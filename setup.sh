#!/usr/bin/env bash

read -p "You are about to install Nix, press enter to continue..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
read -p "You are about to install Homebrew, press enter to continue..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
