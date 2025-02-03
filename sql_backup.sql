--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Debian 16.6-1.pgdg120+1)
-- Dumped by pg_dump version 16.6

-- Started on 2025-02-03 14:17:04 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

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
--
-- TOC entry 6 (class 2615 OID 16416)
-- Name: gosha; Type: SCHEMA; Schema: -; Owner: study
--

CREATE SCHEMA gosha;


ALTER SCHEMA gosha OWNER TO study;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16460)
-- Name: achievements; Type: TABLE; Schema: gosha; Owner: study
--

CREATE TABLE gosha.achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_id uuid NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE gosha.achievements OWNER TO study;

--
-- TOC entry 223 (class 1259 OID 16466)
-- Name: achievements_types; Type: TABLE; Schema: gosha; Owner: study
--

CREATE TABLE gosha.achievements_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE gosha.achievements_types OWNER TO study;

--
-- TOC entry 216 (class 1259 OID 16417)
-- Name: devices; Type: TABLE; Schema: gosha; Owner: study
--

CREATE TABLE gosha.devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE gosha.devices OWNER TO study;

--
-- TOC entry 217 (class 1259 OID 16421)
-- Name: history; Type: TABLE; Schema: gosha; Owner: study
--

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

--
-- TOC entry 218 (class 1259 OID 16426)
-- Name: inputs; Type: TABLE; Schema: gosha; Owner: study
--

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

--
-- TOC entry 219 (class 1259 OID 16430)
-- Name: posts; Type: TABLE; Schema: gosha; Owner: study
--

CREATE TABLE gosha.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE gosha.posts OWNER TO study;

--
-- TOC entry 220 (class 1259 OID 16434)
-- Name: users; Type: TABLE; Schema: gosha; Owner: study
--

CREATE TABLE gosha.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post uuid NOT NULL,
    fullname character varying(100) NOT NULL,
    age integer NOT NULL
);


ALTER TABLE gosha.users OWNER TO study;

--
-- TOC entry 221 (class 1259 OID 16448)
-- Name: users_achievs; Type: TABLE; Schema: gosha; Owner: study
--

CREATE TABLE gosha.users_achievs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    achievement_id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE gosha.users_achievs OWNER TO study;

--
-- TOC entry 3405 (class 0 OID 16460)
-- Dependencies: 222
-- Data for Name: achievements; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.achievements VALUES ('bcad8097-00a5-4714-8e90-346a672d0313', '65e6d057-d0f7-48a4-83be-c36dfc6bb0af', 'За боевые отличия');
INSERT INTO gosha.achievements VALUES ('a415c9c0-123f-405c-a9c6-6b37eba833f1', 'c60c7710-3424-4da5-a1d8-9d48c6b48f99', '100 лет Военно-воздушной академии имени профессора Н. Е. Жуковского и Ю. А. Гагарина');
INSERT INTO gosha.achievements VALUES ('13ef800c-e380-4538-b54c-66479435728e', '1df6e153-5b07-4443-8451-0846585ba6a2', 'Юридическая служба Вооружённых Сил Российской Федерации');
INSERT INTO gosha.achievements VALUES ('a555798e-b403-439b-a193-cd9ba2f9af13', 'f50966c0-6ce5-431b-b155-0427a9a80a74', '50 лет Главному управлению глубоководных исследований');


--
-- TOC entry 3406 (class 0 OID 16466)
-- Dependencies: 223
-- Data for Name: achievements_types; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.achievements_types VALUES ('65e6d057-d0f7-48a4-83be-c36dfc6bb0af', 'медаль');
INSERT INTO gosha.achievements_types VALUES ('c60c7710-3424-4da5-a1d8-9d48c6b48f99', 'юбилейная медаль');
INSERT INTO gosha.achievements_types VALUES ('dd4c6dd7-2c0d-4106-8916-b2c6d0183e1f', 'знак');
INSERT INTO gosha.achievements_types VALUES ('1df6e153-5b07-4443-8451-0846585ba6a2', 'знак отличия');
INSERT INTO gosha.achievements_types VALUES ('f50966c0-6ce5-431b-b155-0427a9a80a74', 'памятный знак');


--
-- TOC entry 3399 (class 0 OID 16417)
-- Dependencies: 216
-- Data for Name: devices; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.devices VALUES ('b07940a1-c522-4b9c-90ba-771c6869d2d7', 'Десантный метео комплект');
INSERT INTO gosha.devices VALUES ('c7237b8d-8b89-46ed-a774-f0c7f4ff7e32', 'Ветровое ружьё');


--
-- TOC entry 3400 (class 0 OID 16421)
-- Dependencies: 217
-- Data for Name: history; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.history VALUES ('51454263-3456-453d-a3f4-ee8bb373451d', '1fae05b2-3c7c-4faf-9d45-1393e6107166', '50f94903-a2f1-4992-81e2-e17659550494', '2025-02-03 13:56:27.489842+00', 36.66, 60.02, 'c7237b8d-8b89-46ed-a774-f0c7f4ff7e32');


--
-- TOC entry 3401 (class 0 OID 16426)
-- Dependencies: 218
-- Data for Name: inputs; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.inputs VALUES ('50f94903-a2f1-4992-81e2-e17659550494', 100.00, 26.50, 750.00, 5.00, 0.20, 460.00);


--
-- TOC entry 3402 (class 0 OID 16430)
-- Dependencies: 219
-- Data for Name: posts; Type: TABLE DATA; Schema: gosha; Owner: study
--

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


--
-- TOC entry 3403 (class 0 OID 16434)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.users VALUES ('1fae05b2-3c7c-4faf-9d45-1393e6107166', 'e479b4ae-1366-4250-8a26-33078c554bc7', 'Воловиков Александр Сергеевич', 45);


--
-- TOC entry 3404 (class 0 OID 16448)
-- Dependencies: 221
-- Data for Name: users_achievs; Type: TABLE DATA; Schema: gosha; Owner: study
--

INSERT INTO gosha.users_achievs VALUES ('9d1335dc-f770-4cec-b9f7-e327589aae92', 'bcad8097-00a5-4714-8e90-346a672d0313', '1fae05b2-3c7c-4faf-9d45-1393e6107166');
INSERT INTO gosha.users_achievs VALUES ('681d8f50-c3a9-41fc-b12e-bca78a6418cc', 'a415c9c0-123f-405c-a9c6-6b37eba833f1', '1fae05b2-3c7c-4faf-9d45-1393e6107166');


--
-- TOC entry 3251 (class 2606 OID 16452)
-- Name: users_achievs achievements_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.users_achievs
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 3253 (class 2606 OID 16465)
-- Name: achievements achievements_pkey1; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.achievements
    ADD CONSTRAINT achievements_pkey1 PRIMARY KEY (id);


--
-- TOC entry 3255 (class 2606 OID 16470)
-- Name: achievements_types achievements_types_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.achievements_types
    ADD CONSTRAINT achievements_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3241 (class 2606 OID 16447)
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- TOC entry 3243 (class 2606 OID 16445)
-- Name: history history_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 3245 (class 2606 OID 16443)
-- Name: inputs inputs_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.inputs
    ADD CONSTRAINT inputs_pkey PRIMARY KEY (id);


--
-- TOC entry 3247 (class 2606 OID 16439)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3249 (class 2606 OID 16441)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: gosha; Owner: study
--

ALTER TABLE ONLY gosha.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


-- Completed on 2025-02-03 14:17:04 UTC

--
-- PostgreSQL database dump complete
--

