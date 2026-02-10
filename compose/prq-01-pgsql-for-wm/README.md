# Prerequisite 01 - Postgres Database for webMethods

This project contains an example of how to create a containerized Postgres database for use with webMethods. It is useful for various landscapes, therefore is has been made a separate building block. It is also designed to be easily merged in other landscape examples as a supporting database.

webMethods databases MUST be managed at DDL (Data Definition Language) level using the product tool DBC (Database Configuration). This example assumes the image for DBC has been built previously. See the following references:

- [DBC 11.01 Full Container Builder](https://github.com/ibm-webmethods-continuous-delivery/2l-unattended-installation-templates/tree/v0.0.4/05-container-image-builders-test/dbc/1101/full/local-build-1)

## Supported Components

```sh
$ ./dbConfigurator.sh -pc

user log: ../logs/dcc.log
developer log: ../logs/log-20260210141024.txt
dcc version: 11.1.0.0000-0026

Supported components:
        All
        APIGatewayEvents (AGW)
        ActiveTransfer (ACT)
        ActiveTransferArchive (ATA)
        Analysis (ANL)
        Archive (ARC)
        BusinessRules (RUL)
        CentralConfiguration (CCS)
        CloudStreamsEventNotification (CLSN)
        CloudStreamsEvents (CLS)
        CommonDirectoryServices (CDS)
        ComponentTracker (CTR)
        CrossReference (XRF)
        DataPurge (DTP)
        DatabaseManagement (DBM)
        DistributedLocking (DSL)
        DocumentHistory (IDR)
        ISCoreAudit (ISC)
        ISInternal (ISI)
        MywebMethodsServer (MWS)
        OperationManagement (OPM)
        ProcessAudit (PRA)
        ProcessEngine (PRE)
        ProcessTracker (PTR)
        Reporting (PRP)
        SAPAdapterTransactionStore (SAPTS)
        Staging (PST)
        Storage (STR)
        TaskArchive (WTA)
        TaskEngine (WTN)
        TradingNetworks (TNS)
        TradingNetworksArchive (TNA)
```