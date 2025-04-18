# 🚀 One-Day Ansible Mastery Plan (Beginner → Confident)

⏰ **Total Time:** 8–10 hours  
Split into learning + doing + documenting

---

## 🔹 Hour 1–2: Core Ansible Concepts

### 🧠 Learn:
- What is Ansible? Why use it?
- Agentless architecture (SSH-based)
- Inventory (static and dynamic)
- YAML syntax
- Modules vs. Plugins vs. Roles

### ✅ Practice:
- Install Ansible: `pip install ansible`
- Create a static inventory file
- Run: `ansible all -m ping` to test connections

### 📘 Resources:
- [Ansible official docs](https://docs.ansible.com/)
- [Jeff Geerling’s YouTube](https://www.youtube.com/c/JeffGeerling)

---

## 🔹 Hour 3–4: Playbooks + Variables + Handlers

### 🧠 Learn:
- Playbook structure
- Tasks, Handlers, Notify
- Variable types (host, group, registered, extra_vars)

### ✅ Practice:
- Write a playbook to install Apache or Nginx
- Use `notify` + `handlers` to restart services
- Use variables to control service name

### 📂 Create project structure:
```bash
ansible_project/
├── inventory.ini
├── playbook.yml
└── roles/        # (leave empty for now)
```

###🔹 Hour 5–6: Loops, Conditionals, Templates
🧠 Learn:
- Loops: with_items, loop

- Conditionals: when, failed_when

- Templates with Jinja2

### ✅ Practice:
- Create a list of users and loop to create them

- Deploy a templated config file (.j2)

- Use when to conditionally install packages


### 🔹 Hour 7–8: Roles + Best Practices
🧠 Learn:
- Directory structure of roles

- Reuse roles across playbooks

- Role dependencies

### ✅ Practice:
- Create a role: webserver

* tasks/

* handlers/

* templates/

* defaults/

- Use: ansible-galaxy init webserver

- Use the role in your main playbook

### 🔹 Hour 9–10: Polish for Interview Readiness
🧠 Learn:
- Tags: --tags, --skip-tags

- ansible-vault for secrets

- ansible-pull (optional)

- Idempotence: run safely multiple times

### ✅ Practice:
- Encrypt a secret with ansible-vault

- Run playbook with tags

- Run the same playbook twice to ensure idempotency




### 📝 Document Your Work (for your GitHub or interview):
- Push your playbook + roles to GitHub

- Write a simple README.md:

     - What the playbook does

     - How to run it

     - Key features (handlers, templates, vault, etc.)

### 🎯 Bonus Tips for Interview
- Prepare 2–3 “project stories” (even if small)

- Be ready to explain:

     - Playbook structure

     - Why you use handlers

     - When to use roles

     - How you handle secrets

- Mention tools like:

     - ansible-lint

     - ansible-vault

     - ansible-galaxy


