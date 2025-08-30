SHELL := /bin/bash
week ?= all
.PHONY: week1 scan report elk-up elk-down
week1:
	@echo "=== Week 1 Honeypot + fail2ban setup ==="
	ssh ubuntu@honeypot 'sudo systemctl status cowrie || true'
scan:
	nmap -A -T4 $(target)
report:
	@echo "Generate report using OpenVAS web UI (see docs)"
elk-up:
	docker compose -f elk-compose.yml up -d
elk-down:
	docker compose -f elk-compose.yml down
