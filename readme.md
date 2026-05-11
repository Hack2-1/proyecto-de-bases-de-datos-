# Sistema de Gestión Académica: Lingua Viva

## Descripción del Proyecto
Este repositorio contiene el diseño, estructuración e implementación de una base de datos relacional para la administración integral de una escuela de idiomas ("Lingua Viva"). El proyecto fue desarrollado con fines académicos para la Facultad de Estadística e Informática de la Universidad Veracruzana, enfocado en resolver las necesidades de control de usuarios, asignación de carga académica y reportes financieros.

## Equipo de Desarrollo (Equipo 4)
* **Eddi Michael Hernández Rodríguez**
* ** ejm**
* **Christian Mora**

## Arquitectura y Decisiones de Diseño
El núcleo del proyecto es una base de datos estructurada bajo la **Tercera Forma Normal (3FN)**, garantizando la atomicidad de los datos y eliminando la redundancia. 

Las decisiones clave de infraestructura incluyen:
* **Integridad Referencial Estricta:** Implementación de llaves foráneas (`FOREIGN KEY`) con políticas de eliminación en cascada (`ON DELETE CASCADE`) para evitar registros huérfanos.
* **Control de Acceso Basado en Roles (RBAC):** Separación lógica de privilegios mediante un tipo enumerado (`ENUM`) en la entidad `Usuario`, aislando las vistas y operaciones de Administradores, Profesores y Alumnos en la capa de presentación (PHP).
* **Restricciones a Nivel de Motor (Constraints):** Uso de índices únicos (`UNIQUE KEY`) en correos electrónicos y folios de pago para delegar la validación de duplicidad al motor de la base de datos (MySQL).

## Módulos del Sistema
1. **Módulo Administrativo:** Gestión de usuarios (CRUD), auditoría de inscripciones y generación de reportes complejos mediante consultas de agregación (`JOIN`, `COUNT`, `SUM`).
2. **Módulo Docente:** Aislamiento de datos que permite a cada profesor visualizar únicamente los grupos y métricas de sus materias asignadas.
3. **Módulo Estudiantil:** Expediente de solo lectura para consulta de nivel de idioma, grupo y estado de inscripción.

## Medidas de Ciberseguridad Implementadas
* **Prevención de SQL Injection (SQLi):** Uso exclusivo de consultas preparadas (*Prepared Statements*) en operaciones de autenticación y extracción de datos.
* **Mitigación de Cross-Site Scripting (XSS):** Sanitización estricta de salida mediante `htmlspecialchars()` con codificación UTF-8 en la renderización del Dashboard.
* **Respaldo Físico:** Scripting de copias de seguridad de infraestructura mediante la utilidad `mysqldump`.

## Instrucciones de Despliegue Local
1. Clonar este repositorio: `git clone <URL_DEL_REPOSITORIO>`
2. Importar la estructura y los datos de prueba ejecutando el archivo `backup_lingua_viva.sql` en MySQL Server 8.0+.
3. Iniciar un servidor web local (ej. PHP Development Server o Apache) apuntando al directorio raíz del proyecto.
4. Acceder a `index.php` utilizando las credenciales de prueba provistas en la documentación interna.
