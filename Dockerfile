# This file is intended to be used apart from the containing source code tree.

FROM python:3-alpine AS builder

# Version of Radicale (e.g. v3)
ARG VERSION=master

# Optional dependencies (e.g. bcrypt or ldap)
ARG DEPENDENCIES=bcrypt

RUN apk add --no-cache --virtual gcc libffi-dev musl-dev \
    && python -m venv /app/venv \
    && /app/venv/bin/pip install --no-cache-dir "Radicale[${DEPENDENCIES}] @ https://github.com/Kozea/Radicale/archive/${VERSION}.tar.gz"


FROM python:3-alpine

WORKDIR /app

RUN addgroup -g 10001 radicale \
    && adduser radicale --home /var/lib/radicale --system --uid 10001 --disabled-password -G radicale \
    && apk add --no-cache ca-certificates openssl

COPY --from=builder /app/venv /app

# Persistent storage for data
VOLUME /var/lib/radicale
# TCP port of Radicale
EXPOSE 5232
# Run Radicale
ENTRYPOINT [ "/app/bin/python", "/app/bin/radicale"]
CMD ["--hosts", "0.0.0.0:5232,[::]:5232", "--auth-type", "htpasswd", "--auth-htpasswd-filename", "/home/radicale/.config/radicale/users", "--auth-htpasswd-encryption", "autodetect"]

USER radicale