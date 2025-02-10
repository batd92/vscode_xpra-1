FROM ubuntu:latest

RUN apt update && apt install -y --no-install-recommends \
    curl python3 python3-tk x11-apps \
    xpra xvfb git sudo \
    uuid-runtime iproute2 x11-xserver-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://code-server.dev/install.sh | sh

COPY python-template/ /python-template/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080 10000

ENTRYPOINT ["/entrypoint.sh"]
