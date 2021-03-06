-- ponerle buenos nombres a las reglas



--The database consist of information of people that can be patients or doctors, but not both

    CREATE RULE regla_update_disjoint_patient
    AS ON UPDATE TO Patient
    WHERE new.pId IN (
        SELECT pId FROM Doctor
    )
    DO INSTEAD select('Un paciente no puede ser doctor');

    CREATE RULE regla_update_disjoint_doctor
    AS ON UPDATE TO Doctor
    WHERE new.pId IN (
        SELECT pId FROM Patient
    )
    DO INSTEAD select('Un doctor no puede ser paciente');

    CREATE RULE regla_insert_disjoint_patient
    AS ON INSERT TO Patient
    WHERE new.pId IN (
        SELECT pId FROM Doctor
    )
    DO INSTEAD select('Un paciente no puede ser doctor');

    CREATE RULE regla_insert_disjoint_doctor
    AS ON INSERT TO Doctor
    WHERE new.pId IN (
        SELECT pId FROM Patient
    )
    DO INSTEAD select('Un doctor no puede ser paciente');

-- A doctor can be leader only of the Area he/she works on.
    CREATE RULE regla_update_doctor_lider 
    AS ON UPDATE TO Area
    WHERE new.name NOT IN (
        SELECT d.works
        FROM Doctor AS d
        WHERE new.ledBy = d.pId
    )
    DO INSTEAD select('Un doctor solo puede ser lider en el area que trabaja.');

    CREATE RULE regla_insert_doctor_lider
    AS ON INSERT TO Area
    WHERE new.ledBy is not null and new.name NOT IN (
        SELECT d.works
        FROM Doctor AS d
        WHERE new.ledBy = d.pId
    )
    DO INSTEAD select('Un doctor solo puede ser lider en el area que trabaja.');

-- Every time a doctor accumulates two years of experience, he/she receives a salary increment of 10% 
    CREATE RULE regla_incremento_salario_experiencia
    AS ON UPDATE TO Doctor
    WHERE new.yearsExperience > old.yearsExperience and new.yearsExperience > 0 AND (new.yearsExperience % 2 = 0)
    DO UPDATE Doctor
    SET salary = old.salary * POWER(1.1, (new.yearsExperience - old.yearsExperience)/2.0)
    WHERE pId = old.pId;


-- It is possible that a doctor changes his/her Area with in the hospital. If the doctor was the leader of the original
-- area, then such an area must select a new leader.
    CREATE RULE regla_update_work
    AS ON UPDATE TO Doctor
    WHERE old.works != new.works and old.works IN (
        SELECT name
        FROM Area
        WHERE ledBy = new.pId
    )
    DO UPDATE Area
    SET ledBy = (
        SELECT pId
        FROM Doctor AS d
        WHERE d.works = old.works AND d.pId != old.pId
        ORDER BY d.yearsExperience DESC
        LIMIT 1
    )
    WHERE ledBy = new.pId;


-- SET SYNTAX '{"x", "y"}'

--A doctor may be associated only to hospital areas that are part of his-her specialties.
    CREATE RULE regla_insert_specialities_area
    AS ON INSERT TO Doctor
    WHERE NOT(new.works = ANY (new.specialities))
    DO INSTEAD select('Un doctor solo puede trabajar en un area que sea una de sus especialidades.');

    CREATE RULE regla_update_specialities_area
    AS ON UPDATE TO Doctor
    WHERE NOT(new.works = ANY (new.specialities))
    DO INSTEAD select('Un doctor solo puede trabajar en un area que sea una de sus especialidades.');


--Premium insurance allows patients to receive treatments for all areas except Radiology.
    CREATE RULE regla_insert_premium_plan
    AS ON INSERT TO Treatment
    WHERE EXISTS(   SELECT * FROM Patient p 
                    WHERE p.pId = new.receivedBy 
                    AND p.insurancePlan = 'Premium') 
        AND EXISTS (SELECT * 
                    FROM Doctor d
                    WHERE d.pId = new.prescribedBy AND d.works = 'Radiology')
    DO INSTEAD select('Pacientes con plan Premium no pueden recibir tratamientos en Radiology.');

    CREATE RULE regla_update_premium_plan
    AS ON UPDATE TO Treatment
    WHERE EXISTS(SELECT * FROM Patient p WHERE p.pId = new.receivedBy AND p.insurancePlan = 'Premium') 
         AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND d.works = 'Radiology')
    DO INSTEAD select('Pacientes con plan Premium no pueden recibir tratamientos en Radiology.');

--Basic Insurance covers only General Medicine, Obstetrics and Pediatrics.
    CREATE RULE regla_insert_basic_plan
    AS ON INSERT TO Treatment
    WHERE EXISTS(SELECT * FROM Patient p WHERE p.pId = new.receivedBy AND p.insurancePlan = 'Basic') 
          AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND (d.works in ('Radiology', 'Traumatology', 'Allergology', 'Cardiology', 'Gerontology')))
    DO INSTEAD select('Pacientes con plan basico solo cubre General Medicine, Obstetrics y Pediatrics.');

    CREATE RULE regla_update_basic_plan
    AS ON UPDATE TO Treatment
    WHERE EXISTS(SELECT *
                FROM Patient p 
                WHERE p.pId = new.receivedBy AND 
                p.insurancePlan = 'Basic') 
    AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND (d.works in ('Radiology', 'Traumatology', 'Allergology', 'Cardiology', 'Gerontology')))
    DO INSTEAD select('Pacientes con plan basico solo cubre General Medicine, Obstetrics y Pediatrics.');

-- INSERT INTO Doctor VALUES(123, '{"General Medicine", "Traumatology"}',1,100,'General Medicine');
-- INSERT INTO Doctor VALUES(777, '{"Allergology", "Traumatology"}',0,50,"General Medicine");

-- DELETE FROM Doctor;
-- DELETE FROM Area;
-- DROP RULE regla_specialities_area ON Doctor;
-- SELECT * FROM Doctor;

-- Evitar mismo pId en person, doctor y patient

    CREATE RULE regla_pId_doctor
    AS ON INSERT TO Doctor
    WHERE new.pId = (
            SELECT pid FROM Person
            where pid = new.pid
        )
    DO INSTEAD select('Ya existe en relacion Person.');

    CREATE RULE regla_pId_patient
    AS ON INSERT TO Patient
    WHERE new.pId = (
            SELECT pId FROM Person
            where pid = new.pid
        )
    DO INSTEAD select('Ya existe en relacion Person.');



    -- DROP RULE regla_pId_patient ON patient
