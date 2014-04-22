
CREATE TABLE tmpuser AS 
SELECT * FROM user;

DROP TABLE IF EXISTS user;
CREATE TABLE user (
userid int(11) NOT NULL auto_increment,
username varchar(20) NOT NULL,
password char(40) NOT NULL,
sex int(11) NOT NULL DEFAULT 0,
age int(11) NOT NULL,
createdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
pushoveruser varchar(40),
fitbitkey varchar(40),
fitbitsecret varchar(40),
fitbitappname varchar(40),
PRIMARY KEY (userid),
UNIQUE KEY username (username)
);
INSERT INTO user (
userid,
username,
password,
sex,
age,
pushoveruser,
fitbitkey,
fitbitsecret,
fitbitappname)
SELECT 
userid,
username,
password,
0,
0,
pushoveruser,
fitbitkey,
fitbitsecret,
fitbitappname
FROM tmpuser;


load data local infile '/Users/stefanopicozzi/websites/nudge/data/poll.csv' 
into table poll
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( pollid, programid, pollname, qcount, polldesc, isinternal, pollurl );


load data local infile '/Users/stefanopicozzi/websites/nudge/data/pollq.csv' 
into table pollq
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( 
pollqid,
programid,
pollid,
qseqno,
qname,
qcount,
qinstruction,
qtext,
q01value, q01label, q02value, q02label, q03value, q03label, q04value, q04label, q05value, q05label, 
q06value, q06label, q07value, q07label, q08value, q08label, q09value, q09label, q10value, q10label );



// 1. Set up new program
INSERT INTO program
(programname, isdefault) VALUES
('lifecoach', 0);

// 2. Then manually add in 'architect' programuser

// 3. Set up polling records
DROP TABLE tmppollq;

CREATE TABLE tmppollq AS
SELECT * FROM pollq
WHERE programid = 1;

UPDATE tmppollq
SET programid = 5,
   pollqid = pollqid + 
      (SELECT MAX(pollqid)
      FROM pollq);
      
INSERT INTO pollq
SELECT * from tmppollq;    
    
// 4. Then visit site to assign rules as coach

// 5. Enrol as participant and test

// To create gas rules off template ...

SELECT CONCAT('gas2', SUBSTR(rulename, 5,20) ) FROM rule
where rulename like 'gas2%'
 and ruletype in ('gas1', 'gas2', 'gas3', 'gas4', 'gas5' );
 
 
load data local infile '/Users/stefanopicozzi/websites/nudge/data/pollq-wellness.csv' 
into table pollq
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( 
pollqid,
programid,
pollid,
qseqno,
qname,
qcount,
qinstruction,
qtext,
q01value, q01label, q02value, q02label, q03value, q03label, q04value, q04label, q05value, q05label, 
q06value, q06label, q07value, q07label, q08value, q08label, q09value, q09label, q10value, q10label );





DELETE FROM programrule;
INSERT INTO programrule
(programid, ruleid, rulehigh, rulelow, rulepoint)
SELECT p.programid, r.ruleid, 0, 0, 10
FROM program p, rule r;

DELETE FROM programuser;
INSERT INTO programuser
(programid, userid, roletype, msgtotalcount, msgunreadcount, ruleoptincount)
SELECT p.programid, u.userid, 'participant', 0, 0, 0
FROM program p, user u;

UPDATE programuser
SET roletype = 'architect'
WHERE userid IN (19,7);

UPDATE programuser
SET roletype = 'administrator'
WHERE userid IN (1);

DELETE FROM programruleuser;
INSERT INTO programruleuser
(programid, ruleid, userid, rulevalue, rulehigh, rulelow)
SELECT p.programid, r.ruleid, u.userid, 1, 0, 0
FROM program p, rule r, user u;


load data local infile '/Users/stefanopicozzi/websites/nudge/data/msg.csv' 
into table msg
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( msgid, programid,   userid,   msgdate,  rulename, ruledate, msgtxt,   issent,   isread,   urldesc );

load data local infile '/Users/stefanopicozzi/websites/nudge/data/program.csv' 
into table program
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( programid,   programname, isdefault )

load data local infile '/Users/stefanopicozzi/websites/nudge/data/user.csv' 
into table user
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( userid,   username, password, pushoveruser )

load data local infile '/Users/stefanopicozzi/websites/nudge/data/programuser.csv' 
into table programuser
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( programuserid,   programid,   userid,   roletype, msgtotalcount,  msgunreadcount, ruleoptincount, pointcount )

load data local infile '/Users/stefanopicozzi/websites/nudge/data/programurl.csv' 
into table programurl 
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( programurlid,   programid,   urltype,  urlname,  urllabel, urldesc );

load data local infile '/Users/stefanopicozzi/websites/nudge/data/rule.csv' 
into table rule
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( ruleid,   rulename,   ruledesc,  ruletype, awardtype, pollname, parentruleid );

load data local infile '/Users/stefanopicozzi/websites/nudge/data/programrule.csv' 
into table programrule
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( programruleid,  programid,   ruleid,   rulehigh, rulelow, rulepoint );

load data local infile '/Users/stefanopicozzi/websites/nudge/data/programruleuser.csv' 
into table programruleuser
fields terminated by ','
ESCAPED BY '\\'
enclosed by '"'
LINES TERMINATED BY '\r'
( programruleuserid, programid,   ruleid,   userid,   rulevalue,   rulehigh, rulelow, ruleuserdesc );




