SET search_path TO kvn;

-- Нам сообщили, то результаты для одной из лиг (Омская)
-- были переданы неверно (-1 год)
-- => меняем года для данной лиги
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
select league_name, year_no
from state
natural join league
	where league_name = 'Омская';

-- UPDATE state as s
-- SET year_no = year_no - 1
-- FROM league as l
-- 	WHERE l.league_name = 'Омская'
-- 	AND s.league_id = l.league_id;
-- COMMIT;

-- Сообщили, что после переподсчета результатов
-- лиги Премьер-лига в 2022 году победителем стала команда Городские комедианты,
-- а Городские шутки заняли только 2 место
BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE state as s
SET place = 1
FROM league as l
natural join team as t
	WHERE l.league_name = 'Премьер-лига'
	AND s.league_id = l.league_id
	AND s.team_id = t.team_id
	AND t.team_name = 'Городские комедианты'
	AND s.year_no = 2022;

UPDATE state as s
SET place = 2
FROM league as l
natural join team as t
	WHERE l.league_name = 'Премьер-лига'
	AND s.league_id = l.league_id
	AND s.team_id = t.team_id
	AND t.team_name = 'Городские шутки'
	AND s.year_no = 2022;
COMMIT;

select * from state
natural join league
	where league_name = 'Премьер-лига'

select * from team
where team_id = 6


-- В Премьер-лиге в 2023 году вместо команды Университетские клоуны
-- 2 место заняла команда Университетские шутники из-за ошибки в результатах
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE state as s
SET team_id = 2
FROM league as l
	WHERE l.league_name = 'Премьер-лига'
	AND s.league_id = l.league_id
	AND s.year_no = 2023
	AND s.place = 2;
COMMIT;


-- Аналогично
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE state as s
SET team_id = 6
FROM league as l
	WHERE l.league_name = 'Премьер-лига'
	AND s.league_id = l.league_id
	AND s.year_no = 2023
	AND s.place = 3;
COMMIT;





