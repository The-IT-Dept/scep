FROM golang:1.16 as builder

WORKDIR /build
COPY . .
RUN go mod download

RUN GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=xxx" -o scepclient-linux-amd64 ./cmd/scepclient
RUN GOOS=linux GOARCH=amd64 go build -ldflags "-X main.version=xxx" -o scepserver-linux-amd64 ./cmd/scepserver



FROM alpine:3

WORKDIR /app

COPY --from=builder /build/scepclient-linux-amd64 /app/scepclient
COPY --from=builder /build/scepserver-linux-amd64 /app/scepserver

RUN apk add libc6-compat

EXPOSE 8080

VOLUME ["/data"]

ENTRYPOINT ["/app/scepserver"]
