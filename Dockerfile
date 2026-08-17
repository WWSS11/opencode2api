FROM --platform=$BUILDPLATFORM golang:1.24-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./
COPY webui ./webui

ARG TARGETOS
ARG TARGETARCH
ARG VERSION=dev
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build \
    -trimpath \
    -ldflags "-s -w -X main.version=${VERSION}" \
    -o /out/opencode2api ./

FROM alpine:3.22

RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=build /out/opencode2api /usr/local/bin/opencode2api
COPY config.example.json /usr/share/opencode2api/config.example.json
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod 0755 /usr/local/bin/docker-entrypoint \
    && mkdir -p /app/config

EXPOSE 8080 8081

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
