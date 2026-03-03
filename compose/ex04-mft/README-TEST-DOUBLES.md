# MFT Test Doubles Integration

This document describes the test double services integrated into the ex04-mft landscape for testing file transfer protocols.

## Overview

The test doubles provide a complete testing environment for Managed File Transfer (MFT) applications, supporting:

1. **FTP** (File Transfer Protocol) - Plain text on port 21
2. **FTPS** (FTP over TLS) - Encrypted on port 990 with TLS 1.2+ enforcement
3. **SFTP** (SSH File Transfer Protocol) - Encrypted on port 22 with modern algorithms

## Architecture

### Services

#### ft-test-double
- **Image**: `ft-test-double-u:alpine`
- **Container**: `ex04-ft-test-double`
- **IP**: 172.20.0.20
- **Purpose**: Unified FTP/FTPS/SFTP server acting as test double (spy/mock)

**Exposed Ports**:
- `40421:21` - FTP
- `40422:22` - SFTP
- `40490:990` - FTPS
- `40400-40410:21100-21110` - FTP passive mode range

**Features**:
- Runtime key/certificate generation (unique per instance)
- TLS 1.2+ enforcement for FTPS
- Modern SSH algorithms for SFTP (curve25519, aes256-gcm, hmac-sha2-512-etm)
- Network traffic capture via tcpdump/tshark
- Supervisord process management

**Volumes**:
- `ft-data:/home` - User home directories and file storage
- `ft-captures:/var/log/captures` - Network packet captures

#### ft-test-client
- **Image**: `ft-test-client-t:alpine`
- **Container**: `ex04-ft-test-client`
- **IP**: 172.20.0.30
- **Purpose**: Automated test suite for protocol validation

**Features**:
- Automated connectivity tests for FTP, FTPS, SFTP
- Integration tests with MFT service
- Test result reporting

**Volumes**:
- `test-results:/results` - Test execution results

### Network

All services run on isolated network `n1` (172.20.0.0/16):
- `172.20.0.10` - MFT application
- `172.20.0.20` - Test double server
- `172.20.0.30` - Test client

## Usage

### 1. Setup Environment

Copy EXAMPLE.env to .env and configure:

```bash
cp EXAMPLE.env .env
```

Key test double variables:
```bash
EX04_TEST_FTP_USER=ftpuser
EX04_TEST_FTP_PASS=FtpPass123!
EX04_TEST_SFTP_USER=sftpuser
EX04_TEST_SFTP_PASS=SftpPass123!
```

### 2. Start Services

```bash
docker compose up -d
```

### 3. Run Tests

Execute all tests:
```bash
docker exec ex04-ft-test-client /tests/run-all-tests.sh
```

Run individual tests:
```bash
# Test FTP connectivity
docker exec ex04-ft-test-client /tests/test-ftp.sh

# Test FTPS connectivity
docker exec ex04-ft-test-client /tests/test-ftps.sh

# Test SFTP connectivity
docker exec ex04-ft-test-client /tests/test-sftp.sh

# Test MFT integration
docker exec ex04-ft-test-client /tests/test-mft-integration.sh
```

### 4. Access Services

From host machine:
- FTP: `ftp://localhost:40421`
- SFTP: `sftp://localhost:40422`
- FTPS: `ftps://localhost:40490`

Example FTP connection:
```bash
curl -u ftpuser:FtpPass123! ftp://localhost:40421/
```

Example SFTP connection:
```bash
sshpass -p 'SftpPass123!' sftp -P 40422 sftpuser@localhost
```

### 5. Network Traffic Analysis

Access packet captures:
```bash
# List captures
docker exec ex04-ft-test-double ls -lh /var/log/captures/

# Copy capture to host
docker cp ex04-ft-test-double:/var/log/captures/traffic.pcap ./

# Analyze with Wireshark or tshark
tshark -r traffic.pcap
```

### 6. View Logs

Test double logs:
```bash
docker logs ex04-ft-test-double
```

Test client logs:
```bash
docker logs ex04-ft-test-client
```

## Security Features

### FTPS (Port 990)
- TLS 1.2 minimum version enforced
- Strong cipher suites only
- Self-signed certificate (generated at runtime)
- Can be replaced with real certificates via volume mount

### SFTP (Port 22)
- Modern key exchange: curve25519-sha256
- Strong encryption: aes256-gcm@openssh.com
- Strong MAC: hmac-sha2-512-etm@openssh.com
- SSH host keys generated at runtime

### Post-Quantum Readiness
The test double is designed to support post-quantum encryption algorithms when they become available in OpenSSH and OpenSSL. Configuration can be updated without rebuilding images.

## Troubleshooting

### Connection Refused
Check if services are running:
```bash
docker ps | grep ex04-ft
```

Check service health:
```bash
docker inspect ex04-ft-test-double | grep -A 10 Health
```

### Authentication Failures
Verify credentials in .env file match those used in tests.

### Network Issues
Verify network configuration:
```bash
docker network inspect ex04-mft_n1
```

Check container IPs:
```bash
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ex04-ft-test-double
```

## Development

### Rebuilding Images

Test double:
```bash
cd c:\gg\aio\c\iwcd\7u-container-images\images\u\alpine\ft-test-double
.\build-local.bat
```

Test client:
```bash
cd c:\gg\aio\c\iwcd\7u-container-images\images\t\alpine\ft-test-client
.\build-local.bat
```

### Modifying Configuration

Configuration files are in the T-tier images:
- `c/iwcd/7u-container-images/images/t/alpine/ft-test-double/config/`

After changes, rebuild the T-tier and U-tier images.

### Adding Tests

Add new test scripts to:
- `c/iwcd/7u-container-images/images/t/alpine/ft-test-client/tests/`

Update `run-all-tests.sh` to include new tests.

## References

- [IWCD Framework](../../../../../../README.md)
- [Container Images Repository](../../../../../7u-container-images/README.md)
- [Session 01: Design](../../../../../.ai-assist/sessions/2026/02/18/01_MFT_Test_Doubles/final-summary.md)
- [Session 02: Implementation](../../../../../.ai-assist/sessions/2026/02/18/02_MFT_Test_Doubles_Impl/conversation-summary.md)