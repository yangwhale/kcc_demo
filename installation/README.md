# install KCC on GKE steps

* Note: replace [PROJECTID] with your projectid in command line and install-bundle-workload-identity/0-cnrm-system.yaml

Create service account and attach project owner role for KCC connector to operate GCP

```bash
gcloud iam service-accounts create cnrm-system
gcloud projects add-iam-policy-binding [PROJECTID] \
--member serviceAccount:cnrm-system@[PROJECTID].iam.gserviceaccount.com \
--role roles/owner
```

Binding GSA and KSA
```bash
gcloud iam service-accounts add-iam-policy-binding \
cnrm-system@[PROJECTID].iam.gserviceaccount.com \
--member="serviceAccount:[PROJECTID].svc.id.goog[cnrm-system/cnrm-controller-manager]" \
--role="roles/iam.workloadIdentityUser"
```

Insall CRD and create RBAC for KCC
```bash
kubectl apply -f install-bundle-workload-identity/crds.yaml
kubectl apply -f install-bundle-workload-identity/0-cnrm-system.yaml
```
