--Amount of Flights with correlated flight time

SELECT scheduled_arrival - scheduled_departure
AS "Flight Time",
COUNT(*) AS "Amount of Flights"
FROM flights
GROUP BY "Flight Time"
ORDER BY 1 DESC;
------------------------------------------------

--Average amount of passengers and income
--correlated with Aircraft Model


WITH aircraft_flights AS
(
	SELECT f.aircraft_code, f.flight_id,
	COUNT(tf.ticket_no) AS "passengers",
	SUM(tf.amount) AS "income"
	FROM flights AS f
	RIGHT JOIN ticket_flights AS tf USING(flight_id)
	GROUP BY f.flight_id
)
--!Inner vs Outer?
SELECT aircraft_code AS "Aircraft",
	ROUND(AVG(passengers)) AS "Average Load",
	ROUND(AVG(income), 3) AS "Average Income"
	FROM aircraft_flights
	GROUP BY aircraft_code
	ORDER BY 3 DESC;
------------------------------------------------


--Top of the most arrived Airports

WITH people_amount AS
(
	SELECT f.arrival_airport AS "airport_name",
	COUNT(tf.ticket_no) AS "people"
	FROM ticket_flights AS tf
	JOIN flights AS f USING(flight_id)
	JOIN airports AS ai
	ON ai.airport_code=f.arrival_airport
	GROUP BY f.arrival_airport, tf.flight_id
)

SELECT airport_name AS "Airport Name",
ROUND(SUM(people)/90) AS "People Per Day"
FROM people_amount
GROUP BY airport_name
ORDER BY 2 desc;

------------------------------------------------


--Top of Passengers' spendings on flights

SELECT t.passenger_name AS "Passenger Name", 
t.contact_data -> 'email' AS "Email",
t.contact_data -> 'phone' AS "Phone",
SUM(tf.amount) AS "Flights Costs"
FROM tickets AS t
JOIN ticket_flights AS tf ON t.ticket_no = tf.ticket_no
GROUP BY passenger_name, contact_data
ORDER BY 4 DESC
LIMIT 1000
OFFSET 2;
------------------------------------------------