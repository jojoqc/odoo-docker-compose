# odoo-docker-compose
Odoo docker compose for easy usage

# HOW TO USE


create the folder for the odoo config file based on the version you chose
just replacing
odoo-{version} -> odoo-16.0
```
mkdir odoo-16.0
mkdir odoo-16.0/conf
```

then copy the odoo.conf to the created conf folder
```
cp conf/odoo.conf odoo-16.0/conf
```


If you use Linux
```yml 
docker compose --env-file .env.example -f docker-compose.yml up -d
```

If you have problem with folder creation or permissions

``` bash
chown $(whoami):$(whoami) /odoo-{version}/extra-addons
chmod -R 744 /odoo-{version}/extra-addons
```
