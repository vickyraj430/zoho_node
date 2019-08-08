--
-- views for DDO DB tables
--

-- ddo_wallethistory_v

CREATE VIEW ddo_wallethistory_v AS
 
SELECT 

	wh.ddo_client_id,
	wh.ddo_org_id,
	wh.created,
	wh.createdby,
	wh.updated,
	wh.updatedby,
	wh.created as date,
	wh.points,
	nom.comments as description,
	emp.firstname || emp.lastname as byto,
	wh.trx_type as trxtype,
	wl.ddo_employee_id


FROM

	DDO_WalletHistory wh
		JOIN DDO_Wallet wl
			ON wl.ddo_wallet_id = wh.ddo_wallet_id
		LEFT JOIN DDO_Nomination nom
			ON nom.ddo_nomination_id = wh.ddo_nomination_id
		JOIN DDO_Employee emp
			ON 
				CASE
					WHEN wh.trx_type::text = 'CR'::text THEN emp.ddo_employee_id = wh.createdby
					ELSE emp.ddo_employee_id = nom.to_employee_id
				END;


-- ddo_rewardhistory_v

CREATE VIEW ddo_rewardhistory_v AS

SELECT krh.ddo_client_id, krh.ddo_org_id, krh.created, krh.createdby, 
    krh.updated, krh.updatedby, krh.created AS date, krh.karma_points AS points, 
    nom.comments AS description,
    nom.from_employee_id,nom.to_employee_id,
    emp.firstname::text || emp.lastname::text AS byto, wl.ddo_employee_id
   FROM ddo_karmarewardhistory krh
   JOIN ddo_wallet wl ON wl.ddo_wallet_id = krh.ddo_wallet_id
   JOIN ddo_nomination nom ON nom.ddo_nomination_id = krh.ddo_nomination_id
   JOIN ddo_employee emp ON emp.ddo_employee_id = krh.createdby;


-- ddo_emp_timeline_v

CREATE VIEW ddo_emp_timeline_v AS

 
 SELECT deh.ddo_employee_history_id AS wtc_employee_history_id, 
    deh.ddo_client_id, deh.ddo_org_id, deh.updated AS activity_on, 
    deh.details AS activity_description, deh.title AS activity_title, 
    deh.event AS activity_type, deh.ddo_employee_id,
    dkrh.karma_points,dn.from_employee_id,dn.to_employee_id,
    pg_catalog.concat(de.firstname, ' ', de.lastname) AS employeename, 
    ( SELECT dd.name
           FROM ddo_designation dd
          WHERE dd.ddo_designation_id = (( SELECT dewd.designation
                   FROM ddo_empworkdetails dewd
                  WHERE dewd.ddo_employee_id = deh.ddo_employee_id))) AS designation, 
        CASE
            WHEN deh.ddo_karma_id IS NULL OR deh.ddo_karma_id <= 0 THEN 'Y'::bpchar
            ELSE ( SELECT dk.showontimeline
               FROM ddo_karma dk
              WHERE dk.ddo_karma_id = deh.ddo_karma_id)
        END AS istimeline, 
    ( SELECT pg_catalog.concat(demp.firstname, ' ', demp.lastname) AS concat
           FROM ddo_employee demp
          WHERE demp.ddo_employee_id = (( SELECT dnom.from_employee_id
                   FROM ddo_nomination dnom
                  WHERE dnom.ddo_nomination_id = deh.recordid AND deh.event::text = 'Nomination'::text))) AS nominated_by
   FROM ddo_employee_history deh
   JOIN ddo_employee de ON de.ddo_employee_id = deh.ddo_employee_id
   JOIN ddo_karmarewardhistory dkrh ON dkrh.ddo_nomination_id = deh.recordid
   JOIN ddo_nomination dn ON dn.ddo_nomination_id = deh.recordid;


-- ddo_emp_fulldetails_v
CREATE VIEW ddo_emp_fulldetails_v AS

   SELECT emp.ddo_client_id, emp.ddo_org_id, emp.created, emp.createdby, 
    emp.updated, emp.updatedby, emp.ddo_employee_id AS c_bpartner_id, 
    pg_catalog.concat(emp.firstname, ' ', emp.lastname) AS employee, 
    COALESCE(empimg.profileimage_url, (('http://www.gravatar.com/avatar/'::text || md5(emp.email::text)) || '.jpg?s200&d=identicon'::text)::character varying) AS user_profile_pic_url, 
    ( SELECT COALESCE(array_to_string(array_agg(dpa.ddo_project_id), ','::text), ''::text) AS "coalesce"
           FROM ddo_project_allocation dpa
          WHERE dpa.ddo_employee_id = emp.ddo_employee_id AND  'now'::text::date >= dpa.startdate::date AND 'now'::text::date <= dpa.enddate::date AND dpa.isactive = 'Y'::bpchar) AS project_id, 
    emp.email, emp.employee_code, ewd.isbillable, 
    COALESCE(wl.karma_points, 0) AS karmapoints, 
    ewd.designation AS hr_designation_id, dsg.name AS hr_designation, 
    ewd.department AS hr_department_id, dept.name AS departmentname, 
    ewd.pskillid AS hr_skilltype_id, sk.name AS skillname, ewd.joiningdate, 
    ewd.empstatus AS employmentstatus, ewd.reportingto AS supervisor_id, 
    sup.firstname::text || sup.lastname::text AS supervisorname, 
    sup.employee_code AS supervisor_emp_code, sup.email AS supervisor_email, 
    COALESCE(supimg.profileimage_url, (('http://www.gravatar.com/avatar/'::text || md5(sup.email::text)) || '.jpg?s200&d=identicon'::text)::character varying) AS supervisor_profile_img, 
    supwl.karma_points AS supervisor_karmapoints
   FROM ddo_employee emp
   LEFT JOIN ddo_empimages empimg ON emp.ddo_employee_id = empimg.ddo_employee_id
   LEFT JOIN ddo_wallet wl ON wl.ddo_employee_id = emp.ddo_employee_id
   LEFT JOIN ddo_empworkdetails ewd ON ewd.ddo_employee_id = emp.ddo_employee_id
   LEFT JOIN ddo_skills sk ON sk.ddo_skills_id = ewd.pskillid
   LEFT JOIN ddo_designation dsg ON dsg.ddo_designation_id = ewd.designation
   LEFT JOIN ddo_department dept ON dept.ddo_department_id = ewd.department
   LEFT JOIN ddo_employee sup ON sup.ddo_employee_id = ewd.reportingto
   LEFT JOIN ddo_empimages supimg ON supimg.ddo_employee_id = sup.ddo_employee_id
   LEFT JOIN ddo_wallet supwl ON supwl.ddo_employee_id = sup.ddo_employee_id;




-- ddo_empprojects_v

CREATE VIEW ddo_empprojects_v AS
    SELECT pal.ddo_employee_id, 
    array_to_string(array_agg(DISTINCT pal.ddo_project_id), ','::text) AS projectids, 
    array_to_string(array_agg(DISTINCT pr.name), ','::text) AS projectnames, 
    max(pal.enddate) AS availablefrom,
    ( SELECT round((extract(epoch from now()::timestamp without time zone) - extract(epoch from max(pal.enddate)))/(60*60*24)::integer)) AS daysonbench
   FROM ddo_project_allocation pal
   JOIN ddo_project pr ON pal.ddo_project_id = pr.ddo_project_id
  WHERE 'now'::text::date >= pal.startdate::date AND 'now'::text::date <= pal.enddate::date AND pal.isactive = 'Y'::bpchar
  GROUP BY pal.ddo_employee_id;

-- ddo_employeegoal_v

CREATE VIEW ddo_employeegoal_v AS
	SELECT eg.ddo_employeegoal_id AS goalid, eg.name AS title, eg.ddo_client_id, 
	    eg.ddo_org_id, eg.ddo_employee_id AS employeeid, eg.targetdate, 
	    eg.ddo_goalstatus_id AS goalstatusid, 
	    pg_catalog.concat(de.firstname, ' ', de.lastname) AS name, 
	    gsh.sharewith_ddo_employee_id AS share_with, 
	    ( SELECT gs.name
	           FROM ddo_goalstatus gs
	          WHERE gs.ddo_goalstatus_id = eg.ddo_goalstatus_id) AS goalstatus, 
	        CASE
	            WHEN (( SELECT DISTINCT gsh.ddo_employeegoal_id
	               FROM ddo_goalshare gsh
	              WHERE gsh.ddo_employeegoal_id = eg.ddo_employeegoal_id)) IS NULL THEN 'no'::text
	            ELSE 'yes'::text
	        END AS sharegoal, 
	    COALESCE(du.profileimage_url, (('http://www.gravatar.com/avatar/'::text || md5(de.email::text)) || '.jpg?s200&d=identicon'::text)::character varying) AS user_profile_pic_url, 
	    ( SELECT ew.reportingto
	           FROM ddo_empworkdetails ew
	          WHERE ew.ddo_client_id = eg.ddo_client_id AND ew.ddo_org_id = eg.ddo_org_id AND ew.ddo_employee_id = eg.ddo_employee_id AND ew.isactive = 'Y'::bpchar) AS reportingto
	   FROM ddo_employeegoal eg
	   LEFT JOIN ddo_goalshare gsh ON gsh.ddo_employeegoal_id = eg.ddo_employeegoal_id
	   LEFT JOIN ddo_employee de ON de.ddo_employee_id = eg.ddo_employee_id
	   LEFT JOIN ddo_empimages du ON du.ddo_employee_id = eg.ddo_employee_id;


---ddo_emp_projectutilization_v

CREATE VIEW ddo_emp_projectutilization_v AS SELECT pa.ddo_project_allocation_id, pa.ddo_client_id, pa.ddo_org_id, 
    pa.ddo_employee_id, 
    emp.firstname::text || emp.lastname::text AS ddo_employee_name, emp.email, 
    pa.ddo_project_id, pr.name, pa.shadow_resource as isshadow, pa.isactive, 
    ew.designation AS designationid, desg.name AS designationname, 
    pa.allocpercent, pa.startdate, pa.enddate,
    ew.empstatus AS employmentstatus
   FROM ddo_project_allocation pa
   JOIN ddo_employee emp ON pa.ddo_employee_id = emp.ddo_employee_id
   JOIN ddo_project pr ON pa.ddo_project_id = pr.ddo_project_id
   LEFT JOIN ddo_empworkdetails ew ON pa.ddo_employee_id = ew.ddo_employee_id
   JOIN ddo_designation desg ON ew.designation = desg.ddo_designation_id
  WHERE pa.isactive = 'Y'::bpchar AND emp.isactive = 'Y'::bpchar AND  current_date >= pa.startdate::date AND current_date <= pa.enddate::date;