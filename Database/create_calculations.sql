-- Создание представлений
create view gosha.wind_temperature_delta as
WITH headers AS (
        SELECT t1.id, t1.value, t2.name 
        FROM gosha.const_table_headers AS t1
        JOIN gosha.header_names AS t2 ON t1.name = t2.id
    ),
    heights AS (
        SELECT t2.value AS heights, t1.value_id AS next_id 
        FROM gosha.const_table_links AS t1
        JOIN (SELECT * FROM headers WHERE name = 'heights') AS t2 ON t1.header_id = t2.id
    ),
    temp_delts AS (
        SELECT t1.heights, t3.value AS temp_delts, t2.value_id AS next_id 
        FROM heights AS t1
        JOIN gosha.const_table_links AS t2 ON t1.next_id = t2.value_id
        JOIN (SELECT * FROM headers WHERE name = 'temp_delts') AS t3 ON t2.header_id = t3.id
    ),
    is_possitives AS (
        SELECT t1.heights, t1.temp_delts, t3.value AS is_possitive, t2.value_id AS next_id 
        FROM temp_delts AS t1
        JOIN gosha.const_table_links AS t2 ON t1.next_id = t2.value_id
        JOIN (SELECT * FROM headers WHERE name = 'is_possitive') AS t3 ON t2.header_id = t3.id
    ),
	values as (
		select t1.* from gosha.const_table_values as t1
		join gosha.const_table_names as t2 on t1.name = t2.id
		where t2.name = 'temperature_delts'
	)
    SELECT t1.heights, t1.temp_delts, t1.is_possitive, t5.value 
    FROM is_possitives AS t1
    JOIN values AS t5 ON t1.next_id = t5.id;


create view gosha.wind_direction_delta as
WITH headers AS (
        SELECT t1.id, t1.value, t2.name 
        FROM gosha.const_table_headers AS t1
        JOIN gosha.header_names AS t2 ON t1.name = t2.id
    ),
	heights AS (
        SELECT t2.value AS heights, t1.value_id AS next_id 
        FROM gosha.const_table_links AS t1
        JOIN (SELECT * FROM headers WHERE name = 'heights') AS t2 ON t1.header_id = t2.id
    ),
	values as (
		select t1.id, t1.value, t3.name from gosha.const_table_values as t1
		join gosha.const_table_names as t2 on t1.name = t2.id
		left join gosha.devices as t3 on t1.device = t3.id
		where t2.name = 'wind_direction_delts'
	)
	SELECT t1.heights, t5.value, t5.name as device 
    FROM heights AS t1
    JOIN values AS t5 ON t1.next_id = t5.id;


create view gosha.bullet_delta as
WITH headers AS (
        SELECT t1.id, t1.value, t2.name 
        FROM gosha.const_table_headers AS t1
        JOIN gosha.header_names AS t2 ON t1.name = t2.id
    ),
	heights AS (
        SELECT t2.value AS heights, t1.value_id AS next_id 
        FROM gosha.const_table_links AS t1
        JOIN (SELECT * FROM headers WHERE name = 'heights') AS t2 ON t1.header_id = t2.id
    ),
	bullet_delts AS (
        SELECT t1.heights, t3.value AS bullet_delts, t2.value_id AS next_id 
        FROM heights AS t1
        JOIN gosha.const_table_links AS t2 ON t1.next_id = t2.value_id
        JOIN (SELECT * FROM headers WHERE name = 'bullet_delts') AS t3 ON t2.header_id = t3.id
    ),
	values as (
		select t1.id, t1.value, t3.name from gosha.const_table_values as t1
		join gosha.const_table_names as t2 on t1.name = t2.id
		left join gosha.devices as t3 on t1.device = t3.id
		where t2.name = 'bullet_delts'
	)
	SELECT t1.heights, t1.bullet_delts, t5.value, t5.name as device 
    FROM bullet_delts AS t1
    JOIN values AS t5 ON t1.next_id = t5.id;


-- Создаём временную таблицу, для вставки с фронта
-- CREATE TEMP TABLE gosha.frontend_table (
-- 	user_id uuid default '1fae05b2-3c7c-4faf-9d45-1393e6107166',
-- 	height numeric(8,2) NOT NULL,
--     temperature numeric(8,2) NOT NULL,
--     pressure numeric(8,2) NOT NULL,
--     wind_direction numeric(8,2) NOT NULL,
--     bullet_speed numeric(8,2) NOT NULL,
-- 	logitude numeric(4,2) NOT NULL,
-- 	latitude numeric(4,2) NOT NULL,
-- 	device_name text
-- );

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


-- Функция валидации данных
CREATE OR REPLACE FUNCTION gosha."fnInputValidate"(
	height numeric(8,2),
    temperature numeric(8,2),
    pressure numeric(8,2),
    wind_speed numeric(8,2),
    wind_direction numeric(8,2)
	)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	IF temperature < gosha."fnGetConstant"('min_temperature')::numeric OR 
		temperature > gosha."fnGetConstant"('max_temperature')::numeric OR 
		pressure > gosha."fnGetConstant"('max_pressure')::numeric OR 
		pressure < gosha."fnGetConstant"('min_pressure')::numeric OR 
		wind_speed > gosha."fnGetConstant"('max_wind')::numeric OR 
		wind_speed < gosha."fnGetConstant"('min_wind')::numeric OR THEN
		return false;
	END IF;
	return true;
end;
$BODY$;


-- Сделать расчёты
CREATE OR REPLACE FUNCTION gosha."fnHeaderCreate"(
	height_ numeric(8,2),
    temperature numeric(8,2),
    pressure numeric(8,2),
    wind_speed numeric(8,2),
    wind_direction numeric(8,2)
	)
    RETURNS gosha.header
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare 
	res gosha.header;
begin
	IF not gosha."fnInputValidate"(height_, temperature, pressure, wind_speed, wind_direction) THEN
		raise exception 'Неккоректные данные!';
	END IF;
	res.datetime = gosha."fnHeaderGetData"();
	res.height = gosha."fnHeaderGetHeight"(height_);
	res.pressure_temperature = lpad(gosha."fnHeaderGetPressure"(pressure)::text, 3, '0') || lpad(gosha."fnHeaderGetTemperature"(temperature)::text, 2, '0');
	return res;
end;
$BODY$;


-- Процедура получения разницы ветрянной температуры
CREATE OR REPLACE FUNCTION gosha."prGetWindTempDelta"(temp_delta numeric)
	RETURNS numeric[]
	LANGUAGE 'plpgsql'
	AS $BODY$
declare
	delts numeric[] default array[]::numeric[];
	isabove numeric(8,2);
begin
	isabove := case when temp_delta > 0 then 1 else 0 end;
	select array_agg(t1.value + t2.value) from (select heights, value from gosha.wind_temperature_delta where temp_delts = floor(abs(temp_delta) / 10) * 10.0 and is_possitive = isabove) as t1
	inner join (select heights, value from gosha.wind_temperature_delta where temp_delts = abs(temp_delta) % 10 and is_possitive = isabove) as t2
	on t1.heights = t2.heights
	into delts;
	return delts;
end;
$BODY$;


-- Рассчёт направленя среднего ветра
CREATE OR REPLACE FUNCTION gosha."fnGetAvgWind"(
	wind_speed numeric(8, 0),
	device_name text)
    RETURNS numeric[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	delts numeric[] default array[]::numeric[];
begin
	select array_agg(value + wind_speed) from gosha.wind_direction_delta where device=device_name into delts;
	return delts;
end;
$BODY$;


-- Рассчёт направленя среднего ветра
CREATE OR REPLACE FUNCTION gosha."fnGetBullet"(
	bullet_speed numeric(8, 2),
	device_name text)
    RETURNS numeric[]
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
	delts numeric[] default array[]::numeric[];
begin
	select array_agg( x1 + (((bullet_speed - y1)*(x2-x1))/(y2-y1)) ) as result
	from (select heights, min(bullet_delts) as y2, min(value) as x2 from gosha.bullet_delta where device=device_name and bullet_delts > bullet_speed group by heights) as t1
	join (select heights, max(bullet_delts) as y1, max(value) as x1 from gosha.bullet_delta where device=device_name and bullet_delts <= bullet_speed group by heights) as t2 on t1.heights = t2.heights
	into delts;
	return delts;
end;
$BODY$;


CREATE OR REPLACE FUNCTION gosha."fnCalculation"(
    temperature numeric(8,2),
    wind_speed numeric(8,2),
    bullet_param numeric(8,2),
	device_name text
)
	RETURNS gosha.calculations
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
	res gosha.calculations;
begin
	WITH headers AS (
        SELECT t1.value
        FROM gosha.const_table_headers AS t1
        JOIN gosha.header_names AS t2 ON t1.name = t2.id
		where t2.name = 'heights'
    )
    select array_agg(value) from headers into res.heights;
	res.windtemp := gosha."prGetWindTempDelta"(gosha."fnHeaderGetTemperature"(temperature));
	res.wind := gosha."fnGetAvgWind"(wind_speed, device_name);
	res.bullet := gosha."fnGetBullet"(bullet_param, device_name);
	return res;
end;
$BODY$;


CREATE OR REPLACE FUNCTION gosha."trCheckInput"()
RETURNS TRIGGER 
LANGUAGE 'plpgsql'
AS $$
begin
    IF not gosha."fnInputValidate"(NEW.height, NEW.temperature, NEW.pressure, NEW.wind_speed, NEW.wind_direction) THEN
        RAISE exception 'Invalid inputs';
    END IF;
    return NEW;
end;
$$;

CREATE TRIGGER trInput
BEFORE INSERT ON gosha.inputs
FOR EACH ROW
EXECUTE FUNCTION gosha."trCheckInput"();


CREATE OR REPLACE FUNCTION gosha."trCalculateInput"()
RETURNS TRIGGER 
LANGUAGE 'plpgsql'
AS $$
declare
    calculation_ gosha.calculation_table;
begin
    select gosha."fnHeaderCreate"(t2.height, t2.temperature, t2.pressure, t2.wind_speed, t2.wind_direction) as header,
    gosha."fnCalculation"(t2.temperature, t2.bullet_speed, t2.bullet_speed, t3.name) as calculations 
    from (select * from gosha.inputs where id = NEW.input_id) as t2 
    join (select * from gosha.devices where id = NEW.device_id) as t3 on 1=1
    into calculation_;
    NEW.calculation = calculation_;
    return NEW;
end;
$$;

CREATE TRIGGER trCalculate
BEFORE INSERT ON gosha.history
FOR EACH ROW
EXECUTE FUNCTION gosha."trCalculateInput"();