# gcp-week9_hw

---

# Q & A
### Load Balancers:
- How does load balancing contribute to Fault tolerance? What about high availability? 
  - Load Balancing contributes to Fault Tolerance by using health checks to delete unhealthy VMs and create new ones, reducing downtime. When it comes to high availability, the load balancer will have other regions available, by way of MIGs, to always be connected to the different regions in the zone the LB was initially deployed to.
  
- Do global load balancers decrease latency for end users? Why or why not? 
   - Yes, load balancer is meant to send direct user traffic to the closest backend. 

- What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy? 
  - Health checks are used for checking the availability and performance of MIGs, the backend configuration. They are needed if you want to make sure your backend is working properly and healthy, in a real work environment. Yes, a LB is different from a reverse proxy, as a reverse proxy sits in front of servers and forwards request.

- What are LB routing rules and URL maps for? Give an example or two of them in use. 
  - LB routing rules and URL maps are used to decide which backend receives a request based on the URL path.
  - Example: "/api/*", that would be directed to the MIGs.
  
- Explain what an anycast IP address is used for in the context of a global load balancer. 
  - An anycast IP is used when sends a request to an IP address, when it does, it is then sent to the nearest location. For example, if there is a user in us-central1 and a user in northamerica-northeaest2 (Toronto) both send request to the same IP, each of them will get routed to the closest Point of Presence.

### Cloud Armor:
- What does cloud armor offer? 
  - Cloud Armor offers protection of your web applications and services from DDoS (denial-of-service), cross-site scripting (XSS), and SQl injecton attacks.
  
- Why is it used in the first place?
  - Since LBs are connected to the public internet, it can be reached by just about anyone who has access to your information.
  
- What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules? 
  - Since Cloud Armor is automatically provided for with a global external Application Load Balancer, it will be operating at Layer 7. However, it also operates at the Layer 3 and Layer 4 levels as well, but the difference is, VPC firewalls operate at the Layer 3 and 4 levels. VPC firewalls can block an IP or a port, but cannot block a SQL injection, like Cloud Armor can. 

- What are rate based rules for? 
  - Rate based rules are used to help protect ones applications from a large volume of request that will help defend against brute force attacks.

- What is reCAPTCHA and how does it relate to this service? 
  - reCAPTCHA is a service that acts as security checkpoint, making the difference between human users and automated bots. It's related with Cloud Armor by being able to block suspicious traffic and request.

### Cloud CDN: 
- What are POPs used for?
  - PoPs (Point of Presence) is used for user request to be as close to the user as possible, as an edge location. It is meant to get content as close to where the user lives, by their zone.

- What kind of files are served with Cloud CDN? 
  - The files that are meant to be served with Cloud CDN videos, images, audio, and documents (such as PDF's), CSS, ecmascript, and javascript.

- What services can be used with cloud CDN for the source of content (the origin)? 
  - MIGs can be used as a source of content, as well as buckets from Google Cloud Storage.

- Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain. 
  - Yes and no. While it does help reduce exposure to DDoS attacks, it is not a security tool like Cloud Armor. Cloud CDN will not detect bots, and has no rate-based rules.

- Should an enterprise always use cloud CDN? Why or why not? 
  - That depends if they need it or not. If there is a public-facing app with significant amount of static content that is distributed globally, then yes. If not, then having CDN only adds too much money with little benefit and complexity.

- What is TTL and how does it control content “freshness”? 
  - Time to Live. It holds a cached copy, based on the amount of time that is that is needed for a newer version.


# Runbook
### Goal
  - Build an Global External Application Load Balancer using a MIG as the backend.

## Prerequisites
- Your own GCP Project
- A working Instance Template
- Working MIG w/ Health Checks and Autoscaling

## Steps
1. In your GCP Console, click on the solid lines on the left > Go to Network Services > go to Load Balancing. Or just used the search bar and type "Load Balancing" > Click "Create Load Balancer".

2. Choose "Application Load Balancer > Public Facing > Best for Global Workloads > Global External Application Load Balancer

3. Name your Load Balancer

4. Frontend Configuration 
   - Name and description > Protocol: HTTP > IPv4 > IP Address: Ephemeral (Automatic) > Port: 80

5. Backend Configuration
   - Create backend service 1
     - Name and description > Backend Type: Instance Group > Protocol: HTTP > named port: http > Timeout: 30 secs > IP Address Selection Policy: Only IPv4 > Health Check: Select ALB Health Check (or create one if you haven't done so)

  - New Backend 1
      - Ip Stack Type: IPv4 (single-stack)
      - Instance Group: Select MIG
      - Port Number: 80
      - Balancing Mode: Rate
        - Traffic Duration = Default (Short)
        - Maximum RPS = 10
        - Scope = per instance
        - Backend Preference Level: None
- Backend 2
  - Follow the same steps above

- Cloud CDN: Unchecked
- Logging: Unchecked
- Identity-Aware Proxy: Unchecked
- Cloud Armor: None

6. Routing Rules
   - Mode: Simple Host and Path Rule

7. Click Create

## Teardown
1. Delete your Load Balancer /w your Backends
2. Delete your MIGs
3. Delete your Instance Template