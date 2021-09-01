FROM --platform=$TARGETPLATFORM alpine:latest
ARG BUILDARCH
ARG version=1.0.0-beta6

WORKDIR /app
VOLUME [ "/app" ]
COPY entrypoint.sh /usr/local/bin
COPY config.yml /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \ 
  apk add --no-cache --virtual .build-deps wget tar && \
  wget -O go-cqhttp.tar.gz "https://github.com/Mrs4s/go-cqhttp/releases/download/v${version}/go-cqhttp_linux_${BUILDARCH}.tar.gz" && \
  tar -xvf go-cqhttp.tar.gz && \
  rm go-cqhttp.tar.gz && \
  mv go-cqhttp /app && \
  apk del .build-deps && \
  apk add --no-cache ffmpeg websocat && \
  chmod +x /usr/local/bin/entrypoint.sh && \
  chmod +x ./go-cqhttp

HEALTHCHECK --interval=1m --timeout=30s --retries=3 \
  CMD websocat -q -Uu ws://127.0.0.1:6700 2> /dev/null || exit 1

ENTRYPOINT ["entrypoint.sh", "faststart"]