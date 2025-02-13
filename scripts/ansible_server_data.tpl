#cloud-config

runcmd:
  - rm -f /etc/ssh/sshd_config.d/50-cloud-init.conf
  - sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
  - sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
  - systemctl restart sshd
  - hostnamectl set-hostname ${hostname}
  - dnf install epel-release -y
  - dnf install ansible -y
  - dnf install sshpass -y
  - dnf install git -y
  - git clone --branch final --single-branch https://github.com/hyukjinKimm/ansible.git

