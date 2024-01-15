#!/bin/bash


if [ `id -u` -ne 0 ]; then
    echo "ERROR: Root privileges are required to run this script"
    exit 1
fi

if ! curl -V &> /dev/null; then
    echo "ERROR: curl is required for this script but not found. Install it with: sudo apt install curl"
    exit 1
fi

NVIM_VERSION="v0.9.5"
NVIM_PATH=/usr/local/bin/nvim.appimage
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim.appimage"
NVIM_TEMP="$(mktemp)"


set -e
trap "rm ${NVIM_TEMP} &> /dev/null" EXIT

echo "Downloading Neovim appimage..."
curl -L --progress-bar -o ${NVIM_TEMP} ${NVIM_URL}

echo "Installing Neovim appimage..."
install -o root -g root -m u=rwx,g=rx,o=rx ${NVIM_TEMP} ${NVIM_PATH}

echo "Updating alternatives"
set -u
update-alternatives --install /usr/bin/ex ex "${NVIM_PATH}" 110
update-alternatives --install /usr/bin/vi vi "${NVIM_PATH}" 110
update-alternatives --install /usr/bin/view view "${NVIM_PATH}" 110
update-alternatives --install /usr/bin/vim vim "${NVIM_PATH}" 110
update-alternatives --install /usr/bin/vimdiff vimdiff "${NVIM_PATH}" 110

echo "Neovim ${NVIM_VERSION} successfully installed!"
