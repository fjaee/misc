-- dv - PetID,DateofVisit,Procedure,OtherComments
-- owner - Owner,OwnerName,Address,ContactNum,EmailAdrs
-- pet - PetID,PetName,PetType,Breed,Birthdate,Age,Sex,Owner,FurColor,Weight
-- proc - ProcCode,ProcedureName,Fee

-- 1. Display the name of the pets and the number of visits to the vet. Include in the list only those who had visited the vet just once.

SELECT PetName, COUNT(DateofVisit) AS VisitCount 
FROM pet p, doctorvisit dv
WHERE p.PetID = dv.PetID
GROUP BY PetName
HAVING COUNT(DateofVisit) = 1;

-- 2. Display the name of the owner and the number of pets owned.

SELECT OwnerName, COUNT(o.Owner) AS PetOwned
FROM owner o, pet p
WHERE o.owner = p.owner
GROUP BY OwnerName; 

-- 3. Display all pet information and owner name. Display only those whose owners are from Manila. Sort by age, from the oldest to the youngest.

SELECT p.*, OwnerName
FROM pet p, owner o
WHERE o.owner = p.owner
	AND Address LIKE "%Manila"
ORDER BY Age DESC;

-- 4. Display pet name, date of visit to the vet, and the name of procedure done during the visit.

SELECT PetName, DateofVisit, ProcedureName
FROM pet p, doctorvisit dv, db2.procedure pr
WHERE p.PetID = dv.PetID 
	AND dv.Procedure = ProcCode;

-- 5. Display the total amount paid to the vet for all the procedures done to the pet. Include also the name of the pet.

SELECT PetName, SUM(pr.Fee) AS TotalAmountPaid
FROM pet p, db2.procedure pr, doctorvisit dv
WHERE ProcCode = dv.Procedure 
	AND dv.PetID = p.PetID
GROUP BY PetName;

-- 6. List the names and age of the pets which have been spayed or neutered

SELECT PetName, Age, dv.Procedure
FROM pet p, doctorvisit dv
WHERE dv.PetID = p.PetID
	AND dv.Procedure IN ("SPY", "NEU");

-- 7. List the name pets which already have their rabies vaccination for the current year

SELECT PetName
FROM pet p, doctorvisit dv
WHERE dv.PetID = p.PetID
	AND dv.Procedure = "RAV"
	AND YEAR(DateofVisit) = 2024;

-- 8. Display the name of the pets which have been vaccinated twice for rabies

SELECT PetName
FROM pet p, doctorvisit dv
WHERE dv.PetID = p.PetID
	AND dv.Procedure = "RAV"
GROUP BY p.PetID, p.PetName
HAVING COUNT(dv.Procedure) = 2;
