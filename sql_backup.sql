DO $$
BEGIN
DROP TABLE IF EXISTS gosha.history;
DROP TABLE IF EXISTS gosha.users;
DROP TABLE IF EXISTS gosha.posts;
DROP TABLE IF EXISTS gosha.inputs;
DROP TABLE IF EXISTS gosha.devices;
DROP TABLE IF EXISTS gosha.temperature_delta;
DROP TYPE IF EXISTS gosha.interpolation;
DROP SCHEMA IF EXISTS gosha;



CREATE SCHEMA gosha;

-- study - мой пользователь
ALTER SCHEMA gosha OWNER TO study;


-- Тип данных для интерполяции температуры
CREATE TYPE gosha.interpolation AS
(
	x1 numeric(8, 2),
	y1 numeric(8, 2),
	x2 numeric(8, 2),
	y2 numeric(8, 2)
);


-- Устройства измерения
CREATE TABLE gosha.devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL
);


-- Должности
CREATE TABLE gosha.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL
);


-- Поправки температуры
CREATE TABLE gosha.temperature_delta (
	temperature numeric(8,2) NOT NULL PRIMARY KEY,
	delta numeric(8,2) NOT NULL
);


-- Введёные метео значения
CREATE TABLE gosha.inputs (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    height numeric(8,2) NOT NULL,
    temperature numeric(8,2) NOT NULL,
    pressure numeric(8,2) NOT NULL,
    wind_speed numeric(8,2) NOT NULL,
    wind_direction numeric(8,2) NOT NULL,
    bullet_speed numeric(8,2) NOT NULL
);


-- Пользователи
CREATE TABLE gosha.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    post uuid NOT NULL,
    fullname character varying(100) NOT NULL,
    age numeric(8,2) NOT NULL,
	FOREIGN KEY (post) REFERENCES gosha.posts(id)
);


-- История запросов
CREATE TABLE gosha.history (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL,
    input_id uuid NOT NULL,
    data timestamp with time zone DEFAULT now() NOT NULL,
    logitude numeric(4,2) NOT NULL,
    latitude numeric(4,2) NOT NULL,
    device_id uuid NOT NULL,
	FOREIGN KEY (user_id) REFERENCES gosha.users(id),
	FOREIGN KEY (input_id) REFERENCES gosha.inputs(id),
	FOREIGN KEY (device_id) REFERENCES gosha.devices(id)
);


-- Данные
INSERT INTO gosha.devices VALUES ('b07940a1-c522-4b9c-90ba-771c6869d2d7', 'Десантный метео комплект');
INSERT INTO gosha.devices VALUES ('c7237b8d-8b89-46ed-a774-f0c7f4ff7e32', 'Ветровое ружьё');

INSERT INTO gosha.inputs VALUES ('50f94903-a2f1-4992-81e2-e17659550494', 100.00, 26.50, 750.00, 5.00, 0.20, 460.00);

INSERT INTO gosha.posts VALUES ('8a4067b1-c60f-49a5-ab28-1727d982ff6d', 'Рядовой');
INSERT INTO gosha.posts VALUES ('097c2bc2-25a5-49a1-b065-a7f3071d4f29', 'Ефрейтор');
INSERT INTO gosha.posts VALUES ('fa62f27d-e1c7-4371-8580-0914d935d2d7', 'Младший сержант');
INSERT INTO gosha.posts VALUES ('e44c730f-4b69-4eea-9a90-083aece2a73b', 'Сержант');
INSERT INTO gosha.posts VALUES ('32a8a966-bf78-431c-8a40-0e2e9a8937be', 'Старший сержант');
INSERT INTO gosha.posts VALUES ('f9c18342-1ac1-4cff-a178-41264c324e7e', 'Старшина');
INSERT INTO gosha.posts VALUES ('ebb859df-eb9c-40e6-b6ba-3251a632dc92', 'Прапорщик');
INSERT INTO gosha.posts VALUES ('08535746-1a74-45c3-a30f-df2e1e99c834', 'Старший прапорщик');
INSERT INTO gosha.posts VALUES ('a8deadd5-458d-4e2b-ad0d-36f61b82cb07', 'Младший лейтенант');
INSERT INTO gosha.posts VALUES ('e479b4ae-1366-4250-8a26-33078c554bc7', 'Лейтенант');
INSERT INTO gosha.posts VALUES ('9a067746-4ba9-4dc8-afcb-d2264dba39ab', 'Старший лейтенант');
INSERT INTO gosha.posts VALUES ('76a5e650-adfc-407d-a3dd-a101e26ecfa7', 'Капитан');
INSERT INTO gosha.posts VALUES ('4b46b545-fb49-4bf8-9127-2644ad3fc65c', 'Майор');
INSERT INTO gosha.posts VALUES ('034cd1d6-2411-4af5-8910-c453ad709135', 'Подполковник');
INSERT INTO gosha.posts VALUES ('9419a9d0-deb3-4178-b50b-6495e4354fc7', 'Полковник');
INSERT INTO gosha.posts VALUES ('fb5dc871-654e-41a6-9211-eb40f122b3f1', 'Генерал майор');
INSERT INTO gosha.posts VALUES ('63271f85-c48f-4c56-b817-59b504035067', 'Генерал лейтенант');
INSERT INTO gosha.posts VALUES ('23e7bb05-42a2-43a5-b955-8ab531640057', 'Генерал полковник');
INSERT INTO gosha.posts VALUES ('4e739c00-4ab5-4209-bd49-3801c82a15cd', 'Генерал армии');
INSERT INTO gosha.posts VALUES ('9fef70a4-8da4-4ffc-9d4c-11367d7f18b9', 'Маршал России');

INSERT INTO gosha.temperature_delta VALUES (-100, 0);
INSERT INTO gosha.temperature_delta VALUES (-0.01, 0);
INSERT INTO gosha.temperature_delta VALUES (0, 0.5);
INSERT INTO gosha.temperature_delta VALUES (5, 0.5);
INSERT INTO gosha.temperature_delta VALUES (10, 1);
INSERT INTO gosha.temperature_delta VALUES (15, 1);
INSERT INTO gosha.temperature_delta VALUES (20, 1.5);
INSERT INTO gosha.temperature_delta VALUES (25, 2);
INSERT INTO gosha.temperature_delta VALUES (30, 3.5);
INSERT INTO gosha.temperature_delta VALUES (40, 4.5);
INSERT INTO gosha.temperature_delta VALUES (100, 4.5);

INSERT INTO gosha.users VALUES ('1fae05b2-3c7c-4faf-9d45-1393e6107166', 'e479b4ae-1366-4250-8a26-33078c554bc7', 'Воловиков Александр Сергеевич', 45);

INSERT INTO gosha.history VALUES ('51454263-3456-453d-a3f4-ee8bb373451d', '1fae05b2-3c7c-4faf-9d45-1393e6107166', '50f94903-a2f1-4992-81e2-e17659550494', '2025-02-03 13:56:27.489842+00', 36.66, 60.02, 'c7237b8d-8b89-46ed-a774-f0c7f4ff7e32');




-- Начала всяких скриптов
DECLARE params gosha.interpolation;
DECLARE delta numeric(8, 2);
DECLARE our_temp numeric(8, 2) := 22;
BEGIN
	SELECT * FROM gosha.temperature_delta WHERE temperature <= our_temp ORDER BY temperature DESC LIMIT 1 INTO params.x1,params.y1;
	SELECT * FROM gosha.temperature_delta WHERE temperature > our_temp ORDER BY temperature LIMIT 1 INTO params.x2,params.y2;
	delta:= ((params.y1*params.x2 - params.y2*params.x1)/(params.x2-params.x1))+((params.y2 - params.y1)/(params.x2 - params.x1))*our_temp;

	RAISE NOTICE 'interolated delta: %', delta;
END;
	

END$$;
