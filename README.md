# SEIR-1 Lab Submissions
## Systems Engineering & Identity Responsibility

---

## 2. Badges

![Program](https://img.shields.io/badge/Program-SEIR--1-purple)
![Lab 1](https://img.shields.io/badge/Lab%201-PASS-brightgreen)
![Lab 2](https://img.shields.io/badge/Lab%202-PASS-brightgreen)
![GCP](https://img.shields.io/badge/Platform-Google%20Cloud-blue)
![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform)
![Nginx](https://img.shields.io/badge/Web%20Server-Nginx-009639?logo=nginx)
![Gate](https://img.shields.io/badge/Gate%20Scripts-Passing-brightgreen)
![Identity](https://img.shields.io/badge/Identity-Entra%20ID-0078D4)

---

## 3. Overview

This repository contains all lab submissions for the SEIR-I program — an 18-month applied program focused on cloud infrastructure, identity, and federated trust.

> "Infrastructure decides what can exist. Identity decides who is trusted."

Each lab submission includes gate script results, screenshots, and supporting artifacts as proof of completion.

---

## 4. Program Stack

| Layer | Technology | Purpose |
|---|---|---|
| Resource Plane | Google Cloud Platform (GCP) | Infrastructure — VMs, networking, storage |
| Trust Plane | Microsoft Entra ID | Identity — authentication, groups, federation |
| Infrastructure as Code | Terraform | Reproducible deployments |
| Web Server | Nginx | Serves the SEIR-I Ops Panel |
| Validation | Gate Scripts (bash) | Proves infrastructure is reachable and correct |

---

## 5. Repository Structure

```
SEIR-1-labs/
├── Lab 1 — Manual GCP VM
│   ├── badge.txt                      # Gate result — GREEN
│   ├── gate_result.json               # Full gate output
│   └── SEIR-I OPS Panel-Node Online.png  # Homepage screenshot
├── Lab 2 — Terraform GCP VM (coming)
├── Lab 3 — (coming)
├── Lab 4 — Multi-cloud VPN (coming)
└── Lab 5 — GCP + Docker + Jenkins (coming)
```

---

## 6. Lab Submissions

### Lab 1 — Manual GCP VM Deployment

**Status:** ✅ PASS

**What was built:**
- GCE VM deployed manually in GCP Console
- Nginx web server serving the SEIR-I Ops Panel on port 80
- Three endpoints validated: `/` , `/healthz`, `/metadata`
- Gate script run and passed

**Gate Results:**

| Check | Result |
|---|---|
| Homepage reachable (HTTP 200) | ✅ PASS |
| /healthz returns `ok` | ✅ PASS |
| /metadata returns valid JSON | ✅ PASS |
| metadata contains instance_name | ✅ PASS |
| metadata contains region | ✅ PASS |

**Artifacts:**
- `badge.txt` — GREEN
- `gate_result.json`
- `SEIR-I OPS Panel-Node Online.png`

---

### Lab 2 — Terraform GCP VM Deployment

**Status:** ✅ PASS

**What was built:**
- Same SEIR-I Ops Panel from Lab 1 deployed via Terraform
- Firewall rule and VM created as code
- Gate script validated all endpoints
- plan.txt and apply output saved as evidence

**Gate Results:**

| Check | Result |
|---|---|
| / returns 200 | ✅ PASS |
| /healthz returns `ok` | ✅ PASS |
| /metadata returns valid JSON | ✅ PASS |
| metadata contains region | ✅ PASS |
| metadata contains VPC | ✅ PASS |
| metadata contains subnet | ✅ PASS |

---

### Lab 3 — Coming Soon

---

### Lab 4 — Multi-Cloud VPN (AWS Tokyo → GCP Iowa)

**Status:** ✅ Complete

**What was built:**
- Site-to-Site VPN between AWS ap-northeast-1 (Tokyo) and GCP us-central1 (Iowa)
- BGP routing configured between clouds
- Traffic routed across clouds over encrypted tunnel

---

### Lab 5 — GCP + Docker + Jenkins

**Status:** 🔄 In Progress

---

## 7. Gate Script Philosophy

> "Real engineers never say: 'It works on my screen.' They prove it."

Every lab is validated by a gate script that checks:
- The service is reachable
- The health endpoint works
- The metadata endpoint returns valid JSON
- The deployed infrastructure identifies itself

Gate scripts are sourced from:
https://github.com/BalericaAI/SEIR-1

---

## 8. Program Mantras

> "Infrastructure decides what can exist. Identity decides who is trusted."

> "If it's not logged, it didn't happen."

> "Projects are blast radius boundaries. Treat them that way."

> "Service accounts are for machines. Not for humans."

> "Least privilege is not a suggestion. It is the standard."

---

## 9. References

- [SEIR-1 Class Repository](https://github.com/BalericaAI/SEIR-1)
- [Google Cloud Platform Documentation](https://cloud.google.com/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Class 7.5 Notes](https://docs.google.com/document/d/1AXLe73cjz__BX4gmC6zgimqMlsiT4QREZwzQ7D70RTc)

---

## 10. Author & Contributors

| Field | Details |
|---|---|
| **Author** | Kamau |
| **Group Leader** | Jacques |
| **Group Name** | TKO Group |
| **Program** | SEIR-I — Systems Engineering & Identity Responsibility |
| **Version** | 1.0 |
| **Date** | April 2026 |

---

*SEIR-I Lab Submissions | TKO Group | Gate Scripts Passing*
