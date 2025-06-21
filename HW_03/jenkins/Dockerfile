FROM jenkins/jenkins:lts-jdk11

# Switch to root user for installing dependencies
USER root

# Install required tools and Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    lsb-release \
    python3-pip \
    curl && \
    curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to Jenkins user
USER jenkins

# Install plugins
RUN jenkins-plugin-cli --verbose --plugins \
    blueocean:latest \
    docker-workflow:latest \
    git:latest \
    pipeline-stage-view:latest \
    workflow-aggregator:latest

# Expose default Jenkins port
EXPOSE 8080

# Set environment variables for Jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_OPTS="--httpPort=8080"