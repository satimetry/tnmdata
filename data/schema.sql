
DROP TABLE IF EXISTS rulefile;
CREATE TABLE rulefile (
id int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
groupid int(11) NOT NULL,
rulename varchar(45) NOT NULL,
ruletxt text not null,
PRIMARY KEY (id)
);

DROP TABLE IF EXISTS fact;
CREATE TABLE fact (
id int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
groupid int(11) NOT NULL,
factname varchar(40) NOT NULL,
facttype int(11) NOT NULL,
factjson varchar(256) not null,
PRIMARY KEY (id)
);

DROP TABLE IF EXISTS poll;
CREATE TABLE poll (
pollid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
pollname varchar(30) NOT NULL,
qcount int(11) NOT NULL,
polldesc varchar(140) NOT NULL,
isinternal int(11) NOT NULL default 1,
pollurl varchar(140) not null,
PRIMARY KEY (pollid)
);


DROP TABLE IF EXISTS pollq;
CREATE TABLE pollq (
pollqid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
pollid int(11) NOT NULL,
qseqno int(11) NOT NULL,
qname varchar(30) NOT NULL,
qcount int(11) NOT NULL,
qinstruction varchar(256) NOT NULL,
qtext varchar(256) NOT NULL,
q01value int(11),
q01label varchar(30),
q02value int(11),
q02label varchar(30),
q03value int(11),
q03label varchar(30),
q04value int(11),
q04label varchar(30),
q05value int(11),
q05label varchar(30),
q06value int(11),
q06label varchar(30),
q07value int(11),
q07label varchar(30),
q08value int(11),
q08label varchar(30),
q09value int(11),
q09label varchar(30),
q10value int(11),
q10label varchar(30),
PRIMARY KEY (pollqid)
);


DROP TABLE IF EXISTS programpolluser;
CREATE TABLE programpolluser (
programpolluserid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
pollid int(11) NOT NULL,
userid int(11) NOT NULL,
polldate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
lastqseqno int(11) NOT NULL DEFAULT 0,
lastqdate timestamp,
qcount int(11) NOT NULL DEFAULT 0,
q01value int(11),
q02value int(11),
q03value int(11),
q04value int(11),
q05value int(11),
q06value int(11),
q07value int(11),
q08value int(11),
q09value int(11),
q10value int(11),
PRIMARY KEY (programpolluserid)
);


DROP TABLE IF EXISTS hit;
CREATE TABLE hit (
hitid int(11) NOT NULL auto_increment,
hitdate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
hitip varchar(30),
urlname varchar(30) NOT NULL,
programid int(11),
userid int(11),
PRIMARY KEY (hitid)
);


DROP TABLE IF EXISTS programurl;
CREATE TABLE programurl (
programurlid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
urltype varchar(30) NOT NULL DEFAULT "URL",
urlname varchar(30) NOT NULL,
urllabel varchar(30) NOT NULL,
urldesc varchar(140) NOT NULL,
urldate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
ruleid int(11),
PRIMARY KEY (programurlid)
);


DROP TABLE IF EXISTS msg;
CREATE TABLE msg (
msgid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
userid int(11) NOT NULL,
ruleid int(11) NOT NULL,
msgdate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
rulename varchar(30),
ruledate timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
msgtxt varchar(512) NOT NULL,
issent tinyint NOT NULL DEFAULT FALSE,
isread tinyint NOT NULL DEFAULT FALSE,
urldesc varchar(140),
PRIMARY KEY (msgid)
);


DROP TABLE IF EXISTS user;
CREATE TABLE user (
userid int(11) NOT NULL auto_increment,
username varchar(20) NOT NULL,
password varchar(40) NOT NULL,
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


DROP TABLE IF EXISTS program;
CREATE TABLE program (
programid int(11) NOT NULL auto_increment,
programname varchar(30) NOT NULL,
isdefault tinyint NOT NULL DEFAULT FALSE,
PRIMARY KEY (programid),
UNIQUE KEY programname (programname)
);


DROP TABLE IF EXISTS rule;
CREATE TABLE rule (
ruleid int(11) NOT NULL auto_increment,
rulename varchar(30) NOT NULL,
ruledesc varchar(140) NOT NULL,
ruletype varchar(30) NOT NULL DEFAULT "program",
awardtype varchar(30) NOT NULL DEFAULT "gold",
pollname varchar(30) NOT NULL,
parentruleid int(11),
PRIMARY KEY (ruleid),
UNIQUE KEY rulename (rulename)
);


DROP TABLE IF EXISTS programrule;
CREATE TABLE programrule (
programruleid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
ruleid int(11) NOT NULL,
rulehigh int(11) DEFAULT 0,
rulelow int(11) DEFAULT 0,
rulepoint int(11) DEFAULT 0,
PRIMARY KEY (programruleid)
);


DROP TABLE IF EXISTS programuser;
CREATE TABLE programuser (
programuserid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
userid int(11) NOT NULL,
roletype varchar(30) NOT NULL DEFAULT 'participant',
msgtotalcount int(11) NOT NULL DEFAULT 0,
msgunreadcount int(11) NOT NULL DEFAULT 0,
ruleoptincount int(11) NOT NULL DEFAULT 0,
pointcount int(11) NOT NULL DEFAULT 0,
PRIMARY KEY (programuserid)
);


DROP TABLE IF EXISTS programruleuser;
CREATE TABLE programruleuser (
programruleuserid int(11) NOT NULL auto_increment,
programid int(11) NOT NULL,
ruleid int(11) NOT NULL,
userid int(11) NOT NULL,
rulevalue int(11) NOT NULL DEFAULT 0,
rulehigh int(11),
rulelow int(11),
ruleuserdesc varchar(140),
PRIMARY KEY (programruleuserid)
);


DROP TABLE IF EXISTS userobs;
CREATE TABLE userobs (
userobsid int(11) NOT NULL auto_increment,
userid int(11) NOT NULL,
programid int(11) NOT NULL,
obsname varchar(30) NOT NULL,
createdate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
obsvalue varchar(30),
obsdesc varchar(140),
obsdate timestamp NOT NULL,
obstype varchar(30) NOT NULL DEFAULT 'userobs',
PRIMARY KEY (userobsid)
);


DROP TABLE IF EXISTS userdiary;
CREATE TABLE userdiary (
userdiaryid int(11) NOT NULL auto_increment,
userid int(11) NOT NULL,
programid int(11) NOT NULL,
diarydate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
diarytxt varchar(140),
PRIMARY KEY (userdiaryid)
);

DROP VIEW IF EXISTS optinruleview;
CREATE VIEW optinruleview AS
SELECT
pru.programruleuserid, 
pru.programid,
pru.userid,
pru.ruleid,
r.rulename
FROM programruleuser pru, rule r
where pru.ruleid = r.ruleid
and pru.rulevalue = 1;

CREATE INDEX userobsidx 
ON userobs
(programid, userid);

CREATE INDEX userdiaryidx 
ON userdiary
(programid, userid);

CREATE INDEX programruleuseridx 
ON programruleuser
(programid, userid, ruleid);

CREATE INDEX programruleidx 
ON programrule
(programid, ruleid);

CREATE INDEX msgidx 
ON msg
(programid, userid);

CREATE INDEX programpolluseridx 
ON programpolluser
(programid, userid);

CREATE INDEX programuseridx 
ON programuser
(programid, userid);

CREATE INDEX pollidx 
ON poll
(programid);

CREATE INDEX pollqidx 
ON pollq
(programid, pollid);




