SET search_path TO kvn;
SET ROLE test;

select * from game_views
LIMIT 10;

BEGIN;
    UPDATE game_views SET game_name = NULL;
ROLLBACK;

select * from rates
LIMIT 10;

BEGIN;
UPDATE rates SET rate = 5
WHERE rate = 0;
ROLLBACK;

BEGIN;
UPDATE rates SET rate = 3
WHERE rate = 0;

select * from rates
LIMIT 10;
ROLLBACK;

select game_id, game_name
FROM game;

select game_name, online_views, offline_views from game
    WHERE game_name = 'Екатеринбург Смех без причины 1999';
BEGIN;
    UPDATE game SET online_views = online_views + 1000
    WHERE game_name = 'Екатеринбург Смех без причины 1999';
COMMIT;

select * from feedback
WHERE game_name = 'Белгород Весела зима, для юмора пора 1994'
LIMIT 10;

BEGIN;
    UPDATE feedback SET rate = 5
    WHERE game_name = 'Белгород Весела зима, для юмора пора 1994';
COMMIT;
