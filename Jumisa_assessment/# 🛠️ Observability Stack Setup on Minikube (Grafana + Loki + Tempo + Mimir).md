Markdown

# 🛠️ Observability Stack Setup on Minikube (Grafana + Loki + Tempo + Mimir)

This document outlines the setup and configuration steps performed for the observability stack deployment on a Minikube cluster. It includes details for Grafana, Loki, Tempo, Mimir, and exposure via NGINX.

## 🧱 Stack Components

| Component | Purpose          | Deployment Status |
|-----------|-----------------|------------------|
| Grafana   | Visualization UI | ✅ Deployed |
| Loki      | Log aggregation  | ✅ Deployed |
| Tempo     | Tracing backend  | ✅ Deployed |
| Mimir     | Metric storage   | ✅ Deployed |
| NGINX     | Reverse proxy    | ✅ Configured |

## 📦 Helm Deployments

Each component was deployed using Helm with appropriate namespaces:

```bash
# Example:
helm install grafana grafana/grafana -n monitoring --create-namespace
```
##cNamespaces used:

- monitoring: for Grafana and Grafana Agent
- loki: for Loki
- tempo: for Tempo
- mimir: for Mimir
## 🧭 DNS Resolution
Verified service discovery inside the cluster:


```
kubectl exec -it debug -n monitoring -- nslookup loki.loki.svc.cluster.local
kubectl exec -it debug -n monitoring -- nslookup tempo-query-frontend.tempo.svc.cluster.local
```
✅ Service Status

```
kubectl get svc -A
```
## Key services:

| Name                  | Namespace   | Type       | Port(s)   | Description                          |
|-----------------------|-------------|------------|-----------|--------------------------------------|
| grafana               | monitoring  | ClusterIP  | 80/TCP    | Grafana UI                           |
| grafana-agent         | monitoring  | ClusterIP  | 80/TCP    | Agent collecting logs/metrics/traces |
| loki                  | loki        | ClusterIP  | 3100/TCP  | Loki API                             |
| tempo-query-frontend  | tempo       | ClusterIP  | 80/TCP    | Tempo UI/API                         |

# 📍 Grafana Exposure via NodePort

## To expose Grafana externally:

```
kubectl patch svc grafana -n monitoring \
  -p '{"spec": {"type": "NodePort", "ports": [{"port":80,"targetPort":3000,"nodePort":30284}]}}'
```
## Confirmed access via:

```

curl -I [http://192.168.49.2:30284](http://192.168.49.2:30284)
```
# 🌐 NGINX Reverse Proxy Setup
## Configuration File `(/etc/nginx/sites-available/loki-grafana.conf)`

```nginx

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass [http://192.168.49.2:30284](http://192.168.49.2:30284);
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    error_page 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```
## Enabling Site and Restarting NGINX

```
sudo ln -s /etc/nginx/sites-available/loki-grafana.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

# 🔗 Grafana Data Sources (Auto-Provisioned via ConfigMap)


- Loki: ``` http://loki.loki.svc.cluster.local:3100 ```
- Tempo: ```http://tempo-query-frontend.tempo.svc.cluster.local:80```
- Mimir/Prometheus: ```http://mimir-query-frontend.mimir.svc.cluster.local:8080```
  
# ✅ Final Result
Grafana is now accessible externally via NGINX reverse proxy and pre-configured to visualize:

- Logs from Loki
- Traces from Tempo
- Metrics from Mimir
# 🔐 Default Login


```
Username: admin
Password: <retrieved from secret or set via Helm>
```
## Retrieve password:

```
kubectl get secret grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d
```


