-- 1. List the names of all pet owners along with the names of their pets.

select o.OwnerID , o.`Name` , o.SurName , p.`Name` as petName
from petowners as o
left join pets as p
on o.OwnerID = p.OwnerID;

-- 2. List all pets and their owner names, including pets that don't have recorded owners.

select  p.`Name` as petName , o.OwnerID , o.`Name` , o.SurName 
from pets as p
left join petowners as o
on o.OwnerID = p.OwnerID;

-- 3. Combine the information of pets and their owners, including those pets
-- without owners and owners without pets.

select  p.`Name` as petName , o.OwnerID , o.`Name` , o.SurName 
from pets as p 
left join petowners as o
on o.OwnerID = p.OwnerID
union 
select  p.`Name` as petName , o.OwnerID , o.`Name` , o.SurName 
from pets as p 
right join petowners as o
on o.OwnerID = p.OwnerID;

-- 4. Find the names of pets along with their owners' names and the details of the
-- procedures they have undergone.

select p.`Name` as PetName , o.`Name` as PetOwner , h.ProcedureSubCode , h.ProcedureType, d.Description , d.Price
from pets as p
join petowners as o
on p.OwnerID = o.OwnerID
left join procedureshistory as h
on h.PetID = p.PetID
left join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType ;

-- 5. List all pet owners and the number of dogs they own.

select o.OwnerID , o.`Name` , o.Surname, count(p.PetID) as no_of_dogs
from petowners as o
left join pets as p
on o.OwnerID = p.OwnerID
group by o.OwnerID , o.`Name` , o.Surname;

-- 6. Identify pets that have not had any procedures.

select p.PetID , p.`Name` as PetName , h.ProcedureType
from pets as p
left join procedureshistory as h
on h.PetID = p.PetID
where h.PetID IS NULL ;

-- 7. Find the name of the oldest pet.

select  petID , `Name`  , Age ,Kind
from pets
order by Age desc 
limit 3; 
 
 # I used limit 3 because three pets have same age, otherwise we will use limit 1 to find oldest
 
-- 8. List all pets who had procedures that cost more than the average cost of all procedures.
select p.PetID , p.`Name` as PetName  , h.ProcedureType, d.Description , d.Price
from pets as p
join procedureshistory as h
on h.PetID = p.PetID
join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
where d.Price > (select avg(Price) from proceduresdetails);

-- 9. Find the details of procedures performed on 'Cuddles'.
select p.PetID , p.`Name` as PetName  , h.ProcedureType, d.Description , d.Price
from pets as p
join procedureshistory as h
on h.PetID = p.PetID
join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
where p.`Name` = 'Cuddles';

-- 10. Create a list of pet owners along with the total cost they have spent on
-- procedures and display only those who have spent above the average spending.

select o.OwnerID , o.`Name` as PetOwner ,  sum(d.Price) as total_price 
from petowners as o
left join pets as p
on p.OwnerID = o.OwnerID
left join procedureshistory as h
on h.PetID = p.PetID
left join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
group by o.OwnerID , o.`Name`
having total_price > (select avg(total_spending) from 
(select o.OwnerID , o.`Name` as PetOwner ,  sum(d.Price) as total_spending
from petowners as o
left join pets as p
on p.OwnerID = o.OwnerID
left join procedureshistory as h
on h.PetID = p.PetID
left join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
group by o.OwnerID ) as spending);


-- 11. List the pets who have undergone a procedure called 'VACCINATIONS'.

select p.PetID , p.`Name` as PetName  , h.ProcedureType, d.Description 
from pets as p
join procedureshistory as h
on h.PetID = p.PetID
join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
where h.ProcedureType = 'VACCINATIONS';

-- 12. Find the owners of pets who have had a procedure called 'EMERGENCY'.

select o.OwnerID , o.`Name` as PetOwner 
from petowners as o
join pets as p
on p.OwnerID = o.OwnerID
join procedureshistory as h
on h.PetID = p.PetID
where h.ProcedureType = 'EMERGENCY';

#
-- 13. Calculate the total cost spent by each pet owner on procedures.

select o.OwnerID , o.`Name` as PetOwner ,  sum(d.Price) as total_cost_spent
from petowners as o
left join pets as p
on p.OwnerID = o.OwnerID
left join procedureshistory as h
on h.PetID = p.PetID
left join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
group by o.OwnerID , o.`Name`;
 
-- 14. Count the number of pets of each kind.
select  Kind , count(PetID) as no_of_pets 
from pets
group by Kind;



-- 15. Group pets by their kind and gender and count the number of pets in each group.

select  Kind , Gender , count(PetID) as no_of_pets 
from pets
group by Kind , Gender ;

-- 16. Show the average age of pets for each kind, but only for kinds that have more than 5 pets.

select  Kind , avg(Age) as Avg_Age , count(PetID) as no_of_pets 
from pets
group by Kind 
having no_of_pets > 5 ;

select  Kind , Gender , avg(Age) as Avg_Age , count(PetID) as no_of_pets 
from pets
group by Kind , Gender 
having no_of_pets > 5 ;

-- 17. Find the types of procedures that have an average cost greater than $50.
select ProcedureType , avg(Price) as Avg_Price
from proceduresdetails
group by ProcedureType
having Avg_Price > 50;

-- 18. Classify pets as 'Young', 'Adult', or 'Senior' based on their age. Age less then
-- 3 Young, Age between 3and 8 Adult, else Senior.

select PetID , `Name` , Age ,
CASE 
WHEN Age < 3 THEN 'Young'
WHEN Age BETWEEN 3 AND 8  THEN 'Adult'
ELSE 'Senior'
END as Age_Classification
from pets;

-- 19. Calculate the total spending of each pet owner on procedures, labeling them
-- as 'Low Spender' for spending under $100, 'Moderate Spender' for spending
-- between $100 and $500, and 'High Spender' for spending over $500.

select o.OwnerID , o.`Name` as PetOwner ,  sum(d.Price) as total_spending,
CASE
WHEN  sum(d.Price) < 100 THEN 'Low Spender'
WHEN  sum(d.Price) BETWEEN 100 AND 500  THEN 'Moderate Spender'
WHEN sum(d.Price) > 500 THEN 'High Spender'
END as spending_label
from petowners as o
left join pets as p
on p.OwnerID = o.OwnerID
left join procedureshistory as h
on h.PetID = p.PetID
left join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
group by o.OwnerID , o.`Name`;

# there are two many null values in the result. To avoind that we can use inner join with procedureshistory and proceduresdetails tables 

select o.OwnerID , o.`Name` as PetOwner ,  sum(d.Price) as total_spending,
CASE
WHEN  sum(d.Price) < 100 THEN 'Low Spender'
WHEN  sum(d.Price) BETWEEN 100 AND 500  THEN 'Moderate Spender'
WHEN sum(d.Price) > 500 THEN 'High Spender'
END as spending_label
from petowners as o
left join pets as p
on p.OwnerID = o.OwnerID
inner join procedureshistory as h
on h.PetID = p.PetID
inner join proceduresdetails as d
on h.ProcedureSubCode = d.ProcedureSubCode and h.ProcedureType = d.ProcedureType 
group by o.OwnerID , o.`Name`;

-- 20. Show the gender of pets with a custom label ('Boy' for male, 'Girl' for female).

select PetID , `Name` , Gender,
CASE 
WHEN Gender = 'male' THEN 'Boy'
ELSE 'Girl'
END as Gender_Classification
from pets;

-- 21. For each pet, display the pet's name, the number of procedures they've had,
-- and a status label: 'Regular' for pets with 1 to 3 procedures, 'Frequent' for 4 to
-- 7 procedures, and 'Super User' for more than 7 procedures.


select p.PetID , p.`Name` , count(h.ProcedureType) as no_of_procedures,
CASE
WHEN count(h.ProcedureType) BETWEEN 1 AND 3 THEN 'Regular'
WHEN count(h.ProcedureType) BETWEEN 4 AND 7 THEN 'Frequent'
WHEN count(h.ProcedureType) >=7  THEN 'Super User'
END as status_label
from pets as p
left join procedureshistory as h
on h.PetID = p.PetID
group by p.PetID ,  p.`Name` ;

# we can also use inner join to avoid null values here 

-- 22. Rank pets by age within each kind.

select  petID , `Name` , Age , Kind ,
rank() over (partition by Kind order by age desc) as ranking
from pets ;

# since it's not mentioned how to rank, i used descending here

-- 23. Assign a dense rank to pets based on their age, regardless of kind.
select  petID , `Name` , Age , Kind , 
dense_rank() over (partition by Kind order by age desc) as ranking
from pets ;

-- 24. For each pet, show the name of the next and previous pet in alphabetical order.

select PetID , `Name` as PetName , lead(`Name`) over(order by `Name`) as next_PetName , 
lag(`Name`) over(order by `Name`)  as previous_PetName 
from pets;

-- 25. Show the average age of pets, partitioned by their kind.

select PetID , `Name` , Kind , avg(Age) over (partition by Kind) as Avg_Age
from pets;

# we can also use group by instead of using window function here

select  Kind , avg(Age) as Avg_Age
from pets
group by Kind;

-- 26. Create a CTE that lists all pets, then select pets older than 5 years from the CTE.

With All_Pets AS(
Select * 
from pets)

Select p.PetID , p.`Name` , p.Age
from All_Pets as p
where p.Age > 5
order by p.Age;
