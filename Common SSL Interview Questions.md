# Common SSL Interview Questions

## 1. Basics of SSL
- **What is SSL?**  
  - Secure Sockets Layer, a protocol for encrypting data between a client and a server.
- **What is the difference between SSL and TLS?**  
  - TLS is the successor to SSL, more secure and efficient. SSL versions are deprecated.

## 2. Certificates
- **What is an SSL Certificate?**  
  - A digital certificate that authenticates the identity of a website and encrypts data.
- **What are the types of SSL Certificates?**  
  - **Domain Validation (DV):** Verifies domain ownership.  
  - **Organization Validation (OV):** Verifies organization identity.  
  - **Extended Validation (EV):** Highest validation, shows green bar or organization name in browsers.  
  - **Wildcard SSL:** Covers a domain and its subdomains.  
  - **SAN (Subject Alternative Name):** Covers multiple domains.
- **How to generate an SSL certificate?**  
  - Use tools like OpenSSL to generate a Certificate Signing Request (CSR).

## 3. Key Concepts
- **What is a Private Key and Public Key?**  
  - Private key: Used for decryption and signing.  
  - Public key: Shared with others for encryption.
- **What is HTTPS?**  
  - HTTP over SSL/TLS, ensures secure communication over the web.
- **What is a CA (Certificate Authority)?**  
  - A trusted entity that issues SSL certificates.

## 4. Implementation and Troubleshooting
- **How to implement SSL on a web server?**  
  - Install SSL certificate on the server (e.g., Apache, NGINX).  
  - Update server configuration to enable HTTPS.
- **What is SSL Termination?**  
  - Decrypting SSL traffic at a load balancer or proxy, then forwarding plain traffic.
- **How to check if SSL is working?**  
  - Use tools like `openssl s_client`, browser padlock, or online SSL checkers.
- **What is the SSL Handshake?**  
  - A process where the client and server agree on encryption methods and establish a secure session.

## 5. Security
- **What is Perfect Forward Secrecy (PFS)?**  
  - Ensures session keys cannot be decrypted even if the private key is compromised.
- **What is an SSL/TLS vulnerability?**  
  - Examples: Heartbleed, BEAST, POODLE.
- **What is HSTS?**  
  - HTTP Strict Transport Security, forces browsers to use HTTPS.

## 6. Common Questions
1. **Why is SSL important?**  
   - Protects data, ensures trust, and improves SEO rankings.
2. **How does SSL work?**  
   - Uses asymmetric encryption during handshake and symmetric encryption for session data.
3. **How to renew an SSL certificate?**  
   - Generate a new CSR, purchase/renew the certificate, and replace the expired one on the server.
4. **What is the role of OpenSSL?**  
   - A toolkit for generating keys, certificates, and managing SSL connections.
5. **What happens if an SSL certificate expires?**  
   - Browsers show a warning, and encrypted communication is disrupted.
6. **How to prevent SSL vulnerabilities?**  
   - Use strong ciphers, disable old protocols (SSL 2.0, 3.0), and keep software updated.

## 7. Tools for SSL
- **Testing:** SSL Labs, OpenSSL, Qualys.  
- **Debugging:** Wireshark, `curl` with `--verbose`.  
- **Management:** Certbot (for Let's Encrypt), Keytool (Java-based).

---
