#!/bin/bash
set -ex

# Update system
apt update -y
apt-get dist-upgrade -y

# Install Java 21
apt install -y fontconfig openjdk-21-jre

# Install Jenkins
install -m 0755 -d /etc/apt/keyrings
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update -y
apt install -y jenkins

# Install Docker
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add Jenkins user to Docker group
usermod -aG docker jenkins
systemctl restart jenkins

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg \
  | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| tee /etc/apt/sources.list.d/hashicorp.list

apt update -y
apt install -y terraform

# Install AWS CLI v2
apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Pre-create empty AWS config to avoid interactive prompt later
mkdir -p /home/ubuntu/.aws
chown -R ubuntu:ubuntu /home/ubuntu/.aws

echo "✔ Installation completed successfully" > /root/install-status.txt
