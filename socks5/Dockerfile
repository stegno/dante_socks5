FROM debian:bookworm-slim

RUN apt update && \
    apt install -y dante-server && \
    apt clean

COPY danted.conf /etc/danted.conf

CMD ["danted", "-f", "/etc/danted.conf", "-N"]
