# Odoo docker compose (boilerplate desarrollo)

Entorno simple para Odoo 18 (y posiblemente 17 y 19 con los ajustes necesarios) en local. No usar en producción.

## Uso rápido
```bash
docker compose up -d
```
Luego abre el puerto HTTP definido en `docker-compose.yaml` (por defecto 8069 en host → 8069 en contenedor).

## Dónde poner tus módulos
- `local_addons/`: tus módulos en desarrollo.
- `oca/`: módulos de la comunidad OCA.
- `enterprise/`: módulos enterprise (si los tienes).
- `extra_addons/`: cualquier otro módulo/plugin que quieras cargar.

## Si ves errores de permisos al crear carpetas
Ejecuta:
```bash
chown -R $USER:$USER .
chmod -R 775 local_addons oca enterprise extra_addons
```