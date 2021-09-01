#!/bin/sh

init_config() {
  yq e -i "
  .account.uin = env(UIN) |
  .account.password = env(PASSWORD)
  " ./config.yml

  IFS=","
  for ITEM in $SERVERS; do
    if [ "$ITEM" = "http" ]; then
      yq e -i "
      .servers[0].disabled = false | 
      .servers[0].post[0].url = strenv(HTTP_POST_URL) | 
      .servers[0].post[0].secret = strenv(HTTP_POST_SECRET)
      " ./config.yml
    elif [ "$ITEM" = "ws" ]; then
      yq e -i ".servers[1].disabled = false" ./config.yml
    elif [ "$ITEM" = "ws-reverse" ]; then
      yq e -i "
      .servers[2].disabled = false | 
      .servers[2].universal = strenv(WS_REVERSE_UNIVERSAL)
      " ./config.yml
    fi
  done
}

init_config

./go-cqhttp "$@"
