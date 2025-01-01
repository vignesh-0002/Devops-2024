# Load Balancers: Types, Networks, Layers, and Common Questions

## 1. Types of Load Balancers
- **Hardware Load Balancer**  
  - Physical devices. Example: F5, Cisco.
- **Software Load Balancer**  
  - Runs on standard hardware. Example: HAProxy, NGINX.
- **Cloud-Based Load Balancer**  
  - Managed by cloud providers. Example: AWS ELB, Azure Load Balancer, GCP Load Balancer.

## 2. Load Balancer by Layer
- **Layer 4 (Transport Layer)**  
  - Operates on TCP/UDP.  
  - Example: AWS Network Load Balancer, HAProxy (Layer 4 mode).  
  - Efficient for simple routing without inspecting traffic content.
- **Layer 7 (Application Layer)**  
  - Operates on HTTP/HTTPS.  
  - Example: AWS Application Load Balancer, NGINX.  
  - Provides advanced routing (e.g., based on URL, headers, cookies).

## 3. Load Balancer Networks
- **Public Load Balancer**  
  - Routes traffic from the internet to resources in a network.  
  - Example: AWS ALB/NLB for web applications.
- **Internal Load Balancer**  
  - Routes traffic between resources within a private network.  
  - Example: Azure Internal Load Balancer for microservices communication.

## 4. Common Features
- SSL/TLS Termination  
- Sticky Sessions (Session Persistence)  
- Health Checks  
- Auto Scaling Integration  
- Traffic Distribution Algorithms: Round Robin, Least Connections, IP Hash.

## 5. Common Questions on Load Balancers
1. **What is the purpose of a load balancer?**  
   - Distributes incoming traffic to multiple backend servers for scalability and reliability.
2. **Difference between Layer 4 and Layer 7 load balancers?**  
   - Layer 4 works on TCP/UDP, Layer 7 works on HTTP/HTTPS with content-based routing.
3. **How does SSL termination work on a load balancer?**  
   - Decrypts SSL/TLS traffic at the load balancer before forwarding to backend servers.
4. **Explain the concept of sticky sessions.**  
   - Ensures a client is routed to the same backend server for session consistency.
5. **How to choose between hardware and software load balancers?**  
   - Based on performance needs, cost, and flexibility.
6. **What are health checks in load balancers?**  
   - Regular checks to ensure backend servers are healthy before routing traffic.
7. **How does a load balancer support high availability?**  
   - By distributing traffic and handling failover in case of server downtime.
8. **What are the security considerations for a load balancer?**  
   - DDoS protection, secure configuration, and access controls.

## 6. Tools and Examples
- **Popular Tools:**  
  - HAProxy, NGINX, Traefik, Envoy.
- **Cloud Examples:**  
  - AWS Elastic Load Balancer (ALB, NLB, CLB), Azure Load Balancer, GCP Load Balancing.

---
