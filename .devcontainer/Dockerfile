FROM odoo:${ODOO_VERSION}

USER root

# Cambiamos a /tmp para las instalaciones
WORKDIR /tmp

# Copiamos los requerimientos (asegúrate de que el archivo existe en la raíz de tu proyecto)
COPY ./requirements.txt .

RUN apt-get update && apt-get install -y --no-install-recommends \
    git gcc swig python3-m2crypto unzip curl python3-venv \
    && pip install --upgrade pip \
    && pip install --no-cache-dir setuptools==82.0.0 wheel \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* requirements.txt

# Volvemos al usuario odoo para seguridad
USER odoo