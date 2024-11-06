# odoo-docker-compose
Odoo docker compose for easy usage

# HOW TO USE



If you use Linux
```yml 
docker compose --env-file .env.example -f docker-compose-linux.yml up -d
```

If you use Window
```yml
docker compose --env-file .env.example -f docker-compose-win.yml up -d
```

If you have problem with folder creation or permissions with the linux versions use

``` bash
chown $(whoami):$(whoami) /opt/odoo-docker-compose/*
chmod -R 744 /opt/odoo-docker-compose/*
```
