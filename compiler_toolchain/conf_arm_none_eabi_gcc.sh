#! /bin/bash
echo '' >> /etc/profile
echo '#gcc-arm-none-eabi configure'>> /etc/profile
#gcc-arm-none-eabi所在目录，一般放在opt下即可
echo 'export PATH=$PATH:/opt/gcc-arm-none-eabi/bin' >> /etc/profile
