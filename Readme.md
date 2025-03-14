# Certificate Verification Smart Contract

This repository contains a Solidity smart contract designed for certificate verification. The contract allows users to issue, verify, and revoke certificates on the Ethereum blockchain. It is a decentralized solution for ensuring the authenticity of certificates, making it suitable for educational institutions, certification bodies, and other organizations that need to issue and verify credentials.

## Features

- **Issue Certificates**: Authorized issuers can issue certificates to recipients.
- **Verify Certificates**: Anyone can verify the authenticity of a certificate by checking its details on the blockchain.
- **Revoke Certificates**: Issuers can revoke certificates if they are no longer valid.
- **Immutable Record**: Once a certificate is issued, its details are stored on the blockchain, ensuring tamper-proof records.
- **Access Control**: Only authorized issuers can issue or revoke certificates.

## Smart Contract Details

### Contract: `CertificateVerification`

#### State Variables

- `issuer`: The address of the entity authorized to issue and revoke certificates.
- `certificates`: A mapping that stores certificate details using a unique `certificateId`.
- `revokedCertificates`: A mapping to track revoked certificates.

#### Functions

1. **`issueCertificate`**
   - **Description**: Allows the issuer to issue a new certificate.
   - **Parameters**:
     - `certificateId`: A unique identifier for the certificate.
     - `recipientName`: The name of the certificate recipient.
     - `courseName`: The name of the course or program.
     - `dateOfIssuance`: The date the certificate was issued.
   - **Emits**: `CertificateIssued` event.

2. **`verifyCertificate`**
   - **Description**: Allows anyone to verify the authenticity of a certificate.
   - **Parameters**:
     - `certificateId`: The unique identifier of the certificate.
   - **Returns**: A tuple containing the certificate details (recipientName, courseName, dateOfIssuance, isRevoked).

3. **`revokeCertificate`**
   - **Description**: Allows the issuer to revoke a certificate.
   - **Parameters**:
     - `certificateId`: The unique identifier of the certificate.
   - **Emits**: `CertificateRevoked` event.

#### Events

- `CertificateIssued`: Emitted when a new certificate is issued.
- `CertificateRevoked`: Emitted when a certificate is revoked.

### Example Usage

#### Issuing a Certificate

```solidity
// Only the issuer can call this function
issueCertificate(1, "Alice", "Blockchain Basics", "2023-10-01");
```

#### Verifying a Certificate

```solidity
// Anyone can call this function
(bool exists, string memory recipientName, string memory courseName, string memory dateOfIssuance, bool isRevoked) = verifyCertificate(1);
```

#### Revoking a Certificate

```solidity
// Only the issuer can call this function
revokeCertificate(1);
```

