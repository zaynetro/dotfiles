#!/usr/bin/env bash

set -e

echo "Installing global packages..."
rpm-ostree install --idempotent \
  emacs \
  aspell \
  aspell-en \
  fd-find \
  fish \
  java-11-openjdk-devel \
  nodejs \
  podman-compose \
  podman-docker \
  ripgrep \
  syncthing
