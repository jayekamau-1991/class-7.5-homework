## Q & A

### What is the difference between high availability and fault tolerance? Which is best to strive for?
High availability means your system goes down but comes back up fast so there is minimal loss. Fault tolerance means it never goes down at all, users notice nothing. Fault tolerance is the goal but most companies use high availability because full fault tolerance is expensive. You need fully redundant systems running at all times which costs significantly more.

### Explain the difference between autoscaling and elasticity.
Elasticity is the ability to stretch and shrink based on demand. Autoscaling is what triggers that to happen automatically. They work together when autoscaling triggers elasticity, it is not a vs situation. Vertical scaling adds more power to one machine. Horizontal scaling adds more machines. Horizontal is preferred because it happens with no downtime. On prem both are hard — vertical means physically swapping hardware and horizontal means keeping idle servers on standby. This is a big reason companies move to cloud.

### What is the difference between managed and unmanaged instance groups?
Managed means GCP handles everything meaning all VMs are identical, built from the same template, and GCP manages autoscaling, autohealing, and multi-zone on its own. Unmanaged means you configure and manage everything yourself. Instances can be different from each other. Unmanaged makes sense if you already have existing VMs you need to group together. If you are starting fresh use managed.

### Explain the different use cases for health checks.
Instance group health checks check if the VM is alive. If it fails GCP replaces it automatically that describes autohealing. Load balancer health checks go further and check if the app inside the VM is actually ready for traffic. A VM can be running but the app inside could be broken. They can be the same check but should not be because they serve different purposes. They are configured separately with different API calls, one on the MIG and one on the backend service.

### Explain the 3 tier architecture.
Three tiers — presentation, application, and data. Presentation is what the user sees, the UI and web layer. The load balancer lives here and routes traffic. Application is the backend where the logic happens in GCP this is your managed instance group. Data is where everything gets stored databases, files, etc. 