-- ============================================================
-- 1. TABLAS INDEPENDIENTES (Sin FK)
-- ============================================================

CREATE TABLE aeropuertos (
    id_aeropuerto INT PRIMARY KEY,
    codigo_iata VARCHAR(3),
    codigo_icao VARCHAR(4),
    nombre VARCHAR(200),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);

CREATE TABLE modelos_avion (
    id_modelo INT PRIMARY KEY,
    modelo VARCHAR(50),
    fabricante VARCHAR(50),
    capacidad_pasajeros INT,
    alcance_km INT
);

CREATE TABLE aerolineas (
    id_aerolinea INT PRIMARY KEY,
    codigo_iata VARCHAR(2),
    nombre VARCHAR(100),
    pais_origen VARCHAR(100)
);

CREATE TABLE pasajeros (
    id_pasajero INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    num_pasaporte VARCHAR(20),
    nacionalidad VARCHAR(50),
    email VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE reservas (
    id_reserva INT PRIMARY KEY,
    codigo_reserva VARCHAR(10),
    fecha_reserva DATETIME,
    estado VARCHAR(70)
);

-- ============================================================
-- 2. TABLAS DE PRIMER NIVEL DE DEPENDENCIA
-- ============================================================

CREATE TABLE puertas_embarque (
    id_puerta INT PRIMARY KEY,
    id_aeropuerto INT,
    numero_puerta VARCHAR(10),
    terminal VARCHAR(10),
    FOREIGN KEY (id_aeropuerto) REFERENCES aeropuertos(id_aeropuerto)
);

CREATE TABLE empleados (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    puesto VARCHAR(50),
    id_aerolinea INT,
    FOREIGN KEY (id_aerolinea) REFERENCES aerolineas(id_aerolinea)
);

CREATE TABLE aviones (
    id_avion INT PRIMARY KEY,
    id_modelo INT,
    id_aerolinea INT,
    matricula VARCHAR(20),
    estado VARCHAR(70),
    FOREIGN KEY (id_modelo) REFERENCES modelos_avion(id_modelo),
    FOREIGN KEY (id_aerolinea) REFERENCES aerolineas(id_aerolinea)
);

-- ============================================================
-- 3. TABLA CENTRAL (VUELOS)
-- ============================================================

CREATE TABLE vuelos (
    id_vuelo INT PRIMARY KEY,
    numero_vuelo VARCHAR(10),
    id_aerolinea INT,
    id_avion INT,
    id_aeropuerto_origen INT,
    id_aeropuerto_destino INT,
    id_puerta_salida INT,
    fecha_salida_programada DATETIME,
    fecha_llegada_programada DATETIME,
    fecha_salida_real DATETIME,
    fecha_llegada_real DATETIME,
    estado VARCHAR(70),
    FOREIGN KEY (id_aerolinea) REFERENCES aerolineas(id_aerolinea),
    FOREIGN KEY (id_avion) REFERENCES aviones(id_avion),
    FOREIGN KEY (id_aeropuerto_origen) REFERENCES aeropuertos(id_aeropuerto),
    FOREIGN KEY (id_aeropuerto_destino) REFERENCES aeropuertos(id_aeropuerto),
    FOREIGN KEY (id_puerta_salida) REFERENCES puertas_embarque(id_puerta)
);

-- ============================================================
-- 4. TABLAS RELACIONADAS A VUELOS, PASAJEROS Y EMPLEADOS
-- ============================================================

CREATE TABLE tripulacion_vuelo (
    id_vuelo INT,
    id_empleado INT,
    rol_en_vuelo VARCHAR(30),
    PRIMARY KEY (id_vuelo, id_empleado),
    FOREIGN KEY (id_vuelo) REFERENCES vuelos(id_vuelo),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE billetes (
    id_billete INT PRIMARY KEY,
    id_reserva INT,
    id_pasajero INT,
    id_vuelo INT,
    numero_asiento VARCHAR(5),
    clase VARCHAR(20),
    precio DECIMAL(10, 2),
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva),
    FOREIGN KEY (id_pasajero) REFERENCES pasajeros(id_pasajero),
    FOREIGN KEY (id_vuelo) REFERENCES vuelos(id_vuelo)
);

-- ============================================================
-- 5. TABLAS DEPENDIENTES DE BILLETES
-- ============================================================

CREATE TABLE tarjetas_embarque (
    id_boarding_pass INT PRIMARY KEY,
    id_billete INT,
    codigo_qr TEXT,
    hora_embarque DATETIME,
    estado_embarque VARCHAR(20),
    FOREIGN KEY (id_billete) REFERENCES billetes(id_billete)
);

CREATE TABLE equipajes (
    id_equipaje INT PRIMARY KEY,
    id_billete INT,
    codigo_etiqueta VARCHAR(20),
    peso_kg DECIMAL(5, 2),
    estado VARCHAR(20),
    FOREIGN KEY (id_billete) REFERENCES billetes(id_billete)
);