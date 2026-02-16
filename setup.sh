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
