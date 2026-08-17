pwd
mkdir -p plays/roles && cd plays && pwd
cat > ansible.cfg
cat ansible.cfg 
cat > inventory
cd
ssh-keygen -t rsa -b 4096 -N '' 
vi ~/plays/adhoc
chmod u+rwx ~/plays/adhoc
cat ~/plays/adhoc 
vi ~/plays/adhoc
cat ~/plays/adhoc
man visudo
~/plays/adhoc 
cd plays
~/plays/adhoc 
cat inventory 
vi /etc/hosts
cd plays
ping -m ping all
ansible -m ping all
for h in 2 3 4 5 ; do h=ansible$i H=$h.hl.local; ssh $h hostname; ssh $H hostname; done 
clear
for i in 2 3 4 5 ; do h=ansible$i H=$h.hl.local; ssh $h hostname; ssh $H hostname; done 
for i in 2 3 4 5 ; do h=ansible$i H=$h.hl.local; ssh vagrant@$h hostname; ssh vagrant@$H hostname; done 
vagrant
clear
~/plays/adhoc 
for i in 2 3 4 5 ; do h=ansible$i ; ssh-copy-id vagrant@$h; done
~/plays/adhoc 
cat ~/plays/adhoc 
vi ~/plays/adhoc 
cat ~/plays/adhoc

ls ~/.ssh/
vi ~/plays/adhoc 
cat ~/plays/adhoc
~/plays/adhoc 
ansible -m ping all
ansible -m command -a id -b all
vi motd.yaml
ansible-playbook motd.yaml 
ansible -m command -a "cat /etc/motd" all
cat inventory 
vi sshd.yaml
ansible doc -l | grep systemd
ansible-doc -l | grep systemd
ansible sshd.yaml --syntax-check
ansible sshd.yaml 
ansible-playbook sshd.yaml --syntax-check
vi sshd.yaml 
ansible-doc -l | grep systemd
ansible-doc ansible.builtin.systemd_service
vi sshd.yaml 
ansible-doc ansible.builtin.systemd_service
vi sshd.yaml 
ansible-playbook sshd.yaml --syntax-check
vi sshd.yaml 
ansible-playbook sshd.yaml --syntax-check
ansible-playbook sshd.yaml 
dnf install ansible-navigator -y
cd plays/
ansible -b -m command -a "egrep '^(Banner|X11forwarding|MaxAuthTries)' /etc/ssh/sshd_config" all
ansible -b -m command -a "egrep '^(Banner|X11Forwarding|MaxAuthTries)' /etc/ssh/sshd_config" all
ansible -b -m command -a "systemctl status sshd"
ansible -b -m command -a "systemctl status sshd" all
ansible -b -m command -a "systemctl status sshd| grep Active" all
ansible -b -m shell -a "systemctl status sshd | grep Active" all
echo devops | tee ~/plays/vault_key
chmod 600 ~/plays/vault_key 
ansible-vault create --vault-password-file=~/plays/vault_key secret.yml
cat ~/plays/secret.yml 
ansible-vault view --vault-password-file=~/plays/vault_key secret.yml 
mkdir -p ~/plays/vars
cat > ~/plays/vars/user_list.yml
vi users.yml
cat users.yml 
ansible-playbook --vaul-password-file=~/plays/vault_key users.yml --syntax-check
ansible-playbook --vaul-password-file=~/plays/vault_key users.yml
ansible-playbook --vault-password-file=~/plays/vault_key users.yml --syntax-check
ansible-playbook --vault-password-file=~/plays/vault_key users.yml --list-tasks
ansible-playbook --vault-password-file=~/plays/vault_key users.yml
ssh alice@ansible3.hl.local id
ssh sandy@ansible5.hl.local id
