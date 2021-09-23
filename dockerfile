FROM --platform=$TARGETPLATFORM alpine:latest
ARG TARGETARCH
ARG version=1.0.0-beta7-fix2

WORKDIR /app
VOLUME [ "/app" ]
COPY entrypoint.sh /usr/local/bin
COPY config.yml /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \ 
  apk add --no-cache --virtual .build-deps wget tar && \
  wget -O go-cqhttp.tar.gz "https://github.com/Mrs4s/go-cqhttp/releases/download/v${version}/go-cqhttp_linux_${TARGETARCH}.tar.gz" && \
  tar -xvf go-cqhttp.tar.gz && \
  rm go-cqhttp.tar.gz && \
  mv go-cqhttp /app && \
  apk del .build-deps && \
  apk add --no-cache ffmpeg yq && \
  chmod +x /usr/local/bin/entrypoint.sh && \
  chmod +x ./go-cqhttp

ENTRYPOINT ["entrypoint.sh", "faststart"]
