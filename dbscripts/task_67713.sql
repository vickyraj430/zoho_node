
CREATE TABLE ddo_proratedkarma (
    ddo_proratedkarma_id SERIAL NOT NULL,
    ddo_org_id integer NOT NULL,
    ddo_client_id integer NOT NULL,
    designation_id integer NOT NULL,
    work_hours integer NOT NULL,
    ddo_karma_id integer NOT NULL,
    karma_points integer NOT NULL,
    karma_percentage double precision NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    createdby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL
);

--PRIMARY KEY query

ALTER TABLE ONLY ddo_proratedkarma
        ADD CONSTRAINT proratedkarma_pk PRIMARY KEY (ddo_proratedkarma_id);
