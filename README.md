# Nginx Proxy Manager Private CA

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

## Tested With

- Smallstep StepCA
- Nginx Proxy Manager
- Internal DNS
- Windows trusted certificate store

## Goal

Make internal HTTPS as easy as public HTTPS.

## Status

Work in progress.
