# Sistema de Control de Obras Municipales

## Autor

Luiggi Orzon Guachun Gonzalez

## Descripción

Sistema web desarrollado para gestionar y supervisar obras públicas municipales, permitiendo administrar contratistas, supervisores, obras, avances de ejecución y reportes.

## Tecnologías Utilizadas

### Backend

* Node.js
* Express.js
* MySQL
* Swagger

### Frontend

* Flutter Web

### Base de Datos

* MySQL

## Funcionalidades

### Contratistas

* Crear contratistas
* Consultar contratistas
* Actualizar contratistas
* Eliminar contratistas

### Supervisores

* Crear supervisores
* Consultar supervisores
* Actualizar supervisores
* Eliminar supervisores

### Obras

* Crear obras
* Consultar obras
* Actualizar obras
* Eliminar obras
* Filtrar obras por estado

### Avances

* Registrar avances de obra
* Consultar avances
* Actualizar avances
* Eliminar avances

### Autenticación

* Inicio de sesión mediante usuario y contraseña

## Instalación Backend

```bash
cd backend
npm install
npm run dev
```

Servidor:

```text
http://localhost:3000
```

Swagger:

```text
http://localhost:3000/docs
```

## Instalación Frontend

```bash
cd frontend_flutter
flutter pub get
flutter run -d chrome
```

## Base de Datos

Crear la base de datos:

```sql
obras_municipales_db
```

Ejecutar el archivo:

```text
schemas.sql
```

## Usuario de Prueba

Usuario:

```text
admin
```

Contraseña:

```text
123456
```

## Funcionalidad Adicional

Filtrado de obras por estado:

```text
GET /api/obras/estado/:estado
```

Ejemplo:

```text
GET /api/obras/estado/en_ejecucion
```
