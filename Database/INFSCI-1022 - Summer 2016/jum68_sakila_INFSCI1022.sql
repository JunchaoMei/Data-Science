USE sakila;

# Task 2
SELECT cate.name AS `Category Name`, f.title AS `Film Title`, 
	f.description AS `Film Description`, f.release_year AS `Release Year`
FROM category cate
JOIN film_category f_c ON cate.category_id = f_c.category_id
JOIN film f ON f_c.film_id = f.film_id
Where cate.name = 'Documentary' AND f.description LIKE '%Drama%'
GROUP BY `Film Title`
ORDER BY `Film Title` ASC;

# Task 3
SELECT CONCAT(actor.last_name, ',', actor.first_name) AS `Actor Name`, f.title AS `Film Title`
FROM actor
JOIN film_actor f_a ON actor.actor_id = f_a.actor_id
JOIN film f ON f_a.film_id = f.film_id
Where actor.first_name = 'JULIA' AND actor.last_name = 'MCQUEEN'
GROUP BY `Film Title`
ORDER BY `Film Title` ASC;

# Task 4
SELECT f.title AS `Film Title`, CONCAT(actor.last_name, ',', actor.first_name) AS `Actor Name`
FROM actor
JOIN film_actor f_a ON actor.actor_id = f_a.actor_id
JOIN film f ON f_a.film_id = f.film_id
Where f.title = 'AMADEUS HOLY'
GROUP BY `Actor Name`
ORDER BY `Actor Name` ASC;

# Task 5
SELECT CONCAT(cus.first_name, ' ', cus.last_name) AS `Customer Name`, f.title AS `Film Title`
FROM customer cus
JOIN rental ON cus.customer_id = rental.customer_id
JOIN inventory inv ON rental.inventory_id = inv.inventory_id
JOIN film f ON inv.film_id = f.film_id
Where cus.first_name = 'KATHLEEN' AND cus.last_name = 'ADAMS'
GROUP BY  `Film Title`
ORDER BY `Film Title` ASC;

/* Task 6
Q1: Which customer has rented the largest number of movies?
Q2: Which is the most popular movie that has been rented?
Q3: What's the maximum payment amount in last month?
*/