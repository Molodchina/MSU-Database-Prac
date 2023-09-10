DROP FUNCTION IF EXISTS kvn.team_disq;
CREATE FUNCTION kvn.team_disq(int, int)
RETURNS void AS
'
	DELETE FROM kvn.score as s
	USING kvn.result as r
		WHERE r.game_id = $2
		AND r.team_id = $1
		AND s.result_id = r.result_id;
	
	UPDATE kvn.result AS r
	SET place = place - 1,
	if_pass =
	CASE
		WHEN place - 1 <= 2 then True
		else False
	END
		WHERE r.game_id = $2
		AND r.place > 
		(
			SELECT place
			FROM kvn.result
			WHERE game_id = $2
			AND team_id = $1
		);
	
	DELETE FROM kvn.result as r
		WHERE r.game_id = $2
		AND r.team_id = $1;
	
	
'
LANGUAGE SQL;

BEGIN;
SELECT * from kvn.result
	WHERE game_id = 1;

SELECT kvn.team_disq(1, 1);

SELECT * from kvn.result
	WHERE game_id = 1;
ROLLBACK;

-- INSERT INTO vars
-- set session vars.tmp_val = (SELECT result_id FROM kvn.result
-- 	WHERE game_id = 1
-- 	AND team_id = 7
-- );
-- select * from current_setting('vars.tmp_val');

ALTER SEQUENCE kvn.result_result_id_seq RESTART;
UPDATE kvn.result SET result_id = DEFAULT;

-- 	ALTER SEQUENCE kvn.result_result_id_seq RESTART;
-- 	UPDATE kvn.result SET result_id = DEFAULT;
-- 		WHERE result_id IN
-- 		(
-- 			SELECT result_id
-- 			FROM kvn.result
-- 			ORDER BY result_id
-- 			FOR UPDATE
-- 		);