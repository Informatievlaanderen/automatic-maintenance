# BSD 2-Clause License
# ====================

# Copyright (c) 2023, Fabian Grutschus
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
# https://github.com/fabiang/docker-go-sqlcmd
ARG GOLANG_VERSION=1.23
FROM golang:$GOLANG_VERSION-alpine AS build

ARG GO_SQLCMD_VERSION=1.8.2
ARG GO_SQLCMD_SHA256=4e97bf4ea6b00a43469156bde3ee91a622deed543b02b9b5dae3fa5565f6fea5

ADD https://api.github.com/repos/microsoft/go-sqlcmd/tarball/v$GO_SQLCMD_VERSION /tmp/gosqlcmd.tar.gz

RUN echo "$GO_SQLCMD_SHA256  /tmp/gosqlcmd.tar.gz" > /tmp/gosqlcmd.sha256 \
    && sha256sum -w -c /tmp/gosqlcmd.sha256

WORKDIR /tmp/gosqlcmd/
RUN tar -xv --strip-components=1 -f /tmp/gosqlcmd.tar.gz -C /tmp/gosqlcmd/
RUN go build -o sqlcmd \
    -ldflags="-X main.version=$GO_SQLCMD_VERSION" \
    /tmp/gosqlcmd/cmd/modern

FROM alpine

RUN apk add --no-cache bash dos2unix

COPY --from=build /tmp/gosqlcmd/sqlcmd /usr/local/bin/sqlcmd
COPY --from=build /tmp/gosqlcmd/LICENSE /usr/share/licenses/sqlcmd/LICENSE

COPY rebuild.sh /app/rebuild.sh
COPY rebuild.sql /app/rebuild.sql
WORKDIR /app

# Fix line endings and make executable
RUN dos2unix /app/rebuild.sh && \
    chmod +x /app/rebuild.sh && \
    ls -la /app/rebuild.sh

ENTRYPOINT ["/app/rebuild.sh"]
