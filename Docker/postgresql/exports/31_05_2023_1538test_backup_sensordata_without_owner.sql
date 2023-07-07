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
    coordinates character varying(100) NOT NULL,
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
    battery_percentage integer,
    state boolean NOT NULL,
    temperature double precision NOT NULL,
    huminity double precision NOT NULL,
    co2 double precision NOT NULL
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

INSERT INTO dt_emmen.building (id, name, type, company, image_path, retention_period) VALUES (1, 'Aareon Emmen', 'Kantoor', 'Aareon', '/images/buildings/1/emmen.jpg', 28);


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

INSERT INTO dt_emmen.role (id, name) VALUES (1, 'standard');
INSERT INTO dt_emmen.role (id, name) VALUES (2, 'administrator');


--
-- TOC entry 3422 (class 0 OID 16402)
-- Dependencies: 221
-- Data for Name: room; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K64', '47,8 131,8 131,60 110,60 110,95 65,93 65,61 47,61', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K64-SUB', '47,61 65,61 65,93 47,93', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K63', '131,8 256,8 256,68 223,59 131,59', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K62', '294,8 339,8 339,73 283,73 256,68 256,32 294,32', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K62-SUB', '256,8 294,8 294,32 256,32', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K61', '339,8 421,8 421,73 339,73', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K60', '459,8 486,8 486,91 421,91 421,33 459,33', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K60-SUB', '421,8 459,8 459,33 421,33', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K9', '80,110 114,110 114,178 80,178', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K10', '80,178 114,178 114,220 80,220', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K11', '80,220 114,220 114,262 80,262', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K12', '80,262 114,262 114,304 80,304', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K13', '80,304 114,304 114,346 80,346', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K14', '47,346 80,346 80,397 47,397', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K15', '47,379 89,379 89,431 47,431', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K16', '89,397 130,397 130,431 89,431', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K27', '130,397 166,397 166,431 130,431', 'Repro');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K6', '131,136 164,136 164,178 131,178', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K5', '131,178 164,178 164,220 131,220', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K4', '131,220 164,220 164,262 131,262', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K3', '131,262 164,262 164,304 131,304', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K2', '131,304 164,304 164,346 131,346', 'Eniaczaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K1', '131,346 177,346 177,379 140,379 131,368', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K23-24', '283,136 333,136 333,220 283,220', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K25', '283,220 333,220 333,261 283,261', 'Designlab XL');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K26', '283,261 333,261 333,304 283,304', 'Designlab XL');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K51', '283,304 333,304 333,346 283,346', 'Pascalzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K21', '350,137 383,137 383,178 350,178', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K20', '350,178 383,178 383,220 350,220', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K19', '350,220 383,220 383,262 350,262', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K18', '350,262 383,262 383,304 350,304', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K17', '350,304 383,304 383,365 350,365', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K28', '320,397 334,397 350,379 445,379 460,396 460,431 320,431', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K49', '418,346 460,346 460,365 418,365', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K47', '494,346 529,346 529,364 494,364', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K48', '459,347 459,365 494,365 494,347', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K46', '529,346 556,346 556,364 529,364', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K29', '460,396 503,396 503,431 460,431', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K53', '503,396 512,387 561,387 561,431 503,431', 'Neumannzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K30', '561,395 623,395 623,431 561,431', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K31', '623,401 666,401 666,421 659,421 659,431 623,431', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K32', '680,401 753,401 753,431 685,431 685,421 680,421', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K33', '680,372 718,372 718,401 680,401', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K34', '718,372 753,372 753,401 718,401', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K36', '680,342 718,342 718,372 680,372', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K35', '718,342 753,342 753,372 718,372', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K37', '708,312 753,312 753,342 708,342', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K38', '708,256 753,256 753,312 708,312', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K39', '665,198 709,198 709,254 665,254', 'Flexruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K40', '620,198 665,198 665,254 620,254', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K41', '577,198 620,198 620,265 577,265', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K42', '577,265 620,265 620,315 577,315', 'Vergaderkamer');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K44', '620,308 666,308 666,343 620,343', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K45', '620,343 666,343 666,373 620,373', 'Werkruimte');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K101', '111,477 145,477 145,516 111,516', 'Jacquardzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K102', '47,477 111,477 111,568 47,568', 'Leibnizzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K103', '111,529 181,529 181,568 111,568', 'Hollerithzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, '2.09', '289,495 369,495 369,568 289,568', 'Studio');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'outside', '', 'outside');


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


--
-- TOC entry 3425 (class 0 OID 16413)
-- Dependencies: 224
-- Data for Name: sensor_co2_data_zigbee; Type: TABLE DATA; Schema: dt_emmen; Owner: -
--

INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K18-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K2-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K17-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K15-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K16-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K27-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K31-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K36-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K35-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K39-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K40-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K42-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K44-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K103-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K45-CO2', -1, true, 21.6, 88, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K102-CO2', -1, true, 21.6, 9, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K21-CO2', -1, true, 21.6, 4, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K12-CO2', -1, true, 21.6, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K4-CO2', -1, true, 21.6, 56, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K3-CO2', -1, true, 21.6, 88, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K13-CO2', -1, true, 21.6, 99, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K51-CO2', -1, true, 21.6, 0, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K29-CO2', -1, true, 21.6, 22, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K20-CO2', -1, true, 23, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K25-CO2', -1, true, 234, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K49-CO2', -1, true, 21.6, 33, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K62-CO2', 44, true, 66, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K33-CO2', -1, true, 21.6, 44, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K60-CO2', 22, true, 24, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K6-CO2', 22, true, 33, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K5-CO2', -1, true, 21.6, 55, 1233);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K11-CO2', -1, true, 21.6, 55, 123);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K28-CO2', -1, true, 21.6, 55, 66);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K53-CO2', -1, true, 21.6, 55, 777);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K48-CO2', -1, true, 21.6, 55, 888);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K38-CO2', -1, true, 21.6, 55, 33);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K101-CO2', -1, true, 21.6, 55, 444);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K64-CO2', 67, true, 100, 45, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K63-CO2', 11, true, 23, 23, 555);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K61-CO2', 33, true, 12, 100, 3);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K9-CO2', 99, true, 33, 55, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K10-CO2', 22, true, 12, 44, 33);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K24-CO2', -1, true, 123, 22, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K19-CO2', -1, true, 21.6, 33, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K26-CO2', -1, true, 21.6, 44, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K47-CO2', -1, true, 21.6, 44, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K30-CO2', -1, true, 21.6, 4, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K32-CO2', -1, true, 21.6, 44, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K34-CO2', -1, true, 21.6, 6, 357);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K37-CO2', -1, true, 21.6, 7, 22);
INSERT INTO dt_emmen.sensor_co2_data_zigbee (date, friendlyname, battery_percentage, state, temperature, huminity, co2) VALUES ('2023-05-23 09:48:07', 'K41-CO2', -1, true, 21.6, 7, 123);

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

INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K102-3', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K103', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K11', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K12', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K15', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K18', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01', 'K38', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01', 'K39', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01', 'K39-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K4', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K48', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K53', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K102-3', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K11', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K12', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K18', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02', 'K38', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02', 'K39', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K48', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K53', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K102-3', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K12', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K18', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01', 'K38', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01', 'K39', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K102-3', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K12', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K18', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K38', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K39', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K10', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01', 'K42', 50, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K102', 23, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K16', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K18', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K26', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K3', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01', 'K38', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01', 'K38-2', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01', 'K39', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01', 'K5', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K10', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K102-2', 100, true, 18.28);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K102-3', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K103', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K12', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K16', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K18', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K26', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K3', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K38', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K38-2', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K39', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01', 'K5', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K53-2', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K102', 100, true, 24.6);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K102-2', 100, true, 26.37);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K102-3', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K103', 100, true, 26.12);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K103-2', 100, true, 26.88);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K11', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K12', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K15', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K16', 100, true, 24.35);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K18', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K2', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K3', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K38', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K38-2', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K39', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K39-2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K4', 100, true, 22.58);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K42', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K47', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K48', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K5', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K51', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K53', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K53-2', 100, true, 24.35);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:16:13.969796', 'K6', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:16:13.969796', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K103-2', 100, true, 26.88);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K11', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K12', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K15', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K16', 100, true, 24.35);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K18', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K2', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K3', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K38', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K38-2', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K39', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K39-2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K4', 100, true, 22.58);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K42', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K47', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K48', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K51', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K102-3', 33, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K42', 23, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K48', 23, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K102', 11, true, 24.6);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K102-2', 97, true, 26.37);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K102-3', 23, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K103-2', 33, true, 26.88);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K12', 55, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K15', 65, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K18', 44, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K2', 44, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K3', 44, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K102', 12, true, 24.6);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K102-2', 44, true, 26.37);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K102-3', 22, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K103', 66, true, 26.12);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K101', 8, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K10', 7, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K12', 50, false, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K102-2', 77, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01', 'K103', 11, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01', 'K103-2', 20, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01', 'K53', 34, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K4', 11, true, 22.58);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K42', 22, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K47', 67, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K48', 33, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K51', 44, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K53-2', 99, true, 24.35);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K101', 44, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K103', 2, true, 26.12);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K11', 5, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K16', 9, true, 24.35);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K53', 33, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K6', 88, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K38', 44, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K38-2', 44, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K39', 44, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K39-2', 44, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07', 'K5', 44, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07', 'K10', 22, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K6', 55, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K53-2', 90, true, 24.35);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-05-23 09:48:07.923908', 'K53', 77, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-05-23 09:48:07.923908', 'K5', 22, true, 19.29);


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
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('elles.heller@aareon.nl', 1, '277439cb66a5f28b5b5f841ff29e928832bc40cae59bca742fb78eedd943d03a', '', '');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('geke.harmers@aareon.nl', 1, '293a2364667cda460832f32182a80aeb0c133684f347b71f61fefba7db157af3', NULL, 'Geke');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel-disbergen@hotmail.com', 2, '562a019025efd6f9296d2d3e8fed4ca3ee7917f7f1255b1e367b07b61768d2c6', '', 'Michel');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel.disbergen@student.nhlstenden.com', 1, '644a59768537372a04ea6d6e458af1974bf2a01fb6600a199d7cb8e57e8aa4c5', '', 'Michel');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel.tentij@aareon.nl', 2, '2c380500759ff84454e258050913385157d683857918125c4d8f1bb6d31daa68', NULL, 'Michel Tentij');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('jaafar.jawadi@student.nhlstenden.com', 1, 'cee5b8546103d113a6a962760a5fffc432ff461c03e3a95fbdedb38c662b5a73', '', 'Jaafar');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('steffan.van.der.werf@student.nhlstenden.com', 2, '4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2', '', 'Steffan');


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 216
-- Name: building_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.building_id_seq', 10, true);


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 218
-- Name: data_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: -
--

SELECT pg_catalog.setval('dt_emmen.data_type_id_seq', 6, true);


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

