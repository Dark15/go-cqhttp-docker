#!/bin/sh

init_config() {
  yq e -i ".account.uin = ${UIN}" ./config.yml
  yq e -i ".account.password = ${PASSWORD}" ./config.yml
  yq e -i ".account.host = ${HOST}" ./config.yml

  IFS=","
  for ITEM in $SERVERS; do
    if [ "$ITEM" = "http" ]; then
      yq e -i ".servers.http.disabled = false" ./config.yml
      yq e -i ".servers.http.post[0].url = ${HTTP_POST_URL}" ./config.yml
      yq e -i ".servers.http.post[0].secret = ${HTTP_POST_SECRET}" ./config.yml
    elif [ "$ITEM" = "ws" ]; then
      yq e -i ".servers.ws.disabled = false" ./config.yml
    elif [ "$ITEM" = "ws-reverse" ]; then
      yq e -i ".servers.ws-reverse.disabled = false" ./config.yml
      yq e -i ".servers.ws-reverse.universal = ${WS_REVERSE_UNIVERSAL}" ./config.yml
    fi
  done
}

init_config

./go-cqhttp "$@"
