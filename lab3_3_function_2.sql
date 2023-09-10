-- Функция выводит среднюю оценку (с точностью до сотых) для игр,
-- в которых принимала участие определенная команда
-- в определенном промежутке времени (по дефолту с даты начала игр КВН по текущую дату)
-- в порядке дат проведения игр
-- ~3 min
SET search_path TO kvn;
CREATE OR REPLACE FUNCTION team_rates(team TEXT,
                                      begin_date timestamp = timestamp '1961-11-08',
                                      end_date timestamp = current_date)
    RETURNS table(game_name TEXT, game_id BIGINT, average numeric) AS
$BODY$
DECLARE
    cur CURSOR FOR SELECT c.game_id
                    FROM connect as c
                    NATURAL JOIN team t
                    NATURAL JOIN game g
                    WHERE t.team_name = team
                    AND g.date BETWEEN begin_date AND end_date;
    played bool = FALSE;
BEGIN
    FOR row in cur LOOP
        RETURN QUERY SELECT f.game_name, row.game_id, round(AVG(f.rate), 3)
            FROM feedback as f
                WHERE f.game_id = row.game_id
                GROUP BY f.game_name, row.game_id;
        played = TRUE;
    END LOOP;
    IF NOT played THEN
        RAISE EXCEPTION 'Данная команда еще не играла в КВН';
    END IF;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM team_rates('«Смех и радость»', timestamp '2022-01-01');

select g.game_name, g.game_id, round(AVG(f.rate), 3)
FROM game g
JOIN feedback f on g.game_id = f.game_id
WHERE '«Смех и радость»' = ANY(g.team_names)
AND g.date BETWEEN timestamp '2022-01-01' and current_date
GROUP BY g.game_name, g.game_id;
