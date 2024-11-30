# How to create a simple nginx Dockerfile?


```
nginx-app/
├── Dockerfile
├── index.html
└── nginx.conf

```

## Step 1: Create the HTML File
In the index.html file, write a basic HTML page:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Our docker session!!!</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <h1>Hello, Nginx is running inside a Docker container!</h1>
    <p>This is a simple static website served by Nginx.</p>
    <h2>This is our youtube link: https://youtu.be/4T6-cWanEEw?si=JwSywt42w7UFqTKt our channel DevOps-Dockyard </h2>
    <p> Kindly checkout our contents <p>
</body>
</html>
```

## Step 2: Create an Nginx Configuration File
Create an nginx.conf file to define the Nginx server configuration:

```
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

### Should You Define an Nginx Server Block?

Defining the server block in the Nginx configuration is not always mandatory, but it is highly recommended and often necessary depending on your use case.

---

## When You **Need** to Define the Server Block

1. **Custom Behavior**:
   - If you want Nginx to serve files from a specific directory, listen on a particular port, or route requests differently, you must define a server block.
   - Example: Specifying the root directory (`root /usr/share/nginx/html;`) and default file (`index index.html;`) is crucial if they differ from Nginx's defaults.

2. **Hosting Multiple Websites**:
   - When serving multiple domains or subdomains (virtual hosting), you must define separate server blocks for each domain or application.

3. **Custom Ports or Hostnames**:
   - If you need to change the default port (80 for HTTP) or serve content for a specific domain or IP address, you must define a server block.

4. **Dockerized Applications**:
   - In a Docker setup, the server block explicitly specifies the behavior of the containerized Nginx instance, ensuring predictable operation.

---

## When You Might **Not** Need to Define It

1. **Default Configuration Is Sufficient**:
   - If your needs align with Nginx’s default configuration:
     - Nginx listens on port 80.
     - Serves files from `/usr/share/nginx/html`.
     - Serves `index.html` or similar as the default page.
   - You may not need a custom `server` block. Nginx's default configuration can handle simple setups.

2. **Using a Preconfigured Nginx Image**:
   - Many Docker Nginx images come with a default configuration that serves static files from `/usr/share/nginx/html` without requiring a custom `server` block.

---

## Why Defining It Is Recommended

Even if Nginx's default settings meet your immediate needs, explicitly defining the `server` block is a best practice because:

- **Documents Your Configuration**:
  - Makes your setup explicit and easier to understand for others (or yourself later).
  
- **Prevents Unexpected Behavior**:
  - Future changes to Nginx's defaults won't affect your site if you have a custom configuration.
  
- **Allows Customization**:
  - Provides flexibility for future modifications, such as adding redirects, security headers, or caching.

---

## Example: Minimal vs. Explicit Configuration

### Using Defaults (No Custom Block)
- Works if you don't need anything special and are happy with `/usr/share/nginx/html` and `index.html`.

### Explicit Configuration (Custom Block)
```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /my/custom/directory;
        index mycustomindex.html;
    }
}
```

Changing Port and Path in the server Block
To change the default port and path, you modify the server block in the Nginx configuration file. Here’s an example:
```nginx
Copy code
server {
    listen 8080;  # Change the port to 8080
    server_name localhost;

    # Change the root path for serving files
    root /custom/path/to/website;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```
### Steps to Apply Changes
* Edit the Configuration File: Update the configuration file, typically located at `/etc/nginx/nginx.conf` or `/etc/nginx/sites-available/default`.
* Restart Nginx: After saving changes, restart Nginx to apply the updates:
 ```
  sudo systemctl restart nginx
  ```
# Step 3: Write the Dockerfile
The Dockerfile will use the official Nginx image as the base and copy your static files into the container:

```
# Use the official Nginx image
FROM nginx:alpine

# Copy custom configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy website files to the default Nginx web directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80
```

