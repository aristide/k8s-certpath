FROM alpine

ARG ARCH

# Ignore to update versions here
# docker build --no-cache --build-arg KUBECTL_VERSION=${tag} --build-arg HELM_VERSION=${helm} --build-arg KUSTOMIZE_VERSION=${kustomize_version} -t ${image}:${tag} .
ARG HELM_VERSION=3.12.3
ARG KUBECTL_VERSION=1.28.1
ARG KUDO_VERSION=0.19.0
ARG ETCD_VERSION=3.4.27
ARG KREW_VERSION=0.4.4
ARG KUBESPHERE_VERSION=3.4.0

# Install helm (latest release)
# ENV BASE_URL="https://storage.googleapis.com/kubernetes-helm"
RUN case `uname -m` in \
    x86_64) ARCH=amd64; ;; \
    armv7l) ARCH=arm; ;; \
    aarch64) ARCH=arm64; ;; \
    ppc64le) ARCH=ppc64le; ;; \
    s390x) ARCH=s390x; ;; \
    *) echo "un-supported arch, exit ..."; exit 1; ;; \
    esac && \
    echo "export ARCH=$ARCH" > /envfile && \
    cat /envfile && \
    mkdir -p /tmp

# add helm
RUN . /envfile && echo $ARCH && \
    apk add --update --no-cache curl wget ca-certificates unzip bash git && \
    curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar -xvz && \
    mv linux-${ARCH}/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-${ARCH}

# add helm-diff
RUN helm plugin install https://github.com/databus23/helm-diff && rm -rf /tmp/helm-*

# add helm-unittest
RUN helm plugin install https://github.com/helm-unittest/helm-unittest && rm -rf /tmp/helm-*

# add helm-push
RUN helm plugin install https://github.com/chartmuseum/helm-push && \
    rm -rf /tmp/helm-* \
    /root/.local/share/helm/plugins/helm-push/testdata \
    /root/.cache/helm/plugins/https-github.com-chartmuseum-helm-push/testdata

# Install kubectl
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install kudo
RUN . /envfile && echo $ARCH && \
    wget -O kubectl-kudo https://github.com/kudobuilder/kudo/releases/download/v${KUDO_VERSION}/kubectl-kudo_${KUDO_VERSION}_linux_${ARCH} && \
    mv kubectl-kudo /usr/bin/kubectl-kudo && \
    chmod +x /usr/bin/kubectl-kudo 

# Install etcd 
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/etcd/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-${ARCH}.zip && \
    unzip etcd-v${ETCD_VERSION}-linux-${ARCH}.zip -d /tmp && \
    mv /tmp/etcd-v${ETCD_VERSION}-linux-${ARCH}/*  /usr/bin/ && \
    rm -rf etcd-v${ETCD_VERSION}-linux-${ARCH}.zip  /tmp/etcd-v${ETCD_VERSION}-linux-${ARCH}

# Install  kube-api-server
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kube-apiserver && \
    mv kube-apiserver /usr/bin/kube-apiserver && \
    chmod +x /usr/bin/kube-apiserver

# Install  kube-controller-manager
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kube-controller-manager && \
    mv kube-controller-manager /usr/bin/kube-controller-manager && \
    chmod +x /usr/bin/kube-controller-manager

# Install kuber-scheduler
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kube-scheduler && \
    mv kube-scheduler /usr/bin/kube-scheduler && \
    chmod +x /usr/bin/kube-scheduler

# Install kubelet
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kubelet && \
    mv kubelet /usr/bin/kubelet && \
    chmod +x /usr/bin/kubelet

# Install kuber-aggregator
RUN . /envfile && echo $ARCH && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/${ARCH}/kube-aggregator && \
    mv kube-aggregator /usr/bin/kube-aggregator && \
    chmod +x /usr/bin/kube-aggregator

# Install krew
RUN . /envfile && echo $ARCH && \
    curl -fsSLO https://github.com/kubernetes-sigs/krew/releases/download//krew-linux_${ARCH}.tar.gz && \
    tar zxvf krew-linux_${ARCH}.tar.gz && \
    KREW=./krew-linux_${ARCH} && \
    "$KREW" install krew && \
    cp $HOME/.krew/bin/kubectl-krew /usr/bin/

# Install kubesphere


