# File Security & Linux ACLs with Monitoring (Week 3)

## Objective
Create project groups, enforce ACLs and history retention policies, log unauthorized file access, and present a small web dashboard for violations.

## Users & ACLs
```bash
sudo groupadd projectA && sudo groupadd projectB
sudo useradd -m alice && sudo usermod -aG projectA alice
sudo useradd -m bob   && sudo usermod -aG projectB bob

sudo mkdir -p /srv/{projectA,projectB}
sudo chgrp projectA /srv/projectA && sudo chmod 2770 /srv/projectA
sudo chgrp projectB /srv/projectB && sudo chmod 2770 /srv/projectB

# Fine-grained ACLs
sudo setfacl -m g:projectA:rwx /srv/projectA
sudo setfacl -m g:projectB:rx  /srv/projectA
sudo getfacl /srv/projectA
```

## Shell History Policies
```bash
# For senior analysts (shorter history)
echo 'HISTSIZE=10' | sudo tee -a /home/alice/.bashrc
# For others
echo 'HISTSIZE=50' | sudo tee -a /home/bob/.bashrc
```

## Unauthorized Access Logging (auditd)
```bash
sudo apt install -y auditd audispd-plugins
sudo auditctl -w /srv/projectA -p rwa -k projectA_access
ausearch -k projectA_access --format text | tee access_audit.txt
```

## Optional Dashboard (Flask)
- Build a simple Flask app that parses audit logs and displays attempts, users, timestamps.
- Consider ELK for centralized search and dashboards.

## Deliverables
- `getfacl` outputs, audit logs, and screenshots of dashboard.

