ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

RUN apk add --no-cache dante-server bash shadow jq

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
