FROM busybox

LABEL maintainer="di3go-sona"
LABEL description="A minimal Docker image for Prometheus Node Exporter"

RUN mkdir -p /usr/local/bin

# Detect the architecture and operating system
# and download the appropriate version of blackbox_exporter
# This uses a service to map the current system's uname output to the correct GOOS and GOARCH values
RUN \
    export OS="$(uname -s | tr '[:upper:]' '[:lower:]')" && \
    export ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')" && \
    export VERSION=0.27.0 && \
    echo "Detected OS: $OS, ARCH: $ARCH" && \
    wget -qO- https://github.com/prometheus/blackbox_exporter/releases/download/v$VERSION/blackbox_exporter-$VERSION.$OS-$ARCH.tar.gz | tar xz -C /tmp && \
    mv /tmp/blackbox_exporter-$VERSION.$OS-$ARCH/blackbox_exporter /usr/local/bin/blackbox_exporter && \
    rm -rf /tmp/blackbox_exporter-$VERSION.$OS-$ARCH

# Expose the default port for blackbox_exporter
EXPOSE 9115

# Healthcheck to ensure blackbox_exporter is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
    CMD wget -q --spider http://localhost:9115/metrics || exit 1

# Set the entrypoint to run blackbox_exporter
CMD ["blackbox_exporter"]