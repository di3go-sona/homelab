FROM golang AS builder

WORKDIR /build
RUN git clone https://github.com/google/cadvisor.git

WORKDIR /build/cadvisor
RUN make build

FROM busybox AS exporter
COPY --from=builder /build/cadvisor/_output/cadvisor /usr/local/bin/cadvisor

EXPOSE 8080
CMD ["cadvisor"]
