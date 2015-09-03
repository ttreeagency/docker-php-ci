#!/bin/bash
set -e

[[ -n $DEBUG_ENTRYPOINT ]] && set -x

TTREE_DATA_DIR=${TTREE_DATA_DIR:-/data}

COMPOSER_UPDATE=${COMPOSER_UPDATE:-true}

BOWER_UPDATE=${BOWER_UPDATE:-true}

GULP_UPDATE=${GULP_UPDATE:-true}

FLOW_CONTEXT=${FLOW_CONTEXT:-Production}
export $FLOW_CONTEXT
FLOW_REWRITEURLS=${FLOW_REWRITEURLS:-1}
export FLOW_REWRITEURLS

SSL_CERTIFICATE_PATH=${SSL_CERTIFICATE_PATH:-$TTREE_DATA_DIR/certs/cert.crt}

CA_CERTIFICATES_PATH=${CA_CERTIFICATES_PATH:-$TTREE_DATA_DIR/certs/ca.crt}

appInit () {
  if [ "$COMPOSER_UPDATE" == "true" ]; then
    echo "Update composer ..."
    composer self-update
  fi
  npm cache clean >/dev/null
  if [ "$BOWER_UPDATE" == "true" ]; then
    echo "Update bower ..."
    npm update -g bower
  fi
  if [ "$GULP_UPDATE" == "true" ]; then
    echo "Update gulp ..."
    npm update -g gulp
  fi
  if [ ! -z "$GITHUB_TOKEN" ]; then
    echo "Setup Github oauth token ..."
    composer config -g github-oauth.github.com "${GITHUB_TOKEN}"
  fi

  if [[ -f ${SSL_CERTIFICATE_PATH} || -f ${CA_CERTIFICATES_PATH} ]]; then
    echo "Updating CA certificates..."
    [[ -f ${SSL_CERTIFICATE_PATH} ]] && cp "${SSL_CERTIFICATE_PATH}" /usr/local/share/ca-certificates/cert.crt
    [[ -f ${CA_CERTIFICATES_PATH} ]] && cp "${CA_CERTIFICATES_PATH}" /usr/local/share/ca-certificates/ca.crt
    update-ca-certificates --fresh >/dev/null
  fi
}

appStart () {
  appInit
  # start supervisord
  echo "Starting supervisord..."
  exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the nginx/php server (default)"
  echo " [command]          - Execute the specified linux command eg. bash."
}

case ${1} in
  app:start)
    appStart
    ;;
  app:help)
    appHelp
    ;;
  *)
    if [[ -x $1 ]]; then
      $1
    else
      prog=$(which $1)
      if [[ -n ${prog} ]] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0
