# Example 04 - webMethods Managed File Transfer (MFT)

This project contains an example of how to spin a simple webMethods MFT server on Postgres using the provided MFT images from containers.webmethods.io.

This example uses a Postgres database service with two separate databases: one for the product and one for archiving.

The database creation image is the one provided officially with MFT by means of the container image `ibmwebmethods.azurecr.io/webmethods-activetransfer-dcc:11.1`.

The server uses the provided container image `ibmwebmethods.azurecr.io/webmethods-activetransfer:11.1`.


## Quick Start

First initialize the database with