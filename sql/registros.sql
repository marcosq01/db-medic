SELECT * FROM person;
SELECT * FROM patient;
SELECT * From doctor;
SELECT * FROM area;

-- Poblar la tabla person (participacion parcial)
INSERT INTO Person VALUES (1, 'Elsa', 'Dillon', '1971-07-13', 'F'), 
(2, 'Neo', 'Moses', '1985-02-10', 'M'), (3, 'Irene', 'Riggs', '1996-02-28', 'F'), 
(4, 'Javan', 'Ramirez', '1986-05-18', 'M'), (5, 'Markus', 'Mcarthur', '1997-03-07', 'M'),
(6, 'Pola', 'Coles', '1963-06-19', 'F')

-- Poblar la tabla patient
INSERT INTO patient VALUES (7, 'Lionel', 'Messi', '1987-06-24', 'M', 'Unlimited'), (8, 'Bibi', 'Barrera', '1998-03-24', 'F', 'Basic'),
(9, 'Pamela', 'Gonzalez', '2000-07-18', 'F', 'Premium'), (10, 'Karen', 'Berenice', '2000-08-22', 'F', 'Unlimited'),
(11, 'Zack', 'Totopo', '2005-01-21', 'M', 'Basic'), (12, 'Veronika', 'Waffle', '2003-08-21', 'M', 'Premium');

-- DELETE FROM Area WHERE (name = 'Obstetrics')

-- Poblar tabla Area (dejando quien lidera en vacio)
INSERT INTO area (name, location) VALUES ('Cardiology', 'Building 3'),
('General Medicine', 'Main Building'), ('Allergology', 'Building 2'),
('Radiology', '13th Floor');

-- Poblar la tabla doctor 
INSERT INTO doctor VALUES (13, 'Marcos', 'Quintero', '1999-11-06', 'M', '{"Cardiology", "General Medicine"}', 3, 120000, 'Cardiology'),
(14, 'Mauricio', 'Martinez', '1990-11-16', 'M', '{"Radiology", "Gerontology"}', 5, 100000, 'Radiology'),
(15, 'Jazmin', 'Santibañez', '1994-03-24', 'F', '{"Allergology", "General Medicine"}', 4, 110000, 'Allergology'),
(16, 'Ness', 'Tamez',  '1993-06-23', 'F', '{"Allergology"}', 2, 80000, 'Allergology' ),
(17, 'Carlos', 'Martinez', '1986-09-06', 'M', '{"Radiology", "Obstetrics", "Pediatrics"}', 8, 120000, 'Radiology'),
(18, 'Renata', 'Gonzalez', '1999-02-14', 'F', '{"Cardiology"}', 1, 60000, 'Cardiology'),
(19, 'Raul', 'Sanchez', '1969-08-06', 'M', '{"General Medicine"}', 12, 150000, 'General Medicine');


-- Añadir quien lidera cada departamento
UPDATE area SET ledby = 13 WHERE name = 'Cardiology';
UPDATE area SET ledby = 19 WHERE name = 'General Medicine';
UPDATE area SET ledby = 17 WHERE name = 'Radiology';
UPDATE area SET ledby = 15 WHERE name = 'Allergology';

-- Poblar tabla treatment