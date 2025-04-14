FROM ubuntu:22.04

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    docker.io \
    docker-compose \
    conntrack \
    socat \
    ebtables \
    ethtool \
    iptables \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize

# Install Minikube for Kubernetes v1.25.9 (arm64)
RUN curl -LO https://storage.googleapis.com/minikube/releases/v1.29.0/minikube-linux-arm64 && \
    chmod +x minikube-linux-arm64 && \
    mv minikube-linux-arm64 /usr/local/bin/minikube && \
    minikube version || { echo "Minikube installation failed"; exit 1; }

# Install kubectl for Kubernetes v1.25.9 (arm64)
RUN curl -LO "https://dl.k8s.io/release/v1.25.9/bin/linux/arm64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    kubectl version --client || { echo "kubectl installation failed"; exit 1; }

# Create non-root user for running Minikube
RUN useradd -ms /bin/bash minikube && usermod -aG docker minikube

# Set working directory
WORKDIR /home/minikube

# Copy entrypoint script with correct ownership and permissions
COPY --chown=minikube:minikube entrypoint.sh .
RUN chmod +x entrypoint.sh

# Copy the shinyproxy folder into the container
COPY ./shinyproxy /shinyproxy
RUN chown -R minikube:minikube /shinyproxy

# Use the non-root user
USER minikube

# Set entrypoint
ENTRYPOINT ["./entrypoint.sh"]
