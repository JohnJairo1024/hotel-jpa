-- Tabla para la cadena de hoteles
CREATE TABLE CadenaHotelera
(
    nombre_ch         text    NOT NULL,
    numero_de_hoteles integer NOT NULL DEFAULT 0,
    PRIMARY KEY (nombre_ch),
    CHECK (numero_de_hoteles >= 0)
);

-- Tabla para la Oficina Central
CREATE TABLE OficinaCentral
(
    nombre_ch                    TEXT NOT NULL,
    nombre_calle                 TEXT,
    numero_calle                 INT,
    ciudad                       TEXT,
    estado                       VARCHAR(2),
    país                         VARCHAR(2),
    numero_telefono              TEXT NOT NULL,
    direccion_correo_electronico TEXT NOT NULL,
    PRIMARY KEY (nombre_calle, numero_calle, ciudad, estado, país),
    FOREIGN KEY (nombre_ch) REFERENCES CadenaHotelera (nombre_ch) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (numero_calle > 0)
);

-- Tabla para el Hotel
CREATE TABLE Hotel
(
    nombre_ch              text       not null references CadenaHotelera (nombre_ch),
    id_hotel               serial primary key,
    nombre_calle           TEXT       not null,
    numero_calle           int        not null,
    ciudad                 TEXT       not null,
    estado                 VARCHAR(2) not null,
    país                   VARCHAR(2) not null,
    clasificacion          int        not null,
    numero_telefono        text       not null,
    numero_de_habitaciones int        not null default 0,
    check (clasificacion <= 5 and clasificacion >= 0),
    check (numero_de_habitaciones >= 0),
    check (numero_calle > 0)
);

-- Tabla para la Habitación
CREATE TABLE Habitacion
(
    id_hotel          INT,
    numero_habitacion INT,
    tipo_vista        TEXT    NOT NULL,
    capacidad         INT     NOT NULL,
    precio            FLOAT   NOT NULL,
    ampliable         BOOLEAN NOT NULL DEFAULT FALSE,
    area              FLOAT   NOT NULL,
    PRIMARY KEY (id_hotel, numero_habitacion),
    FOREIGN KEY (id_hotel) REFERENCES Hotel (id_hotel) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (numero_habitacion > 0),
    CHECK (capacidad > 0),
    CHECK (precio > 0.00),
    CHECK (area > 0.00)
);

-- Tabla para Amenidades de la Habitación
CREATE TABLE AmenidadesHabitacion
(
    id_hotel          INT,
    numero_habitacion INT,
    amenidad          TEXT,
    PRIMARY KEY (id_hotel, numero_habitacion, amenidad),
    FOREIGN KEY (id_hotel, numero_habitacion) REFERENCES Habitacion (id_hotel, numero_habitacion) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla para Daños en la Habitación
CREATE TABLE DaniosHabitacion
(
    id_hotel          INT,
    numero_habitacion INT,
    dano              TEXT,
    PRIMARY KEY (id_hotel, numero_habitacion, dano),
    FOREIGN KEY (id_hotel, numero_habitacion) REFERENCES Habitacion (id_hotel, numero_habitacion) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla para el Cliente
CREATE TABLE Cliente
(
    sin               TEXT,
    nombre            TEXT       NOT NULL,
    apellido          TEXT       NOT NULL,
    nombre_calle      TEXT       NOT NULL,
    numero_calle      INT        NOT NULL,
    ciudad            TEXT       NOT NULL,
    estado            VARCHAR(2) NOT NULL,
    país              VARCHAR(2) NOT NULL,
    fecha_de_registro TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    PRIMARY KEY (sin),
    CHECK (numero_calle > 0)
);

-- Tabla para el Empleado
CREATE TABLE Empleado
(
    id_hotel     int        not null references Hotel (id_hotel),
    sin          int primary key,
    nombre_calle TEXT       not null,
    numero_calle int        not null,
    ciudad       TEXT       not null,
    estado       VARCHAR(2) not null,
    país         VARCHAR(2) not null,
    nombre       text       not null,
    apellido     text       not null,
    check (numero_calle > 0)
);

-- Tabla para el Rol del Empleado
CREATE TABLE RolEmpleado
(
    sin text not null references Empleado (sin),
    rol text not null,
    primary key (sin, rol)
);

-- Tabla para Reservas
CREATE TABLE Reserva
(
    id_hotel          INT,
    numero_habitacion INT,
    fecha_inicio      TIMESTAMP,
    fecha_fin         TIMESTAMP,
    sin_cliente       TEXT NOT NULL,
    tipo_reserva      BOOLEAN DEFAULT FALSE,
    CHECK (fecha_inicio <= fecha_fin),
    PRIMARY KEY (id_hotel, numero_habitacion, fecha_inicio, fecha_fin),
    FOREIGN KEY (id_hotel, numero_habitacion) REFERENCES Habitacion (id_hotel, numero_habitacion) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (sin_cliente) REFERENCES Cliente (sin) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

-- Tabla para el Registro de Entradas
CREATE TABLE Registrado
(
    sin_empleado      TEXT,
    id_hotel          INT,
    numero_habitacion INT,
    fecha_inicio      TIMESTAMP,
    fecha_fin         TIMESTAMP,
    pago              FLOAT NOT NULL,
    PRIMARY KEY (sin_empleado, id_hotel, numero_habitacion, fecha_inicio, fecha_fin),
    FOREIGN KEY (sin_empleado) REFERENCES Empleado (sin) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_hotel, numero_habitacion, fecha_inicio, fecha_fin) REFERENCES Reserva (id_hotel, numero_habitacion, fecha_inicio, fecha_fin)
        MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CHECK (pago > 0.00)
);

-- Tabla para el Archivo de Reservas
CREATE TABLE ArchivoReservas
(
    id                serial,
    nombre_ch         TEXT,
    id_hotel          INT,
    numero_habitacion INT,
    fecha_inicio      timestamp,
    fecha_fin         timestamp,
    sin_cliente       TEXT,
    sin_empleado      TEXT,
    tipo_reserva      Boolean DEFAULT False,
    PRIMARY KEY (id)
);
