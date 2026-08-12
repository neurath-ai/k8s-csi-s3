FROM golang:1.25.9 AS geesefs-build

WORKDIR /src
COPY third_party/geesefs/ ./
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /geesefs .

FROM golang:1.25.9

LABEL maintainers="Vitaliy Filippov <vitalif@yourcmc.ru>"
LABEL description="csi-s3 testing image"

# Minio download servers are TERRIBLY SLOW as of 2021-10-27
#RUN wget https://dl.min.io/server/minio/release/linux-amd64/minio && \
#    chmod +x minio && \
#    mv minio /usr/local/bin

RUN git clone --depth=1 https://github.com/minio/minio
RUN cd minio && go build && mv minio /usr/local/bin

WORKDIR /build

# prewarm go mod cache
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY --from=geesefs-build /geesefs /usr/bin/geesefs

ENTRYPOINT ["/build/test/test.sh"]
