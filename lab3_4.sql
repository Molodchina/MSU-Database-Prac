SET search_path TO kvn;

DROP INDEX IF EXISTS array_index;
DROP INDEX IF EXISTS game_multi_index;
DROP INDEX IF EXISTS text_index;
DROP INDEX IF EXISTS jsonb_index;


-- Работа с массивами
EXPLAIN ANALYZE SELECT *
                FROM game
                WHERE ARRAY[10]::int[] <@ team_ids;
/*
QUERY PLAN

Seq Scan on game  (cost=0.00..105883.00 rows=64643 width=610) (actual time=0.056..697.198 rows=61798 loops=1)
  Filter: ('{10}'::integer[] <@ team_ids)
  Rows Removed by Filter: 1038202
Planning Time: 0.077 ms
Execution Time: 698.762 ms
*/

CREATE INDEX array_index ON game USING GIN(team_ids);
-- completed in 2 s 479 ms

EXPLAIN ANALYZE SELECT *
                FROM game
                WHERE ARRAY[10]::int[] <@ team_ids;
/*
QUERY PLAN

Bitmap Heap Scan on game  (cost=600.99..89361.36 rows=64643 width=610) (actual time=8.605..42.049 rows=61798 loops=1)
  Recheck Cond: ('{10}'::integer[] <@ team_ids)
  Heap Blocks: exact=11189
  ->  Bitmap Index Scan on array_index  (cost=0.00..584.83 rows=64643 width=0) (actual time=6.213..6.213 rows=61798 loops=1)
        Index Cond: (team_ids @> '{10}'::integer[])
Planning Time: 0.382 ms
Execution Time: 43.609 ms
*/


-- Работа с jsonb
EXPLAIN ANALYZE SELECT * FROM game as g
                JOIN feedback as f USING(game_id)
                where viewer_info @> '{"Город": "Тверь"}'::jsonb
                AND to_tsvector('russian', g.league_name) @@ to_tsquery('russian', 'Молодёжная');
/*
QUERY PLAN

Merge Join  (cost=788270.22..810914.09 rows=1010 width=818) (actual time=3791.477..4087.506 rows=4168 loops=1)
  Merge Cond: (g.game_id = f.game_id)
  ->  Gather Merge  (cost=1000.45..232371.03 rows=5500 width=610) (actual time=93.190..222.081 rows=1299 loops=1)
        Workers Planned: 2
        Workers Launched: 2
        ->  Parallel Index Scan using game_pkey on game g  (cost=0.43..230736.17 rows=2292 width=610) (actual time=19.828..207.471 rows=451 loops=3)
"              Filter: (to_tsvector('russian'::regconfig, league_name) @@ '''молодежн'''::tsquery)"
              Rows Removed by Filter: 34403
  ->  Materialize  (cost=787269.31..788279.41 rows=202020 width=216) (actual time=3698.276..3829.848 rows=326547 loops=1)
        ->  Sort  (cost=787269.31..787774.36 rows=202020 width=216) (actual time=3698.272..3793.333 rows=326547 loops=1)
              Sort Key: f.game_id
              Sort Method: external merge  Disk: 72520kB
              ->  Gather  (cost=1000.00..748750.67 rows=202020 width=216) (actual time=0.333..3348.527 rows=326547 loops=1)
                    Workers Planned: 2
                    Workers Launched: 2
                    ->  Parallel Seq Scan on feedback f  (cost=0.00..727548.67 rows=84175 width=216) (actual time=0.124..3402.243 rows=108849 loops=3)
"                          Filter: (viewer_info @> '{""Город"": ""Тверь""}'::jsonb)"
                          Rows Removed by Filter: 6557818
Planning Time: 0.371 ms
Execution Time: 4093.745 ms
*/

CREATE INDEX text_index ON game USING GIN(to_tsvector('russian', league_name));
-- completed in 5 s 312 ms
CREATE INDEX jsonb_index ON feedback USING GIN(viewer_info);
-- completed in 4 m 43 s 802 ms

EXPLAIN ANALYZE SELECT * FROM game as g
                JOIN feedback as f USING(game_id)
                where viewer_info @> '{"Город": "Тверь"}'::jsonb
                AND to_tsvector('russian', g.league_name) @@ to_tsquery('russian', 'Молодёжная');
/*
QUERY PLAN

Gather  (cost=21124.62..526152.64 rows=1010 width=818) (actual time=371.220..1869.496 rows=4168 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  ->  Parallel Hash Join  (cost=20124.62..525051.64 rows=421 width=818) (actual time=330.502..1812.807 rows=1389 loops=3)
        Hash Cond: (f.game_id = g.game_id)
        ->  Parallel Bitmap Heap Scan on feedback f  (cost=1913.66..506619.72 rows=84175 width=216) (actual time=232.973..1673.782 rows=108849 loops=3)
"              Recheck Cond: (viewer_info @> '{""Город"": ""Тверь""}'::jsonb)"
              Rows Removed by Index Recheck: 2043088
              Heap Blocks: exact=19112 lossy=67623
              ->  Bitmap Index Scan on jsonb_index  (cost=0.00..1863.15 rows=202020 width=0) (actual time=221.943..221.943 rows=326547 loops=1)
"                    Index Cond: (viewer_info @> '{""Город"": ""Тверь""}'::jsonb)"
        ->  Parallel Hash  (cost=18182.32..18182.32 rows=2292 width=610) (actual time=95.526..95.527 rows=4670 loops=3)
              Buckets: 16384 (originally 8192)  Batches: 1 (originally 1)  Memory Usage: 10112kB
              ->  Parallel Bitmap Heap Scan on game g  (cost=74.63..18182.32 rows=2292 width=610) (actual time=3.599..87.930 rows=4670 loops=3)
"                    Recheck Cond: (to_tsvector('russian'::regconfig, league_name) @@ '''молодежн'''::tsquery)"
                    Heap Blocks: exact=8207
                    ->  Bitmap Index Scan on text_index  (cost=0.00..73.25 rows=5500 width=0) (actual time=5.859..5.859 rows=14011 loops=1)
"                          Index Cond: (to_tsvector('russian'::regconfig, league_name) @@ '''молодежн'''::tsquery)"
Planning Time: 2.695 ms
Execution Time: 1869.942 ms
*/


-- Секционирование таблицы
EXPLAIN ANALYZE SELECT *
                FROM feedback
                WHERE extract(year from date) = 2023;
/*
QUERY PLAN

Gather  (cost=1000.00..759375.70 rows=99995 width=216) (actual time=0.458..204028.490 rows=320600 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  ->  Parallel Seq Scan on feedback  (cost=0.00..748376.20 rows=41665 width=216) (actual time=279.688..203731.028 rows=106867 loops=3)
        Filter: (EXTRACT(year FROM date) = '2023'::numeric)
        Rows Removed by Filter: 6559800
Planning Time: 0.077 ms
Execution Time: 204052.084 ms
*/
DROP TABLE IF EXISTS section_feedback;
CREATE TABLE section_feedback(
    comment_id BIGSERIAL,
    game_id bigint,
    game_name text,
    "comment" text,
	"date" timestamp,
    rate integer,
    viewer_info jsonb
) PARTITION BY RANGE ("date");

CREATE TABLE part_one PARTITION OF section_feedback
    FOR VALUES FROM ('1962-01-01') TO ('1982-06-14');

CREATE TABLE part_two PARTITION OF section_feedback
    FOR VALUES FROM ('1982-06-14') TO ('2002-12-10');

CREATE TABLE part_three PARTITION OF section_feedback
    FOR VALUES FROM ('2002-12-10') TO ('2024-12-29');

INSERT INTO section_feedback(game_id, game_name, "comment", "date", rate, viewer_info, comment_id)
SELECT * FROM feedback;

EXPLAIN ANALYZE SELECT *
                FROM section_feedback
                WHERE extract(year from date) = 2023;
/*
QUERY PLAN

Gather  (cost=1000.00..847741.04 rows=165196 width=124) (actual time=47980.236..98936.160 rows=320600 loops=1)
  Workers Planned: 2
  Workers Launched: 2
  ->  Parallel Append  (cost=0.00..830221.44 rows=68831 width=124) (actual time=31805.558..82281.998 rows=106867 loops=3)
        ->  Parallel Seq Scan on part_three section_feedback_3  (cost=0.00..290677.11 rows=24109 width=124) (actual time=0.129..50466.077 rows=106867 loops=3)
              Filter: (EXTRACT(year FROM date) = '2023'::numeric)
              Rows Removed by Filter: 2228440
        ->  Parallel Seq Scan on part_two section_feedback_2  (cost=0.00..269962.86 rows=22391 width=124) (actual time=38470.976..38470.976 rows=0 loops=1)
              Filter: (EXTRACT(year FROM date) = '2023'::numeric)
              Rows Removed by Filter: 6505940
        ->  Parallel Seq Scan on part_one section_feedback_1  (cost=0.00..269237.33 rows=22331 width=124) (actual time=28472.649..28472.650 rows=0 loops=2)
              Filter: (EXTRACT(year FROM date) = '2023'::numeric)
              Rows Removed by Filter: 3244071
Planning Time: 3.546 ms
Execution Time: 98948.382 ms
*/
