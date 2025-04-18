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
