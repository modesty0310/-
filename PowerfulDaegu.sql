CREATE TABLE `user` (
	`id`	bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`password`	varchar(255)	NULL,
	`name`	varchar(100)	NULL,
	`nickname`	varchar(100)	NULL,
	`gender`	bit(1)	NULL,
	`term`	bit(1)	NULL,
	`email`	varchar(255)	NULL,
	`phone_number`	char(11)	NULL,
	`birthday`	datetime	NULL,
	`admin`	bit(1)	NULL,
	`user_type`	varchar(30)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

CREATE TABLE `store` (
	`id` int(11) NOT NULL PRIMARY KEY,
	`name` varchar(100)	NULL,
	`code` int(11)	NULL,
	`city_name`	varchar(100) NULL,
	`city_code`	int(11)	NULL,
	`street_address` varchar(255) NULL,
	`detail_address` varchar(255) NULL,
	`phone_number` char(11) NULL,
	`week_start` datetime NULL,
	`week_end` datetime NULL,
	`sat_start` datetime NULL,
	`sat_end` datetime NULL,
	`holiday_start` datetime NULL,
	`holiday_end` datetime NULL,
	`delivery` bit(1) NULL,
	`created` datetime NULL,
	`updated` datetime NULL,
	`deleted` datetime NULL,
	`point`	point NULL,
	`food_code`	int(11)	NOT NULL
);

CREATE TABLE `store_like` (
	`user_id`	bigint(20)	NOT NULL,
	`store_id`	int(11)	NOT NULL
);

CREATE TABLE `menu` (
	`id` bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`stroe_id` int(11) NOT NULL,
	`name`	varchar(100) NULL,
	`price`	varchar(100) NULL,
	`created` datetime NULL,
	`updated` datetime NULL,
	`deleted` datetime NULL
);

CREATE TABLE `store_type` (
	`food_code`	int(11)	NOT NULL,
	`category`	varchar(100)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

CREATE TABLE `notice` (
	`id`	bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`writer`	bigint(20)	NOT NULL,
	`title`	varchar(255)	NULL,
	`contents`	text	NULL,
	`category`	int(1)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

CREATE TABLE `faq` (
	`id`	bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`writer`	bigint(20)	NOT NULL,
	`title`	varchar(255)	NULL,
	`question`	text	NULL,
	`answer`	text	NULL,
	`category`	int(1)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

CREATE TABLE `qna` (
	`id`	bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`writer`	bigint(20)	NOT NULL,
	`answerer`	bigint(20)	NOT NULL,
	`title`	varchar(255)	NULL,
	`question`	text	NULL,
	`answer`	text	NULL,
	`category`	int(1)	NULL,
	`file`	varchar(255)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

CREATE TABLE `talk` (
	`id`	bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`writer`	bigint(20)	NOT NULL,
	`store_id`	int(11)	NOT NULL,
	`title`	varchar(255)	NULL,
	`contents`	text	NULL,
	`category`	int(1)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

CREATE TABLE `talk_like` (
	`user_id`	bigint(20)	NOT NULL,
	`talk_id`	bigint(20)	NOT NULL
);

CREATE TABLE `talk_report` (
	`id`	bigint(20)	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`user_id`	bigint(20)	NOT NULL,
	`talk_id`	bigint(20)	NOT NULL,
	`code`	int(1)	NULL,
	`created`	datetime	NULL,
	`updated`	datetime	NULL,
	`deleted`	datetime	NULL
);

ALTER TABLE `user` ADD CONSTRAINT `PK_USER` PRIMARY KEY (
	`id`
);

ALTER TABLE `store` ADD CONSTRAINT `PK_STORE` PRIMARY KEY (
	`id`
);

ALTER TABLE `store_like` ADD CONSTRAINT `PK_STORE_LIKE` PRIMARY KEY (
	`user_id`,
	`store_id`
);

ALTER TABLE `menu` ADD CONSTRAINT `PK_MENU` PRIMARY KEY (
	`id`
);

ALTER TABLE `store_type` ADD CONSTRAINT `PK_STORE_TYPE` PRIMARY KEY (
	`food_code`
);

ALTER TABLE `notice` ADD CONSTRAINT `PK_NOTICE` PRIMARY KEY (
	`id`
);

ALTER TABLE `faq` ADD CONSTRAINT `PK_FAQ` PRIMARY KEY (
	`id`
);

ALTER TABLE `qna` ADD CONSTRAINT `PK_QNA` PRIMARY KEY (
	`id`
);

ALTER TABLE `talk` ADD CONSTRAINT `PK_TALK` PRIMARY KEY (
	`id`
);

ALTER TABLE `talk_like` ADD CONSTRAINT `PK_TALK_LIKE` PRIMARY KEY (
	`user_id`,
	`talk_id`
);

ALTER TABLE `talk_report` ADD CONSTRAINT `PK_TALK_REPORT` PRIMARY KEY (
	`id`
);

ALTER TABLE `store_like` ADD CONSTRAINT `FK_user_TO_store_like_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `user` (
	`id`
);

ALTER TABLE `store_like` ADD CONSTRAINT `FK_store_TO_store_like_1` FOREIGN KEY (
	`store_id`
)
REFERENCES `store` (
	`id`
);

ALTER TABLE `talk_like` ADD CONSTRAINT `FK_user_TO_talk_like_1` FOREIGN KEY (
	`user_id`
)
REFERENCES `user` (
	`id`
);

ALTER TABLE `talk_like` ADD CONSTRAINT `FK_talk_TO_talk_like_1` FOREIGN KEY (
	`talk_id`
)
REFERENCES `talk` (
	`id`
);

