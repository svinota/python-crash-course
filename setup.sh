#!/bin/bash

dnf=`which dnf 2>/dev/null`
yum=`which yum 2>/dev/null`
apt=`which apt-get 2>/dev/null`

if [ ! -z "$apt" ]; then {
    sudo $apt install `cat requirements-debian`
} elif [ ! -z "$dnf" ]; then {
    sudo $dnf install `cat requirements-fedora`
} elif [ ! -z "$yum" ]; then {
    sudo $yum install `cat requirements-fedora`
} fi
sudo pip install -U -r requirements-pip
