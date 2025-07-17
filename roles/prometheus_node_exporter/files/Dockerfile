FROM busybox

LABEL maintainer="di3go-sona"
LABEL description="A minimal Docker image for Prometheus Node Exporter"

RUN mkdir -p /usr/local/bin

# Detect the architecture and operating system
# and download the appropriate version of node_exporter
# This uses a service to map the current system's uname output to the correct GOOS and GOARCH values
RUN \
    export OS="$(uname -s | tr '[:upper:]' '[:lower:]')" && \
    export ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')" && \
    export VERSION=1.9.1 && \
    echo "Detected OS: $OS, ARCH: $ARCH" && \
    wget -qO- https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.$OS-$ARCH.tar.gz | tar xz -C /tmp && \
    mv /tmp/node_exporter-$VERSION.$OS-$ARCH/node_exporter /usr/local/bin/node_exporter && \
    rm -rf /tmp/node_exporter-$VERSION.$OS-$ARCH

# Expose the default port for node_exporter
EXPOSE 9100

# Healthcheck to ensure node_exporter is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
    CMD wget -q --spider http://localhost:9100/metrics || exit 1

# Set the entrypoint to run node_exporter
CMD ["node_exporter"]