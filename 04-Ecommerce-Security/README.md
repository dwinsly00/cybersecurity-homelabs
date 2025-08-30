# E-Commerce Security Review (Week 5)

## Objective
Review a test marketplace (PrestaShop/WooCommerce) for SQLi, XSS, session hijacking, broken access control. Validate coupon logic and admin exposure.

## Setup (PrestaShop via Docker compose example)
```bash
# docker-compose.yml (example)
version: '3.3'
services:
  db:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_DATABASE=prestashop
      - MYSQL_USER=ps
      - MYSQL_PASSWORD=pspass
    volumes:
      - dbdata:/var/lib/mysql
  prestashop:
    image: prestashop/prestashop:latest
    ports:
      - "8081:80"
    environment:
      - PS_INSTALL_AUTO=1
      - DB_SERVER=db
volumes:
  dbdata:
```
```bash
docker compose up -d
```

## Tests
- Recon with Nmap.
- SQLi with `sqlmap` against product endpoints.
- XSS in search/review fields.
- Session fixation/hijacking via cookies.
- Try expired coupon logic to simulate financial abuse.

## Remediation
- Parameterized queries / ORM.
- CSRF tokens and secure cookies.
- Proper authZ checks on admin routes.

## Deliverables
- Vulnerability matrix + PoC screenshots + remediation steps.

---

## One-Command Launch (PrestaShop)

```bash
docker compose -f prestashop-compose.yml up -d
# Visit: http://localhost:8081
# Complete the web installer → set your own admin email/password
# Note: PrestaShop randomizes the admin folder name for security.
# Find it with:
docker logs prestashop 2>&1 | grep -i "Admin"
```
You’ll see something like `/var/www/html/admin123abc/`. Access the admin at `http://localhost:8081/admin123abc/` with the credentials you set during install.

**Targets & Tests:**
- Search box (XSS): `index.php?controller=search&s=<script>alert(1)</script>`
- Product params (SQLi attempts): observe parameterized queries effectiveness (`id_product` etc.)
- Checkout/session flows: cookie flags (HttpOnly/Secure/SameSite), CSRF tokens
- Admin panel hardening: role permissions, IP allowlists, strong passwords, 2FA module

**Extras (make it better):**
- Place nginx in front with TLS (mkcert/Let’s Encrypt) → test mixed-content and header policies.
- Add WAF (mod_security / Coraza) in reverse proxy and measure blocked vs allowed requests.
- Export Burp findings → map to OWASP ASVS controls and create a remediation backlog.

