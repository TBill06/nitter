FROM nimlang/nim:2.2.0-alpine-regular as nim
LABEL maintainer="setenforce@protonmail.com"

RUN apk --no-cache add libsass-dev pcre

WORKDIR /src/nitter

COPY nitter.nimble .
RUN nimble install -y --depsOnly

COPY . .
RUN nimble build -d:danger -d:lto -d:strip --mm:refc \
    && nimble scss \
    && nimble md

FROM alpine:latest
WORKDIR /src/
RUN apk --no-cache add pcre ca-certificates shadow
COPY --from=nim /src/nitter/nitter ./
COPY --from=nim /src/nitter/public ./public
COPY start.sh .
RUN adduser -h /src/ -D -s /bin/sh nitter
RUN usermod -a -G 1000 nitter
RUN chmod +x ./start.sh
USER nitter
EXPOSE 8080
CMD ["./start.sh"]