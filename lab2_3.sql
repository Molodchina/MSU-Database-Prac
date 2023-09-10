/*
	Топ-20 игроков по просматриваемости для
	составления "медийных" команд
*/

SELECT p.full_name AS "ФИО",
p.phone_num AS "Телефон",
p.team_role AS "Роль",
SUM(v.online_view_amount + v.offline_view_amount)
AS "Количество Просмотров"
FROM kvn.personal AS p
JOIN kvn.player USING(player_id)
JOIN kvn.team USING(team_id)
JOIN kvn.result USING(team_id)
JOIN kvn.game USING(game_id)
JOIN kvn.viewer AS v USING(game_id)
GROUP BY p.player_id
ORDER BY "Количество Просмотров" DESC
LIMIT 20;

/*
	Определение топ-2 самых популярных
	команд каждой из лиг КВН, в которых были игры
*/

WITH popular AS
(
	SELECT l.league_name, l.league_id,
	t.team_name, t.team_id,
	SUM(v.online_view_amount + v.offline_view_amount),
	RANK() OVER
	(
		PARTITION BY league_name
		ORDER BY SUM(v.online_view_amount + v.offline_view_amount) DESC
	) AS pop_pos
	FROM kvn.league AS l
	NATURAL JOIN kvn.game AS gm
	NATURAL JOIN kvn.result
	NATURAL JOIN kvn.viewer AS v
	NATURAL JOIN kvn.team AS t
	GROUP BY l.league_id, t.team_id
)

SELECT league_name AS "Лига",
team_name AS "Команда",
pop_pos AS "Позиция"
FROM popular
WHERE pop_pos <= 2;

/*
	Определение мест, нуждающихся в 
	отоплении для проведения игр
*/

SELECT c.city_name AS "Город",
l.coords AS "Координаты места",
COUNT(g.game_date) AS "Игры на Холоде"
FROM kvn.location AS l
NATURAL JOIN kvn.city AS c
NATURAL JOIN kvn.game AS g
WHERE 
EXTRACT(month FROM age(g.game_date, TIMESTAMP '1960-01-01 00:00:00'))
NOT BETWEEN 4 AND 8
GROUP BY l.location_id, c.city_name
ORDER BY "Игры на Холоде" DESC;
