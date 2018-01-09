FROM alpine:3.7
MAINTAINER Artem Starostenko

ARG GCLOUD_VERSION=183.0.0
# https://aur.archlinux.org/packages/kubectl-bin/
ARG KUBECTL_VERSION=v1.9.1
# https://github.com/kubernetes/helm/releases
ARG HELM_VERSION=v2.7.2
# build info
ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="helm-gke" \
      org.label-schema.url="https://hub.docker.com/r/artemkin/helm-gke/" \
      org.label-schema.vcs-url="https://github.com/artemkin/helm-gke"

# install dependencies
RUN apk add --no-cache ca-certificates tar wget openssl python bash
RUN mkdir /opt

# install gcloud
RUN	wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
    && tar -xvf google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz \
    && mv google-cloud-sdk /opt/google-cloud-sdk \
    && /opt/google-cloud-sdk/install.sh \
    && rm -f google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz

# install kubectl
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O /opt/google-cloud-sdk/bin/kubectl \
    && chmod a+x /opt/google-cloud-sdk/bin/kubectl

# install helm
RUN wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xvf helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && mv linux-amd64/helm /opt/google-cloud-sdk/bin/ \
    && chmod a+x /opt/google-cloud-sdk/bin/helm \
    && rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64

ENV PATH=$PATH:/opt/google-cloud-sdk/bin

CMD ["bash"]
