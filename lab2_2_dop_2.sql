/*
	Удалить On Delete Cascade для таблиц:
	score, result, season
*/
-- postgres=# psql \! chcp 1251
ALTER TABLE kvn.score DROP CONSTRAINT "score_result_id_fkey";
ALTER TABLE kvn.result DROP CONSTRAINT "result_game_id_fkey";
ALTER TABLE kvn.season DROP CONSTRAINT "season_league_id_fkey";

ALTER TABLE kvn.score ADD FOREIGN KEY (result_id)
REFERENCES kvn.result;
ALTER TABLE kvn.result ADD FOREIGN KEY (game_id)
REFERENCES kvn.game;
ALTER TABLE kvn.season ADD FOREIGN KEY (league_id)
REFERENCES kvn.league;


/*
	Игрок закончил выступление за команду А
	И начал выступать за команду Б
*/

UPDATE kvn.player AS pl
SET end_date = TIMESTAMP '2023-10-11'
FROM kvn.team as tm
NATURAL JOIN kvn.personal as ps
WHERE tm.team_name = 'Университетские шутники'
AND ps.phone_num = '89391689376'
AND pl.player_id = ps.player_id
AND pl.team_id = tm.team_id;

select team_id from kvn.team
WHERE team_name = 'Городские комедианты';

select player_id from kvn.personal
WHERE phone_num = '89391689376';

INSERT INTO kvn.player(team_id, player_id, begin_date)
VALUES
(2, 1, TIMESTAMP '2023-10-11');

/*
	После апелляции по результату одного из раундов
	команде должны увеличить оценку за раунд
*/

UPDATE kvn.score as sc
SET score_amount = 10.0
FROM kvn.team as tm
NATURAL JOIN kvn.result as r
NATURAL JOIN kvn.game as gm
WHERE tm.team_name = 'Городские комедианты'
AND gm.game_name = 'Усть-Каменогорск - центр планеты'
AND sc.result_id = r.result_id
AND sc.round_num = 1;

/*
	Узнали, что одна из игр была "куплена"
	и решили аннулировать результаты, удалив игру.
	Сперва нужно удалить результаты каждой команды
	+ подчистить смежные таблицы
*/

-- Код, вызывающий ошибку:
-- DELETE FROM kvn.game
-- WHERE game_id = 40;

-- Вот так:

WITH del_values AS
(
	SELECT round_num,
	result_id
	from kvn.score
	where result_id IN 
	(SELECT result_id
	from kvn.result as r
	NATURAL JOIN kvn.game as gm
	WHERE gm.game_name = 'Усть-Каменогорск - центр планеты'
	AND r.game_id = gm.game_id)
)

DELETE FROM kvn.score as sc
WHERE EXISTS
(
	SELECT *
	FROM del_values as dv
	WHERE sc.round_num = dv.round_num
	AND sc.result_id = dv.result_id
);

DELETE FROM kvn.result as r
USING kvn.game as gm
WHERE gm.game_name = 'Усть-Каменогорск - центр планеты'
AND r.game_id = gm.game_id;

DELETE FROM kvn.viewer as v
USING kvn.game as gm
WHERE gm.game_name = 'Усть-Каменогорск - центр планеты'
AND v.game_id = gm.game_id;

DELETE FROM kvn.game as gm
WHERE gm.game_name = 'Усть-Каменогорск - центр планеты';

ALTER SEQUENCE kvn.game_game_id_seq RESTART;
UPDATE kvn.game SET game_id = DEFAULT;
select * from kvn.result;
ALTER SEQUENCE kvn.result_result_id_seq RESTART;
UPDATE kvn.result SET result_id = DEFAULT;
