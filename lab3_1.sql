DROP SCHEMA IF EXISTS kvn CASCADE;
CREATE SCHEMA kvn;
SET search_path TO kvn;

-- Статистика зрители-игроки:
-- какие возрастные категории оставляют комментарии, какие рейтинги
-- для улучшения взаимодействия с аудиторией.
-- Какие ведущие аудитории нравятся больше, какие игроки
-- Влияет ли возраст игроков на оценку зрителей

CREATE TABLE game (
    game_id BIGSERIAL PRIMARY KEY,
    game_name text NOT NULL,
	league_name text,
    "date" timestamp,
    team_ids integer[],
	team_names text[],
	host_name text,
	online_views BIGINT,
	offline_views BIGINT,
	city text
);

CREATE TABLE team (
    team_id BIGSERIAL PRIMARY KEY,
    team_name text NOT NULL,
    team_info jsonb
);

CREATE TABLE connect (
    game_id BIGINT 
		CONSTRAINT connect_game REFERENCES game,
    team_id BIGINT
		CONSTRAINT connect_team REFERENCES team
);

CREATE TABLE feedback (
    comment_id BIGSERIAL PRIMARY KEY,
    game_id bigint DEFAULT NULL
		CONSTRAINT comment_game REFERENCES game ON DELETE SET DEFAULT,
    game_name text,
    "comment" text,
	"date" timestamp,
    rate integer,
    viewer_info jsonb
);

ALTER TABLE connect DROP CONSTRAINT connect_game;
ALTER TABLE connect DROP CONSTRAINT connect_team;
ALTER TABLE feedback DROP CONSTRAINT comment_game;
ALTER TABLE game DROP COLUMN game_id;
ALTER TABLE team DROP COLUMN team_id;
ALTER TABLE feedback DROP COLUMN comment_id;


ALTER TABLE game ADD COLUMN game_id BIGSERIAL;
ALTER TABLE game ADD PRIMARY KEY (game_id);
ALTER TABLE team ADD COLUMN team_id BIGSERIAL;
ALTER TABLE team ADD PRIMARY KEY (team_id);
ALTER TABLE feedback ADD COLUMN comment_id BIGSERIAL;
ALTER TABLE feedback ADD PRIMARY KEY (comment_id);
ALTER TABLE feedback ADD CONSTRAINT comment_game 
FOREIGN KEY (game_id) REFERENCES game ON DELETE SET DEFAULT;
ALTER TABLE connect ADD CONSTRAINT connect_game
FOREIGN KEY (game_id) REFERENCES game;
ALTER TABLE connect ADD CONSTRAINT connect_team
FOREIGN KEY (team_id) REFERENCES team;
