FROM debian:bullseye

RUN apt update && \
    apt install -y dante-server && \
    apt clean

COPY sockd.conf /etc/sockd.conf

CMD ["/usr/sbin/danted", "-f", "/etc/danted.conf"]
