## Base ##
FROM debian:bullseye-slim as base

RUN \
    apt-get update && \
    apt-get -y install ca-certificates && \
    apt-get clean

## Download ##
FROM base as download

RUN \
    apt-get -y install curl jq && \
    curl -s https://api.caido.io/releases/latest \
    | jq '.links[] | select(.display == "Linux AArch64") | .link' \
    | xargs curl -s -L --output caido.tar.gz && \
    tar -xf caido.tar.gz && \
    rm caido.tar.gz

## Runtime ##
FROM base

RUN groupadd -r caido && useradd --no-log-init -m -r -g caido caido

COPY --from=download caido-cli /usr/bin/caido

USER caido

EXPOSE 8080

ENTRYPOINT ["caido"]
CMD ["--listen", "0.0.0.0:8080"]
