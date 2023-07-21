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

