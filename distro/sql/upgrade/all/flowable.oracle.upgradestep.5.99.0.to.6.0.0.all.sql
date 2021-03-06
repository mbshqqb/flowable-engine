alter table ACT_RE_PROCDEF add (ENGINE_VERSION_ NVARCHAR2(255));
update ACT_RE_PROCDEF set ENGINE_VERSION_ = 'v5';

alter table ACT_RE_DEPLOYMENT add (ENGINE_VERSION_ NVARCHAR2(255));
update ACT_RE_DEPLOYMENT set ENGINE_VERSION_ = 'v5';

alter table ACT_RU_EXECUTION add (ROOT_PROC_INST_ID_ NVARCHAR2(64));
create index ACT_IDX_EXEC_ROOT on ACT_RU_EXECUTION(ROOT_PROC_INST_ID_);

alter table ACT_RU_EXECUTION add (IS_MI_ROOT_ NUMBER(1,0) CHECK (IS_MI_ROOT_ IN (1,0)));

create table ACT_RU_TIMER_JOB (
    ID_ NVARCHAR2(64) NOT NULL,
    REV_ INTEGER,
    TYPE_ NVARCHAR2(255) NOT NULL,
    LOCK_EXP_TIME_ TIMESTAMP(6),
    LOCK_OWNER_ NVARCHAR2(255),
    EXCLUSIVE_ NUMBER(1,0) CHECK (EXCLUSIVE_ IN (1,0)),
    EXECUTION_ID_ NVARCHAR2(64),
    PROCESS_INSTANCE_ID_ NVARCHAR2(64),
    PROC_DEF_ID_ NVARCHAR2(64),
    RETRIES_ INTEGER,
    EXCEPTION_STACK_ID_ NVARCHAR2(64),
    EXCEPTION_MSG_ NVARCHAR2(2000),
    DUEDATE_ TIMESTAMP(6),
    REPEAT_ NVARCHAR2(255),
    HANDLER_TYPE_ NVARCHAR2(255),
    HANDLER_CFG_ NVARCHAR2(2000),
    TENANT_ID_ NVARCHAR2(255) DEFAULT '',
    primary key (ID_)
);

create table ACT_RU_SUSPENDED_JOB (
    ID_ NVARCHAR2(64) NOT NULL,
    REV_ INTEGER,
    TYPE_ NVARCHAR2(255) NOT NULL,
    EXCLUSIVE_ NUMBER(1,0) CHECK (EXCLUSIVE_ IN (1,0)),
    EXECUTION_ID_ NVARCHAR2(64),
    PROCESS_INSTANCE_ID_ NVARCHAR2(64),
    PROC_DEF_ID_ NVARCHAR2(64),
    RETRIES_ INTEGER,
    EXCEPTION_STACK_ID_ NVARCHAR2(64),
    EXCEPTION_MSG_ NVARCHAR2(2000),
    DUEDATE_ TIMESTAMP(6),
    REPEAT_ NVARCHAR2(255),
    HANDLER_TYPE_ NVARCHAR2(255),
    HANDLER_CFG_ NVARCHAR2(2000),
    TENANT_ID_ NVARCHAR2(255) DEFAULT '',
    primary key (ID_)
);

create table ACT_RU_DEADLETTER_JOB (
    ID_ NVARCHAR2(64) NOT NULL,
    REV_ INTEGER,
    TYPE_ NVARCHAR2(255) NOT NULL,
    EXCLUSIVE_ NUMBER(1,0) CHECK (EXCLUSIVE_ IN (1,0)),
    EXECUTION_ID_ NVARCHAR2(64),
    PROCESS_INSTANCE_ID_ NVARCHAR2(64),
    PROC_DEF_ID_ NVARCHAR2(64),
    EXCEPTION_STACK_ID_ NVARCHAR2(64),
    EXCEPTION_MSG_ NVARCHAR2(2000),
    DUEDATE_ TIMESTAMP(6),
    REPEAT_ NVARCHAR2(255),
    HANDLER_TYPE_ NVARCHAR2(255),
    HANDLER_CFG_ NVARCHAR2(2000),
    TENANT_ID_ NVARCHAR2(255) DEFAULT '',
    primary key (ID_)
);

create index ACT_IDX_JOB_EXECUTION_ID on ACT_RU_JOB(EXECUTION_ID_);
alter table ACT_RU_JOB 
    add constraint ACT_FK_JOB_EXECUTION 
    foreign key (EXECUTION_ID_) 
    references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_JOB_PROC_INST_ID on ACT_RU_JOB(PROCESS_INSTANCE_ID_);
alter table ACT_RU_JOB 
    add constraint ACT_FK_JOB_PROCESS_INSTANCE 
    foreign key (PROCESS_INSTANCE_ID_) 
    references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_JOB_PROC_DEF_ID on ACT_RU_JOB(PROC_DEF_ID_);
alter table ACT_RU_JOB 
    add constraint ACT_FK_JOB_PROC_DEF
    foreign key (PROC_DEF_ID_) 
    references ACT_RE_PROCDEF (ID_);

create index ACT_IDX_TJOB_EXECUTION_ID on ACT_RU_TIMER_JOB(EXECUTION_ID_);
alter table ACT_RU_TIMER_JOB 
    add constraint ACT_FK_TJOB_EXECUTION 
    foreign key (EXECUTION_ID_) 
    references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_TJOB_PROC_INST_ID on ACT_RU_TIMER_JOB(PROCESS_INSTANCE_ID_);
alter table ACT_RU_TIMER_JOB 
    add constraint ACT_FK_TJOB_PROCESS_INSTANCE 
    foreign key (PROCESS_INSTANCE_ID_) 
    references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_TJOB_PROC_DEF_ID on ACT_RU_TIMER_JOB(PROC_DEF_ID_);
alter table ACT_RU_TIMER_JOB 
    add constraint ACT_FK_TJOB_PROC_DEF
    foreign key (PROC_DEF_ID_) 
    references ACT_RE_PROCDEF (ID_);

create index ACT_IDX_TJOB_EXCEPTION on ACT_RU_TIMER_JOB(EXCEPTION_STACK_ID_);    
alter table ACT_RU_TIMER_JOB 
    add constraint ACT_FK_TJOB_EXCEPTION 
    foreign key (EXCEPTION_STACK_ID_) 
    references ACT_GE_BYTEARRAY (ID_);

create index ACT_IDX_SJOB_EXECUTION_ID on ACT_RU_SUSPENDED_JOB(EXECUTION_ID_);    
alter table ACT_RU_SUSPENDED_JOB 
    add constraint ACT_FK_SJOB_EXECUTION 
    foreign key (EXECUTION_ID_) 
    references ACT_RU_EXECUTION (ID_);
    
create index ACT_IDX_SJOB_PROC_INST_ID on ACT_RU_SUSPENDED_JOB(PROCESS_INSTANCE_ID_);    
alter table ACT_RU_SUSPENDED_JOB 
    add constraint ACT_FK_SJOB_PROCESS_INSTANCE 
    foreign key (PROCESS_INSTANCE_ID_) 
    references ACT_RU_EXECUTION (ID_);

create index ACT_IDX_SJOB_PROC_DEF_ID on ACT_RU_SUSPENDED_JOB(PROC_DEF_ID_);    
alter table ACT_RU_SUSPENDED_JOB 
    add constraint ACT_FK_SJOB_PROC_DEF
    foreign key (PROC_DEF_ID_) 
    references ACT_RE_PROCDEF (ID_);

create index ACT_IDX_SJOB_EXCEPTION on ACT_RU_SUSPENDED_JOB(EXCEPTION_STACK_ID_);    
alter table ACT_RU_SUSPENDED_JOB 
    add constraint ACT_FK_SJOB_EXCEPTION 
    foreign key (EXCEPTION_STACK_ID_) 
    references ACT_GE_BYTEARRAY (ID_);

create index ACT_IDX_DJOB_EXECUTION_ID on ACT_RU_DEADLETTER_JOB(EXECUTION_ID_);      
alter table ACT_RU_DEADLETTER_JOB 
    add constraint ACT_FK_DJOB_EXECUTION 
    foreign key (EXECUTION_ID_) 
    references ACT_RU_EXECUTION (ID_);
 
create index ACT_IDX_DJOB_PROC_INST_ID on ACT_RU_DEADLETTER_JOB(PROCESS_INSTANCE_ID_);        
alter table ACT_RU_DEADLETTER_JOB 
    add constraint ACT_FK_DJOB_PROCESS_INSTANCE 
    foreign key (PROCESS_INSTANCE_ID_) 
    references ACT_RU_EXECUTION (ID_);
    
create index ACT_IDX_DJOB_PROC_DEF_ID on ACT_RU_DEADLETTER_JOB(PROC_DEF_ID_);    
alter table ACT_RU_DEADLETTER_JOB 
    add constraint ACT_FK_DJOB_PROC_DEF
    foreign key (PROC_DEF_ID_) 
    references ACT_RE_PROCDEF (ID_);
    
create index ACT_IDX_DJOB_EXCEPTION on ACT_RU_DEADLETTER_JOB(EXCEPTION_STACK_ID_);    
alter table ACT_RU_DEADLETTER_JOB 
    add constraint ACT_FK_DJOB_EXCEPTION 
    foreign key (EXCEPTION_STACK_ID_) 
    references ACT_GE_BYTEARRAY (ID_);
    
-- Moving jobs with retries <= 0 to ACT_RU_DEADLETTER_JOB

INSERT INTO ACT_RU_DEADLETTER_JOB (ID_, REV_, TYPE_, EXCLUSIVE_, EXECUTION_ID_, PROCESS_INSTANCE_ID_, PROC_DEF_ID_, 
EXCEPTION_STACK_ID_,     EXCEPTION_MSG_, DUEDATE_, REPEAT_, HANDLER_TYPE_, HANDLER_CFG_, TENANT_ID_)
(SELECT ID_, REV_, TYPE_, EXCLUSIVE_, EXECUTION_ID_, PROCESS_INSTANCE_ID_, PROC_DEF_ID_, 
EXCEPTION_STACK_ID_, EXCEPTION_MSG_, DUEDATE_, REPEAT_, HANDLER_TYPE_, HANDLER_CFG_, TENANT_ID_ 
from ACT_RU_JOB WHERE RETRIES_ <= 0);

DELETE FROM ACT_RU_JOB 
WHERE RETRIES_ <= 0;


-- Moving suspended jobs to ACT_RU_SUSPENDED_JOB

INSERT INTO ACT_RU_SUSPENDED_JOB (ID_, REV_, TYPE_, EXCLUSIVE_, EXECUTION_ID_, PROCESS_INSTANCE_ID_, PROC_DEF_ID_, 
RETRIES_, EXCEPTION_STACK_ID_,     EXCEPTION_MSG_, DUEDATE_, REPEAT_, HANDLER_TYPE_, HANDLER_CFG_, TENANT_ID_)
(SELECT job.ID_, job.REV_, job.TYPE_, job.EXCLUSIVE_, job.EXECUTION_ID_, job.PROCESS_INSTANCE_ID_, job.PROC_DEF_ID_, 
job.RETRIES_, job.EXCEPTION_STACK_ID_, job.EXCEPTION_MSG_, job.DUEDATE_, job.REPEAT_, job.HANDLER_TYPE_, job.HANDLER_CFG_, job.TENANT_ID_ 
from ACT_RU_JOB job INNER JOIN ACT_RU_EXECUTION execution on execution.ID_ = job.PROCESS_INSTANCE_ID_ where execution.SUSPENSION_STATE_ = 2);

DELETE FROM ACT_RU_JOB
WHERE PROCESS_INSTANCE_ID_ IN (SELECT ID_ FROM ACT_RU_EXECUTION execution WHERE execution.PARENT_ID_ is null and execution.SUSPENSION_STATE_ = 2);



-- Moving timer jobs to ACT_RU_TIMER_JOB

INSERT INTO ACT_RU_TIMER_JOB (ID_, REV_, TYPE_, LOCK_EXP_TIME_, LOCK_OWNER_, EXCLUSIVE_, EXECUTION_ID_, PROCESS_INSTANCE_ID_, 
PROC_DEF_ID_, RETRIES_, EXCEPTION_STACK_ID_, EXCEPTION_MSG_, DUEDATE_, REPEAT_, HANDLER_TYPE_, HANDLER_CFG_, TENANT_ID_)
(SELECT ID_, REV_, TYPE_, LOCK_EXP_TIME_, LOCK_OWNER_, EXCLUSIVE_, EXECUTION_ID_, PROCESS_INSTANCE_ID_, 
PROC_DEF_ID_, RETRIES_, EXCEPTION_STACK_ID_, EXCEPTION_MSG_, DUEDATE_, REPEAT_, HANDLER_TYPE_, HANDLER_CFG_, TENANT_ID_ 
from ACT_RU_JOB WHERE (HANDLER_TYPE_ = 'activate-processdefinition' or HANDLER_TYPE_ = 'suspend-processdefinition' 
or HANDLER_TYPE_ = 'timer-intermediate-transition' or HANDLER_TYPE_ = 'timer-start-event' or HANDLER_TYPE_ = 'timer-transition') and LOCK_EXP_TIME_ is null);

DELETE FROM ACT_RU_JOB 
WHERE (HANDLER_TYPE_ = 'activate-processdefinition' 
    or HANDLER_TYPE_ = 'suspend-processdefinition' 
    or HANDLER_TYPE_ = 'timer-intermediate-transition' 
    or HANDLER_TYPE_ = 'timer-start-event' 
    or HANDLER_TYPE_ = 'timer-transition') 
and LOCK_EXP_TIME_ is null;
        

alter table ACT_RU_EXECUTION add START_TIME_ TIMESTAMP(6);
alter table ACT_RU_EXECUTION add START_USER_ID_ NVARCHAR2(255);
alter table ACT_RU_TASK add CLAIM_TIME_ TIMESTAMP(6);

alter table ACT_RE_DEPLOYMENT add KEY_ NVARCHAR2(255);

-- Upgrade added in upgradestep.52001.to.52002.engine, which is not applied when already on beta2 
update ACT_RU_EVENT_SUBSCR set PROC_DEF_ID_ = CONFIGURATION_ where EVENT_TYPE_ = 'message' and PROC_INST_ID_ is null and EXECUTION_ID_ is null and PROC_DEF_ID_ is null;

-- Adding count columns for execution relationship count feature
alter table ACT_RU_EXECUTION add IS_COUNT_ENABLED_ NUMBER(1,0) CHECK (IS_COUNT_ENABLED_ IN (1,0));
alter table ACT_RU_EXECUTION add EVT_SUBSCR_COUNT_ INTEGER; 
alter table ACT_RU_EXECUTION add TASK_COUNT_ INTEGER; 
alter table ACT_RU_EXECUTION add JOB_COUNT_ INTEGER; 
alter table ACT_RU_EXECUTION add TIMER_JOB_COUNT_ INTEGER;
alter table ACT_RU_EXECUTION add SUSP_JOB_COUNT_ INTEGER;
alter table ACT_RU_EXECUTION add DEADLETTER_JOB_COUNT_ INTEGER;
alter table ACT_RU_EXECUTION add VAR_COUNT_ INTEGER;
alter table ACT_RU_EXECUTION add ID_LINK_COUNT_ INTEGER;

alter table ACT_RU_TASK add IS_COUNT_ENABLED_ NUMBER(1,0) CHECK (IS_COUNT_ENABLED_ IN (1,0));
alter table ACT_RU_TASK add VAR_COUNT_ INTEGER;
alter table ACT_RU_TASK add ID_LINK_COUNT_ INTEGER;

update ACT_GE_PROPERTY set VALUE_ = '6.0.0.5' where NAME_ = 'schema.version';

create table ACT_ID_PROPERTY (
    NAME_ NVARCHAR2(64),
    VALUE_ NVARCHAR2(300),
    REV_ INTEGER,
    primary key (NAME_)
);

insert into ACT_ID_PROPERTY
values ('schema.version', '6.0.0.5', 1);

create table ACT_ID_BYTEARRAY (
    ID_ NVARCHAR2(64),
    REV_ INTEGER,
    NAME_ NVARCHAR2(255),
    BYTES_ BLOB,
    primary key (ID_)
);

create table ACT_ID_TOKEN (
    ID_ NVARCHAR2(64) not null,
    REV_ INTEGER,
    TOKEN_VALUE_ NVARCHAR2(255),
    TOKEN_DATE_ TIMESTAMP(6),
    IP_ADDRESS_ NVARCHAR2(255),
    USER_AGENT_ NVARCHAR2(255),
    USER_ID_ NVARCHAR2(255),
    TOKEN_DATA_ NVARCHAR2(2000),
    primary key (ID_)
);

create table ACT_ID_PRIV (
    ID_ NVARCHAR2(64) not null,
    NAME_ NVARCHAR2(255),
    primary key (ID_)
);

create table ACT_ID_PRIV_MAPPING (
    ID_ NVARCHAR2(64) not null,
    PRIV_ID_ NVARCHAR2(64) not null,
    USER_ID_ NVARCHAR2(255),
    GROUP_ID_ NVARCHAR2(255),
    primary key (ID_)
);

create index ACT_IDX_PRIV_MAPPING on ACT_ID_PRIV_MAPPING(PRIV_ID_);    
alter table ACT_ID_PRIV_MAPPING 
    add constraint ACT_FK_PRIV_MAPPING 
    foreign key (PRIV_ID_) 
    references ACT_ID_PRIV (ID_);
    
create index ACT_IDX_PRIV_USER on ACT_ID_PRIV_MAPPING(USER_ID_);
create index ACT_IDX_PRIV_GROUP on ACT_ID_PRIV_MAPPING(GROUP_ID_);   

CREATE TABLE ACT_DMN_DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED NUMBER(1) NOT NULL, LOCKGRANTED TIMESTAMP, LOCKEDBY VARCHAR2(255), CONSTRAINT PK_ACT_DMN_DATABASECHANGELOGLO PRIMARY KEY (ID));

DELETE FROM ACT_DMN_DATABASECHANGELOGLOCK;

INSERT INTO ACT_DMN_DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

UPDATE ACT_DMN_DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = '192.168.1.5 (192.168.1.5)', LOCKGRANTED = to_timestamp('2019-03-14 18:05:24.400', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

CREATE TABLE ACT_DMN_DATABASECHANGELOG (ID VARCHAR2(255) NOT NULL, AUTHOR VARCHAR2(255) NOT NULL, FILENAME VARCHAR2(255) NOT NULL, DATEEXECUTED TIMESTAMP NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR2(10) NOT NULL, MD5SUM VARCHAR2(35), DESCRIPTION VARCHAR2(255), COMMENTS VARCHAR2(255), TAG VARCHAR2(255), LIQUIBASE VARCHAR2(20), CONTEXTS VARCHAR2(255), LABELS VARCHAR2(255), DEPLOYMENT_ID VARCHAR2(10));

CREATE TABLE ACT_DMN_DEPLOYMENT (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255), CATEGORY_ VARCHAR2(255), DEPLOY_TIME_ TIMESTAMP, TENANT_ID_ VARCHAR2(255), PARENT_DEPLOYMENT_ID_ VARCHAR2(255), CONSTRAINT PK_ACT_DMN_DEPLOYMENT PRIMARY KEY (ID_));

CREATE TABLE ACT_DMN_DEPLOYMENT_RESOURCE (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255), DEPLOYMENT_ID_ VARCHAR2(255), RESOURCE_BYTES_ BLOB, CONSTRAINT PK_ACT_DMN_DEPLOYMENT_RESOURCE PRIMARY KEY (ID_));

CREATE TABLE ACT_DMN_DECISION_TABLE (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255), VERSION_ INTEGER, KEY_ VARCHAR2(255), CATEGORY_ VARCHAR2(255), DEPLOYMENT_ID_ VARCHAR2(255), PARENT_DEPLOYMENT_ID_ VARCHAR2(255), TENANT_ID_ VARCHAR2(255), RESOURCE_NAME_ VARCHAR2(255), DESCRIPTION_ VARCHAR2(255), CONSTRAINT PK_ACT_DMN_DECISION_TABLE PRIMARY KEY (ID_));

INSERT INTO ACT_DMN_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1', 'activiti', 'org/flowable/dmn/db/liquibase/flowable-dmn-db-changelog.xml', SYSTIMESTAMP, 1, '7:d878c2672ead57b5801578fd39c423af', 'createTable tableName=ACT_DMN_DEPLOYMENT; createTable tableName=ACT_DMN_DEPLOYMENT_RESOURCE; createTable tableName=ACT_DMN_DECISION_TABLE', '', 'EXECUTED', NULL, NULL, '3.5.3', '2586724620');

UPDATE ACT_DMN_DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;



CREATE TABLE ACT_FO_DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED NUMBER(1) NOT NULL, LOCKGRANTED TIMESTAMP, LOCKEDBY VARCHAR2(255), CONSTRAINT PK_ACT_FO_DATABASECHANGELOGLOC PRIMARY KEY (ID));

DELETE FROM ACT_FO_DATABASECHANGELOGLOCK;

INSERT INTO ACT_FO_DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

UPDATE ACT_FO_DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = '192.168.1.5 (192.168.1.5)', LOCKGRANTED = to_timestamp('2019-03-14 18:05:25.186', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

CREATE TABLE ACT_FO_DATABASECHANGELOG (ID VARCHAR2(255) NOT NULL, AUTHOR VARCHAR2(255) NOT NULL, FILENAME VARCHAR2(255) NOT NULL, DATEEXECUTED TIMESTAMP NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR2(10) NOT NULL, MD5SUM VARCHAR2(35), DESCRIPTION VARCHAR2(255), COMMENTS VARCHAR2(255), TAG VARCHAR2(255), LIQUIBASE VARCHAR2(20), CONTEXTS VARCHAR2(255), LABELS VARCHAR2(255), DEPLOYMENT_ID VARCHAR2(10));

CREATE TABLE ACT_FO_FORM_DEPLOYMENT (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255), CATEGORY_ VARCHAR2(255), DEPLOY_TIME_ TIMESTAMP, TENANT_ID_ VARCHAR2(255), PARENT_DEPLOYMENT_ID_ VARCHAR2(255), CONSTRAINT PK_ACT_FO_FORM_DEPLOYMENT PRIMARY KEY (ID_));

CREATE TABLE ACT_FO_FORM_RESOURCE (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255), DEPLOYMENT_ID_ VARCHAR2(255), RESOURCE_BYTES_ BLOB, CONSTRAINT PK_ACT_FO_FORM_RESOURCE PRIMARY KEY (ID_));

CREATE TABLE ACT_FO_FORM_DEFINITION (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255), VERSION_ INTEGER, KEY_ VARCHAR2(255), CATEGORY_ VARCHAR2(255), DEPLOYMENT_ID_ VARCHAR2(255), PARENT_DEPLOYMENT_ID_ VARCHAR2(255), TENANT_ID_ VARCHAR2(255), RESOURCE_NAME_ VARCHAR2(255), DESCRIPTION_ VARCHAR2(255), CONSTRAINT PK_ACT_FO_FORM_DEFINITION PRIMARY KEY (ID_));

CREATE TABLE ACT_FO_FORM_INSTANCE (ID_ VARCHAR2(255) NOT NULL, FORM_DEFINITION_ID_ VARCHAR2(255) NOT NULL, TASK_ID_ VARCHAR2(255), PROC_INST_ID_ VARCHAR2(255), PROC_DEF_ID_ VARCHAR2(255), SUBMITTED_DATE_ TIMESTAMP, SUBMITTED_BY_ VARCHAR2(255), FORM_VALUES_ID_ VARCHAR2(255), TENANT_ID_ VARCHAR2(255), CONSTRAINT PK_ACT_FO_FORM_INSTANCE PRIMARY KEY (ID_));

INSERT INTO ACT_FO_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1', 'activiti', 'org/flowable/form/db/liquibase/flowable-form-db-changelog.xml', SYSTIMESTAMP, 1, '7:252bd5cb28cf86685ed67eb15d910118', 'createTable tableName=ACT_FO_FORM_DEPLOYMENT; createTable tableName=ACT_FO_FORM_RESOURCE; createTable tableName=ACT_FO_FORM_DEFINITION; createTable tableName=ACT_FO_FORM_INSTANCE', '', 'EXECUTED', NULL, NULL, '3.5.3', '2586725348');

UPDATE ACT_FO_DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;



CREATE TABLE ACT_CO_DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED NUMBER(1) NOT NULL, LOCKGRANTED TIMESTAMP, LOCKEDBY VARCHAR2(255), CONSTRAINT PK_ACT_CO_DATABASECHANGELOGLOC PRIMARY KEY (ID));

DELETE FROM ACT_CO_DATABASECHANGELOGLOCK;

INSERT INTO ACT_CO_DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

UPDATE ACT_CO_DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = '192.168.1.5 (192.168.1.5)', LOCKGRANTED = to_timestamp('2019-03-14 18:05:25.919', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

CREATE TABLE ACT_CO_DATABASECHANGELOG (ID VARCHAR2(255) NOT NULL, AUTHOR VARCHAR2(255) NOT NULL, FILENAME VARCHAR2(255) NOT NULL, DATEEXECUTED TIMESTAMP NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR2(10) NOT NULL, MD5SUM VARCHAR2(35), DESCRIPTION VARCHAR2(255), COMMENTS VARCHAR2(255), TAG VARCHAR2(255), LIQUIBASE VARCHAR2(20), CONTEXTS VARCHAR2(255), LABELS VARCHAR2(255), DEPLOYMENT_ID VARCHAR2(10));

CREATE TABLE ACT_CO_CONTENT_ITEM (ID_ VARCHAR2(255) NOT NULL, NAME_ VARCHAR2(255) NOT NULL, MIME_TYPE_ VARCHAR2(255), TASK_ID_ VARCHAR2(255), PROC_INST_ID_ VARCHAR2(255), CONTENT_STORE_ID_ VARCHAR2(255), CONTENT_STORE_NAME_ VARCHAR2(255), FIELD_ VARCHAR2(400), CONTENT_AVAILABLE_ NUMBER(1) DEFAULT 0, CREATED_ TIMESTAMP(6), CREATED_BY_ VARCHAR2(255), LAST_MODIFIED_ TIMESTAMP(6), LAST_MODIFIED_BY_ VARCHAR2(255), CONTENT_SIZE_ NUMBER(38, 0) DEFAULT 0, TENANT_ID_ VARCHAR2(255), CONSTRAINT PK_ACT_CO_CONTENT_ITEM PRIMARY KEY (ID_));

CREATE INDEX idx_contitem_taskid ON ACT_CO_CONTENT_ITEM(TASK_ID_);

CREATE INDEX idx_contitem_procid ON ACT_CO_CONTENT_ITEM(PROC_INST_ID_);

INSERT INTO ACT_CO_DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1', 'activiti', 'org/flowable/content/db/liquibase/flowable-content-db-changelog.xml', SYSTIMESTAMP, 1, '7:a17df43ed0c96adfef5271e1781aaed2', 'createTable tableName=ACT_CO_CONTENT_ITEM; createIndex indexName=idx_contitem_taskid, tableName=ACT_CO_CONTENT_ITEM; createIndex indexName=idx_contitem_procid, tableName=ACT_CO_CONTENT_ITEM', '', 'EXECUTED', NULL, NULL, '3.5.3', '2586726102');

UPDATE ACT_CO_DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

