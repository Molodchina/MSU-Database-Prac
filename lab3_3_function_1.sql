-- Функция для выбранной лиги КВН выводит
-- возможно для выбранной игры
-- капитанов всех команд с их контактными данными
-- 111ms
drop FUNCTION find_captains(text, text);
SET search_path TO kvn;
CREATE OR REPLACE FUNCTION find_captains(leagueName TEXT,
                                         gameName text DEFAULT Null)
    RETURNS table(team_name TEXT, captain_name TEXT, phone_num varchar(14)) AS
$BODY$
DECLARE
    cur CURSOR
        FOR SELECT game_name, team_ids
        FROM game
        WHERE leagueName = league_name
        AND
            CASE
                WHEN gameName is not Null then game_name = gameName
                ELSE True
            END;
    exist bool = True;
	cur_team_id integer;
    cur_team_name text;
    cur_player jsonb;
BEGIN
    FOR row in cur LOOP
        FOREACH cur_team_id IN ARRAY row.team_ids LOOP
            cur_player = t.team_info -> 'Капитан'
                FROM team t
                WHERE team_id = cur_team_id;
            cur_team_name = t.team_name
                FROM team t
                WHERE t.team_id = cur_team_id;

            IF cur_player IS NULL THEN
                RAISE NOTICE 'Команда % не имеет капитана!', cur_team_name;
            ELSE
                RETURN QUERY
                    SELECT
                            t.team_name,
                           (cur_player -> 'Фамилия') ->> 0 || ' '
                                || ((cur_player -> 'Имя') ->> 0) || ' '
                                || ((cur_player -> 'Отчество') ->> 0),
                           ((cur_player -> 'Телефон') ->> 0)::varchar(14)
                    FROM team t
                    WHERE t.team_id = cur_team_id;

                exist = TRUE;
            END IF;
        END LOOP;
    END LOOP;
    IF NOT exist THEN
        RAISE EXCEPTION 'В данной Лиге КВН команды еще не играли!';
    END IF;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

SELECT * FROM find_captains('Лига Малых городов', NULL);

select count(*)

-- SELECT *
-- FROM game
-- WHERE league_name = 'Лига Малых городов'
-- AND game_name = 'Тихвин Усть-Каменогорск - центр планеты 1991';
--
-- select case when team_info -> 'Капитан' is NULL then 'OK' else ((team_info -> 'Капитан')::jsonb -> 'Имя') ->> 0  END from team
-- where team_id = any('{126,127,128,129,130,131,132,133,134,135}'::bigint[]);

