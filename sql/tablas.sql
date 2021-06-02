--CREATE DATABASE TareaObjetosRelacional;

-- Primero creamos los tipos necesarios para los planes y para especialidades
CREATE TYPE insurancePlan_t AS ENUM('Unlimited', 'Premium', 'Basic');
CREATE TYPE speciality_t AS ENUM('General Medicine', 'Traumatology', 'Allergology', 'Radiology', 'Cardiology', 'Gerontology', 'Obstetrics', 'Pediatrics');

-- Las tablas

CREATE TABLE Person (
    pId       int,
    firstName varchar(20),
    lastName  varchar(20),
    dob       date,
    gender    varchar(1),

    PRIMARY key (pId)
);

-- las tablas doctor y patient heredan de person

CREATE TABLE Patient (
    pId           int,
    insurancePlan insurancePlan_t,
    PRIMARY KEY (pId)
) INHERITS (Person);

create table Doctor (
    pId             int, 
    specialities    speciality_t[],
    yearsExperience int,
    salary          float,
    PRIMARY KEY (pId)
);

CREATE TABLE Area (
    name     speciality_t,
    location varchar(30),
    ledBy    int,
    PRIMARY KEY (name)
);

-- necesita ir despues del create table de Area
ALTER TABLE Doctor ADD COLUMN works speciality_t REFERENCES Area(name);

CREATE TABLE Treatment (
    receivedBy   int REFERENCES Patient(pId),
    prescribedBy int REFERENCES Doctor(pId),
    duration     int,
    medicaments  varchar(25)[],
    description  varchar(80)
)
