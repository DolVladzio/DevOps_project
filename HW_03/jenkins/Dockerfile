FROM jenkins/jenkins:2.414.2-jdk11

# Switch to root user for package installation
USER root

# Install required dependencies and Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    lsb-release \
    python3-pip && \
    curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to Jenkins user
USER jenkins

RUN mkdir -p /usr/share/jenkins/ref/plugins && \
    curl -o /usr/share/jenkins/ref/plugins/blueocean.jpi https://updates.jenkins.io/latest/blueocean.hpi && \
    curl -o /usr/share/jenkins/ref/plugins/docker-workflow.jpi https://updates.jenkins.io/latest/docker-workflow.hpi