# Week 13 Notes
## SEIR-1 | June 10, 2026 | Kamau

---

## GCP VPC

**What is it?**
A VPC is my private network inside Google Cloud Platform. A single 
VPC spans all GCP regions. It isolates resources from the public 
internet unless access is explicitly allowed.

**Key Services and Terms**
- Subnet: regional network segment inside the VPC with its own IP range
- Auto mode: GCP automatically creates subnets in every region
- Custom mode: I define every subnet manually. Used in production.
- Firewall rules: live at the VPC level, not the subnet level
- Default VPC: every new GCP project gets one automatically in auto mode

**How it Works**
You create a VPC and define subnets per region. VMs and other 
resources are placed inside subnets. Firewall rules control what 
traffic can enter or leave. Nothing is reachable from the internet 
unless you explicitly create a firewall rule to allow it.

**Things to Remember**
- GCP VPC is global. AWS VPC is regional. This is a key difference.
- Custom mode is what production uses
- You cannot change a subnet's region after creation

**Real World Analogy**
A VPC is like a private office building. The building spans multiple 
floors (regions). Each floor has its own rooms (subnets). Security 
guards at the door (firewall rules) decide who gets in and out. 
Nobody gets in unless they are on the list.

---

## GCP Billing

**What is it?**
GCP Billing is how Google charges me for the resources I use. A 
billing account pays for one or more GCP projects.

**Key Services and Terms**
- Billing account: linked to projects and a payment method
- Budget: a spending limit you define
- Alert thresholds: percentages at which GCP notifies you (50%, 90%, 100%)
- Billing export: sends billing data to BigQuery for SQL analysis
- Pub/Sub: receives billing alert events for automation

**How it Works**
You create a billing account and link it to your projects. You set 
a budget with a dollar amount. When spending hits a threshold GCP 
sends an alert to email or Pub/Sub. The alert does NOT stop spending. 
It only notifies you. To actually stop spending you need Pub/Sub 
and a Cloud Function working together.

**Things to Remember**
- Budget alerts do not cap spending. They only notify.
- Billing export goes to BigQuery for analysis
- Pub/Sub is the bridge between alerts and automation
- To analyze spend with SQL queries use billing export to BigQuery

**Real World Analogy**
Think of it like a school district budget. The budget alert is like 
a low balance notification on a purchase order. The money can still 
go out. Someone has to manually step in to stop it unless you have 
an automated process in place.

---

## GCP Operations

**What is it?**
GCP Operations is the suite of tools that lets you monitor, log, 
trace, and debug what is happening in your GCP environment. It was 
formerly called Stackdriver.

**Key Services and Terms**
- Cloud Monitoring: tracks metrics like CPU, memory, uptime. Set alerts here.
- Cloud Logging: collects logs from all GCP services automatically
- Sink: exports logs to BigQuery, Cloud Storage, or Pub/Sub for long-term storage
- Cloud Trace: tracks how long requests take through your application
- Cloud Debugger: inspects a running application without stopping it

**How it Works**
Cloud Monitoring watches your resources and fires alerts when 
something crosses a threshold. Cloud Logging collects all logs 
automatically. To store logs long term you create a sink to BigQuery. 
Cloud Trace helps you find latency issues. Cloud Debugger helps you 
find bugs in production without taking anything offline.

**Things to Remember**
- Logs go to BigQuery via a sink for long-term analysis
- Cloud Trace is for latency. Cloud Debugger is for bugs.
- Exam pattern: store and analyze logs = sink to BigQuery

**Real World Analogy**
Think of GCP Operations like a school building management system. 
Cloud Monitoring is the alarm system. Cloud Logging is the security 
camera footage. The sink is the archive where footage is stored long 
term. Cloud Trace is checking how long it takes students to get 
from class to class. Cloud Debugger is reviewing the footage to 
find out what went wrong without disrupting the school day.

---

## Classic VPN vs HA VPN

**What is it?**
Both are GCP services that connect two networks securely over 
IPSec tunnels. Classic VPN is simpler. HA VPN is built for 
production with high availability.

**Key Services and Terms**
- Classic VPN: single tunnel, single interface, 99.9% SLA
- HA VPN: two tunnels, two interfaces, 99.99% SLA
- Route-based: traffic routed by destination IP. More flexible.
- Policy-based: traffic matched by specific source/destination IP rules
- BGP: required for HA VPN. Exchanges routes dynamically between networks.
- Cloud Router: the GCP component that runs BGP

**How it Works**
Classic VPN creates one tunnel between two networks. If that tunnel 
goes down connectivity is lost. HA VPN creates two tunnels across 
two interfaces. If one fails the other takes over automatically. 
BGP runs over the tunnel to exchange routing information between 
the two networks.

**Things to Remember**
- Classic VPN = 1 tunnel, 99.9%, static or dynamic routing
- HA VPN = 2 tunnels, 99.99%, BGP required
- Most common Phase 1 failure = PSK mismatch
- Correct order of establishment: IKE Phase 1 → IPSec Phase 2 → BGP

**Real World Analogy**
Classic VPN is like a single bridge connecting two towns. If the 
bridge goes down no one gets across. HA VPN is like having two 
bridges. If one closes for repairs traffic automatically uses 
the other one.

---

## IPSec and BGP Key Concepts

**RFCs to Know**
- RFC 4301: IPSec Architecture
- RFC 4302: AH — authentication only, no encryption, breaks with NAT
- RFC 4303: ESP — encryption and authentication, works with NAT
- RFC 7296: IKEv2 — modern standard
- RFC 2409: IKEv1 — legacy
- RFC 3947 + 3948: NAT Traversal — detect NAT and wrap ESP in UDP
- RFC 4271: BGP — dynamically exchange routing information

**Ports to Know**
- UDP 500: IKE negotiation
- UDP 4500: NAT Traversal
- TCP 179: BGP
- IP Protocol 50: ESP

**Key Terms**
- PSK: Pre-Shared Key. Authenticates VPN peers. Must match on both sides.
- SA: Security Association. The agreed set of IPSec parameters between peers.
- BGP Established: the state that means BGP is working and routes are exchanging
- 169.254.x.x: link-local addresses used for BGP peer communication in HA VPN
- Autonomous System (AS): a network run by one organization with its own ASN
- BGP Hijacking: when bad routes are advertised intentionally or accidentally

---

## FinOps

**What is it?**
FinOps is the practice of managing cloud spending. It brings 
together visibility, alerts, and automation to control costs 
without slowing down work.

**Key Services and Terms**
- Cloud Billing: tracks all spending across projects
- Budgets and Alerts: set spending limits and thresholds for notifications
- Cloud Pub/Sub: receives billing events and passes them to automation
- Cloud Function: can automatically disable billing when triggered by Pub/Sub

**How it Works**
You set a budget with thresholds. When spending hits 50%, 90%, 
or 100% GCP fires an alert. That alert goes to email and to 
Pub/Sub. From Pub/Sub a Cloud Function can take automated action 
like disabling billing. Disabling billing in production stops 
all resources immediately so it requires careful planning.

**Things to Remember**
- Budget alerts do not stop spending
- Pub/Sub is required for automation
- Disabling billing = all resources stop immediately
- This is dangerous in production without a recovery plan

**Real World Analogy**
FinOps in GCP is like having a budget dashboard in a school 
district. You can see what is being spent, get warned when you 
are close to the limit, and set up automatic stops if needed. 
The automatic stop is like freezing a purchase card when it hits 
its limit. Useful but you need a plan for what happens next.