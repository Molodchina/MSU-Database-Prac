REVOKE ALL PRIVILEGES ON SCHEMA kvn FROM test;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA kvn FROM test;
DROP VIEW IF EXISTS kvn.game_views;
DROP VIEW IF EXISTS kvn.rates;
DROP USER IF EXISTS test;
DROP ROLE IF EXISTS rates_role;

CREATE USER test PASSWORD '1234';
GRANT USAGE ON SCHEMA kvn TO test;

GRANT SELECT, UPDATE, INSERT ON kvn.feedback TO test;
GRANT SELECT (game_name, league_name, "date", host_name, online_views, offline_views, city), UPDATE (online_views, offline_views) ON kvn.game TO test;
GRANT SELECT ON kvn.team TO test;

SET search_path TO kvn;
CREATE OR REPLACE VIEW game_views AS
    SELECT game_name, online_views, offline_views
    FROM game;
GRANT SELECT ON game_views TO test;

CREATE OR REPLACE VIEW rates AS
    SELECT comment_id, comment, rate
    FROM feedback
    WHERE rate BETWEEN 0 AND 3
    WITH LOCAL CHECK OPTION;

CREATE ROLE rates_role;
GRANT SELECT, UPDATE (rate) ON rates TO rates_role;
GRANT rates_role TO test;
