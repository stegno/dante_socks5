FROM debian:bookworm-slim

RUN apt update && \
    apt install -y dante-server && \
    apt clean

COPY sockd.conf /etc/sockd.conf

CMD ["danted", "-f", "/etc/sockd.conf", "-N"]
