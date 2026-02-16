FROM odoo:${ODOO_VERSION:-18}

USER root

# Cambiamos a /tmp para las instalaciones
WORKDIR /tmp

# Copiamos los requerimientos (asegúrate de que el archivo existe en la raíz de tu proyecto)
COPY ./requirements.txt .

RUN apt-get update && apt-get install -y --no-install-recommends \
    git gcc swig python3-m2crypto unzip curl python3-venv \
    && pip install --no-cache-dir --break-system-packages setuptools wheel \
    && pip install --no-cache-dir --break-system-packages -r requirements.txt \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* requirements.txt

# Volvemos al directorio de trabajo por defecto de Odoo
WORKDIR /var/lib/odoo

# Volvemos al usuario odoo para seguridad
USER odoo