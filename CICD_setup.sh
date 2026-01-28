#!/usr/bin/env bash
set -euo pipefail

echo "=== Jenkins Installation Script Started ==="

# Ensure running as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or with sudo"
  exit 1
fi

# Install wget if missing
if ! command -v wget &>/dev/null; then
  echo "Installing wget..."
  yum install -y wget
fi

# Import Jenkins GPG key
echo "Importing Jenkins GPG key..."
rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

# Add Jenkins repo if not exists
JENKINS_REPO="/etc/yum.repos.d/jenkins.repo"

if [[ ! -f "$JENKINS_REPO" ]]; then
  echo "Adding Jenkins repo..."
  wget -O "$JENKINS_REPO" https://pkg.jenkins.io/rpm-stable/jenkins.repo
fi

# Update system
echo "Updating packages..."
yum update -y

# Install Java if missing
if ! rpm -q java-21-openjdk &>/dev/null; then
  echo "Installing Java 21..."
  yum install -y java-21-openjdk fontconfig
fi

# Install Jenkins if missing
if ! rpm -q jenkins &>/dev/null; then
  echo "Installing Jenkins..."
  yum install -y jenkins
fi


export CASC_JENKINS_CONFIG=/var/lib/jenkins/jenkins.yaml

# Reload systemd & enable Jenkins
echo "Configuring Jenkins service..."
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Verify Jenkins status
systemctl status jenkins --no-pager

echo "=== Jenkins Installation Completed Successfully ==="
