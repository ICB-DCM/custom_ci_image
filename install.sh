#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt-get clean && apt-get update
apt-get install -y apt-utils

echo "================ Installing locales ======================="
apt-get install -q locales

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u18

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -q \
  build-essential \
  curl \
  gcc \
  clang \
  gettext \
  libxml2-dev \
  libxslt1-dev \
  make \
  nano \
  openssh-client \
  openssl \
  software-properties-common \
  sudo  \
  texinfo \
  zip \
  unzip \
  wget \
  rsync \
  psmisc \
  netcat-openbsd \
  vim

echo "================= Installing Python packages ==================="
apt-get install -q -y \
  python3-pip \
  python3-dev

echo "================= Installing Git ==================="
add-apt-repository ppa:git-core/ppa -y
apt-get update
apt-get install -q -y git

echo "================= sonarcloud requirements ============"

apt install nodejs
export SONAR_SCANNER_VERSION=4.6.1.2450
export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
curl --create-dirs -sSLo $HOME/.sonar/sonar-scanner.zip \
  https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
export SONAR_SCANNER_OPTS="-server"

curl --create-dirs -sSLo $HOME/.sonar/build-wrapper-linux-x86.zip \
  https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip
unzip -o $HOME/.sonar/build-wrapper-linux-x86.zip -d $HOME/.sonar/
export PATH=$HOME/.sonar/build-wrapper-linux-x86:$PATH

echo "================= parPE requirements ============"
apt-get install \
  gfortran \
  libmpich-dev \
  libatlas-base-dev \
  libboost-all-dev \
  libhdf5-dev \
  cmake \
  libceres-dev \
  coinor-libipopt-dev \
  gcovr \
  valgrind \
  swig \
  python3 \
  python3-numpy \
  python3-venv \
  hdf5-tools
# for setuptools to find:
python3 -m pip install --upgrade pip
pip3 install -U setuptools pkgconfig wheel

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
