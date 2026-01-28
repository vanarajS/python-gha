#!/usr/bin/env bash
set -euo pipefail

echo "=== Jenkins + PostgreSQL Installation Script Started ==="

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
echo "Updating system packages..."
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

# Export JCasC environment variables
export CASC_JENKINS_CONFIG="/var/lib/jenkins/jenkins.yaml"
export JENKINS_ADMIN_PASSWORD="StrongPasswordHere"
export GIT_PASSWORD="GitSecretHere"

# Enable & start Jenkins
echo "Starting Jenkins..."
systemctl daemon-reload
systemctl enable --now jenkins

systemctl status jenkins --no-pager

echo "=== Jenkins Installation Completed ==="


# ==========================================================
# PostgreSQL 10 Installation for SonarQube
# ==========================================================

echo "=== Starting PostgreSQL Installation for SonarQube ==="

PG_REPO="/etc/yum.repos.d/pgdg-redhat-all.repo"

if [[ ! -f "$PG_REPO" ]]; then
  echo "Installing PostgreSQL repository..."
  yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
fi

# Install PostgreSQL server if missing
if ! rpm -q postgresql10-server &>/dev/null; then
  echo "Installing PostgreSQL 10..."
  yum install -y postgresql10 postgresql10-server postgresql10-contrib
fi

# Initialize DB only if not initialized
PG_DATA="/var/lib/pgsql/10/data"

if [[ ! -f "$PG_DATA/PG_VERSION" ]]; then
  echo "Initializing PostgreSQL database..."
  /usr/pgsql-10/bin/postgresql-10-setup initdb
fi

# Replace ident -> md5 safely
PG_HBA="$PG_DATA/pg_hba.conf"

if grep -q "ident" "$PG_HBA"; then
  echo "Updating authentication method to md5..."
  sed -i 's/\bident\b/md5/g' "$PG_HBA"
fi

# Enable & start PostgreSQL
systemctl enable --now postgresql-10

systemctl status postgresql-10 --no-pager

echo "=== PostgreSQL Installation Completed ==="
echo "=== Script Finished Successfully ==="
