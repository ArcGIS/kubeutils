FROM node:8

ARG KUBECTL_VERSION=1.8.6

RUN mkdir /usr/local/share/ca-certificates/k8s && \
    chown -R node:node /usr/local/share/ca-certificates/k8s && \
    chown -R node:node /etc/ssl/certs/

RUN apt-get update && apt-get -qq install -y ca-certificates musl musl-dev

RUN ln -s /lib/ld-musl-x86_64.so.1 /lib/libc.musl-x86_64.so.1

ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

RUN mkdir /kubeutils
WORKDIR /kubeutils

ADD yarn.lock /kubeutils
ADD . /kubeutils

RUN yarn

RUN ln -sfv /kubeutils/bin/cli.js /usr/local/bin/kubeutils
RUN chmod +x /usr/local/bin/kubeutils
