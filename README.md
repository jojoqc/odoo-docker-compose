# Odoo docker compose

## Cómo usar este proyecto
## `advertencia no utilizar esta plantilla para despligues en produccion.`


Para iniciar Odoo, ejecuta el siguiente comando:
```yml 
docker compose up -d
```
Este comando inicia los contenedores de Odoo en segundo plano, lo que significa que Odoo estará ejecutándose en el puerto 8069 en docker pero hara un alias en tus puertos locales y lo encontraras en el puerto 80, pero no bloqueará tu terminal.


Solución de problemas de permisos
Si experimentas problemas con la creación de carpetas o permisos, ejecuta los siguientes comandos:

``` bash
chown $USER:$USER odoo/
chmod -R 744 odoo/extra-addons/
```
Estos comandos establecen los permisos adecuados para que Odoo pueda funcionar correctamente:

- `chown $USER:$USER odoo/`: Establece la propiedad del directorio `odoo/` para que sea propiedad del usuario actual.
- `chmod -R 744 odoo/extra-addons/`: Establece los permisos del directorio `extra-addons/` y todos sus subdirectorios para que sean lectura, escritura y ejecución para el propietario, y lectura para los grupos y otros usuarios.

El contenido el archivo `docker-compose.yaml` es el siguiente:

``` yaml
networks:
  od16:
name: odoo
services:
  pg15:
    image: postgres:15
    hostname: pg15
    container_name: pg15
    restart: always
    stdin_open: true
    tty: true
    pull_policy: always
    environment:
      - POSTGRES_USER=odoo
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=admin
      - PGDATA=/var/lib/postgresql/data/pgdata
    networks:
      - od16
    volumes:
      - postgres_15:/var/lib/postgresql/data/pgdata

  od16:
    image: odoo:16.0
    hostname: od16
    container_name: od16
    restart: always
    ports:
      - "80:8069"
    entrypoint: "odoo -c /etc/odoo/odoo.conf --dev=all"
    volumes:
      - ./odoo/oca:/mnt/oca
      - ./odoo/conf:/etc/odoo
      - ./odoo/enterprise:/mnt/enterprise
      - ./odoo/extra-addons:/mnt/extra-addons
    stdin_open: true
    tty: true
    pull_policy: always
    environment:
      - USER=odoo
      - PASSWORD=admin
    networks:
      - od16
    links:
      - pg15:db
    depends_on:
      - pg15

volumes:
  postgres_15:
```