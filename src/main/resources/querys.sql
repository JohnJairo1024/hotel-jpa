-- Consulta principal de habitaciones basada en parámetros
SELECT habitacion.*
FROM habitacion, hotel
WHERE (
          (
              habitacion.id_hotel = hotel.id_hotel AND
              hotel.ciudad = ? AND
              hotel.estado = ? AND
              hotel.pais = ? AND
              hotel.clasificacion = ? AND
              hotel.nombre_ch = ?
              ) AND (
              habitacion.capacidad >= ? AND
              habitacion.precio <= ? AND
              habitacion.area >= ?
              ) AND (
              NOT EXISTS (
                  SELECT 1
                  FROM reserva
                  WHERE (
                            (reserva.id_hotel = habitacion.id_hotel AND reserva.numero_habitacion = habitacion.numero_habitacion) AND (
                                (reserva.fecha_inicio <= ? AND reserva.fecha_fin > ?) OR -- inicio
                                (reserva.fecha_inicio < ? AND reserva.fecha_fin >= ?) OR -- fin
                                (reserva.fecha_inicio >= ? AND reserva.fecha_fin <= ?) -- ?1: inicio, ?2: fin
                                )
                            )
              )
              )
          )
GROUP BY habitacion.id_hotel, habitacion.numero_habitacion;

--------------------------------------------------------------------------------------------------

-- Consulta de habitaciones para un hotel específico
SELECT habitacion.*
FROM habitacion, hotel
WHERE (
          (
              habitacion.id_hotel = ?
              ) AND (
              habitacion.capacidad >= ? AND
              habitacion.precio <= ? AND
              habitacion.area >= ?
              ) AND (
              NOT EXISTS (
                  SELECT 1
                  FROM reserva
                  WHERE (
                            (reserva.id_hotel = habitacion.id_hotel AND reserva.numero_habitacion = habitacion.numero_habitacion) AND (
                                (reserva.fecha_inicio <= ? AND reserva.fecha_fin > ?) OR -- inicio
                                (reserva.fecha_inicio < ? AND reserva.fecha_fin >= ?) OR -- fin
                                (reserva.fecha_inicio >= ? AND reserva.fecha_fin <= ?) -- ?1: inicio, ?2: fin
                                )
                            )
              )
              )
          )
GROUP BY habitacion.id_hotel, habitacion.numero_habitacion;

--------------------------------------------------------------------------------------------------

-- Consulta para obtener información de habitaciones disponibles en hoteles
SELECT p.nombre, e.ciudad, e.categoria, e.numero_habitaciones, s.precio
FROM hotel e
         INNER JOIN habitacion s ON e.id_hotel = s.id_hotel
         INNER JOIN cadenaHotelera p ON s.nombre_ch = p.nombre_ch
WHERE s.numero_habitacion NOT IN (
    SELECT numero_habitacion
    FROM reserva
    WHERE NOT (
        ('2019-04-10' < reserva.fecha_inicio AND '2019-04-12' < reserva.fecha_inicio) OR
        ('2019-04-10' > reserva.fecha_fin AND '2019-04-13' > reserva.fecha_fin)
        ) AND
        1 = reserva.id_hotel AND
        1 = reserva.numero_habitacion
);
