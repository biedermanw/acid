# 🧪 Acid

## 🌐 Overview

```bash
# Clone the main repository with its submodules
git clone git@github.com:biedermanw/acid.git --recursive
cd acid

# Switch to the `main` branch for each submodule
git submodule foreach 'git checkout main || :'

# Execute the make up command
make up
```

Acid is a **React**ive **Flask** container to catalyze the initiation of projects. Built with an integrated React UI, it prioritizes modularity, component-driven development, and clear separation of concerns. This not only streamlines maintenance and user experience enhancements but also fosters consistent, reusable UI development.

The incorporation of Docker ensures an environment that champions consistency, portability, and isolation, eliminating the all-too-familiar "it works on my machine" scenario. It streamlines deployment and optimizes resource scalability.

The robustness of Python 3.11 drives Acid's API, complemented by PostgreSQL's reliability for data storage. This synergy ensures that Acid scales gracefully, meeting the evolving needs of projects.

## 🛠️ Key Technologies

- **Flask**: Powers the API logic and services.
- **React**: For a dynamic, responsive UI.
- **Vite**: A build tool that provides a faster development and build experience for React projects.
- **Storybook**: Visualizes and tests React components in isolation, streamlining UI development.
- **PostgreSQL (v15 with Alpine)**: Robust database solution ensuring data integrity and fast retrieval.
- **Docker**: Guarantees consistent development and deployment environments.
- **Docker Compose**: Orchestrates multi-container Docker applications.
- **Gunicorn**: Efficiently manages incoming requests as the WSGI HTTP server for Flask.
- **Nginx (on Alpine)**: Delivers UI assets swiftly.
- **Python 3.11**: Provides a versatile and powerful API foundation.
- **Node.js**: Manages React dependencies and UI build scripts.

## 🚀 Setup & Development

Check for updates to the submodules.

```bash
git pull --recurse-submodules
```

### 📋 Prerequisites

- Docker
- Python 3
- npm

### 🐳 Docker Workflow

1. **Build Images**: Constructs images for UI, API, and database services.

```bash
make build
```

2. **Launch Services**: Initiates services as per the Docker Compose specification.

```bash
make up
```

3. **SQLALchemy Initialization**: Required for first-time setups.

```bash
make db_init
make db_migrate
make db_upgrade
```

To halt services:

```bash
make down
```

Shortcut to use `make dowwn; make build; make up` to rebuild and restart services:

```bash
make over
```

### 💡 Direct Local Development

Setup local development environment:

```bash
make local_build
```

Cleanup local development environment:

```bash
make local_clean
```

Run Flask and React locally:

```bash
make local
```

Appending `_flask` or `_react` to the end of the above commands will manage either the Flask or React projects separately.

### 📘 Commands Reference

For an exhaustive command list:

```bash
make help
```
