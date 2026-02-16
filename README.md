# 🐘 Odoo Docker Compose - Entorno de Desarrollo

> 🚀 Boilerplate optimizado para desarrollo de aplicaciones Odoo 18 con Dev Container, herramientas modernas y configuración enterprise-ready.

[![Dev Container](https://img.shields.io/badge/Dev%20Container-Ready-blue?logo=visualstudiocode&logoColor=white)](https://code.visualstudio.com/docs/devcontainers/containers)
[![Python](https://img.shields.io/badge/Python-3.12+-blue?logo=python&logoColor=white)](https://www.python.org/)
[![Odoo](https://img.shields.io/badge/Odoo-18.0-green?logo=odoo&logoColor=white)](https://www.odoo.com/)

## ✨ Características Destacadas

### 🏗️ **Arquitectura de Desarrollo Moderna**
- **Dev Container completo** con VS Code - entorno aislado y reproducible
- **versión Odoo** - soporte para 18
- **PostgreSQL optimizado** con tuning de rendimiento para desarrollo
- **Docker Compose** con volúmenes persistentes y networking optimizado

### 🔧 **Herramientas de Desarrollo Integradas**
- **Pyright** - análisis estático con tipado robusto para Odoo
- **Ruff** - formateo y linting ultra-rápido
- **Pre-commit hooks** - calidad de código automatizada
- **Debugpy** - debugging remoto integrado
- **Type Stubs** - soporte completo de tipado para el core de Odoo

### 📦 **Estructura de Módulos Organizada**
```
📁 local_addons/     # Tus módulos en desarrollo
📁 oca/             # Módulos de la comunidad OCA  
📁 enterprise/       # Módulos enterprise (si los tienes)
📁 extra_addons/     # Plugins y dependencias adicionales
```

### 🎯 **Extensiones VS Code Especializadas**
- **Odoo File** - navegación inteligente de archivos Odoo
- **OWL Vision** - soporte para componentes OWL
- **Odoo Extension** - herramientas específicas para desarrollo
- **SQL Tools** - gestión de base de datos integrada

## 🚀 Dev Container

### Iniciar con Dev Container 
```bash
# 1. Clona el repositorio
git clone <repo-url> odoo18
cd odoo18
cp .devcontainer/.env.example .devcontainer/.env


# 2. Abre en VS Code y selecciona "Reopen in Container"
# 3. Espera a que se construya el contenedor
# 4. Accede a Odoo en http://localhost:8069 (admin/admin)
#    Contraseña de base de datos: 1234 (configurada en conf/odoo.conf)
```

## 📁 Estructura Inicial

### Script de Configuración
```bash
# Ejecutar después de clonar el repositorio
chmod +x setup.sh && ./setup.sh
```

```bash
#!/bin/bash
# setup.sh - Script para crear estructura de directorios

echo "🚀 Creando estructura de directorios para Odoo..."

# Crear directorios de addons
mkdir -p local_addons
mkdir -p oca  
mkdir -p enterprise
mkdir -p extra_addons

# Crear README para cada directorio
echo "# Tus módulos locales en desarrollo" > local_addons/README.md
echo "# Módulos de la comunidad OCA" > oca/README.md  
echo "# Módulos enterprise (si los tienes)" > enterprise/README.md
echo "# Otros módulos y dependencias" > extra_addons/README.md

# Configurar permisos
chmod -R 775 local_addons oca enterprise extra_addons

echo "✅ Estructura creada exitosamente!"
echo "📁 Directorios creados:"
echo "   - local_addons/  # Tus módulos"
echo "   - oca/           # Módulos OCA" 
echo "   - enterprise/    # Módulos enterprise"
echo "   - extra_addons/  # Otras dependencias"
```

## ⚙️ Configuración

### Variables de Entorno
```bash
# .devcontainer/.env
POSTGRES_VERSION=16        # Versión PostgreSQL(15/16/17)
ODOO_VERSION=18           # Versión Odoo (17/18/19)
ENTRYPOINT=...            # Configuración debugging
```

### Puertos Disponibles
- **8069** - Odoo Web Interface
- **8072** - Longpolling/WebSockets  
- **5678** - Debugpy (Python Debugger)
- **5432** - PostgreSQL (acceso directo)

### Rutas de Desarrollo
- **Workspace**: `/workspaces/devcontainer`
- **Configuración**: `/etc/odoo/odoo.conf`
- **Datos Odoo**: `/var/lib/odoo`
- **Addons**: Configurados automáticamente en `addons_path`

## 🛠️ Herramientas de Desarrollo

### Tipado y Autocompletado
```python
# Ejemplo con tipado robusto
from odoo import models, fields, api
from typing import List, Dict, Optional

class ResPartner(models.Model):
    _name = 'res.partner'
    
    name: str = fields.Char(required=True)
    email: Optional[str] = fields.Char()
    
    @api.model
    def create_partners(self, partners_data: List[Dict]) -> List['ResPartner']:
        # Full autocompletado y type checking
        pass
```

### Debugging Remoto
1. **Breakpoints** en VS Code
2. **Attach** al proceso Odoo en puerto 5678
3. **Debug** de módulos locales y enterprise
4. **Hot reload** en modo desarrollo

### Calidad de Código
```bash
# Formateo automático
ruff format .

# Linting y corrección
ruff check --fix .

# Type checking
pyright --warnings
```

## 🔧 Personalización

### Agregar Nuevos Addons
```bash
# Módulos locales
mkdir local_addons/mi_modulo

# Módulos OCA
git submodule add https://github.com/OCA/web.git oca/web

# Módulos enterprise
cp -r /path/to/enterprise/* enterprise/
```

### Configuración Avanzada
```python
# conf/odoo.conf - ajustes específicos
workers = 3                    # Ajustar según CPU
limit_memory_soft = 1610612736 # ~1.5GB por worker
limit_time_cpu = 600           # 10 minutos por request
```

## 🐛 Troubleshooting

### Permisos de Archivos
```bash
# Fix permisos locales
chown -R $USER:$USER .
chmod -R 775 local_addons oca enterprise extra_addons
```

### Logs y Debugging
```bash
# Logs en tiempo real
docker logs -f odoo

# Debugging remoto
# VS Code: Run > Attach to Remote Process
```

### Problemas Comunes
- **Memory errors**: Reducir workers o aumentar RAM
- **Port conflicts**: Cambiar puertos en docker-compose.yaml
- **Permission denied**: Ejecutar comandos de permisos

## 🤝 Contribución

### Flujo de Trabajo
1. **Fork** del repositorio
2. **Feature branch** para cambios
3. **Pre-commit checks** automáticos
4. **Pull request** con tests

### Standards
- **PEP 8** con Ruff formatting
- **Type hints** obligatorios
- **Tests** para nuevas funcionalidades
- **Documentation** en código

## 📚 Recursos Adicionales

### Documentación
- [Odoo Developer Documentation](https://www.odoo.com/documentation/latest/developer.html)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)

### Comunidad
- [Odoo Community Forum](https://www.odoo.com/forum/help-1)
- [OCA GitHub](https://github.com/OCA)
- [Stack Overflow Odoo Tag](https://stackoverflow.com/questions/tagged/odoo)

---

## 📄 Licencia

MIT License - ver archivo [LICENSE](LICENSE) para detalles.

---

**⭐ Si este boilerplate te ayuda en tu desarrollo de Odoo, considera darle una estrella!**

**🐛 Issues y Pull Requests son bienvenidos para mejorar este proyecto.**