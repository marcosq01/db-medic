-- ponerle buenos nombres a las reglas



--The database consist of information of people that can be patients or doctors, but not both

    CREATE RULE regla_update_disjoint_patient
    AS ON UPDATE TO Patient
    WHERE new.pId IN (
        SELECT pId FROM Doctor
    )
    DO NOTHING;

    CREATE RULE regla_update_disjoint_doctor
    AS ON UPDATE TO Doctor
    WHERE new.pId IN (
        SELECT pId FROM Patient
    )
    DO NOTHING;

    CREATE RULE regla_insert_disjoint_patient
    AS ON INSERT TO Patient
    WHERE new.pId IN (
        SELECT pId FROM Doctor
    )
    DO NOTHING;

    CREATE RULE regla_insert_disjoint_doctor
    AS ON INSERT TO Doctor
    WHERE new.pId IN (
        SELECT pId FROM Patient
    )
    DO NOTHING;

-- A doctor can be leader only of the Area he/she works on.
    CREATE RULE regla_update_doctor_lider 
    AS ON UPDATE TO Area
    WHERE new.name NOT IN (
        SELECT d.works
        FROM Doctor AS d
        WHERE new.ledBy = d.pId
    )
    DO NOTHING; -- o que imprima un mensaje, no se

    CREATE RULE regla_insert_doctor_lider2 
    AS ON INSERT TO Area
    WHERE new.name NOT IN (
        SELECT d.works
        FROM Doctor AS d
        WHERE new.ledBy = d.pId
    )
    DO NOTHING; 

-- Every time a doctor accumulates two years of experience, he/she receives a salary increment of 10% 
    CREATE RULE regla_incremento_salario_experiencia
    AS ON UPDATE TO Doctor
    WHERE new.yearsExperience > old.yearsExperience and new.yearsExperience > 0 AND (new.yearsExperience % 2 = 0)
    DO UPDATE Doctor
    SET salary = old.salary * POWER(1.1, (new.yearsExperience - old.yearsExperience)/2)
    WHERE pId = old.pId;

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
    WHERE ledBy = new.pId


-- SET SYNTAX '{"x", "y"}'

--A doctor may be associated only to hospital areas that are part of his-her specialties.
    CREATE RULE regla_insert_specialities_area
    AS ON INSERT TO Doctor
    WHERE NOT(new.works = ANY (new.specialities))
    DO NOTHING;

    CREATE RULE regla_update_specialities_area
    AS ON UPDATE TO Doctor
    WHERE NOT(new.works = ANY (new.specialities))
    DO NOTHING;

--Premium insurance allows patients to receive treatments for all areas except Radiology.
    CREATE RULE regla_insert_premium_plan
    AS ON INSERT TO Treatment
    WHERE EXISTS(SELECT * FROM Patient p WHERE p.pId = new.receivedBy AND p.insurancePlan = 'Premium') AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND d.works = 'Radiology')
    DO NOTHING;

    CREATE RULE regla_update_premium_plan
    AS ON UPDATE TO Treatment
    WHERE EXISTS(SELECT * FROM Patient p WHERE p.pId = new.receivedBy AND p.insurancePlan = 'Premium') AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND d.works = 'Radiology')
    DO NOTHING;

--Basic Insurance covers only General Medicine, Obstetrics and Pediatrics.
    CREATE RULE regla_insert_basic_plan
    AS ON INSERT TO Treatment
    WHERE EXISTS(SELECT * FROM Patient p WHERE p.pId = new.receivedBy AND p.insurancePlan = 'Basic') AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND (d.works in ('Radiology', 'Traumatology', 'Allergology', 'Cardiology', 'Gerontology')))
    DO NOTHING;

    CREATE RULE regla_update_basic_plan
    AS ON UPDATE TO Treatment
    WHERE EXISTS(SELECT * FROM Patient p WHERE p.pId = new.receivedBy AND p.insurancePlan = 'Basic') AND EXISTS(SELECT * FROM Doctor d WHERE d.pId = new.prescribedBy AND (d.works in ('Radiology', 'Traumatology', 'Allergology', 'Cardiology', 'Gerontology')))
    DO NOTHING;

-- INSERT INTO Doctor VALUES(123, '{"General Medicine", "Traumatology"}',1,100,'General Medicine');
-- INSERT INTO Doctor VALUES(777, '{"Allergology", "Traumatology"}',0,50,"General Medicine");

-- DELETE FROM Doctor;
-- DELETE FROM Area;
-- DROP RULE regla_specialities_area ON Doctor;
-- SELECT * FROM Doctor;
