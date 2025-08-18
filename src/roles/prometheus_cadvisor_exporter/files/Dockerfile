FROM golang:alpine AS builder

RUN apk add --no-cache git make bash musl-dev gcc 

WORKDIR /build
RUN git clone https://github.com/google/cadvisor.git

WORKDIR /build/cadvisor
RUN /bin/bash -c "make build"

FROM alpine AS exporter
COPY --from=builder /build/cadvisor/_output/cadvisor /usr/local/bin/cadvisor

EXPOSE 8080
CMD ["cadvisor"]
