# Architecture

## Goal

Allow Nginx Proxy Manager to obtain certificates from private certificate authorities.

## Components

### Root Certificate Authority

The ultimate trust anchor.

Examples:

- Internal Root CA
- Corporate Root CA
- HomeLab Root CA

### Issuing Certificate Authority

Issues certificates on behalf of the Root CA.

Examples:

- Internal Issuing CA
- Intermediate CA

### ACME Certificate Authority Service

Provides an ACME-compatible certificate enrollment service.

Examples:

- Smallstep StepCA
- Vault PKI
- Other ACME-compatible certificate authorities

### Nginx Proxy Manager

Requests certificates through ACME and manages reverse proxy hosts.

### Client Devices

Browsers and operating systems that trust the Root CA.

## Certificate Flow

Client Browser
↓
Nginx Proxy Manager
↓ ACME
ACME Certificate Authority Service
↓
Issuing Certificate Authority
↓
Root Certificate Authority

## Result

Trusted HTTPS certificates for internal services without requiring public DNS or Internet access.
