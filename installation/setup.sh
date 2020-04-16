#!/bin/bash

# Author: Chris Yang

PWD=`pwd`
JAVA=`which java`
PROJECT_ID=$(gcloud config get-value project)
# Google Service Account ID
GSA_ID=cnrm-sys-owner-02


__usage() {
    echo "Usage: ./setup.sh {cgsa|cgke|ikcc|all}"
    echo $PROJECT_ID
    echo $GSA_ID
}

__create_gsa() {
    gcloud iam service-accounts create $GSA_ID
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member serviceAccount:$GSA_ID@chris-demo-258505.iam.gserviceaccount.com \
        --role roles/owner
    gcloud iam service-accounts add-iam-policy-binding \
        $GSA_ID@$PROJECT_ID.iam.gserviceaccount.com \
        --member="serviceAccount:$PROJECT_ID.svc.id.goog[cnrm-system/cnrm-controller-manager]" \
        --role="roles/iam.workloadIdentityUser"
}

__config_gke() {
    gcloud iam service-accounts keys create --iam-account \
        $GSA_ID@$PROJECT_ID.iam.gserviceaccount.com key.json
    kubectl create namespace cnrm-system
    kubectl create secret generic gcp-key --from-file key.json --namespace cnrm-system
    rm key.json
    kubectl annotate namespace default cnrm.cloud.google.com/project-id=chris-demo-258505
}

__install_kcc() {
    kubectl apply -f install-bundle-gcp-identity/crds.yaml
    kubectl apply -f install-bundle-gcp-identity/0-cnrm-system.yaml
}

__main() {
    if [ $# -eq 0 ]
    then
        __usage
    else
        case $1 in
            cgsa)
                __create_gsa
                ;;
            cgke)
                __config_gke
                ;;
            ikcc)
                __install_kcc
                ;;
            all)
                __create_gsa
                __config_gke
                __install_kcc
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@

exit 0