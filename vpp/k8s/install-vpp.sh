#/bin/sh

ubuntu=focal

echo "Installing vpp (master version)..."
echo "deb [trusted=yes] https://packagecloud.io/fdio/release/ubuntu $ubuntu main" > /etc/apt/sources.list.d/99fd.io.list
curl -L https://packagecloud.io/fdio/release/gpgkey | sudo apt-key add -
apt-get update && apt-get install vpp vpp-plugin-core vpp-plugin-dpdk -y