/* Database schema to keep the structure of entire database. */
/* Create a table animals with the following columns*/
CREATE TABLE animals (
    id SERIAL NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL(5,2) NOT NULL
);

/*Add a column species of type string to animals table.*/
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

/*Add a column species_id and owner_id to animals table.*/
ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);


/*Create a table named vets*/
CREATE TABLE vets (
    id SERIAL NOT NULL PRIMARY KEY,
    name varchar(100) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

/*Create a table named specializations*/
CREATE TABLE specializations (
    id SERIAL NOT NULL PRIMARY KEY,
    vet_id INT REFERENCES vets(id),
    species_id INT REFERENCES species(id)
);

/*Create a table named visits*/
CREATE TABLE visits (
    id SERIAL NOT NULL PRIMARY KEY,
    vet_id INT REFERENCES vets(id),
    animal_id INT REFERENCES animals(id),
    date_of_visit DATE NOT NULL
); 

