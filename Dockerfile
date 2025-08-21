# --- Build Stage (No changes) ---
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

# --- Final Stage ---
FROM alpine:latest
WORKDIR /src/
RUN apk --no-cache add pcre ca-certificates

# Copy all necessary files.
COPY --from=nim /src/nitter/nitter ./
COPY --from=nim /src/nitter/public ./public
COPY start.sh .

# Make the startup script executable.
RUN chmod +x ./start.sh

# We DO NOT create a 'nitter' user.
# We DO NOT use 'USER nitter'.
# The entire container will run as the default ROOT user.
EXPOSE 8080
CMD ["./start.sh"]