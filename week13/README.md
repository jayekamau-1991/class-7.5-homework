Week 13 Homework

Classic VPN vs HA VPN

A Classic VPN is a single tunnel connecting 2 networks over IPSec. It is easy to set up but it uses a single interface and one single tunnel, so if that tunnel goes down the connection is lost. Use case: low cost, easy setup, and downtime is not a big issue.

Route-based: traffic is routed by destination IP. More flexible.
Policy-based: traffic is matched by specific rules about source/destination IP ranges.

HA VPN uses 2 tunnels across 2 interfaces. If one fails the other takes over automatically. It requires BGP for dynamic routing — the 2 sides exchange routes automatically over the tunnel. Use case: production workloads where high availability is required and downtime cannot be tolerated. SLA is 99.99% vs Classic VPN's 99.9%.


# Week 13 FinOps Budget Alerts Runbook

What is FinOps?

From what I understand FinOps is about managing how much money 
you are spending in the cloud. It is not just about saving money 
but making sure the right people know what is being spent and 
why. I come from school administration where managing budgets 
was a big part of my job. In GCP FinOps gives you tools to do 
that same thing but for cloud resources.

In this runbook I am going to walk through how to set up budget 
alerts in GCP so that you get notified before you overspend.

---

Services I Used

Cloud Billing
This is where GCP keeps track of everything you are spending. 
Every project is linked to a billing account and all charges 
show up here. I think of it like a general ledger.

Budgets and Alerts
This is where you set a limit and tell GCP to warn you when 
you are getting close to that limit. One thing I learned is 
that setting a budget does not actually stop the spending. 
It just sends you a notification. I did not know that at first.

Cloud Pub/Sub
I am still learning this one. From what I understand it is a 
messaging service. When a budget threshold is hit GCP sends a 
message to Pub/Sub. That message can then be used to trigger 
other things like sending an SMS or running an automated action. 
I think of it like a PA system announcement that other services 
can listen to and respond to.

Cloud Monitoring
You can use this to connect email notifications to your budget 
alerts. I did not go deep into this one yet but I know it is 
part of the overall monitoring picture in GCP.

---

How I Think It All Connects

Based on what I built in the lab this is how I understand it:

You set a budget in Cloud Billing. When spending hits a 
threshold an alert fires. That alert can go to email or to 
a Pub/Sub topic. From Pub/Sub it can trigger other automated 
actions. I have not built the automated part yet but I 
understand that is the next step.



Steps I Followed

Step 1: Create a Pub/Sub Topic

I learned you have to create the Pub/Sub topic first before 
setting up the budget. I made the mistake of doing it in the 
wrong order the first time.

1. In GCP Console search for Pub/Sub at the top
2. Click Create Topic
3. For Topic ID I used: kamau-billing-alerts
4. I left everything else as default
5. Click Create

Screenshot: show the topic in the topic list after creation

Step 2: Create a Budget

1. In GCP Console search for Billing
2. In the left sidebar click Budgets and Alerts
3. Click Create Budget
4. I filled in the following:
   Name: kamau-week13-budget
   Projects: Kamau Lab 4
   Budget type: Specified amount
   Amount: $10
5. Click Next

Screenshot: show the budget screen with the fields filled in

---

Step 3: Set the Alert Thresholds

This part made sense to me. You are basically saying warn me 
when I hit 50% then again at 90% then again at 100%.

1. I set three thresholds:
   50% of budget which is $5 at Actual spend
   90% of budget which is $9 at Actual spend
   100% of budget which is $10 at Actual spend
2. Under Manage Notifications I checked email alerts to 
   billing admins and users
3. I connected the Pub/Sub topic kamau-billing-alerts
4. Click Finish

Screenshot: show the thresholds set and Pub/Sub connected

---

A Problem I Ran Into

When I went to connect the Pub/Sub topic to the budget it 
was not showing up in the dropdown. I spent some time 
troubleshooting this. What I found out is that the Pub/Sub 
topic has to be in a project that is linked to the billing 
account. I had created it in a different place.

If you run into this here is what to check:
1. Go to Billing then Account Management then Linked Projects
2. Make sure your project is listed there
3. Go back to Pub/Sub and create the topic in that project
4. Then go back to the budget and try again

I was able to create the topic and the budget but the 
connection between the two did not fully complete due to 
this issue. I documented it here so the next person does 
not run into the same problem.

---

Why I Think This Matters

Coming from education I know that budgets without visibility 
are how organizations end up in financial trouble. The same 
thing can happen in the cloud. Resources are easy to spin up 
and easy to forget about. This runbook sets up the first layer 
of protection which is awareness. You know what you are 
spending and you get warned before it becomes a problem.

---

Extra Credit: Automated Billing Disable

I read about this but have not built it yet. From what I 
understand you can use Cloud Pub/Sub together with a Cloud 
Function to automatically shut off billing when a threshold 
is crossed. That would stop all spending immediately.

What I also learned is that doing this in a real production 
environment is risky. When you disable billing everything 
stops. VMs shut down. Databases go offline. It is not 
something you would turn on without a plan for how to 
recover. For this lab I understand the concept but I would 
want to learn more before I built it in a real environment.