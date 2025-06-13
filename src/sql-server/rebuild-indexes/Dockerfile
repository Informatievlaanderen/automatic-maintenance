# BSD 2-Clause License
# ====================

# Copyright (c) 2017, Fabian Grutschus
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.

# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# https://github.com/fabiang/docker-sqlcmd
ARG UBUNTU_VERSION=22.04
FROM ubuntu:$UBUNTU_VERSION

ARG MSSQLTOOLS_VERSION=18.2.1.1
# Microsoft decided to have a suffix for newer versions of mssql-tools, e.g. mssql-tools18
ARG MSSQLTOOLS_SUFFIX=18
# and also the path changed on newer versions. It's a mess.
ARG MSSQLTOOLS_PATH=/opt/mssql-tools18

ENV PATH=$MSSQLTOOLS_PATH/bin:$PATH

LABEL maintainer="Digitaal Vlaanderen <digitaal.vlaanderen@vlaanderen.be>"

COPY / /app
WORKDIR /app

RUN apt-get -qqq update \
    && apt-get install -y curl apt-transport-https locales gnupg2 \
        # Helper command to convert \r\n to \n,
        # since sqlcmd prints Windows line endings
        dos2unix \
    && locale-gen "en_US.UTF-8" \
    \
    && export $(grep "VERSION_ID" /etc/os-release | sed -e 's/^VERSION_ID=\"/VERSION_ID=/' -e 's/\"$//') \
    && mkdir -p /usr/share/keyrings \
    && curl --fail --show-error https://packages.microsoft.com/config/ubuntu/$VERSION_ID/prod.list -o /tmp/microsoft-prod.list \
    && if ! grep -q "signed-by=" /tmp/microsoft-prod.list; then \
        sed -E 's#deb\s+\[#deb [signed-by=/usr/share/keyrings/microsoft-prod.gpg #; t; q1' /tmp/microsoft-prod.list > /etc/apt/sources.list.d/microsoft.list; \
        rm /tmp/microsoft-prod.list; \
    else \
        mv /tmp/microsoft-prod.list /etc/apt/sources.list.d/microsoft.list; \
    fi \
    && curl --fail --show-error https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
    \
    && apt-get -qqq update \
    && ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools$MSSQLTOOLS_SUFFIX=$MSSQLTOOLS_VERSION unixodbc-dev \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && chmod +x ./rebuild.sh

## should be set after locale was generated, overwise triggers warnings
ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"

ENTRYPOINT ["./rebuild.sh"]
