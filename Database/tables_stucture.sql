-- Тип данных для интерполяции температуры
CREATE TYPE gosha.interpolation AS
(
	x1 numeric(8, 2),
	y1 numeric(8, 2),
	x2 numeric(8, 2),
	y2 numeric(8, 2)
);


-- Метео приближённая
CREATE TYPE gosha.header AS 
(
	datetime character(5),
	height character(4),
	pressure_temperature character(5)
);


-- Тип рассчётов
CREATE TYPE gosha.calculations AS (
	heights numeric[],
	windtemp numeric[],
	wind numeric[],
	bullet numeric[]
);


-- Таблица рассчётов
CREATE TYPE gosha.calculation_table AS (
	header gosha.header,
	calculations gosha.calculations
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


-- Имена шапок для константных таблиц
CREATE TABLE IF NOT EXISTS gosha.header_names (
	id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	name character(100) NOT NULL
);


-- Имена константных таблиц
CREATE TABLE IF NOT EXISTS gosha.const_table_names (
	id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	name character(100) NOT NULL
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


-- Значения константных таблиц
CREATE TABLE IF NOT EXISTS gosha.const_table_values (
	id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	value numeric(8,2) NOT NULL,
	name uuid NOT NULL,
	device uuid,
	FOREIGN KEY (name) REFERENCES gosha.const_table_names(id),
	FOREIGN KEY (device) REFERENCES gosha.devices(id)
);


-- Пользователи
CREATE TABLE IF NOT EXISTS gosha.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    post uuid NOT NULL,
    fullname character varying(100) NOT NULL,
    age numeric(8,2) NOT NULL,
	FOREIGN KEY (post) REFERENCES gosha.posts(id)
);


-- Шапки константных таблиц
CREATE TABLE IF NOT EXISTS gosha.const_table_headers (
	id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	value numeric(8,2) NOT NULL,
	name uuid NOT NULL,
	FOREIGN KEY (name) REFERENCES gosha.header_names(id)
);


-- Связи для составления константных таблиц
CREATE TABLE IF NOT EXISTS gosha.const_table_links (
	id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
	value_id uuid NOT NULL,
	header_id uuid NOT NULL,
	FOREIGN KEY (value_id) REFERENCES gosha.const_table_values(id),
	FOREIGN KEY (header_id) REFERENCES gosha.const_table_headers(id)
);


-- История запросов
CREATE TABLE IF NOT EXISTS gosha.history (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    user_id uuid NOT NULL default '1fae05b2-3c7c-4faf-9d45-1393e6107166',
    input_id uuid NOT NULL,
    data timestamp with time zone DEFAULT now() NOT NULL,
    logitude numeric(4,2) NOT NULL,
    latitude numeric(4,2) NOT NULL,
    device_id uuid NOT NULL,
	calculation gosha.calculation_table,
	FOREIGN KEY (user_id) REFERENCES gosha.users(id),
	FOREIGN KEY (input_id) REFERENCES gosha.inputs(id),
	FOREIGN KEY (device_id) REFERENCES gosha.devices(id)
);	