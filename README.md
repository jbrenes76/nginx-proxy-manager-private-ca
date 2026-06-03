# Nginx Proxy Manager Private CA

Nginx Proxy Manager Private CA enables Nginx Proxy Manager to obtain and renew TLS certificates from private certificate authorities.

## Why

Nginx Proxy Manager works extremely well with public certificate authorities such as Let's Encrypt.

However, many HomeLab and private infrastructure environments use internal DNS names and private certificate authorities that are not publicly reachable.

This project provides a lightweight extension to Nginx Proxy Manager that allows it to use private ACME-compatible certificate authorities while preserving the familiar NPM user experience.

## Features

- Private certificate authority support
- ACME-compatible certificate enrollment
- Automatic certificate renewal
- Internal HTTPS for HomeLab services
- Trusted certificates for private DNS names
- Tested with Smallstep StepCA

## Use Cases

- Proxmox
- Portainer
- TrueNAS
- Home Assistant
- Internal web applications
- Air-gapped environments

## Status

Experimental

Tested successfully with:

- Nginx Proxy Manager
- Smallstep StepCA
- Internal DNS
- Private certificate chains

## Project Goal

Make trusted HTTPS inside a HomeLab as easy as Let's Encrypt makes HTTPS on the public Internet.
