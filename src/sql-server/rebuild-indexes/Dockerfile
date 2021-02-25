# Based on https://github.com/fabiang/docker-sqlcmd
FROM ubuntu:18.04

LABEL maintainer "agentschap Informatie Vlaanderen <basisregisters@vlaanderen.be>"

COPY / /app
WORKDIR /app

ENV PATH=/opt/mssql-tools/bin:$PATH
RUN apt-get update && \
    apt-get install -y curl gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    chmod +x ./rebuild.sh

ENTRYPOINT ["./rebuild.sh"]
