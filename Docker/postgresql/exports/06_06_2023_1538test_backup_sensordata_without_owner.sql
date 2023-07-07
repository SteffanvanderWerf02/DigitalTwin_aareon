--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg110+1)
-- Dumped by pg_dump version 15.2

-- Started on 2023-05-24 13:32:41 UTC

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

--
-- TOC entry 3438 (class 1262 OID 16385)
-- Name: aareon_dt; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE aareon_dt WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


\connect aareon_dt

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

--
-- TOC entry 3439 (class 0 OID 0)
-- Name: aareon_dt; Type: DATABASE PROPERTIES; Schema: -; Owner: -
--

ALTER DATABASE aareon_dt SET search_path TO 'public', 'dt_emmen';


\connect aareon_dt

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

--
-- TOC entry 6 (class 2615 OID 16386)
-- Name: dt_emmen; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA dt_emmen;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16387)
-- Name: building; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.building (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(50) NOT NULL,
    company character varying(20) NOT NULL,
    image_path character varying(255),
    map_path character varying(255),
    retention_period integer DEFAULT 28 NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16391)
-- Name: building_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: -
--

CREATE SEQUENCE dt_emmen.building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 216
-- Name: building_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: -
--

ALTER SEQUENCE dt_emmen.building_id_seq OWNED BY dt_emmen.building.id;


--
-- TOC entry 217 (class 1259 OID 16392)
-- Name: data_type; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.data_type (
    id integer NOT NULL,
    type text NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 16397)
-- Name: data_type_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: -
--

CREATE SEQUENCE dt_emmen.data_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 218
-- Name: data_type_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: -
--

ALTER SEQUENCE dt_emmen.data_type_id_seq OWNED BY dt_emmen.data_type.id;


--
-- TOC entry 219 (class 1259 OID 16398)
-- Name: role; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.role (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16401)
-- Name: role_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: -
--

CREATE SEQUENCE dt_emmen.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 220
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: -
--

ALTER SEQUENCE dt_emmen.role_id_seq OWNED BY dt_emmen.role.id;


--
-- TOC entry 221 (class 1259 OID 16402)
-- Name: room; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.room (
    building_id integer NOT NULL,
    room_number character varying(10) NOT NULL,
    coordinates character varying(512) NOT NULL,
    image_path character varying(255),
    name character varying(50) NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 16405)
-- Name: sensor; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor (
    room_number character varying(50) NOT NULL,
    friendlyname character varying(20) DEFAULT 'K0000'::character varying NOT NULL,
    serial_number character varying(50),
    type_id integer
);


--
-- TOC entry 223 (class 1259 OID 16409)
-- Name: sensor_co2_data_lora; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor_co2_data_lora (
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    "lowBattery" boolean,
    "hardwareError" boolean NOT NULL,
    temperature double precision NOT NULL,
    huminity double precision NOT NULL,
    co2 double precision NOT NULL
  
);


--
-- TOC entry 224 (class 1259 OID 16413)
-- Name: sensor_co2_data_zigbee; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor_co2_data_zigbee (
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    state boolean NOT NULL,
    temperature double precision NOT NULL,
    huminity double precision NOT NULL,
    co2 double precision NOT NULL,
    battery_low boolean,
    battery boolean
);


--
-- TOC entry 225 (class 1259 OID 16417)
-- Name: sensor_facilitor; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor_facilitor (
    id integer NOT NULL,
    sensor_id text NOT NULL,
    facilitor_id integer NOT NULL,
    data_type_id integer NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 16422)
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: -
--

CREATE SEQUENCE dt_emmen.sensor_facilitor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 226
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: -
--

ALTER SEQUENCE dt_emmen.sensor_facilitor_id_seq OWNED BY dt_emmen.sensor_facilitor.id;


--
-- TOC entry 227 (class 1259 OID 16423)
-- Name: sensor_motion_data_zigbee; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor_motion_data_zigbee (
    occupied boolean NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    battery_percentage integer NOT NULL,
    state boolean,
    temperature double precision NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 16427)
-- Name: sensor_type; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor_type (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16432)
-- Name: sensor_type_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: -
--

CREATE SEQUENCE dt_emmen.sensor_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 229
-- Name: sensor_type_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: -
--

ALTER SEQUENCE dt_emmen.sensor_type_id_seq OWNED BY dt_emmen.sensor_type.id;


--
-- TOC entry 230 (class 1259 OID 16433)
-- Name: sensor_water_data_lora; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen.sensor_water_data_lora (
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    "hardwareError" boolean NOT NULL,
    "lowBattery" boolean NOT NULL,
    "channelValue" integer NOT NULL,
    "currentState" boolean NOT NULL,
    "previousFrameState" boolean NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 16437)
-- Name: user; Type: TABLE; Schema: dt_emmen; Owner: -
--

CREATE TABLE dt_emmen."user" (
    mail character varying(60) NOT NULL,
    role_id integer NOT NULL,
    password character varying(100) NOT NULL,
    mfa_token character varying(20) DEFAULT NULL::character varying,
    username character varying(50) NOT NULL
);


--
-- TOC entry 3225 (class 2604 OID 16441)
-- Name: building id; Type: DEFAULT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.building ALTER COLUMN id SET DEFAULT nextval('dt_emmen.building_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 16442)
-- Name: data_type id; Type: DEFAULT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.data_type ALTER COLUMN id SET DEFAULT nextval('dt_emmen.data_type_id_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 16443)
-- Name: role id; Type: DEFAULT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.role ALTER COLUMN id SET DEFAULT nextval('dt_emmen.role_id_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 16444)
-- Name: sensor_facilitor id; Type: DEFAULT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor ALTER COLUMN id SET DEFAULT nextval('dt_emmen.sensor_facilitor_id_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 16445)
-- Name: sensor_type id; Type: DEFAULT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_type ALTER COLUMN id SET DEFAULT nextval('dt_emmen.sensor_type_id_seq'::regclass);


--
-- TOC entry 3416 (class 0 OID 16387)
-- Dependencies: 215
-- Data for Name: building; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.building (id, name, type, company, image_path, map_path, retention_period) VALUES (1, 'Aareon Emmen', 'Kantoor', 'Aareon', '/images/buildings/1/emmen.jpg', '/images/maps/1/aareonmap.png', 28);
INSERT INTO dt_emmen.building (id, name, type, company, image_path, map_path, retention_period) VALUES (2, 'Aareon Amsterdam', 'Kantoor', 'Aareon', '/images/buildings/2/amsterdam.jpg', '/images/maps/2/coengebouw.png', 35);

--
-- TOC entry 3418 (class 0 OID 16392)
-- Dependencies: 217
-- Data for Name: data_type; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.data_type (id, type) VALUES (1, 'BEZ');
INSERT INTO dt_emmen.data_type (id, type) VALUES (2, 'TEMP');
INSERT INTO dt_emmen.data_type (id, type) VALUES (3, 'CO2');
INSERT INTO dt_emmen.data_type (id, type) VALUES (4, 'BAT');


--
-- TOC entry 3420 (class 0 OID 16398)
-- Dependencies: 219
-- Data for Name: role; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.role (id, name) VALUES (1, 'Standard');
INSERT INTO dt_emmen.role (id, name) VALUES (2, 'Administrator');


--
-- TOC entry 3422 (class 0 OID 16402)
-- Dependencies: 221
-- Data for Name: room; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K64', '9,8 93,8 93,60 72,60 72,95 27,93 27,61 9,61', '/images/rooms/K64/K64.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K64-SUB', '9,61 27,61 27,93 9,93', '/images/rooms/K64-SUB/K64-SUB.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K63', '93,8 218,8 218,68 185,59 93,59', '/images/rooms/K63/K63.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K62', '256,8 301,8 301,73 245,73 218,68 218,32 256,32', '/images/rooms/K62/K62.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K62-SUB', '218,8 256,8 256,32 218,32', '/images/rooms/K62-SUB/K62-SUB.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K61', '301,8 383,8 383,73 301,73', '/images/rooms/K61/K61.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K60', '421,8 448,8 448,91 383,91 383,33 421,33', '/images/rooms/K60/K60.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K60-SUB', '383,8 421,8 421,33 383,33', '/images/rooms/K60-SUB/K60-SUB.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K9', '42,110 76,110 76,178 42,178', '/images/rooms/K9/K9.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K10', '42,178 76,178 76,220 42,220', '/images/rooms/K10/K10.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K11', '42,220 76,220 76,262 42,262', '/images/rooms/K11/K11.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K12', '42,262 76,262 76,304 42,304', '/images/rooms/K12/K12.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K13', '42,304 76,304 76,346 42,346', '/images/rooms/K13/K13.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K14', '9,346 42,346 42,397 9,397', '/images/rooms/K14/K14.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K15', '9,397 51,397 51,431 9,431', '/images/rooms/K15/K15.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K16', '51,397 92,397 92,431 51,431', '/images/rooms/K16/K16.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K27', '92,397 128,397 128,431 92,431', '/images/rooms/K27/K27.jpg', 'Repro');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K6', '93,136 126,136 126,178 93,178', '/images/rooms/K6/K6.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K5', '93,178 126,178 126,220 93,220', '/images/rooms/K5/K5.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K4', '93,220 126,220 126,262 93,262', '/images/rooms/K4/K4.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K3', '93,262 126,262 126,304 93,304', '/images/rooms/K3/K3.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K2', '93,304 126,304 126,346 93,346', '/images/rooms/K2/K2.jpg', 'Eniaczaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K1', '93,346 139,346 139,379 102,379 93,368', '/images/rooms/K1/K1.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K23-24', '245,136 295,136 295,220 245,220', '/images/rooms/K23-24/K23-24.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K25', '245,220 295,220 295,261 245,261', '/images/rooms/K25/K25.jpg', 'Designlab XL');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K26', '245,261 295,261 295,304 245,304', '/images/rooms/K26/K26.jpg', 'Designlab XL');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K51', '245,304 295,304 295,346 245,346', '/images/rooms/K51/K51.jpg', 'Pascalzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K21', '312,137 345,137 345,178 312,178', '/images/rooms/K21/K21.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K20', '312,178 345,178 345,220 312,220', '/images/rooms/K20/K20.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K19', '312,220 345,220 345,262 312,262', '/images/rooms/K19/K19.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K18', '312,262 345,262 345,304 312,304', '/images/rooms/K18/K18.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K17', '312,304 345,304 345,365 312,365', '/images/rooms/K17/K17.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K28', '282,397 296,397 312,379 407,379 422,396 422,431 282,431', '/images/rooms/K28/K28.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K49', '380,346 422,346 422,365 380,365', '/images/rooms/K49/K49.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K47', '456,346 491,346 491,364 456,364', '/images/rooms/K47/K47.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K48', '421,347 421,365 456,365 456,347', '/images/rooms/K48/K48.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K46', '491,346 518,346 518,364 491,364', '/images/rooms/K46/K46.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K29', '422,396 465,396 465,431 422,431', '/images/rooms/K29/K29.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K53', '465,396 474,387 523,387 523,431 465,431', '/images/rooms/K53/K53.jpg', 'Neumannzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K30', '523,395 585,395 585,431 523,431', '/images/rooms/K30/K30.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K31', '585,401 628,401 628,421 621,421 621,431 585,431', '/images/rooms/K31/K31.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K32', '642,401 715,401 715,431 647,431 647,421 642,421', '/images/rooms/K32/K32.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K33', '642,372 680,372 680,401 642,401', '/images/rooms/K33/K33.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K34', '680,372 715,372 715,401 680,401', '/images/rooms/K34/K34.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K36', '642,342 680,342 680,372 642,372', '/images/rooms/K36/K36.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K35', '680,342 715,342 715,372 680,372', '/images/rooms/K35/K35.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K37', '670,312 715,312 715,342 670,342', '/images/rooms/K37/K37.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K38', '670,256 715,256 715,312 670,312', '/images/rooms/K38/K38.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K39', '627,198 671,198 671,254 627,254', '/images/rooms/K39/K39.jpg', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K40', '582,198 627,198 627,254 582,254', '/images/rooms/K40/K40.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K41', '539,198 582,198 582,265 539,265', '/images/rooms/K41/K41.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K42', '539,265 582,265 582,315 539,315', '/images/rooms/K42/K42.jpg', 'Vergaderkamer');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K44', '582,308 628,308 628,343 582,343', '/images/rooms/K44/K44.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K45', '582,343 628,343 628,373 582,373', '/images/rooms/K45/K45.jpg', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K101', '73,477 107,477 107,516 73,516', '/images/rooms/K101/K101.jpg', 'Jacquardzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K102', '9,477 73,477 73,568 9,568', '/images/rooms/K102/K102.jpg', 'Leibnizzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K103', '73,529 143,529 143,568 73,568', '/images/rooms/K103/K103.jpg', 'Hollerithzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'K104', '253,495 333,495 333,568 253,568', '/images/rooms/K104/K104.jpg', 'Studio');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (1, 'outside', '', '', 'outside');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (2, 'R801', '521,212 545,212 545,221 590,221 590,207 609,207 609,221 655,221 655,212 679,212 679,566 520,566', '/images/rooms/R801/R801.png', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (2, 'R802', '582,11 845,11 845,169 756,169 756,80 582,80', '/images/rooms/R802/R802.png', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, image_path, name) VALUES (2, 'R803', '8,11 582,11 582,98 548,98 548,165 8,165', '/images/rooms/R803/R803.png', 'Werkruimte');

-- 
-- TOC entry 3423 (class 0 OID 16405)
-- Dependencies: 222
-- Data for Name: sensor; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K102', 'K102', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K102', 'K102-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K102', 'K102-3', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K103', 'K103', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K103', 'K103-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K11', 'K11', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K12', 'K12', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K15', 'K15', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K16', 'K16', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K18', 'K18', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K2', 'K2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K25', 'K25', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K26', 'K26', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K3', 'K3', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K38', 'K38', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K38', 'K38-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K39', 'K39', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K39', 'K39-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K4', 'K4', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K42', 'K42', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K47', 'K47', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K48', 'K48', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K5', 'K5', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K51', 'K51', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K53', 'K53', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K53', 'K53-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K6', 'K6', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K10', 'K10', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K101', 'K101', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K102', 'K102-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K103', 'K103-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K11', 'K11-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K12', 'K12-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K15', 'K15-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K16', 'K16-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K18', 'K18-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K2', 'K2-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K25', 'K25-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K26', 'K26-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K3', 'K3-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K38', 'K38-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K39', 'K39-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K4', 'K4-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K42', 'K42-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K47', 'K47-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K48', 'K48-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K5', 'K5-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K51', 'K51-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K53', 'K53-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K6', 'K6-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K10', 'K10-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K101', 'K101-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K64', 'K64-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K64', 'K64-2-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K63', 'K63-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K62', 'K62-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K62', 'K62-2-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K61', 'K61-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K60', 'K60-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K60', 'K60-2-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K9', 'K9-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K13', 'K13-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K104', 'K104-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K49', 'K49-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K29', 'K29-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K28', 'K28-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K27', 'K27-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K30', 'K30-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K31', 'K31-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K32', 'K32-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K33', 'K33-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K34', 'K34-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K35', 'K35-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K36', 'K36-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K45', 'K45-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K44', 'K44-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K37', 'K37-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K41', 'K41-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K40', 'K40-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K17', 'K17-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K19', 'K19-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K20', 'K20-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K21', 'K21-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('K24', 'K24-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('outside', '0018B21000008CF1', '', 3);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('outside', '0018B21000008C47', '', 3);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('R801', 'K26-AMS', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('R802', 'K38-AMS', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('R803', 'K102-AMS', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('R801', 'K25-AMS-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('R802', 'K51-AMS-CO2', NULL, 2);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, serial_number, type_id) VALUES ('R803', 'K53-AMS-CO2', NULL, 2);


--
-- TOC entry 3425 (class 0 OID 16413)
-- Dependencies: 224
-- Data for Name: sensor_co2_data_zigbee; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-09 17:08:14.620359', 'K103-CO2', true, 25.79, 39.27, 516, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-09 17:08:14.620359', 'K25-CO2', true, 22.7, 55.9, 359, false, false);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-09 17:08:14.620359', 'K47-CO2', true, 21.53, 48.42, 419, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-09 17:08:14.620359', 'K51-CO2', true, 21.61, 49.77, 589, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-09 17:08:14.620359', 'K53-CO2', true, 22.54, 52.39, 484, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:07:14.620359', 'K25-AMS-CO2', true, 11.98, 51.07, 510, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:07:14.620359', 'K51-AMS-CO2', true, 25.91, 33.21, 347, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:07:14.620359', 'K53-AMS-CO2', true, 28.01, 38.96, 599, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:17:14.620359', 'K25-AMS-CO2', true, 21.53, 48.42, 419, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:17:14.620359', 'K51-AMS-CO2', true, 21.61, 49.77, 589, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:17:14.620359', 'K53-AMS-CO2', true, 22.54, 52.39, 484, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:27:14.620359', 'K25-AMS-CO2', true, 21.53, 40.27, 349, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:27:14.620359', 'K51-AMS-CO2', true, 21.61, 39.81, 471, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:27:14.620359', 'K53-AMS-CO2', true, 22.82, 53.45, 501, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:37:14.620359', 'K25-AMS-CO2', true, 11.21, 51.07, 495, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:37:14.620359', 'K51-AMS-CO2', true, 25.91, 33.21, 463, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:37:14.620359', 'K53-AMS-CO2', true, 28.01, 38.96, 545, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:47:14.620359', 'K25-AMS-CO2', true, 21.53, 48.42, 493, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:47:14.620359', 'K51-AMS-CO2', true, 21.61, 49.77, 435, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:47:14.620359', 'K53-AMS-CO2', true, 22.54, 52.39, 455, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:57:14.620359', 'K25-AMS-CO2', true, 18.62, 40.27, 534, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:57:14.620359', 'K51-AMS-CO2', true, 21.61, 39.81, 346, false, true);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, state, temperature, huminity, co2, battery_low, battery) VALUES ('2023-06-12 15:57:14.620359', 'K53-AMS-CO2', true, 22.54, 53.45, 467, false, true);


--
-- TOC entry 3426 (class 0 OID 16417)
-- Dependencies: 225
-- Data for Name: sensor_facilitor; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (1, 'K10', 18661, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (2, 'K10', 18641, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (3, 'K101', 18670, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (4, 'K101', 18662, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (5, 'K102', 18664, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (6, 'K102', 18671, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (7, 'K103', 18665, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (8, 'K103', 18672, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (11, 'K11', 18666, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (12, 'K11', 18674, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (13, 'K12', 18667, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (14, 'K12', 18675, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (15, 'K15', 18669, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (16, 'K15', 18677, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (17, 'K16', 18673, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (18, 'K16', 18680, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (19, 'K18', 18676, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (20, 'K18', 18681, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (21, 'K2', 18679, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (22, 'K2', 18721, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (23, 'K25', 18682, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (24, 'K25', 18683, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (25, 'K26', 18684, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (26, 'K26', 18685, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (27, 'K3', 18687, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (28, 'K3', 18686, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (29, 'K38', 18689, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (30, 'K38', 18688, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (31, 'K39', 18691, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (32, 'K39', 18690, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (33, 'K4', 18722, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (34, 'K4', 18692, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (35, 'K42', 18693, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (36, 'K42', 18694, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (37, 'K47', 18696, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (38, 'K47', 18695, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (39, 'K48', 18698, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (40, 'K48', 18697, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (41, 'K5', 18701, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (42, 'K5', 18699, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (43, 'K51', 18703, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (44, 'K51', 18700, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (45, 'K53', 18705, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (46, 'K53', 18702, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (47, 'K6', 18706, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (48, 'K6', 18704, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (49, 'K102-2', 18741, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (50, 'K102-2', 18747, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (51, 'K102-3', 18742, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (52, 'K102-3', 18748, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (53, 'K103-2', 18743, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (54, 'K103-2', 18749, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (55, 'K38-2', 18744, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (56, 'K38-2', 18750, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (57, 'K39-2', 18745, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (58, 'K39-2', 18751, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (59, 'K53-2', 18746, 1);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (60, 'K53-2', 18752, 2);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (61, 'K102-CO2', 18761, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (62, 'K103-CO2', 18763, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (63, 'K11-CO2', 18813, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (64, 'K12-CO2', 18815, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (65, 'K15-CO2', 18765, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (66, 'K16-CO2', 18766, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (67, 'K18-CO2', 18809, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (68, 'K2-CO2', 18802, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (69, 'K25-CO2', 18817, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (70, 'K26-CO2', 18810, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (71, 'K3-CO2', 18814, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (72, 'K38-CO2', 18796, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (73, 'K39-CO2', 18797, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (74, 'K4-CO2', 18816, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (75, 'K42-CO2', 18795, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (76, 'K47-CO2', 18782, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (77, 'K48-CO2', 18781, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (78, 'K5-CO2', 18807, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (79, 'K51-CO2', 18804, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (80, 'K53-CO2', 18773, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (81, 'K6-CO2', 18799, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (82, 'K10-CO2', 18805, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (83, 'K101-CO2', 18762, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (84, 'K64-CO2', 18770, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (85, 'K63-CO2', 18775, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (86, 'K62-CO2', 18777, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (87, 'K62-2-CO2', 18778, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (88, 'K61-CO2', 18780, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (89, 'K60-CO2', 18784, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (90, 'K60-2-CO2', 18786, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (91, 'K9-CO2', 18790, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (92, 'K13-CO2', 18801, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (93, 'K104-CO2', 18764, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (94, 'K49-CO2', 18779, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (95, 'K29-CO2', 18772, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (96, 'K28-CO2', 18769, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (97, 'K27-CO2', 18768, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (98, 'K30-CO2', 18774, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (99, 'K31-CO2', 18783, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (100, 'K32-CO2', 18785, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (101, 'K33-CO2', 18787, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (102, 'K34-CO2', 18788, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (103, 'K35-CO2', 18792, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (104, 'K36-CO2', 18791, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (105, 'K45-CO2', 18789, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (106, 'K44-CO2', 18794, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (107, 'K37-CO2', 18793, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (108, 'K41-CO2', 18800, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (109, 'K40-CO2', 18798, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (110, 'K17-CO2', 18806, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (111, 'K19-CO2', 18818, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (112, 'K20-CO2', 18811, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (113, 'K21-CO2', 18803, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (114, 'K24-CO2', 18808, 3);
INSERT INTO dt_emmen.sensor_facilitor (id, sensor_id, facilitor_id, data_type_id) VALUES (115, 'K64-2-CO2', 18771, 3);


--
-- TOC entry 3428 (class 0 OID 16423)
-- Dependencies: 227
-- Data for Name: sensor_motion_data_zigbee; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K102', 100, true, 24.6);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-09 17:08:14.593152', 'K102-2', 100, true, 24.6);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K102-3', 100, true, 24.86);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K103', 100, true, 25.61);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K103-2', 100, true, 26.37);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K11', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K12', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K15', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K16', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K18', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K2', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-09 17:08:14.593152', 'K25', 100, true, 22.58);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-09 17:08:14.593152', 'K26', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K3', 100, true, 22.58);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K38', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K38-2', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K39', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K4', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-09 17:08:14.593152', 'K42', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K47', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K48', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K5', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K51', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K53', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K53-2', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K6', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-09 17:08:14.593152', 'K10', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-09 17:08:14.593152', 'K101', 100, true, 16.5);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:07:14.620359', 'K26-AMS', 100, true, 24.91);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:07:14.620359', 'K38-AMS', 100, true, 22.23);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:07:14.620359', 'K102-AMS', 100, true, 18.7);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:17:14.620359', 'K26-AMS', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:17:14.620359', 'K38-AMS', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:17:14.620359', 'K102-AMS', 100, true, 16.5);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:27:14.620359', 'K26-AMS', 100, true, 17.41);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:27:14.620359', 'K38-AMS', 100, true, 19.21);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:27:14.620359', 'K102-AMS', 100, true, 23.64);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:37:14.620359', 'K26-AMS', 100, true, 11.21);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:37:14.620359', 'K38-AMS', 100, true, 25.91);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:37:14.620359', 'K102-AMS', 100, true, 28.01);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:47:14.620359', 'K26-AMS', 100, true, 21.93);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:47:14.620359', 'K38-AMS', 100, true, 27.64);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:47:14.620359', 'K102-AMS', 100, true, 19.74);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:57:14.620359', 'K26-AMS', 100, true, 24.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-06-12 15:57:14.620359', 'K38-AMS', 100, true, 29.99);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-06-12 15:57:14.620359', 'K102-AMS', 100, true, 25.79);
--
-- TOC entry 3429 (class 0 OID 16427)
-- Dependencies: 228
-- Data for Name: sensor_type; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.sensor_type (id, name) VALUES (1, 'motion_zigbee');
INSERT INTO dt_emmen.sensor_type (id, name) VALUES (2, 'co2_zigbee');
INSERT INTO dt_emmen.sensor_type (id, name) VALUES (3, 'co2_lora');
INSERT INTO dt_emmen.sensor_type (id, name) VALUES (4, 'water_lora');


--
-- TOC entry 3431 (class 0 OID 16433)
-- Dependencies: 230
-- Data for Name: sensor_water_data_lora; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--



--
-- TOC entry 3432 (class 0 OID 16437)
-- Dependencies: 231
-- Data for Name: user; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('arie.vanderdeijl@aareon.nl', 2, '8c6c2cdcb8ba954497b7015629c79009e7868a4c514e65f29afe1e432ccff63d', '', 'Arie');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('elles.heller@aareon.nl', 1, '277439cb66a5f28b5b5f841ff29e928832bc40cae59bca742fb78eedd943d03a', '', 'Elles');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('geke.harmers@aareon.nl', 1, '293a2364667cda460832f32182a80aeb0c133684f347b71f61fefba7db157af3', NULL, 'Geke');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel.disbergen@student.nhlstenden.com', 1, '644a59768537372a04ea6d6e458af1974bf2a01fb6600a199d7cb8e57e8aa4c5', '', 'Michel');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel.tentij@aareon.nl', 2, '2c380500759ff84454e258050913385157d683857918125c4d8f1bb6d31daa68', NULL, 'Michel Tentij');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('steffan.van.der.werf@student.nhlstenden.com', 2, '4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2', '', 'Steffan');


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 216
-- Name: building_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.building_id_seq', 1, true);


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 218
-- Name: data_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.data_type_id_seq', 4, true);


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 220
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.role_id_seq', 2, true);


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 226
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.sensor_facilitor_id_seq', 60, true);


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 229
-- Name: sensor_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.sensor_type_id_seq', 4, true);


--
-- TOC entry 3240 (class 2606 OID 16447)
-- Name: data_type data_type_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.data_type
    ADD CONSTRAINT data_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 16449)
-- Name: building idx_16392_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.building
    ADD CONSTRAINT idx_16392_primary PRIMARY KEY (id);


--
-- TOC entry 3242 (class 2606 OID 16451)
-- Name: role idx_16398_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.role
    ADD CONSTRAINT idx_16398_primary PRIMARY KEY (id);


--
-- TOC entry 3245 (class 2606 OID 16453)
-- Name: room idx_16402_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.room
    ADD CONSTRAINT idx_16402_primary PRIMARY KEY (room_number);


--
-- TOC entry 3247 (class 2606 OID 16455)
-- Name: sensor idx_16405_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT idx_16405_primary PRIMARY KEY (friendlyname);


--
-- TOC entry 3256 (class 2606 OID 16457)
-- Name: sensor_motion_data_zigbee idx_16409_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_motion_data_zigbee
    ADD CONSTRAINT idx_16409_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3252 (class 2606 OID 16459)
-- Name: sensor_co2_data_zigbee idx_16410_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_zigbee
    ADD CONSTRAINT idx_16410_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3250 (class 2606 OID 16461)
-- Name: sensor_co2_data_lora idx_16411_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_lora
    ADD CONSTRAINT idx_16411_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3260 (class 2606 OID 16463)
-- Name: sensor_water_data_lora idx_16412_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_water_data_lora
    ADD CONSTRAINT idx_16412_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3262 (class 2606 OID 16465)
-- Name: user idx_16413_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen."user"
    ADD CONSTRAINT idx_16413_primary PRIMARY KEY (mail);


--
-- TOC entry 3254 (class 2606 OID 16467)
-- Name: sensor_facilitor sensor_facilitor_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT sensor_facilitor_pkey PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 16469)
-- Name: sensor_type sensor_type_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_type
    ADD CONSTRAINT sensor_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3243 (class 1259 OID 16470)
-- Name: idx_16402_building_id; Type: INDEX; Schema: dt_emmen; Owner: -
--

CREATE INDEX idx_16402_building_id ON dt_emmen.room USING btree (building_id);


--
-- TOC entry 3248 (class 1259 OID 16471)
-- Name: idx_16405_sensor_room; Type: INDEX; Schema: dt_emmen; Owner: -
--

CREATE INDEX idx_16405_sensor_room ON dt_emmen.sensor USING btree (room_number);


--
-- TOC entry 3263 (class 1259 OID 16472)
-- Name: idx_16413_user_role; Type: INDEX; Schema: dt_emmen; Owner: -
--

CREATE INDEX idx_16413_user_role ON dt_emmen."user" USING btree (role_id);


--
-- TOC entry 3264 (class 2606 OID 16473)
-- Name: room room_building_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.room
    ADD CONSTRAINT "room_building_FK" FOREIGN KEY (building_id) REFERENCES dt_emmen.building(id) NOT VALID;


--
-- TOC entry 3271 (class 2606 OID 16478)
-- Name: sensor_motion_data_zigbee sensorMotionData_sensor_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_motion_data_zigbee
    ADD CONSTRAINT "sensorMotionData_sensor_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname)ON DELETE CASCADE;



--
-- TOC entry 3269 (class 2606 OID 16483)
-- Name: sensor_facilitor sensorToFacilitor_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT "sensorToFacilitor_FK" FOREIGN KEY (sensor_id) REFERENCES dt_emmen.sensor(friendlyname) ON DELETE CASCADE;


--
-- TOC entry 3267 (class 2606 OID 16488)
-- Name: sensor_co2_data_lora sensor_co2_data_lora_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_lora
    ADD CONSTRAINT "sensor_co2_data_lora_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname) ON DELETE CASCADE;


--
-- TOC entry 3268 (class 2606 OID 16493)
-- Name: sensor_co2_data_zigbee sensor_co2_data_zigbee_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_zigbee
    ADD CONSTRAINT "sensor_co2_data_zigbee_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname) ON DELETE CASCADE;


--
-- TOC entry 3270 (class 2606 OID 16498)
-- Name: sensor_facilitor sensor_data_type_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT "sensor_data_type_FK" FOREIGN KEY (data_type_id) REFERENCES dt_emmen.data_type(id);


--
-- TOC entry 3265 (class 2606 OID 16503)
-- Name: sensor sensor_room_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT "sensor_room_FK" FOREIGN KEY (room_number) REFERENCES dt_emmen.room(room_number) NOT VALID;


--
-- TOC entry 3266 (class 2606 OID 16508)
-- Name: sensor sensor_type_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT "sensor_type_FK" FOREIGN KEY (type_id) REFERENCES dt_emmen.sensor_type(id) NOT VALID;


--
-- TOC entry 3272 (class 2606 OID 16513)
-- Name: sensor_water_data_lora sensor_water_data_lora_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen.sensor_water_data_lora
    ADD CONSTRAINT "sensor_water_data_lora_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname) ON DELETE CASCADE;


--
-- TOC entry 3273 (class 2606 OID 16518)
-- Name: user user_role_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: -
--

ALTER TABLE ONLY dt_emmen."user"
    ADD CONSTRAINT "user_role_FK" FOREIGN KEY (role_id) REFERENCES dt_emmen.role(id) NOT VALID;


-- Completed on 2023-05-24 13:32:41 UTC

--
-- PostgreSQL database dump complete
--

