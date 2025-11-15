# GLPI + FormCreator en Docker -- Guía Paso a Paso

## 0. Contexto del entorno

Stack Docker usado:

-   **GLPI 10.0.19** (`glpi/glpi:10.0.19`)
-   **MariaDB 10.11** (`mariadb:10.11`)
-   Plugin **FormCreator 2.13.10** incluido en la imagen Docker
-   Volúmenes persistentes:
    -   `glpi_config` → `/var/www/html/glpi/config`
    -   `glpi_files` → `/var/www/html/glpi/files`
    -   `glpi_db` → `/var/lib/mysql`

Base de datos:

-   Host: `db`\
-   Database: `glpidb`\
-   User: `glpi`\
-   Password: `glpi_pass`\
-   Root password: `root_pass`

------------------------------------------------------------------------

## 1. Levantar el entorno con Docker

Desde la carpeta raíz donde está `docker-compose.yml`:

``` bash
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
```

Comprobar contenedores:

``` bash
docker ps
```

Resultados esperados:

-   `glpi_db` → Up\
-   `glpi_app` → Up (puerto `8080:80`)

------------------------------------------------------------------------

## 2. Instalación inicial de GLPI

Abrir en un navegador:

    http://localhost:8080

o\
`http://IP_SERVIDOR:8080`

### Pasos del asistente:

1.  **Idioma** → Continuar\
2.  **Licencia** → Continuar\
3.  Seleccionar **Instalación**\
4.  **Chequeo de requisitos** → Continuar\
5.  **Base de datos**
    -   Servidor: `db`\
    -   Usuario: `glpi`\
    -   Contraseña: `glpi_pass`\
    -   Base: `glpidb`\
6.  GLPI creará las tablas\
7.  GLPI mostrará los usuarios creados por defecto\
8.  Ir a la pantalla de **Login**

------------------------------------------------------------------------

## 3. Primer login y ajustes básicos

Entrar con:

-   Usuario: `glpi`
-   Contraseña: `glpi` (cambiable luego)

Recomendado:

-   Cambiar contraseña del admin\
-   Configurar idioma\
-   Revisar zona horaria (`America/Argentina/Buenos_Aires`)\
-   Ajustar nombre de la organización

------------------------------------------------------------------------

## 4. Activar plugin FormCreator

1.  Menú: **Complementos**\
2.  Buscar **FormCreator**\
3.  Clic en **Activar**\
4.  Confirmar que queda en estado **Activo**

------------------------------------------------------------------------

## 5. Importar tus formularios existentes

Desde:

**Administración → Formularios → Importar**

Para cada archivo `.json`:

1.  Importar\
2.  Confirmar\
3.  Verificar que aparece en la lista

Revisar:

-   Permisos\
-   Destinos\
-   Categorías asociadas

------------------------------------------------------------------------

## 6. Configuración recomendada en GLPI

### 6.1. Entidades

-   Administración → Entidades\
-   Ajustar nombre, zona horaria, mail, etc.

### 6.2. Usuarios

-   Administración → Usuarios\
-   Crear usuarios

### 6.3. Grupos

-   Administración → Grupos\
-   Ejemplos: Soporte Nivel 1, Infraestructura, Desarrollo

### 6.4. Perfiles

-   Administración → Perfiles\
-   Ajustar permisos

------------------------------------------------------------------------

## 7. Configuración de correo

### 7.1. Notificaciones SMTP

-   Configuración → Notificaciones → Configuración\
-   Configuración → Correo → SMTP

### 7.2. Recolección de correo

-   Configuración → Correos recolectados

------------------------------------------------------------------------

## 8. FormCreator -- Buenas prácticas

-   Formularios bien nombrados\
-   Secciones claras\
-   Destinos revisados\
-   Permisos configurados\
-   Usuarios acceden desde **Auto-servicio → Formularios**

------------------------------------------------------------------------

## 9. Backups

### 9.1. DB

``` bash
docker exec -i glpi_db mysqldump -uglpi -pglpi_pass glpidb > backup_glpi.sql
```

### 9.2. Archivos

Volumen `glpi_files`.

------------------------------------------------------------------------

## 10. Resumen rápido

1.  Levantar Docker\
2.  Instalar GLPI\
3.  Login como admin\
4.  Activar FormCreator\
5.  Importar formularios\
6.  Configurar usuarios, grupos y perfiles\
7.  Configurar correo\
8.  Usar GLPI
