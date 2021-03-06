-- escrito y probado en consola, Fedora 34

-- 1. psql hace disponibles comandos para crear bases de datos desde el entorno de usuario global.
-- $ createdb posts -- (igual que CREATE DATABASE posts) pero desde el user de Linux. 
-- $ psql posts -- (para entrar al entorno psql en la base de datos posts y continuar con el requerimiento).

-- 2. crear tabla posts
CREATE TABLE post(
    id SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL,
    fecha_creacion DATE NOT NULL,
    contenido VARCHAR NOT NULL,
    descripcion VARCHAR(255) NOT NULL);

-- 3. insertar 3 posts, 2 para "Pamela" y 1 para "Carlos"
INSERT INTO post (nombre_usuario, fecha_creacion, contenido, descripcion)
VALUES
    ('Pamela', '2020-05-23', 'contenido del 1er post de Pamela', 'descripcion post 1 Pamela'),
    ('Pamela', '2020-05-25', 'contenido del 2do post de Pamela', 'descripcion post 2 Pamela'),
    ('Carlos', '2020-04-13', 'contenido del 1er post de Carlos', 'descripcion post 1 Carlos')
RETURNING *; -- solo para confirmar la correcta inserción de los registros.

-- 4. Modificar la tabla post, agregando la columna titulo
ALTER TABLE post ADD titulo VARCHAR(100);

-- 5. Agregar título a los registros ya creados.
UPDATE post SET titulo='Pamela - Post 1' WHERE id='1';
UPDATE post SET titulo='Pamela - Post 2' WHERE id='2';
UPDATE post SET titulo='Carlos - Post 1' WHERE id='3';

-- 5. Extra: configurar columna titulo NOT NULL para evitar futuros campos vacíos.
ALTER TABLE psot ALTER COLUMN titulo SET NOT NULL;

-- 6. Insertar 2 registros para el usuario "Pedro"
INSERT INTO post (nombre_usuario, fecha_creacion, contenido, descripcion, titulo)
VALUES
    ('Pedro', '2021-12-02', 'Contenido del 1er post de Pedro', 'Descripcion post 1 Pedro', 'Pedro - Post 1'),
    ('Pedro', '2021-12-05', 'Contenido del 2do post de Pedro', 'Descripcion post 2 Pedro', 'Pedro - Post 2')
RETURNING *;

-- 7. Eliminar post de Carlos
DELETE FROM post WHERE id='3';

-- 8. Agregar un nuevo post para Carlos
INSERT INTO 
post (nombre_usuario, fecha_creacion, contenido, descripcion, titulo)
VALUES('Carlos', '2020-06-30', 'Contenido del 2do post de Carlos', 'Descripcion post 2 Carlos', 'Carlos - Post 2')
RETURNING *;

-- PARTE 2
-- 1. crear tabla 'comentarios' (id, fecha, hora_creacion, contenido) FOREING KEY id,
CREATE TABLE comentarios(
    id INT NOT NULL REFERENCES post(id) ,
    fecha DATE NOT NULL,
    hora_creacion TIME NOT NULL,
    contenido VARCHAR NOT NULL);
-- \d comentarios  verificar correcta creacion de la tabla.

-- 2. crear 2 registros para user 'Pamela' y 4 para user 'Carlos'
-- SELECT * FROM post;   para verificar contenido actual de tabla.
INSERT INTO comentarios (id, fecha, hora_creacion, contenido)
VALUES
    ('1', '2021-01-03', '12:00:00', 'Comentario 1 en post 1 de Pamela'),
    ('1', '2021-01-04', '12:00:00', 'Comentario 1 en post 2 de Pamela'),
    ('1', '2021-01-03', '12:00:00', 'Comentario 1 en post 2 de Carlos'),
    ('1', '2021-01-05', '12:00:00', 'Comentario 2 en post 2 de Carlos'),
    ('1', '2021-01-07', '12:00:00', 'Comentario 3 en post 2 de Carlos'),
    ('1', '2021-01-09', '12:00:00', 'Comentario 4 en post 2 de Carlos')
RETURNING *;
-- 3. crear un registro en 'post' para 'Margarita'
INSERT INTO 
post (nombre_usuario, fecha_creacion, contenido, descripcion, titulo) 
VALUES('Margarita', '2021-07-01', 'Contenido del 1er post de Margarita', 'Descripcion del 1er post de Margarita', 'Margarita - Post 1') 
RETURNING *;

-- 4. crear 5 registros en 'comentarios' para user Margarita
INSERT INTO comentarios (id, fecha, hora_creacion, contenido) 
VALUES 
('7', '2021-07-02', '12:00:00', '1er comentario a 1er post de Margarita'), 
('7', '2021-07-03', '12:00:00', '2do comentario a 1er post de Margarita'), 
('7', '2021-07-04', '12:00:00', '3er comentario a 1er post de Margarita'), 
('7', '2021-07-05', '12:00:00', '4to comentario a 1er post de Margarita'), 
('7', '2021-07-08', '12:00:00', '5to comentario a 1er post de Margarita') 
RETURNING *;


-- RESULTADO
-- id | nombre_usuario | fecha_creacion |              contenido              |              descripcion              |       titulo       
-- ----+----------------+----------------+-------------------------------------+---------------------------------------+--------------------
--  2 | Pamela         | 2021-05-25     | Contenido 2do post Pamela           | Descripcion 2do post Pamela           | Pamela - Post 2
--  1 | Pamela         | 2021-05-23     | Contenido 1er post Pamela           | Descripcion 1er post Pamela           | Pamela - Post 1
--  4 | Pedro          | 2021-12-02     | Contenido del 1er post de Pedro     | Descripcion 1er post Pedro            | Pedro - Post 1
--  5 | Pedro          | 2021-12-05     | Contenido del 2do post de Pedro     | Descripcion 2do post Pedro            | Pedro - Post 2
--  6 | Carlos         | 2021-02-23     | Contenido 2do post de Carlos        | Descripcion 2do post de Carlos        | Carlos - Post 2
--  7 | Margarita      | 2021-07-01     | Contenido del 1er post de Margarita | Descripcion del 1er post de Margarita | Margarita - Post 1

-- id |   fecha    | hora_creacion |               contenido                
-- ----+------------+---------------+----------------------------------------
--  1 | 2021-01-03 | 12:00:00      | Comentario 1 en post 1 de Pamela
--  2 | 2021-01-06 | 12:00:00      | Comentario 1 en post 2 de Pamela
--  6 | 2021-05-23 | 12:00:00      | Comentario 1 en post 2 de Carlos
--  6 | 2021-05-25 | 12:00:00      | Comentario 2 en post 2 de Carlos
--  6 | 2021-05-30 | 12:00:00      | Comentario 3 en post 2 de Carlos
--  6 | 2021-06-12 | 12:00:00      | Comentario 4 en post 2 de Carlos
--  7 | 2021-07-02 | 12:00:00      | 1er comentario a 1er post de Margarita
--  7 | 2021-07-03 | 12:00:00      | 2do comentario a 1er post de Margarita
--  7 | 2021-07-04 | 12:00:00      | 3er comentario a 1er post de Margarita
--  7 | 2021-07-05 | 12:00:00      | 4to comentario a 1er post de Margarita
--  7 | 2021-07-08 | 12:00:00      | 5to comentario a 1er post de Margarita