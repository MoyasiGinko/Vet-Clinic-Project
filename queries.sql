/*Queries that provide answers to the questions from all projects.*/

/*--------------------start-----------------------*/
-- Path: animals table queries.sql
SELECT * FROM animals;
SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;
/*----------------------end-----------------------*/



/*---------------------start----------------------*/
-- Path: multiple table queries.sql
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
/*--------------------end-----------------------*/



/*--------------------start-----------------------*/
-- Path: owners and species table queries.sql
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
/*---------------------end-------------------------*/



/*--------------------start-------------------------*/
-- Path: vets, specializations, and visits table queries.sql
/*Who was the last animal seen by William Tatcher?*/
SELECT vets.name AS vets_name, animals.name AS animals_name 
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC LIMIT 1;

/*How many different animals did Stephanie Mendez see?*/
SELECT vets.name AS vets_name, COUNT(animals.id) 
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
GROUP BY vets.name;

/*List all vets and their specialties, including vets with no specialties.*/
SELECT vets.name AS vets_name, COALESCE(species.name, 'no specializations') AS species_name
FROM vets
LEFT JOIN specializations ON vets.id = specializations.vet_id
LEFT JOIN species ON specializations.species_id = species.id;

/*List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.*/
SELECT vets.name AS vets_name, animals.name AS animals_name, visits.date_of_visit 
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Stephanie Mendez'
AND visits.date_of_visit 
BETWEEN '2020-04-01' AND '2020-08-30';

/*What animal has the most visits to vets?*/
SELECT animals.name AS animals_name, COUNT(visits.id) FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name ORDER BY COUNT(visits.id) DESC LIMIT 1;

/*Who was Maisy Smith's first visit?*/
SELECT vets.name AS vets_name, animals.name AS animals_name, visits.date_of_visit 
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC LIMIT 1;

/*Details for most recent visit: animal information, vet information, and date of visit.*/
SELECT vets.name AS vets_name, animals.name AS animals_name, visits.date_of_visit FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
ORDER BY visits.date_of_visit DESC LIMIT 1;

/*How many visits were with a vet that did not specialize in that animal's species?*/
SELECT COUNT(visits.id) AS visits_without_specializations FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
LEFT JOIN specializations ON vets.id = specializations.vet_id AND specializations.species_id = animals.species_id
WHERE specializations.vet_id IS NULL;

/*What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT species.name AS species_specialty, COUNT(visits.id) AS visit_count
FROM species
JOIN animals ON species.id = animals.species_id
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'Maisy Smith'
GROUP BY species.name
ORDER BY visit_count DESC
LIMIT 1;
/*---------------------end-------------------------*/


