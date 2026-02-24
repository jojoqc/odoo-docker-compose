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
| **Odoo shortcuts** | Navegación de archivos Odoo | [Marketplace](https://marketplace.windsurf.com/vscode/item?itemName=mvintg.odoo-file) |
| **OWL Vision** | Soporte para componentes OWL | [Marketplace](https://marketplace.windsurf.com/vscode/item?itemName=Odoo.owl-vision) |
| **Odoo IDE** | Snippets y utilidades | [Marketplace](https://marketplace.windsurf.com/vscode/item?itemName=trinhanhngoc.vscode-odoo) |
| **Pyright** | Type checking | [Marketplace](https://marketplace.windsurf.com/vscode/item?itemName=ms-pyright.pyright) |
| **Ruff** | Linting y formateo | [Marketplace](https://marketplace.windsurf.com/vscode/item?itemName=charliermarsh.ruff) |

## Estructura del Proyecto

```
📦 odoo-devcontainer/
├── 📁 local_addons/       # Tus módulos en desarrollo
├── 📁 oca/                # Módulos de la comunidad OCA
├── 📁 enterprise/         # Módulos enterprise (opcional)
├── 📁 extra_addons/       # Otras dependencias y plugins
├── 📁 conf/               # Configuración de Odoo
├── 📁 docker-compose.yml   # Configuración de Docker Compose
├── 📁 Dockerfile          # Dockerfile para el contenedor
├── 📄 .env.example       # Variables de entorno (plantilla)
├── 🔧 setup.sh            # Script de configuración inicial
├── 📄 pyproject.toml      # Configuración de Pyright y Ruff
└── 📄 README.md           # Este archivo
```

### 🔌 Puertos Expuestos

| Puerto | Servicio | Uso |
|--------|----------|-----|
| **8069** | Odoo HTTP | Interfaz web principal |
| **8072** | Odoo Longpolling | WebSockets para chat y notificaciones |
| **5432** | PostgreSQL | Base de datos (acceso directo) |

## 🚀 Inicio Rápido

### Paso 1: Clonar el Repositorio

```bash
# Clona este repositorio
git clone https://github.com/jojoqc/odoo-devcontainer odoo-dev
cd odoo-dev

```

### Paso 2: Iniciar con Docker Compose
```bash
# Inicia todos los servicios en segundo plano
docker compose up -d

# Verifica que los servicios estén corriendo
docker compose ps
docker compose logs -f odoo
docker compose logs -f postgres
```

### Paso 3: Clonar Odoo y Stubs (Recomendado)

Para una mejor experiencia de desarrollo, clona el código fuente de Odoo y los type stubs **fuera del proyecto** (en un directorio superior). Esto permite:

- ✅ Mejor autocompletado con type stubs
- ✅ Navegación rápida al código fuente de Odoo

```bash
# Navegar al directorio padre (fuera del proyecto)
cd ..  

# Clonar Odoo 18 (código fuente para referencia)
git clone https://github.com/odoo/odoo.git --depth 1 --branch 18.0 odoo18

# Clonar type stubs (para autocompletado IDE)
git clone https://github.com/odoo/odoo-stubs.git --depth 1 --branch 18.0

# Volver al proyecto
cd odoo-devcontainer
```

**Estructura recomendada:**
```
~/path/to/odoo/
├── odoo18/              # Código fuente Odoo 18
├── odoo-stubs/          # Type stubs para IDE
└── odoo-devcontainer/   # Tu proyecto actual
```

### Paso 4: Ejecutar Script de Configuración
```bash
# Da permisos de ejecución
chmod +x setup.sh

# Ejecuta el script (creará estructura de módulos)
./setup.sh
```

### Paso 5: Acceder a Odoo
| Servicio | URL |
|----------|-----|
| **Odoo Web** | http://localhost:8069 |
| **PostgreSQL** | `localhost:5432` |

**Master Password:** `1234` (configurada en `conf/odoo.conf`)
