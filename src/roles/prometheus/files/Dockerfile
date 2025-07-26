FROM busybox

LABEL maintainer="di3go-sona"
LABEL description="A minimal Docker image for Prometheus"

RUN mkdir -p /usr/local/bin

# Detect the architecture and operating system
# and download the appropriate version of prometheus
# This uses a service to map the current system's uname output to the correct GOOS and GOARCH values
RUN \
    export OS="$(uname -s | tr '[:upper:]' '[:lower:]')" && \
    export ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/' -e 's/armv6l/armv6/' )" && \
    export VERSION=3.4.2 && \
    echo "Detected OS: $OS, ARCH: $ARCH" && \
    wget -qO- https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.$OS-$ARCH.tar.gz | tar xz -C /tmp && \
    mv /tmp/prometheus-$VERSION.$OS-$ARCH/prometheus /usr/local/bin/prometheus && \
    rm -rf /tmp/prometheus-$VERSION.$OS-$ARCH

# Expose the default port for prometheus
EXPOSE 9090

# Healthcheck to ensure prometheus is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s \
    CMD wget -q --spider http://localhost:9090/metrics || exit 1

# Set the entrypoint to run prometheus
CMD ["prometheus"]
