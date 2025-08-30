# Active Directory – Setup & Policies (Week 10)

## Objective
Install and configure AD DS, create OUs, apply password/lockout/login-time policies via GPOs, and join Windows/Linux clients to the domain.

## Install AD DS (Windows Server 2019/2022)
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName corp.local -SafeModeAdministratorPassword (Read-Host -AsSecureString "DSRM Password")
# Reboot when prompted
```

## OUs & Users
- OUs: Finance, HR, IT
- Create users and security groups per OU.

## GPOs
- Password policy, Account Lockout policy.
- Login time restrictions for test users.

## Join Clients
- Windows: System Properties → Domain: corp.local
- Ubuntu: `realmd`/`sssd` for domain join.

## Deliverables
- Screenshots of enforced policy blocks and GPMC settings.

