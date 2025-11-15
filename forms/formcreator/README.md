# FormCreator – Formularios exportados

Este directorio contiene los formularios de **FormCreator** exportados desde GLPI.
La idea es poder versionarlos en Git y volver a importarlos fácilmente en una
instancia nueva.

---

## Cómo usar estos formularios

1. Levantar GLPI con Docker (ver README principal del proyecto).
2. Iniciar sesión como super-admin.
3. Ir a: **Administración → Formularios**.
4. En la parte superior, usar **Importar**.
5. Seleccionar uno de los archivos `.json` de este directorio.
6. Revisar después de importar:
   - Entidad asignada
   - Categoría del ticket
   - Grupo / técnico asignado
   - Permisos de acceso al formulario

Repetir el proceso para cada archivo que se quiera importar.

---

## Formularios incluidos

### 1. `form-01-solicitud-equipo.json`
- **Descripción:** Ejemplo: solicitud de nuevo equipo de trabajo (notebook/PC).
- **Destino:** Crea un ticket en la categoría correspondiente.
- **Asignación:** Grupo de Soporte / Mesa de ayuda.
- **Notas:** Ajustar categorías/grupos si cambian en la instancia nueva.

### 2. `form-02-alta-usuario.json`
- **Descripción:** Ejemplo: alta de usuario en sistemas internos.
- **Destino:** Ticket con checklist de tareas (correo, AD, sistemas internos).
- **Asignación:** Grupo de Sistemas.
- **Notas:** Puede requerir categorías específicas en GLPI.

### 3. `form-03-solicitud-acceso-vpn.json`
- **Descripción:** Ejemplo: solicitud de acceso remoto/VPN.
- **Destino:** Ticket con aprobación previa de un responsable.
- **Asignación:** Grupo de Infraestructura / Redes.
- **Notas:** Verificar que el flujo de aprobación esté configurado.

---

## Buenas prácticas

- Cuando se modifique un formulario en GLPI:
  1. Exportarlo de nuevo.
  2. Reemplazar el `.json` correspondiente en este directorio.
  3. Hacer commit con un mensaje claro, por ejemplo:
     - `chore(forms): update alta-usuario form fields`
- Si se agrega un formulario nuevo:
  - Nombrarlo `form-XX-nombre-descriptivo.json`.
  - Agregar una sección nueva en este README explicando para qué sirve.
