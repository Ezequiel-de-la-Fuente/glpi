# 🚀 GLPI + FormCreator + API REST – Guía Completa

Esta guía unificada cubre **todo el flujo completo**, desde instalar GLPI, importar formularios con FormCreator y finalmente consumirlos vía API REST desde otro servicio.

## 📖 Índice

1. 🔧 Instalación & configuración de GLPI (Docker)
2. 📩 Importación de formularios FormCreator (versionados en Git)
3. 🔌 Consumo de la API de GLPI (incluye ejemplos con Node.js)

---

# 1️⃣ Instalación y Configuración de GLPI

## 1.1. Stack utilizado

* GLPI **10.0.19**
* MariaDB **10.11**
* Plugin **FormCreator 2.13.10**
* Docker + docker-compose
* Volúmenes persistentes:

  * `glpi_config → /var/www/html/glpi/config`
  * `glpi_files → /var/www/html/glpi/files`
  * `glpi_db → /var/lib/mysql`

## 1.2. Levantar el entorno

```bash
docker compose down -v --remove-orphans
docker compose build --no-cache
docker compose up -d
```

Comprobar:

```bash
docker ps
```

Esperado:

* glpi_app → Up
* glpi_db → Up

## 1.3. Instalar GLPI

Abrir:

```
http://localhost:8080
```

Pasos del asistente:

1. Idioma
2. Licencia
3. Instalación
4. Chequeos → OK
5. Base de datos:

   * Servidor: db
   * Usuario: glpi
   * Contraseña: glpi_pass
   * Base: glpidb
6. Terminar instalación
7. Ir al login

## 1.4. Primer login

```
Usuario: glpi
Contraseña: glpi
```

Recomendado:

* Cambiar contraseña
* Configurar zona horaria
* Revisar nombre de la organización

## 1.5. Activar FormCreator

```
Menú → Configuración → Complementos → FormCreator → Instalar y Activar
```

Estado debe quedar: **Activo**

---

# 2️⃣ Importar Formularios FormCreator (versionados)

Estos formularios se almacenan en el repo bajo `forms/formcreator` y son JSON exportados.

📌 Referencia original incluida en este proyecto

## 2.1. Cómo importarlos

1. Entrar como Super-Admin
2. Ir a: **Administración → Formularios → Importar (Boton Crear para permitir JSON)**
3. Seleccionar `form-xx-nombre.json`
4. Verificar:

   * Entidad
   * Categoría destino
   * Grupos asignados
   * Permisos de usuario

## 2.2. Formularios incluidos (ejemplos)

* Solicitud de equipo
* Alta de usuario
* Solicitud de acceso VPN

## 2.3. Buenas prácticas

* Exportar cambios después de editar
* Versionar JSONs en Git
* Nombrar `form-XX-descriptivo.json`

---

# 3️⃣ Exponer & Consumir la API de GLPI

## 3.1. Activar API REST

```
Configuración → General → API → Activar API REST, Activar acceso con credenciales y activar acceso con token externo
```

## 3.2. Crear Cliente API

```
Configuración  → General → API → Agregar cliente API (Nombre, Activo y regenar token)
```

Guarda el **App-Token**

## 3.3. Crear User Token

```
Administración → Usuarios → (usuario glpi) → Usuario → Claves de acceso remoto (Token API) → Regenerar
```

Guarda el **User-Token**

---

# 3.4. Cliente Node.js de ejemplo

## Variables `.env`

```
GLPI_APP_TOKEN=XXXXXXXXXXXXX
GLPI_USER_TOKEN=XXXXXXXXXXXXX
```

## Código completo `index.js`

```js
require("dotenv").config();
const axios = require("axios");

const baseURL = "http://localhost:8080/apirest.php";
const APP_TOKEN = process.env.GLPI_APP_TOKEN;
const USER_TOKEN = process.env.GLPI_USER_TOKEN;

async function getSessionToken() {
  const res = await axios.get(`${baseURL}/initSession`, {
    headers: {
      "App-Token": APP_TOKEN,
      Authorization: `user_token ${USER_TOKEN}`,
    },
  });

  return res.data.session_token;
}

async function getForms() {
  const session = await getSessionToken();

  const res = await axios.get(`${baseURL}/PluginFormcreatorForm`, {
    headers: {
      "Session-Token": session,
      "App-Token": APP_TOKEN,
    },
  });

  return res.data;
}

getForms()
  .then(forms => console.log(forms))
  .catch(err => console.error(err.response?.data || err.message));
```

## Ejecutar

```bash
npm install
npm run dev
```

Salida esperada (ejemplo):

```
[
  {
    id: 1,
    name: "Solicitud de equipo",
    ...
  }
]
```

---

# 🔍 Endpoints comunes de FormCreator

| Acción               | Endpoint                      |
| -------------------- | ----------------------------- |
| Obtener formularios  | `/PluginFormcreatorForm`      |
| Obtener respuestas   | `/PluginFormcreatorAnswer`    |
| Crear ticket vía API | `/Ticket`                     |
| Crear formulario     | (no soportado vía API nativa) |

---

# 📌 Resumen rápido

| Paso | Acción                                |
| ---- | ------------------------------------- |
| 1    | Levantar GLPI con Docker              |
| 2    | Instalar GLPI y activar FormCreator   |
| 3    | Importar formularios JSON             |
| 4    | Habilitar API REST                    |
| 5    | Crear App-Token y User-Token          |
| 6    | Consumir API desde cualquier servicio |

---

# 📦 Extras

* Backup DB: `docker exec -i glpi_db mysqldump -uglpi -pglpi_pass glpidb > backup.sql`
* Volúmenes persistentes incluyen archivos y config
* Formularios pueden exportarse y versionarse en Git

---

# 📚 Referencias

* GLPI Docs: [https://glpi-project.org](https://glpi-project.org)
* API REST Docs: `http://tu-glpi/apirest.php`
* Basado en guías internas del proyecto: fileciteturn0file1

---

# 🎯 Objetivo final

Con esta guía puedes:
✔ Instalar GLPI rápido
✔ Versionar formularios
✔ Consumir los formularios vía API en cualquier app (Node.js, Python, etc.)
✔ Automatizar flujos de soporte, onboarding, accesos y más 🚀
