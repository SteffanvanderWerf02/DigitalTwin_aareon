--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2

-- Started on 2023-05-08 09:52:57 UTC

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
-- TOC entry 229 (class 1259 OID 16512)
-- Name: data_type; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.data_type (
    id integer NOT NULL,
    type text NOT NULL
);


ALTER TABLE dt_emmen.data_type OWNER TO aareon;

--
-- TOC entry 228 (class 1259 OID 16511)
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
-- Dependencies: 228
-- Name: data_type_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.data_type_id_seq OWNED BY dt_emmen.data_type.id;


--
-- TOC entry 217 (class 1259 OID 16392)
-- Name: role; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.role (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE dt_emmen.role OWNER TO aareon;

--
-- TOC entry 218 (class 1259 OID 16395)
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
-- Dependencies: 218
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.role_id_seq OWNED BY dt_emmen.role.id;


--
-- TOC entry 219 (class 1259 OID 16396)
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
-- TOC entry 220 (class 1259 OID 16399)
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
-- TOC entry 224 (class 1259 OID 16471)
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
-- TOC entry 223 (class 1259 OID 16458)
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
-- TOC entry 231 (class 1259 OID 16521)
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
-- TOC entry 230 (class 1259 OID 16520)
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
-- Dependencies: 230
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.sensor_facilitor_id_seq OWNED BY dt_emmen.sensor_facilitor.id;


--
-- TOC entry 221 (class 1259 OID 16403)
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
-- TOC entry 227 (class 1259 OID 16496)
-- Name: sensor_type; Type: TABLE; Schema: dt_emmen; Owner: aareon
--

CREATE TABLE dt_emmen.sensor_type (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE dt_emmen.sensor_type OWNER TO aareon;

--
-- TOC entry 226 (class 1259 OID 16495)
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
-- Dependencies: 226
-- Name: sensor_type_id_seq; Type: SEQUENCE OWNED BY; Schema: dt_emmen; Owner: aareon
--

ALTER SEQUENCE dt_emmen.sensor_type_id_seq OWNED BY dt_emmen.sensor_type.id;


--
-- TOC entry 225 (class 1259 OID 16484)
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
-- TOC entry 222 (class 1259 OID 16407)
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
-- TOC entry 3225 (class 2604 OID 16411)
-- Name: building id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.building ALTER COLUMN id SET DEFAULT nextval('dt_emmen.building_id_seq'::regclass);


--
-- TOC entry 3235 (class 2604 OID 16515)
-- Name: data_type id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.data_type ALTER COLUMN id SET DEFAULT nextval('dt_emmen.data_type_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 16412)
-- Name: role id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.role ALTER COLUMN id SET DEFAULT nextval('dt_emmen.role_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 16524)
-- Name: sensor_facilitor id; Type: DEFAULT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor ALTER COLUMN id SET DEFAULT nextval('dt_emmen.sensor_facilitor_id_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 16499)
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
-- TOC entry 3430 (class 0 OID 16512)
-- Dependencies: 229
-- Data for Name: data_type; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3418 (class 0 OID 16392)
-- Dependencies: 217
-- Data for Name: role; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.role (id, name) VALUES (1, 'standard');
INSERT INTO dt_emmen.role (id, name) VALUES (2, 'administrator');


--
-- TOC entry 3420 (class 0 OID 16396)
-- Dependencies: 219
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
INSERT INTO dt_emmen.room (building_id, room_number, coordinates, name) VALUES (1, 'K25-K26', '283,222 283,304 333,304 333,222', 'Designlab XL');
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


--
-- TOC entry 3421 (class 0 OID 16399)
-- Dependencies: 220
-- Data for Name: sensor; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K10', 'K10', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K101', 'K101', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K102', 'K102', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K102', 'K102-2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K102', 'K102-3', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K103', 'K103', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K103', 'K103-2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K11', 'K11', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K12', 'K12', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K15', 'K15', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K16', 'K16', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K18', 'K18', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K2', 'K2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K25-K26', 'K25-K26', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K25-K26', 'K25-K26-2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K3', 'K3', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K38', 'K38', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K38', 'K38-2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K39', 'K39', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K39', 'K39-2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K4', 'K4', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K42', 'K42', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K47', 'K47', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K48', 'K48', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K5', 'K5', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K51', 'K51', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K53', 'K53', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K53', 'K53-2', NULL, NULL);
INSERT INTO dt_emmen.sensor (room_number, friendlyname, "serial_number ", type_id) VALUES ('K6', 'K6', NULL, NULL);


--
-- TOC entry 3425 (class 0 OID 16471)
-- Dependencies: 224
-- Data for Name: sensor_co2_data_lora; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3424 (class 0 OID 16458)
-- Dependencies: 223
-- Data for Name: sensor_co2_data_zigbee; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3432 (class 0 OID 16521)
-- Dependencies: 231
-- Data for Name: sensor_facilitor; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3422 (class 0 OID 16403)
-- Dependencies: 221
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
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K25-K26', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:00:01+02', 'K25-K26-2', 100, true, 20.81);
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
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K25-K26', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:10:02+02', 'K25-K26-2', 100, true, 20.81);
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
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K25-K26', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:20:01+02', 'K25-K26-2', 100, true, 20.81);
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
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K25-K26', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:30:01+02', 'K25-K26-2', 100, true, 20.81);
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
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K25-K26', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (false, '2023-04-26 08:40:01+02', 'K25-K26-2', 100, true, 20.3);
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
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K25-K26', 100, true, 20.56);
INSERT INTO dt_emmen.sensor_motion_data_zigbee (occupied, date, friendlyname, battery_percentage, state, temperature) VALUES (true, '2023-04-26 08:50:01+02', 'K25-K26-2', 100, true, 20.3);
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
-- TOC entry 3428 (class 0 OID 16496)
-- Dependencies: 227
-- Data for Name: sensor_type; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3426 (class 0 OID 16484)
-- Dependencies: 225
-- Data for Name: sensor_water_data_lora; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--



--
-- TOC entry 3423 (class 0 OID 16407)
-- Dependencies: 222
-- Data for Name: user; Type: TABLE DATA; Schema: dt_emmen; Owner: aareon
--

INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('arie.vanderdeijl@aareon.nl', 2, '8c6c2cdcb8ba954497b7015629c79009e7868a4c514e65f29afe1e432ccff63d', '', 'Arie');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('elles.heller@aareon.nl', 1, '277439cb66a5f28b5b5f841ff29e928832bc40cae59bca742fb78eedd943d03a', '', '');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('geke.harmers@aareon.nl', 1, '293a2364667cda460832f32182a80aeb0c133684f347b71f61fefba7db157af3', NULL, 'Geke');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('Jaafar.jawadi@student.nhlstenden.com', 1, 'cee5b8546103d113a6a962760a5fffc432ff461c03e3a95fbdedb38c662b5a73', '', 'Jaafar');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel-disbergen@hotmail.com', 2, '562a019025efd6f9296d2d3e8fed4ca3ee7917f7f1255b1e367b07b61768d2c6', '', 'Michel');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel.disbergen@student.nhlstenden.com', 1, '644a59768537372a04ea6d6e458af1974bf2a01fb6600a199d7cb8e57e8aa4c5', '', 'Michel');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('michel.tentij@aareon.nl', 2, '2c380500759ff84454e258050913385157d683857918125c4d8f1bb6d31daa68', NULL, 'Michel Tentij');
INSERT INTO dt_emmen."user" (mail, role_id, password, mfa_token, username) VALUES ('Steffan.van.der.werf@student.nhlstenden.com', 2, '4813494d137e1631bba301d5acab6e7bb7aa74ce1185d456565ef51d737677b2', '', 'Steffan');


--
-- TOC entry 3445 (class 0 OID 0)
-- Dependencies: 216
-- Name: building_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.building_id_seq', 10, true);


--
-- TOC entry 3446 (class 0 OID 0)
-- Dependencies: 228
-- Name: data_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.data_type_id_seq', 1, false);


--
-- TOC entry 3447 (class 0 OID 0)
-- Dependencies: 218
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.role_id_seq', 2, true);


--
-- TOC entry 3448 (class 0 OID 0)
-- Dependencies: 230
-- Name: sensor_facilitor_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.sensor_facilitor_id_seq', 1, false);


--
-- TOC entry 3449 (class 0 OID 0)
-- Dependencies: 226
-- Name: sensor_type_id_seq; Type: SEQUENCE SET; Schema: dt_emmen; Owner: aareon
--

SELECT pg_catalog.setval('dt_emmen.sensor_type_id_seq', 1, false);


--
-- TOC entry 3261 (class 2606 OID 16519)
-- Name: data_type data_type_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.data_type
    ADD CONSTRAINT data_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 16414)
-- Name: building idx_16392_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.building
    ADD CONSTRAINT idx_16392_primary PRIMARY KEY (id);


--
-- TOC entry 3240 (class 2606 OID 16416)
-- Name: role idx_16398_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.role
    ADD CONSTRAINT idx_16398_primary PRIMARY KEY (id);


--
-- TOC entry 3243 (class 2606 OID 16418)
-- Name: room idx_16402_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.room
    ADD CONSTRAINT idx_16402_primary PRIMARY KEY (room_number);


--
-- TOC entry 3245 (class 2606 OID 16420)
-- Name: sensor idx_16405_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT idx_16405_primary PRIMARY KEY (friendlyname);


--
-- TOC entry 3248 (class 2606 OID 16422)
-- Name: sensor_motion_data_zigbee idx_16409_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_motion_data_zigbee
    ADD CONSTRAINT idx_16409_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3253 (class 2606 OID 16465)
-- Name: sensor_co2_data_zigbee idx_16410_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_zigbee
    ADD CONSTRAINT idx_16410_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3255 (class 2606 OID 16478)
-- Name: sensor_co2_data_lora idx_16411_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_lora
    ADD CONSTRAINT idx_16411_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3257 (class 2606 OID 16489)
-- Name: sensor_water_data_lora idx_16412_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_water_data_lora
    ADD CONSTRAINT idx_16412_primary PRIMARY KEY (date, friendlyname);


--
-- TOC entry 3250 (class 2606 OID 16424)
-- Name: user idx_16413_primary; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen."user"
    ADD CONSTRAINT idx_16413_primary PRIMARY KEY (mail);


--
-- TOC entry 3263 (class 2606 OID 16528)
-- Name: sensor_facilitor sensor_facilitor_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT sensor_facilitor_pkey PRIMARY KEY (id);


--
-- TOC entry 3259 (class 2606 OID 16503)
-- Name: sensor_type sensor_type_pkey; Type: CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_type
    ADD CONSTRAINT sensor_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3241 (class 1259 OID 16425)
-- Name: idx_16402_building_id; Type: INDEX; Schema: dt_emmen; Owner: aareon
--

CREATE INDEX idx_16402_building_id ON dt_emmen.room USING btree (building_id);


--
-- TOC entry 3246 (class 1259 OID 16426)
-- Name: idx_16405_sensor_room; Type: INDEX; Schema: dt_emmen; Owner: aareon
--

CREATE INDEX idx_16405_sensor_room ON dt_emmen.sensor USING btree (room_number);


--
-- TOC entry 3251 (class 1259 OID 16427)
-- Name: idx_16413_user_role; Type: INDEX; Schema: dt_emmen; Owner: aareon
--

CREATE INDEX idx_16413_user_role ON dt_emmen."user" USING btree (role_id);


--
-- TOC entry 3264 (class 2606 OID 16437)
-- Name: room room_building_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.room
    ADD CONSTRAINT "room_building_FK" FOREIGN KEY (building_id) REFERENCES dt_emmen.building(id) NOT VALID;


--
-- TOC entry 3267 (class 2606 OID 16447)
-- Name: sensor_motion_data_zigbee sensorMotionData_sensor_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_motion_data_zigbee
    ADD CONSTRAINT "sensorMotionData_sensor_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname) NOT VALID;


--
-- TOC entry 3272 (class 2606 OID 16529)
-- Name: sensor_facilitor sensorToFacilitor_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT "sensorToFacilitor_FK" FOREIGN KEY (sensor_id) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3270 (class 2606 OID 16479)
-- Name: sensor_co2_data_lora sensor_co2_data_lora_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_lora
    ADD CONSTRAINT "sensor_co2_data_lora_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3269 (class 2606 OID 16466)
-- Name: sensor_co2_data_zigbee sensor_co2_data_zigbee_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_co2_data_zigbee
    ADD CONSTRAINT "sensor_co2_data_zigbee_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3273 (class 2606 OID 16534)
-- Name: sensor_facilitor sensor_data_type_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_facilitor
    ADD CONSTRAINT "sensor_data_type_FK" FOREIGN KEY (data_type_id) REFERENCES dt_emmen.data_type(id);


--
-- TOC entry 3265 (class 2606 OID 16442)
-- Name: sensor sensor_room_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT "sensor_room_FK" FOREIGN KEY (room_number) REFERENCES dt_emmen.room(room_number) NOT VALID;


--
-- TOC entry 3266 (class 2606 OID 16506)
-- Name: sensor sensor_type_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor
    ADD CONSTRAINT "sensor_type_FK" FOREIGN KEY (type_id) REFERENCES dt_emmen.sensor_type(id) NOT VALID;


--
-- TOC entry 3271 (class 2606 OID 16490)
-- Name: sensor_water_data_lora sensor_water_data_lora_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen.sensor_water_data_lora
    ADD CONSTRAINT "sensor_water_data_lora_FK" FOREIGN KEY (friendlyname) REFERENCES dt_emmen.sensor(friendlyname);


--
-- TOC entry 3268 (class 2606 OID 16432)
-- Name: user user_role_FK; Type: FK CONSTRAINT; Schema: dt_emmen; Owner: aareon
--

ALTER TABLE ONLY dt_emmen."user"
    ADD CONSTRAINT "user_role_FK" FOREIGN KEY (role_id) REFERENCES dt_emmen.role(id) NOT VALID;


-- Completed on 2023-05-08 09:52:57 UTC

--
-- PostgreSQL database dump complete
--

