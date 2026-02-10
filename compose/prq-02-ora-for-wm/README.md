# Prerequisite 02 - Example of Oracle Database for webMethods

This project contains an example of how to create a containerized Oracle database for use with webMethods. It is useful for various landscapes, therefore is has been made a separate building block. It is also designed to be easily merged in other landscape examples as a supporting database.

webMethods databases MUST be managed at DDL (Data Definition Language) level using the product tool DBC (Database Configuration). This example assumes the image for DBC has been built previously. See the following references:

- [DBC 11.01 Full Container Builder](https://github.com/ibm-webmethods-continuous-delivery/2l-unattended-installation-templates/tree/v0.0.5/05-container-image-builders-test/dbc/1101/full/local-build-1)

## Notes

As opposed to the Postgres prerequisite example, this example uses at least an undocumented forcing point, due to the operational complexity of working with Oracle Databases, which are designed to be multi-tenant by the means of pluggable databases.

In this case, the example uses undocumented settings and is not guaranteed or expected to work with any version and in any case. Furthermore, the example uses the `FREE` service ID, which seems to stand for the central database service. Trials to use `FREEPDB1` pluggable database failed, and we are not aware at this point in time how to resolve this issue. In real production environments users should use pluggable databases. Refer to an Oracle specialized database administrator or engineer.
