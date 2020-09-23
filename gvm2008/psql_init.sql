create role dba with superuser noinherit;
grant dba to gvmd;
create extension "uuid-ossp";
create extension "pgcrypto";
