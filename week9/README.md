# SEIR-1 Week 9 Homework

**Student:** Kamau
**Group:** TKO Group (led by Jacques)
**Week:** 9 — Cloud NAT, Global Load Balancing, Cloud CDN, Cloud Armor
**Assigned:** Fri 5/8/26 | **Due:** Thu 5/14/26
**Last updated:** May 12, 2026

---

## Progress

- [x] Load Balancers Q&A (5/5)
- [ ] Cloud Armor Q&A (0/5)
- [ ] Cloud CDN Q&A (0/6)
- [ ] Runbook — global LB + MIG via ClickOps (group work)

---

## Q & A

### Load Balancers

**1. How does load balancing contribute to fault tolerance? What about high availability?**

Load balancing helps with fault tolerance because the LB uses health checks to see which backend servers are working. When a server fails the health check, the LB stops sending traffic to it and shifts that traffic to healthy servers, which keeps the application running. It also helps with high availability because the LB can spread traffic across multiple backends in different zones or regions, so even if one zone goes down, users still get served.

**2. Do global load balancers decrease latency for end users? Why or why not?**

Yes, global LBs decrease latency. The global LB uses anycast — a single IP advertised from many of Google's data centers around the world — so a user gets routed to the closest data center automatically. It's like traveling to a nearby city instead of having to travel to another state: the closer the data center, the faster the connection.

**3. What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy?**

Health checks are for checking if the server is alive so the LB can stop sending traffic to dead servers and only route users to working ones. Yes, we always need health checks in real production because the LB needs to route around failures — without them, traffic would keep going to dead servers and users would see errors. A reverse proxy is a server that sits in front of other servers and forwards requests to them — the client doesn't talk to the backend directly. The LB distributes traffic, which means it spreads the load across many backends, and it uses health checks so it knows which backends are eligible to receive the traffic.

**4. What are LB routing rules and URL maps for? Give an example or two of them in use.**

A global LB has one public IP. A real website has multiple parts like a homepage, API server, and storage like Cloud Storage buckets that contain the images. URL maps are the load balancer's routing table — a list of the rules. Routing rules are entries in the table that say "if the URL matches X, send to the backend called Y." For example, `/api/*` would route to the API backend, and `/images/*` would route to the Cloud Storage bucket.

**5. Explain what an anycast IP address is used for in the context of a global load balancer.**

Anycast is one IP address that exists in many places at once. Once you connect to it you get sent to the closest one automatically. Global LBs use it because one IP serves the whole planet, giving every user fast service because they always reach the nearest data center.

---

### Cloud Armor

*Pending — to be completed.*

**1. What does Cloud Armor offer?**

_TBD_

**2. Why is it used in the first place?**

_TBD_

**3. What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules?**

_TBD_

**4. What are rate-based rules for?**

_TBD_

**5. What is reCAPTCHA and how does it relate to this service?**

_TBD_

---

### Cloud CDN

*Pending — to be completed.*

**1. What are POPs used for?**

_TBD_

**2. What kind of files are served with Cloud CDN?**

_TBD_

**3. What services can be used with Cloud CDN for the source of content (the origin)?**

_TBD_

**4. Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain.**

_TBD_

**5. Should an enterprise always use Cloud CDN? Why or why not?**

_TBD_

**6. What is TTL and how does it control content "freshness"?**

_TBD_

---

## Runbook — Global LB + MIG via ClickOps

*Group work — pending.*

**Goal:** Spin up a fully configured external application global load balancer via ClickOps, using a MIG as the backend. Health checks required.

---

## Documentation & Resources Used

*To be filled in as work progresses.*

- Cloud NAT: https://docs.cloud.google.com/nat/docs/private-nat
- Global LB: https://docs.cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute
- Cloud CDN: https://cloud.google.com/cdn
- Cloud Armor: https://cloud.google.com/security/products/armor

---

*Note: All Q&A answers written by Kamau in his own words, with Claude used only for teaching concepts and clarifying questions, not for generating answers.*
