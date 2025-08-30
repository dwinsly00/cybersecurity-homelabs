# Capstone Simulation (Week 12)

## Objective
End-to-end exercise: Attack path → Initial Access → Privilege Escalation → Credential Dump → Lateral Movement → Containment → Hardening → Validation.

## Scenario
- Red Team: Kali launches exploit against an unpatched target (e.g., SMB vuln or web SQLi).
- Blue Team: Detect via logs, block IPs, patch, enforce policies, and verify with OpenVAS.

## Steps
1. Recon target and find exploitable surface.
2. Obtain shell and enumerate.
3. Dump creds/hashes; attempt lateral movement (in isolated lab only).
4. Blue Team actions: block, rotate creds, patch, apply GPO/ACLs, re-segment.
5. Validate with rescans and failed re-exploitation attempts.

## Final Report (final_report.md)
- Executive Summary
- Timeline of Events
- Findings & Impact
- Mitigations Implemented
- Before/After Metrics
- Next Steps (MFA rollout, EDR, regular scans)

