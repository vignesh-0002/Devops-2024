# How to configure nginx using ansible.
   1. Install and configure Nginx as a reverse proxy on the public EC2 instance.
   2. Install and configure Nginx as a web server on the private EC2 instance.
   3. Set up the reverse proxy to forward traffic to the private web server.

Here’s the step-by-step approach:

### Ansible Playbook Structure
1. Create an inventory file.
2. Write the playbook with tasks for both the proxy and web server.
3. Use ansible modules to install and configure Nginx.
   
### Directory Structure

```
ansible-nginx-setup/
├── inventory
├── playbook.yml
├── roles/
│   ├── proxy/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   └── templates/
│   │       └── nginx-proxy.conf.j2
│   ├── web/
│       ├── tasks/
│       │   └── main.yml
│       └── templates/
│           └── nginx-web.conf.j2

```
1. Inventory File
```
[proxy]
public-ec2 ansible_host=<PUBLIC_IP> ansible_user=ubuntu ansible_private_key_file=/path/to/key.pem

[web]
private-ec2 ansible_host=<PRIVATE_IP> ansible_user=ubuntu ansible_private_key_file=/path/to/key.pem

```

![image](https://github.com/user-attachments/assets/eeea4d7f-ac30-4fc5-ba88-107e4ca2f279)

2. Proxy Server Configuration

```roles/proxy/tasks/main.yml```
```
- name: Install Nginx on Proxy Server
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Configure Nginx Proxy
  template:
    src: nginx-proxy.conf.j2
    dest: /etc/nginx/sites-available/default
    owner: root
    group: root
    mode: 0644

- name: Ensure Nginx is running
  service:
    name: nginx
    state: started
    enabled: yes
```
![image](https://github.com/user-attachments/assets/c3f84fa4-6b62-4764-adbf-6d9f2541f9f1)

```roles/proxy/templates/nginx-proxy.conf.j2```
```
server {
    listen 80;

    location / {
        proxy_pass http://<PRIVATE_IP>:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
Replace `<PRIVATE_IP>` with the private IP of the private EC2 instance.

![image](https://github.com/user-attachments/assets/e5811a1c-0341-4da3-bbd2-a890f4de905a)

3. Web Server Configuration

```roles/web/tasks/main.yml```
```
- name: Install Nginx on Web Server
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Configure Nginx Web Server
  template:
    src: nginx-web.conf.j2
    dest: /etc/nginx/sites-available/default
    owner: root
    group: root
    mode: 0644

- name: Ensure Nginx is running
  service:
    name: nginx
    state: started
    enabled: yes
```
![image](https://github.com/user-attachments/assets/123e0a5b-a0cb-4cc2-b726-421a103b1d4b)

4. Main Playbook
```
- name: Configure Nginx Proxy and Web Server
  hosts: all
  become: yes

  roles:
    - { role: proxy, when: "'proxy' in group_names" }
    - { role: web, when: "'web' in group_names" }

```
![image](https://github.com/user-attachments/assets/13980fc0-2002-4306-9218-a47c6e3cec98)

5. Run the Playbook

1. Ensure SSH access to both EC2 instances using the private key provided in the inventory file.
2. Execute the playbook.
   ```
   ansible-playbook -i inventory playbook.yml

   ```
