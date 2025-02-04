
ALTER TABLE IF EXISTS ONLY gosha.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY gosha.posts DROP CONSTRAINT IF EXISTS posts_pkey;
ALTER TABLE IF EXISTS ONLY gosha.inputs DROP CONSTRAINT IF EXISTS inputs_pkey;
ALTER TABLE IF EXISTS ONLY gosha.history DROP CONSTRAINT IF EXISTS history_pkey;
ALTER TABLE IF EXISTS ONLY gosha.devices DROP CONSTRAINT IF EXISTS devices_pkey;
ALTER TABLE IF EXISTS ONLY gosha.achievements_types DROP CONSTRAINT IF EXISTS achievements_types_pkey;
ALTER TABLE IF EXISTS ONLY gosha.achievements DROP CONSTRAINT IF EXISTS achievements_pkey1;
ALTER TABLE IF EXISTS ONLY gosha.users_achievs DROP CONSTRAINT IF EXISTS achievements_pkey;
DROP TABLE IF EXISTS gosha.users_achievs;
DROP TABLE IF EXISTS gosha.users;
DROP TABLE IF EXISTS gosha.posts;
DROP TABLE IF EXISTS gosha.inputs;
DROP TABLE IF EXISTS gosha.history;
DROP TABLE IF EXISTS gosha.devices;
DROP TABLE IF EXISTS gosha.achievements_types;
DROP TABLE IF EXISTS gosha.achievements;
DROP SCHEMA IF EXISTS gosha;



CREATE SCHEMA gosha;

-- study - мой пользователь
ALTER SCHEMA gosha OWNER TO study;



CREATE TABLE gosha.achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_id uuid NOT NULL,
    name character varying(100) NOT NULL
);
ALTER TABLE gosha.achievements OWNER TO study;



CREATE TABLE gosha.achievements_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL
);
ALTER TABLE gosha.achievements_types OWNER TO study;



CREATE TABLE gosha.devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL
);
ALTER TABLE gosha.devices OWNER TO study;



CREATE TABLE gosha.history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    input_id uuid NOT NULL,
    data timestamp with time zone DEFAULT now() NOT NULL,
    logitude numeric(4,2) NOT NULL,
    latitude numeric(4,2) NOT NULL,
    device_id uuid NOT NULL
);
ALTER TABLE gosha.history OWNER TO study;



CREATE TABLE gosha.inputs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    height numeric(8,2) NOT NULL,
    temperature numeric(8,2) NOT NULL,
    pressure numeric(8,2) NOT NULL,
    wind_speed numeric(8,2) NOT NULL,
    wind_direction numeric(8,2) NOT NULL,
    bullet_speed numeric(8,2) NOT NULL
);
ALTER TABLE gosha.inputs OWNER TO study;



CREATE TABLE gosha.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL
);
ALTER TABLE gosha.posts OWNER TO study;


CREATE TABLE gosha.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post uuid NOT NULL,
    fullname character varying(100) NOT NULL,
    age integer NOT NULL
);
ALTER TABLE gosha.users OWNER TO study;



CREATE TABLE gosha.users_achievs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    achievement_id uuid NOT NULL,
    user_id uuid NOT NULL
);
ALTER TABLE gosha.users_achievs OWNER TO study;


INSERT INTO gosha.achievements VALUES ('bcad8097-00a5-4714-8e90-346a672d0313', '65e6d057-d0f7-48a4-83be-c36dfc6bb0af', 'За боевые отличия');
INSERT INTO gosha.achievements VALUES ('a415c9c0-123f-405c-a9c6-6b37eba833f1', 'c60c7710-3424-4da5-a1d8-9d48c6b48f99', '100 лет Военно-воздушной академии имени профессора Н. Е. Жуковского и Ю. А. Гагарина');
INSERT INTO gosha.achievements VALUES ('13ef800c-e380-4538-b54c-66479435728e', '1df6e153-5b07-4443-8451-0846585ba6a2', 'Юридическая служба Вооружённых Сил Российской Федерации');
INSERT INTO gosha.achievements VALUES ('a555798e-b403-439b-a193-cd9ba2f9af13', 'f50966c0-6ce5-431b-b155-0427a9a80a74', '50 лет Главному управлению глубоководных исследований');

INSERT INTO gosha.achievements_types VALUES ('65e6d057-d0f7-48a4-83be-c36dfc6bb0af', 'медаль');
INSERT INTO gosha.achievements_types VALUES ('c60c7710-3424-4da5-a1d8-9d48c6b48f99', 'юбилейная медаль');
INSERT INTO gosha.achievements_types VALUES ('dd4c6dd7-2c0d-4106-8916-b2c6d0183e1f', 'знак');
INSERT INTO gosha.achievements_types VALUES ('1df6e153-5b07-4443-8451-0846585ba6a2', 'знак отличия');
INSERT INTO gosha.achievements_types VALUES ('f50966c0-6ce5-431b-b155-0427a9a80a74', 'памятный знак');

INSERT INTO gosha.devices VALUES ('b07940a1-c522-4b9c-90ba-771c6869d2d7', 'Десантный метео комплект');
INSERT INTO gosha.devices VALUES ('c7237b8d-8b89-46ed-a774-f0c7f4ff7e32', 'Ветровое ружьё');

INSERT INTO gosha.history VALUES ('51454263-3456-453d-a3f4-ee8bb373451d', '1fae05b2-3c7c-4faf-9d45-1393e6107166', '50f94903-a2f1-4992-81e2-e17659550494', '2025-02-03 13:56:27.489842+00', 36.66, 60.02, 'c7237b8d-8b89-46ed-a774-f0c7f4ff7e32');

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

INSERT INTO gosha.users VALUES ('1fae05b2-3c7c-4faf-9d45-1393e6107166', 'e479b4ae-1366-4250-8a26-33078c554bc7', 'Воловиков Александр Сергеевич', 45);

INSERT INTO gosha.users_achievs VALUES ('9d1335dc-f770-4cec-b9f7-e327589aae92', 'bcad8097-00a5-4714-8e90-346a672d0313', '1fae05b2-3c7c-4faf-9d45-1393e6107166');
INSERT INTO gosha.users_achievs VALUES ('681d8f50-c3a9-41fc-b12e-bca78a6418cc', 'a415c9c0-123f-405c-a9c6-6b37eba833f1', '1fae05b2-3c7c-4faf-9d45-1393e6107166');




ALTER TABLE ONLY gosha.users_achievs
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY gosha.achievements
    ADD CONSTRAINT achievements_pkey1 PRIMARY KEY (id);
ALTER TABLE ONLY gosha.achievements_types
    ADD CONSTRAINT achievements_types_pkey PRIMARY KEY (id);
ALTER TABLE ONLY gosha.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);
ALTER TABLE ONLY gosha.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);
ALTER TABLE ONLY gosha.inputs
    ADD CONSTRAINT inputs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY gosha.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY gosha.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

