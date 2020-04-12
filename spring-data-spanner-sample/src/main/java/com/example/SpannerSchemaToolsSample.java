package com.example;

//[START spring_data_spanner_schema_sample]
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gcp.data.spanner.core.admin.SpannerDatabaseAdminTemplate;
import org.springframework.cloud.gcp.data.spanner.core.admin.SpannerSchemaUtils;
import org.springframework.stereotype.Component;
import model.Customer;

/**
 * This sample demonstrates how to generate schemas for interleaved tables from POJOs and how to
 * execute DDL.
 */
@Component
public class SpannerSchemaToolsSample {

    @Autowired
    SpannerDatabaseAdminTemplate spannerDatabaseAdminTemplate;

    @Autowired
    SpannerSchemaUtils spannerSchemaUtils;

    /**
     * Creates the Singers table. Also creates the Albums table, because Albums is interleaved with
     * Singers.
     */
    public void createTableIfNotExists() {
        if (!this.spannerDatabaseAdminTemplate.tableExists("Customer")) {
            this.spannerDatabaseAdminTemplate.executeDdlStrings(
                    this.spannerSchemaUtils
                            .getCreateTableDdlStringsForInterleavedHierarchy(Customer.class),
                    true);
        }
    }

    /**
     * Drops both the Singers and Albums tables using just a reference to the Singer entity type ,
     * because they are interleaved.
     */
    public void dropTables() {
        if (this.spannerDatabaseAdminTemplate.tableExists("Customer")) {
            this.spannerDatabaseAdminTemplate.executeDdlStrings(
                    this.spannerSchemaUtils.getDropTableDdlStringsForInterleavedHierarchy(Customer.class),
                    false);
        }
    }
}
//[END spring_data_spanner_schema_sample]

