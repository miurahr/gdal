#!/usr/bin/env bash

# MSSQL: client side
wget -nc -c -P /var/cache/wget https://packages.microsoft.com/config/ubuntu/14.04/packages-microsoft-prod.deb
sudo dpkg -i /var/cache/wget/packages-microsoft-prod.deb
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
