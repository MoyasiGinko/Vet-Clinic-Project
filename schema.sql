/* Database schema to keep the structure of entire database. */
/* Create a table animals with the following columns:*/
CREATE TABLE animals (
    id SERIAL NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL(5,2) NOT NULL
);

/*Add a column species of type string to your animals table.*/
ALTER TABLE animals ADD COLUMN species varchar(100);

/*Create a table named owners*/
CREATE TABLE owners (
    id SERIAL NOT NULL PRIMARY KEY,
    full_name varchar(100) NOT NULL,
    age INT NOT NULL
);


/*Create a table named species*/
CREATE TABLE species (
    id SERIAL NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL
);

/*Add a column species_id of type integer to your animals table.*/
ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);

