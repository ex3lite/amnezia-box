#!/usr/bin/env bash

set -e -o pipefail

if [ -d /usr/local/go ]; then
  export PATH="$PATH:/usr/local/go/bin"
fi

DIR=$(dirname "$0")
PROJECT=$DIR/../..

pushd $PROJECT
go install -v -trimpath -ldflags "-s -w -buildid=" -tags with_gvisor,with_utls,with_clash_api,with_tailscale,with_dhcp,with_quic,with_wireguard,with_acme,with_awg ./cmd/sing-box
popd

sudo systemctl stop sing-box
sudo cp $(go env GOPATH)/bin/sing-box /usr/local/bin/
sudo systemctl start sing-box
