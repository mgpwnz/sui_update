#!/bin/bash

exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 && curl -s https://raw.githubusercontent.com/cryptology-nodes/main/main/logo.sh | bash && sleep 2

echo -e '\n\e[42mUpgrade software\e[0m\n' && sleep 1
systemctl stop suid
rm -rf /var/sui/db/* $HOME/sui
source $HOME/.cargo/env
cd $HOME
git clone https://github.com/MystenLabs/sui.git
cd sui
git checkout devnet-0.21.0
cargo build --bin sui-node --bin sui --release
mv ~/sui/target/release/sui-node /usr/local/bin/
mv ~/sui/target/release/sui /usr/local/bin/
systemctl restart suid
echo -e '\n\e[42mUpgrade completed\e[0m\n' && sleep 1
journalctl -u suid -f -o cat
