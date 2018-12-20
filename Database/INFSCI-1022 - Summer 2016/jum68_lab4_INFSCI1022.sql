USE sakila;

# Task 1
SELECT film.title AS `Movie Title`, AVG(film.rental_rate) AS `AVG Rental Rate`, (film.replacement_cost) AS `AVG Replacement Cost`
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.inventory_id IN
(SELECT rental.inventory_id FROM rental WHERE MONTH(return_date)=5 AND YEAR(return_date)=2005)
GROUP BY `Movie Title`
ORDER BY `Movie Title` ASC;

# Task 2
SELECT film.title AS `Movie Title`, film.rental_rate AS `Rental Rate`, MAX(M.M_Profit) AS `Maximum Profit`
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN
	(SELECT MAX(payment.amount) AS M_Profit, rental.inventory_id FROM rental
    JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY rental.inventory_id) M
ON inventory.inventory_id = M.inventory_id
GROUP BY film.film_id
ORDER BY `Movie Title` ASC;

# Task 3
SELECT film.title AS `Movie Title`, film.rental_rate AS `Rental Rate`, MAX(payment.amount) AS `Maximum Profit`
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
LEFt JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY film.film_id
ORDER BY `Movie Title` ASC;