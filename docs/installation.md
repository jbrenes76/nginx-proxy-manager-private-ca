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
- CA certificates required to trust the private ACME server available for the NPM container

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

## CA Certificates

The Nginx Proxy Manager container must trust the certificate presented by your private ACME server.

Place the CA certificates required to trust your private ACME server in the directory mounted to:

```yaml
/usr/local/share/ca-certificates
```

Typical files include:

```text
root-ca.crt
intermediate-ca.crt
```

The container automatically imports these certificates during startup.

Do not place private keys in this directory.
