ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

RUN apk add --no-cache dante-server bash shadow

COPY run.sh /run.sh
COPY danted.conf /danted.conf

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
