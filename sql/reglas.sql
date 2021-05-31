-- ponerle buenos nombres a las reglas

-- regla1
CREATE RULE regla_1 
AS ON UPDATE TO Area
WHERE new.name NOT IN (
    SELECT d.works
    FROM Doctor AS d
    WHERE new.ledBy = d.pId
)
DO NOTHING; -- o que imprima un mensaje, no se

-- regla2 
CREATE RULE regla_2
AS ON UPDATE TO Doctor
WHERE new.yearsExperience > old.yearsExperience and new.yearsExperience > 0 AND (new.yearsExperience % 2 = 0)
DO UPDATE Doctor
SET salary = old.salary * 1.10
WHERE pId = old.pId;


-- regla3

CREATE RULE regla_3
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
    WHERE d.works = old.works
    ORDER BY d.yearsExperience DESC
    LIMIT 1
)
WHERE ledBy = new.pId


