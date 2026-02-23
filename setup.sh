#!/bin/bash
# setup.sh - Script de configuración inicial del entorno Odoo
# Este script crea la estructura de directorios, clona Odoo y actualiza los stubs

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
echo "║        � Odoo Development Environment Setup 🐘          ║"
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

# === PASO 1: Leer configuración del archivo .env ===
log_info "Leyendo configuración del archivo .devcontainer/.env..."

ENV_FILE=".devcontainer/.env"
ENV_EXAMPLE=".devcontainer/.env.example"

# Verificar si existe el archivo .env
if [ ! -f "$ENV_FILE" ]; then
    if [ -f "$ENV_EXAMPLE" ]; then
        log_warning "Archivo .env no encontrado, copiando desde .env.example..."
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        log_success "Archivo .env creado desde plantilla"
    else
        log_error "No se encontró ni .env ni .env.example en .devcontainer/"
        exit 1
    fi
fi

# Leer ODOO_VERSION del archivo .env
if grep -q "ODOO_VERSION" "$ENV_FILE"; then
    ODOO_VERSION=$(grep "^ODOO_VERSION=" "$ENV_FILE" | cut -d '=' -f2 | tr -d '[:space:]' | tr -d '"' | tr -d "'")
    log_success "Versión de Odoo detectada: ${ODOO_VERSION}"
else
    log_warning "ODOO_VERSION no encontrado en .env, usando versión por defecto: 18"
    ODOO_VERSION="18"
fi

# Validar versión de Odoo
if [[ ! "$ODOO_VERSION" =~ ^[0-9]+$ ]]; then
    log_error "Versión de Odoo inválida: $ODOO_VERSION"
    exit 1
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

# === PASO 3: Clonar repositorio de Odoo ===
ODOO_DIR="odoo"
ODOO_REPO="https://github.com/odoo/odoo.git"
ODOO_BRANCH="${ODOO_VERSION}.0"

if [ -d "$ODOO_DIR" ]; then
    log_warning "Directorio 'odoo' ya existe"
    
    # Verificar si es un repositorio git
    if [ -d "$ODOO_DIR/.git" ]; then
        log_info "Actualizando repositorio de Odoo a la rama $ODOO_BRANCH..."
        
        cd "$ODOO_DIR"
        
        # Verificar la rama actual
        CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        
        if [ "$CURRENT_BRANCH" != "$ODOO_BRANCH" ]; then
            log_warning "Rama actual: $CURRENT_BRANCH, cambiando a $ODOO_BRANCH..."
            git fetch origin
            git checkout "$ODOO_BRANCH" 2>/dev/null || {
                log_warning "Rama $ODOO_BRANCH no existe localmente, descargando..."
                git checkout -b "$ODOO_BRANCH" "origin/$ODOO_BRANCH"
            }
        fi
        
        # Actualizar código
        log_info "Actualizando código de Odoo..."
        git pull origin "$ODOO_BRANCH" || log_warning "No se pudo actualizar (puede haber cambios locales)"
        
        cd ..
        log_success "Repositorio de Odoo actualizado a la rama $ODOO_BRANCH"
    else
        log_error "El directorio 'odoo' existe pero no es un repositorio git válido"
        log_warning "Por favor, elimina el directorio manualmente: rm -rf odoo"
        exit 1
    fi
else
    log_info "Clonando repositorio oficial de Odoo (rama $ODOO_BRANCH)..."
    log_warning "Esto puede tomar varios minutos..."
    
    # Clonar con profundidad limitada para ser más rápido
    git clone --depth 1 --branch "$ODOO_BRANCH" "$ODOO_REPO" "$ODOO_DIR" || {
        log_error "Error al clonar Odoo. Verifica tu conexión a Internet."
        exit 1
    }
    
    log_success "Repositorio de Odoo clonado exitosamente"
fi

# === PASO 4: Actualizar submódulo de stubs ===
STUBS_DIR="stubs"
STUBS_REPO="https://github.com/odoo-ide/odoo-stubs.git"

# Determinar la rama de stubs (los stubs llegan hasta Odoo 18)
if [ "$ODOO_VERSION" -gt 18 ]; then
    STUBS_BRANCH="18.0"
    log_warning "Los stubs solo llegan hasta Odoo 18. Usando stubs de la versión 18.0"
else
    STUBS_BRANCH="${ODOO_VERSION}.0"
fi

log_info "Actualizando submódulo de stubs (rama $STUBS_BRANCH)..."

if [ -d "$STUBS_DIR" ]; then
    # Verificar si es un submódulo git
    if [ -d "$STUBS_DIR/.git" ]; then
        log_info "Actualizando stubs existentes..."
        
        cd "$STUBS_DIR"
        
        # Verificar la rama actual
        CURRENT_STUBS_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
        
        if [ "$CURRENT_STUBS_BRANCH" != "$STUBS_BRANCH" ]; then
            log_info "Cambiando stubs a la rama $STUBS_BRANCH..."
            git fetch origin
            git checkout "$STUBS_BRANCH" 2>/dev/null || {
                git checkout -b "$STUBS_BRANCH" "origin/$STUBS_BRANCH"
            }
        fi
        
        git pull origin "$STUBS_BRANCH" || log_warning "No se pudo actualizar stubs"
        
        cd ..
        log_success "Stubs actualizados a la rama $STUBS_BRANCH"
    else
        log_warning "Directorio stubs existe pero no es un repositorio git"
    fi
else
    log_info "Inicializando submódulo de stubs..."
    git submodule update --init --recursive || {
        log_warning "Error al inicializar submódulo. Intentando clonar manualmente..."
        git clone --depth 1 --branch "$STUBS_BRANCH" "$STUBS_REPO" "$STUBS_DIR" || {
            log_error "Error al clonar stubs"
        }
    }
    log_success "Stubs inicializados"
fi

# Actualizar la rama del submódulo en .gitmodules si es necesario
if [ -f ".gitmodules" ]; then
    if grep -q "branch = " ".gitmodules"; then
        # Actualizar la rama existente
        sed -i "s/branch = .*/branch = $STUBS_BRANCH/" ".gitmodules" 2>/dev/null || {
            # En macOS, sed requiere un argumento para -i
            sed -i '' "s/branch = .*/branch = $STUBS_BRANCH/" ".gitmodules" 2>/dev/null || true
        }
        log_info "Rama de stubs actualizada en .gitmodules"
    fi
fi

# === PASO 5: Configurar permisos ===
log_info "Configurando permisos de directorios..."

chmod -R 775 local_addons oca enterprise extra_addons 2>/dev/null || {
    log_warning "No se pudieron configurar algunos permisos (puede ser normal)"
}

if [ -d "$ODOO_DIR" ]; then
    chmod -R 775 "$ODOO_DIR" 2>/dev/null || true
fi

log_success "Permisos configurados"

# === RESUMEN FINAL ===
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║              ✅ Setup completado exitosamente ✅           ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

log_success "Configuración completada para Odoo ${ODOO_VERSION}.0"
echo ""
echo -e "${BLUE}📁 Estructura creada:${NC}"
echo "   ✅ local_addons/     → Tus módulos personalizados"
echo "   ✅ oca/              → Módulos de la comunidad OCA"
echo "   ✅ enterprise/       → Módulos enterprise (si los tienes)"
echo "   ✅ extra_addons/     → Otras dependencias"
echo "   ✅ odoo/             → Core de Odoo ${ODOO_VERSION}.0"
echo "   ✅ stubs/            → Type hints para autocompletado"
echo ""
echo -e "${BLUE}🚀 Próximos pasos:${NC}"
echo "   1. Abre este proyecto en VS Code: ${YELLOW}code .${NC}"
echo "   2. Click en ${YELLOW}'Reopen in Container'${NC} cuando aparezca el mensaje"
echo "   3. Espera a que se construya el contenedor (~5-10 min la primera vez)"
echo "   4. Accede a Odoo en ${YELLOW}http://localhost:8069${NC}"
echo "   5. Credenciales: ${YELLOW}admin / admin${NC}"
echo ""
log_info "Para más información, consulta el README.md"
echo ""
