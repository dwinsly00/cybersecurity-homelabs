# Honeypots & SSH Defense (Week 1)

## Objective
Deploy SSH/web/email/file honeypot services, harden real SSH, and implement automated blocking with fail2ban and firewalld. Collect logs for analysis.

## Topology
- Attacker: Kali (VLAN10)
- Target/Honeypot host: Ubuntu/Debian (VLAN20, public tunnel optional)
- Logging: ELK/Splunk (VLAN30)

## Setup
```bash
# Base
sudo apt update && sudo apt install -y python3-venv git fail2ban firewalld
sudo systemctl enable --now firewalld

# (Option A) Cowrie SSH Honeypot
sudo adduser --disabled-password --gecos "" cowrie
sudo -u cowrie -H bash -lc 'git clone https://github.com/cowrie/cowrie ~/cowrie && python3 -m venv ~/cowrie/cowrie-env && source ~/cowrie/cowrie-env/bin/activate && pip install --upgrade pip && pip install -r ~/cowrie/requirements.txt'
# Configure cowrie to listen on 2222, log to ~/cowrie/var/log/cowrie
# Start cowrie
sudo -u cowrie -H bash -lc '~/cowrie/cowrie-env/bin/python ~/cowrie/src/cowrie start'

# (Option B) Simple fake services using Docker (http/ftp/smb/mysql)
sudo apt install -y docker.io
sudo docker run -d --name fake-http -p 8080:80 nginx:alpine
sudo docker run -d --name fake-ftp  -p 21:21 -e FTP_USER=demo -e FTP_PASS=demo stilliard/pure-ftpd
# (Optional) Dionaea honeypot or T-Pot (advanced)
```

## Harden Real SSH
```bash
sudo sed -i 's/^#\?Port .*/Port 2200/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

sudo firewall-cmd --permanent --add-port=2200/tcp
sudo firewall-cmd --reload
```

## fail2ban
```bash
sudo tee /etc/fail2ban/jail.local >/dev/null <<'EOF'
[sshd]
enabled = true
port = 2200
maxretry = 3
bantime = 3600
findtime = 600
logpath = /var/log/auth.log
EOF
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd
```

## Attacks to Simulate (from Kali)
```bash
# Brute-force (controlled) – DO NOT run against unauthorized hosts
hydra -l test -P /usr/share/wordlists/rockyou.txt ssh://TARGET_IP -s 2200 -o hydra_ssh.txt
# Directory brute-force (if fake web app is exposed)
gobuster dir -u http://TARGET_IP:8080 -w /usr/share/wordlists/dirb/common.txt -t 50
```

## Outputs to Collect
- `/var/log/fail2ban.log` (bans)
- `~/cowrie/var/log/cowrie/cowrie.json` (session logs)
- Firewall events

## Extra (Betterment)
- Ship logs to ELK or Splunk via Filebeat.
- Enable GeoIP ban lists (careful with false positives).
- Build a Grafana dashboard (bans/day, sources, top usernames).

