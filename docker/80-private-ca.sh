#!/command/with-contenv sh
set -eu

echo "[80-private-ca] Running private CA prepare step..."

echo "[80-private-ca] Updating CA certificates..."
update-ca-certificates

ACME_WEBROOT="${ACME_WEBROOT:-/data/letsencrypt-acme-challenge}"
mkdir -p "${ACME_WEBROOT}/.well-known/acme-challenge"

if [ -n "${ACME_SERVER:-}" ]; then
  echo "[80-private-ca] Creating /etc/letsencrypt.ini"

  cat > /etc/letsencrypt.ini <<EOF
server = ${ACME_SERVER}
eab-kid = ${ACME_EAB_KID:-}
eab-hmac-key = ${ACME_EAB_HMAC_KEY:-}
webroot-path = ${ACME_WEBROOT}
EOF

  chmod 600 /etc/letsencrypt.ini
  echo "[80-private-ca] /etc/letsencrypt.ini created"
else
  echo "[80-private-ca] ACME_SERVER not set, skipping letsencrypt.ini creation"
fi

echo "[80-private-ca] Private CA prepare step completed."