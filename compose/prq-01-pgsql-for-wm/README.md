# Prerequisite 01 - Postgres Database for webMethods

This project contains an example of how to create a containerized Postgres database for use with webMethods. It is useful for various landscapes, therefore is has been made a separate building block.

webMethods databases MUST be managed at DDL (Data Definition Language) level using the product tool DBC (Database Configuration). This example assumes the image for DBC has been built previously. See the following references:

- [DBC 11.01 Full Container Builder](https://github.com/ibm-webmethods-continuous-delivery/2l-unattended-installation-templates/tree/v0.0.4/05-container-image-builders-test/dbc/1101/full/local-build-1)
