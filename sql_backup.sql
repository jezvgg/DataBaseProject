DROP SCHEMA IF EXISTS gosha CASCADE;

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
	FOREIGN KEY (name) REFERENCES gosha.const_table_names(id)
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

INSERT INTO gosha.header_names VALUES ('a459d14f-f091-4bb3-bafb-c4dfea48ea0d', 'heights');
INSERT INTO gosha.header_names VALUES ('6fba682c-538e-41ad-8f02-4211acd7af73', 'temp_delts');
INSERT INTO gosha.header_names VALUES ('33f5ba82-cd60-40f9-a3ad-2965e47d93ac', 'is_possitive');
INSERT INTO gosha.header_names VALUES ('a21ddce1-a3ce-46dc-b4cb-7c75a262209a', 'bullet_delts');
INSERT INTO gosha.header_names VALUES ('de8b1ddb-bf98-427c-98e6-ef8abde593f3', 'angle_delts');

INSERT INTO gosha.const_table_names VALUES ('8dd77de1-d576-4691-8358-f76bf521753a', 'temperature_delts');
INSERT INTO gosha.const_table_names VALUES ('69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef', 'wind_direction_delts');
INSERT INTO gosha.const_table_names VALUES ('b6669f4e-6811-4920-a57a-14318d7ba664', 'bullet_delts');

INSERT INTO gosha.const_table_headers VALUES ('fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b', 200, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('19f254bd-f737-4661-b037-faaddb2df77e', 400, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('9c248174-82cf-485f-a14b-d496c1e6bad3', 800, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('ae8de529-4081-436b-8944-420028fa3cf4', 1200, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('845b0477-bc67-40be-824a-ef933fd5f939', 1600, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('29f4ffde-281e-402b-be8a-1621e03504c0', 2000, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('bf109d15-5e82-4363-9484-9b0f67141e3d', 2400, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('6f95200d-31a2-4f01-be6b-f8e344a2e402', 3000, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');
INSERT INTO gosha.const_table_headers VALUES ('5b0c31e5-ce5c-4f20-a538-3eee8e183939', 4000, 'a459d14f-f091-4bb3-bafb-c4dfea48ea0d');

INSERT INTO gosha.const_table_headers VALUES ('7344b92d-7760-4434-b6f6-3971e97bbb37', 0, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('197c058d-d74b-484e-96c6-11676959b4cc', 1, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('d6d80c7b-7339-4586-8504-9aaa17a82c4e', 2, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('3a091a87-c8bc-45e1-97b7-e46fe5793f75', 3, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('7c55a13a-87cf-45fd-8ca1-e285a10cb698', 4, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('c7ab9d80-3741-46da-8215-84dbb205ad7a', 5, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('ab8041ae-cfce-4bbe-b2db-c8fb863fc93d', 6, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('733d16a7-eac9-44f9-90ab-1d3211c4c0c1', 7, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('8ed5d240-c14d-4e7c-a2df-3c82c3d0589f', 8, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('5d303816-5b07-470a-90f3-22777a08e3b1', 9, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('31f2d040-7f5a-492f-b6e3-f12a2aebf1a2', 10, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('69112646-2a84-4a1d-be1b-0fa138dfab61', 20, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('b8a90a55-1984-4e04-a6bc-5c6b6882281d', 30, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('88a972e1-bd65-413f-afff-58619f2420b3', 40, '6fba682c-538e-41ad-8f02-4211acd7af73');
INSERT INTO gosha.const_table_headers VALUES ('d40a05eb-1851-4a44-a7e5-4729e6ba0091', 50, '6fba682c-538e-41ad-8f02-4211acd7af73');

INSERT INTO gosha.const_table_headers VALUES ('5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb', 0, '33f5ba82-cd60-40f9-a3ad-2965e47d93ac');
INSERT INTO gosha.const_table_headers VALUES ('4c72a246-9225-4ffb-9d56-1f5c55268e64', 1, '33f5ba82-cd60-40f9-a3ad-2965e47d93ac');

INSERT INTO gosha.const_table_headers VALUES ('46322079-b68d-4b07-abce-98fa42cc8fca', 3, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('555f8a00-0039-46a9-aa43-f86468551d8f', 4, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('217a9ae1-890c-49a8-8fde-31ccd828cfb8', 5, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('80ff3e50-e752-4338-b07d-9754cd020ddf', 6, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9', 7, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('c8c31e45-a217-4d64-94b0-3e823abea28e', 8, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('f667b401-1cfb-4529-8e9e-f938f87e58ed', 9, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('9b71c896-efda-45ec-a06a-5fbc3afe2644', 10, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('48fe940a-7eb4-4e76-8f0a-dd65a8909f4c', 11, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('0e988140-5fb7-469c-9734-8da9838ed3e7', 12, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('e7112b1c-5a21-46f8-afca-1baa583856d7', 13, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('d0473e8e-1a7b-4817-9847-d3e5a745f498', 14, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');
INSERT INTO gosha.const_table_headers VALUES ('0acfe29a-4b57-47f2-a093-dd0b00461cf8', 15, 'a21ddce1-a3ce-46dc-b4cb-7c75a262209a');


INSERT INTO gosha.const_table_values VALUES ('37200186-77e3-41c7-a56b-48b708b26a56', 1, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('a0b67763-3ddc-429f-af6c-95d7f6b47592', 2, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('eb19cb9b-6c11-4ed6-a0a4-2219270d60e7', 3, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('af8978f5-c476-432e-9794-393c6d204707', 3, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('bb65e5db-10b1-429b-9cb6-89b88ee55cf0', 4, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('af7d551f-7acb-4ec8-80e1-7c2a9674e088', 4, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('1fa11612-cb1f-4ef0-9930-15b7553bd667', 4, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('7d9c4d1c-34af-41c5-8cc6-8e34b4ed6cab', 5, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');
INSERT INTO gosha.const_table_values VALUES ('e13ff294-c106-40f3-bd66-ebb766adb897', 5, '69dda9a8-a4e9-4f24-b8ba-a7593a4e66ef');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37200186-77e3-41c7-a56b-48b708b26a56', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0b67763-3ddc-429f-af6c-95d7f6b47592', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'eb19cb9b-6c11-4ed6-a0a4-2219270d60e7', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'af8978f5-c476-432e-9794-393c6d204707', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bb65e5db-10b1-429b-9cb6-89b88ee55cf0', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'af7d551f-7acb-4ec8-80e1-7c2a9674e088', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1fa11612-cb1f-4ef0-9930-15b7553bd667', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7d9c4d1c-34af-41c5-8cc6-8e34b4ed6cab', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e13ff294-c106-40f3-bd66-ebb766adb897', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');





-- 200
INSERT INTO gosha.const_table_values VALUES ('11359b2e-c4de-4d95-a77e-df49fd22ca53', 4, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('5b1b1981-d420-43d5-b854-8d6120a001a1', 6, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('f58cd8ab-6d60-4027-b23c-243d1c8e2bdb', 8, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('acb1a14d-1e81-4258-b00b-5c88373e377b', 9, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('9b5da669-e904-442e-bbe5-b3d06bb24cb3', 10, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('830b5b39-226a-4f3c-853e-d97e6b6ee916', 12, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('a7601888-fd5b-40d5-80df-1eff597e100a', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('356f96f0-de95-4bf3-a7ae-0a51e5786490', 15, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('193a4d7a-1021-4776-b48c-88adeb19dae3', 16, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('0b73dcc3-f113-4967-aae8-ec00c62b164e', 18, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('16aa79b7-b385-40e6-97ad-452ee2c19efa', 20, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('744ce5cb-4928-44c4-ae8b-60027c55832e', 21, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('fc1b1f77-cdd5-445b-9444-95a22c5853e6', 22, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '11359b2e-c4de-4d95-a77e-df49fd22ca53', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b1b1981-d420-43d5-b854-8d6120a001a1', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f58cd8ab-6d60-4027-b23c-243d1c8e2bdb', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'acb1a14d-1e81-4258-b00b-5c88373e377b', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9b5da669-e904-442e-bbe5-b3d06bb24cb3', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '830b5b39-226a-4f3c-853e-d97e6b6ee916', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a7601888-fd5b-40d5-80df-1eff597e100a', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '356f96f0-de95-4bf3-a7ae-0a51e5786490', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '193a4d7a-1021-4776-b48c-88adeb19dae3', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0b73dcc3-f113-4967-aae8-ec00c62b164e', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '16aa79b7-b385-40e6-97ad-452ee2c19efa', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '744ce5cb-4928-44c4-ae8b-60027c55832e', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'fc1b1f77-cdd5-445b-9444-95a22c5853e6', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '11359b2e-c4de-4d95-a77e-df49fd22ca53', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b1b1981-d420-43d5-b854-8d6120a001a1', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f58cd8ab-6d60-4027-b23c-243d1c8e2bdb', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'acb1a14d-1e81-4258-b00b-5c88373e377b', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9b5da669-e904-442e-bbe5-b3d06bb24cb3', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '830b5b39-226a-4f3c-853e-d97e6b6ee916', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a7601888-fd5b-40d5-80df-1eff597e100a', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '356f96f0-de95-4bf3-a7ae-0a51e5786490', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '193a4d7a-1021-4776-b48c-88adeb19dae3', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0b73dcc3-f113-4967-aae8-ec00c62b164e', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '16aa79b7-b385-40e6-97ad-452ee2c19efa', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '744ce5cb-4928-44c4-ae8b-60027c55832e', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'fc1b1f77-cdd5-445b-9444-95a22c5853e6', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 400
INSERT INTO gosha.const_table_values VALUES ('004d65e3-8e24-4fd3-a79a-7111de505b4e', 5, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('ca757a06-3a0f-4948-ad05-f6cdbfe7e10d', 7, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('8cfd9e20-0bfd-4e6f-8717-e4e14f487a91', 10, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b6b5b25d-7ed7-4146-9732-306b6ef5f24c', 11, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('73daaa1c-2174-499b-83e0-ad50e2139c69', 12, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('4b9bdf05-33e3-4f92-8ee8-b2eb936e0d33', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('748ba582-f7c6-418f-8f76-7008cb7540ea', 17, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('ce3f076a-7a55-41b0-a214-22b9e350d7bb', 18, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b3f8370d-c99b-4e89-9926-95d5790ef62a', 20, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('be5f9689-0d4e-4a38-ad38-2591dfc74fe0', 22, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('723d2c63-4ada-41d3-90c0-8054815f2a5c', 23, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b1fdc81b-5a34-4008-bfde-4c520e5fc59b', 25, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('c6caf64a-bd5d-4275-b520-82f072163039', 27, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '004d65e3-8e24-4fd3-a79a-7111de505b4e', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ca757a06-3a0f-4948-ad05-f6cdbfe7e10d', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8cfd9e20-0bfd-4e6f-8717-e4e14f487a91', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b6b5b25d-7ed7-4146-9732-306b6ef5f24c', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73daaa1c-2174-499b-83e0-ad50e2139c69', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b9bdf05-33e3-4f92-8ee8-b2eb936e0d33', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '748ba582-f7c6-418f-8f76-7008cb7540ea', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ce3f076a-7a55-41b0-a214-22b9e350d7bb', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b3f8370d-c99b-4e89-9926-95d5790ef62a', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'be5f9689-0d4e-4a38-ad38-2591dfc74fe0', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '723d2c63-4ada-41d3-90c0-8054815f2a5c', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1fdc81b-5a34-4008-bfde-4c520e5fc59b', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c6caf64a-bd5d-4275-b520-82f072163039', '19f254bd-f737-4661-b037-faaddb2df77e');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '004d65e3-8e24-4fd3-a79a-7111de505b4e', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ca757a06-3a0f-4948-ad05-f6cdbfe7e10d', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8cfd9e20-0bfd-4e6f-8717-e4e14f487a91', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b6b5b25d-7ed7-4146-9732-306b6ef5f24c', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73daaa1c-2174-499b-83e0-ad50e2139c69', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b9bdf05-33e3-4f92-8ee8-b2eb936e0d33', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '748ba582-f7c6-418f-8f76-7008cb7540ea', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ce3f076a-7a55-41b0-a214-22b9e350d7bb', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b3f8370d-c99b-4e89-9926-95d5790ef62a', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'be5f9689-0d4e-4a38-ad38-2591dfc74fe0', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '723d2c63-4ada-41d3-90c0-8054815f2a5c', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1fdc81b-5a34-4008-bfde-4c520e5fc59b', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c6caf64a-bd5d-4275-b520-82f072163039', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 800
INSERT INTO gosha.const_table_values VALUES ('0011b034-cc6c-4ba7-bea5-17a4a1492cb7', 5, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b6ce1405-c2d1-4a2e-a6c6-c73792e11545', 8, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('baae83b3-146e-46da-88a4-41f02b23ce7e', 10, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('1e87192d-652d-4032-9562-473875254e3f', 11, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('6f2d7804-c092-4ae6-85e9-9c7e6ff93b07', 13, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('58a9270d-a5f3-4ebe-abd6-f975cb6cbe8a', 15, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('066bbfca-d5a8-44dc-8d1e-8a7df959f892', 18, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('2105501f-3cf9-43af-aaec-38c8ec727d1c', 19, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('45e5c2aa-2c0f-4cac-af7c-ff053febc8e4', 21, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('ce3709eb-80f1-401f-aa65-f080087539f1', 23, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b957793f-e6a9-463c-81e3-7e9d0d50ce33', 25, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('9f810369-f5ab-479f-846f-ffa164711d48', 27, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('3ed0a20d-1fc7-4acc-aa01-8815e64b6e94', 28, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0011b034-cc6c-4ba7-bea5-17a4a1492cb7', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b6ce1405-c2d1-4a2e-a6c6-c73792e11545', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'baae83b3-146e-46da-88a4-41f02b23ce7e', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1e87192d-652d-4032-9562-473875254e3f', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6f2d7804-c092-4ae6-85e9-9c7e6ff93b07', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '58a9270d-a5f3-4ebe-abd6-f975cb6cbe8a', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '066bbfca-d5a8-44dc-8d1e-8a7df959f892', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2105501f-3cf9-43af-aaec-38c8ec727d1c', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '45e5c2aa-2c0f-4cac-af7c-ff053febc8e4', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ce3709eb-80f1-401f-aa65-f080087539f1', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b957793f-e6a9-463c-81e3-7e9d0d50ce33', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9f810369-f5ab-479f-846f-ffa164711d48', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3ed0a20d-1fc7-4acc-aa01-8815e64b6e94', '9c248174-82cf-485f-a14b-d496c1e6bad3');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0011b034-cc6c-4ba7-bea5-17a4a1492cb7', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b6ce1405-c2d1-4a2e-a6c6-c73792e11545', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'baae83b3-146e-46da-88a4-41f02b23ce7e', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1e87192d-652d-4032-9562-473875254e3f', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6f2d7804-c092-4ae6-85e9-9c7e6ff93b07', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '58a9270d-a5f3-4ebe-abd6-f975cb6cbe8a', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '066bbfca-d5a8-44dc-8d1e-8a7df959f892', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2105501f-3cf9-43af-aaec-38c8ec727d1c', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '45e5c2aa-2c0f-4cac-af7c-ff053febc8e4', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ce3709eb-80f1-401f-aa65-f080087539f1', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b957793f-e6a9-463c-81e3-7e9d0d50ce33', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9f810369-f5ab-479f-846f-ffa164711d48', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3ed0a20d-1fc7-4acc-aa01-8815e64b6e94', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 1200
INSERT INTO gosha.const_table_values VALUES ('4bea9541-fe98-44c7-beb4-aaf4ff93b2d8', 5, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('a1a777f6-d6b8-4157-ab20-ce5f54d271b3', 8, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('c12b6571-38a5-441b-afea-3c9d26128335', 11, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('295409c8-2275-4a08-830b-efe42f6ef58b', 12, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('6aa3ac25-86de-4bdc-948b-3499811c0e5e', 13, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('62185d2e-72dc-4ca6-9315-b5ff7f56431e', 16, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('747f145d-3204-4981-9d6f-b9c6a8e04e18', 19, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('6f5cad01-0e82-4af0-8994-72bab6f224ce', 20, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('1be3dbd1-d897-4f8e-8204-63e5fbdc9dfd', 22, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('d1afa9c0-de04-4b2f-a6d1-e90489a9ddf6', 24, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('d8b8e7f1-7ac0-471e-b0fc-076c8c905426', 26, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('60812c5b-6f0e-4f4b-bf51-ff8ca9bc64a5', 28, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('75043b6c-1728-4bee-89cd-54331ccc7862', 30, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4bea9541-fe98-44c7-beb4-aaf4ff93b2d8', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a1a777f6-d6b8-4157-ab20-ce5f54d271b3', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c12b6571-38a5-441b-afea-3c9d26128335', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '295409c8-2275-4a08-830b-efe42f6ef58b', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6aa3ac25-86de-4bdc-948b-3499811c0e5e', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '62185d2e-72dc-4ca6-9315-b5ff7f56431e', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '747f145d-3204-4981-9d6f-b9c6a8e04e18', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6f5cad01-0e82-4af0-8994-72bab6f224ce', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1be3dbd1-d897-4f8e-8204-63e5fbdc9dfd', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd1afa9c0-de04-4b2f-a6d1-e90489a9ddf6', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd8b8e7f1-7ac0-471e-b0fc-076c8c905426', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '60812c5b-6f0e-4f4b-bf51-ff8ca9bc64a5', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '75043b6c-1728-4bee-89cd-54331ccc7862', 'ae8de529-4081-436b-8944-420028fa3cf4');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4bea9541-fe98-44c7-beb4-aaf4ff93b2d8', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a1a777f6-d6b8-4157-ab20-ce5f54d271b3', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c12b6571-38a5-441b-afea-3c9d26128335', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '295409c8-2275-4a08-830b-efe42f6ef58b', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6aa3ac25-86de-4bdc-948b-3499811c0e5e', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '62185d2e-72dc-4ca6-9315-b5ff7f56431e', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '747f145d-3204-4981-9d6f-b9c6a8e04e18', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6f5cad01-0e82-4af0-8994-72bab6f224ce', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1be3dbd1-d897-4f8e-8204-63e5fbdc9dfd', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd1afa9c0-de04-4b2f-a6d1-e90489a9ddf6', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd8b8e7f1-7ac0-471e-b0fc-076c8c905426', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '60812c5b-6f0e-4f4b-bf51-ff8ca9bc64a5', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '75043b6c-1728-4bee-89cd-54331ccc7862', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 1600
INSERT INTO gosha.const_table_values VALUES ('b1aef7fa-1676-4b99-81fb-d7ba024d3a5e', 6, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('4b31e93f-8714-48a4-86ef-32685c13c932', 8, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('6486d3b3-821e-4d8b-8f4a-00a8e20cdd65', 11, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('32aa2684-2bf8-48de-be88-d8ba511eb155', 13, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('19d3017a-fa69-4432-9158-b67f18fd81d2', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('c0cae770-a000-460b-b5c8-7ca9ce28d108', 17, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('6b865005-c093-46a6-82fe-8f8ef06550a4', 20, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('272f808b-b1d5-4fa3-9143-d838380cb30b', 21, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b4777437-65d5-4fba-b719-e2b36b83c4a4', 23, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('39e5ab92-d585-46c9-86b6-94a09dd2273d', 25, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('0ce9e2f6-e026-4644-833b-141e50cf50ac', 27, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('9c1c6140-a53f-4f30-a271-ee250e939e87', 29, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('8a011b69-c3c2-4f9d-a8cb-84daeb2157b0', 32, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1aef7fa-1676-4b99-81fb-d7ba024d3a5e', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b31e93f-8714-48a4-86ef-32685c13c932', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6486d3b3-821e-4d8b-8f4a-00a8e20cdd65', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '32aa2684-2bf8-48de-be88-d8ba511eb155', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '19d3017a-fa69-4432-9158-b67f18fd81d2', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c0cae770-a000-460b-b5c8-7ca9ce28d108', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6b865005-c093-46a6-82fe-8f8ef06550a4', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '272f808b-b1d5-4fa3-9143-d838380cb30b', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b4777437-65d5-4fba-b719-e2b36b83c4a4', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '39e5ab92-d585-46c9-86b6-94a09dd2273d', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0ce9e2f6-e026-4644-833b-141e50cf50ac', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c1c6140-a53f-4f30-a271-ee250e939e87', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8a011b69-c3c2-4f9d-a8cb-84daeb2157b0', '845b0477-bc67-40be-824a-ef933fd5f939');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1aef7fa-1676-4b99-81fb-d7ba024d3a5e', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b31e93f-8714-48a4-86ef-32685c13c932', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6486d3b3-821e-4d8b-8f4a-00a8e20cdd65', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '32aa2684-2bf8-48de-be88-d8ba511eb155', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '19d3017a-fa69-4432-9158-b67f18fd81d2', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c0cae770-a000-460b-b5c8-7ca9ce28d108', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6b865005-c093-46a6-82fe-8f8ef06550a4', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '272f808b-b1d5-4fa3-9143-d838380cb30b', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b4777437-65d5-4fba-b719-e2b36b83c4a4', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '39e5ab92-d585-46c9-86b6-94a09dd2273d', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0ce9e2f6-e026-4644-833b-141e50cf50ac', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c1c6140-a53f-4f30-a271-ee250e939e87', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8a011b69-c3c2-4f9d-a8cb-84daeb2157b0', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 2000
INSERT INTO gosha.const_table_values VALUES ('fc9dc852-5a13-482b-aa43-42563f9eaf03', 6, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('5b01a9c6-e8c8-45c6-8a49-15d1c59e4a21', 9, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('047247c4-f942-4c05-bc3a-e410a248dfee', 11, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('3672d392-2e00-4f6b-a880-d4deae7821be', 13, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('7f7b46bd-a8bc-4d4f-8a75-b4afecdb8432', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('58f60a15-5f2f-4d3d-a670-adbc69a3618d', 17, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('28e81b62-c7c1-49fc-a6f6-21baaadf7fe7', 20, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('7b8ee3d7-2e07-4a39-842b-edd419b23716', 21, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('e1ad68cc-1489-41cb-be4b-a47904e44097', 24, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('a93e6fe4-0cdd-4bbe-9080-1dc0e04e04a8', 26, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('e10577cc-7a43-458a-b9e7-1dbdb09bea62', 28, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('01a9b824-f579-4b50-8c69-b1e612e586d6', 30, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('a6f23343-043a-4f7c-a56c-14a089e60cdd', 32, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'fc9dc852-5a13-482b-aa43-42563f9eaf03', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b01a9c6-e8c8-45c6-8a49-15d1c59e4a21', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '047247c4-f942-4c05-bc3a-e410a248dfee', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3672d392-2e00-4f6b-a880-d4deae7821be', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7f7b46bd-a8bc-4d4f-8a75-b4afecdb8432', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '58f60a15-5f2f-4d3d-a670-adbc69a3618d', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '28e81b62-c7c1-49fc-a6f6-21baaadf7fe7', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7b8ee3d7-2e07-4a39-842b-edd419b23716', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1ad68cc-1489-41cb-be4b-a47904e44097', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a93e6fe4-0cdd-4bbe-9080-1dc0e04e04a8', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e10577cc-7a43-458a-b9e7-1dbdb09bea62', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '01a9b824-f579-4b50-8c69-b1e612e586d6', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a6f23343-043a-4f7c-a56c-14a089e60cdd', '29f4ffde-281e-402b-be8a-1621e03504c0');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'fc9dc852-5a13-482b-aa43-42563f9eaf03', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b01a9c6-e8c8-45c6-8a49-15d1c59e4a21', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '047247c4-f942-4c05-bc3a-e410a248dfee', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3672d392-2e00-4f6b-a880-d4deae7821be', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7f7b46bd-a8bc-4d4f-8a75-b4afecdb8432', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '58f60a15-5f2f-4d3d-a670-adbc69a3618d', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '28e81b62-c7c1-49fc-a6f6-21baaadf7fe7', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7b8ee3d7-2e07-4a39-842b-edd419b23716', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1ad68cc-1489-41cb-be4b-a47904e44097', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a93e6fe4-0cdd-4bbe-9080-1dc0e04e04a8', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e10577cc-7a43-458a-b9e7-1dbdb09bea62', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '01a9b824-f579-4b50-8c69-b1e612e586d6', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a6f23343-043a-4f7c-a56c-14a089e60cdd', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 2400
INSERT INTO gosha.const_table_values VALUES ('e43167af-cd28-4f0f-9bec-3cf77fa567ab', 6, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('0ddc50df-9f9d-48f3-a1ce-88f77a4499f1', 9, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('8fa79274-989f-4d88-8c84-690908c31f73', 12, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('f980b166-be17-4802-b860-961d1f497d15', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('fe2a91a1-2e6c-4773-87f6-246c0f361f84', 15, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('f236eba5-8eac-4f5e-b27e-f5b8f7cb516d', 18, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('9073c1ac-bd57-42a3-8aea-640e96c12b7a', 21, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('5a36fdd9-427e-4f69-8d99-8322fd10e9ae', 22, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('3331a819-8f16-456e-a2f8-ea2fc0d02134', 25, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('a5445750-c658-44c7-8488-0dd23ac92cf6', 27, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('ab1c86ca-f1c1-4acf-88c5-d4ccd909f6aa', 29, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('729dfa65-7985-4e14-8c6b-7b4059b2ff27', 32, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('12fbcbbe-f55b-40b7-a129-2f1787b58f9d', 36, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e43167af-cd28-4f0f-9bec-3cf77fa567ab', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0ddc50df-9f9d-48f3-a1ce-88f77a4499f1', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8fa79274-989f-4d88-8c84-690908c31f73', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f980b166-be17-4802-b860-961d1f497d15', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'fe2a91a1-2e6c-4773-87f6-246c0f361f84', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f236eba5-8eac-4f5e-b27e-f5b8f7cb516d', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9073c1ac-bd57-42a3-8aea-640e96c12b7a', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5a36fdd9-427e-4f69-8d99-8322fd10e9ae', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3331a819-8f16-456e-a2f8-ea2fc0d02134', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a5445750-c658-44c7-8488-0dd23ac92cf6', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ab1c86ca-f1c1-4acf-88c5-d4ccd909f6aa', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '729dfa65-7985-4e14-8c6b-7b4059b2ff27', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '12fbcbbe-f55b-40b7-a129-2f1787b58f9d', 'bf109d15-5e82-4363-9484-9b0f67141e3d');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e43167af-cd28-4f0f-9bec-3cf77fa567ab', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0ddc50df-9f9d-48f3-a1ce-88f77a4499f1', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8fa79274-989f-4d88-8c84-690908c31f73', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f980b166-be17-4802-b860-961d1f497d15', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'fe2a91a1-2e6c-4773-87f6-246c0f361f84', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f236eba5-8eac-4f5e-b27e-f5b8f7cb516d', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9073c1ac-bd57-42a3-8aea-640e96c12b7a', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5a36fdd9-427e-4f69-8d99-8322fd10e9ae', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3331a819-8f16-456e-a2f8-ea2fc0d02134', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a5445750-c658-44c7-8488-0dd23ac92cf6', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ab1c86ca-f1c1-4acf-88c5-d4ccd909f6aa', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '729dfa65-7985-4e14-8c6b-7b4059b2ff27', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '12fbcbbe-f55b-40b7-a129-2f1787b58f9d', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 3000
INSERT INTO gosha.const_table_values VALUES ('af57b876-a499-4777-aaee-9a66f7787237', 6, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('d40abe13-65e4-4b39-8acc-b72dd8c25b88', 9, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('9b4c2d73-23af-41f6-8cec-b4ebab5abf73', 12, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('1839e5bc-d0f0-4a4e-bb69-0ec7a14fed77', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('5423e2c9-d6ce-4482-8bcd-853cd2a9e9e4', 15, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('256a9087-a818-4896-b49d-2f98726a83a4', 18, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('ce7211a1-2498-4db0-be64-8a1a499a7eca', 21, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('7c4e0ef6-8998-4c5a-a828-fe4351ebca7e', 23, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('f351bccf-1d98-42f1-a535-6c4493dbe982', 25, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('b11ecf01-b85b-45bf-9c17-e77945024b65', 28, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('29be4b5a-6edc-4429-a810-397363decf7d', 30, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('1d73d000-7480-48ef-8d00-30bfb8d253f6', 32, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('2e365732-c690-49b0-9feb-1eee75d2a510', 36, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'af57b876-a499-4777-aaee-9a66f7787237', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd40abe13-65e4-4b39-8acc-b72dd8c25b88', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9b4c2d73-23af-41f6-8cec-b4ebab5abf73', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1839e5bc-d0f0-4a4e-bb69-0ec7a14fed77', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5423e2c9-d6ce-4482-8bcd-853cd2a9e9e4', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '256a9087-a818-4896-b49d-2f98726a83a4', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ce7211a1-2498-4db0-be64-8a1a499a7eca', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7c4e0ef6-8998-4c5a-a828-fe4351ebca7e', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f351bccf-1d98-42f1-a535-6c4493dbe982', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b11ecf01-b85b-45bf-9c17-e77945024b65', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '29be4b5a-6edc-4429-a810-397363decf7d', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1d73d000-7480-48ef-8d00-30bfb8d253f6', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2e365732-c690-49b0-9feb-1eee75d2a510', '6f95200d-31a2-4f01-be6b-f8e344a2e402');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'af57b876-a499-4777-aaee-9a66f7787237', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd40abe13-65e4-4b39-8acc-b72dd8c25b88', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9b4c2d73-23af-41f6-8cec-b4ebab5abf73', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1839e5bc-d0f0-4a4e-bb69-0ec7a14fed77', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5423e2c9-d6ce-4482-8bcd-853cd2a9e9e4', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '256a9087-a818-4896-b49d-2f98726a83a4', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ce7211a1-2498-4db0-be64-8a1a499a7eca', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7c4e0ef6-8998-4c5a-a828-fe4351ebca7e', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f351bccf-1d98-42f1-a535-6c4493dbe982', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b11ecf01-b85b-45bf-9c17-e77945024b65', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '29be4b5a-6edc-4429-a810-397363decf7d', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1d73d000-7480-48ef-8d00-30bfb8d253f6', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2e365732-c690-49b0-9feb-1eee75d2a510', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 4000
INSERT INTO gosha.const_table_values VALUES ('38a47f64-a9a5-4960-b859-14af3bfce819', 6, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('51aa6b58-79fc-444d-845c-71ba0578d8a7', 10, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('0d1c8e9b-76e8-44ab-9bdb-8321ff3d5eda', 12, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('8e5439f4-98c7-40cb-b8d6-fb6a02b95583', 14, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('e16e9fe2-61bc-439d-9a67-a2308bc32cb3', 16, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('42f8aa1f-35e3-4801-9ccd-0b59111fd98e', 19, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('69b60069-0762-408c-98ae-2a01510d8a4c', 22, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('54a40b09-4822-48eb-b507-6ff28c0e5ad3', 24, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('db144f85-4029-445d-987d-d56e4bdff556', 26, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('d7239d37-29ec-4ced-8e74-b32d93a43f61', 29, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('ac184a81-5dea-44e8-b5f3-134fc81348e2', 32, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('9ab83356-abbd-40ce-9356-ed413cae4bbd', 34, 'b6669f4e-6811-4920-a57a-14318d7ba664');
INSERT INTO gosha.const_table_values VALUES ('565d73ef-03d2-4298-a035-cfaa08d80004', 36, 'b6669f4e-6811-4920-a57a-14318d7ba664');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '38a47f64-a9a5-4960-b859-14af3bfce819', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '51aa6b58-79fc-444d-845c-71ba0578d8a7', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0d1c8e9b-76e8-44ab-9bdb-8321ff3d5eda', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8e5439f4-98c7-40cb-b8d6-fb6a02b95583', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e16e9fe2-61bc-439d-9a67-a2308bc32cb3', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '42f8aa1f-35e3-4801-9ccd-0b59111fd98e', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '69b60069-0762-408c-98ae-2a01510d8a4c', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54a40b09-4822-48eb-b507-6ff28c0e5ad3', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'db144f85-4029-445d-987d-d56e4bdff556', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd7239d37-29ec-4ced-8e74-b32d93a43f61', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ac184a81-5dea-44e8-b5f3-134fc81348e2', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ab83356-abbd-40ce-9356-ed413cae4bbd', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '565d73ef-03d2-4298-a035-cfaa08d80004', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '38a47f64-a9a5-4960-b859-14af3bfce819', '46322079-b68d-4b07-abce-98fa42cc8fca');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '51aa6b58-79fc-444d-845c-71ba0578d8a7', '555f8a00-0039-46a9-aa43-f86468551d8f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0d1c8e9b-76e8-44ab-9bdb-8321ff3d5eda', '217a9ae1-890c-49a8-8fde-31ccd828cfb8');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8e5439f4-98c7-40cb-b8d6-fb6a02b95583', '80ff3e50-e752-4338-b07d-9754cd020ddf');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e16e9fe2-61bc-439d-9a67-a2308bc32cb3', '5c7d8858-b120-4ef0-91ce-fe7b1d93bcc9');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '42f8aa1f-35e3-4801-9ccd-0b59111fd98e', 'c8c31e45-a217-4d64-94b0-3e823abea28e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '69b60069-0762-408c-98ae-2a01510d8a4c', 'f667b401-1cfb-4529-8e9e-f938f87e58ed');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54a40b09-4822-48eb-b507-6ff28c0e5ad3', '9b71c896-efda-45ec-a06a-5fbc3afe2644');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'db144f85-4029-445d-987d-d56e4bdff556', '48fe940a-7eb4-4e76-8f0a-dd65a8909f4c');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd7239d37-29ec-4ced-8e74-b32d93a43f61', '0e988140-5fb7-469c-9734-8da9838ed3e7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ac184a81-5dea-44e8-b5f3-134fc81348e2', 'e7112b1c-5a21-46f8-afca-1baa583856d7');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ab83356-abbd-40ce-9356-ed413cae4bbd', 'd0473e8e-1a7b-4817-9847-d3e5a745f498');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '565d73ef-03d2-4298-a035-cfaa08d80004', '0acfe29a-4b57-47f2-a093-dd0b00461cf8');


-- 1

-- Values
INSERT INTO gosha.const_table_values VALUES ('acbc1717-5ce0-4116-8488-9b89e5af05e0', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('b987d59e-f1b2-45c9-80b9-83f8b02a4228', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('bc857fe2-caff-4109-8329-c1b8d4a58500', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('776cd1db-8d97-4dea-bf0e-3bca078a733c', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('2e04890d-76ce-4ef1-9c91-318f2f36375e', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f12c6b2e-f00c-48da-a344-499f8b7f806f', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('74e29e83-d0f3-4f5c-aa3c-29a2bac9b6bc', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a716f63a-f0bd-487a-abf2-0e2b7e14a756', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('b72ab03a-9e12-4865-8069-68d88304b26b', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('949746b7-572a-4358-aaa3-ee80bb554774', -8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a42222d0-7392-488c-8e77-069514555a94', -8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('2a470cf7-800b-4637-9e94-23374f1c4a36', -9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5b8d3de6-f542-48ab-b3a3-ed9bb20cb2fd', -20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('08265d64-3c90-4c23-8323-9a8787c90a13', -29, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('bef63580-e913-40b4-b073-d8d6cfc472c3', -39, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('1a40c700-1563-43d4-960a-bb8939005b28', -49, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('0535f0ed-663b-48c8-9374-1bf3eb8c316f', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('742a921c-f53d-4270-8d76-46d20a01d00d', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('50b25bb3-8fab-4f50-b071-a0349d8bab80', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('71c283b0-2768-44c3-9c55-3723b3a4a02f', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ff2d7504-e018-486e-a390-113925ba731a', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9c833aef-587c-49c1-ac9e-791270fd4366', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('321695a3-b032-4232-951e-e322f1601546', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a663f31f-9eb1-43f6-9615-8a90d8846cc9', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('3740e173-3efe-4e93-a2cd-e6ab179bb138', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('bb832c3c-96d2-4d7f-adc4-1bd258c7ae24', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6d47c6f5-5b17-43bc-8e60-6ec01d6b15b4', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f74c768d-89fc-453e-b709-99792f3ca810', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'acbc1717-5ce0-4116-8488-9b89e5af05e0', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b987d59e-f1b2-45c9-80b9-83f8b02a4228', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bc857fe2-caff-4109-8329-c1b8d4a58500', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '776cd1db-8d97-4dea-bf0e-3bca078a733c', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2e04890d-76ce-4ef1-9c91-318f2f36375e', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f12c6b2e-f00c-48da-a344-499f8b7f806f', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '74e29e83-d0f3-4f5c-aa3c-29a2bac9b6bc', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a716f63a-f0bd-487a-abf2-0e2b7e14a756', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b72ab03a-9e12-4865-8069-68d88304b26b', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '949746b7-572a-4358-aaa3-ee80bb554774', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a42222d0-7392-488c-8e77-069514555a94', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2a470cf7-800b-4637-9e94-23374f1c4a36', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b8d3de6-f542-48ab-b3a3-ed9bb20cb2fd', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '08265d64-3c90-4c23-8323-9a8787c90a13', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bef63580-e913-40b4-b073-d8d6cfc472c3', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1a40c700-1563-43d4-960a-bb8939005b28', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0535f0ed-663b-48c8-9374-1bf3eb8c316f', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '742a921c-f53d-4270-8d76-46d20a01d00d', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '50b25bb3-8fab-4f50-b071-a0349d8bab80', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '71c283b0-2768-44c3-9c55-3723b3a4a02f', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ff2d7504-e018-486e-a390-113925ba731a', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c833aef-587c-49c1-ac9e-791270fd4366', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '321695a3-b032-4232-951e-e322f1601546', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a663f31f-9eb1-43f6-9615-8a90d8846cc9', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3740e173-3efe-4e93-a2cd-e6ab179bb138', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bb832c3c-96d2-4d7f-adc4-1bd258c7ae24', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6d47c6f5-5b17-43bc-8e60-6ec01d6b15b4', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f74c768d-89fc-453e-b709-99792f3ca810', 'fa3df7e9-c4cc-4a84-89d3-0a6307f75e3b');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'acbc1717-5ce0-4116-8488-9b89e5af05e0', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b987d59e-f1b2-45c9-80b9-83f8b02a4228', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bc857fe2-caff-4109-8329-c1b8d4a58500', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '776cd1db-8d97-4dea-bf0e-3bca078a733c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2e04890d-76ce-4ef1-9c91-318f2f36375e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f12c6b2e-f00c-48da-a344-499f8b7f806f', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '74e29e83-d0f3-4f5c-aa3c-29a2bac9b6bc', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a716f63a-f0bd-487a-abf2-0e2b7e14a756', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b72ab03a-9e12-4865-8069-68d88304b26b', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '949746b7-572a-4358-aaa3-ee80bb554774', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a42222d0-7392-488c-8e77-069514555a94', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2a470cf7-800b-4637-9e94-23374f1c4a36', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b8d3de6-f542-48ab-b3a3-ed9bb20cb2fd', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '08265d64-3c90-4c23-8323-9a8787c90a13', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bef63580-e913-40b4-b073-d8d6cfc472c3', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1a40c700-1563-43d4-960a-bb8939005b28', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0535f0ed-663b-48c8-9374-1bf3eb8c316f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '742a921c-f53d-4270-8d76-46d20a01d00d', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '50b25bb3-8fab-4f50-b071-a0349d8bab80', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '71c283b0-2768-44c3-9c55-3723b3a4a02f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ff2d7504-e018-486e-a390-113925ba731a', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c833aef-587c-49c1-ac9e-791270fd4366', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '321695a3-b032-4232-951e-e322f1601546', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a663f31f-9eb1-43f6-9615-8a90d8846cc9', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3740e173-3efe-4e93-a2cd-e6ab179bb138', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bb832c3c-96d2-4d7f-adc4-1bd258c7ae24', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6d47c6f5-5b17-43bc-8e60-6ec01d6b15b4', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f74c768d-89fc-453e-b709-99792f3ca810', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'acbc1717-5ce0-4116-8488-9b89e5af05e0', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b987d59e-f1b2-45c9-80b9-83f8b02a4228', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bc857fe2-caff-4109-8329-c1b8d4a58500', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '776cd1db-8d97-4dea-bf0e-3bca078a733c', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2e04890d-76ce-4ef1-9c91-318f2f36375e', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f12c6b2e-f00c-48da-a344-499f8b7f806f', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '74e29e83-d0f3-4f5c-aa3c-29a2bac9b6bc', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a716f63a-f0bd-487a-abf2-0e2b7e14a756', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b72ab03a-9e12-4865-8069-68d88304b26b', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '949746b7-572a-4358-aaa3-ee80bb554774', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a42222d0-7392-488c-8e77-069514555a94', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2a470cf7-800b-4637-9e94-23374f1c4a36', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5b8d3de6-f542-48ab-b3a3-ed9bb20cb2fd', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '08265d64-3c90-4c23-8323-9a8787c90a13', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bef63580-e913-40b4-b073-d8d6cfc472c3', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1a40c700-1563-43d4-960a-bb8939005b28', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0535f0ed-663b-48c8-9374-1bf3eb8c316f', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '742a921c-f53d-4270-8d76-46d20a01d00d', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '50b25bb3-8fab-4f50-b071-a0349d8bab80', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '71c283b0-2768-44c3-9c55-3723b3a4a02f', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ff2d7504-e018-486e-a390-113925ba731a', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c833aef-587c-49c1-ac9e-791270fd4366', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '321695a3-b032-4232-951e-e322f1601546', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a663f31f-9eb1-43f6-9615-8a90d8846cc9', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3740e173-3efe-4e93-a2cd-e6ab179bb138', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bb832c3c-96d2-4d7f-adc4-1bd258c7ae24', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6d47c6f5-5b17-43bc-8e60-6ec01d6b15b4', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f74c768d-89fc-453e-b709-99792f3ca810', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');





-- 2

-- Values
INSERT INTO gosha.const_table_values VALUES ('76d8c0dd-4535-40ec-882a-3bd6f54322d6', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('afe2cdf5-f23b-484e-a937-56c5bd6ac879', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('e8ca64dd-b60f-4e3a-adf2-dbbc2b70fc9c', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9a179a62-3f50-4cbe-aaeb-5279bf9d4f0c', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e2a7af18-346c-4fbc-b96d-65b6db10d17e', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('1b061c53-fa5b-4549-9bfd-00787d1f6012', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('40dd5d34-492b-4ea8-99e3-c6c8e392a095', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('786e1eaf-9e49-4960-9178-c1b66336edb0', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('586e3bfb-3e34-4a17-8fbb-c8b813485df9', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('994b029b-4071-43e3-8194-e81ac9f940b1', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5d001045-e075-4d95-a0a2-ac75073df64e', -8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('96e61249-9fae-4177-9c8b-cc8bfbb28666', -9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('707aaf01-61d2-4eaf-ae41-030568f82ec0', -19, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('03ecd8e6-d029-4f8d-9356-0bae3a1758f5', -29, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('36a02de1-890a-4843-b901-99a7cd8b1862', -38, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('8aef3d6a-8a7b-4f97-bc9f-2920b63b2bac', -48, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('6794b615-5a35-4ff1-9f5c-250af79b0ea9', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('2b788816-a692-4e2e-9f5d-95aa67d0666b', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c4ff3880-a803-450f-95a8-be33d0a4203e', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('99e4fa81-386f-46b2-a33d-5c377a16ae80', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('264a6440-dbe7-43e8-838c-602390141b7b', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('4ec0e481-5a06-4023-96cf-a4ed04dd4f81', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f3a455e1-26b5-4573-bfba-3b69867a57a3', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('4095803d-a9e7-4645-9f8e-1df86235183f', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('388d063b-8f83-4b11-a180-f50b46005215', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('cb8ec0bd-83cc-4927-a3c0-c45ba36f2438', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('55e2c1e7-486b-4016-ad9d-26a9db0f2afd', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('72820c07-c8e5-4a24-bb07-71700beb26ab', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '76d8c0dd-4535-40ec-882a-3bd6f54322d6', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'afe2cdf5-f23b-484e-a937-56c5bd6ac879', '19f254bd-f737-4661-b037-faaddb2df77e');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e8ca64dd-b60f-4e3a-adf2-dbbc2b70fc9c', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a179a62-3f50-4cbe-aaeb-5279bf9d4f0c', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e2a7af18-346c-4fbc-b96d-65b6db10d17e', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1b061c53-fa5b-4549-9bfd-00787d1f6012', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '40dd5d34-492b-4ea8-99e3-c6c8e392a095', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '786e1eaf-9e49-4960-9178-c1b66336edb0', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '586e3bfb-3e34-4a17-8fbb-c8b813485df9', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '994b029b-4071-43e3-8194-e81ac9f940b1', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d001045-e075-4d95-a0a2-ac75073df64e', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '96e61249-9fae-4177-9c8b-cc8bfbb28666', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '707aaf01-61d2-4eaf-ae41-030568f82ec0', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '03ecd8e6-d029-4f8d-9356-0bae3a1758f5', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '36a02de1-890a-4843-b901-99a7cd8b1862', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8aef3d6a-8a7b-4f97-bc9f-2920b63b2bac', '19f254bd-f737-4661-b037-faaddb2df77e');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6794b615-5a35-4ff1-9f5c-250af79b0ea9', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a179a62-3f50-4cbe-aaeb-5279bf9d4f0c', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c4ff3880-a803-450f-95a8-be33d0a4203e', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '99e4fa81-386f-46b2-a33d-5c377a16ae80', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '264a6440-dbe7-43e8-838c-602390141b7b', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4ec0e481-5a06-4023-96cf-a4ed04dd4f81', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f3a455e1-26b5-4573-bfba-3b69867a57a3', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4095803d-a9e7-4645-9f8e-1df86235183f', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '388d063b-8f83-4b11-a180-f50b46005215', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'cb8ec0bd-83cc-4927-a3c0-c45ba36f2438', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '55e2c1e7-486b-4016-ad9d-26a9db0f2afd', '19f254bd-f737-4661-b037-faaddb2df77e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '72820c07-c8e5-4a24-bb07-71700beb26ab', '19f254bd-f737-4661-b037-faaddb2df77e');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '76d8c0dd-4535-40ec-882a-3bd6f54322d6', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'afe2cdf5-f23b-484e-a937-56c5bd6ac879', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e8ca64dd-b60f-4e3a-adf2-dbbc2b70fc9c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a179a62-3f50-4cbe-aaeb-5279bf9d4f0c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e2a7af18-346c-4fbc-b96d-65b6db10d17e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1b061c53-fa5b-4549-9bfd-00787d1f6012', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '40dd5d34-492b-4ea8-99e3-c6c8e392a095', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '786e1eaf-9e49-4960-9178-c1b66336edb0', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '586e3bfb-3e34-4a17-8fbb-c8b813485df9', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '994b029b-4071-43e3-8194-e81ac9f940b1', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d001045-e075-4d95-a0a2-ac75073df64e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '96e61249-9fae-4177-9c8b-cc8bfbb28666', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '707aaf01-61d2-4eaf-ae41-030568f82ec0', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '03ecd8e6-d029-4f8d-9356-0bae3a1758f5', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '36a02de1-890a-4843-b901-99a7cd8b1862', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8aef3d6a-8a7b-4f97-bc9f-2920b63b2bac', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6794b615-5a35-4ff1-9f5c-250af79b0ea9', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2b788816-a692-4e2e-9f5d-95aa67d0666b', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c4ff3880-a803-450f-95a8-be33d0a4203e', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '99e4fa81-386f-46b2-a33d-5c377a16ae80', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '264a6440-dbe7-43e8-838c-602390141b7b', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4ec0e481-5a06-4023-96cf-a4ed04dd4f81', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f3a455e1-26b5-4573-bfba-3b69867a57a3', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4095803d-a9e7-4645-9f8e-1df86235183f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '388d063b-8f83-4b11-a180-f50b46005215', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'cb8ec0bd-83cc-4927-a3c0-c45ba36f2438', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '55e2c1e7-486b-4016-ad9d-26a9db0f2afd', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '72820c07-c8e5-4a24-bb07-71700beb26ab', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '76d8c0dd-4535-40ec-882a-3bd6f54322d6', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'afe2cdf5-f23b-484e-a937-56c5bd6ac879', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e8ca64dd-b60f-4e3a-adf2-dbbc2b70fc9c', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a179a62-3f50-4cbe-aaeb-5279bf9d4f0c', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e2a7af18-346c-4fbc-b96d-65b6db10d17e', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1b061c53-fa5b-4549-9bfd-00787d1f6012', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '40dd5d34-492b-4ea8-99e3-c6c8e392a095', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '786e1eaf-9e49-4960-9178-c1b66336edb0', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '586e3bfb-3e34-4a17-8fbb-c8b813485df9', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '994b029b-4071-43e3-8194-e81ac9f940b1', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d001045-e075-4d95-a0a2-ac75073df64e', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '96e61249-9fae-4177-9c8b-cc8bfbb28666', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '707aaf01-61d2-4eaf-ae41-030568f82ec0', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '03ecd8e6-d029-4f8d-9356-0bae3a1758f5', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '36a02de1-890a-4843-b901-99a7cd8b1862', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8aef3d6a-8a7b-4f97-bc9f-2920b63b2bac', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6794b615-5a35-4ff1-9f5c-250af79b0ea9', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2b788816-a692-4e2e-9f5d-95aa67d0666b', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c4ff3880-a803-450f-95a8-be33d0a4203e', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '99e4fa81-386f-46b2-a33d-5c377a16ae80', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '264a6440-dbe7-43e8-838c-602390141b7b', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4ec0e481-5a06-4023-96cf-a4ed04dd4f81', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f3a455e1-26b5-4573-bfba-3b69867a57a3', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4095803d-a9e7-4645-9f8e-1df86235183f', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '388d063b-8f83-4b11-a180-f50b46005215', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'cb8ec0bd-83cc-4927-a3c0-c45ba36f2438', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '55e2c1e7-486b-4016-ad9d-26a9db0f2afd', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '72820c07-c8e5-4a24-bb07-71700beb26ab', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 3

-- Values
INSERT INTO gosha.const_table_values VALUES ('edf58656-3f50-48a7-a247-ee8894fa0c08', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('27d494eb-02ac-4126-b64c-7fa4556ca6cb', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('16a9ad9a-2138-45cb-9cb1-3d90384c5c45', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f2d11df3-e532-42c2-ae0a-4e8304531f36', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f8bbb15d-5902-45d2-8ed2-f6283e7e23bc', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('39017e29-6340-44a7-a01c-38993be337e1', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('0130271b-e964-4c7e-b387-039e93f70c73', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('975072dd-be8b-4f9e-8b6d-a4ce08bf35fc', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6860cd4a-3ec7-4469-a5cd-165eabef6d54', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f00124e2-42d3-481f-98a6-eefc1bc91fb8', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('b223f8dc-a4a6-4fbd-ae2e-d707500bd033', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c2296aa7-9e28-4325-836d-a707b3eb06cf', -8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('7517cb4d-929a-463a-96f6-1a4e020ce32d', -18, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5226d403-7737-482a-830a-3e357103cdbc', -28, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a8e55142-706a-4e10-8e1a-8a622fe043d9', -37, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('abc057f9-d231-4093-8058-453d758c71f6', -46, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('63ea631d-4b73-44c4-b3ea-1a321394c5c4', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('59b98434-65a9-4354-9d3f-89181a136ada', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('938e9561-bcac-456c-9d73-26188423064d', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9a58aab5-0bde-4a5c-8462-ec7b7711f4e0', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('859a4ef2-33b3-481d-a631-5615725e0611', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6720fc28-4df4-4372-9372-5ca33c224968', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9ed56990-55e7-447f-88e9-db0ed571f5a1', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6fe90042-f655-4762-aaf5-24018f936c24', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a53f0cf1-11fd-4557-8d08-69f79f658fec', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('28eab3ef-cd6e-4eb2-a817-f2b1c2e3c3f5', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e1103bcc-b5f6-4547-894f-730d30d4f650', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('74d23a69-e8f5-4ca2-bf30-2e9894e49365', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'edf58656-3f50-48a7-a247-ee8894fa0c08', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '27d494eb-02ac-4126-b64c-7fa4556ca6cb', '9c248174-82cf-485f-a14b-d496c1e6bad3');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '16a9ad9a-2138-45cb-9cb1-3d90384c5c45', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2d11df3-e532-42c2-ae0a-4e8304531f36', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f8bbb15d-5902-45d2-8ed2-f6283e7e23bc', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '39017e29-6340-44a7-a01c-38993be337e1', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0130271b-e964-4c7e-b387-039e93f70c73', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '975072dd-be8b-4f9e-8b6d-a4ce08bf35fc', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6860cd4a-3ec7-4469-a5cd-165eabef6d54', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f00124e2-42d3-481f-98a6-eefc1bc91fb8', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b223f8dc-a4a6-4fbd-ae2e-d707500bd033', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2296aa7-9e28-4325-836d-a707b3eb06cf', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7517cb4d-929a-463a-96f6-1a4e020ce32d', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5226d403-7737-482a-830a-3e357103cdbc', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a8e55142-706a-4e10-8e1a-8a622fe043d9', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'abc057f9-d231-4093-8058-453d758c71f6', '9c248174-82cf-485f-a14b-d496c1e6bad3');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '63ea631d-4b73-44c4-b3ea-1a321394c5c4', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2d11df3-e532-42c2-ae0a-4e8304531f36', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '938e9561-bcac-456c-9d73-26188423064d', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a58aab5-0bde-4a5c-8462-ec7b7711f4e0', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '859a4ef2-33b3-481d-a631-5615725e0611', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6720fc28-4df4-4372-9372-5ca33c224968', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ed56990-55e7-447f-88e9-db0ed571f5a1', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6fe90042-f655-4762-aaf5-24018f936c24', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a53f0cf1-11fd-4557-8d08-69f79f658fec', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '28eab3ef-cd6e-4eb2-a817-f2b1c2e3c3f5', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1103bcc-b5f6-4547-894f-730d30d4f650', '9c248174-82cf-485f-a14b-d496c1e6bad3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '74d23a69-e8f5-4ca2-bf30-2e9894e49365', '9c248174-82cf-485f-a14b-d496c1e6bad3');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'edf58656-3f50-48a7-a247-ee8894fa0c08', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '27d494eb-02ac-4126-b64c-7fa4556ca6cb', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '16a9ad9a-2138-45cb-9cb1-3d90384c5c45', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2d11df3-e532-42c2-ae0a-4e8304531f36', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f8bbb15d-5902-45d2-8ed2-f6283e7e23bc', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '39017e29-6340-44a7-a01c-38993be337e1', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0130271b-e964-4c7e-b387-039e93f70c73', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '975072dd-be8b-4f9e-8b6d-a4ce08bf35fc', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6860cd4a-3ec7-4469-a5cd-165eabef6d54', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f00124e2-42d3-481f-98a6-eefc1bc91fb8', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b223f8dc-a4a6-4fbd-ae2e-d707500bd033', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2296aa7-9e28-4325-836d-a707b3eb06cf', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7517cb4d-929a-463a-96f6-1a4e020ce32d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5226d403-7737-482a-830a-3e357103cdbc', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a8e55142-706a-4e10-8e1a-8a622fe043d9', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'abc057f9-d231-4093-8058-453d758c71f6', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '63ea631d-4b73-44c4-b3ea-1a321394c5c4', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '59b98434-65a9-4354-9d3f-89181a136ada', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '938e9561-bcac-456c-9d73-26188423064d', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a58aab5-0bde-4a5c-8462-ec7b7711f4e0', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '859a4ef2-33b3-481d-a631-5615725e0611', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6720fc28-4df4-4372-9372-5ca33c224968', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ed56990-55e7-447f-88e9-db0ed571f5a1', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6fe90042-f655-4762-aaf5-24018f936c24', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a53f0cf1-11fd-4557-8d08-69f79f658fec', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '28eab3ef-cd6e-4eb2-a817-f2b1c2e3c3f5', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1103bcc-b5f6-4547-894f-730d30d4f650', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '74d23a69-e8f5-4ca2-bf30-2e9894e49365', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'edf58656-3f50-48a7-a247-ee8894fa0c08', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '27d494eb-02ac-4126-b64c-7fa4556ca6cb', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '16a9ad9a-2138-45cb-9cb1-3d90384c5c45', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2d11df3-e532-42c2-ae0a-4e8304531f36', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f8bbb15d-5902-45d2-8ed2-f6283e7e23bc', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '39017e29-6340-44a7-a01c-38993be337e1', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0130271b-e964-4c7e-b387-039e93f70c73', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '975072dd-be8b-4f9e-8b6d-a4ce08bf35fc', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6860cd4a-3ec7-4469-a5cd-165eabef6d54', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f00124e2-42d3-481f-98a6-eefc1bc91fb8', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b223f8dc-a4a6-4fbd-ae2e-d707500bd033', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2296aa7-9e28-4325-836d-a707b3eb06cf', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7517cb4d-929a-463a-96f6-1a4e020ce32d', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5226d403-7737-482a-830a-3e357103cdbc', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a8e55142-706a-4e10-8e1a-8a622fe043d9', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'abc057f9-d231-4093-8058-453d758c71f6', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '63ea631d-4b73-44c4-b3ea-1a321394c5c4', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '59b98434-65a9-4354-9d3f-89181a136ada', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '938e9561-bcac-456c-9d73-26188423064d', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9a58aab5-0bde-4a5c-8462-ec7b7711f4e0', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '859a4ef2-33b3-481d-a631-5615725e0611', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6720fc28-4df4-4372-9372-5ca33c224968', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ed56990-55e7-447f-88e9-db0ed571f5a1', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6fe90042-f655-4762-aaf5-24018f936c24', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a53f0cf1-11fd-4557-8d08-69f79f658fec', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '28eab3ef-cd6e-4eb2-a817-f2b1c2e3c3f5', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1103bcc-b5f6-4547-894f-730d30d4f650', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '74d23a69-e8f5-4ca2-bf30-2e9894e49365', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 4

-- Values
INSERT INTO gosha.const_table_values VALUES ('7d58f7df-607e-4aef-96f9-7943fec39888', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5315d2da-6a5d-4bee-acce-e1e6cbf2d5e2', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('bf89787c-3a1d-4d92-b25d-8f011048f24c', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c2566efe-f4f8-4c91-800a-37d447e8ea4e', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('177aff06-809e-4bf7-a6c6-e52b1c4fb347', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('37201c1e-6994-47e3-b3b5-8a1735dcee2e', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a266a805-5e0f-4ff9-bcc0-261c38a2d4ea', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('d5ceb45d-c3ab-4976-941f-1687f8740734', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('bebb2053-f707-4f43-bf14-2ac35fd14b56', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('234c92de-7d50-49b3-ab7b-6ca99eef6944', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('874976e9-2adc-4fc6-afb6-2decedd0b545', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e110a7e2-7dff-4d02-ad0d-8a7640c21494', -8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c626376a-7894-467d-aa05-48789e15eab9', -17, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('8cdf01e7-855d-4369-b4d2-760092121978', -26, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('2bda5eba-2544-43f2-8cb0-235e1fb3aec0', -35, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('8851dd90-78f9-4270-a43b-7e63baef7854', -44, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('41a43bec-0ff8-461b-a0cb-b0f149fa13f3', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('d1cbbcd0-10bb-4bc3-81da-07c92d071156', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ccfec039-d222-40d2-b9d5-3f515db9fa76', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ef967ad2-2161-4182-b561-f68b3e43cdf2', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c586e4e0-3245-4337-85a6-7f8755298f53', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('486145f2-6be6-4967-9e4a-0831f6f174e0', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('26e490a6-6fac-4ce6-b822-332f05a21950', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('092fe1a4-0373-4752-867b-7db5f34392c8', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ed81fc8d-697f-4adb-ae74-9ae39533bd41', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a40260fe-7ddd-4d85-9850-8f9ae7eca040', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('03a90d69-2eae-4b4c-b7d6-4b029fdd2356', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6daf1bf7-1456-4abc-834f-42af684b051f', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7d58f7df-607e-4aef-96f9-7943fec39888', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5315d2da-6a5d-4bee-acce-e1e6cbf2d5e2', 'ae8de529-4081-436b-8944-420028fa3cf4');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bf89787c-3a1d-4d92-b25d-8f011048f24c', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2566efe-f4f8-4c91-800a-37d447e8ea4e', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '177aff06-809e-4bf7-a6c6-e52b1c4fb347', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37201c1e-6994-47e3-b3b5-8a1735dcee2e', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a266a805-5e0f-4ff9-bcc0-261c38a2d4ea', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd5ceb45d-c3ab-4976-941f-1687f8740734', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bebb2053-f707-4f43-bf14-2ac35fd14b56', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '234c92de-7d50-49b3-ab7b-6ca99eef6944', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '874976e9-2adc-4fc6-afb6-2decedd0b545', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e110a7e2-7dff-4d02-ad0d-8a7640c21494', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c626376a-7894-467d-aa05-48789e15eab9', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8cdf01e7-855d-4369-b4d2-760092121978', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2bda5eba-2544-43f2-8cb0-235e1fb3aec0', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8851dd90-78f9-4270-a43b-7e63baef7854', 'ae8de529-4081-436b-8944-420028fa3cf4');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '41a43bec-0ff8-461b-a0cb-b0f149fa13f3', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2566efe-f4f8-4c91-800a-37d447e8ea4e', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ccfec039-d222-40d2-b9d5-3f515db9fa76', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ef967ad2-2161-4182-b561-f68b3e43cdf2', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c586e4e0-3245-4337-85a6-7f8755298f53', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '486145f2-6be6-4967-9e4a-0831f6f174e0', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '26e490a6-6fac-4ce6-b822-332f05a21950', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '092fe1a4-0373-4752-867b-7db5f34392c8', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ed81fc8d-697f-4adb-ae74-9ae39533bd41', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a40260fe-7ddd-4d85-9850-8f9ae7eca040', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '03a90d69-2eae-4b4c-b7d6-4b029fdd2356', 'ae8de529-4081-436b-8944-420028fa3cf4');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6daf1bf7-1456-4abc-834f-42af684b051f', 'ae8de529-4081-436b-8944-420028fa3cf4');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7d58f7df-607e-4aef-96f9-7943fec39888', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5315d2da-6a5d-4bee-acce-e1e6cbf2d5e2', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bf89787c-3a1d-4d92-b25d-8f011048f24c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2566efe-f4f8-4c91-800a-37d447e8ea4e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '177aff06-809e-4bf7-a6c6-e52b1c4fb347', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37201c1e-6994-47e3-b3b5-8a1735dcee2e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a266a805-5e0f-4ff9-bcc0-261c38a2d4ea', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd5ceb45d-c3ab-4976-941f-1687f8740734', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bebb2053-f707-4f43-bf14-2ac35fd14b56', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '234c92de-7d50-49b3-ab7b-6ca99eef6944', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '874976e9-2adc-4fc6-afb6-2decedd0b545', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e110a7e2-7dff-4d02-ad0d-8a7640c21494', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c626376a-7894-467d-aa05-48789e15eab9', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8cdf01e7-855d-4369-b4d2-760092121978', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2bda5eba-2544-43f2-8cb0-235e1fb3aec0', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8851dd90-78f9-4270-a43b-7e63baef7854', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '41a43bec-0ff8-461b-a0cb-b0f149fa13f3', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd1cbbcd0-10bb-4bc3-81da-07c92d071156', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ccfec039-d222-40d2-b9d5-3f515db9fa76', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ef967ad2-2161-4182-b561-f68b3e43cdf2', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c586e4e0-3245-4337-85a6-7f8755298f53', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '486145f2-6be6-4967-9e4a-0831f6f174e0', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '26e490a6-6fac-4ce6-b822-332f05a21950', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '092fe1a4-0373-4752-867b-7db5f34392c8', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ed81fc8d-697f-4adb-ae74-9ae39533bd41', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a40260fe-7ddd-4d85-9850-8f9ae7eca040', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '03a90d69-2eae-4b4c-b7d6-4b029fdd2356', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6daf1bf7-1456-4abc-834f-42af684b051f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '7d58f7df-607e-4aef-96f9-7943fec39888', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5315d2da-6a5d-4bee-acce-e1e6cbf2d5e2', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bf89787c-3a1d-4d92-b25d-8f011048f24c', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c2566efe-f4f8-4c91-800a-37d447e8ea4e', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '177aff06-809e-4bf7-a6c6-e52b1c4fb347', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37201c1e-6994-47e3-b3b5-8a1735dcee2e', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a266a805-5e0f-4ff9-bcc0-261c38a2d4ea', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd5ceb45d-c3ab-4976-941f-1687f8740734', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bebb2053-f707-4f43-bf14-2ac35fd14b56', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '234c92de-7d50-49b3-ab7b-6ca99eef6944', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '874976e9-2adc-4fc6-afb6-2decedd0b545', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e110a7e2-7dff-4d02-ad0d-8a7640c21494', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c626376a-7894-467d-aa05-48789e15eab9', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8cdf01e7-855d-4369-b4d2-760092121978', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2bda5eba-2544-43f2-8cb0-235e1fb3aec0', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8851dd90-78f9-4270-a43b-7e63baef7854', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '41a43bec-0ff8-461b-a0cb-b0f149fa13f3', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd1cbbcd0-10bb-4bc3-81da-07c92d071156', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ccfec039-d222-40d2-b9d5-3f515db9fa76', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ef967ad2-2161-4182-b561-f68b3e43cdf2', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c586e4e0-3245-4337-85a6-7f8755298f53', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '486145f2-6be6-4967-9e4a-0831f6f174e0', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '26e490a6-6fac-4ce6-b822-332f05a21950', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '092fe1a4-0373-4752-867b-7db5f34392c8', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ed81fc8d-697f-4adb-ae74-9ae39533bd41', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a40260fe-7ddd-4d85-9850-8f9ae7eca040', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '03a90d69-2eae-4b4c-b7d6-4b029fdd2356', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6daf1bf7-1456-4abc-834f-42af684b051f', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 5

-- Values
INSERT INTO gosha.const_table_values VALUES ('db684efc-06ef-4ab8-9da9-8ef64faf9134', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('4e612d10-9b79-4ea6-9102-2b26b6e23480', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('f46df5b2-98fa-48fd-97a1-c98b1301648e', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a0de5c70-3661-42c1-878e-8cec5dd37dfc', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('87ee2197-c090-4b06-98a5-306941116647', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('54c335f8-4100-4aee-89f0-9783c936547b', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5c91d65d-a1dc-4a3d-9109-1fc4079ce46c', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('8258c082-384b-4b14-b4dd-75408685db95', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('687339d8-292e-4ed9-a197-1e33090bc702', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('3b29f357-d209-41cd-8825-ed083012a3a4', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('299fb1c2-d149-4127-b5e6-7766267adf58', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a67f48c0-de8d-4f45-a2b9-6ab60b9186df', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('d2d255ca-cac1-46a9-ab59-c834de36b66a', -17, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('3226f4d7-088e-49c0-98c5-578e054b55cc', -25, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('4ca5b611-1793-4850-9ba8-bb9fa57970f7', -34, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6d425551-74be-4823-a42d-09d39abf2c92', -42, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('d625e2d5-99cd-4fe9-ab13-f513d26049ab', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('611bd516-4f84-481b-85bb-8bb08fb08d69', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('1e0eaf88-82ca-4352-909e-f20412a9051f', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('95365bf6-c564-41b0-9037-7081409f6b0a', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e1dbf162-7385-4d5a-9e24-65f43a36f40b', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('1a4ab0ae-8e94-4c81-a68c-ce7b8e70cffd', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('8e7d451a-c53c-41b1-a918-1d33ec056767', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('44e95a4a-64ae-4d2c-a873-d5c9a0761657', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c492381e-a477-475a-a0b4-a5d750d6d0eb', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9c7e50a6-0980-45fd-8140-e070c4dd861f', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('07eda6ea-cd25-4fca-ad55-9550ffc90775', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('467ae411-e37d-4ba0-9d20-9ab07ee80234', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'db684efc-06ef-4ab8-9da9-8ef64faf9134', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4e612d10-9b79-4ea6-9102-2b26b6e23480', '845b0477-bc67-40be-824a-ef933fd5f939');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f46df5b2-98fa-48fd-97a1-c98b1301648e', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0de5c70-3661-42c1-878e-8cec5dd37dfc', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '87ee2197-c090-4b06-98a5-306941116647', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54c335f8-4100-4aee-89f0-9783c936547b', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5c91d65d-a1dc-4a3d-9109-1fc4079ce46c', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8258c082-384b-4b14-b4dd-75408685db95', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '687339d8-292e-4ed9-a197-1e33090bc702', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3b29f357-d209-41cd-8825-ed083012a3a4', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '299fb1c2-d149-4127-b5e6-7766267adf58', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a67f48c0-de8d-4f45-a2b9-6ab60b9186df', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd2d255ca-cac1-46a9-ab59-c834de36b66a', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3226f4d7-088e-49c0-98c5-578e054b55cc', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4ca5b611-1793-4850-9ba8-bb9fa57970f7', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6d425551-74be-4823-a42d-09d39abf2c92', '845b0477-bc67-40be-824a-ef933fd5f939');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd625e2d5-99cd-4fe9-ab13-f513d26049ab', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0de5c70-3661-42c1-878e-8cec5dd37dfc', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1e0eaf88-82ca-4352-909e-f20412a9051f', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '95365bf6-c564-41b0-9037-7081409f6b0a', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1dbf162-7385-4d5a-9e24-65f43a36f40b', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1a4ab0ae-8e94-4c81-a68c-ce7b8e70cffd', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8e7d451a-c53c-41b1-a918-1d33ec056767', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '44e95a4a-64ae-4d2c-a873-d5c9a0761657', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c492381e-a477-475a-a0b4-a5d750d6d0eb', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c7e50a6-0980-45fd-8140-e070c4dd861f', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '07eda6ea-cd25-4fca-ad55-9550ffc90775', '845b0477-bc67-40be-824a-ef933fd5f939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '467ae411-e37d-4ba0-9d20-9ab07ee80234', '845b0477-bc67-40be-824a-ef933fd5f939');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'db684efc-06ef-4ab8-9da9-8ef64faf9134', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4e612d10-9b79-4ea6-9102-2b26b6e23480', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f46df5b2-98fa-48fd-97a1-c98b1301648e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0de5c70-3661-42c1-878e-8cec5dd37dfc', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '87ee2197-c090-4b06-98a5-306941116647', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54c335f8-4100-4aee-89f0-9783c936547b', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5c91d65d-a1dc-4a3d-9109-1fc4079ce46c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8258c082-384b-4b14-b4dd-75408685db95', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '687339d8-292e-4ed9-a197-1e33090bc702', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3b29f357-d209-41cd-8825-ed083012a3a4', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '299fb1c2-d149-4127-b5e6-7766267adf58', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a67f48c0-de8d-4f45-a2b9-6ab60b9186df', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd2d255ca-cac1-46a9-ab59-c834de36b66a', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3226f4d7-088e-49c0-98c5-578e054b55cc', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4ca5b611-1793-4850-9ba8-bb9fa57970f7', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6d425551-74be-4823-a42d-09d39abf2c92', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd625e2d5-99cd-4fe9-ab13-f513d26049ab', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '611bd516-4f84-481b-85bb-8bb08fb08d69', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1e0eaf88-82ca-4352-909e-f20412a9051f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '95365bf6-c564-41b0-9037-7081409f6b0a', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1dbf162-7385-4d5a-9e24-65f43a36f40b', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1a4ab0ae-8e94-4c81-a68c-ce7b8e70cffd', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8e7d451a-c53c-41b1-a918-1d33ec056767', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '44e95a4a-64ae-4d2c-a873-d5c9a0761657', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c492381e-a477-475a-a0b4-a5d750d6d0eb', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c7e50a6-0980-45fd-8140-e070c4dd861f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '07eda6ea-cd25-4fca-ad55-9550ffc90775', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '467ae411-e37d-4ba0-9d20-9ab07ee80234', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'db684efc-06ef-4ab8-9da9-8ef64faf9134', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4e612d10-9b79-4ea6-9102-2b26b6e23480', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f46df5b2-98fa-48fd-97a1-c98b1301648e', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0de5c70-3661-42c1-878e-8cec5dd37dfc', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '87ee2197-c090-4b06-98a5-306941116647', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54c335f8-4100-4aee-89f0-9783c936547b', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5c91d65d-a1dc-4a3d-9109-1fc4079ce46c', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8258c082-384b-4b14-b4dd-75408685db95', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '687339d8-292e-4ed9-a197-1e33090bc702', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3b29f357-d209-41cd-8825-ed083012a3a4', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '299fb1c2-d149-4127-b5e6-7766267adf58', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a67f48c0-de8d-4f45-a2b9-6ab60b9186df', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd2d255ca-cac1-46a9-ab59-c834de36b66a', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3226f4d7-088e-49c0-98c5-578e054b55cc', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4ca5b611-1793-4850-9ba8-bb9fa57970f7', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6d425551-74be-4823-a42d-09d39abf2c92', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd625e2d5-99cd-4fe9-ab13-f513d26049ab', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '611bd516-4f84-481b-85bb-8bb08fb08d69', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1e0eaf88-82ca-4352-909e-f20412a9051f', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '95365bf6-c564-41b0-9037-7081409f6b0a', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1dbf162-7385-4d5a-9e24-65f43a36f40b', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1a4ab0ae-8e94-4c81-a68c-ce7b8e70cffd', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8e7d451a-c53c-41b1-a918-1d33ec056767', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '44e95a4a-64ae-4d2c-a873-d5c9a0761657', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c492381e-a477-475a-a0b4-a5d750d6d0eb', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9c7e50a6-0980-45fd-8140-e070c4dd861f', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '07eda6ea-cd25-4fca-ad55-9550ffc90775', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '467ae411-e37d-4ba0-9d20-9ab07ee80234', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 6

-- Values
INSERT INTO gosha.const_table_values VALUES ('10f1c692-006d-4d3c-8be2-d54549cc4078', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('1c3b57fe-7890-4d4f-9ccd-c6bb965a1b73', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('b922daff-870e-4d4d-803e-4e1ce4de8a8d', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('b4f53650-3265-46bf-b8ca-df6bccf46d22', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('49119ea7-4acf-4225-bb67-1bb1aed12db6', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('bff1c30a-9f30-4926-8d99-3d2a711ac030', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c0c55c73-7013-47c6-bfff-e7bcc683f1d3', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('90bd3bd1-b2d9-45a8-a5db-42337ea3a62d', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('2231cbff-ea1e-42cb-afe1-1abbebb6352a', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('800e26a5-70cc-4bbe-973a-2b6cb83ba74f', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('86b03286-b9c9-4ebf-a059-fec995bf992d', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('60522ecc-ac4e-42f2-9eb8-47c560ef8bf3', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('3755b7ea-7107-43a2-9285-41830383c34d', -16, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e8ef1492-0848-4f99-a6a7-419738a4e0e3', -24, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('62e587d0-007d-4a93-a00c-cc7bf0f150f3', -32, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('81346dd2-c73f-483f-97b1-99ac1d370d6c', -40, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('4b84739a-f3e1-473c-ae35-659aa9b7c5d9', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e4fe979e-0f55-4845-a651-4c06f1d76f81', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('182603eb-8348-44f4-86f5-45e08202e3e0', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ba6d43ff-e44d-4822-9961-66cd1ff855e9', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a3d9819e-5df8-42d4-ac46-9e69a3ebd155', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('78643a04-73dd-42ab-8085-4e376f95de35', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c7bac43c-3955-4ae3-b800-2d38d2d97c4b', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('47c36c0e-ad39-4d18-a0b0-30fb12dd680b', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e86c03b1-09ca-4e8e-9440-9c1ec7c248f1', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ff15ef31-057c-4acf-b92f-73974e24795f', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('44302b32-cff9-4e16-88e1-69c18b7eeaa0', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('11a0a446-5b6d-4c6e-a9b4-d29529ac979e', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '10f1c692-006d-4d3c-8be2-d54549cc4078', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1c3b57fe-7890-4d4f-9ccd-c6bb965a1b73', '29f4ffde-281e-402b-be8a-1621e03504c0');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b922daff-870e-4d4d-803e-4e1ce4de8a8d', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b4f53650-3265-46bf-b8ca-df6bccf46d22', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49119ea7-4acf-4225-bb67-1bb1aed12db6', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bff1c30a-9f30-4926-8d99-3d2a711ac030', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c0c55c73-7013-47c6-bfff-e7bcc683f1d3', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '90bd3bd1-b2d9-45a8-a5db-42337ea3a62d', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2231cbff-ea1e-42cb-afe1-1abbebb6352a', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '800e26a5-70cc-4bbe-973a-2b6cb83ba74f', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '86b03286-b9c9-4ebf-a059-fec995bf992d', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '60522ecc-ac4e-42f2-9eb8-47c560ef8bf3', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3755b7ea-7107-43a2-9285-41830383c34d', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e8ef1492-0848-4f99-a6a7-419738a4e0e3', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '62e587d0-007d-4a93-a00c-cc7bf0f150f3', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '81346dd2-c73f-483f-97b1-99ac1d370d6c', '29f4ffde-281e-402b-be8a-1621e03504c0');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b84739a-f3e1-473c-ae35-659aa9b7c5d9', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b4f53650-3265-46bf-b8ca-df6bccf46d22', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '182603eb-8348-44f4-86f5-45e08202e3e0', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ba6d43ff-e44d-4822-9961-66cd1ff855e9', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a3d9819e-5df8-42d4-ac46-9e69a3ebd155', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '78643a04-73dd-42ab-8085-4e376f95de35', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c7bac43c-3955-4ae3-b800-2d38d2d97c4b', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '47c36c0e-ad39-4d18-a0b0-30fb12dd680b', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e86c03b1-09ca-4e8e-9440-9c1ec7c248f1', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ff15ef31-057c-4acf-b92f-73974e24795f', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '44302b32-cff9-4e16-88e1-69c18b7eeaa0', '29f4ffde-281e-402b-be8a-1621e03504c0');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '11a0a446-5b6d-4c6e-a9b4-d29529ac979e', '29f4ffde-281e-402b-be8a-1621e03504c0');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '10f1c692-006d-4d3c-8be2-d54549cc4078', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1c3b57fe-7890-4d4f-9ccd-c6bb965a1b73', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b922daff-870e-4d4d-803e-4e1ce4de8a8d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b4f53650-3265-46bf-b8ca-df6bccf46d22', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49119ea7-4acf-4225-bb67-1bb1aed12db6', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bff1c30a-9f30-4926-8d99-3d2a711ac030', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c0c55c73-7013-47c6-bfff-e7bcc683f1d3', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '90bd3bd1-b2d9-45a8-a5db-42337ea3a62d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2231cbff-ea1e-42cb-afe1-1abbebb6352a', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '800e26a5-70cc-4bbe-973a-2b6cb83ba74f', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '86b03286-b9c9-4ebf-a059-fec995bf992d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '60522ecc-ac4e-42f2-9eb8-47c560ef8bf3', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3755b7ea-7107-43a2-9285-41830383c34d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e8ef1492-0848-4f99-a6a7-419738a4e0e3', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '62e587d0-007d-4a93-a00c-cc7bf0f150f3', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '81346dd2-c73f-483f-97b1-99ac1d370d6c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b84739a-f3e1-473c-ae35-659aa9b7c5d9', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e4fe979e-0f55-4845-a651-4c06f1d76f81', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '182603eb-8348-44f4-86f5-45e08202e3e0', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ba6d43ff-e44d-4822-9961-66cd1ff855e9', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a3d9819e-5df8-42d4-ac46-9e69a3ebd155', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '78643a04-73dd-42ab-8085-4e376f95de35', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c7bac43c-3955-4ae3-b800-2d38d2d97c4b', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '47c36c0e-ad39-4d18-a0b0-30fb12dd680b', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e86c03b1-09ca-4e8e-9440-9c1ec7c248f1', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ff15ef31-057c-4acf-b92f-73974e24795f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '44302b32-cff9-4e16-88e1-69c18b7eeaa0', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '11a0a446-5b6d-4c6e-a9b4-d29529ac979e', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '10f1c692-006d-4d3c-8be2-d54549cc4078', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '1c3b57fe-7890-4d4f-9ccd-c6bb965a1b73', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b922daff-870e-4d4d-803e-4e1ce4de8a8d', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b4f53650-3265-46bf-b8ca-df6bccf46d22', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49119ea7-4acf-4225-bb67-1bb1aed12db6', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'bff1c30a-9f30-4926-8d99-3d2a711ac030', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c0c55c73-7013-47c6-bfff-e7bcc683f1d3', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '90bd3bd1-b2d9-45a8-a5db-42337ea3a62d', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2231cbff-ea1e-42cb-afe1-1abbebb6352a', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '800e26a5-70cc-4bbe-973a-2b6cb83ba74f', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '86b03286-b9c9-4ebf-a059-fec995bf992d', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '60522ecc-ac4e-42f2-9eb8-47c560ef8bf3', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3755b7ea-7107-43a2-9285-41830383c34d', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e8ef1492-0848-4f99-a6a7-419738a4e0e3', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '62e587d0-007d-4a93-a00c-cc7bf0f150f3', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '81346dd2-c73f-483f-97b1-99ac1d370d6c', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4b84739a-f3e1-473c-ae35-659aa9b7c5d9', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e4fe979e-0f55-4845-a651-4c06f1d76f81', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '182603eb-8348-44f4-86f5-45e08202e3e0', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ba6d43ff-e44d-4822-9961-66cd1ff855e9', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a3d9819e-5df8-42d4-ac46-9e69a3ebd155', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '78643a04-73dd-42ab-8085-4e376f95de35', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c7bac43c-3955-4ae3-b800-2d38d2d97c4b', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '47c36c0e-ad39-4d18-a0b0-30fb12dd680b', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e86c03b1-09ca-4e8e-9440-9c1ec7c248f1', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ff15ef31-057c-4acf-b92f-73974e24795f', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '44302b32-cff9-4e16-88e1-69c18b7eeaa0', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '11a0a446-5b6d-4c6e-a9b4-d29529ac979e', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 7

-- Values
INSERT INTO gosha.const_table_values VALUES ('98d1ce26-2588-44f6-bc4e-a7d9697868cf', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c12db44b-c3d8-497a-8ca1-417da4107cec', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('e207e45c-a0fd-4b6c-9759-035155fd3c2f', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5d5c3738-1342-437c-91b6-6c0f8e6eeea1', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f2b66083-3694-4bb1-a489-ff86b2b81932', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9510fab1-f557-4a58-be13-b59656bf9ada', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('37fb8e12-80cb-4143-a3bb-3c8d9916d383', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c81cf9dd-c817-425b-bad9-4cbeba649240', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('94b827b8-e349-4bee-b45e-11be3b948921', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f7c6b3da-a3c8-4a92-bb49-a5b42074b3ee', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('01f998f8-8a91-485b-ad32-2c99b553d73a', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9af69388-a396-481a-89f5-c1a009ba7f8e', -7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a31ec543-5f8e-4962-a003-99040b41924c', -15, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ae4a59bf-e8cd-4bad-baf6-bd3a2c2147bf', -23, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('b1b092f2-4e86-44d6-86b7-9bef1543f29c', -31, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('55a89dbc-bcb4-497d-b423-65f6aefe6cca', -38, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('a5c4b805-1225-49fc-8819-66df47383075', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('49d0a2fb-7033-41f5-9e2b-c5866644814a', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ab2fd164-2def-4ad5-8061-1138b9140c07', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('89131cde-4d36-47c1-83bc-9f828e863b84', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('092444c1-6196-4d98-9ee3-9bad8e4c28e2', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('99db730c-2607-4304-9dce-10f6bf3778f2', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('4cd9badc-5783-48a5-b76a-d9d5758b42ef', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('413434fc-dadb-4c88-9fb7-00576e989878', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('312760ba-dc2e-48e8-856d-a1f4964f0c44', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a38084a8-669a-4b1f-ad96-e145e58febe6', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('d747d891-b084-4050-adb2-1ed9645efebe', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ec68a350-9574-464b-a00b-089de5a28791', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '98d1ce26-2588-44f6-bc4e-a7d9697868cf', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c12db44b-c3d8-497a-8ca1-417da4107cec', 'bf109d15-5e82-4363-9484-9b0f67141e3d');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e207e45c-a0fd-4b6c-9759-035155fd3c2f', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d5c3738-1342-437c-91b6-6c0f8e6eeea1', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2b66083-3694-4bb1-a489-ff86b2b81932', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9510fab1-f557-4a58-be13-b59656bf9ada', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37fb8e12-80cb-4143-a3bb-3c8d9916d383', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c81cf9dd-c817-425b-bad9-4cbeba649240', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '94b827b8-e349-4bee-b45e-11be3b948921', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f7c6b3da-a3c8-4a92-bb49-a5b42074b3ee', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '01f998f8-8a91-485b-ad32-2c99b553d73a', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9af69388-a396-481a-89f5-c1a009ba7f8e', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a31ec543-5f8e-4962-a003-99040b41924c', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ae4a59bf-e8cd-4bad-baf6-bd3a2c2147bf', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1b092f2-4e86-44d6-86b7-9bef1543f29c', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '55a89dbc-bcb4-497d-b423-65f6aefe6cca', 'bf109d15-5e82-4363-9484-9b0f67141e3d');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a5c4b805-1225-49fc-8819-66df47383075', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d5c3738-1342-437c-91b6-6c0f8e6eeea1', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ab2fd164-2def-4ad5-8061-1138b9140c07', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '89131cde-4d36-47c1-83bc-9f828e863b84', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '092444c1-6196-4d98-9ee3-9bad8e4c28e2', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '99db730c-2607-4304-9dce-10f6bf3778f2', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4cd9badc-5783-48a5-b76a-d9d5758b42ef', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '413434fc-dadb-4c88-9fb7-00576e989878', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '312760ba-dc2e-48e8-856d-a1f4964f0c44', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a38084a8-669a-4b1f-ad96-e145e58febe6', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd747d891-b084-4050-adb2-1ed9645efebe', 'bf109d15-5e82-4363-9484-9b0f67141e3d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ec68a350-9574-464b-a00b-089de5a28791', 'bf109d15-5e82-4363-9484-9b0f67141e3d');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '98d1ce26-2588-44f6-bc4e-a7d9697868cf', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c12db44b-c3d8-497a-8ca1-417da4107cec', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e207e45c-a0fd-4b6c-9759-035155fd3c2f', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d5c3738-1342-437c-91b6-6c0f8e6eeea1', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2b66083-3694-4bb1-a489-ff86b2b81932', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9510fab1-f557-4a58-be13-b59656bf9ada', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37fb8e12-80cb-4143-a3bb-3c8d9916d383', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c81cf9dd-c817-425b-bad9-4cbeba649240', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '94b827b8-e349-4bee-b45e-11be3b948921', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f7c6b3da-a3c8-4a92-bb49-a5b42074b3ee', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '01f998f8-8a91-485b-ad32-2c99b553d73a', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9af69388-a396-481a-89f5-c1a009ba7f8e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a31ec543-5f8e-4962-a003-99040b41924c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ae4a59bf-e8cd-4bad-baf6-bd3a2c2147bf', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1b092f2-4e86-44d6-86b7-9bef1543f29c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '55a89dbc-bcb4-497d-b423-65f6aefe6cca', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a5c4b805-1225-49fc-8819-66df47383075', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49d0a2fb-7033-41f5-9e2b-c5866644814a', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ab2fd164-2def-4ad5-8061-1138b9140c07', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '89131cde-4d36-47c1-83bc-9f828e863b84', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '092444c1-6196-4d98-9ee3-9bad8e4c28e2', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '99db730c-2607-4304-9dce-10f6bf3778f2', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4cd9badc-5783-48a5-b76a-d9d5758b42ef', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '413434fc-dadb-4c88-9fb7-00576e989878', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '312760ba-dc2e-48e8-856d-a1f4964f0c44', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a38084a8-669a-4b1f-ad96-e145e58febe6', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd747d891-b084-4050-adb2-1ed9645efebe', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ec68a350-9574-464b-a00b-089de5a28791', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '98d1ce26-2588-44f6-bc4e-a7d9697868cf', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c12db44b-c3d8-497a-8ca1-417da4107cec', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e207e45c-a0fd-4b6c-9759-035155fd3c2f', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5d5c3738-1342-437c-91b6-6c0f8e6eeea1', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f2b66083-3694-4bb1-a489-ff86b2b81932', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9510fab1-f557-4a58-be13-b59656bf9ada', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '37fb8e12-80cb-4143-a3bb-3c8d9916d383', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c81cf9dd-c817-425b-bad9-4cbeba649240', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '94b827b8-e349-4bee-b45e-11be3b948921', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f7c6b3da-a3c8-4a92-bb49-a5b42074b3ee', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '01f998f8-8a91-485b-ad32-2c99b553d73a', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9af69388-a396-481a-89f5-c1a009ba7f8e', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a31ec543-5f8e-4962-a003-99040b41924c', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ae4a59bf-e8cd-4bad-baf6-bd3a2c2147bf', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b1b092f2-4e86-44d6-86b7-9bef1543f29c', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '55a89dbc-bcb4-497d-b423-65f6aefe6cca', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a5c4b805-1225-49fc-8819-66df47383075', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49d0a2fb-7033-41f5-9e2b-c5866644814a', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ab2fd164-2def-4ad5-8061-1138b9140c07', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '89131cde-4d36-47c1-83bc-9f828e863b84', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '092444c1-6196-4d98-9ee3-9bad8e4c28e2', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '99db730c-2607-4304-9dce-10f6bf3778f2', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4cd9badc-5783-48a5-b76a-d9d5758b42ef', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '413434fc-dadb-4c88-9fb7-00576e989878', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '312760ba-dc2e-48e8-856d-a1f4964f0c44', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a38084a8-669a-4b1f-ad96-e145e58febe6', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd747d891-b084-4050-adb2-1ed9645efebe', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ec68a350-9574-464b-a00b-089de5a28791', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 8

-- Values
INSERT INTO gosha.const_table_values VALUES ('a2ac6842-1583-4cec-9205-66de92b52ab4', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('50aaf956-690a-47c6-8cc5-5f614e374e91', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('9f1dae42-0246-4dd9-82c7-f5851fc2ef01', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('73dd2598-cc90-4884-b47f-472daaf04330', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('902447de-ee37-40f4-b9ff-5f0d92c1764b', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('53353bc0-ba53-45a9-a555-cac7ea1e9893', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('977f539f-93bc-42ab-b45a-f1d86226ec0c', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('8b3413c8-5390-419a-ae91-a9c9cacb138c', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('38953180-d6c1-461c-857f-34785d5bc549', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('215bf647-e69d-4539-8305-2695d3278572', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('249d24b5-b91b-41b6-9d87-0556562adac8', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('eb9ee93f-91d4-4932-8d67-ab5b42000631', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('957b6ba0-e309-4a9f-b9f2-27dcd4e96c0d', -15, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('66c27479-347b-4910-bb67-d369bca22441', -22, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ae3a4ca4-1d2b-4733-ae4f-49e7b183f081', -30, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('0671bc08-b914-4b08-95be-15e82bf01fdb', -37, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('4750a7d0-0866-43de-85d7-7ec1dba042ae', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('794dee64-1039-45ad-a179-2f0549dc323f', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('46e74f3f-6281-4b29-878a-2dd5a1c9b7e1', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('6cb1d871-1212-4511-b63e-1ed1599afe98', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('36817b64-87ab-487e-8539-aa55ce98c277', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('73c5e54b-eb70-4272-af28-a64e4647e6af', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('3f0e15bf-3cec-4e11-8d00-4ab1a42a07bf', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('67cd9e36-3155-428a-b7a4-f8f27950df55', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('5e94c774-40b9-4e2f-8c75-b68234356eca', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('87b6a223-03a6-4e28-ac31-463ea2503ca4', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a0230ceb-34cb-4795-bed2-259663c47a8a', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c4cbadf3-e6df-417d-b3ea-be0d8dca5804', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a2ac6842-1583-4cec-9205-66de92b52ab4', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '50aaf956-690a-47c6-8cc5-5f614e374e91', '6f95200d-31a2-4f01-be6b-f8e344a2e402');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9f1dae42-0246-4dd9-82c7-f5851fc2ef01', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73dd2598-cc90-4884-b47f-472daaf04330', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '902447de-ee37-40f4-b9ff-5f0d92c1764b', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '53353bc0-ba53-45a9-a555-cac7ea1e9893', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '977f539f-93bc-42ab-b45a-f1d86226ec0c', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8b3413c8-5390-419a-ae91-a9c9cacb138c', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '38953180-d6c1-461c-857f-34785d5bc549', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '215bf647-e69d-4539-8305-2695d3278572', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '249d24b5-b91b-41b6-9d87-0556562adac8', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'eb9ee93f-91d4-4932-8d67-ab5b42000631', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '957b6ba0-e309-4a9f-b9f2-27dcd4e96c0d', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '66c27479-347b-4910-bb67-d369bca22441', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ae3a4ca4-1d2b-4733-ae4f-49e7b183f081', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0671bc08-b914-4b08-95be-15e82bf01fdb', '6f95200d-31a2-4f01-be6b-f8e344a2e402');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4750a7d0-0866-43de-85d7-7ec1dba042ae', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73dd2598-cc90-4884-b47f-472daaf04330', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '46e74f3f-6281-4b29-878a-2dd5a1c9b7e1', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6cb1d871-1212-4511-b63e-1ed1599afe98', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '36817b64-87ab-487e-8539-aa55ce98c277', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73c5e54b-eb70-4272-af28-a64e4647e6af', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3f0e15bf-3cec-4e11-8d00-4ab1a42a07bf', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '67cd9e36-3155-428a-b7a4-f8f27950df55', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5e94c774-40b9-4e2f-8c75-b68234356eca', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '87b6a223-03a6-4e28-ac31-463ea2503ca4', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0230ceb-34cb-4795-bed2-259663c47a8a', '6f95200d-31a2-4f01-be6b-f8e344a2e402');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c4cbadf3-e6df-417d-b3ea-be0d8dca5804', '6f95200d-31a2-4f01-be6b-f8e344a2e402');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a2ac6842-1583-4cec-9205-66de92b52ab4', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '50aaf956-690a-47c6-8cc5-5f614e374e91', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9f1dae42-0246-4dd9-82c7-f5851fc2ef01', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73dd2598-cc90-4884-b47f-472daaf04330', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '902447de-ee37-40f4-b9ff-5f0d92c1764b', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '53353bc0-ba53-45a9-a555-cac7ea1e9893', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '977f539f-93bc-42ab-b45a-f1d86226ec0c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8b3413c8-5390-419a-ae91-a9c9cacb138c', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '38953180-d6c1-461c-857f-34785d5bc549', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '215bf647-e69d-4539-8305-2695d3278572', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '249d24b5-b91b-41b6-9d87-0556562adac8', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'eb9ee93f-91d4-4932-8d67-ab5b42000631', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '957b6ba0-e309-4a9f-b9f2-27dcd4e96c0d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '66c27479-347b-4910-bb67-d369bca22441', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ae3a4ca4-1d2b-4733-ae4f-49e7b183f081', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0671bc08-b914-4b08-95be-15e82bf01fdb', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4750a7d0-0866-43de-85d7-7ec1dba042ae', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '794dee64-1039-45ad-a179-2f0549dc323f', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '46e74f3f-6281-4b29-878a-2dd5a1c9b7e1', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6cb1d871-1212-4511-b63e-1ed1599afe98', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '36817b64-87ab-487e-8539-aa55ce98c277', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73c5e54b-eb70-4272-af28-a64e4647e6af', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3f0e15bf-3cec-4e11-8d00-4ab1a42a07bf', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '67cd9e36-3155-428a-b7a4-f8f27950df55', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5e94c774-40b9-4e2f-8c75-b68234356eca', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '87b6a223-03a6-4e28-ac31-463ea2503ca4', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0230ceb-34cb-4795-bed2-259663c47a8a', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c4cbadf3-e6df-417d-b3ea-be0d8dca5804', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a2ac6842-1583-4cec-9205-66de92b52ab4', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '50aaf956-690a-47c6-8cc5-5f614e374e91', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9f1dae42-0246-4dd9-82c7-f5851fc2ef01', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73dd2598-cc90-4884-b47f-472daaf04330', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '902447de-ee37-40f4-b9ff-5f0d92c1764b', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '53353bc0-ba53-45a9-a555-cac7ea1e9893', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '977f539f-93bc-42ab-b45a-f1d86226ec0c', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '8b3413c8-5390-419a-ae91-a9c9cacb138c', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '38953180-d6c1-461c-857f-34785d5bc549', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '215bf647-e69d-4539-8305-2695d3278572', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '249d24b5-b91b-41b6-9d87-0556562adac8', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'eb9ee93f-91d4-4932-8d67-ab5b42000631', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '957b6ba0-e309-4a9f-b9f2-27dcd4e96c0d', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '66c27479-347b-4910-bb67-d369bca22441', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ae3a4ca4-1d2b-4733-ae4f-49e7b183f081', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '0671bc08-b914-4b08-95be-15e82bf01fdb', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '4750a7d0-0866-43de-85d7-7ec1dba042ae', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '794dee64-1039-45ad-a179-2f0549dc323f', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '46e74f3f-6281-4b29-878a-2dd5a1c9b7e1', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '6cb1d871-1212-4511-b63e-1ed1599afe98', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '36817b64-87ab-487e-8539-aa55ce98c277', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '73c5e54b-eb70-4272-af28-a64e4647e6af', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '3f0e15bf-3cec-4e11-8d00-4ab1a42a07bf', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '67cd9e36-3155-428a-b7a4-f8f27950df55', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '5e94c774-40b9-4e2f-8c75-b68234356eca', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '87b6a223-03a6-4e28-ac31-463ea2503ca4', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a0230ceb-34cb-4795-bed2-259663c47a8a', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c4cbadf3-e6df-417d-b3ea-be0d8dca5804', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


-- 9

-- Values
INSERT INTO gosha.const_table_values VALUES ('ebff7ba0-265c-451d-991b-8bfbe9d379e6', 0, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c1f096fe-1585-4f1b-9f3a-295603df4d6a', 0, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('2fcdd132-aaa4-453c-b5a7-0090bef52fb0', -1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c3e05c80-a68f-4c4b-a23b-7b7980b644dd', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('f7d8a94d-b162-4bb4-a782-9d59b91df451', -2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('54415b51-a2ed-4ede-8c80-cc385455bf23', -3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('b8f1137c-ac9e-494c-b029-4190f16c8a5d', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9ecc0fbc-5540-4d66-adbe-d0e8a58c912f', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('67707235-148a-4f34-be51-e36f1f65eacf', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('d0dc6e7e-981b-46d7-bd47-9ffe56b32ab2', -4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9e270cc5-c897-44a1-809d-75be64fcff82', -5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('69e00f98-ecf5-4f3f-8076-f851412e1fbd', -6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('d7b06e3e-625e-40c1-8279-8327c03f04e2', -14, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c997f08f-89bd-4ca4-947a-ab83f5fbe3ee', -20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('9aeacecd-c9d0-487a-96c6-928f2e1bd34e', -27, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('818b63fb-7d97-4c39-9b00-d0646115d9bb', -34, '8dd77de1-d576-4691-8358-f76bf521753a');

INSERT INTO gosha.const_table_values VALUES ('f5cbc6cd-27c1-4752-b6b3-1b2ea8a379b1', 1, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c50bd3be-66b2-4fce-ab11-18197a3f2396', 2, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('27a5eaf7-0cc3-4176-b23a-ad6dfcf3ee8e', 3, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('ac01422e-780c-4355-9e1d-4d85675a4cb2', 4, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('49f69293-d3b7-464c-aaaa-ffc082b1e7a2', 5, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('91d010ec-c5c0-4335-89ff-1e447fb1e2c8', 6, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('534b22bd-93c9-4a1d-804a-b07ec89899b6', 7, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('e1d5562e-6c9b-4ff4-bd92-64bd9a309635', 8, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('035042d4-7ad1-4afd-a0b7-95537575d270', 9, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('85b620d0-73ee-4300-bfb9-5de256fa4f41', 10, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('a7086d5f-6597-42fc-a891-0c581cd9e985', 20, '8dd77de1-d576-4691-8358-f76bf521753a');
INSERT INTO gosha.const_table_values VALUES ('c6d084f2-58bf-4618-87c3-8b0c692574c9', 30, '8dd77de1-d576-4691-8358-f76bf521753a');

-- Headers
-- heights
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ebff7ba0-265c-451d-991b-8bfbe9d379e6', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c1f096fe-1585-4f1b-9f3a-295603df4d6a', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2fcdd132-aaa4-453c-b5a7-0090bef52fb0', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c3e05c80-a68f-4c4b-a23b-7b7980b644dd', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f7d8a94d-b162-4bb4-a782-9d59b91df451', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54415b51-a2ed-4ede-8c80-cc385455bf23', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b8f1137c-ac9e-494c-b029-4190f16c8a5d', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ecc0fbc-5540-4d66-adbe-d0e8a58c912f', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '67707235-148a-4f34-be51-e36f1f65eacf', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd0dc6e7e-981b-46d7-bd47-9ffe56b32ab2', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9e270cc5-c897-44a1-809d-75be64fcff82', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '69e00f98-ecf5-4f3f-8076-f851412e1fbd', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd7b06e3e-625e-40c1-8279-8327c03f04e2', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c997f08f-89bd-4ca4-947a-ab83f5fbe3ee', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9aeacecd-c9d0-487a-96c6-928f2e1bd34e', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '818b63fb-7d97-4c39-9b00-d0646115d9bb', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f5cbc6cd-27c1-4752-b6b3-1b2ea8a379b1', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c3e05c80-a68f-4c4b-a23b-7b7980b644dd', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '27a5eaf7-0cc3-4176-b23a-ad6dfcf3ee8e', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ac01422e-780c-4355-9e1d-4d85675a4cb2', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49f69293-d3b7-464c-aaaa-ffc082b1e7a2', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '91d010ec-c5c0-4335-89ff-1e447fb1e2c8', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '534b22bd-93c9-4a1d-804a-b07ec89899b6', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1d5562e-6c9b-4ff4-bd92-64bd9a309635', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '035042d4-7ad1-4afd-a0b7-95537575d270', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '85b620d0-73ee-4300-bfb9-5de256fa4f41', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a7086d5f-6597-42fc-a891-0c581cd9e985', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c6d084f2-58bf-4618-87c3-8b0c692574c9', '5b0c31e5-ce5c-4f20-a538-3eee8e183939');

-- is_possitive
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ebff7ba0-265c-451d-991b-8bfbe9d379e6', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c1f096fe-1585-4f1b-9f3a-295603df4d6a', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2fcdd132-aaa4-453c-b5a7-0090bef52fb0', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c3e05c80-a68f-4c4b-a23b-7b7980b644dd', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f7d8a94d-b162-4bb4-a782-9d59b91df451', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54415b51-a2ed-4ede-8c80-cc385455bf23', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b8f1137c-ac9e-494c-b029-4190f16c8a5d', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ecc0fbc-5540-4d66-adbe-d0e8a58c912f', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '67707235-148a-4f34-be51-e36f1f65eacf', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd0dc6e7e-981b-46d7-bd47-9ffe56b32ab2', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9e270cc5-c897-44a1-809d-75be64fcff82', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '69e00f98-ecf5-4f3f-8076-f851412e1fbd', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd7b06e3e-625e-40c1-8279-8327c03f04e2', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c997f08f-89bd-4ca4-947a-ab83f5fbe3ee', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9aeacecd-c9d0-487a-96c6-928f2e1bd34e', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '818b63fb-7d97-4c39-9b00-d0646115d9bb', '5e1b4a1e-2884-4e65-8ed4-8ff0b5a5b3bb');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f5cbc6cd-27c1-4752-b6b3-1b2ea8a379b1', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c50bd3be-66b2-4fce-ab11-18197a3f2396', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '27a5eaf7-0cc3-4176-b23a-ad6dfcf3ee8e', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ac01422e-780c-4355-9e1d-4d85675a4cb2', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49f69293-d3b7-464c-aaaa-ffc082b1e7a2', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '91d010ec-c5c0-4335-89ff-1e447fb1e2c8', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '534b22bd-93c9-4a1d-804a-b07ec89899b6', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1d5562e-6c9b-4ff4-bd92-64bd9a309635', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '035042d4-7ad1-4afd-a0b7-95537575d270', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '85b620d0-73ee-4300-bfb9-5de256fa4f41', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a7086d5f-6597-42fc-a891-0c581cd9e985', '4c72a246-9225-4ffb-9d56-1f5c55268e64');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c6d084f2-58bf-4618-87c3-8b0c692574c9', '4c72a246-9225-4ffb-9d56-1f5c55268e64');

-- temp_delts
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ebff7ba0-265c-451d-991b-8bfbe9d379e6', '7344b92d-7760-4434-b6f6-3971e97bbb37');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c1f096fe-1585-4f1b-9f3a-295603df4d6a', '7344b92d-7760-4434-b6f6-3971e97bbb37');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '2fcdd132-aaa4-453c-b5a7-0090bef52fb0', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c3e05c80-a68f-4c4b-a23b-7b7980b644dd', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f7d8a94d-b162-4bb4-a782-9d59b91df451', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '54415b51-a2ed-4ede-8c80-cc385455bf23', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'b8f1137c-ac9e-494c-b029-4190f16c8a5d', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9ecc0fbc-5540-4d66-adbe-d0e8a58c912f', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '67707235-148a-4f34-be51-e36f1f65eacf', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd0dc6e7e-981b-46d7-bd47-9ffe56b32ab2', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9e270cc5-c897-44a1-809d-75be64fcff82', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '69e00f98-ecf5-4f3f-8076-f851412e1fbd', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'd7b06e3e-625e-40c1-8279-8327c03f04e2', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c997f08f-89bd-4ca4-947a-ab83f5fbe3ee', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '9aeacecd-c9d0-487a-96c6-928f2e1bd34e', '88a972e1-bd65-413f-afff-58619f2420b3');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '818b63fb-7d97-4c39-9b00-d0646115d9bb', 'd40a05eb-1851-4a44-a7e5-4729e6ba0091');

INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'f5cbc6cd-27c1-4752-b6b3-1b2ea8a379b1', '197c058d-d74b-484e-96c6-11676959b4cc');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c50bd3be-66b2-4fce-ab11-18197a3f2396', 'd6d80c7b-7339-4586-8504-9aaa17a82c4e');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '27a5eaf7-0cc3-4176-b23a-ad6dfcf3ee8e', '3a091a87-c8bc-45e1-97b7-e46fe5793f75');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'ac01422e-780c-4355-9e1d-4d85675a4cb2', '7c55a13a-87cf-45fd-8ca1-e285a10cb698');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '49f69293-d3b7-464c-aaaa-ffc082b1e7a2', 'c7ab9d80-3741-46da-8215-84dbb205ad7a');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '91d010ec-c5c0-4335-89ff-1e447fb1e2c8', 'ab8041ae-cfce-4bbe-b2db-c8fb863fc93d');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '534b22bd-93c9-4a1d-804a-b07ec89899b6', '733d16a7-eac9-44f9-90ab-1d3211c4c0c1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'e1d5562e-6c9b-4ff4-bd92-64bd9a309635', '8ed5d240-c14d-4e7c-a2df-3c82c3d0589f');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '035042d4-7ad1-4afd-a0b7-95537575d270', '5d303816-5b07-470a-90f3-22777a08e3b1');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), '85b620d0-73ee-4300-bfb9-5de256fa4f41', '31f2d040-7f5a-492f-b6e3-f12a2aebf1a2');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'a7086d5f-6597-42fc-a891-0c581cd9e985', '69112646-2a84-4a1d-be1b-0fa138dfab61');
INSERT INTO gosha.const_table_links VALUES (gen_random_uuid(), 'c6d084f2-58bf-4618-87c3-8b0c692574c9', 'b8a90a55-1984-4e04-a6bc-5c6b6882281d');


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
		select t1.* from gosha.const_table_values as t1
		join gosha.const_table_names as t2 on t1.name = t2.id
		where t2.name = 'wind_direction_delts'
	)
	SELECT t1.heights, t5.value 
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
		select t1.* from gosha.const_table_values as t1
		join gosha.const_table_names as t2 on t1.name = t2.id
		where t2.name = 'bullet_delts'
	)
	SELECT t1.heights, t1.bullet_delts, t5.value 
    FROM bullet_delts AS t1
    JOIN values AS t5 ON t1.next_id = t5.id;

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
    RETURNS TABLE(datetime character(5), height character(4), params character(5))
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
	IF not gosha."fnInputValidate"(height_, temperature, pressure, wind_speed, wind_direction) THEN
		raise exception 'Неккоректные данные!';
	END IF;
	return query select gosha."fnHeaderGetData"()::character(5), gosha."fnHeaderGetHeight"(height_)::character(4), (lpad(gosha."fnHeaderGetPressure"(pressure)::text, 3, '0') || lpad(gosha."fnHeaderGetTemperature"(temperature)::text, 2, '0'))::character(5);
end;
$BODY$;


-- Процедура получения разницы ветрянной температуры
CREATE OR REPLACE PROCEDURE gosha."prGetWindTempDelta"(
	IN temp_delta numeric,
	INOUT delts numeric[] default array[]::numeric[])
LANGUAGE 'plpgsql'
AS $BODY$
declare
	isabove numeric(8,2);
begin
	isabove := case when temp_delta > 0 then 1 else 0 end;
	select array_agg(t1.value + t2.value) from (select heights, value from gosha.wind_temperature_delta where temp_delts = floor(abs(temp_delta) / 10) * 10.0 and is_possitive = isabove) as t1
	inner join (select heights, value from gosha.wind_temperature_delta where temp_delts = abs(temp_delta) % 10 and is_possitive = isabove) as t2
	on t1.heights = t2.heights
	into delts;
end;
$BODY$;


select * from gosha.bullet_delta;