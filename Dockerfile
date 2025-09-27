FROM eclipse-temurin:17-jre-alpine

# Tools: lbzip2 (parallel bzip2), bzip2 (for compatibility), wget, certs
RUN apk add --no-cache lbzip2 bzip2 wget ca-certificates

ENV PHOTON_VERSION=0.7.4
WORKDIR /photon

# Download Photon JAR at build time
ADD https://github.com/komoot/photon/releases/download/${PHOTON_VERSION}/photon-${PHOTON_VERSION}.jar /photon/photon.jar

# Entrypoint script
COPY entrypoint.sh /photon/entrypoint.sh
RUN chmod +x /photon/entrypoint.sh

EXPOSE 2322
VOLUME ["/photon/photon_data"]

ENTRYPOINT ["/bin/sh", "/photon/entrypoint.sh"]
