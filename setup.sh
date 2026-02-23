#!/bin/bash
# setup.sh - Script de configuración inicial del entorno Odoo
# Este script crea la estructura de directorios y configura permisos

set -e  # Salir si hay errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║        🚀 Odoo Development Environment Setup 🐘          ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Función para mensajes de log
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# === PASO 1: Copiar archivo .env ===
log_info "Configurando archivo .env..."

ENV_FILE=".devcontainer/.env"
ENV_EXAMPLE=".devcontainer/.env.example"

if [ ! -f "$ENV_FILE" ]; then
    if [ -f "$ENV_EXAMPLE" ]; then
        log_info "Copiando .env.example a .env..."
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        log_success "Archivo .env creado desde plantilla"
    else
        log_warning "No se encontró .env.example, continuando sin él"
    fi
else
    log_success "Archivo .env ya existe"
fi

# === PASO 2: Crear estructura de directorios ===
log_info "Creando estructura de directorios para módulos..."

mkdir -p local_addons
mkdir -p oca  
mkdir -p enterprise
mkdir -p extra_addons

# Crear README para cada directorio
cat > local_addons/README.md << 'EOF'
# Local Addons

Directorio para tus módulos personalizados en desarrollo.

## Estructura recomendada de un módulo

```
mi_modulo/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   └── mi_modelo.py
├── views/
│   └── mi_vista.xml
├── security/
│   └── ir.model.access.csv
└── static/
    └── description/
        └── icon.png
```
EOF

cat > oca/README.md << 'EOF'
# OCA Modules

Directorio para módulos de la Odoo Community Association (OCA).

## Agregar módulos OCA como submodules

```bash
cd oca/
git submodule add https://github.com/OCA/web.git web
git submodule add https://github.com/OCA/server-tools.git server-tools
```

## Recursos
- [OCA GitHub](https://github.com/OCA)
- [OCA Guidelines](https://github.com/OCA/odoo-community.org)
EOF

cat > enterprise/README.md << 'EOF'
# Enterprise Modules

Directorio para módulos de Odoo Enterprise (requiere licencia).

## Cómo agregar módulos enterprise

1. Obtén acceso a los módulos enterprise de Odoo
2. Copia los módulos a esta carpeta:
   ```bash
   cp -r /ruta/a/enterprise/* enterprise/
   ```
3. Reinicia el contenedor para que se carguen los módulos
EOF

cat > extra_addons/README.md << 'EOF'
# Extra Addons

Directorio para módulos adicionales de terceros que no sean OCA ni Enterprise.

Ejemplos:
- Módulos comprados en Odoo Apps Store
- Módulos de otros repositorios
- Dependencias específicas del proyecto
EOF

log_success "Estructura de directorios creada"

# === PASO 3: Configurar permisos ===
log_info "Configurando permisos de directorios..."

chmod -R 775 local_addons oca enterprise extra_addons 2>/dev/null || {
    log_warning "No se pudieron configurar algunos permisos (puede ser normal)"
}

log_success "Permisos configurados"

# === RESUMEN FINAL ===
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║              ✅ Setup completado exitosamente ✅           ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

log_success "Configuración completada"
echo ""
echo -e "${BLUE}📁 Estructura de directorios creada:${NC}"
echo "   ✅ local_addons/     → Módulos personalizados"
echo "   ✅ oca/              → Módulos OCA"
echo "   ✅ enterprise/       → Módulos Enterprise"
echo "   ✅ extra_addons/     → Módulos adicionales"
echo ""
echo -e "${BLUE}🔧 Configuración aplicada:${NC}"
echo "   ✅ Permisos establecidos (775)"
echo "   ✅ Archivo .env configurado"
echo ""
echo -e "${BLUE}🚀 Próximos pasos:${NC}"
echo "   1. Abre en VS Code: ${YELLOW}code .${NC}"
echo "   2. Click en ${YELLOW}'Reopen in Container'${NC}"
echo "   3. El contenedor montará los directorios odoo y odoo-stubs desde el nivel superior"
echo ""
log_info "Para más información, consulta el README.md"
echo ""
