# CA Certificates

Place the CA certificates required to trust your private ACME server in this directory.

Examples:

- root-ca.crt
- intermediate-ca.crt

Do not place private keys in this directory.

These certificates are used only so the Nginx Proxy Manager container can trust the ACME server when requesting certificates.

This directory is ignored by Git. Only this README file is committed.
