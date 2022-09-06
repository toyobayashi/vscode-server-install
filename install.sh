#!/bin/bash

set -e

vscode_sha=$1
targzfile=$2

if [ "$vscode_sha"x = ""x ]; then
  vscode_tag=$(curl -k -sSL "https://api.github.com/repos/microsoft/vscode/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  echo "tag: $vscode_tag"

  vscode_sha=$(curl -k -sSL "https://api.github.com/repos/microsoft/vscode/git/ref/tags/$vscode_tag" | grep '"sha":' | sed -E 's/.*"([^"]+)".*/\1/')
fi

echo "sha: $vscode_sha"

if [ "$targzfile"x = ""x ]; then
  targzfile="/tmp/vscode-server-linux-x64.tar.gz"
  download_url="https://update.code.visualstudio.com/commit:$vscode_sha/server-linux-x64/stable"
  echo "Download $download_url -> $targzfile"
  curl -k -SL "https://update.code.visualstudio.com/commit:$vscode_sha/server-linux-x64/stable" -o $targzfile
fi

vscode_install_dir=~/.vscode-server/bin/$vscode_sha
echo "Install $targzfile to $vscode_install_dir"

mkdir -p $vscode_install_dir
tar zxvf "$targzfile" -C $vscode_install_dir --strip 1 >/dev/null
touch $vscode_install_dir/0
echo "Done"
