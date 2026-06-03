# Installation

## Assumptions

This project assumes you already have a private certificate authority with an ACME-compatible endpoint.

Examples include:

- Smallstep StepCA
- Vault PKI with ACME enabled
- An internal corporate ACME-compatible CA

This project does **not** create your certificate authority.

Its purpose is to help Nginx Proxy Manager request certificates from your existing private CA.

## Dependencies

You need:

- Docker
- Docker Compose
- A private ACME server URL
- Local DNS records pointing to your Nginx Proxy Manager server
- Root CA installed on client devices
- CA certificates required to trust the private ACME server
- This repository cloned locally

## 1. Clone the repository

```bash
git clone https://github.com/jbrenes76/nginx-proxy-manager-private-ca.git
cd nginx-proxy-manager-private-ca
```

## 2. Add your CA certificates

The Nginx Proxy Manager container must trust the certificate presented by your private ACME server.

Place the CA certificates required to trust your private ACME server in:

```text
examples/ca-certs/
```

Typical files:

```text
root-ca.crt
intermediate-ca.crt
```

**Do not place private keys in this directory.**

These files are mounted into the container at:

```text
/usr/local/share/ca-certificates
```

The container imports them during startup.

## 3. Configure the ACME server

Edit:

```text
examples/docker-compose.stepca.yml
```

Set your private ACME directory URL:

```yaml
environment:
  - ACME_SERVER=https://ca.example.internal/acme/acme/directory
```

Optional values:

```yaml
- ACME_EAB_KID=
- ACME_EAB_HMAC_KEY=
- ACME_WEBROOT=/data/letsencrypt-acme-challenge
```

Most basic StepCA setups do not require EAB values.

## 4. Start Nginx Proxy Manager

From the `examples` directory:

```bash
cd examples
docker compose -p npm-private-ca-test -f docker-compose.stepca.yml up -d --build
```

This builds the local image and starts Nginx Proxy Manager.

## 5. Validate the container configuration

Check that the private ACME server was written into Certbot configuration:

```bash
docker exec -it npm-private-ca cat /etc/letsencrypt.ini
```

Expected:

```ini
server = https://ca.example.internal/acme/acme/directory
eab-kid =
eab-hmac-key =
webroot-path = /data/letsencrypt-acme-challenge
```

Check that the container trusts the ACME server:

```bash
docker exec -it npm-private-ca curl https://ca.example.internal/acme/acme/directory
```

This should return an ACME directory response containing values such as:

```text
newNonce
newAccount
newOrder
revokeCert
keyChange
```

## 6. Configure DNS

Create a local DNS record for the service you want to proxy.

Example:

```text
nginx.home.arpa -> IP address of the Nginx Proxy Manager server
```

The hostname must point to Nginx Proxy Manager, not directly to the backend service.

## 7. Request a certificate in Nginx Proxy Manager

Open Nginx Proxy Manager:

```text
http://NPM-SERVER-IP:81
```

Create a proxy host and request a new certificate.

Example proxy host:

```text
Domain Name: nginx.home.arpa
Scheme: HTTP
Forward Hostname/IP: backend service IP
Forward Port: backend service port
Force SSL: Enabled
```

Most internal services should use `HTTP` as the backend scheme. Nginx Proxy Manager presents HTTPS to the browser and forwards traffic to the backend service.

## 8. Validate HTTPS

Open:

```text
https://nginx.home.arpa
```

Expected result:

- Browser shows a trusted HTTPS connection
- Certificate is issued by your private CA
- Backend service loads through Nginx Proxy Manager

## Stop the test stack

To stop the example stack:

```bash
docker compose -p npm-private-ca-test -f docker-compose.stepca.yml down
```
