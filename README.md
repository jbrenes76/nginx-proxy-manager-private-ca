# Nginx Proxy Manager Private CA

[![Docker Build](https://github.com/jbrenes76/nginx-proxy-manager-private-ca/actions/workflows/docker-build.yml/badge.svg)](https://github.com/jbrenes76/nginx-proxy-manager-private-ca/actions/workflows/docker-build.yml)
[![GitHub Container Registry](https://img.shields.io/badge/ghcr.io-jbrenes76%2Fnginx--proxy--manager--private--ca-blue?logo=docker)](https://github.com/jbrenes76/nginx-proxy-manager-private-ca/pkgs/container/nginx-proxy-manager-private-ca)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![NPM Version](https://img.shields.io/badge/NPM-2.15.0-orange)](https://github.com/NginxProxyManager/nginx-proxy-manager/releases/tag/v2.15.0)

Use Nginx Proxy Manager with private certificate authorities.

## The Problem

Nginx Proxy Manager works great with Let's Encrypt.

However, many HomeLabs use private DNS names and private certificate authorities.

Examples:

- proxmox.home.arpa
- portainer.home.arpa
- truenas.home.arpa

These services often need trusted HTTPS certificates without relying on public DNS or Internet access.

## The Solution

This project adds support for private certificate authorities to Nginx Proxy Manager.

Instead of using only Let's Encrypt, Nginx Proxy Manager can request certificates from a private ACME-compatible certificate authority.

## Quick Start

### Prerequisites

- Docker and Docker Compose
- A private ACME-compatible CA (e.g. [Smallstep StepCA](https://smallstep.com/docs/step-ca))
- Internal DNS records pointing to your Nginx Proxy Manager server
- Root CA certificate installed on your client devices

### 1. Clone the repository

```bash
git clone https://github.com/jbrenes76/nginx-proxy-manager-private-ca.git
cd nginx-proxy-manager-private-ca
```

### 2. Add your CA certificates

Place the certificates needed to trust your private ACME server in:

```
examples/ca-certs/
```

Typical files:

```
root-ca.crt
intermediate-ca.crt
```

Do not place private keys here.

### 3. Configure your ACME server

Edit `examples/docker-compose.stepca.yml` and set your ACME directory URL:

```yaml
environment:
  - ACME_SERVER=https://ca.home.arpa:9000/acme/acme/directory
```

If your CA uses External Account Binding, also set:

```yaml
- ACME_EAB_KID=your-kid
- ACME_EAB_HMAC_KEY=your-hmac-key
```

### 4. Start Nginx Proxy Manager

```bash
cd examples
docker compose -f docker-compose.stepca.yml up -d --build
```

### 5. Verify

Check that the ACME server was configured correctly:

```bash
docker exec -it npm-private-ca cat /etc/letsencrypt.ini
```

Check that the container trusts your ACME server:

```bash
docker exec -it npm-private-ca curl https://ca.home.arpa:9000/acme/acme/directory
```

### 6. Request a certificate

Open Nginx Proxy Manager at `http://YOUR-SERVER-IP:81`, create a proxy host, and request a new SSL certificate. The certificate will be issued by your private CA.

For full installation details and troubleshooting, see the [docs](docs/) folder.

## Tested With

- Smallstep StepCA
- Nginx Proxy Manager
- Internal DNS
- Windows trusted certificate store

## Goal

Make internal HTTPS as easy as public HTTPS.

## Status

Work in progress.

## License

MIT — see [LICENSE](LICENSE).
