# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM golang:1.25.9-alpine AS csi-build

ARG TARGETOS
ARG TARGETARCH
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY cmd ./cmd
COPY pkg ./pkg
RUN CGO_ENABLED=0 GOOS="$TARGETOS" GOARCH="$TARGETARCH" \
    go build -trimpath -a -ldflags '-extldflags "-static"' -o /out/s3driver ./cmd/s3driver

FROM --platform=$BUILDPLATFORM golang:1.25.9-alpine AS geesefs-build

ARG TARGETOS
ARG TARGETARCH
WORKDIR /build
COPY third_party/geesefs/ ./
RUN go mod download
RUN CGO_ENABLED=0 GOOS="$TARGETOS" GOARCH="$TARGETARCH" \
    go build -trimpath -ldflags "-X main.Version=0.43.7-neurath.1" -o /out/geesefs .

FROM alpine:3.22

LABEL org.opencontainers.image.source="https://github.com/neurath-ai/k8s-csi-s3"
LABEL org.opencontainers.image.description="CSI S3 driver with GeeseFS"
RUN apk add --no-cache fuse mailcap rclone s3fs-fuse
COPY --from=csi-build /out/s3driver /s3driver
COPY --from=geesefs-build /out/geesefs /usr/bin/geesefs
ENTRYPOINT ["/s3driver"]
