--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    id integer NOT NULL,
    user_id integer,
    label character varying,
    city character varying,
    street character varying,
    zip_code character varying,
    country character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "primary" boolean
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admins (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying,
    invitations_count integer DEFAULT 0,
    role character varying,
    active boolean DEFAULT true,
    full_name character varying
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admins_id_seq OWNED BY admins.id;


--
-- Name: affiliates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE affiliates (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: affiliates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE affiliates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: affiliates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE affiliates_id_seq OWNED BY affiliates.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying,
    icon character varying,
    image character varying,
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    imaging_category character varying,
    level integer,
    unisex boolean DEFAULT false
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: channel_media_owners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE channel_media_owners (
    id integer NOT NULL,
    channel_id integer,
    media_owner_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: channel_media_owners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channel_media_owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_media_owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channel_media_owners_id_seq OWNED BY channel_media_owners.id;


--
-- Name: channel_moderators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE channel_moderators (
    id integer NOT NULL,
    admin_id integer,
    channel_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: channel_moderators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channel_moderators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_moderators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channel_moderators_id_seq OWNED BY channel_moderators.id;


--
-- Name: channel_pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE channel_pictures (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    channel_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: channel_pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channel_pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channel_pictures_id_seq OWNED BY channel_pictures.id;


--
-- Name: channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE channels (
    id integer NOT NULL,
    name character varying,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dialogfeed_url character varying,
    feed_active boolean DEFAULT true
);


--
-- Name: channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE channels_id_seq OWNED BY channels.id;


--
-- Name: collection_background_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collection_background_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    collection_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collection_background_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collection_background_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_background_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collection_background_images_id_seq OWNED BY collection_background_images.id;


--
-- Name: collection_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collection_contents (
    id integer NOT NULL,
    collection_id integer,
    content_id integer,
    content_type character varying,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    width character varying
);


--
-- Name: collection_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collection_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collection_contents_id_seq OWNED BY collection_contents.id;


--
-- Name: collection_cover_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collection_cover_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    collection_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: collection_cover_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collection_cover_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_cover_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collection_cover_images_id_seq OWNED BY collection_cover_images.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collections (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    channel_id integer,
    photo character varying,
    admin_id integer
);


--
-- Name: collections_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collections_containers (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    channel_id integer,
    admin_id integer
);


--
-- Name: collections_containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_containers_id_seq OWNED BY collections_containers.id;


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: episodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE episodes (
    id integer NOT NULL,
    tv_show_season_id integer,
    cover_image character varying,
    file character varying,
    title character varying,
    number integer,
    specification text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: episodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE episodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: episodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE episodes_id_seq OWNED BY episodes.id;


--
-- Name: event_background_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_background_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    event_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: event_background_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_background_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_background_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_background_images_id_seq OWNED BY event_background_images.id;


--
-- Name: event_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_contents (
    id integer NOT NULL,
    event_id integer,
    content_id integer,
    content_type character varying,
    "position" integer,
    width character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: event_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_contents_id_seq OWNED BY event_contents.id;


--
-- Name: event_cover_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE event_cover_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    event_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: event_cover_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE event_cover_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_cover_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE event_cover_images_id_seq OWNED BY event_cover_images.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    admin_id integer
);


--
-- Name: events_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE events_containers (
    id integer NOT NULL,
    name character varying,
    channel_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin_id integer
);


--
-- Name: events_containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_containers_id_seq OWNED BY events_containers.id;


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: followings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE followings (
    id integer NOT NULL,
    followed_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    followed_type character varying
);


--
-- Name: followings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE followings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: followings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE followings_id_seq OWNED BY followings.id;


--
-- Name: home_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE home_contents (
    id integer NOT NULL,
    home_id integer,
    content_id integer,
    "position" integer,
    content_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    width character varying
);


--
-- Name: home_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE home_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: home_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE home_contents_id_seq OWNED BY home_contents.id;


--
-- Name: homes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE homes (
    id integer NOT NULL,
    published boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    home_type integer DEFAULT 0
);


--
-- Name: homes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE homes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: homes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE homes_id_seq OWNED BY homes.id;


--
-- Name: import_category_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE import_category_mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_cover_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issue_cover_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    issue_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: issue_cover_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_cover_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_cover_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_cover_images_id_seq OWNED BY issue_cover_images.id;


--
-- Name: issue_page_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issue_page_tags (
    id integer NOT NULL,
    specification text DEFAULT '{}'::text,
    issue_page_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: issue_page_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_page_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_page_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_page_tags_id_seq OWNED BY issue_page_tags.id;


--
-- Name: issue_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issue_pages (
    id integer NOT NULL,
    page_number integer,
    description character varying,
    image character varying,
    issue_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    visible boolean DEFAULT true
);


--
-- Name: issue_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_pages_id_seq OWNED BY issue_pages.id;


--
-- Name: issue_tag_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issue_tag_products (
    id integer NOT NULL,
    product_id integer,
    issue_page_tag_id integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_tag_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_tag_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_tag_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_tag_products_id_seq OWNED BY issue_tag_products.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE issues (
    id integer NOT NULL,
    volume_id integer,
    pages integer,
    url character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    publication_date date,
    title character varying,
    pdf_file_name character varying,
    pdf_url character varying,
    pdf_image_base_url character varying,
    pdf_pages integer
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issues_id_seq OWNED BY issues.id;


--
-- Name: linked_collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE linked_collections (
    id integer NOT NULL,
    collections_container_id integer,
    collection_id integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: linked_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE linked_collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linked_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE linked_collections_id_seq OWNED BY linked_collections.id;


--
-- Name: linked_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE linked_events (
    id integer NOT NULL,
    event_id integer,
    events_container_id integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: linked_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE linked_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linked_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE linked_events_id_seq OWNED BY linked_events.id;


--
-- Name: linked_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE linked_products (
    id integer NOT NULL,
    products_container_id integer,
    product_id integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: linked_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE linked_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linked_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE linked_products_id_seq OWNED BY linked_products.id;


--
-- Name: links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE links (
    id integer NOT NULL,
    target_type character varying,
    target_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE links_id_seq OWNED BY links.id;


--
-- Name: magazine_background_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE magazine_background_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    magazine_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: magazine_background_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE magazine_background_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: magazine_background_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE magazine_background_images_id_seq OWNED BY magazine_background_images.id;


--
-- Name: magazine_cover_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE magazine_cover_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    magazine_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: magazine_cover_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE magazine_cover_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: magazine_cover_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE magazine_cover_images_id_seq OWNED BY magazine_cover_images.id;


--
-- Name: magazines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE magazines (
    id integer NOT NULL,
    channel_id integer,
    title character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: magazines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE magazines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: magazines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE magazines_id_seq OWNED BY magazines.id;


--
-- Name: media_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_containers (
    id integer NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    additional_description text,
    owner_id integer,
    owner_type character varying
);


--
-- Name: media_containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_containers_id_seq OWNED BY media_containers.id;


--
-- Name: media_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_contents (
    id integer NOT NULL,
    file_type character varying,
    file character varying,
    membership_id integer,
    membership_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cover_image character varying,
    specification text
);


--
-- Name: media_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_contents_id_seq OWNED BY media_contents.id;


--
-- Name: media_owner_background_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_owner_background_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    media_owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_owner_background_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_owner_background_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_owner_background_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_owner_background_images_id_seq OWNED BY media_owner_background_images.id;


--
-- Name: media_owner_moderators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_owner_moderators (
    id integer NOT NULL,
    admin_id integer,
    media_owner_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: media_owner_moderators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_owner_moderators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_owner_moderators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_owner_moderators_id_seq OWNED BY media_owner_moderators.id;


--
-- Name: media_owner_pictures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_owner_pictures (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    media_owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: media_owner_pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_owner_pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_owner_pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_owner_pictures_id_seq OWNED BY media_owner_pictures.id;


--
-- Name: media_owners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_owners (
    id integer NOT NULL,
    name character varying,
    url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dialogfeed_url character varying,
    feed_active boolean DEFAULT true
);


--
-- Name: media_owners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_owners_id_seq OWNED BY media_owners.id;


--
-- Name: option_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE option_types (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: option_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE option_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: option_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE option_types_id_seq OWNED BY option_types.id;


--
-- Name: option_value_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE option_value_variants (
    id integer NOT NULL,
    option_value_id integer,
    variant_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: option_value_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE option_value_variants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: option_value_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE option_value_variants_id_seq OWNED BY option_value_variants.id;


--
-- Name: option_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE option_values (
    id integer NOT NULL,
    option_type_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: option_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE option_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: option_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE option_values_id_seq OWNED BY option_values.id;


--
-- Name: post_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE post_products (
    id integer NOT NULL,
    post_id integer,
    product_id integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: post_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE post_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: post_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE post_products_id_seq OWNED BY post_products.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE posts (
    id integer NOT NULL,
    source_id integer,
    published_at timestamp without time zone,
    content_title character varying,
    content_body text,
    content_picture character varying,
    content_video character varying,
    post_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uid integer,
    post_type integer,
    original_picture_url character varying,
    visible boolean DEFAULT true,
    original_video_url character varying
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product_categories (
    id integer NOT NULL,
    product_id integer,
    category_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_categories_id_seq OWNED BY product_categories.id;


--
-- Name: product_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product_files (
    id integer NOT NULL,
    product_id integer,
    file_type character varying,
    file character varying,
    cover_image character varying,
    specification text,
    small_version_url character varying,
    normal_version_url character varying,
    large_version_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_files_id_seq OWNED BY product_files.id;


--
-- Name: product_option_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product_option_types (
    id integer NOT NULL,
    product_id integer,
    option_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_option_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_option_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_option_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_option_types_id_seq OWNED BY product_option_types.id;


--
-- Name: product_similarity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product_similarity (
    id integer NOT NULL,
    product_from_id integer,
    product_to_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_similarity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_similarity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_similarity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_similarity_id_seq OWNED BY product_similarity.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying,
    brand character varying,
    product_code character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description text,
    price_range character varying,
    category_hierarchy character varying,
    product_files jsonb DEFAULT '[]'::jsonb NOT NULL,
    shipping_info character varying,
    vendor_url character varying,
    containers_placement boolean DEFAULT false,
    vendor_product_image_url text,
    product_group character varying
);


--
-- Name: products_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products_containers (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    media_owner_id integer,
    channel_id integer,
    description character varying,
    admin_id integer,
    category_id integer
);


--
-- Name: products_containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_containers_id_seq OWNED BY products_containers.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE profiles (
    id integer NOT NULL,
    user_id integer,
    name character varying,
    surname character varying,
    picture character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searched_phrases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE searched_phrases (
    id integer NOT NULL,
    phrase character varying,
    counter integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: searched_phrases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE searched_phrases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searched_phrases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE searched_phrases_id_seq OWNED BY searched_phrases.id;


--
-- Name: size_guides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE size_guides (
    id integer NOT NULL,
    category_id integer,
    size_name character varying NOT NULL,
    size_num character varying NOT NULL,
    country character varying
);


--
-- Name: size_guides_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE size_guides_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: size_guides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE size_guides_id_seq OWNED BY size_guides.id;


--
-- Name: snapped_photos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapped_photos (
    id integer NOT NULL,
    user_id integer,
    image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapped_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapped_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapped_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapped_photos_id_seq OWNED BY snapped_photos.id;


--
-- Name: snapped_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapped_products (
    id integer NOT NULL,
    user_id integer,
    product_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapped_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapped_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapped_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapped_products_id_seq OWNED BY snapped_products.id;


--
-- Name: sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sources (
    id integer NOT NULL,
    name character varying,
    dialogfeed_id integer,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    source_owner_id integer,
    source_owner_type character varying
);


--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sources_id_seq OWNED BY sources.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stores (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country jsonb DEFAULT '[]'::jsonb NOT NULL,
    affiliate_id integer
);


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stores_id_seq OWNED BY stores.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id integer NOT NULL,
    media_container_id integer,
    product_id integer,
    coordinate_x numeric(4,3),
    coordinate_y numeric(4,3),
    coordinate_duration_end integer,
    coordinate_duration_start integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: temp_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE temp_images (
    id integer NOT NULL,
    image character varying,
    specification text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: temp_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_images_id_seq OWNED BY temp_images.id;


--
-- Name: trending_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trending_contents (
    id integer NOT NULL,
    trending_id integer,
    content_id integer,
    content_type character varying,
    "position" integer,
    width character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trending_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trending_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trending_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trending_contents_id_seq OWNED BY trending_contents.id;


--
-- Name: trendings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE trendings (
    id integer NOT NULL,
    channel_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trendings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trendings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trendings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trendings_id_seq OWNED BY trendings.id;


--
-- Name: tv_show_background_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tv_show_background_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    tv_show_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tv_show_background_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tv_show_background_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tv_show_background_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tv_show_background_images_id_seq OWNED BY tv_show_background_images.id;


--
-- Name: tv_show_cover_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tv_show_cover_images (
    id integer NOT NULL,
    file character varying,
    specification text DEFAULT '{}'::text,
    tv_show_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tv_show_cover_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tv_show_cover_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tv_show_cover_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tv_show_cover_images_id_seq OWNED BY tv_show_cover_images.id;


--
-- Name: tv_show_seasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tv_show_seasons (
    id integer NOT NULL,
    tv_show_id integer,
    number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tv_show_seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tv_show_seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tv_show_seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tv_show_seasons_id_seq OWNED BY tv_show_seasons.id;


--
-- Name: tv_shows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tv_shows (
    id integer NOT NULL,
    channel_id integer,
    title character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tv_shows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tv_shows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tv_shows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tv_shows_id_seq OWNED BY tv_shows.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    provider character varying DEFAULT 'email'::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    email character varying,
    tokens json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    ulab_user_id character varying,
    ulab_access_token character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: variant_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE variant_files (
    id integer NOT NULL,
    variant_id integer,
    file_type character varying,
    file character varying,
    cover_image character varying,
    specification text,
    small_version_url character varying,
    normal_version_url character varying,
    large_version_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: variant_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE variant_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: variant_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE variant_files_id_seq OWNED BY variant_files.id;


--
-- Name: variant_stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE variant_stores (
    id integer NOT NULL,
    price numeric(8,2),
    currency character varying,
    url character varying,
    variant_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sku character varying,
    store_id integer,
    quantity integer
);


--
-- Name: variant_stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE variant_stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: variant_stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE variant_stores_id_seq OWNED BY variant_stores.id;


--
-- Name: variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE variants (
    id integer NOT NULL,
    product_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    variant_files jsonb DEFAULT '[]'::jsonb NOT NULL,
    description character varying,
    "position" integer
);


--
-- Name: variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE variants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE variants_id_seq OWNED BY variants.id;


--
-- Name: volumes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE volumes (
    id integer NOT NULL,
    magazine_id integer,
    year integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: volumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE volumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: volumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE volumes_id_seq OWNED BY volumes.id;


--
-- Name: wishlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE wishlists (
    id integer NOT NULL,
    user_id integer,
    product_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wishlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wishlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wishlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wishlists_id_seq OWNED BY wishlists.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins ALTER COLUMN id SET DEFAULT nextval('admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY affiliates ALTER COLUMN id SET DEFAULT nextval('affiliates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_media_owners ALTER COLUMN id SET DEFAULT nextval('channel_media_owners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_moderators ALTER COLUMN id SET DEFAULT nextval('channel_moderators_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_pictures ALTER COLUMN id SET DEFAULT nextval('channel_pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels ALTER COLUMN id SET DEFAULT nextval('channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_background_images ALTER COLUMN id SET DEFAULT nextval('collection_background_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_contents ALTER COLUMN id SET DEFAULT nextval('collection_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_cover_images ALTER COLUMN id SET DEFAULT nextval('collection_cover_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections_containers ALTER COLUMN id SET DEFAULT nextval('collections_containers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY episodes ALTER COLUMN id SET DEFAULT nextval('episodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_background_images ALTER COLUMN id SET DEFAULT nextval('event_background_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_contents ALTER COLUMN id SET DEFAULT nextval('event_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_cover_images ALTER COLUMN id SET DEFAULT nextval('event_cover_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_containers ALTER COLUMN id SET DEFAULT nextval('events_containers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings ALTER COLUMN id SET DEFAULT nextval('followings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY home_contents ALTER COLUMN id SET DEFAULT nextval('home_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY homes ALTER COLUMN id SET DEFAULT nextval('homes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_cover_images ALTER COLUMN id SET DEFAULT nextval('issue_cover_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_page_tags ALTER COLUMN id SET DEFAULT nextval('issue_page_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_pages ALTER COLUMN id SET DEFAULT nextval('issue_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_tag_products ALTER COLUMN id SET DEFAULT nextval('issue_tag_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('issues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY linked_collections ALTER COLUMN id SET DEFAULT nextval('linked_collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY linked_events ALTER COLUMN id SET DEFAULT nextval('linked_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY linked_products ALTER COLUMN id SET DEFAULT nextval('linked_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY links ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazine_background_images ALTER COLUMN id SET DEFAULT nextval('magazine_background_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazine_cover_images ALTER COLUMN id SET DEFAULT nextval('magazine_cover_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazines ALTER COLUMN id SET DEFAULT nextval('magazines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_containers ALTER COLUMN id SET DEFAULT nextval('media_containers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_contents ALTER COLUMN id SET DEFAULT nextval('media_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_background_images ALTER COLUMN id SET DEFAULT nextval('media_owner_background_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_moderators ALTER COLUMN id SET DEFAULT nextval('media_owner_moderators_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_pictures ALTER COLUMN id SET DEFAULT nextval('media_owner_pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owners ALTER COLUMN id SET DEFAULT nextval('media_owners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_types ALTER COLUMN id SET DEFAULT nextval('option_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_value_variants ALTER COLUMN id SET DEFAULT nextval('option_value_variants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_values ALTER COLUMN id SET DEFAULT nextval('option_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_products ALTER COLUMN id SET DEFAULT nextval('post_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_categories ALTER COLUMN id SET DEFAULT nextval('product_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_files ALTER COLUMN id SET DEFAULT nextval('product_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_option_types ALTER COLUMN id SET DEFAULT nextval('product_option_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_similarity ALTER COLUMN id SET DEFAULT nextval('product_similarity_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products_containers ALTER COLUMN id SET DEFAULT nextval('products_containers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY searched_phrases ALTER COLUMN id SET DEFAULT nextval('searched_phrases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY size_guides ALTER COLUMN id SET DEFAULT nextval('size_guides_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapped_photos ALTER COLUMN id SET DEFAULT nextval('snapped_photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapped_products ALTER COLUMN id SET DEFAULT nextval('snapped_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources ALTER COLUMN id SET DEFAULT nextval('sources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores ALTER COLUMN id SET DEFAULT nextval('stores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_images ALTER COLUMN id SET DEFAULT nextval('temp_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trending_contents ALTER COLUMN id SET DEFAULT nextval('trending_contents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trendings ALTER COLUMN id SET DEFAULT nextval('trendings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_background_images ALTER COLUMN id SET DEFAULT nextval('tv_show_background_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_cover_images ALTER COLUMN id SET DEFAULT nextval('tv_show_cover_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_seasons ALTER COLUMN id SET DEFAULT nextval('tv_show_seasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_shows ALTER COLUMN id SET DEFAULT nextval('tv_shows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY variant_files ALTER COLUMN id SET DEFAULT nextval('variant_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY variant_stores ALTER COLUMN id SET DEFAULT nextval('variant_stores_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY variants ALTER COLUMN id SET DEFAULT nextval('variants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY volumes ALTER COLUMN id SET DEFAULT nextval('volumes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wishlists ALTER COLUMN id SET DEFAULT nextval('wishlists_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: affiliates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY affiliates
    ADD CONSTRAINT affiliates_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: channel_media_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_media_owners
    ADD CONSTRAINT channel_media_owners_pkey PRIMARY KEY (id);


--
-- Name: channel_moderators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_moderators
    ADD CONSTRAINT channel_moderators_pkey PRIMARY KEY (id);


--
-- Name: channel_pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_pictures
    ADD CONSTRAINT channel_pictures_pkey PRIMARY KEY (id);


--
-- Name: channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: collection_background_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_background_images
    ADD CONSTRAINT collection_background_images_pkey PRIMARY KEY (id);


--
-- Name: collection_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_contents
    ADD CONSTRAINT collection_contents_pkey PRIMARY KEY (id);


--
-- Name: collection_cover_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_cover_images
    ADD CONSTRAINT collection_cover_images_pkey PRIMARY KEY (id);


--
-- Name: collections_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections_containers
    ADD CONSTRAINT collections_containers_pkey PRIMARY KEY (id);


--
-- Name: collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- Name: event_background_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_background_images
    ADD CONSTRAINT event_background_images_pkey PRIMARY KEY (id);


--
-- Name: event_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_contents
    ADD CONSTRAINT event_contents_pkey PRIMARY KEY (id);


--
-- Name: event_cover_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_cover_images
    ADD CONSTRAINT event_cover_images_pkey PRIMARY KEY (id);


--
-- Name: events_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_containers
    ADD CONSTRAINT events_containers_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


--
-- Name: home_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY home_contents
    ADD CONSTRAINT home_contents_pkey PRIMARY KEY (id);


--
-- Name: homes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY homes
    ADD CONSTRAINT homes_pkey PRIMARY KEY (id);


--
-- Name: issue_cover_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_cover_images
    ADD CONSTRAINT issue_cover_images_pkey PRIMARY KEY (id);


--
-- Name: issue_page_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_page_tags
    ADD CONSTRAINT issue_page_tags_pkey PRIMARY KEY (id);


--
-- Name: issue_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_pages
    ADD CONSTRAINT issue_pages_pkey PRIMARY KEY (id);


--
-- Name: issue_tag_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_tag_products
    ADD CONSTRAINT issue_tag_products_pkey PRIMARY KEY (id);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: linked_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY linked_collections
    ADD CONSTRAINT linked_collections_pkey PRIMARY KEY (id);


--
-- Name: linked_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY linked_events
    ADD CONSTRAINT linked_events_pkey PRIMARY KEY (id);


--
-- Name: linked_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY linked_products
    ADD CONSTRAINT linked_products_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: magazine_background_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazine_background_images
    ADD CONSTRAINT magazine_background_images_pkey PRIMARY KEY (id);


--
-- Name: magazine_cover_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazine_cover_images
    ADD CONSTRAINT magazine_cover_images_pkey PRIMARY KEY (id);


--
-- Name: magazines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazines
    ADD CONSTRAINT magazines_pkey PRIMARY KEY (id);


--
-- Name: media_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_containers
    ADD CONSTRAINT media_containers_pkey PRIMARY KEY (id);


--
-- Name: media_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_contents
    ADD CONSTRAINT media_contents_pkey PRIMARY KEY (id);


--
-- Name: media_owner_background_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_background_images
    ADD CONSTRAINT media_owner_background_images_pkey PRIMARY KEY (id);


--
-- Name: media_owner_moderators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_moderators
    ADD CONSTRAINT media_owner_moderators_pkey PRIMARY KEY (id);


--
-- Name: media_owner_pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_pictures
    ADD CONSTRAINT media_owner_pictures_pkey PRIMARY KEY (id);


--
-- Name: media_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owners
    ADD CONSTRAINT media_owners_pkey PRIMARY KEY (id);


--
-- Name: option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_types
    ADD CONSTRAINT option_types_pkey PRIMARY KEY (id);


--
-- Name: option_value_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_value_variants
    ADD CONSTRAINT option_value_variants_pkey PRIMARY KEY (id);


--
-- Name: option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY option_values
    ADD CONSTRAINT option_values_pkey PRIMARY KEY (id);


--
-- Name: post_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY post_products
    ADD CONSTRAINT post_products_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: product_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_files
    ADD CONSTRAINT product_files_pkey PRIMARY KEY (id);


--
-- Name: product_option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_option_types
    ADD CONSTRAINT product_option_types_pkey PRIMARY KEY (id);


--
-- Name: product_similarity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_similarity
    ADD CONSTRAINT product_similarity_pkey PRIMARY KEY (id);


--
-- Name: products_containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products_containers
    ADD CONSTRAINT products_containers_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: searched_phrases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searched_phrases
    ADD CONSTRAINT searched_phrases_pkey PRIMARY KEY (id);


--
-- Name: size_guides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY size_guides
    ADD CONSTRAINT size_guides_pkey PRIMARY KEY (id);


--
-- Name: snapped_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapped_photos
    ADD CONSTRAINT snapped_photos_pkey PRIMARY KEY (id);


--
-- Name: snapped_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapped_products
    ADD CONSTRAINT snapped_products_pkey PRIMARY KEY (id);


--
-- Name: sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: temp_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_images
    ADD CONSTRAINT temp_images_pkey PRIMARY KEY (id);


--
-- Name: trending_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trending_contents
    ADD CONSTRAINT trending_contents_pkey PRIMARY KEY (id);


--
-- Name: trendings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trendings
    ADD CONSTRAINT trendings_pkey PRIMARY KEY (id);


--
-- Name: tv_show_background_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_background_images
    ADD CONSTRAINT tv_show_background_images_pkey PRIMARY KEY (id);


--
-- Name: tv_show_cover_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_cover_images
    ADD CONSTRAINT tv_show_cover_images_pkey PRIMARY KEY (id);


--
-- Name: tv_show_seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_seasons
    ADD CONSTRAINT tv_show_seasons_pkey PRIMARY KEY (id);


--
-- Name: tv_shows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_shows
    ADD CONSTRAINT tv_shows_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variant_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY variant_files
    ADD CONSTRAINT variant_files_pkey PRIMARY KEY (id);


--
-- Name: variant_stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY variant_stores
    ADD CONSTRAINT variant_stores_pkey PRIMARY KEY (id);


--
-- Name: variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY variants
    ADD CONSTRAINT variants_pkey PRIMARY KEY (id);


--
-- Name: volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY volumes
    ADD CONSTRAINT volumes_pkey PRIMARY KEY (id);


--
-- Name: wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- Name: index_addresses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_user_id ON addresses USING btree (user_id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON admins USING btree (email);


--
-- Name: index_admins_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_invitation_token ON admins USING btree (invitation_token);


--
-- Name: index_admins_on_invitations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_invitations_count ON admins USING btree (invitations_count);


--
-- Name: index_admins_on_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_admins_on_invited_by_id ON admins USING btree (invited_by_id);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON admins USING btree (reset_password_token);


--
-- Name: index_categories_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_parent_id ON categories USING btree (parent_id);


--
-- Name: index_channel_media_owners_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_channel_media_owners_on_channel_id ON channel_media_owners USING btree (channel_id);


--
-- Name: index_channel_media_owners_on_media_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_channel_media_owners_on_media_owner_id ON channel_media_owners USING btree (media_owner_id);


--
-- Name: index_channel_moderators_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_channel_moderators_on_admin_id ON channel_moderators USING btree (admin_id);


--
-- Name: index_channel_moderators_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_channel_moderators_on_channel_id ON channel_moderators USING btree (channel_id);


--
-- Name: index_channel_pictures_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_channel_pictures_on_channel_id ON channel_pictures USING btree (channel_id);


--
-- Name: index_collection_background_images_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_background_images_on_collection_id ON collection_background_images USING btree (collection_id);


--
-- Name: index_collection_contents_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_contents_on_collection_id ON collection_contents USING btree (collection_id);


--
-- Name: index_collection_contents_on_content_id_and_content_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_contents_on_content_id_and_content_type ON collection_contents USING btree (content_id, content_type);


--
-- Name: index_collection_cover_images_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collection_cover_images_on_collection_id ON collection_cover_images USING btree (collection_id);


--
-- Name: index_collections_containers_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_containers_on_admin_id ON collections_containers USING btree (admin_id);


--
-- Name: index_collections_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_admin_id ON collections USING btree (admin_id);


--
-- Name: index_episodes_on_tv_show_season_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_episodes_on_tv_show_season_id ON episodes USING btree (tv_show_season_id);


--
-- Name: index_event_background_images_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_background_images_on_event_id ON event_background_images USING btree (event_id);


--
-- Name: index_event_contents_on_content_type_and_content_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_contents_on_content_type_and_content_id ON event_contents USING btree (content_type, content_id);


--
-- Name: index_event_contents_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_contents_on_event_id ON event_contents USING btree (event_id);


--
-- Name: index_event_cover_images_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_cover_images_on_event_id ON event_cover_images USING btree (event_id);


--
-- Name: index_events_containers_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_containers_on_admin_id ON events_containers USING btree (admin_id);


--
-- Name: index_events_containers_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_containers_on_channel_id ON events_containers USING btree (channel_id);


--
-- Name: index_events_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_admin_id ON events USING btree (admin_id);


--
-- Name: index_home_contents_on_content_id_and_content_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_home_contents_on_content_id_and_content_type ON home_contents USING btree (content_id, content_type);


--
-- Name: index_home_contents_on_home_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_home_contents_on_home_id ON home_contents USING btree (home_id);


--
-- Name: index_issue_cover_images_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_cover_images_on_issue_id ON issue_cover_images USING btree (issue_id);


--
-- Name: index_issue_page_tags_on_issue_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_page_tags_on_issue_page_id ON issue_page_tags USING btree (issue_page_id);


--
-- Name: index_issue_pages_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_pages_on_issue_id ON issue_pages USING btree (issue_id);


--
-- Name: index_issue_pages_on_issue_id_and_page_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_issue_pages_on_issue_id_and_page_number ON issue_pages USING btree (issue_id, page_number);


--
-- Name: index_issue_tag_products_on_issue_page_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_tag_products_on_issue_page_tag_id ON issue_tag_products USING btree (issue_page_tag_id);


--
-- Name: index_issue_tag_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_tag_products_on_product_id ON issue_tag_products USING btree (product_id);


--
-- Name: index_issues_on_volume_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_volume_id ON issues USING btree (volume_id);


--
-- Name: index_linked_collections_on_collection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_collections_on_collection_id ON linked_collections USING btree (collection_id);


--
-- Name: index_linked_collections_on_collections_container_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_collections_on_collections_container_id ON linked_collections USING btree (collections_container_id);


--
-- Name: index_linked_events_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_events_on_event_id ON linked_events USING btree (event_id);


--
-- Name: index_linked_events_on_events_container_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_events_on_events_container_id ON linked_events USING btree (events_container_id);


--
-- Name: index_linked_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_products_on_product_id ON linked_products USING btree (product_id);


--
-- Name: index_linked_products_on_products_container_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_linked_products_on_products_container_id ON linked_products USING btree (products_container_id);


--
-- Name: index_links_on_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_links_on_target_id ON links USING btree (target_id);


--
-- Name: index_magazine_background_images_on_magazine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_magazine_background_images_on_magazine_id ON magazine_background_images USING btree (magazine_id);


--
-- Name: index_magazine_cover_images_on_magazine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_magazine_cover_images_on_magazine_id ON magazine_cover_images USING btree (magazine_id);


--
-- Name: index_magazines_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_magazines_on_channel_id ON magazines USING btree (channel_id);


--
-- Name: index_media_owner_background_images_on_media_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_owner_background_images_on_media_owner_id ON media_owner_background_images USING btree (media_owner_id);


--
-- Name: index_media_owner_pictures_on_media_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_media_owner_pictures_on_media_owner_id ON media_owner_pictures USING btree (media_owner_id);


--
-- Name: index_option_value_variants_on_option_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_option_value_variants_on_option_value_id ON option_value_variants USING btree (option_value_id);


--
-- Name: index_option_value_variants_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_option_value_variants_on_variant_id ON option_value_variants USING btree (variant_id);


--
-- Name: index_option_values_on_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_option_values_on_option_type_id ON option_values USING btree (option_type_id);


--
-- Name: index_option_values_on_option_type_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_option_values_on_option_type_id_and_name ON option_values USING btree (option_type_id, name);


--
-- Name: index_post_products_on_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_products_on_post_id ON post_products USING btree (post_id);


--
-- Name: index_post_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_post_products_on_product_id ON post_products USING btree (product_id);


--
-- Name: index_posts_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_posts_on_source_id ON posts USING btree (source_id);


--
-- Name: index_posts_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_posts_on_uid ON posts USING btree (uid);


--
-- Name: index_product_categories_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_categories_on_category_id ON product_categories USING btree (category_id);


--
-- Name: index_product_categories_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_categories_on_product_id ON product_categories USING btree (product_id);


--
-- Name: index_product_files_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_files_on_product_id ON product_files USING btree (product_id);


--
-- Name: index_product_option_types_on_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_option_types_on_option_type_id ON product_option_types USING btree (option_type_id);


--
-- Name: index_product_option_types_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_option_types_on_product_id ON product_option_types USING btree (product_id);


--
-- Name: index_product_similarity_on_product_from_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_similarity_on_product_from_id ON product_similarity USING btree (product_from_id);


--
-- Name: index_product_similarity_on_product_to_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_similarity_on_product_to_id ON product_similarity USING btree (product_to_id);


--
-- Name: index_products_containers_on_admin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_containers_on_admin_id ON products_containers USING btree (admin_id);


--
-- Name: index_products_containers_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_containers_on_channel_id ON products_containers USING btree (channel_id);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_name ON products USING btree (name);


--
-- Name: index_products_on_product_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_product_code ON products USING btree (product_code);


--
-- Name: index_products_on_product_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_product_group ON products USING btree (product_group);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_size_guides_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_size_guides_on_category_id ON size_guides USING btree (category_id);


--
-- Name: index_snapped_photos_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapped_photos_on_user_id ON snapped_photos USING btree (user_id);


--
-- Name: index_snapped_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapped_products_on_product_id ON snapped_products USING btree (product_id);


--
-- Name: index_snapped_products_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapped_products_on_user_id ON snapped_products USING btree (user_id);


--
-- Name: index_stores_on_affiliate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stores_on_affiliate_id ON stores USING btree (affiliate_id);


--
-- Name: index_tags_on_media_container_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_media_container_id ON tags USING btree (media_container_id);


--
-- Name: index_tags_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_product_id ON tags USING btree (product_id);


--
-- Name: index_trending_contents_on_content_id_and_content_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trending_contents_on_content_id_and_content_type ON trending_contents USING btree (content_id, content_type);


--
-- Name: index_trending_contents_on_trending_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trending_contents_on_trending_id ON trending_contents USING btree (trending_id);


--
-- Name: index_trendings_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trendings_on_channel_id ON trendings USING btree (channel_id);


--
-- Name: index_tv_show_background_images_on_tv_show_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tv_show_background_images_on_tv_show_id ON tv_show_background_images USING btree (tv_show_id);


--
-- Name: index_tv_show_cover_images_on_tv_show_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tv_show_cover_images_on_tv_show_id ON tv_show_cover_images USING btree (tv_show_id);


--
-- Name: index_tv_show_seasons_on_tv_show_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tv_show_seasons_on_tv_show_id ON tv_show_seasons USING btree (tv_show_id);


--
-- Name: index_tv_shows_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tv_shows_on_channel_id ON tv_shows USING btree (channel_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_uid_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_uid_and_provider ON users USING btree (uid, provider);


--
-- Name: index_variant_files_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_variant_files_on_variant_id ON variant_files USING btree (variant_id);


--
-- Name: index_variant_stores_on_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_variant_stores_on_sku ON variant_stores USING btree (sku);


--
-- Name: index_variant_stores_on_store_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_variant_stores_on_store_id ON variant_stores USING btree (store_id);


--
-- Name: index_variant_stores_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_variant_stores_on_variant_id ON variant_stores USING btree (variant_id);


--
-- Name: index_variants_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_variants_on_product_id ON variants USING btree (product_id);


--
-- Name: index_volumes_on_magazine_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_volumes_on_magazine_id ON volumes USING btree (magazine_id);


--
-- Name: index_wishlists_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlists_on_product_id ON wishlists USING btree (product_id);


--
-- Name: index_wishlists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlists_on_user_id ON wishlists USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: tsvectorupdate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE ON products FOR EACH ROW EXECUTE PROCEDURE tsvector_update_trigger('tsv', 'pg_catalog.english', 'name');


--
-- Name: fk_rails_183ce4e7d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazine_cover_images
    ADD CONSTRAINT fk_rails_183ce4e7d1 FOREIGN KEY (magazine_id) REFERENCES magazines(id);


--
-- Name: fk_rails_271088ec87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY channel_pictures
    ADD CONSTRAINT fk_rails_271088ec87 FOREIGN KEY (channel_id) REFERENCES channels(id);


--
-- Name: fk_rails_396a803954; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_background_images
    ADD CONSTRAINT fk_rails_396a803954 FOREIGN KEY (event_id) REFERENCES events(id);


--
-- Name: fk_rails_3afbfa8a51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_tag_products
    ADD CONSTRAINT fk_rails_3afbfa8a51 FOREIGN KEY (issue_page_tag_id) REFERENCES issue_page_tags(id);


--
-- Name: fk_rails_44e522f5ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_background_images
    ADD CONSTRAINT fk_rails_44e522f5ee FOREIGN KEY (collection_id) REFERENCES collections(id);


--
-- Name: fk_rails_6e7d6c5875; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY magazine_background_images
    ADD CONSTRAINT fk_rails_6e7d6c5875 FOREIGN KEY (magazine_id) REFERENCES magazines(id);


--
-- Name: fk_rails_74b9ed1ef8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_tag_products
    ADD CONSTRAINT fk_rails_74b9ed1ef8 FOREIGN KEY (product_id) REFERENCES products(id);


--
-- Name: fk_rails_8fadb6740c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_background_images
    ADD CONSTRAINT fk_rails_8fadb6740c FOREIGN KEY (media_owner_id) REFERENCES media_owners(id);


--
-- Name: fk_rails_992e963e81; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_owner_pictures
    ADD CONSTRAINT fk_rails_992e963e81 FOREIGN KEY (media_owner_id) REFERENCES media_owners(id);


--
-- Name: fk_rails_a16b63703b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY event_cover_images
    ADD CONSTRAINT fk_rails_a16b63703b FOREIGN KEY (event_id) REFERENCES events(id);


--
-- Name: fk_rails_b247b9356d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_background_images
    ADD CONSTRAINT fk_rails_b247b9356d FOREIGN KEY (tv_show_id) REFERENCES tv_shows(id);


--
-- Name: fk_rails_c1024ece28; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_cover_images
    ADD CONSTRAINT fk_rails_c1024ece28 FOREIGN KEY (issue_id) REFERENCES issues(id);


--
-- Name: fk_rails_c3f112a110; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stores
    ADD CONSTRAINT fk_rails_c3f112a110 FOREIGN KEY (affiliate_id) REFERENCES affiliates(id);


--
-- Name: fk_rails_cad10f0dbe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products_containers
    ADD CONSTRAINT fk_rails_cad10f0dbe FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;


--
-- Name: fk_rails_cfe2a16589; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_pages
    ADD CONSTRAINT fk_rails_cfe2a16589 FOREIGN KEY (issue_id) REFERENCES issues(id);


--
-- Name: fk_rails_e88c104a68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_cover_images
    ADD CONSTRAINT fk_rails_e88c104a68 FOREIGN KEY (collection_id) REFERENCES collections(id);


--
-- Name: fk_rails_eac25ffbef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_page_tags
    ADD CONSTRAINT fk_rails_eac25ffbef FOREIGN KEY (issue_page_id) REFERENCES issue_pages(id);


--
-- Name: fk_rails_f04ecb7adb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tv_show_cover_images
    ADD CONSTRAINT fk_rails_f04ecb7adb FOREIGN KEY (tv_show_id) REFERENCES tv_shows(id);


--
-- Name: fk_rails_feca9d934b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY size_guides
    ADD CONSTRAINT fk_rails_feca9d934b FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160225104006');

INSERT INTO schema_migrations (version) VALUES ('20160225104612');

INSERT INTO schema_migrations (version) VALUES ('20160225111949');

INSERT INTO schema_migrations (version) VALUES ('20160225114517');

INSERT INTO schema_migrations (version) VALUES ('20160225120650');

INSERT INTO schema_migrations (version) VALUES ('20160225122408');

INSERT INTO schema_migrations (version) VALUES ('20160225124456');

INSERT INTO schema_migrations (version) VALUES ('20160225125815');

INSERT INTO schema_migrations (version) VALUES ('20160225130539');

INSERT INTO schema_migrations (version) VALUES ('20160225131437');

INSERT INTO schema_migrations (version) VALUES ('20160225132312');

INSERT INTO schema_migrations (version) VALUES ('20160225133213');

INSERT INTO schema_migrations (version) VALUES ('20160225133811');

INSERT INTO schema_migrations (version) VALUES ('20160225141750');

INSERT INTO schema_migrations (version) VALUES ('20160226133052');

INSERT INTO schema_migrations (version) VALUES ('20160302172625');

INSERT INTO schema_migrations (version) VALUES ('20160303154826');

INSERT INTO schema_migrations (version) VALUES ('20160304125852');

INSERT INTO schema_migrations (version) VALUES ('20160304161547');

INSERT INTO schema_migrations (version) VALUES ('20160307152431');

INSERT INTO schema_migrations (version) VALUES ('20160307160612');

INSERT INTO schema_migrations (version) VALUES ('20160307162140');

INSERT INTO schema_migrations (version) VALUES ('20160308110650');

INSERT INTO schema_migrations (version) VALUES ('20160308110910');

INSERT INTO schema_migrations (version) VALUES ('20160308120821');

INSERT INTO schema_migrations (version) VALUES ('20160308125149');

INSERT INTO schema_migrations (version) VALUES ('20160308150421');

INSERT INTO schema_migrations (version) VALUES ('20160316112903');

INSERT INTO schema_migrations (version) VALUES ('20160316124203');

INSERT INTO schema_migrations (version) VALUES ('20160316125022');

INSERT INTO schema_migrations (version) VALUES ('20160317153510');

INSERT INTO schema_migrations (version) VALUES ('20160317153730');

INSERT INTO schema_migrations (version) VALUES ('20160329104014');

INSERT INTO schema_migrations (version) VALUES ('20160405113303');

INSERT INTO schema_migrations (version) VALUES ('20160406082140');

INSERT INTO schema_migrations (version) VALUES ('20160406092819');

INSERT INTO schema_migrations (version) VALUES ('20160406093938');

INSERT INTO schema_migrations (version) VALUES ('20160406115246');

INSERT INTO schema_migrations (version) VALUES ('20160406133903');

INSERT INTO schema_migrations (version) VALUES ('20160406144759');

INSERT INTO schema_migrations (version) VALUES ('20160406144837');

INSERT INTO schema_migrations (version) VALUES ('20160406145323');

INSERT INTO schema_migrations (version) VALUES ('20160406145602');

INSERT INTO schema_migrations (version) VALUES ('20160407123207');

INSERT INTO schema_migrations (version) VALUES ('20160407144559');

INSERT INTO schema_migrations (version) VALUES ('20160407170018');

INSERT INTO schema_migrations (version) VALUES ('20160408131310');

INSERT INTO schema_migrations (version) VALUES ('20160408142602');

INSERT INTO schema_migrations (version) VALUES ('20160411101714');

INSERT INTO schema_migrations (version) VALUES ('20160411144308');

INSERT INTO schema_migrations (version) VALUES ('20160413104649');

INSERT INTO schema_migrations (version) VALUES ('20160413143344');

INSERT INTO schema_migrations (version) VALUES ('20160413161805');

INSERT INTO schema_migrations (version) VALUES ('20160414141450');

INSERT INTO schema_migrations (version) VALUES ('20160415105744');

INSERT INTO schema_migrations (version) VALUES ('20160415110350');

INSERT INTO schema_migrations (version) VALUES ('20160415114252');

INSERT INTO schema_migrations (version) VALUES ('20160415114400');

INSERT INTO schema_migrations (version) VALUES ('20160415115231');

INSERT INTO schema_migrations (version) VALUES ('20160415130643');

INSERT INTO schema_migrations (version) VALUES ('20160418124510');

INSERT INTO schema_migrations (version) VALUES ('20160418165743');

INSERT INTO schema_migrations (version) VALUES ('20160419153925');

INSERT INTO schema_migrations (version) VALUES ('20160420163944');

INSERT INTO schema_migrations (version) VALUES ('20160421122924');

INSERT INTO schema_migrations (version) VALUES ('20160421165707');

INSERT INTO schema_migrations (version) VALUES ('20160422123706');

INSERT INTO schema_migrations (version) VALUES ('20160422150305');

INSERT INTO schema_migrations (version) VALUES ('20160424131512');

INSERT INTO schema_migrations (version) VALUES ('20160425094037');

INSERT INTO schema_migrations (version) VALUES ('20160425102932');

INSERT INTO schema_migrations (version) VALUES ('20160425153835');

INSERT INTO schema_migrations (version) VALUES ('20160425170230');

INSERT INTO schema_migrations (version) VALUES ('20160425171315');

INSERT INTO schema_migrations (version) VALUES ('20160425215009');

INSERT INTO schema_migrations (version) VALUES ('20160426115003');

INSERT INTO schema_migrations (version) VALUES ('20160504100206');

INSERT INTO schema_migrations (version) VALUES ('20160504142245');

INSERT INTO schema_migrations (version) VALUES ('20160505125840');

INSERT INTO schema_migrations (version) VALUES ('20160510133958');

INSERT INTO schema_migrations (version) VALUES ('20160511111759');

INSERT INTO schema_migrations (version) VALUES ('20160511115919');

INSERT INTO schema_migrations (version) VALUES ('20160512144035');

INSERT INTO schema_migrations (version) VALUES ('20160512162756');

INSERT INTO schema_migrations (version) VALUES ('20160513133544');

INSERT INTO schema_migrations (version) VALUES ('20160513145924');

INSERT INTO schema_migrations (version) VALUES ('20160519130053');

INSERT INTO schema_migrations (version) VALUES ('20160519132811');

INSERT INTO schema_migrations (version) VALUES ('20160530141035');

INSERT INTO schema_migrations (version) VALUES ('20160530141310');

INSERT INTO schema_migrations (version) VALUES ('20160531122914');

INSERT INTO schema_migrations (version) VALUES ('20160531144112');

INSERT INTO schema_migrations (version) VALUES ('20160601104249');

INSERT INTO schema_migrations (version) VALUES ('20160601110434');

INSERT INTO schema_migrations (version) VALUES ('20160601110543');

INSERT INTO schema_migrations (version) VALUES ('20160601112805');

INSERT INTO schema_migrations (version) VALUES ('20160601135959');

INSERT INTO schema_migrations (version) VALUES ('20160601141117');

INSERT INTO schema_migrations (version) VALUES ('20160602105628');

INSERT INTO schema_migrations (version) VALUES ('20160602115531');

INSERT INTO schema_migrations (version) VALUES ('20160602134654');

INSERT INTO schema_migrations (version) VALUES ('20160602141128');

INSERT INTO schema_migrations (version) VALUES ('20160602142837');

INSERT INTO schema_migrations (version) VALUES ('20160603071503');

INSERT INTO schema_migrations (version) VALUES ('20160603082226');

INSERT INTO schema_migrations (version) VALUES ('20160603095804');

INSERT INTO schema_migrations (version) VALUES ('20160606074651');

INSERT INTO schema_migrations (version) VALUES ('20160606075833');

INSERT INTO schema_migrations (version) VALUES ('20160606081804');

INSERT INTO schema_migrations (version) VALUES ('20160606130058');

INSERT INTO schema_migrations (version) VALUES ('20160607085245');

INSERT INTO schema_migrations (version) VALUES ('20160607121548');

INSERT INTO schema_migrations (version) VALUES ('20160607122229');

INSERT INTO schema_migrations (version) VALUES ('20160608134350');

INSERT INTO schema_migrations (version) VALUES ('20160608134437');

INSERT INTO schema_migrations (version) VALUES ('20160608134523');

INSERT INTO schema_migrations (version) VALUES ('20160609125901');

INSERT INTO schema_migrations (version) VALUES ('20160609134706');

INSERT INTO schema_migrations (version) VALUES ('20160609135903');

INSERT INTO schema_migrations (version) VALUES ('20160613132412');

INSERT INTO schema_migrations (version) VALUES ('20160614085304');

INSERT INTO schema_migrations (version) VALUES ('20160614085813');

INSERT INTO schema_migrations (version) VALUES ('20160614143726');

INSERT INTO schema_migrations (version) VALUES ('20160614154340');

INSERT INTO schema_migrations (version) VALUES ('20160614164914');

INSERT INTO schema_migrations (version) VALUES ('20160615111413');

INSERT INTO schema_migrations (version) VALUES ('20160615160335');

INSERT INTO schema_migrations (version) VALUES ('20160615172213');

INSERT INTO schema_migrations (version) VALUES ('20160615191438');

INSERT INTO schema_migrations (version) VALUES ('20160616103122');

INSERT INTO schema_migrations (version) VALUES ('20160616135223');

INSERT INTO schema_migrations (version) VALUES ('20160617113856');

INSERT INTO schema_migrations (version) VALUES ('20160620134650');

INSERT INTO schema_migrations (version) VALUES ('20160620135009');

INSERT INTO schema_migrations (version) VALUES ('20160621123004');

INSERT INTO schema_migrations (version) VALUES ('20160621123521');

INSERT INTO schema_migrations (version) VALUES ('20160622102028');

INSERT INTO schema_migrations (version) VALUES ('20160622103821');

INSERT INTO schema_migrations (version) VALUES ('20160622104754');

INSERT INTO schema_migrations (version) VALUES ('20160622113124');

INSERT INTO schema_migrations (version) VALUES ('20160622121654');

INSERT INTO schema_migrations (version) VALUES ('20160622141744');

INSERT INTO schema_migrations (version) VALUES ('20160622141920');

INSERT INTO schema_migrations (version) VALUES ('20160622142420');

INSERT INTO schema_migrations (version) VALUES ('20160623080832');

INSERT INTO schema_migrations (version) VALUES ('20160623080842');

INSERT INTO schema_migrations (version) VALUES ('20160623081005');

INSERT INTO schema_migrations (version) VALUES ('20160623083025');

INSERT INTO schema_migrations (version) VALUES ('20160623083032');

INSERT INTO schema_migrations (version) VALUES ('20160623083138');

INSERT INTO schema_migrations (version) VALUES ('20160623084108');

INSERT INTO schema_migrations (version) VALUES ('20160623084116');

INSERT INTO schema_migrations (version) VALUES ('20160623121054');

INSERT INTO schema_migrations (version) VALUES ('20160623131321');

INSERT INTO schema_migrations (version) VALUES ('20160624152325');

INSERT INTO schema_migrations (version) VALUES ('20160627150753');

INSERT INTO schema_migrations (version) VALUES ('20160627150834');

INSERT INTO schema_migrations (version) VALUES ('20160629151004');

INSERT INTO schema_migrations (version) VALUES ('20160629171304');

INSERT INTO schema_migrations (version) VALUES ('20160704084102');

INSERT INTO schema_migrations (version) VALUES ('20160704085000');

INSERT INTO schema_migrations (version) VALUES ('20160704140845');

INSERT INTO schema_migrations (version) VALUES ('20160708093954');

INSERT INTO schema_migrations (version) VALUES ('20160708094012');

INSERT INTO schema_migrations (version) VALUES ('20160708094021');

INSERT INTO schema_migrations (version) VALUES ('20160708094025');

INSERT INTO schema_migrations (version) VALUES ('20160708094033');

INSERT INTO schema_migrations (version) VALUES ('20160708132608');

INSERT INTO schema_migrations (version) VALUES ('20160714093349');

INSERT INTO schema_migrations (version) VALUES ('20160722064110');

INSERT INTO schema_migrations (version) VALUES ('20160729081847');

INSERT INTO schema_migrations (version) VALUES ('20160801041306');

INSERT INTO schema_migrations (version) VALUES ('20160804035323');

INSERT INTO schema_migrations (version) VALUES ('20160804035332');

INSERT INTO schema_migrations (version) VALUES ('20160804035336');

INSERT INTO schema_migrations (version) VALUES ('20160804035341');

INSERT INTO schema_migrations (version) VALUES ('20160806045035');

INSERT INTO schema_migrations (version) VALUES ('20160810090945');

INSERT INTO schema_migrations (version) VALUES ('20160811021527');

INSERT INTO schema_migrations (version) VALUES ('20160811040312');

INSERT INTO schema_migrations (version) VALUES ('20160822043334');

INSERT INTO schema_migrations (version) VALUES ('20160822045954');

INSERT INTO schema_migrations (version) VALUES ('20160827042246');

INSERT INTO schema_migrations (version) VALUES ('20160827133823');

