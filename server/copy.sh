#!/bin/bash

# Copy Bootstrap (Need To Have Root Key)
read -p 'Enter Remote Host IP: ' ip
scp -rp etc root@$ip:~
scp -p bootstrap.sh root@$ip:~