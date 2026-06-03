#!/command/with-contenv sh
set -eu

echo "[80-private-ca] Running private CA prepare step..."

echo "[80-private-ca] Updating CA certificates..."
update-ca-certificates

ACME_WEBROOT="${ACME_WEBROOT:-/data/letsencrypt-acme-challenge}"
mkdir -p "${ACME_WEBROOT}/.well-known/acme-challenge"

if [ -n "${ACME_SERVER:-}" ]; then
  echo "[80-private-ca] Creating /etc/letsencrypt.ini"

  printf 'server = %s\n' "${ACME_SERVER}" > /etc/letsencrypt.ini
  printf 'webroot-path = %s\n' "${ACME_WEBROOT}" >> /etc/letsencrypt.ini

  if [ -n "${ACME_EAB_KID:-}" ] && [ -n "${ACME_EAB_HMAC_KEY:-}" ]; then
    printf 'eab-kid = %s\n' "${ACME_EAB_KID}" >> /etc/letsencrypt.ini
    printf 'eab-hmac-key = %s\n' "${ACME_EAB_HMAC_KEY}" >> /etc/letsencrypt.ini
    echo "[80-private-ca] EAB credentials written"
  fi

  chmod 600 /etc/letsencrypt.ini
  echo "[80-private-ca] /etc/letsencrypt.ini created"
else
  echo "[80-private-ca] ACME_SERVER not set, skipping letsencrypt.ini creation"
fi

echo "[80-private-ca] Private CA prepare step completed."