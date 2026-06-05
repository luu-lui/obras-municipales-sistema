CREATE DATABASE IF NOT EXISTS obras_municipales_db;
USE obras_municipales_db;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario VARCHAR(100) NOT NULL UNIQUE,
  contrasena VARCHAR(255) NOT NULL,
  rol VARCHAR(50) DEFAULT 'admin'
);

INSERT INTO usuarios (usuario, contrasena, rol)
VALUES ('admin', '123456', 'admin');

CREATE TABLE contratistas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  ruc VARCHAR(20) NOT NULL,
  telefono VARCHAR(50) NOT NULL,
  correo VARCHAR(255) NOT NULL,
  direccion VARCHAR(255)
);

CREATE TABLE supervisores (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  cargo VARCHAR(100) NOT NULL,
  telefono VARCHAR(50) NOT NULL,
  correo VARCHAR(255) NOT NULL
);

CREATE TABLE obras (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  tipo VARCHAR(100) NOT NULL,
  ubicacion VARCHAR(255) NOT NULL,
  presupuesto DECIMAL(12,2) NOT NULL,
  estado VARCHAR(50) DEFAULT 'planificada',
  fecha_inicio DATE,
  fecha_fin DATE,
  contratista_id INT NOT NULL,
  supervisor_id INT NOT NULL,
  FOREIGN KEY (contratista_id) REFERENCES contratistas(id),
  FOREIGN KEY (supervisor_id) REFERENCES supervisores(id)
);

CREATE TABLE avances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  obra_id INT NOT NULL,
  fecha DATE NOT NULL,
  porcentaje DECIMAL(5,2) NOT NULL,
  descripcion TEXT NOT NULL,
  gasto_ejecutado DECIMAL(12,2) DEFAULT 0,
  observaciones TEXT,
  FOREIGN KEY (obra_id) REFERENCES obras(id)
);