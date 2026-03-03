# Example 04 - webMethods Managed File Transfer (MFT)

This project contains an example of how to spin a webMethods MFT server on Postgres using the provided MFT images from containers.webmethods.io, along with comprehensive FTP/FTPS/SFTP test doubles for protocol validation.

## Architecture

This landscape includes:

1. **Database Layer**
   - PostgreSQL database with two separate databases (product + archiving)
   - Adminer for database administration

2. **MFT Application**
   - webMethods Active Transfer 11.1 server
   - Database creation via `ibmwebmethods.azurecr.io/webmethods-activetransfer-dcc:11.1`
   - Runtime via `ibmwebmethods.azurecr.io/webmethods-activetransfer:11.1`

3. **Test Infrastructure**
   - **cert-manager**: Automated certificate and SSH key generation
   - **ft-test-double**: ProFTPD-based FTP/FTPS/SFTP server with classical TLS
   - **ft-test-client**: Automated test harness for protocol validation

### Certificate Management

The landscape now includes automated certificate management:

- **Root CA**: Self-signed certificate authority for test environment
- **Server Certificates**: TLS certificates for FTPS, signed by Root CA
- **Client SSH Keys**: RSA and ED25519 key pairs for SFTP authentication
- **Automated Generation**: All certificates and keys are generated at startup

Certificate artifacts are stored in `./data/subjects/01-ft-test/` and are automatically regenerated on each startup for consistency.

## Prerequisites

### Required Images

Build the following images before starting:

```powershell
# Build cert-manager (S → T → U tiers)
cd ...\iwcd\7u-container-images\images\s\alpine\cert-manager
.\build-local.bat
cd ..\..\..\t\alpine\cert-manager
.\build-local.bat
cd ..\..\..\u\alpine\cert-manager
.\build-local.bat

# Build ft-test-double (S → T → U tiers)
cd ...\iwcd\7u-container-images\images\s\alpine\ft-test-double
.\build-local.bat
cd ..\..\..\t\alpine\ft-test-double
.\build-local.bat
cd ..\..\..\u\alpine\ft-test-double
.\build-local.bat

# Build ft-test-client (S → T → U tiers)
cd ...\iwcd\7u-container-images\images\s\alpine\ft-test-client
.\build-local.bat
cd ..\..\..\t\alpine\ft-test-client
.\build-local.bat
cd ..\..\..\u\alpine\ft-test-client
.\build-local.bat
```

## Quick Start

### 1. Configure Environment

Copy the example environment file and adjust as needed:

```powershell
cd ...\iwcd\1c-landscapes-examples\compose\ex04-mft
Copy-Item EXAMPLE.env .env
```

Key configuration variables:
- `EX04_PORT_PREFIX`: Port prefix for all exposed services (default: 404)
- `EX04_TEST_PK_SECRET`: Passphrase for certificate encryption (default: TestOnly123)
- Database credentials and MFT image references

### 2. Initialize Database

First time setup requires database initialization:

```powershell
.\db-init.bat
```

This will:
- Start PostgreSQL
- Create the webMethods and archive databases
- Set up database users and permissions

### 3. Start All Services

```powershell
docker compose up -d
```

This will start:
1. **cert-manager** - Generates certificates and keys (runs first)
2. **db** - PostgreSQL database
3. **adminer** - Database admin UI
4. **mft** - webMethods Active Transfer server
5. **ft-test-double** - FTP/FTPS/SFTP test server
6. **ft-test-client** - Test automation client

### 4. Verify Services

Check service health:

```powershell
docker compose ps
```

All services should show "healthy" status.

### 5. Access Services

From your host machine:

- **MFT Admin UI**: http://localhost:40455
- **Adminer (DB)**: http://localhost:40480
- **FTP**: ftp://localhost:40421
- **SFTP**: sftp://localhost:40422 (port 40422)
- **FTPS**: ftps://localhost:40490

## Testing File Transfer Protocols

### Manual Testing

Test FTP connectivity:
```powershell
# Using curl
curl -u ftuser01:Manage01 ftp://localhost:40421/

# Using Windows FTP client
ftp localhost 40421
# Username: ftuser01
# Password: Manage01
```

Test SFTP connectivity:
```powershell
# Using sftp (requires OpenSSH or similar)
sftp -P 40422 ftuser01@localhost
# Password: Manage01
```

### Automated Testing

Run the automated test suite:

```powershell
# Execute all test scenarios
docker exec ex04-ft-test-client /opt/ft-test-client/scripts/run-scenarios.sh

# View test results
docker exec ex04-ft-test-client cat /results/test-summary.txt
```

The test suite validates:
- FTP plain text transfers
- FTPS explicit TLS (STARTTLS)
- FTPS implicit TLS
- SFTP with password authentication
- SFTP with key-based authentication (RSA and ED25519)

## Certificate and Key Management

### Certificate Structure

```
./data/subjects/01-ft-test/
├── 01-ca-ft-test/              # Root CA
│   ├── set-env.sh              # CA configuration
│   └── out/                    # Generated CA artifacts
│       └── rsa/
├── 02-ft-server/               # Server certificate
│   ├── set-env.sh              # Server cert configuration
│   ├── csr.config              # CSR configuration
│   ├── cert-gen.config         # Certificate generation config
│   └── out/                    # Generated server cert + key
│       ├── rsa/                # RSA certificate and encrypted key
│       └── ed25519/            # ED25519 certificate and key
└── 03-ft-client-keys/          # Client SSH keys (generated at runtime)
    ├── rsa/                    # RSA key pair for SFTP
    │   ├── id_client           # Private key
    │   └── id_client.pub       # Public key
    └── ed25519/                # ED25519 key pair for SFTP
        ├── id_client           # Private key
        └── id_client.pub       # Public key
```

### Regenerating Certificates

To force certificate regeneration:

```powershell
# Stop services
docker compose down -v

# Remove generated certificates
Remove-Item -Recurse -Force .\data\subjects\01-ft-test\01-ca-ft-test\out
Remove-Item -Recurse -Force .\data\subjects\01-ft-test\02-ft-server\out
Remove-Item -Recurse -Force .\data\subjects\01-ft-test\03-ft-client-keys\rsa
Remove-Item -Recurse -Force .\data\subjects\01-ft-test\03-ft-client-keys\ed25519

# Restart services (certificates will be regenerated)
docker compose up -d
```

### Security Notes

⚠️ **FOR TESTING ONLY**

- Passwords are hardcoded in configuration files
- Private key passphrase (`EX04_TEST_PK_SECRET`) is exposed in environment variables
- Self-signed certificates are used
- TLS certificate validation is disabled on the client side

**DO NOT use this configuration in production environments.**

## Maintenance

### View Logs

```powershell
# All services
docker compose logs -f

# Specific service
docker compose logs -f mft
docker compose logs -f ft-test-double
docker compose logs -f cert-manager
```

### Database Management

Access database via Adminer:
- URL: http://localhost:40480
- System: PostgreSQL
- Server: db
- Username: postgres
- Password: (from .env file)

### Cleanup

Stop and remove all services:

```powershell
docker compose down
```

Stop and remove all services including volumes:

```powershell
docker compose down -v
```

## Troubleshooting

### Certificate Manager Fails

Check cert-manager logs:
```powershell
docker compose logs cert-manager
```

Verify TEST_PK_SECRET is set in .env file.

### Test Double Fails to Start

Check if certificates were generated:
```powershell
docker compose exec cert-manager ls -la /mnt/data/certmgr/01-ft-test/02-ft-server/out/rsa/
```

Check test double logs:
```powershell
docker compose logs ft-test-double
```

### Connection Refused

Verify services are running and healthy:
```powershell
docker compose ps
```

Check port mappings match your EX04_PORT_PREFIX setting.

### MFT Fails to Start

Check database is initialized:
```powershell
.\db-init.bat
```

Verify database credentials in .env file.

## Advanced Topics

### Post-Quantum Cryptography

The test infrastructure is designed to support post-quantum cryptography. A future enhancement will add a second test double variant (`ft-test-double-pq-hybrid`) using:

- **Key Exchange**: x25519_kyber768 (Classical + ML-KEM-768)
- **Authentication**: RSA, ECDSA, ED25519
- **Provider**: Open Quantum Safe (OQS)

### MFT Integration Testing

Future enhancements will include:
- Test scenarios that exercise MFT's file transfer capabilities
- Integration tests between ft-test-client and MFT service
- Performance benchmarking

## References

- [IWCD Framework](../../../../../README.md)
- [Container Images Repository](../../../../7u-container-images/README.md)
- [Test Doubles Documentation](./README-TEST-DOUBLES.md)
- [01-ft-example Test Harness](../../../../7u-container-images/test/01-ft-example/README.md)

## License

Copyright IBM Corp. 2026 - 2026
SPDX-License-Identifier: Apache-2.0