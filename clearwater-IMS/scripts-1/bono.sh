#!/bin/bash 

# ctx logger info "In Bono ${public_ip}   ${dns_ip}   "

# echo "In Bono ${public_ip}   ${dns_ip}   " > /home/ubuntu/dnsfile

# sudo exec > >(sudo tee -a /var/log/clearwater-cloudify.log) 2>&1


# Configure the APT software source.
sudo echo 'deb http://repo.cw-ngv.com/stable binary/' > /etc/apt/sources.list.d/clearwater.list
sudo curl -L http://repo.cw-ngv.com/repo_key | apt-key add -
sudo apt-get update

# Configure /etc/clearwater/local_config.
sudo mkdir -p /etc/clearwater
sudo cat > /etc/clearwater/config << EOF
home_domain=example.com
sprout_hostname=sprout.example.com
chronos_hostname=$(hostname -I | sed -e 's/  *//g'):7253
hs_hostname=hs.example.com:8888
hs_provisioning_hostname=hs.example.com:8889
ralf_hostname=ralf.example.com:10888
xdms_hostname=homer.example.com:7888

local_ip=$(hostname -I)
public_ip1=$public_ip
public_hostname=bono.example.com

# Email server configuration
smtp_smarthost=localhost
smtp_username=username
smtp_password=password
email_recovery_sender=clearwater@example.org

# Keys
signup_key=secret
turn_workaround=secret
ellis_api_key=secret
ellis_cookie_key=secret
EOF

# Now install the software.
# "-o DPkg::options::=--force-confnew" works around https://github.com/Metaswitch/clearwater-infrastructure/issues/186.
#sudo DEBIAN_FRONTEND=noninteractive apt-get install bono --yes --force-yes -o DPkg::options::=--force-confnew
#sudo DEBIAN_FRONTEND=noninteractive apt-get install clearwater-config-manager --yes --force-yes
sudo DEBIAN_FRONTEND=noninteractive apt-get install bono dnsutils --yes --force-yes

