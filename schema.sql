/*Create database*/



/*DDO_Session*/

CREATE TABLE ddo_Session (
    sid character varying NOT NULL,
    sess json  NOT NULL,
    expire timestamp(6) without time zone NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    logindate timestamp without time zone DEFAULT now() NOT NULL
);

ALTER TABLE ONLY ddo_session
        ADD CONSTRAINT session_pk PRIMARY KEY (sid);

-- FYear

CREATE TABLE DDO_FYear (
    DDO_FYear_ID SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    startDate date DEFAULT date(EXTRACT(YEAR FROM now()) || '-01'|| '-01'),
    endDate date DEFAULT date(EXTRACT(YEAR FROM now()) || '-12'|| '-31')
    name character varying(100) -- 'Jan-2017:Dec-2017'
);


--  PK

ALTER TABLE ONLY DDO_FYear
    ADD CONSTRAINT DDO_FYear_PK PRIMARY KEY (DDO_FYear_ID);



/*DDO_Registration*/
CREATE TABLE DDO_Registration(
    DDO_Registration_ID SERIAL,
    firstname character varying(200) NOT NULL,
    lastname character varying(200) NOT NULL,
    email character varying(150) NOT NULL,
    company character varying(200) NOT NULL,
    designation character varying(100) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    isprocessed character(1) DEFAULT 'N'::bpchar NOT NULL,
    iserror character(1) DEFAULT 'N'::bpchar NOT NULL,
    error_message text,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    UNIQUE (company, email, phonenumber)
);

-- PK

ALTER TABLE ONLY DDO_Registration
    ADD CONSTRAINT registration_pk PRIMARY KEY (DDO_Registration_ID);


/*DDO_Client*/
CREATE TABLE DDO_Client(
    DDO_Client_ID SERIAL,
    name  character varying(200) NOT NULL,
    description  text,
    logo_url  character varying(400),
    firstname  character varying(200) NOT NULL,
    lastname  character varying(200) NOT NULL,
    email  character varying(150) NOT NULL,
    designation  character varying(100),
    address  character varying(1000),
    city  character varying(100),
    state  character varying(100),
    country  character varying(100),
    zipcode  character varying(40),
    phonenumber  character varying(15) NOT NULL,
    key character varying(100) NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    UNIQUE (email, name, phonenumber)
);

-- PK

ALTER TABLE ONLY DDO_Client
        ADD CONSTRAINT client_pk PRIMARY KEY (DDO_Client_ID);

/*DDO_Org*/

CREATE TABLE DDO_Org(
    DDO_Org_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL, 
    name character varying(100) NOT NULL,
    description character varying(255),
    parentOrgId INTEGER,
    key character varying(100) NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Org
        ADD CONSTRAINT org_pk PRIMARY KEY (DDO_Org_ID);

-- FK

ALTER TABLE ONLY DDO_Org
        ADD CONSTRAINT client_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;  

ALTER TABLE ONLY  DDO_Org
    ADD CONSTRAINT org_unique UNIQUE (name);


/*DDO_User*/

CREATE TABLE DDO_User(
    DDO_User_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,   
    username character varying(150) NOT NULL,
    password character varying(200),
    email character varying(150),
    key character varying(150) NOT NULL,
    isadmin character(1) DEFAULT 'N'::bpchar NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_User
        ADD CONSTRAINT user_pk PRIMARY KEY (DDO_User_ID);

-- FK

ALTER TABLE ONLY DDO_User
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_User
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;  

ALTER TABLE ONLY  DDO_User
    ADD CONSTRAINT user_unique UNIQUE (email);

/*DDO_Role*/

CREATE TABLE DDO_Role(
    DDO_Role_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(100),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    key character varying(150) NOT NULL
    );

-- PK

ALTER TABLE ONLY DDO_Role
        ADD CONSTRAINT role_pk PRIMARY KEY (DDO_Role_ID);

-- FK

ALTER TABLE ONLY DDO_Role
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Role
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;  


/*DDO_UserRole*/

CREATE TABLE DDO_UserRole(
    DDO_UserRole_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_User_ID INTEGER NOT NULL,
    DDO_Role_ID INTEGER NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_UserRole
        ADD CONSTRAINT userrole_pk PRIMARY KEY (DDO_UserRole_ID);

-- FK

ALTER TABLE ONLY DDO_UserRole
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_UserRole
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_UserRole
    ADD UNIQUE (DDO_User_ID, DDO_Role_ID);

/*DDO_AppViews*/

CREATE TABLE DDO_AppViews (
    DDO_AppViews_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    app_view_id INTEGER NOT NULL,
    app_view_name character varying(100) NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_AppViews
        ADD CONSTRAINT appview_pk PRIMARY KEY (DDO_AppViews_ID);

-- FK

ALTER TABLE ONLY DDO_AppViews
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_AppViews
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

/*DDO_UserViewAccess*/

CREATE TABLE DDO_UserViewAccess (
    DDO_UserViewAccess_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Role_ID INTEGER NOT NULL,
    appviewid numeric(10,0),
    appviewname character varying(255),
    allow character(1) DEFAULT 'N'::bpchar NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_UserViewAccess
        ADD CONSTRAINT userviewaccess_pk PRIMARY KEY (DDO_UserViewAccess_ID);

-- FK

ALTER TABLE ONLY DDO_UserViewAccess
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_UserViewAccess
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_UserViewAccess
        ADD CONSTRAINT roleid_fk FOREIGN KEY (DDO_Role_ID) REFERENCES DDO_Role(DDO_Role_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Employee*/


CREATE TABLE DDO_Employee (
DDO_Employee_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
firstName  character varying(200) NOT NULL,
lastName character varying(200) NOT NULL,
email character varying(150) NOT NULL,
employee_code INTEGER NOT NULL,
key character varying(150) NOT NULL,
IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
Updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY  DDO_Employee
        ADD CONSTRAINT employee_pk PRIMARY KEY ( DDO_Employee_ID);

-- FK

ALTER TABLE ONLY DDO_Employee
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Employee
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

/*DDO_EmpAddress*/

CREATE TABLE DDO_EmpAddress (
DDO_EmpAddress_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
DDO_Employee_ID INTEGER NOT NULL,
Details  character varying(1000) NOT NULL,
City character varying(150) NOT NULL,
State character varying(100) NOT NULL,
Country character varying(100) NOT NULL,
ZipCode character varying(100) NOT NULL,
Type character varying(4) NOT NULL,-- //  temp /perm / Same 
IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
Updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY  DDO_EmpAddress
        ADD CONSTRAINT empaddress_pk PRIMARY KEY ( DDO_EmpAddress_ID);

-- FK

ALTER TABLE ONLY DDO_EmpAddress
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpAddress
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE ONLY DDO_EmpAddress
        ADD CONSTRAINT empid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED; 


/*DDO_EmpWorkExperience*/

CREATE TABLE DDO_EmpWorkExperience (
    DDO_EmpWorkExperience_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,
            designation character varying(100),
    company character varying(200),
    location character varying(200),
    fromMonth character varying(40),
    fromYear character varying(5),
    toMonth character varying(40),
    toYear character varying(5),
    currentlyWorking character(1) DEFAULT 'N'::bpchar NOT NULL,
    description text,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpWorkExperience
        ADD CONSTRAINT workexperience_pk PRIMARY KEY (DDO_EmpWorkExperience_ID);

-- FK

ALTER TABLE ONLY DDO_EmpWorkExperience
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpWorkExperience
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpWorkExperience
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_EmpSkills*/

CREATE TABLE DDO_EmpSkills (
    DDO_EmpSkill_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,
    primarySkill character(1) DEFAULT 'N'::bpchar NOT NULL,
    skillId INTEGER NOT NULL,
    skillName character varying(100),
    rating INTEGER NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpSkills
        ADD CONSTRAINT skill_pk PRIMARY KEY (DDO_EmpSkill_ID);

-- FK

ALTER TABLE ONLY DDO_EmpSkills
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpSkills
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpSkills
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpSkills
        ADD CONSTRAINT rating CHECK (rating IN(1, 2, 3, 4, 5));

/*DDO_EmpEducation*/

CREATE TABLE DDO_EmpEducation (
    DDO_EmpEducation_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,
    school character varying(400),
    fromDateAttended numeric(5,0),
    toDateAttended numeric(5,0),
    course character varying(100),
    courseId INTEGER NOT NULL,
    description text,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpEducation
        ADD CONSTRAINT education_pk PRIMARY KEY (DDO_EmpEducation_ID);

-- FK

ALTER TABLE ONLY DDO_EmpEducation
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpEducation
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpEducation
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_EmpInterest*/

CREATE TABLE DDO_EmpInterest (
    DDO_EmpInterest_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,
    area character varying(100),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpInterest
        ADD CONSTRAINT interest_pk PRIMARY KEY (DDO_EmpInterest_ID);

-- FK

ALTER TABLE ONLY DDO_EmpInterest
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpInterest
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpInterest
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_EmpImages*/

CREATE TABLE DDO_EmpImages(
    DDO_EmpImage_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,
    profileImage_url character varying(400),
    coverImage_url character varying(400),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpImages
        ADD CONSTRAINT images_pk PRIMARY KEY (DDO_EmpImage_ID);

-- FK

ALTER TABLE ONLY DDO_EmpImages
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpImages
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpImages
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Designation*/

CREATE TABLE DDO_Designation (
    DDO_Designation_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    name character varying(100),
    description character varying(200),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Designation
        ADD CONSTRAINT designation_pk PRIMARY KEY (DDO_Designation_ID);

-- FK

ALTER TABLE ONLY DDO_Designation
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Designation
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Department*/

CREATE TABLE DDO_Department (
    DDO_Department_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    name character varying(100),
    description character varying(200),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Department
        ADD CONSTRAINT ddodepartment_pk PRIMARY KEY (DDO_Department_ID);

-- FK

ALTER TABLE ONLY DDO_Department
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Department
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;



/*DDO_Skills*/

CREATE TABLE DDO_Skills (
    DDO_Skill_ID SERIAL,
    name character varying(100),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL
    
    
);

-- PK

ALTER TABLE ONLY DDO_Skills
        ADD CONSTRAINT ddoskill_pk PRIMARY KEY (DDO_Skill_ID);

/*DDO_EmpWorkDetails*/

CREATE TABLE DDO_EmpWorkDetails(
    DDO_EmpWorkDetails_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Employee_ID INTEGER NOT NULL,
    reportingTo INTEGER,
    designation  INTEGER NOT NULL,
    department  INTEGER NOT NULL,
    primaryskill INTEGER NOT NULL,
    empStatus character varying(50),
    joiningDate timestamp without time zone, 
    confirmDate timestamp without time zone, 
    separatedDate timestamp without time zone, 
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpWorkDetails
        ADD CONSTRAINT department_pk PRIMARY KEY (DDO_EmpWorkDetails_ID);

-- FK

ALTER TABLE ONLY DDO_EmpWorkDetails
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpWorkDetails
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpWorkDetails
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpWorkDetails
        ADD CONSTRAINT skillid_fk FOREIGN KEY (primaryskill) REFERENCES DDO_Skills(DDO_Skill_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DDO_EmpWorkDetails ADD COLUMN isbillable character(1) DEFAULT 'N'::bpchar NOT NULL;


/*DDO_EmpPersonalDetails*/

CREATE TABLE DDO_EmpPersonalDetails(
    DDO_EmpPersonalDetails_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
            DDO_Employee_ID INTEGER NOT NULL,
    DOB timestamp without time zone, 
    gender character(1) NOT NULL,
    maritalStatus  character varying(50),
    anniversaryDate timestamp without time zone, 
    bloodGroup character varying(50),
    panNo character varying(50),
    aadharNo character varying(50),
    phoneNo character varying(12),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_EmpPersonalDetails
        ADD CONSTRAINT personaldetails_pk PRIMARY KEY (DDO_EmpPersonalDetails_ID);

-- FK

ALTER TABLE ONLY DDO_EmpPersonalDetails
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmpPersonalDetails
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmpPersonalDetails
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;



/*DDO_Task*/

CREATE TABLE DDO_Task(
    DDO_Task_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
task text NOT NULL,
task_owner INTEGER NOT NULL,
isdeleted character varying(1) NOT NULL,
iscompleted character varying(1) NOT NULL,
task_type numeric(1, 0) DEFAULT 1 NOT NULL,
task_start_date  timestamp without time zone DEFAULT now() NOT NULL,
task_end_date  timestamp without time zone DEFAULT now() NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Task
        ADD CONSTRAINT task_pk PRIMARY KEY (DDO_Task_ID);

-- FK

ALTER TABLE ONLY DDO_Task
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Task
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Task
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (task_owner) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

/*DDO_Group*/

/*DDO_Group*/

CREATE TABLE DDO_Group (
    DDO_Group_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    name character varying(100),
    owner_id INTEGER NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
 );

-- PK

ALTER TABLE ONLY DDO_Group
        ADD CONSTRAINT group_pk PRIMARY KEY (DDO_Group_ID);

-- FK

ALTER TABLE ONLY DDO_Group
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Group
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Group
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (owner_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;



/*DDO_Group_Member*/

CREATE TABLE DDO_Group_Member (
    DDO_Group_Member_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Group_ID INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);


-- PK

ALTER TABLE ONLY DDO_Group_Member
        ADD CONSTRAINT groupmember_pk PRIMARY KEY (DDO_Group_Member_ID);

-- FK

ALTER TABLE ONLY DDO_Group_Member
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Group_Member
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Group_Member
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (member_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Group_Member
        ADD CONSTRAINT group_fk FOREIGN KEY (DDO_Group_ID) REFERENCES DDO_Group(DDO_Group_ID) DEFERRABLE INITIALLY DEFERRED;



/*DDO_Posts*/

CREATE TABLE DDO_Posts (
    DDO_Posts_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    content text,
    post_type character varying(10),
    sharable character(1) DEFAULT 'N'::bpchar,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Posts
        ADD CONSTRAINT posts_pk PRIMARY KEY (DDO_Posts_ID);

-- FK

ALTER TABLE ONLY DDO_Posts
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Posts
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Posts
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (author_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;



/*DDO_Post_Tag*/

CREATE TABLE DDO_Post_Tag (
    DDO_Post_Tag_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Posts_ID INTEGER NOT NULL,
    DDO_Group_ID INTEGER,
    tag_user_id INTEGER,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Post_Tag
        ADD CONSTRAINT posttag_pk PRIMARY KEY (DDO_Post_Tag_ID);

-- FK

ALTER TABLE ONLY DDO_Post_Tag
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Post_Tag
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Tag
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (tag_user_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Tag
        ADD CONSTRAINT group_fk FOREIGN KEY (DDO_Group_ID) REFERENCES DDO_Group(DDO_Group_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Tag
        ADD CONSTRAINT posts_fk FOREIGN KEY (DDO_Posts_ID) REFERENCES DDO_Posts(DDO_Posts_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Post_Share*/

CREATE TABLE DDO_Post_Share (
    DDO_Post_Share_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Posts_ID INTEGER NOT NULL,
    share_author_id INTEGER NOT NULL,
    share_network character varying(60),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Post_Share
        ADD CONSTRAINT postshare_pk PRIMARY KEY (DDO_Post_Share_ID);

-- FK

ALTER TABLE ONLY DDO_Post_Share
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Post_Share
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Share
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (share_author_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Share
        ADD CONSTRAINT posts_fk FOREIGN KEY (DDO_Posts_ID) REFERENCES DDO_Posts(DDO_Posts_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Post_Like*/

CREATE TABLE DDO_Post_Like (
    DDO_Post_Like_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Posts_ID INTEGER NOT NULL,
    like_author_id INTEGER NOT NULL,
    like_value numeric(10,0),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);


-- PK

ALTER TABLE ONLY DDO_Post_Like
        ADD CONSTRAINT postlike_pk PRIMARY KEY (DDO_Post_Like_ID);

-- FK

ALTER TABLE ONLY DDO_Post_Like
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Post_Like
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Like
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (like_author_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Like
        ADD CONSTRAINT posts_fk FOREIGN KEY (DDO_Posts_ID) REFERENCES DDO_Posts(DDO_Posts_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Post_Attachment*/

CREATE TABLE DDO_Post_Attachment (
    DDO_Post_Attachment_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Posts_ID INTEGER NOT NULL,
    title character varying(100),
    description character varying(200),
    attachment_paths text,
    attachment_type character varying(100),
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_Post_Attachment
        ADD CONSTRAINT postattachment_pk PRIMARY KEY (DDO_Post_Attachment_ID);

-- FK

ALTER TABLE ONLY DDO_Post_Attachment
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Post_Attachment
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Attachment
        ADD CONSTRAINT posts_fk FOREIGN KEY (DDO_Posts_ID) REFERENCES DDO_Posts(DDO_Posts_ID) DEFERRABLE INITIALLY DEFERRED;


/*DDO_Post_Comment*/

CREATE TABLE DDO_Post_Comment (
    DDO_Post_Comment_ID SERIAL,
    DDO_Client_ID INTEGER NOT NULL,
    DDO_Org_ID INTEGER NOT NULL,
    DDO_Posts_ID  INTEGER NOT NULL,
    comment_author_id  INTEGER NOT NULL,
    content text,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    IsReference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL
    );

-- PK

ALTER TABLE ONLY DDO_Post_Comment
        ADD CONSTRAINT postcomment_pk PRIMARY KEY (DDO_Post_Comment_ID);

-- FK

ALTER TABLE ONLY DDO_Post_Comment
        ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_Post_Comment
        ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Comment
        ADD CONSTRAINT employeeid_fk FOREIGN KEY (comment_author_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Post_Comment
        ADD CONSTRAINT posts_fk FOREIGN KEY (DDO_Posts_ID) REFERENCES DDO_Posts(DDO_Posts_ID) DEFERRABLE INITIALLY DEFERRED;



/* DDO_Project */

CREATE TABLE DDO_Project(
    DDO_Project_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    name character varying(255) NOT NULL,
    search_key character varying(60) UNIQUE NOT NULL, -- Unique
    key character varying(150) NOT NULL,
    sales_representative_ID integer,
    isTrackable character(1) DEFAULT 'Y'::bpchar,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    image_url character varying(1000)
);

-- PK

ALTER TABLE ONLY DDO_Project
    ADD CONSTRAINT DDO_Project_PK PRIMARY KEY (DDO_Project_ID);

-- FK

ALTER TABLE ONLY DDO_Project
    ADD CONSTRAINT ddo_project_emp_fk FOREIGN KEY (sales_representative_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Project
    ADD CONSTRAINT ddo_project_clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Project
    ADD CONSTRAINT ddo_project_org_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DDO_Project ADD COLUMN DDO_projects_client_ID integer NOT NULL;


ALTER TABLE ONLY DDO_Project
    ADD CONSTRAINT ddo_projects_clientid_fk FOREIGN KEY (DDO_projects_client_ID) REFERENCES DDO_Projects_Clients(DDO_projects_client_ID) DEFERRABLE INITIALLY DEFERRED;


/* DDO_ProjectRoles */

CREATE TABLE DDO_ProjectRoles(
    DDO_ProjectRoles_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,    
    name character varying(255) NOT NULL,
    key character varying(150) NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    search_key character varying(60) UNIQUE -- Unique
);

-- PK

ALTER TABLE ONLY DDO_ProjectRoles
    ADD CONSTRAINT DDO_ProjectRoles_PK PRIMARY KEY (DDO_ProjectRoles_ID);


-- DDO_ProjectRoles values

INSERT INTO DDO_ProjectRoles(DDO_Client_ID, DDO_Org_ID, IsActive, createdby, updatedby, name, key, search_key) VALUES
(0, 0, 'Y', 0, 0, 'Stake Holder', 1, 'Stake Holder'),
(0, 0, 'Y', 0, 0, 'Project Manager', 2, 'Project Manager'),
(0, 0, 'Y', 0, 0, 'Architect', 3, 'Architect'),
(0, 0, 'Y', 0, 0, 'Business Analyst', 4, 'Business Analyst'),
(0, 0, 'Y', 0, 0, 'Lead', 5, 'Lead'),
(0, 0, 'Y', 0, 0, 'Developer', 6, 'Developer'),
(0, 0, 'Y', 0, 0, 'QA Lead', 7, 'QA Lead'),
(0, 0, 'Y', 0, 0, 'Tester', 8, 'Tester'),
(0, 0, 'Y', 0, 0, 'Senior Web Designer', 9, 'Senior Web Designer'),
(0, 0, 'Y', 0, 0, 'UX Designer', 10, 'UX Designer'),
(0, 0, 'Y', 0, 0, 'Reporter', 11, 'Reporter'),
(0, 0, 'Y', 0, 0, 'Visitor', 12, 'Visitor'),
(0, 0, 'Y', 0, 0, 'HR Admin', 13, 'HR Admin'),
(0, 0, 'Y', 0, 0, 'Customer', 14, 'Customer');

/* DDO_Project_Allocation */

CREATE TABLE DDO_Project_Allocation(
    DDO_Project_Allocation_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,    
    DDO_Project_ID integer NOT NULL,
    DDO_Employee_ID integer NOT NULL,
    DDO_ProjectRoles_ID integer NOT NULL,
    StartDate timestamp without time zone NOT NULL,
    EndDate timestamp without time zone NOT NULL,
    key character varying(150) NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    allocpercent numeric(3,0) NOT NULL,
    IsShadow character(1) DEFAULT 'N'::bpchar NOT NULL
);

-- PK 

ALTER TABLE ONLY DDO_Project_Allocation
    ADD CONSTRAINT DDO_Project_Allocation_PK PRIMARY KEY (DDO_Project_Allocation_ID);

-- FK

ALTER TABLE ONLY DDO_Project_Allocation
    ADD CONSTRAINT DDO_Project_Allocation_clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Project_Allocation
    ADD CONSTRAINT DDO_Project_Allocation_org_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Project_Allocation
    ADD CONSTRAINT DDO_Project_alloc_pro_id_fkey FOREIGN KEY (DDO_Project_ID) REFERENCES DDO_Project(DDO_Project_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_Project_Allocation
    ADD CONSTRAINT DDO_Project_alloc_ddo_emp_fkey FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;  

ALTER TABLE ONLY DDO_Project_Allocation
    ADD CONSTRAINT DDO_Project_alloc_role_id_fkey FOREIGN KEY (DDO_ProjectRoles_ID) REFERENCES DDO_ProjectRoles(DDO_ProjectRoles_ID) DEFERRABLE INITIALLY DEFERRED;


/* DDO_ProjectNotes */

CREATE TABLE DDO_ProjectNotes(
    DDO_ProjectNotes_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    DDO_Project_ID integer NOT NULL,
    Type integer NOT NULL,
    Status integer NOT NULL,
    Title character varying(255) NOT NULL,
    key character varying(150) NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    Description text NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_ProjectNotes
    ADD CONSTRAINT DDO_ProjectNotes_PK PRIMARY KEY (DDO_ProjectNotes_ID);

-- FK

ALTER TABLE ONLY DDO_ProjectNotes
    ADD CONSTRAINT DDO_ProjectNotes_clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_ProjectNotes
    ADD CONSTRAINT DDO_ProjectNotes_org_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_ProjectNotes
    ADD CONSTRAINT DDO_ProjectNotes_c_project_fkey FOREIGN KEY (DDO_Project_ID) REFERENCES DDO_Project(DDO_Project_ID) DEFERRABLE INITIALLY DEFERRED;


/* DDO_MOM  */

CREATE TABLE DDO_MOM(
    DDO_MOM_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    Agenda character varying(255) NOT NULL,
    Description text NOT NULL,
    DDO_Project_ID integer,
    Is_Publish character(1) DEFAULT 'N'::bpchar NOT NULL,
    key character varying(150) NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    Start_Time character varying(255) NOT NULL,
    End_Time character varying(255) NOT NULL,
    Start_Date timestamp without time zone NOT NULL,
    End_Date timestamp without time zone NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_MOM
    ADD CONSTRAINT DDO_MOM_PK PRIMARY KEY (DDO_MOM_ID);

-- FK

ALTER TABLE ONLY DDO_MOM
    ADD CONSTRAINT DDO_MOM_clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM
    ADD CONSTRAINT DDO_MOM_org_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM
    ADD CONSTRAINT DDO_MOM_c_project_fkey FOREIGN KEY (DDO_Project_ID) REFERENCES DDO_Project(DDO_Project_ID) DEFERRABLE INITIALLY DEFERRED;

/* DDO_MOM_Task */

CREATE TABLE DDO_MOM_Task(
    DDO_MOM_Task_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    key character varying(150) NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    updatedby integer NOT NULL,
    DDO_MOM_ID integer NOT NULL,
    DDO_Task_ID integer NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_MOM_Task
    ADD CONSTRAINT DDO_MOM_Task_PK PRIMARY KEY (DDO_MOM_Task_ID);

-- FK

ALTER TABLE ONLY DDO_MOM_Task
    ADD CONSTRAINT DDO_MOM_Task_clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM_Task
    ADD CONSTRAINT DDO_MOM_Task_org_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM_Task
    ADD CONSTRAINT DDO_MOM_Task_mom_id_fkey FOREIGN KEY (DDO_MOM_ID) REFERENCES DDO_MOM(DDO_MOM_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM_Task
    ADD CONSTRAINT DDO_MOM_Task_ddo_emp_fkey FOREIGN KEY (DDO_Task_ID) REFERENCES DDO_Task(DDO_Task_ID) DEFERRABLE INITIALLY DEFERRED;

/* DDO_MOM_Participant */

CREATE TABLE DDO_MOM_Participant(
    DDO_MOM_Participant_ID SERIAL,
    DDO_Client_ID integer NOT NULL,
    DDO_Org_ID integer NOT NULL,
    IsActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    key character varying(150) NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    updatedby integer NOT NULL,
    DDO_MOM_ID integer NOT NULL,
    DDO_Employee_ID integer NOT NULL
);

-- PK

ALTER TABLE ONLY DDO_MOM_Participant
    ADD CONSTRAINT DDO_MOM_Participant_PK PRIMARY KEY (DDO_MOM_Participant_ID);

-- FK

ALTER TABLE ONLY DDO_MOM_Participant
    ADD CONSTRAINT DDO_MOM_Participant_clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM_Participant
    ADD CONSTRAINT DDO_MOM_Participant_org_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM_Participant
    ADD CONSTRAINT DDO_MOM_Participant_mom_id_fkey FOREIGN KEY (DDO_MOM_ID) REFERENCES DDO_MOM(DDO_MOM_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_MOM_Participant
    ADD CONSTRAINT DDO_MOM_Participant_ddo_emp_fkey FOREIGN KEY (DDO_Employee_ID) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;



-- Values for DDO_AppViews

INSERT INTO DDO_APPVIEWS (ddo_client_id, ddo_org_id, isactive, createdby, updatedby, app_view_id, app_view_name) VALUES
 (0, 0,'Y', 0, 0, 1, 'Home'),
 (0, 0,'Y', 0, 0, 2, 'Employee Dashboard'),
 (0, 0,'Y', 0, 0, 3, 'Karmascore'),
 (0, 0,'Y', 0, 0, 4, 'Karma Setup'),
 (0, 0,'Y', 0, 0, 5, 'Business Workflow'),
 (0, 0,'Y', 0, 0, 6, 'Org Chart'),
 (0, 0,'N', 0, 0, 7, 'Job Openings'),
 (0, 0,'Y', 0, 0, 8, 'Groups'),
 (0, 0,'Y', 0, 0, 9, 'Performance'),
 (0, 0,'Y', 0, 0, 10, 'Executive Dashboard'),
 (0, 0,'Y', 0, 0, 11, 'Availability Sheet'),
 (0, 0,'N', 0, 0, 12, 'Job Applicants'),
 (0, 0,'Y', 0, 0, 13, 'Projects'),
 (0, 0,'Y', 0, 0, 14, 'Finance'),
 (0, 0,'Y', 0, 0, 15, 'Sales'),
 (0, 0,'Y', 0, 0, 16, 'HR'),
 (0, 0,'Y', 0, 0, 17, 'Karma Approval'),
 (0, 0,'Y', 0, 0, 18, 'Setup'),
 (0, 0,'Y', 0, 0, 19, 'Account'),
 (0, 0,'Y', 0, 0, 20, 'Designation'),
 (0, 0,'Y', 0, 0, 21, 'Department'),
 (0, 0,'Y', 0, 0, 22, 'Role'),
 (0, 0,'Y', 0, 0, 23, 'Employee'),
 (0, 0,'Y', 0, 0, 24, 'Roles & Security'),
 (0, 0,'Y', 0, 0, 25, 'Help'),
 (0, 0,'Y', 0, 0, 26, 'Karmascore Filters'),
 (0, 0,'Y', 0, 0, 27, 'Support'),
 (0, 0,'Y', 0, 0, 28, 'Redeem'),
 (0, 0,'Y', 0, 0, 29, 'Add New Project'),
 (0, 0,'Y', 0, 0, 30, 'Project New Resource'),
 (0, 0,'Y', 0, 0, 31, 'Product Setup'),
 (0, 0,'Y', 0, 0, 32, 'Attribute'),
 (0, 0,'Y', 0, 0, 33, 'Attribute Value'),
 (0, 0,'Y', 0, 0, 34, 'Category'),
 (0, 0,'Y', 0, 0, 35, 'Product'),
 (0, 0,'Y', 0, 0, 36, 'Settings'),
 (0, 0,'Y', 0, 0, 37, 'Mom'),
 (0, 0,'Y', 0, 0, 38, 'Goals'),
 (0, 0,'Y', 0, 0, 39, 'Leave Management'),
 (0, 0,'Y', 0, 0, 45, 'Access Management'),
 (0, 0,'Y', 0, 0, 46, 'All Apps'),
 (0, 0,'Y', 0, 0, 47, 'Access Control'),
 (0, 0,'Y', 0, 0, 48, 'My Apps'),
 (0, 0,'Y', 0, 0, 50, 'Job Type'),
 (0, 0,'Y', 0, 0, 51, 'Job Education'),
 (0, 0,'Y', 0, 0, 52, 'Application Status'),
 (0, 0,'Y', 0, 0, 53, 'Interview Rating'),
 (0, 0,'Y', 0, 0, 54, 'Interview Status'),
 (0, 0,'Y', 0, 0, 55, 'Job Location'),
 (0, 0,'Y', 0, 0, 56, 'Sourcing Partners'),
 (0, 0,'Y', 0, 0, 57, 'Profile Sources'),
 (0, 0,'N', 0, 0, 58, 'Job Openings'),
 (0, 0,'N', 0, 0, 59, 'Job Applications'),
 (0, 0,'Y', 0, 0, 60, 'Refer A Friend'),
 (0, 0,'Y', 0, 0, 61, 'Referred Employees'),
 (0, 0,'Y', 0, 0, 62, 'My Referrals'),
 (0, 0,'Y', 0, 0, 63, 'Scheduled Interview'),
 (0, 0,'Y', 0, 0, 64, 'Talent Acquisition'),
(0, 0,'Y', 0, 0, 65, 'Charts'),
(0, 0,'Y', 0, 0, 66, 'Job Openings'),
(0, 0,'Y', 0, 0, 67, 'Job Applications'),
(0, 0,'Y', 0, 0, 68, 'Referrals'),
(0, 0,'Y', 0, 0, 69, 'Interview Request'),
(0, 0,'Y', 0, 0, 70, 'EditAction'),
(0, 0,'Y', 0, 0, 71, 'DeleteAction'),
(0, 0,'Y', 0, 0, 72, 'CloseAction'),
(0, 0,'Y', 0, 0, 73, 'Approveaction'),
(0, 0,'Y', 0, 0, 74, 'RejectAction'),
(0, 0,'Y', 0, 0, 75, 'CreateJobOpeningBtn'),
(0, 0,'Y', 0, 0, 76, 'CreateNewJobAppBtn'),
(0, 0,'Y', 0, 0, 77, 'EditJobApplication'),
(0, 0,'Y', 0, 0, 78, 'DeleteJobApplication'),
(0, 0,'Y', 0, 0, 79, 'Schedule Interview View'),
(0, 0,'Y', 0, 0, 80, 'Cancel& Reschedule Btns Show'),
(0, 0,'Y', 0, 0, 81, 'Update Job Application Status'),
(0, 0,'Y', 0, 0, 82, 'Application Enquiry');


-- Karma setup tables


-- DDO_KarmaCategory

CREATE TABLE ddo_karmacategory (
    ddo_karmacategory_id SERIAL,
    DDO_client_id INTEGER NOT NULL,
    DDO_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    name character varying(90) NOT NULL,
    description character varying(255)
);


-- PK 

ALTER TABLE ONLY ddo_karmacategory
    ADD CONSTRAINT ddo_karmacategory_pk PRIMARY KEY (ddo_karmacategory_id);


--  DDO_KarmaRating

CREATE TABLE ddo_karmarating (
    ddo_karmarating_id SERIAL,
    DDO_client_id INTEGER NOT NULL,
    DDO_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    name character varying(90) NOT NULL,
    description character varying(255),
    imagepath character varying(1000)
);


-- PK 

ALTER TABLE ONLY ddo_karmarating
    ADD CONSTRAINT ddo_karmarating_id_pk PRIMARY KEY (ddo_karmarating_id);


-- DDO_KarmaRule

CREATE TABLE ddo_karmarule (
    ddo_karmarule_id SERIAL,
    DDO_client_id INTEGER NOT NULL,
    DDO_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    name character varying(90) NOT NULL,
    description character varying(255)
);


-- PK

ALTER TABLE ONLY ddo_karmarule
    ADD CONSTRAINT ddo_karmarule_id_pk PRIMARY KEY (ddo_karmarule_id);




-- DDO_Karma

CREATE TABLE ddo_karma (
    ddo_karma_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    name character varying(90) NOT NULL,
    description character varying(255),
    ddo_karmacategory_id INTEGER NOT NULL,
    ddo_wallet_id INTEGER DEFAULT 0 NOT NULL,
    isrulebased character(1) DEFAULT 'N'::bpchar,
    isratingbased character(1) DEFAULT 'N'::bpchar,
    showontimeline character(1) DEFAULT 'N'::bpchar,
    autoapproval character(1) DEFAULT 'N'::bpchar,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    ddo_karmarule_id INTEGER
);

-- PK

ALTER TABLE ONLY ddo_karma
    ADD CONSTRAINT ddo_karma_pk PRIMARY KEY (ddo_karma_id);

-- FK    

ALTER TABLE ONLY ddo_karma
    ADD CONSTRAINT ddo_karma_category_fk FOREIGN KEY (ddo_karmacategory_id) REFERENCES ddo_karmacategory(ddo_karmacategory_id) DEFERRABLE INITIALLY DEFERRED;    


-- DDO_KarmaRating_Instances


CREATE TABLE ddo_karmaratings_instance (
    ddo_karmaratings_instance_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_karma_id INTEGER NOT NULL,
    ddo_karmarating_id INTEGER NOT NULL,
    karma_points INTEGER,
    reward_points INTEGER
);


-- PK

ALTER TABLE ONLY ddo_karmaratings_instance
    ADD CONSTRAINT ddo_karmaratings_instance_pk PRIMARY KEY (ddo_karmaratings_instance_id);


-- FK

ALTER TABLE ONLY ddo_karmaratings_instance
    ADD CONSTRAINT ddo_karmaratings_id_fk FOREIGN KEY (ddo_karma_id) REFERENCES ddo_karma(ddo_karma_id) DEFERRABLE INITIALLY DEFERRED;


-- FK



ALTER TABLE ONLY ddo_karmaratings_instance
    ADD CONSTRAINT ddo_karmaratings_instance_fk FOREIGN KEY (ddo_karmarating_id) REFERENCES ddo_karmarating(ddo_karmarating_id) DEFERRABLE INITIALLY DEFERRED;



--  DDO_KarmaRange_Instance

CREATE TABLE ddo_karmarange_instance (
    ddo_karmarange_instnace_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_karma_id INTEGER NOT NULL,
    startrange numeric,
    endrange numeric,
    factor numeric
);


-- PK

ALTER TABLE ONLY ddo_karmarange_instance
    ADD CONSTRAINT ddo_karmarange_instance_pk PRIMARY KEY (ddo_karmarange_instnace_id);


-- FK

ALTER TABLE ONLY ddo_karmarange_instance
    ADD CONSTRAINT ddo_karmarange_karma_id_fk FOREIGN KEY (ddo_karma_id) REFERENCES ddo_karma(ddo_karma_id) DEFERRABLE INITIALLY DEFERRED;



 -- DDO_Nomination table

CREATE TABLE ddo_nomination (
    ddo_nomination_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_karmacategory_id INTEGER NOT NULL,
    ddo_karma_id INTEGER NOT NULL,
    comments text,
    from_employee_id INTEGER NOT NULL,
    to_employee_id INTEGER NOT NULL,
    processed character(1) DEFAULT 'N'::bpchar,
    approved character(1) DEFAULT 'N'::bpchar,
    rejected character(1) DEFAULT 'N'::bpchar,
    ddo_karmarating_id INTEGER,
    karmaunits INTEGER,
    instance_id INTEGER,
    rejectmsg character varying(1000),
    appovalcbpid INTEGER
);




-- PK

ALTER TABLE ONLY ddo_nomination
    ADD CONSTRAINT ddo_nomination_pk PRIMARY KEY (ddo_nomination_id);

-- FK

ALTER TABLE ONLY ddo_nomination
    ADD CONSTRAINT ddo_nomination_karma_id_fk FOREIGN KEY (ddo_karma_id) REFERENCES ddo_karma(ddo_karma_id) DEFERRABLE INITIALLY DEFERRED;

-- FK

ALTER TABLE ONLY ddo_nomination
    ADD CONSTRAINT ddo_nomination_karmacategory_id_fk FOREIGN KEY (ddo_karmacategory_id) REFERENCES ddo_karmacategory(ddo_karmacategory_id) DEFERRABLE INITIALLY DEFERRED;



-- DDO_Wallet


CREATE TABLE ddo_wallet (
    ddo_wallet_id SERIAL
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_employee_id INTEGER NOT NULL,
    DDO_FYear_id INTEGER NOT NULL,
    points INTEGER DEFAULT 0,
    reward_points INTEGER DEFAULT 0,
    karma_points INTEGER DEFAULT 0,
    description character varying(255),
    sharable character(1) DEFAULT 'N'::bpchar
);


--  PK

ALTER TABLE ONLY ddo_wallet
    ADD CONSTRAINT ddo_wallet_pk PRIMARY KEY (ddo_wallet_id);


-- FK

ALTER TABLE ONLY ddo_wallet
    ADD CONSTRAINT ddo_wallet_employee_fkey FOREIGN KEY (DDO_Employee_id) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;


-- PK

ALTER TABLE ONLY ddo_wallet
    ADD CONSTRAINT ddo_wallet_year_fkey FOREIGN KEY ( DDO_FYear_id) REFERENCES  DDO_FYear ( DDO_FYear_id) DEFERRABLE INITIALLY DEFERRED;


-- DDO_KarmaRewardHistory


CREATE TABLE ddo_karmarewardhistory (
    ddo_karmarewardhistory_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_wallet_id INTEGER NOT NULL,
    ddo_nomination_id INTEGER NOT NULL,
    reward_points numeric(10,0),
    karma_points numeric(10,0)
);

--  PK

ALTER TABLE ONLY ddo_karmarewardhistory
    ADD CONSTRAINT ddo_karmarewardhistory_PK PRIMARY KEY (ddo_karmarewardhistory_id);

-- FK

ALTER TABLE ONLY ddo_karmarewardhistory
    ADD CONSTRAINT ddo_karmarewardhistory_fk FOREIGN KEY (ddo_nomination_id) REFERENCES ddo_nomination(ddo_nomination_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_karmarewardhistory_wallet_id_fk; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_karmarewardhistory
    ADD CONSTRAINT ddo_karmarewardhistory_wallet_id_fk FOREIGN KEY (ddo_wallet_id) REFERENCES ddo_wallet(ddo_wallet_id) DEFERRABLE INITIALLY DEFERRED;


-- ddo_wallethistory



CREATE TABLE ddo_wallethistory (
    ddo_wallethistory_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_wallet_id INTEGER NOT NULL,
    ddo_nomination_id INTEGER,
    points numeric(10,0),
    trx_type character varying(20)
);


-- PK

ALTER TABLE ONLY ddo_wallethistory
    ADD CONSTRAINT ddo_wallethistory_pk PRIMARY KEY (ddo_wallethistory_id);


-- FK

ALTER TABLE ONLY ddo_wallethistory
    ADD CONSTRAINT ddo_wallethistory_nomination_id_fk FOREIGN KEY (ddo_nomination_id) REFERENCES ddo_nomination(ddo_nomination_id) DEFERRABLE INITIALLY DEFERRED;

-- FK

ALTER TABLE ONLY ddo_wallethistory
    ADD CONSTRAINT ddo_wallethistory_wallet_id_fk FOREIGN KEY (ddo_wallet_id) REFERENCES ddo_wallet(ddo_wallet_id) DEFERRABLE INITIALLY DEFERRED;


-- ddo_employee_history


CREATE TABLE ddo_employee_history (
    ddo_employee_history_id SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    ddo_employee_id INTEGER NOT NULL, 
    title character varying(400),
    details text,
    tablename character varying(200),
    event character varying(200),
    recordId INTEGER NOT NULL,
    DDO_Karma_ID INTEGER
);



ALTER TABLE ONLY ddo_employee_history
    ADD CONSTRAINT ddo_employee_history_PK  PRIMARY KEY (ddo_employee_history_id);


--
-- PostgreSQL database dump
--


CREATE TABLE ddo_productattribute (
    ddo_productattribute_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL
);


ALTER TABLE adempiere.ddo_productattribute OWNER TO adempiere;


ALTER TABLE ONLY ddo_productattribute
    ADD CONSTRAINT productattribute_pk PRIMARY KEY (ddo_productattribute_id);



--
-- PostgreSQL database dump
--


CREATE TABLE ddo_productattribute_values (
    ddo_productattribute_value_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    value character varying(1000) NOT NULL,
    code character varying(10) NOT NULL,
    ddo_productattribute_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_productattribute_values OWNER TO adempiere;

ALTER TABLE ONLY ddo_productattribute_values
    ADD CONSTRAINT ddo_productattribute_values_pk PRIMARY KEY (ddo_productattribute_value_id);

ALTER TABLE ONLY ddo_productattribute_values
    ADD CONSTRAINT ddo_productattribute_values_fk FOREIGN KEY (ddo_productattribute_id) REFERENCES ddo_productattribute(ddo_productattribute_id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump
--


CREATE TABLE ddo_productcategory (
    ddo_productcategory_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL
);


ALTER TABLE adempiere.ddo_productcategory OWNER TO adempiere;

ALTER TABLE ONLY ddo_productcategory
    ADD CONSTRAINT product_category_pk PRIMARY KEY (ddo_productcategory_id);




--
-- PostgreSQL database dump
--

CREATE TABLE ddo_product (
    ddo_product_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    price integer NOT NULL,
    quantity integer NOT NULL,
    ddo_productcategory_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_product OWNER TO adempiere;

ALTER TABLE ONLY ddo_product
    ADD CONSTRAINT product_pk PRIMARY KEY (ddo_product_id);

ALTER TABLE ONLY ddo_product
    ADD CONSTRAINT product_category_fk FOREIGN KEY (ddo_productcategory_id) REFERENCES ddo_productcategory(ddo_productcategory_id) DEFERRABLE INITIALLY DEFERRED;




--
-- PostgreSQL database dump
--


CREATE TABLE ddo_productattribute_instance (
    ddo_productattribute_instance_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    quantity integer NOT NULL,
    ddo_product_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_productattribute_instance OWNER TO adempiere;

ALTER TABLE ONLY ddo_productattribute_instance
    ADD CONSTRAINT ddo_productattribute_instance_pk PRIMARY KEY (ddo_productattribute_instance_id);

ALTER TABLE ONLY ddo_productattribute_instance
    ADD CONSTRAINT product_fk FOREIGN KEY (ddo_product_id) REFERENCES ddo_product(ddo_product_id) DEFERRABLE INITIALLY DEFERRED;




--
-- PostgreSQL database dump
--

CREATE TABLE ddo_productattributes_set (
    ddo_productattributes_set_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    ddo_product_id integer NOT NULL,
    ddo_productattribute_id integer NOT NULL,
    ddo_productattribute_value_id integer NOT NULL,
    ddo_productattribute_instance_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_productattributes_set OWNER TO adempiere;

ALTER TABLE ONLY ddo_productattributes_set
    ADD CONSTRAINT product_attributeset_pk PRIMARY KEY (ddo_productattributes_set_id);

ALTER TABLE ONLY ddo_productattributes_set
    ADD CONSTRAINT ddo_productattribute_instance_fk FOREIGN KEY (ddo_productattribute_instance_id) REFERENCES ddo_productattribute_instance(ddo_productattribute_instance_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_productattributes_set
    ADD CONSTRAINT product_attribute_fk FOREIGN KEY (ddo_productattribute_id) REFERENCES ddo_productattribute(ddo_productattribute_id) DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE ONLY ddo_productattributes_set
    ADD CONSTRAINT product_attributevalues_fk FOREIGN KEY (ddo_productattribute_value_id) REFERENCES ddo_productattribute_values(ddo_productattribute_value_id) DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE ONLY ddo_productattributes_set
    ADD CONSTRAINT product_fk FOREIGN KEY (ddo_product_id) REFERENCES ddo_product(ddo_product_id) DEFERRABLE INITIALLY DEFERRED;



--
-- PostgreSQL database dump
--


CREATE TABLE ddo_product_images (
    ddo_product_images_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    imagepath character varying(2000) NOT NULL,
    isdefault character(1) DEFAULT 'Y'::bpchar NOT NULL,
    ddo_product_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_product_images OWNER TO adempiere;


ALTER TABLE ONLY ddo_product_images
    ADD CONSTRAINT product_images_pk PRIMARY KEY (ddo_product_images_id);


ALTER TABLE ONLY ddo_product_images
    ADD CONSTRAINT product_images_fk FOREIGN KEY (ddo_product_id) REFERENCES ddo_product(ddo_product_id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump
--
CREATE TABLE ddo_order_status (
    ddo_orderstatus_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    name character varying(100) NOT NULL,
    status character varying(100) NOT NULL
);


ALTER TABLE adempiere.ddo_order_status OWNER TO adempiere;

ALTER TABLE ONLY ddo_order_status
    ADD CONSTRAINT ddo_order_status_pk PRIMARY KEY (ddo_orderstatus_id);

INSERT INTO ddo_order_status (ddo_client_id, ddo_org_id, createdby, updatedby, name, status) VALUES
 ( 11, 1000001, 1001190, 1001190, 'pending', 'pr'),
 (11, 1000001, 1001190, 1001190, 'completed', 'cmp'),
 (11, 1000001, 1001190, 1001190, 'cancelled', 'cl');



 

CREATE TABLE ddo_product_order (
    ddo_product_order_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    description character varying(1000) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    totalprice integer NOT NULL,
    ddo_orderstatus_id integer NOT NULL,
    processed character(1) DEFAULT 'N'::bpchar NOT NULL,
    isapproved character(1) DEFAULT 'Y'::bpchar NOT NULL,
    ddo_employee_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_product_order OWNER TO adempiere;

ALTER TABLE ONLY ddo_product_order
    ADD CONSTRAINT product_order_pk PRIMARY KEY (ddo_product_order_id);

ALTER TABLE ONLY ddo_product_order
    ADD CONSTRAINT product_emp_id_fk FOREIGN KEY (ddo_employee_id) REFERENCES ddo_employee(ddo_employee_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_product_order
    ADD CONSTRAINT product_order_status_fk FOREIGN KEY (ddo_orderstatus_id) REFERENCES ddo_order_status(ddo_orderstatus_id) DEFERRABLE INITIALLY DEFERRED;


CREATE TABLE ddo_product_order_items (
    ddo_product_order_items_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    quantity integer NOT NULL,
    unitprice numeric(10,2) NOT NULL,
    lineprice numeric(10,2) NOT NULL,
    ddo_product_order_id integer NOT NULL,
    processed character(1) DEFAULT 'N'::bpchar NOT NULL,
    ddo_productattribute_id integer,
    ddo_productattributevalue_id numeric(10,2),
    ddo_product_id integer NOT NULL
);


ALTER TABLE adempiere.ddo_product_order_items OWNER TO adempiere;

ALTER TABLE ONLY ddo_product_order_items
    ADD CONSTRAINT ddo_product_order_items_pk PRIMARY KEY (ddo_product_order_items_id);

ALTER TABLE ONLY ddo_product_order_items
    ADD CONSTRAINT ddo_product_order_fk FOREIGN KEY (ddo_product_order_id) REFERENCES ddo_product_order(ddo_product_order_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_product_order_items
    ADD CONSTRAINT product_fk FOREIGN KEY (ddo_product_id) REFERENCES ddo_product(ddo_product_id) DEFERRABLE INITIALLY DEFERRED;


CREATE TABLE ddo_redeemhistory (
    ddo_redeemhistory_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    ddo_wallet_id integer NOT NULL,
    ddo_product_order_id integer NOT NULL,
    redeem_points integer NOT NULL
);


ALTER TABLE ONLY ddo_redeemhistory
    ADD CONSTRAINT ddo_redeemhistory_pk PRIMARY KEY (ddo_redeemhistory_id);

ALTER TABLE ONLY ddo_redeemhistory
    ADD CONSTRAINT ddo_redeemhistory_order_id_fk FOREIGN KEY (ddo_product_order_id) REFERENCES ddo_product_order(ddo_product_order_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_redeemhistory
    ADD CONSTRAINT ddo_redeemhistory_wallet_id_fk FOREIGN KEY (ddo_wallet_id) REFERENCES ddo_wallet(ddo_wallet_id) DEFERRABLE INITIALLY DEFERRED;


-- ddo_url_metadata 
CREATE TABLE ddo_url_metadata (
    ddo_url_metadata_id SERIAL,
    ddo_posts_id integer NOT NULL,
    link text NOT NULL,
    metadata text NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedcount integer DEFAULT 0
);

ALTER TABLE ONLY ddo_url_metadata
    ADD CONSTRAINT ddo_url_metadata_pk PRIMARY KEY (ddo_url_metadata_id);


ALTER TABLE ONLY ddo_url_metadata
    ADD CONSTRAINT ddo_url_metadata_post_id_fk FOREIGN KEY (ddo_posts_id) REFERENCES ddo_posts(ddo_posts_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_employeegoal; Type: TABLE; Schema: adempiere; Owner: adempiere; Tablespace: 
--

CREATE TABLE ddo_employeegoal (
    ddo_employeegoal_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    name character varying(1000) NOT NULL,
    parentgoalid integer,
    targetdate timestamp without time zone NOT NULL,
    measurementcriteria text NOT NULL,
    ddo_goalstatus_id integer NOT NULL,
    ddo_employee_id integer NOT NULL,
    karmapoints integer
);

--
-- Name: ddo_employeegoal_pk; Type: CONSTRAINT; Schema: adempiere; Owner: adempiere; Tablespace: 
--

ALTER TABLE ONLY ddo_employeegoal
    ADD CONSTRAINT ddo_employeegoal_pk PRIMARY KEY (ddo_employeegoal_id);


--
-- Name: ddo_employeegoal_ddo_employee_fkey; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_employeegoal
    ADD CONSTRAINT ddo_employeegoal_ddo_employee_fkey FOREIGN KEY (ddo_employee_id) REFERENCES ddo_employee(ddo_employee_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_goalnote; Type: TABLE; Schema: adempiere; Owner: adempiere; Tablespace: 
--

CREATE TABLE ddo_goalnote (
    ddo_goalnote_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    details text NOT NULL,
    notetype text NOT NULL,
    ddo_employeegoal_id integer NOT NULL
);

--
-- Name: ddo_goalnote_pk; Type: CONSTRAINT; Schema: adempiere; Owner: adempiere; Tablespace: 
--

ALTER TABLE ONLY ddo_goalnote
    ADD CONSTRAINT ddo_goalnote_pk PRIMARY KEY (ddo_goalnote_id);


--
-- Name: ddo_goalnote_ddo_employeegoal_fkey; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_goalnote
    ADD CONSTRAINT ddo_goalnote_ddo_employeegoal_fkey FOREIGN KEY (ddo_employeegoal_id) REFERENCES ddo_employeegoal(ddo_employeegoal_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_goalrating; Type: TABLE; Schema: adempiere; Owner: adempiere; Tablespace: 
--

CREATE TABLE ddo_goalrating (
    ddo_goalrating_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    ddo_employeegoal_id integer NOT NULL,
    selfcomment text,
    managercomment text,
    karmapoints integer,
    ddo_nomination_id integer,
    ratingtext character varying(60)
);

--
-- Name: ddo_goalrating_pk; Type: CONSTRAINT; Schema: adempiere; Owner: adempiere; Tablespace: 
--

ALTER TABLE ONLY ddo_goalrating
    ADD CONSTRAINT ddo_goalrating_pk PRIMARY KEY (ddo_goalrating_id);


--
-- Name: ddo_ddo_nomination_id_fkey; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_goalrating
    ADD CONSTRAINT ddo_ddo_nomination_id_fkey FOREIGN KEY (ddo_nomination_id) REFERENCES ddo_nomination(ddo_nomination_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_goalrating_ddo_employeegoal_fkey; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_goalrating
    ADD CONSTRAINT ddo_goalrating_ddo_employeegoal_fkey FOREIGN KEY (ddo_employeegoal_id) REFERENCES ddo_employeegoal(ddo_employeegoal_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_goalshare; Type: TABLE; Schema: adempiere; Owner: adempiere; Tablespace: 
--

CREATE TABLE ddo_goalshare (
    ddo_goalshare_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    ddo_employeegoal_id integer NOT NULL,
    sharewith_ddo_employee_id integer NOT NULL
);

--
-- Name: ddo_goalshare_pk; Type: CONSTRAINT; Schema: adempiere; Owner: adempiere; Tablespace: 
--

ALTER TABLE ONLY ddo_goalshare
    ADD CONSTRAINT ddo_goalshare_pk PRIMARY KEY (ddo_goalshare_id);


--
-- Name: ddo_goalshare_ddo_employeegoal_fkey; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_goalshare
    ADD CONSTRAINT ddo_goalshare_ddo_employeegoal_fkey FOREIGN KEY (ddo_employeegoal_id) REFERENCES ddo_employeegoal(ddo_employeegoal_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_goalshare_sharewith_ddo_employee_fkey; Type: FK CONSTRAINT; Schema: adempiere; Owner: adempiere
--

ALTER TABLE ONLY ddo_goalshare
    ADD CONSTRAINT ddo_goalshare_sharewith_ddo_employee_fkey FOREIGN KEY (sharewith_ddo_employee_id) REFERENCES ddo_employee(ddo_employee_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ddo_goalstatus; Type: TABLE; Schema: adempiere; Owner: adempiere; Tablespace: 
--

CREATE TABLE ddo_goalstatus (
    ddo_goalstatus_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    name character varying(255) NOT NULL,
    key character varying(60) NOT NULL
);

--
-- Name: ddo_goalstatus_pk; Type: CONSTRAINT; Schema: adempiere; Owner: adempiere; Tablespace: 
--

ALTER TABLE ONLY ddo_goalstatus
    ADD CONSTRAINT ddo_goalstatus_pk PRIMARY KEY (ddo_goalstatus_id);


--
-- Data for Name: ddo_goalstatus; Type: TABLE DATA; Schema: adempiere; Owner: adempiere
-- Insert values for ddo_goalstatus table

INSERT INTO ddo_goalstatus VALUES (1, 0, 0, 0, 0, 'Draft', 'Draft');
INSERT INTO ddo_goalstatus VALUES (2, 0, 0, 0, 0, 'Pending', 'Pending');
INSERT INTO ddo_goalstatus VALUES (3, 0, 0, 0, 0, 'In Progress', 'In Progress');
INSERT INTO ddo_goalstatus VALUES (4, 0, 0, 0, 0, 'Completed', 'Completed');
INSERT INTO ddo_goalstatus VALUES (5, 0, 0, 0, 0, 'Achieved', 'Achieved');
INSERT INTO ddo_goalstatus VALUES (6, 0, 0, 0, 0, 'Re-Open', 'reopen');
INSERT INTO ddo_goalstatus VALUES (7, 0, 0, 0, 0, 'Cancel', 'cancel');

-- ddo_client_setting

CREATE TABLE ddo_client_setting (
    ddo_client_setting_id SERIAL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    roleIds character varying(200) NOT NULL,
    setting_id numeric(1,0) NOT NUll
);


ALTER TABLE ONLY ddo_client_setting
    ADD CONSTRAINT ddo_client_setting_pk PRIMARY KEY (ddo_client_setting_id);

ALTER TABLE ONLY ddo_client_setting
    ADD CONSTRAINT clientid_fk FOREIGN KEY (ddo_client_id) REFERENCES ddo_client(ddo_client_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_client_setting
    ADD CONSTRAINT orgid_fk FOREIGN KEY (ddo_org_id) REFERENCES ddo_org(ddo_org_id) DEFERRABLE INITIALLY DEFERRED;

-- ddo_emailtemplate

CREATE TABLE ddo_emailtemplate (
    ddo_emailtemplate_id SERIAL,
    title text NOT NULL,
    body text NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    isreference character(1) DEFAULT 'N'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE ONLY ddo_emailtemplate
    ADD CONSTRAINT emailtemplate_pk PRIMARY KEY (ddo_emailtemplate_id);

--ddo_emailtemplate data

INSERT INTO ddo_emailtemplate(title, body) VALUES 
('We are missing you', './templates/Template1.hbs'),
('Your wallet is expire soon', './templates/Template2.hbs'),
('Good to see you contributing more', './templates/Template6.hbs'),
('You seem to be tough', './templates/Template3.hbs'),
('Less karmascore points  ', './templates/Template4.hbs'),
('Top 10 KarmaScores', './templates/Template5.hbs'),
('Registration', './templates/Template7.hbs'),
('Nomination', './templates/Template8.hbs');

-- DDO_WalletSettings

CREATE TABLE DDO_WalletSettings (
    DDO_WalletSettings_ID SERIAL,
    ddo_client_id INTEGER NOT NULL,
    ddo_org_id INTEGER NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby INTEGER NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby INTEGER NOT NULL,
    default_points INTEGER DEFAULT 500 NOT NULL,
    emp_percent numeric(3,0) DEFAULT 50 NOT NULL,
    manager_percent numeric(3,0) DEFAULT 40 NOT NULL,
    manager_manager_percent numeric(3,0) DEFAULT 10 NOT NULL
);

--  PK

ALTER TABLE ONLY DDO_WalletSettings
    ADD CONSTRAINT DDO_WalletSettings_PK PRIMARY KEY (DDO_WalletSettings_ID);

--ddo_walletsettings data

INSERT INTO ddo_walletsettings(ddo_client_id, ddo_org_id, createdby, updatedby) VALUES 
(0, 0, 0, 0);


--DDO_KarmaAccess

CREATE TABLE ddo_karmaaccess (
    ddo_karmaaccess_id integer NOT NULL,
    ddo_client_id integer NOT NULL,
    ddo_org_id integer NOT NULL,
    isactive character(1) DEFAULT 'Y'::bpchar,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdby integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedby integer NOT NULL,
    ddo_karma_id integer NOT NULL,
    ddo_employee_id text,
    ddo_role_id text
);

ALTER TABLE ONLY DDO_KarmaAccess
    ADD CONSTRAINT DDO_KarmaAccess_pk PRIMARY KEY (DDO_KarmaAccess_ID);

ALTER TABLE ONLY DDO_KarmaAccess
    ADD CONSTRAINT karmaid_fk FOREIGN KEY (ddo_karma_id) REFERENCES ddo_karma(ddo_karma_id) DEFERRABLE INITIALLY DEFERRED;


    CREATE TABLE DDO_AccessApp (
    DDO_AccessApp_ID SERIAL,
    DDO_Client_Id integer,
    DDO_Org_Id integer,
    IsActive character(1) DEFAULT 'Y'::bpchar,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedBy integer NOT NULL,
    name character varying(150) NOT NULL,
    imageUrl character varying(255) NOT NULL,
    allowedUserCount integer NOT NULL,
    activeUserCount integer NOT NULL,
    clientName character(255) NOT NULL,
    description character varying(255) NOT NULL,
    ownerId integer NOT NULL
);

-- PK 
ALTER TABLE ONLY DDO_AccessApp
    ADD CONSTRAINT ddo_accessapp_pkey PRIMARY KEY (DDO_AccessApp_ID);

ALTER TABLE ONLY ddo_AccessApp
    ADD CONSTRAINT ddo_app_ownerId_fkey FOREIGN KEY (ownerId) REFERENCES ddo_employee(ddo_employee_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_AccessApp
    ADD CONSTRAINT ddo_AccessApp_name_key UNIQUE (name);



----------------------------------------------------------------------------------------
CREATE TABLE ddo_AccessApp_Status (
    DDO_AccessApp_Status_ID serial,
    DDO_Client_Id integer NOT NULL,
    DDO_Org_Id integer NOT NULL,
    isActive character(1) DEFAULT 'Y'::bpchar,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedBy integer NOT NULL,
    name character varying(255),
    key character varying(255),
    isReference character(1) DEFAULT 'N'::bpchar

);

-- PK 
ALTER TABLE ONLY ddo_AccessApp_Status
    ADD CONSTRAINT ddo_AccessAppstatus_pkey PRIMARY KEY   (DDO_AccessApp_Status_ID);

    ----------------------------------------------------------------------------------------
CREATE TABLE ddo_AccessApp_Request (
    ddo_AccessApp_Request_ID serial,
    DDO_Employee_ID integer NOT NULL,
    DDO_AccessApp_ID integer NOT NULL,
    DDO_Client_Id integer NOT NULL,
    DDO_Org_Id integer NOT NULL,
    isActive character(1) DEFAULT 'Y'::bpchar,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedBy integer NOT NULL,
    fromDate timestamp without time zone,
    endDate timestamp without time zone,
    DDO_AccessApp_Status_ID integer NOT NULL,
    requestReason character varying(255),
    rejectReason character varying(255)
);


ALTER TABLE ONLY ddo_AccessApp_Request
    ADD CONSTRAINT ddo_AccessAppRequest_pkey PRIMARY KEY   (ddo_AccessApp_Request_ID);

ALTER TABLE ONLY ddo_AccessApp_Request
    ADD CONSTRAINT ddo_AccessAppRequest_user_app_id_fkey FOREIGN KEY (DDO_AccessApp_ID) REFERENCES DDO_AccessApp(DDO_AccessApp_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_AccessApp_Request
    ADD CONSTRAINT ddo_AccessAppRequest_Employee_ID_fkey FOREIGN KEY (DDO_Employee_ID) REFERENCES ddo_employee(ddo_employee_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_AccessApp_Request
    ADD CONSTRAINT ddo_AccessApp_Request_DDO_AccessApp_Status_ID_fkey FOREIGN KEY  (DDO_AccessApp_Status_ID) REFERENCES ddo_AccessApp_Status(DDO_AccessApp_Status_ID) DEFERRABLE INITIALLY DEFERRED;

---------------------------------------------------------------------------------------


CREATE TABLE DDO_AppAccessHistory (
    DDO_AppAccessHistory_ID SERIAL,
    DDO_AppAccess_ID INTEGER NOT NULL,
    DDO_AppAccessRequest_ID INTEGER NOT NULL,
    DDO_AppStatus_ID INTEGER NOT NULL,
    DDO_Client_Id integer NOT NULL,
    DDO_Org_Id integer NOT NULL,
    isActive character(1) DEFAULT 'Y'::bpchar,
    created timestamp without time zone DEFAULT now() NOT NULL,
    createdBy integer NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    updatedBy integer NOT NULL,
    request_start_date timestamp without time zone,
    request_end_date timestamp without time zone
);
ALTER TABLE ONLY ddo_AppAccessHistory
    ADD CONSTRAINT ddo_AppAccessHistory_pkey PRIMARY KEY   (DDO_AppAccessHistory_ID);

ALTER TABLE ONLY ddo_AppAccessHistory
    ADD CONSTRAINT ddo_AppAccessHistory_DDO_AppAccess_ID_fkey FOREIGN KEY  (DDO_AppAccess_ID) REFERENCES ddo_AccessApp(ddo_AccessApp_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_AppAccessHistory
    ADD CONSTRAINT ddo_AppAccessHistory_DDO_AppAccessRequest_ID_fkey FOREIGN KEY  (DDO_AppAccessRequest_ID) REFERENCES ddo_AccessApp_Request(ddo_AccessApp_Request_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY ddo_AppAccessHistory
    ADD CONSTRAINT ddo_AppAccessHistory_DDO_AppStatus_ID_fkey FOREIGN KEY  (DDO_AppStatus_ID) REFERENCES ddo_AccessApp_Status(DDO_AccessApp_Status_ID) DEFERRABLE INITIALLY DEFERRED;

--------------------------------------------------------------------------------
/*  DDO Job Module JOb Opening Request table creation*/

CREATE TABLE DDO_JobOpening(

DDO_JobOpening_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
DDO_Department_ID INTEGER NOT NULL,
DDO_JobLocation_ID INTEGER NOT NULL,
DDO_JobOpeningStatus_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
title character varying(200) NOT NULL,
description text,
noOfpositions INTEGER NOT NULL,
minWorkExperience INTEGER NOT NULL,
maxWorkExperience INTEGER NOT NULL,
skill_ids character varying(200) NOT NULL,
interviewers_ids character varying(200) NOT NULL      
);



ALTER TABLE ONLY DDO_JobOpening
        ADD CONSTRAINT jobopening_pk PRIMARY KEY (DDO_JobOpening_ID);

ALTER TABLE ONLY DDO_JobOpening
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobOpening
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobOpening
         ADD CONSTRAINT joblocation_id_fk FOREIGN KEY (ddo_joblocation_id) REFERENCES DDO_JobLocation(ddo_joblocation_id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobOpening
         ADD CONSTRAINT joblstatus_id_fk FOREIGN KEY (ddo_jobopeningstatus_id) REFERENCES DDO_JobOpeningStatus(ddo_jobopeningstatus_id) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE DDO_JobOpening 
        ADD COLUMN DDO_projects_client_ID integer NOT NULL;
        
ALTER TABLE ONLY DDO_JobOpening
    ADD CONSTRAINT ddo_projects_clientid_fk FOREIGN KEY (DDO_projects_client_ID) REFERENCES DDO_Projects_Clients(DDO_projects_client_ID) DEFERRABLE INITIALLY DEFERRED;


/* Job Status Table creation*/
CREATE TABLE DDO_JobOpeningStatus(

DDO_JobOpeningStatus_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200)
);


ALTER TABLE ONLY DDO_JobOpeningStatus
        ADD CONSTRAINT jobstatus_pk PRIMARY KEY (DDO_JobOpeningStatus_ID);

ALTER TABLE ONLY DDO_JobOpeningStatus
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobOpeningStatus
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

/* To Drop tables related to Talent Acquisition*/
drop table ddo_jobapplications,ddo_jobapplicationstatus,ddo_jobeducation,ddo_jobinterviewfeedback,ddo_jobinterviewrating,ddo_jobinterviewstatus,ddo_jobopenings,ddo_jobskills,ddo_jobsource,ddo_jobsourcelines,ddo_jobtype,ddo_scheduleinterview,ddo_employeereferral


/* To de -activate the Talent Acquisition views from Roles & security*/
update ddo_appviews set isactive = 'N' where app_view_id in (50,51,52,53,54,55,56,57,58,59,60,61,62,63,64)


/* Recruitement Module - Interview Screen*/

CREATE TABLE DDO_InterviewRating(

DDO_InterviewRating_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_InterviewRating
        ADD CONSTRAINT interviewrating_pk PRIMARY KEY (DDO_InterviewRating_ID);

ALTER TABLE ONLY DDO_InterviewRating
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_InterviewRating
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

/* Table - job Application Interview*/
CREATE TABLE DDO_JobApplicationInterview(

DDO_JobApplicationInterview_ID SERIAL,
DDO_JobApplication_ID INTEGER NOT NULL,
DDO_JobInterviewStatus_ID INTEGER NOT NULL,
DDO_InterviewRating_ID INTEGER,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
interviewer_id INTEGER,
interviewType character varying(50),
interviewDate timestamp without time zone,
interviewTime character varying(10),
feedback character varying(1000),
interviewmode character varying(50) 
);

ALTER TABLE ONLY DDO_JobApplicationInterview
        ADD CONSTRAINT jobapplicationinterview_pk PRIMARY KEY (DDO_JobApplicationInterview_ID);

ALTER TABLE ONLY DDO_JobApplicationInterview
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobApplicationInterview
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE DDO_JobApplicationInterview ADD COLUMN interviewmode character varying(50);


/* Table - jobJobInterviewStatus*/
CREATE TABLE DDO_JobInterviewStatus(

DDO_JobInterviewStatus_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_JobInterviewStatus
        ADD CONSTRAINT jobinterviewstatus_pk PRIMARY KEY (DDO_JobInterviewStatus_ID);

ALTER TABLE ONLY DDO_JobInterviewStatus
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobInterviewStatus
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

/* Table - jobJobApplicationStatus*/
CREATE TABLE DDO_JobApplicationStatus(

DDO_JobApplicationStatus_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,
description character varying(500)
);

ALTER TABLE ONLY DDO_JobApplicationStatus
        ADD CONSTRAINT jobapplicationstatus_pk PRIMARY KEY (DDO_JobApplicationStatus_ID);

ALTER TABLE ONLY DDO_JobApplicationStatus
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobApplicationStatus
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;
/*Table*/
CREATE TABLE DDO_JobApplication(

DDO_JobApplication_ID SERIAL,
DDO_JobOpening_ID INTEGER NOT NULL,
DDO_JobApplicationStatus_ID INTEGER NOT NULL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
firstName  character varying(20) NOT NULL,
lastName character varying(20) NOT NULL,
currentJobTitle character varying(50),
workExpYears numeric,
workExpMonths numeric,
currentLocation character varying(255),
ddo_jobeducation_ID integer,
collegeName character varying(255),
mobile character varying(12) NOT NULL,
emailId character varying(50) NOT NULL,
DDO_JobHiringSource_ID integer,
jobPortalName character varying(50),
DDO_employeereferral_ID INTEGER,
resumePath character varying(225),
declineReason character varying(1000),
recruiter character varying(200),
preferred_location character varying(200),
submission_date character varying(200)
);


ALTER TABLE ONLY DDO_JobApplication
        ADD CONSTRAINT jobapplication_pk PRIMARY KEY (DDO_JobApplication_ID);

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT jobopening_fk FOREIGN KEY (DDO_JobOpening_ID) REFERENCES DDO_JobOpening(DDO_JobOpening_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT jobappstatus_fk FOREIGN KEY (DDO_JobApplicationStatus_ID) REFERENCES DDO_JobApplicationStatus(DDO_JobApplicationStatus_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT jobeducationid_fk FOREIGN KEY (DDO_JobEducation_ID) REFERENCES DDO_Jobeducation(DDO_JobEducation_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT jobhiringsourceid_fk FOREIGN KEY (DDO_JobHiringSource_ID) REFERENCES DDO_JobHiringSource(DDO_JobHiringSource_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_JobApplication
         ADD CONSTRAINT emplid_fk FOREIGN KEY (DDO_EmployeeReferral_ID) REFERENCES DDO_EmployeeReferral(DDO_EmployeeReferral_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ddo_jobapplication ADD CONSTRAINT unique_apps UNIQUE (firstname,lastname,mobile,emailid,ddo_jobopening_id);

/*Table*/
CREATE TABLE DDO_EmployeeReferral(

DDO_employeereferral_ID SERIAL,
Referred_BY INTEGER,
Relationship CHARACTER varying(255),
Recommendation character varying(1000),
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL
);

ALTER TABLE ONLY DDO_EmployeeReferral
        ADD CONSTRAINT employeerefid_pk PRIMARY KEY (DDO_employeereferral_ID);

ALTER TABLE ONLY DDO_EmployeeReferral
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_EmployeeReferral
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY DDO_EmployeeReferral
         ADD CONSTRAINT empid_fk FOREIGN KEY (Referred_By) REFERENCES DDO_Employee(DDO_Employee_ID) DEFERRABLE INITIALLY DEFERRED;


/*table*/
CREATE TABLE DDO_JobHiringSource(

DDO_JobHiringSource_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200)
);


ALTER TABLE ONLY DDO_JobHiringSource
        ADD CONSTRAINT hiringsource_pk PRIMARY KEY (DDO_JobHiringSource_ID);

ALTER TABLE ONLY DDO_JobHiringSource
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobHiringSource
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;

/*table*/
CREATE TABLE DDO_JobEducation(

DDO_JobEducation_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,
description character varying(500)
);


ALTER TABLE ONLY DDO_JobEducation
        ADD CONSTRAINT educationid_pk PRIMARY KEY (DDO_JobEducation_ID);

ALTER TABLE ONLY DDO_JobEducation
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobEducation
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;


/*table*/

CREATE TABLE ddo_preferences(

ddo_preference_id SERIAL,
ddo_client_id INTEGER NOT NULL,
ddo_org_id INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdby INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedby INTEGER NOT NULL,
isactive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200),
tableName character varying(200)
);

ALTER TABLE ONLY ddo_preferences ADD CONSTRAINT preferenceid_pk PRIMARY KEY (ddo_preference_id)

/* JobType Table*/

CREATE TABLE DDO_JobType(

DDO_JobType_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_JobType
        ADD CONSTRAINT JobType_pk PRIMARY KEY (DDO_JobType_ID);

ALTER TABLE ONLY DDO_JobType
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_JobType
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;


/* JOBLOCATION table creation */
CREATE TABLE DDO_joblocation(

DDO_joblocation_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_joblocation
        ADD CONSTRAINT joblocation_pk PRIMARY KEY (DDO_joblocation_ID);

ALTER TABLE ONLY DDO_joblocation
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_joblocation
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;
/*JobSourcingPartners table creation */

CREATE TABLE DDO_jobsourcingpartners(

DDO_jobsourcingpartners_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_jobsourcingpartners
        ADD CONSTRAINT jobsourcingpartners_pk PRIMARY KEY (DDO_jobsourcingpartners_ID);

ALTER TABLE ONLY DDO_jobsourcingpartners
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_jobsourcingpartners
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED; 
/* JobProfileSources table creation */

CREATE TABLE DDO_jobprofilesources(

DDO_jobprofilesources_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_jobprofilesources
        ADD CONSTRAINT jobprofilesources_pk PRIMARY KEY (DDO_jobprofilesources_ID);

ALTER TABLE ONLY DDO_jobprofilesources
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_jobprofilesources
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;    
/* interviewtype table creation */

CREATE TABLE DDO_interviewtype(

DDO_interviewtype_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_interviewtype
        ADD CONSTRAINT interviewtype_pk PRIMARY KEY (DDO_interviewtype_ID);

ALTER TABLE ONLY DDO_interviewtype
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_interviewtype
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;    

INSERT INTO ddo_interviewtype(
            ddo_client_id, ddo_org_id, createdby, updatedby, isactive, name, description)
    VALUES (11,1000001,1001228,1001228,'Y','Managerial','Managerial');

/* interviewmode table creation */

CREATE TABLE DDO_interviewmode(

DDO_interviewmode_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(200) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_interviewmode
        ADD CONSTRAINT interviewmode_pk PRIMARY KEY (DDO_interviewmode_ID);

ALTER TABLE ONLY DDO_interviewmode
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_interviewmode
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;    


INSERT INTO ddo_interviewmode(
            ddo_client_id, ddo_org_id, createdby, updatedby, isactive, name, description)
    VALUES (11,1000001,1001228,1001228,'Y','Face-to-Face','Face-to-Face');

/* Project Technologies table creation */

CREATE TABLE DDO_project_technologies(

DDO_project_technology_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
DDO_Project_ID integer NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(300) NOT NULL,  
description character varying(100)
);

ALTER TABLE ONLY DDO_project_technologies
        ADD CONSTRAINT project_technology_pk PRIMARY KEY (DDO_project_technology_ID);

ALTER TABLE ONLY DDO_project_technologies
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_project_technologies
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;    

ALTER TABLE ONLY DDO_project_technologies
    ADD CONSTRAINT DDO_ProjectTechnologies_project_fk FOREIGN KEY (DDO_Project_ID) REFERENCES DDO_Project(DDO_Project_ID) DEFERRABLE INITIALLY DEFERRED;

/* Project Clients table creation */

CREATE TABLE DDO_projects_clients(

DDO_projects_client_ID SERIAL,
DDO_Client_ID INTEGER NOT NULL,
DDO_Org_ID INTEGER NOT NULL,
created timestamp without time zone DEFAULT now() NOT NULL,
createdBy INTEGER NOT NULL,
updated timestamp without time zone DEFAULT now() NOT NULL,
updatedBy INTEGER NOT NULL,
isActive character(1) DEFAULT 'Y'::bpchar NOT NULL,
name character varying(300) NOT NULL,  
description character varying(500)
);

ALTER TABLE ONLY DDO_projects_clients
        ADD CONSTRAINT projects_clients_pk PRIMARY KEY (DDO_projects_client_ID);

ALTER TABLE ONLY DDO_projects_clients
         ADD CONSTRAINT clientid_fk FOREIGN KEY (DDO_Client_ID) REFERENCES DDO_Client(DDO_Client_ID) DEFERRABLE INITIALLY DEFERRED; 

ALTER TABLE ONLY DDO_projects_clients
         ADD CONSTRAINT orgid_fk FOREIGN KEY (DDO_Org_ID) REFERENCES DDO_Org(DDO_Org_ID) DEFERRABLE INITIALLY DEFERRED;    

/*Inserting static values into jobopening status*/
INSERT INTO ddo_jobopeningstatus VALUES (2, 11, 1000001, now(), 1001228, now(), 1001228, 'Y', 'Awaiting Approval', '#919191'); 
INSERT INTO ddo_jobopeningstatus VALUES (5, 11, 1000001, now(), 1001228, now(), 1001228, 'Y', 'Closed', '#919191'); 
INSERT INTO ddo_jobopeningstatus VALUES (1, 11, 1000001, now(), 1001228, now(), 1001228, 'Y', 'Approved', '#19A844'); 
INSERT INTO ddo_jobopeningstatus VALUES (3, 11, 1000001, now(), 1001228, now(), 1001228, 'Y', 'Drafted', '#0078BE');
INSERT INTO ddo_jobopeningstatus VALUES (4, 11, 1000001, now(), 1001228, now(), 1001228, 'Y', 'Rejected', '#E94435');