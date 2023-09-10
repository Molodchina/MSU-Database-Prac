SET search_path TO kvn;

-- А параллельно с этим сообщили, что игры в Омской лиге
-- в сезон 2022 не проводились, а имеющиеся результаты - липа
-- нужно удалить записи о результатах
-- год оказался -10
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Убеждаемся, что данный сезон присутствует в таблице state
SELECT * from state
natural join league
	where league_name = 'Омская';
-- UPDATE state as s
-- SET year_no = year_no - 10
-- FROM league as l
-- 	WHERE l.league_name = 'Омская'
-- 	AND s.league_id = l.league_id;

-- пытаемся удалить ненужные записи
DELETE FROM state as s
using league as l
	WHERE l.league_name = 'Омская'
	AND s.league_id = l.league_id
	AND s.year_no = 2022;
-- удаление не происходит
COMMIT;
rollback

-- Узнаем положение дел в лиге Премьер-лига в 2022 году для вручения наград
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * from state
natural join league
	where league_name = 'Премьер-лига'
	and year_no = 2022;
-- Напечатали грамоты, на свякий случай перепроверяем
SELECT * from state
natural join league
	where league_name = 'Премьер-лига'
	and year_no = 2022;
COMMIT;


-- Аналогичная ситуация с награждением в Премьер-лиге, но в 2023 году
-- + награда командам, которые в Премьер-лиге занимали 1 место когда-либо
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * from state
natural join league
	where league_name = 'Премьер-лига'
	and year_no = 2023;
SELECT team_name
from state
NATURAL JOIN team
NATURAL JOIN league
	where league_name = 'Премьер-лига'
	group by team_name
	having count(place) > 1;

SELECT * from state
natural join league
	where league_name = 'Премьер-лига'
	and year_no = 2023;
SELECT team_name
from state
NATURAL JOIN team
NATURAL JOIN league
	where league_name = 'Премьер-лига'
	group by team_name
	having count(place) > 1;
COMMIT;


-- Аналогично
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT team_name
from state
NATURAL JOIN team
NATURAL JOIN league
	where league_name = 'Премьер-лига'
	group by team_name
	having count(place) > 1;

SELECT team_name
from state
NATURAL JOIN team
NATURAL JOIN league
	where league_name = 'Премьер-лига'
	group by team_name
	having count(place) > 1;
COMMIT;