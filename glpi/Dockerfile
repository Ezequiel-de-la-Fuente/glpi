FROM glpi/glpi:10.0.19

ENV GLPI_INSTALL_AUTO=0

# Copiar plugin FormCreator
COPY plugins/formcreator /var/www/glpi/plugins/formcreator

# Copiar scripts de init
COPY init /docker-entrypoint-init.d/

RUN chmod -R +x /docker-entrypoint-init.d/
