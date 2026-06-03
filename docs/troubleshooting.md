# Troubleshooting

This document lists common issues when using Nginx Proxy Manager with a private ACME-compatible certificate authority.

The examples use:

```text
nginx.home.arpa
```

Replace this with your own internal hostname.

---

## Certificate request fails with “certificate verify failed”

### Symptom

Nginx Proxy Manager shows an internal error when requesting a certificate.

The logs show something like:

```text
certificate verify failed: unable to get local issuer certificate
```

### Cause

The Nginx Proxy Manager container does not trust the certificate presented by the private ACME server.

This usually means the required CA certificates were not mounted into the container.

### Fix

Place the CA certificates required to trust your private ACME server in:

```text
examples/ca-certs/
```

Typical files:

```text
root-ca.crt
intermediate-ca.crt
```

Do not place private keys in this directory.

Then restart the stack:

```bash
docker compose -p npm-private-ca-test -f docker-compose.stepca.yml down
docker compose -p npm-private-ca-test -f docker-compose.stepca.yml up -d --build
```

Verify that the container can reach the ACME directory without using `-k`:

```bash
docker exec -it npm-private-ca curl https://ca.example.internal/acme/acme/directory
```

If this works, the container trusts the ACME server.

---

## Certificate request hangs or never completes

### Symptom

Nginx Proxy Manager appears to hang while requesting a certificate.

### Cause

The hostname being requested may not resolve to the Nginx Proxy Manager server.

ACME HTTP validation requires the requested hostname to point to Nginx Proxy Manager.

### Fix

Verify DNS:

```bash
ping nginx.home.arpa
```

The hostname should resolve to the IP address of the Nginx Proxy Manager server.

Correct flow:

```text
Browser
  ↓
nginx.home.arpa
  ↓
Nginx Proxy Manager
  ↓
Backend service
```

Do not point the hostname directly to the backend service.

---

## 502 Bad Gateway

### Symptom

The certificate is valid and the browser shows HTTPS, but the page displays:

```text
502 Bad Gateway
```

### Cause

The HTTPS certificate is working, but Nginx Proxy Manager cannot reach the backend service.

This is a proxy/backend configuration issue, not a certificate issue.

### Fix

Check the proxy host settings:

```text
Domain Name: nginx.home.arpa
Scheme: HTTP
Forward Hostname/IP: backend service IP
Forward Port: backend service port
Force SSL: Enabled
```

Most internal services should use:

```text
Scheme: HTTP
```

even when the browser connects using HTTPS.

The usual flow is:

```text
Browser
  ↓ HTTPS
Nginx Proxy Manager
  ↓ HTTP
Backend service
```

Use `HTTPS` as the backend scheme only if the backend service itself is actually serving HTTPS on that port.

---

## ACME server URL is configured but certificates are not issued

### Symptom

The container starts, but certificate requests still fail.

### Checks

Verify that `/etc/letsencrypt.ini` contains the private ACME server:

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

If `server =` is missing, the private CA startup script did not run or `ACME_SERVER` was not set.

---

## Private CA startup script is present but does not run

### Symptom

The file exists inside the container:

```text
/etc/s6-overlay/s6-rc.d/prepare/80-private-ca.sh
```

but `/etc/letsencrypt.ini` is not updated.

### Cause

Nginx Proxy Manager uses a startup script called:

```text
/etc/s6-overlay/s6-rc.d/prepare/00-all.sh
```

That script controls which prepare scripts are executed.

Simply copying a new script into the directory is not enough.

### Fix

The Dockerfile must patch `00-all.sh` so it executes:

```text
80-private-ca.sh
```

Verify the script ran:

```bash
docker logs npm-private-ca | grep 80-private-ca
```

Expected:

```text
[80-private-ca] Running private CA prepare step...
[80-private-ca] Creating /etc/letsencrypt.ini
[80-private-ca] /etc/letsencrypt.ini created
```

---

## ACME webroot error

### Symptom

Certbot fails with a message similar to:

```text
Input the webroot for domain
```

### Cause

Certbot is using the webroot authenticator, but no `webroot-path` was configured.

### Fix

Verify that `/etc/letsencrypt.ini` includes:

```ini
webroot-path = /data/letsencrypt-acme-challenge
```

This project writes that value automatically during container startup.

---

## Certificate is issued but browser does not trust it

### Symptom

Nginx Proxy Manager successfully creates the certificate, but the browser does not show a trusted HTTPS connection.

### Cause

The client device does not trust the private Root CA.

### Fix

Install the Root CA certificate on the client device.

On Windows, install it under:

```text
Trusted Root Certification Authorities
```

If your environment uses an intermediate CA, install that certificate under:

```text
Intermediate Certification Authorities
```

---

## Certificate has no Common Name

### Symptom

The certificate details show:

```text
Common Name: Not Part Of Certificate
```

### Cause

Modern certificates may rely on the Subject Alternative Name field instead of the Common Name field.

### Fix

Verify that the requested hostname appears in the SAN field:

```bash
openssl x509 -in fullchain.pem -text -noout | grep -A2 "Subject Alternative Name"
```

Expected:

```text
DNS:nginx.home.arpa
```

If the SAN is correct and the certificate chain is trusted, this is not a problem.

---

## Quick validation checklist

Use this checklist after installation:

- The container starts successfully.
- `/etc/letsencrypt.ini` contains the private ACME server.
- The container can `curl` the ACME directory without `-k`.
- The requested hostname resolves to Nginx Proxy Manager.
- The proxy host backend IP and port are correct.
- The backend scheme is correct, usually `HTTP`.
- Certificate issuance succeeds.
- Browser shows a trusted HTTPS connection.
- The proxied service loads without `502 Bad Gateway`.
