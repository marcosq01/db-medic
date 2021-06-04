--The database consist of information of people that can be patients or doctors, but not both
-- El siguiente ya existe en Doctor, por lo que se debe evitar el insert.
INSERT INTO Patient VALUES (13, 'Marcos', 'Quintero', '1999-11-06', 'M', 'Unlimited');



-- A doctor can be leader only of the Area he/she works on.

-- Renata Gonzalez solo tiene Cardiology, por lo que si al Area de Radiology le intentamos poner
-- el id de Renata, debe activarse la regla y no permitir el cambio.
UPDATE Area 
SET ledBy = 18
WHERE name = 'Radiology'

-- Intenamos lo mismo con Mauricio Martinez que no tiene General Medicine como especialidad.
UPDATE Area 
SET ledBy = 14
WHERE name = 'General Medicine'

-- Every time a doctor accumulates two years of experience, he/she receives a salary increment of 10% 
UPDATE Doctor
SET yearsExperience = 10
WHERE  pid = 17
--------------------

-- It is possible that a doctor changes his/her Area with in the hospital. If the doctor was the leader of the original
-- area, then such an area must select a new leader.

-- Carlos Martinez es encargado de Radiology, le cambiamos su area de trabajo.
-- Entonces Radiology debe cambiar a otro lider.

UPDATE Doctor
SET works = 'Obstetrics'
WHERE pid = 17;

SELECT * FROM Area
where name = 'Radiology';

--A doctor may be associated only to hospital areas that are part of his-her specialties.

UPDATE DOCTOR 
SET works = 'Radiology'
WHERE pid = 18;

SELECT * FROM Doctor;


--Premium insurance allows patients to receive treatments for all areas except Radiology.

INSERT INTO Treatment values(9, 17, 10, '{"Aspirina"}', 'Tomar cada 50 horas');

--Basic Insurance covers only General Medicine, Obstetrics and Pediatrics.

INSERT INTO Treatment values(8, 18, 15, '{"Aspirina"}', 'Tomar cada 10 horas');


-- Unlimited
INSERT INTO Treatment values(7, 14, 15, '{"Aspirina"}', 'Tomar cada 10 horas');
