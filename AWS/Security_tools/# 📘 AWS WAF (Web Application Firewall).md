# 📘 AWS WAF (Web Application Firewall)

## 🔹 Overview

AWS **WAF** (Web Application Firewall) is used to protect your web applications from **common Layer 7 (HTTP)** web exploits.

- **Layer 7**: Application Layer (HTTP)
- **Layer 4**: Transport Layer (TCP/UDP)

WAF helps protect your applications against HTTP-level threats such as SQL injection, XSS (cross-site scripting), and other common vulnerabilities.

---

## 🔹 Where Can You Deploy AWS WAF?

You can deploy AWS WAF on the following services:

- **Application Load Balancer (ALB)**
- **API Gateway**
- **Amazon CloudFront**
- **AWS AppSync (GraphQL API)**
- **Amazon Cognito User Pools**

> ⚠️ **Important:**  
> You **cannot** deploy WAF on **Network Load Balancer (NLB)**, since NLB works at **Layer 4**, while WAF operates at **Layer 7**.

---

## 🔹 Web ACLs and Rules

Once WAF is deployed on a supported service, you define **Web ACLs (Access Control Lists)** and **rules** to filter traffic.

### Types of Rules

- **IP Set Filtering**
  - Create IP sets with up to **10,000 IPs** per set
  - Use multiple rules for more IPs

- **Header / Body / URI Filters**
  - Inspect specific parts of the HTTP request

- **SQL Injection Protection**
  - Detect and block SQLi payloads

- **Cross-site Scripting (XSS) Protection**

- **Size Constraints**
  - Limit request size (e.g., max 2 MB)

- **Geo Match**
  - Allow or block specific **countries**

- **Rate-based Rules**
  - Block IPs sending more than X requests/sec
  - Useful for **DDoS protection**

---

## 🔹 Rule Groups

- A **Rule Group** is a reusable set of rules
- Can be added to multiple Web ACLs
- Helps **organize** and manage rules efficiently

---

## 🔹 Regional vs Global Scope

- Web ACLs are **regional**
- **Exception**: When using WAF with **CloudFront**, Web ACLs are **global**

---

## 🔹 Fixed IP with WAF + ALB

### ❓ Problem

- WAF requires **ALB**, not NLB
- ALB does **not** have fixed IPs
- You need a **fixed IP** + **WAF protection**

### ✅ Solution

- Use **AWS Global Accelerator** to provide **static IP addresses**
- Point Global Accelerator to the **ALB**
- Attach **WAF (Web ACL)** to the **ALB**

### 🧱 Architecture Summary

1. Deploy application behind an **Application Load Balancer**
2. Use **Global Accelerator** to expose **fixed IPs** to users
3. Deploy **AWS WAF** and attach a **Web ACL** to the ALB
4. The WAF and ALB must be in the **same region**

---

## 🔚 Summary

- AWS WAF operates at **Layer 7 (HTTP)** and protects against common web exploits
- Deployable only on **ALB, API Gateway, CloudFront, AppSync, Cognito**
- Not supported on **NLB** (Layer 4)
- **Web ACLs** define filtering rules (IP, size, geo, rate, headers, etc.)
- Use **Global Accelerator** + ALB to get **fixed IPs with WAF protection**

---

✅ That's it for this topic!  
📘 Hope you found it helpful. See you in the next lecture!
