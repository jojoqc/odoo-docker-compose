# Odoo 18 Entorno de Desarrollo

Entorno de desarrollo para Odoo 18 usando Docker y VS Code Dev Containers.

[![Odoo](https://img.shields.io/badge/Odoo-18.0-green)](https://www.odoo.com/)
[![Python](https://img.shields.io/badge/Python-3.12-blue)](https://www.python.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)](https://www.postgresql.org/)

## Características

**Entorno:**
- Dev Container para VS Code
- Odoo 18.0
- PostgreSQL 16
- Python 3.12
- Docker Compose
- Volúmenes persistentes

**Herramientas de desarrollo:**
| Extensión | Función |
|-----------|---------|
| **Odoo File** | Navegación de archivos Odoo |
| **OWL Vision** | Soporte para componentes OWL |
| **Odoo Extension** | Snippets y utilidades |
| **SQL Tools** | Cliente PostgreSQL |
| **Debugpy** | Debugging Python |
| **Pyright** | Type checking |
| **Ruff** | Linting y formateo |

## Estructura del Proyecto

```
📦 odoo-docker-compose/
├── 📁 odoo/               # ⚠️ Core de Odoo (clonar automáticamente)
├── 📁 stubs/              # Type stubs para autocompletado
├── 📁 local_addons/       # Tus módulos en desarrollo
├── 📁 oca/                # Módulos de la comunidad OCA
├── 📁 enterprise/         # Módulos enterprise (opcional)
├── 📁 extra_addons/       # Otras dependencias y plugins
├── 📁 conf/               # Configuración de Odoo
├── 📁 .devcontainer/      # Configuración del contenedor
│   ├── devcontainer.json  # VS Code Dev Container config
│   ├── docker-compose.yaml
│   ├── Dockerfile
│   ├── .env.example       # Variables de entorno (plantilla)
│   └── .env               # Variables de entorno (local)
├── 🔧 setup.sh            # Script de configuración inicial
├── 📄 pyproject.toml      # Configuración de Pyright y Ruff
└── 📄 README.md           # Este archivo
```

### 🔌 Puertos Expuestos

| Puerto | Servicio | Uso |
|--------|----------|-----|
| **8069** | Odoo HTTP | Interfaz web principal |
| **8072** | Odoo Longpolling | WebSockets para chat y notificaciones |
| **5678** | Debugpy | Debugging remoto Python |
| **5432** | PostgreSQL | Base de datos (acceso directo) |

## 🚀 Inicio Rápido

### Paso 1: Clonar el Repositorio

```bash
# Clona este repositorio
git clone https://github.com/jojoqc/odoo-docker-compose odoo-dev
cd odoo-dev

```

### Paso 2: Configurar Variables de Entorno
```bash
# Copia el archivo de ejemplo
cp .devcontainer/.env.example .devcontainer/.env

# Edita según tus necesidades (opcional)
nano .devcontainer/.env
```

### Paso 3: Ejecutar Script de Configuración
```bash
# Da permisos de ejecución
chmod +x setup.sh

# Ejecuta el script (clonará Odoo y creará estructura)
./setup.sh
```

### Paso 5: Acceder a Odoo
| Servicio | URL |
|----------|-----|
| **Odoo Web** | http://localhost:8069 |
| **PostgreSQL** | `localhost:5432` |
| **Debugger** | `localhost:5678` |

**Master Password:** `1234` (configurada en `conf/odoo.conf`)

### Variables de Entorno (`.devcontainer/.env`)

```bash
POSTGRES_VERSION=16
ODOO_VERSION=18

# Con debugging remoto
ENTRYPOINT=/usr/bin/python3 -m debugpy --listen 0.0.0.0:5678 /usr/bin/odoo -c /etc/odoo/odoo.conf --dev=all

# Sin debugging remoto
# ENTRYPOINT=odoo -c /etc/odoo/odoo.conf --dev=all
```