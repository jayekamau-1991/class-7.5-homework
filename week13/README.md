Week 13 Homework

Classic VPN vs HA VPN

A Classic VPN is a single tunnel connecting 2 networks over IPSec. It is easy to set up but it uses a single interface and one single tunnel, so if that tunnel goes down the connection is lost. Use case: low cost, easy setup, and downtime is not a big issue.

Route-based: traffic is routed by destination IP. More flexible.
Policy-based: traffic is matched by specific rules about source/destination IP ranges.

HA VPN uses 2 tunnels across 2 interfaces. If one fails the other takes over automatically. It requires BGP for dynamic routing — the 2 sides exchange routes automatically over the tunnel. Use case: production workloads where high availability is required and downtime cannot be tolerated. SLA is 99.99% vs Classic VPN's 99.9%.