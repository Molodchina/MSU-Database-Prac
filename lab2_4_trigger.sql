SET search_path TO kvn;
DROP FUNCTION IF EXISTS state_trigger() CASCADE;

-- Контроль изменений в таблице state:
-- если вводится запись с сезоном лиги, которого еще нет, тогда добавляем новый сезон (год в промежутках от 1961 до настоящего времени)
-- если для данной команды и для данного сезона результат уже загружен в таблицу, предупреждаем, что результат уже есть
-- если вносятся данные для данного сезона, но место в сезоне уже занято, то ставим максимально сущ. место  + 1

CREATE FUNCTION state_trigger()
RETURNS trigger AS $state_trigger$
    BEGIN
		IF NEW.year_no NOT BETWEEN 1961 AND EXTRACT(year FROM current_date) THEN
			RETURN NULL;
		ELSIF NEW.year_no NOT IN
		(
			SELECT year_num FROM season
			WHERE league_id = NEW.league_id
		) THEN
			INSERT INTO season SELECT NEW.league_id, NEW.year_no;
		END IF;
		
		IF ((
			SELECT count(*)
			FROM state
			WHERE league_id = NEW.league_id
			AND year_no = NEW.year_no
			AND team_id = NEW.team_id
		) > 0) THEN
			RAISE EXCEPTION 'current team result is loaded into table';
			RETURN NULL;
		END IF;
		
		IF ((
			SELECT COUNT(*)
			FROM state
			WHERE league_id = NEW.league_id
			AND year_no = NEW.year_no
			AND place = NEW.place
		) > 0) THEN
			NEW.place = max(place) + 1
				FROM state
				WHERE league_id = NEW.league_id
				AND year_no = NEW.year_no;
		END IF;
		
		RETURN NEW;
    END;
$state_trigger$ LANGUAGE plpgsql;

CREATE TRIGGER state_trigger BEFORE INSERT OR UPDATE on state
    FOR EACH ROW EXECUTE FUNCTION state_trigger();	