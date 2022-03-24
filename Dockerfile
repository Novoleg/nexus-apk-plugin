FROM alpine:3.15.0 as downloader

ARG DOWNLOADER_FOLDER=downloader
ARG NEXUS3_KEYCLOAK_PLUGIN_FILENAME=nexus3-keycloak-plugin.kar
ARG NEXUS3_KEYCLOAK_PLUGIN_VERSION=0.5.0
# ARG NEXUS_VERSION=3.37.3
# ARG NEXUS3_APK_REPOSITORY_PLUGIN=nexus3-apk-repository-plugin.kar
# ARG NEXUS3_APK_REPOSITORY_PLUGIN_VERSION=0.0.23


RUN apk add curl && \
    mkdir $DOWNLOADER_FOLDER && \
    curl -sSLfo $DOWNLOADER_FOLDER/$NEXUS3_KEYCLOAK_PLUGIN_FILENAME https://github.com/flytreeleft/nexus3-keycloak-plugin/releases/download/v{$NEXUS3_KEYCLOAK_PLUGIN_VERSION}/nexus3-keycloak-plugin-${NEXUS3_KEYCLOAK_PLUGIN_VERSION}-bundle.kar
    # curl -sSLfo $DOWNLOADER_FOLDER/$NEXUS3_APK_REPOSITORY_PLUGIN https://repo1.maven.org/maven2/org/sonatype/nexus/plugins/nexus-repository-apk/${NEXUS3_APK_REPOSITORY_PLUGIN_VERSION}/nexus-repository-apk-${NEXUS3_APK_REPOSITORY_PLUGIN_VERSION}-bundle.kar

FROM sonatype/nexus3:3.37.3 as runtime

ARG DOWNLOADER_FOLDER
ENV NEXUS_VERSION=$NEXUS_VERSION

ARG DEPLOY_DIR=/opt/sonatype/nexus/deploy/
COPY --from=downloader $DOWNLOADER_FOLDER/* $DEPLOY_DIR/