
CREATE TABLE IF NOT EXISTS rol (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS especialidad (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT
);

CREATE TABLE IF NOT EXISTS sede (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  ciudad VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS medicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  rol_id INT DEFAULT 2,
  especialidad_id INT,
  sede_id INT,
  activo TINYINT DEFAULT 0,
  foto_perfil VARCHAR(255),
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  actualizado_en DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (rol_id) REFERENCES rol(id),
  FOREIGN KEY (especialidad_id) REFERENCES especialidad(id),
  FOREIGN KEY (sede_id) REFERENCES sede(id)
);

CREATE TABLE IF NOT EXISTS neonato (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  documento VARCHAR(500),
  sexo VARCHAR(10),
  fecha_nacimiento DATE,
  edad_gestacional_sem INT,
  edad_corregida_sem INT,
  peso_nacimiento_g DECIMAL(10,2),
  peso_actual_g DECIMAL(10,2),
  perimetro_cefalico DECIMAL(10,2),
  created_by_medico_id INT,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by_medico_id) REFERENCES medicos(id)
);

CREATE TABLE IF NOT EXISTS acudiente (
  id INT AUTO_INCREMENT PRIMARY KEY,
  neonato_id INT,
  nombre VARCHAR(100),
  apellido VARCHAR(100),
  sexo VARCHAR(10),
  parentesco VARCHAR(50),
  telefono VARCHAR(500),
  correo VARCHAR(500),
  FOREIGN KEY (neonato_id) REFERENCES neonato(id)
);

CREATE TABLE IF NOT EXISTS ecografias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  neonato_id INT,
  uploader_medico_id INT,
  sede_id INT,
  filepath VARCHAR(255),
  mime_type VARCHAR(100),
  size_bytes BIGINT,
  thumbnail_path VARCHAR(255),
  dicom_metadata JSON,
  fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (neonato_id) REFERENCES neonato(id),
  FOREIGN KEY (uploader_medico_id) REFERENCES medicos(id),
  FOREIGN KEY (sede_id) REFERENCES sede(id)
);

CREATE TABLE IF NOT EXISTS reportes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ecografia_id INT UNIQUE,
  created_by_medico_id INT,
  updated_by_medico_id INT,
  titulo VARCHAR(255),
  contenido TEXT,
  hallazgos TEXT,
  conclusion TEXT,
  recomendaciones TEXT,
  firma_medico TEXT,
  fecha_reporte DATETIME,
  estado VARCHAR(20) DEFAULT 'borrador',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (ecografia_id) REFERENCES ecografias(id),
  FOREIGN KEY (created_by_medico_id) REFERENCES medicos(id),
  FOREIGN KEY (updated_by_medico_id) REFERENCES medicos(id)
);

CREATE TABLE IF NOT EXISTS reportes_historial (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reporte_id INT,
  version INT,
  datos_json JSON,
  medico_id INT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reporte_id) REFERENCES reportes(id),
  FOREIGN KEY (medico_id) REFERENCES medicos(id)
);

-- Datos 

INSERT INTO rol (nombre) VALUES ('admin'), ('medico');

INSERT INTO especialidad (nombre, descripcion) VALUES
  ('Neonatología', 'Especialidad en recién nacidos'),
  ('Pediatría', 'Especialidad en niños'),
  ('Neurología Pediátrica', 'Neurología infantil');

INSERT INTO sede (nombre, ciudad) VALUES
  ('Hospital Central', 'Bogotá'),
  ('Clínica Norte', 'Medellín');

INSERT INTO medicos (nombre, apellido, email, password, rol_id, especialidad_id, sede_id, activo)
VALUES ('Admin', 'JoeyCare', 'admin@joeycare.com', 'admin123', 1, 1, 1, 1);

INSERT INTO neonato (nombre, apellido, documento, sexo, fecha_nacimiento, edad_gestacional_sem, peso_nacimiento_g, created_by_medico_id)
VALUES ('Bebé', 'Prueba', 'DOC123456', 'M', '2025-12-01', 38, 3200, 1);