--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2

-- Started on 2023-05-09 12:52:10 UTC

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
-- Name: aareon_dt; Type: DATABASE; Schema: -; Owner: aareon
--

CREATE DATABASE aareon_dt WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE aareon_dt OWNER TO aareon;

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
-- Name: aareon_dt; Type: DATABASE PROPERTIES; Schema: -; Owner: aareon
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
-- Name: dt_emmen; Type: SCHEMA; Schema: -; Owner: aareon
--

CREATE SCHEMA dt_emmen;


ALTER SCHEMA dt_emmen OWNER TO aareon;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16387)
-- Name: building; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.building (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    type character varying(50) NOT NULL,
    company character varying(20) NOT NULL,
    retention_period integer DEFAULT 28 NOT NULL
);


ALTER TABLE dt_emmen.building OWNER TO aareon;

--
-- TOC entry 216 (class 1259 OID 16391)
-- Name: building_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: aareon
--

CREATE SEQUENCE dt_emmen.building_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dt_emmen.building_id_seq OWNER TO aareon;

--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 216
-- Name: building_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.building_id_seq OWNED BY dt_emmen.building.id;


--
-- TOC entry 217 (class 1259 OID 16392)
-- Name: data_type; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.data_type (
    id integer NOT NULL,
    type text NOT NULL
);


ALTER TABLE dt_emmen.data_type OWNER TO aareon;

--
-- TOC entry 218 (class 1259 OID 16397)
-- Name: data_type_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: aareon
--

CREATE SEQUENCE dt_emmen.data_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dt_emmen.data_type_id_seq OWNER TO aareon;

--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 218
-- Name: data_type_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.data_type_id_seq OWNED BY dt_emmen.data_type.id;


--
-- TOC entry 219 (class 1259 OID 16398)
-- Name: role; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.role (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE dt_emmen.role OWNER TO aareon;

--
-- TOC entry 220 (class 1259 OID 16401)
-- Name: role_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: aareon
--

CREATE SEQUENCE dt_emmen.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dt_emmen.role_id_seq OWNER TO aareon;

--
-- TOC entry 3442 (class 0 OID 0)
-- Dependencies: 220
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.role_id_seq OWNED BY dt_emmen.role.id;


--
-- TOC entry 221 (class 1259 OID 16402)
-- Name: room; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.room (
    building_id integer NOT NULL,
    room_number character varying(10) NOT NULL,
    coordinates character varying(50) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE dt_emmen.room OWNER TO aareon;

--
-- TOC entry 222 (class 1259 OID 16405)
-- Name: sensor; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor (
    room_number character varying(50) NOT NULL,
    friendlyname character varying(20) DEFAULT 'K0000'::character varying NOT NULL,
    "serial_number " text,
    type_id integer
);


ALTER TABLE dt_emmen.sensor OWNER TO aareon;

--
-- TOC entry 223 (class 1259 OID 16411)
-- Name: sensor_co2_data_lora; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_co2_data_lora (
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    battery_percentage integer NOT NULL,
    state boolean,
    temperature numeric NOT NULL,
    huminity numeric NOT NULL,
    co2 numeric NOT NULL
);


ALTER TABLE dt_emmen.sensor_co2_data_lora OWNER TO aareon;

--
-- TOC entry 224 (class 1259 OID 16417)
-- Name: sensor_co2_data_zigbee; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_co2_data_zigbee (
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    battery_percentage integer NOT NULL,
    state boolean,
    temperature numeric NOT NULL,
    huminity numeric NOT NULL,
    co2 numeric NOT NULL
);


ALTER TABLE dt_emmen.sensor_co2_data_zigbee OWNER TO aareon;

--
-- TOC entry 225 (class 1259 OID 16423)
-- Name: sensor_facilitor; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_facilitor (
    id integer NOT NULL,
    sensor_id text NOT NULL,
    facilitor_id integer NOT NULL,
    data_type_id integer NOT NULL
);


ALTER TABLE dt_emmen.sensor_facilitor OWNER TO aareon;

--
-- TOC entry 226 (class 1259 OID 16428)
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: aareon
--

CREATE SEQUENCE dt_emmen.sensor_facilitor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dt_emmen.sensor_facilitor_id_seq OWNER TO aareon;

--
-- TOC entry 3443 (class 0 OID 0)
-- Dependencies: 226
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.sensor_facilitor_id_seq OWNED BY dt_emmen.sensor_facilitor.id;


--
-- TOC entry 227 (class 1259 OID 16429)
-- Name: sensor_motion_data_zigbee; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_motion_data_zigbee (
    occupied boolean NOT NULL,
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    battery_percentage integer NOT NULL,
    state boolean,
    temperature double precision NOT NULL
);


ALTER TABLE dt_emmen.sensor_motion_data_zigbee OWNER TO aareon;

--
-- TOC entry 228 (class 1259 OID 16433)
-- Name: sensor_type; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_type (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE dt_emmen.sensor_type OWNER TO aareon;

--
-- TOC entry 229 (class 1259 OID 16438)
-- Name: sensor_type_id_seq; Type: SEQUENCE; Schema: dt_emmen; Owner: aareon
--

CREATE SEQUENCE dt_emmen.sensor_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dt_emmen.sensor_type_id_seq OWNER TO aareon;

--
-- TOC entry 3444 (class 0 OID 0)
-- Dependencies: 229
-- Name: sensor_type_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.sensor_type_id_seq OWNED BY dt_emmen.sensor_type.id;


--
-- TOC entry 230 (class 1259 OID 16439)
-- Name: sensor_water_data_lora; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_water_data_lora (
    date timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    friendlyname character varying(50) NOT NULL,
    battery_percentage integer NOT NULL,
    state boolean NOT NULL,
    water_present boolean NOT NULL
);


ALTER TABLE dt_emmen.sensor_water_data_lora OWNER TO aareon;

--
-- TOC entry 231 (class 1259 OID 16443)
-- Name: user; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen."user" (
    mail character varying(60) NOT NULL,
    role_id integer NOT NULL,
    password character varying(100) NOT NULL,
    mfa_token character varying(20) DEFAULT NULL::character varying,
    username character varying(50) NOT NULL
);


ALTER TABLE dt_emmen."user" OWNER TO aareon;

--
-- TOC entry 3225 (class 2604 OID 16447)
-- Name: building id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.building ALTER COLUMN id SET DEFAULT nextval('dt_emmen.building_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 16448)
-- Name: data_type id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.data_type ALTER COLUMN id SET DEFAULT nextval('dt_emmen.data_type_id_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 16449)
-- Name: role id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.role ALTER COLUMN id SET DEFAULT nextval('dt_emmen.role_id_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 16450)
-- Name: sensor_facilitor id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor ALTER COLUMN id SET DEFAULT nextval('dt_emmen.sensor_facilitor_id_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 16451)
-- Name: sensor_type id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_type ALTER COLUMN id SET DEFAULT nextval('dt_emmen.sensor_type_id_seq'::regclass);


--
-- TOC entry 3416 (class 0 OID 16387)
-- Dependencies: 215
-- Data for Name: building; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.building (id, name, type, company, retention_period) VALUES (1, 'Aareon', 'Kantoor', 'Aareon', 28);


--
-- TOC entry 3418 (class 0 OID 16392)
-- Dependencies: 217
-- Data for Name: data_type; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.data_type (id, type) VALUES (1, 'BEZ');
INSERT INTO dt_emmen.data_type (id, type) VALUES (2, 'TEMP');
INSERT INTO dt_emmen.data_type (id, type) VALUES (3, 'CO2');
INSERT INTO dt_emmen.data_type (id, type) VALUES (4, 'BAT');


--
-- TOC entry 3420 (class 0 OID 16398)
-- Dependencies: 219
-- Data for Name: role; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.role (id, name) VALUES (1, 'standard');
INSERT INTO dt_emmen.role (id, name) VALUES (2, 'administrator');


--
-- TOC entry 3422 (class 0 OID 16402)
-- Dependencies: 221
-- Data for Name: room; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K10', '80,180 80,220 114,221 114,180', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K101', '111,478 111,517 145,517 145,478', 'Jacquardzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K102', '46,480 46,569 110,569 110,480', 'Leibnizzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K103', '111,532 111,569 179,569 179,532', 'Hollerithzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K11', '80,222 80,262 114,262 114,222', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K12', '80,264 80,306 114,306 114,263', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K15', '47,398 47,431 88,431 88,398', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K16', '89,398 89,431 129,431 129,398', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K18', '349,264 349,304 382,304 382,264', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K2', '131,306 131,347 164,347 164,306', 'Ericazaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K3', '131,264 131,305 164,305 164,264', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K38', '710,258 710,312 751,312 751,258', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K39', '665,199 665,254 709,254 709,199', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K4', '131,222 131,261 164,261 164,222', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K42', '579,267 579,314 621,314 621,267', 'Vergaderzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K47', '498,347 498,365 528,365 528,347', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K48', '459,347 459,365 494,365 494,347', 'Designlab XS');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K5', '131,180 131,220 164,220 164,180', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K51', '284,306 331,306 331,346 284,346', 'Pascalzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K53', '502,432 502,397 510,389 560,389 560,431', 'Neumannzaal');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K6', '131,138 131,179 164,179 164,138', 'Flex');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K25', '283,222 283,262 333,262 333,222', 'Designlab XL');
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K26', '283,262 283,304 333,304 333,262', 'Designlab Xl');


--
-- TOC entry 3423 (class 0 OID 16405)
-- Dependencies: 222
-- Data for Name: sensor; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K102', 'K102', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K102', 'K102-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K102', 'K102-3', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K103', 'K103', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K103', 'K103-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K11', 'K11', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K12', 'K12', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K15', 'K15', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K16', 'K16', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K18', 'K18', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K2', 'K2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K25', 'K25', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K26', 'K26', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K3', 'K3', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K38', 'K38', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K38', 'K38-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K39', 'K39', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K39', 'K39-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K4', 'K4', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K42', 'K42', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K47', 'K47', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K48', 'K48', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K5', 'K5', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K51', 'K51', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K53', 'K53', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K53', 'K53-2', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K6', 'K6', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K10', 'K10', NULL, 1);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K101', 'K101', NULL, 1);


--
-- TOC entry 3424 (class 0 OID 16411)
-- Dependencies: 223
-- Data for Name: sensor_co2_data_lora; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3425 (class 0 OID 16417)
-- Dependencies: 224
-- Data for Name: sensor_co2_data_zigbee; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3426 (class 0 OID 16423)
-- Dependencies: 225
-- Data for Name: sensor_facilitor; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
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


--
-- TOC entry 3428 (class 0 OID 16429)
-- Dependencies: 227
-- Data for Name: sensor_motion_data_zigbee; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K102-3', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K103', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K11', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K12', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K15', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K18', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01+02', 'K38', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01+02', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01+02', 'K39', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:00:01+02', 'K39-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K4', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K48', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K53', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K102-3', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02+02', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02+02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K11', 100, true, 22.33);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K12', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K18', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02+02', 'K38', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02+02', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02+02', 'K39', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:10:02+02', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K48', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K53', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K102-3', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01+02', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01+02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K12', 100, true, 22.07);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K18', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01+02', 'K38', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01+02', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01+02', 'K39', 100, true, 21.31);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:20:01+02', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K10', 100, true, 23.34);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K102-3', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K12', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K16', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K18', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K2', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K26', 100, true, 20.81);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K3', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K38', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K38-2', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K39', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K5', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:30:01+02', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K10', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K102-2', 100, true, 18.53);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K102-3', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01+02', 'K103', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K12', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K16', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K18', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K26', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K3', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01+02', 'K38', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01+02', 'K38-2', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01+02', 'K39', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01+02', 'K5', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K53-2', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:40:01+02', 'K6', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K10', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K101', 100, true, 23.09);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K102', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K102-2', 100, true, 18.28);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K102-3', 100, true, 18.02);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K103', 100, true, 19.04);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K103-2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K11', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K12', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K15', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K16', 100, true, 19.8);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K18', 100, true, 21.57);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K2', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K25', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K26', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K3', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K38', 100, true, 19.54);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K38-2', 100, true, 20.3);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K39', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K39-2', 100, true, 21.06);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K4', 100, true, 20.05);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K42', 100, true, 22.83);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K47', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K48', 100, true, 23.59);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K5', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K51', 100, true, 21.82);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K53', 100, true, 19.29);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K53-2', 100, true, 18.78);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:50:01+02', 'K6', 100, true, 19.54);


--
-- TOC entry 3429 (class 0 OID 16433)
-- Dependencies: 228
-- Data for Name: sensor_type; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.sensor_type (id, name) VALUES (1, 'motion_zigbee');
INSERT INTO dt_emmen.sensor_type (id, name) VALUES (2, 'co2_zigbee');
INSERT INTO dt_emmen.sensor_type (id, name) VALUES (3, 'co2_lora');
INSERT INTO dt_emmen.sensor_type (id, name) VALUES (4, 'water_lora');


--
-- TOC entry 3431 (class 0 OID 16439)
-- Dependencies: 230
-- Data for Name: sensor_water_data_lora; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3432 (class 0 OID 16443)
-- Dependencies: 231
-- Data for Name: user; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
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
-- Name: building_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.building_id_seq', 10, true);


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 218
-- Name: data_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.data_type_id_seq', 6, true);


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 220
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.role_id_seq', 2, true);


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 226
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.sensor_facilitor_id_seq', 48, true);


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 229
-- Name: sensor_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.sensor_type_id_seq', 4, true);


--
-- TOC entry 3240 (class 2606 OID 16453)
-- Name: data_type data_type_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.data_type
    ADD CONSTRAINT data_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 16455)
-- Name: building idx_16392_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.building
    ADD CONSTRAINT idx_16392_primary PRIMARY KEY (id);


--
-- TOC entry 3242 (class 2606 OID 16457)
-- Name: role idx_16398_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.role
    ADD CONSTRAINT idx_16398_primary PRIMARY KEY (id);


--
-- TOC entry 3245 (class 2606 OID 16459)
-- Name: room idx_16402_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.room
    ADD CONSTRAINT idx_16402_primary PRIMARY KEY (room_number);


--
-- TOC entry 3247 (class 2606 OID 16461)
-- Name: sensor idx_16405_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT idx_16405_primary PRIMARY KEY (friendlyname);


--
-- TOC entry 3256 (class 2606 OID 16463)
-- Name: sensor_motion_data_zigbee idx_16409_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_motion_data_zigbee
    ADD CONSTRAINT idx_16409_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3252 (class 2606 OID 16465)
-- Name: sensor_co2_data_zigbee idx_16410_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_zigbee
    ADD CONSTRAINT idx_16410_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3250 (class 2606 OID 16467)
-- Name: sensor_co2_data_lora idx_16411_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_lora
    ADD CONSTRAINT idx_16411_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3260 (class 2606 OID 16469)
-- Name: sensor_water_data_lora idx_16412_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_water_data_lora
    ADD CONSTRAINT idx_16412_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3262 (class 2606 OID 16471)
-- Name: user idx_16413_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen."user"
    ADD CONSTRAINT idx_16413_primary PRIMARY KEY (mail);


--
-- TOC entry 3254 (class 2606 OID 16473)
-- Name: sensor_facilitor sensor_facilitor_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT sensor_facilitor_pkey PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 16475)
-- Name: sensor_type sensor_type_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_type
    ADD CONSTRAINT sensor_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3243 (class 1259 OID 16476)
-- Name: idx_16402_building_id; Type: INDEX; Schema: dt_emmen; Owner: aareon
--

CREATE INDEX idx_16402_building_id ON dt_emmen.room USING btree (building_id);


--
-- TOC entry 3248 (class 1259 OID 16477)
-- Name: idx_16405_sensor_room; Type: INDEX; Schema: dt_emmen; Owner: aareon
--

CREATE INDEX idx_16405_sensor_room ON dt_emmen.sensor USING btree (room_number);


--
-- TOC entry 3263 (class 1259 OID 16478)
-- Name: idx_16413_user_role; Type: INDEX; Schema: dt_emmen; Owner: aareon
--

CREATE INDEX idx_16413_user_role ON dt_emmen."user" USING btree (role_id);


--
-- TOC entry 3264 (class 2606 OID 16479)
-- Name: room room_building_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.room
    ADD CONSTRAINT "room_building_FK" FOREIGN KEY (building_id) REFERENCES dt_emmen.building(id) NOT VALID;


--
-- TOC entry 3271 (class 2606 OID 16484)
-- Name: sensor_motion_data_zigbee sensorMotionData_sensor_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_motion_data_zigbee
    ADD CONSTRAINT "sensorMotionData_sensor_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname) NOT VALID;


--
-- TOC entry 3269 (class 2606 OID 16489)
-- Name: sensor_facilitor sensorToFacilitor_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT "sensorToFacilitor_FK" FOREIGN KEY (sensor_id) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3267 (class 2606 OID 16494)
-- Name: sensor_co2_data_lora sensor_co2_data_lora_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_lora
    ADD CONSTRAINT "sensor_co2_data_lora_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3268 (class 2606 OID 16499)
-- Name: sensor_co2_data_zigbee sensor_co2_data_zigbee_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_zigbee
    ADD CONSTRAINT "sensor_co2_data_zigbee_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3270 (class 2606 OID 16504)
-- Name: sensor_facilitor sensor_data_type_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT "sensor_data_type_FK" FOREIGN KEY (data_type_id) REFERENCES dt_emmen.data_type(id);


--
-- TOC entry 3265 (class 2606 OID 16509)
-- Name: sensor sensor_room_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT "sensor_room_FK" FOREIGN KEY (room_number) REFERENCES dt_emmen.room(room_number) NOT VALID;


--
-- TOC entry 3266 (class 2606 OID 16514)
-- Name: sensor sensor_type_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT "sensor_type_FK" FOREIGN KEY (type_id) REFERENCES dt_emmen.sensor_type(id) NOT VALID;


--
-- TOC entry 3272 (class 2606 OID 16519)
-- Name: sensor_water_data_lora sensor_water_data_lora_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_water_data_lora
    ADD CONSTRAINT "sensor_water_data_lora_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3273 (class 2606 OID 16524)
-- Name: user user_role_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen."user"
    ADD CONSTRAINT "user_role_FK" FOREIGN KEY (role_id) REFERENCES dt_emmen.role(id) NOT VALID;


-- Completed on 2023-05-09 12:52:10 UTC

--
-- PostgreSQL database dump complete
--

