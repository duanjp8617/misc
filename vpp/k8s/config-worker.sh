#/bin/sh

initfile=/home/ubuntu/scripts/kubeadm_init.txt

swapoff -a
addr=$(grep -oP "(?<=kubeadm join ).*(?= --token)" $initfile)
token=$(grep -oP "(?<=--token ).*(?= )" $initfile)
cert_hash=$(grep -oP "(?<=ca-cert-hash ).*(?= )" $initfile)
echo "Joining k8s master at $addr."
echo "Token: $token."
echo "Certificate hash: $cert_hash."
kubeadm join $addr --token $token --discovery-token-ca-cert-hash $cert_hash --node-name `hostname`