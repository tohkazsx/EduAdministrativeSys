CREATE DATABASE IF NOT EXISTS `teaching_mgt` CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `teaching_mgt`;

SET foreign_key_checks = 0;

-- 用户登录
-- user_no 可以是 学生、教师、管理员
-- user_type 同上
-- 初始密码默认同账号
DROP TABLE IF EXISTS `user_login`;
CREATE TABLE `user_login` (
    `user_no` VARCHAR(16) NOT NULL COMMENT '用户账号(stu_no/teach_no/admin_no)',
    `user_pass` VARCHAR(64) NOT NULL COMMENT '用户密码',
    `user_name` VARCHAR(32) NOT NULL COMMENT '用户真实姓名',
    `user_type` CHAR(8) NOT NULL COMMENT '用户账号类型',
    `user_first` CHAR(5) NOT NULL COMMENT '用户是否第一次登录(true/false)',
    PRIMARY KEY (`user_no`)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='用户登录信息';

DROP TABLE IF EXISTS `student`;
CREATE TABLE `student` (
    `stu_no` VARCHAR(16) NOT NULL COMMENT '学生学号',
    `stu_name` VARCHAR(32) NOT NULL COMMENT '学生姓名',
    `stu_sex` CHAR(2) NOT NULL COMMENT '性别',
    `stu_enter_date` DATETIME NOT NULL COMMENT '入学时间',
    `stu_class_no` VARCHAR(16) NOT NULL COMMENT '所属班级编号',
    `stu_depart_no` VARCHAR(16) NOT NULL COMMENT '系别编号',
    PRIMARY KEY (`stu_no`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='学生信息';

DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher` (
    `teach_no` VARCHAR(16) NOT NULL COMMENT '教师工号',
    `teach_name` VARCHAR(32) NOT NULL COMMENT '教师姓名',
    `teach_sex` CHAR(2) NOT NULL COMMENT '性别',
    `teach_depart_no` VARCHAR(16) NOT NULL COMMENT '系别编号',
    `teach_phone` CHAR(16) NOT NULL COMMENT '联系方式',
    PRIMARY KEY (`teach_no`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT='教师信息';

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
    `admin_no` VARCHAR(16) NOT NULL COMMENT '管理员账号',
    `admin_name` VARCHAR(32) NOT NULL COMMENT '管理员姓名',
    `admin_phone` VARCHAR(16) NOT NULL COMMENT '联系方式',
    PRIMARY KEY (`admin_no`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '管理员信息';

DROP TABLE IF EXISTS `class`;
CREATE TABLE `class` (
    `class_no` VARCHAR(16) NOT NULL COMMENT '班级编号',
    `class_name` VARCHAR(32) NOT NULL COMMENT '班级名称',
    `class_term` VARCHAR(16) NOT NULL COMMENT '班级所属年级',
    `class_teach_no` VARCHAR(16) NOT NULL COMMENT '班主任编号',
    `class_depart_no` VARCHAR(16) NOT NULL COMMENT '系部编号',
    `class_num` INT NOT NULL DEFAULT 0 COMMENT '班级人数',
    PRIMARY KEY (`class_no`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '班级信息';

DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
    `depart_no` VARCHAR(16) NOT NULL COMMENT '系部编号',
    `depart_name` VARCHAR(32) NOT NULL COMMENT '系部名称',
    `depart_teach_no` VARCHAR(16) NOT NULL COMMENT '系主任编号',
    `depart_num` INT NOT NULL DEFAULT 0 COMMENT '系部学生人数',
    PRIMARY KEY (`depart_no`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '系部信息';

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
    `course_no` VARCHAR(16) NOT NULL COMMENT '课程编号',
    `course_name` VARCHAR(32) NOT NULL COMMENT '课程名',
    `course_teach_no` VARCHAR(16) NOT NULL COMMENT '课程负责老师',
    `course_date` DATETIME NOT NULL COMMENT '课程学年',
    `course_term` INT NOT NULL COMMENT '课程学期',
    PRIMARY KEY (`course_no`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '课程信息';

DROP TABLE IF EXISTS `score`;
CREATE TABLE `score` (
    `sc_stu_no` VARCHAR(16) NOT NULL COMMENT '学生学号',
    `sc_cur_no` VARCHAR(16) NOT NULL COMMENT '课程编号',
    `sc_socre`  DECIMAL(2) NOT NULL COMMENT '课程成绩'
) ENGINE=INNODB DEFAULT CHARSET=UTF8 COMMENT '课程成绩';

-- 触发器定义
DROP TRIGGER IF EXISTS `after_insert_student_trig`;
DELIMITER $
CREATE TRIGGER `after_insert_student_trig`
AFTER INSERT ON `student` FOR EACH ROW
BEGIN
    UPDATE `class` SET `class_num`=`class_num`+1 WHERE `class_no`=NEW.`stu_class_no`;
    UPDATE `department` SET `depart_num`=`depart_num`+1 WHERE `depart_no`=NEW.`stu_depart_no`;
    INSERT INTO `user_login` values (NEW.`stu_no`,MD5(NEW.`stu_no`),NEW.`stu_name`,"student","true");
END $
DELIMITER ;

DROP TRIGGER IF EXISTS `after_delete_student_trig`;
DELIMITER $
CREATE TRIGGER `after_delete_student_trig`
AFTER DELETE ON `student` FOR EACH ROW
BEGIN
    UPDATE `class` SET `class_num`=`class_num`-1 WHERE `class_no`=OLD.`stu_class_no`;
    UPDATE `department` SET `depart_num`=`depart_num`-1 WHERE `depart_no`=OLD.`stu_depart_no`;
    DELETE FROM `score` WHERE `sc_stu_no`=OLD.`stu_no`;
END $
DELIMITER ;

DROP TRIGGER IF EXISTS `after_insert_teacher_trig`;
DELIMITER $
CREATE TRIGGER `after_insert_teacher_trig`
AFTER INSERT ON `teacher` FOR EACH ROW
BEGIN
    INSERT INTO `user_login` values (NEW.`teach_no`,MD5(NEW.`teach_no`),NEW.`teach_name`,"teacher","true");
END $
DELIMITER ;

DROP TRIGGER IF EXISTS `after_insert_admin_trig`;
DELIMITER $
CREATE TRIGGER `after_insert_admin_trig`
AFTER INSERT ON `admin` FOR EACH ROW
BEGIN
    INSERT INTO `user_login` values (NEW.`admin_no`,MD5(NEW.`admin_no`),NEW.`admin_name`,"admin","true");
END $
DELIMITER ;

-- 过程定义
DROP PROCEDURE IF EXISTS `user_verify_proc`;
DELIMITER $
CREATE PROCEDURE `user_verify_proc` (
    IN user VARCHAR(16),
    IN pass VARCHAR(64)
)
BEGIN
    DECLARE res INT;
    DECLARE u_name CHAR(32) DEFAULT NULL;
    DECLARE u_type CHAR(8) DEFAULT NULL;
    DECLARE u_first CHAR(5) DEFAULT NULL;
    SELECT COUNT(1) INTO res FROM `user_login` WHERE `user_no`=user;
    if res=0 then
        SELECT "User Not Found" as result;
    else
        SELECT `user_name`,`user_type`,`user_first` INTO u_name,u_type,u_first FROM `user_login` WHERE `user_no`=user and `user_pass`=pass;
        if u_type IS NULL then
            SELECT "Password Error" as result;
        else
            SELECT u_name as name, u_type as result, u_first as first;
        end if;
    end if;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `reset_password_proc`;
DELIMITER $
CREATE PROCEDURE `reset_password_proc` (
    IN user VARCHAR(16),
    IN pass VARCHAR(64)
)
BEGIN
    UPDATE `user_login` SET `user_pass`=pass,`user_first`='false' WHERE `user_no`=user;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `stu_course_proc`;
DELIMITER $
CREATE PROCEDURE `stu_course_proc` (
    IN stu_no VARCHAR(16)
)
BEGIN
    SELECT `course_no`,`course_name`,`sc_socre`,`course_date`,`course_term`,`teach_name`,`teach_phone`,`depart_name`
    FROM `course`,`teacher`,`department`,`score`
    WHERE `course_teach_no`=`teach_no` and `teach_depart_no`=`depart_no`
    and `course_no`=`sc_cur_no` and `sc_stu_no`=stu_no;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `stu_optinal_course_proc`;
DELIMITER $
CREATE PROCEDURE `stu_optinal_course_proc` (
    IN stu_no VARCHAR(16)
)
BEGIN
    SELECT `course_no`,`course_name`,`course_date`,`course_term`,`teach_name`,`teach_phone`,`depart_name`
    FROM `course`,`teacher`,`department`
    WHERE `course_teach_no`=`teach_no` and `teach_depart_no`=`depart_no` and
    `course_no` NOT IN (SELECT `sc_cur_no` FROM `score` WHERE `sc_stu_no`=stu_no);
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `teacher_course_score_proc`;
DELIMITER $
CREATE PROCEDURE `teacher_course_score_proc` (
    IN teacher_no VARCHAR(16)
)
BEGIN
    SELECT `course_no`,`course_name`,`course_date`,`course_term`,MAX(`sc_socre`) as max_score, MIN(`sc_socre`) as min_score,AVG(`sc_socre`) as avg_score
    FROM `course`,`teacher`,`score`
    WHERE `course_teach_no`=teacher_no and `teach_no`=teacher_no and `course_no`=`sc_cur_no`;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `get_student_info_proc`;
DELIMITER $
CREATE PROCEDURE `get_student_info_proc` (
    IN i_stu_no VARCHAR(16)
)
BEGIN
    SELECT `stu_no` as userno,`stu_name` as username,`stu_sex` as usersex,DATE_FORMAT(`stu_enter_date`,'%Y-%m-%d') as enter_date,`class_name`,`teach_name`,`teach_phone`,`depart_name` as departname
    FROM `student`,`class`,`department`,`teacher`
    WHERE `stu_no` LIKE i_stu_no and `stu_class_no`=`class_no` and `stu_depart_no`=`depart_no` and `class_teach_no`=`teach_no`;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `get_teacher_info_proc`;
DELIMITER $
CREATE PROCEDURE `get_teacher_info_proc` (
    IN i_teach_no VARCHAR(16)
)
BEGIN
    SELECT `teach_no` as userno,`teach_name` as username,`teach_sex` as usersex,`teach_phone` as userphone,`depart_name` as departname
    FROM `teacher`,`department`
    WHERE `teach_no` LIKE i_teach_no and `teach_depart_no`=`depart_no`;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `get_admin_info_proc`;
DELIMITER $
CREATE PROCEDURE `get_admin_info_proc` (
    IN i_admin_no VARCHAR(16)
)
BEGIN
    SELECT `admin_no` as userno,`admin_name` as username,`admin_phone` as userphone
    FROM `admin`
    WHERE `admin_no` LIKE i_admin_no;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `get_department_info_proc`;
DELIMITER $
CREATE PROCEDURE `get_department_info_proc` ()
BEGIN
    SELECT `depart_name`,`depart_num`,`teach_name`
    FROM `department`,`teacher`
    WHERE `depart_teach_no`=`teach_no`;
END $
DELIMITER ;

DROP PROCEDURE IF EXISTS `get_class_info_proc`;
DELIMITER $
CREATE PROCEDURE `get_class_info_proc` ()
BEGIN
    SELECT `class_name`,`class_num`,`teach_name`,`depart_name`,`class_term`
    FROM `department`,`class`,`teacher`
    WHERE `class_teach_no`=`teach_no` and `depart_no`=`class_depart_no`;
END $
DELIMITER ;


INSERT INTO `department` values('9900001','计算机与科学技术系','',0);
INSERT INTO `department` values('9900002','信息与通信工程系','',0);
INSERT INTO `department` values('9900003','土木工程材料系','',0);
INSERT INTO `department` values('9900004','城市工程系','',0);

INSERT INTO `class` values('8800001','计算机1班','2019','2200001','9900001',0);
-- INSERT INTO `class` values('8800002','信息工程2班','2019','2200001','9900002',0);

INSERT INTO `admin` values("1000001", '李华', "18018592020");
INSERT INTO `student` values("1900001", '小明', '男', '2020-06-01','8800001','9900001');
INSERT INTO `teacher` values("2200001", '王鹏程', '男', '9900001','13545678951');