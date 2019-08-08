-- lower regex usage function

CREATE FUNCTION ddo_lower_regex(value character varying(500)) RETURNS character varying(500) AS $$
BEGIN
RETURN (SELECT lower(regexp_replace(value, '\\s+$', '')));
END; $$
LANGUAGE PLPGSQL;