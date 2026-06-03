# Installation

## Assumptions

This project assumes you already have a private certificate authority with an ACME-compatible endpoint.

Examples include:

- Smallstep StepCA
- Vault PKI with ACME enabled
- An internal corporate ACME-compatible CA

This project does not create your certificate authority.

Its purpose is to help Nginx Proxy Manager request certificates from your existing private CA.

## Requirements

- Docker
- Docker Compose
- Nginx Proxy Manager Private CA image
- A private ACME server URL
- Local DNS records pointing to your NPM server
- Root CA installed on client devices

## Required Environment Variables

```yaml
ACME_SERVER=https://ca.example.internal/acme/acme/directory
```

Optional:

```yaml
ACME_EAB_KID=
ACME_EAB_HMAC_KEY=
ACME_WEBROOT=/data/letsencrypt-acme-challenge
```

## Required Volume

Mount your private CA certificates into the container trust store:

```yaml
- ./ca-certs:/usr/local/share/ca-certificates:ro
```

## Example

```yaml
services:
  npm:
    image: yourname/nginx-proxy-manager-private-ca:latest
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    environment:
      - ACME_SERVER=https://ca.example.internal/acme/acme/directory
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
      - ./ca-certs:/usr/local/share/ca-certificates:ro
```
