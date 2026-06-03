# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added

- MIT license
- Quick start section in README
- README badges for build status, GHCR image, license, and NPM version

### Changed

- Pin upstream image to `jc21/nginx-proxy-manager:2.15.0`
- Expand `.gitattributes` to enforce LF line endings on `*.yml`, `*.yaml`, `Dockerfile`, `*.md`, `*.ini`, `*.env`

### Fixed

- EAB credentials (`eab-kid`, `eab-hmac-key`) are now only written to `letsencrypt.ini` when both values are set
- CRLF line endings removed from all tracked files

---

## [v0.1.1] - 2026-06-03

### Added

- `docs/installation.md` — full step-by-step installation guide
- `docs/troubleshooting.md` — common issues and fixes
- `docs/architecture.md` — component overview and certificate flow
- `examples/docker-compose.ghcr.yml` — compose file using the pre-built GHCR image
- GitHub Actions workflow to build and publish to GHCR on push and tags

### Changed

- Expanded example `docker-compose.stepca.yml` with inline comments and folder layout

---

## [v0.1.0] - 2026-06-03

### Added

- Initial release
- `docker/Dockerfile` — extends `jc21/nginx-proxy-manager` with private CA support
- `docker/80-private-ca.sh` — startup script that injects ACME server config into Certbot
- `examples/docker-compose.stepca.yml` — example stack for use with Smallstep StepCA
- Support for `ACME_SERVER`, `ACME_EAB_KID`, `ACME_EAB_HMAC_KEY`, `ACME_WEBROOT` environment variables
- CA certificate trust via volume mount at `/usr/local/share/ca-certificates`
