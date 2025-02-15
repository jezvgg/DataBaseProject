DROP TABLE IF EXISTS gosha.history;
DROP TABLE IF EXISTS gosha.users;
DROP TABLE IF EXISTS gosha.posts;
DROP TABLE IF EXISTS gosha.inputs;
DROP TABLE IF EXISTS gosha.devices;
DROP TABLE IF EXISTS gosha.temperature_delta;
DROP TABLE IF EXISTS gosha.constants;

DROP FUNCTION IF EXISTS gosha."fnHeaderCreate"(data gosha.input);
DROP FUNCTION IF EXISTS gosha."fnInputValidate"(
	height numeric(8,2),
    temperature numeric(8,2),
    pressure numeric(8,2),
    wind_speed numeric(8,2),
    wind_direction numeric(8,2)
	);
DROP FUNCTION IF EXISTS gosha."fnGetConstant"(const_name character varying);
DROP FUNCTION IF EXISTS gosha."fnHeaderGetData"();
DROP FUNCTION IF EXISTS gosha."fnHeaderGetData"(datetime timestamp with time zone);
DROP FUNCTION IF EXISTS gosha."fnHeaderGetHeight"(height numeric);
DROP FUNCTION IF EXISTS gosha."fnHeaderGetPressure"();
DROP FUNCTION IF EXISTS gosha."fnHeaderGetPressure"(pressure numeric);
DROP FUNCTION IF EXISTS gosha."fnHeaderGetTemperature"();
DROP FUNCTION IF EXISTS gosha."fnHeaderGetTemperature"(our_temperature numeric);

DROP TYPE IF EXISTS gosha.interpolation;
DROP TYPE IF EXISTS gosha.input;

DROP SCHEMA IF EXISTS gosha;

CREATE SCHEMA IF NOT EXISTS gosha;


-- Тип данных для интерполяции температуры
CREATE TYPE gosha.interpolation AS
(
	x1 numeric(8, 2),
	y1 numeric(8, 2),
	x2 numeric(8, 2),
	y2 numeric(8, 2)
);


-- Тип для передачи данных
CREATE TYPE gosha.input AS (
    height numeric(8,2),
    temperature numeric(8,2),
    pressure numeric(8,2),
    wind_speed numeric(8,2),
    wind_direction numeric(8,2)
);


-- Устройства измерения
CREATE TABLE IF NOT EXISTS gosha.devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL
);


-- Должности
CREATE TABLE IF NOT EXISTS gosha.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    name character varying(100) NOT NULL
);


-- Поправки температуры
CREATE TABLE IF NOT EXISTS gosha.temperature_delta (
	temperature numeric(8,2) NOT NULL PRIMARY KEY,
	delta numeric(8,2) NOT NULL
);


-- Константы
CREATE TABLE IF NOT EXISTS gosha.constants
(
    id character varying(50) NOT NULL PRIMARY KEY,
    constant character varying(100) NOT NULL
);


-- Введёные метео значения
CREATE TABLE IF NOT EXISTS gosha.inputs (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    height numeric(8,2) NOT NULL,
    temperature numeric(8,2) NOT NULL,
    pressure numeric(8,2) NOT NULL,
    wind_speed numeric(8,2) NOT NULL,
    wind_direction numeric(8,2) NOT NULL,
    bullet_speed numeric(8,2) NOT NULL
);


-- Пользователи
CREATE TABLE IF NOT EXISTS gosha.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    post uuid NOT NULL,
    fullname character varying(100) NOT NULL,
    age numeric(8,2) NOT NULL,
	FOREIGN KEY (post) REFERENCES gosha.posts(id)
);


-- История запросов
CREATE TABLE IF NOT EXISTS gosha.history (
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


-- Данные для вставки
INSERT INTO gosha.constants VALUES ('pressure', '750');
INSERT INTO gosha.constants VALUES ('temperature', '15.9');
INSERT INTO gosha.constants VALUES ('max_temperature', '59');
INSERT INTO gosha.constants VALUES ('min_temperature', '-58');
INSERT INTO gosha.constants VALUES ('max_pressure', '900');
INSERT INTO gosha.constants VALUES ('min_pressure', '500');
INSERT INTO gosha.constants VALUES ('max_wind', '59');
INSERT INTO gosha.constants VALUES ('min_wind', '0');

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


-- Создание функций

-- Получить константу по ключу
CREATE OR REPLACE FUNCTION gosha."fnGetConstant"(
	const_name character varying(50)
	)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	if const_name not in (select id from gosha.constants) then
		raise exception 'Key not in constants!';
	end if;
	return (select constant from gosha.constants where id = const_name);
end;
$BODY$;


-- Получить дата-время в нужном формате
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetData"(
	datetime timestamp with time zone
	)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	return substring(to_char(datetime, 'DDHHMI'), 1, 5);
end;
$BODY$;


-- Получить текущее дата-время в нужном формате
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetData"(
	)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	return gosha."fnHeaderGetData"(now());
end;
$BODY$;


-- Форматировать высоту
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetHeight"(
	height numeric(8, 0))
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	return lpad(round(height)::text, 4, '0');
end;
$BODY$;


-- Получить константу для давления
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetPressure"(
	)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	return gosha."fnGetConstant"('pressure')::numeric(8,0);
end;
$BODY$;


-- Получить рассчитаное давление
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetPressure"(
	pressure numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE 
	pressure_delta numeric;
begin
	pressure_delta := pressure - gosha."fnHeaderGetPressure"();
	IF pressure_delta < 0 THEN
		pressure_delta := pressure_delta - 500;
	END IF;
	pressure_delta := abs(pressure_delta);
	return pressure_delta;
end;
$BODY$;


-- Получить константу для температуры
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetTemperature"(
	)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	return gosha."fnGetConstant"('temperature')::numeric(8,0);
end;
$BODY$;


-- Получить рассчитаную температуру
CREATE OR REPLACE FUNCTION gosha."fnHeaderGetTemperature"(
	our_temperature numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	params gosha.interpolation;
	delta numeric(8, 2);
begin
	
	IF our_temperature > 40 THEN
        RAISE EXCEPTION 'Error: impossible temrepature for artilery';
    END IF; 
	SELECT * FROM gosha.temperature_delta WHERE temperature <= our_temperature ORDER BY temperature DESC LIMIT 1 INTO params.x1,params.y1;
	SELECT * FROM gosha.temperature_delta WHERE temperature > our_temperature ORDER BY temperature LIMIT 1 INTO params.x2,params.y2;
	delta:= ((params.y1*params.x2 - params.y2*params.x1)/(params.x2-params.x1))+((params.y2 - params.y1)/(params.x2 - params.x1))*our_temperature;
	return round((our_temperature + delta) - gosha."fnHeaderGetTemperature"());
end;
$BODY$;


-- sssss
CREATE OR REPLACE FUNCTION gosha."fnInputValidate"(
	height numeric(8,2),
    temperature numeric(8,2),
    pressure numeric(8,2),
    wind_speed numeric(8,2),
    wind_direction numeric(8,2)
	)
    RETURNS gosha.input
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	results gosha.input;
begin
	IF temperature < gosha."fnGetConstant"('min_temperature')::numeric OR 
		temperature > gosha."fnGetConstant"('max_temperature')::numeric OR 
		pressure > gosha."fnGetConstant"('max_pressure')::numeric OR 
		pressure < gosha."fnGetConstant"('min_pressure')::numeric OR 
		wind_speed > gosha."fnGetConstant"('max_wind')::numeric OR 
		wind_speed < gosha."fnGetConstant"('min_wind')::numeric OR THEN
		raise exception 'Неккоректные входящие данные.';
	END IF;
	SELECT COALESCE(height, 0), COALESCE(temperature, 0), COALESCE(pressure,0), COALESCE(wind_speed,0), COALESCE(wind_direction,0) INTO results.height, results.temperature, results.pressure, results.wind_speed, results.wind_direction;
	return results;
end;
$BODY$;


-- Сделать расчёты
CREATE OR REPLACE FUNCTION gosha."fnHeaderCreate"(
	data gosha.input
	)
    RETURNS TABLE(datetime character(5), height character(4), params character(5))
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	return query select gosha."fnHeaderGetData"()::character(5), gosha."fnHeaderGetHeight"(data.height)::character(4), (lpad(gosha."fnHeaderGetPressure"(735)::text, 3, '0') || lpad(gosha."fnHeaderGetTemperature"(23)::text, 2, '0'))::character(5);
end;
$BODY$;



select gosha."fnHeaderCreate"((60, 23, 755, 34, 34));