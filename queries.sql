/*Queries that provide answers to the questions from all projects.*/

\d animals;
SELECT * FROM animals;

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/*Inside a transaction update the animals table by setting the species column to unspecified.*/
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/*Inside a transaction update the animals table by setting the species column to digimon for all animals that have a name ending in mon.*/
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT * FROM animals;
COMMIT;
SELECT * FROM animals;

/*Inside a transaction delete all records in the animals table, then roll back the transaction.*/
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

/*Inside a transaction delete all records in the animals table, then commit the transaction.*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;


/*Inside a transaction delete all records in the animals table, then commit the transaction.*/
SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT name, neutered, escape_attempts FROM animals WHERE escape_attempts = (SELECT MAX(escape_attempts) FROM animals);
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


/*What animals belong to Melody Pond?*/
SELECT animals.*
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';
/*List of all animals that are pokemon (their type is Pokemon).*/
SELECT animals.* 
FROM animals 
JOIN species ON animals.species_id = species.id 
WHERE species.name = 'Pokemon';
/*List all owners and their animals, remember to include those that don't own any animal.*/
SELECT owners.full_name, animals.name 
FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;
/*How many animals are there per species?*/
SELECT species.name, COUNT(animals.id) 
FROM animals RIGHT JOIN species ON animals.species_id = species.id GROUP BY species.name;
/*List all Digimon owned by Jennifer Orwell.*/
SELECT animals.* FROM animals 
JOIN owners ON animals.owner_id = owners.id 
JOIN species ON animals.species_id = species.id 
WHERE owners.full_name = 'Jennifer Orwell' 
AND species.name = 'Digimon';
/*List all animals owned by Dean Winchester that haven't tried to escape.*/
SELECT animals.* FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
AND animals.escape_attempts = 0;
/*Who owns the most animals?*/
SELECT owners.full_name, COUNT(animals.id) 
FROM animals RIGHT JOIN owners ON animals.owner_id = owners.id 
GROUP BY owners.full_name ORDER BY COUNT(animals.id) DESC LIMIT 1;

