SET FOREIGN_KEY_CHECKS=0;
-- 判断索引是否存在的存储过程
DELIMITER ;;
CREATE PROCEDURE dropIndexIfExists(IN idxName VARCHAR(64), IN tblName VARCHAR(64))
BEGIN
    DECLARE indexExists TINYINT DEFAULT 0;

    SELECT COUNT(*)
    INTO indexExists
    FROM information_schema.statistics
    WHERE table_schema = DATABASE() AND index_name = idxName AND table_name = tblName;

    IF indexExists > 0 THEN
        SET @dropIndexSQL = CONCAT('DROP INDEX `', idxName, '` ON `', tblName, '`');
        PREPARE stmt FROM @dropIndexSQL;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END;;
DELIMITER ;



-- 判断字段是否存在的存储过程
DELIMITER ;;
CREATE PROCEDURE addColumnIfNotExists(IN tbl VARCHAR(64), IN col_name VARCHAR(64), IN col_defn TEXT)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = tbl AND column_name = col_name) THEN
    SET @sql = CONCAT('ALTER TABLE `', tbl, '` ADD COLUMN ', col_defn);
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END;;
DELIMITER ;


CALL dropIndexIfExists('idx', 'jshop_addons');
ALTER TABLE `jshop_addons` ADD INDEX `idx`(`status`, `name`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_advert_position');
ALTER TABLE `jshop_advert_position` ADD INDEX `idx`(`code`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_advertisement');
ALTER TABLE `jshop_advertisement` ADD INDEX `idx`(`position_id`, `code`) USING BTREE;
CALL dropIndexIfExists('idx', 'jshop_article');
ALTER TABLE `jshop_article` ADD INDEX `idx`(`type_id`, `is_pub`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_balance');
ALTER TABLE `jshop_balance` ADD INDEX `idx`(`user_id`, `type`, `source_id`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bargain');
ALTER TABLE `jshop_bargain` ADD INDEX `idx`(`id`, `goods_id`, `stime`, `etime`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_bargain_log');
ALTER TABLE `jshop_bargain_log` ADD INDEX `idx`(`record_id`, `user_id`, `bargain_id`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bargain_record');
ALTER TABLE `jshop_bargain_record` ADD INDEX `idx`(`bargain_id`, `user_id`, `status`, `order_id`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bill_aftersales');
ALTER TABLE `jshop_bill_aftersales` ADD INDEX `idx`(`order_id`, `user_id`, `type`, `status`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bill_aftersales_items');
ALTER TABLE `jshop_bill_aftersales_items` ADD INDEX `idx`(`aftersales_id`, `order_items_id`, `sn`, `bn`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bill_delivery');
ALTER TABLE `jshop_bill_delivery` ADD INDEX `idx`(`logi_code`, `logi_no`, `logi_status`, `ship_area_id`, `status`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bill_delivery_items');
ALTER TABLE `jshop_bill_delivery_items` ADD INDEX `idx`(`delivery_id`, `sn`, `bn`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_bill_lading');
ALTER TABLE `jshop_bill_lading` ADD INDEX `idx`(`order_id`, `store_id`, `mobile`, `clerk_id`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_bill_payments');
ALTER TABLE `jshop_bill_payments` ADD INDEX `idx`(`user_id`, `type`, `status`, `payment_code`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_bill_payments_rel');
ALTER TABLE `jshop_bill_payments_rel` ADD INDEX `idx`(`source_id`, `payment_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_bill_refund');
ALTER TABLE `jshop_bill_refund` ADD INDEX `idx`(`aftersales_id`, `user_id`, `source_id`, `type`, `payment_code`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_bill_reship');
ALTER TABLE `jshop_bill_reship` ADD INDEX `idx`(`order_id`, `aftersales_id`, `user_id`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_cart');
ALTER TABLE `jshop_cart` ADD INDEX `idx`(`user_id`, `product_id`, `type`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_clerk');
ALTER TABLE `jshop_clerk` ADD INDEX `idx`(`store_id`, `user_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_coupon');
ALTER TABLE `jshop_coupon` ADD INDEX `idx`(`coupon_code`, `promotion_id`, `user_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_form');
ALTER TABLE `jshop_form` ADD INDEX `idx`(`id`, `type`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_form_item');
ALTER TABLE `jshop_form_item` ADD INDEX `idx`(`form_id`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_form_submit');
ALTER TABLE `jshop_form_submit` ADD INDEX `idx`(`form_id`, `user_id`, `status`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_form_submit_detail');
ALTER TABLE `jshop_form_submit_detail` ADD INDEX `idx`(`submit_id`, `form_id`) USING BTREE;




CALL addColumnIfNotExists('jshop_goods', 'open_point', '`open_point` tinyint(1) UNSIGNED NULL DEFAULT 3 COMMENT \'开启积分，1积分+现金，2积分，3关闭\' AFTER `new_spec`');


CALL addColumnIfNotExists('jshop_goods', 'point', 'point int(10) UNSIGNED NULL DEFAULT 0 COMMENT \'积分数量\' AFTER open_point');


CALL dropIndexIfExists('idx', 'jshop_goods');
ALTER TABLE `jshop_goods` ADD INDEX `idx`(`bn`, `goods_cat_id`, `brand_id`, `marketable`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_goods_browsing');

ALTER TABLE `jshop_goods_browsing` ADD INDEX `idx`(`goods_id`, `user_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_goods_cat');
ALTER TABLE `jshop_goods_cat` ADD INDEX `idx`(`id`, `parent_id`, `type_id`) USING BTREE;


ALTER TABLE `jshop_goods_comment` MODIFY COLUMN `order_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评价订单ID' AFTER `product_id`;

CALL dropIndexIfExists('idx', 'jshop_goods_comment');
ALTER TABLE `jshop_goods_comment` ADD INDEX `idx`(`user_id`, `goods_id`, `order_id`, `display`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_goods_grade');
ALTER TABLE `jshop_goods_grade` ADD INDEX `idx`(`goods_id`, `grade_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_group_goods');

ALTER TABLE `jshop_group_goods` ADD INDEX `idx`(`rule_id`, `goods_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_hooks');
ALTER TABLE `jshop_hooks` ADD INDEX `idx`(`name`, `type`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_ietask');
ALTER TABLE `jshop_ietask` ADD INDEX `idx`(`file_type`, `type`, `status`) USING BTREE;


CALL dropIndexIfExists('idx', 'jshop_images');
ALTER TABLE `jshop_images` ADD INDEX `idx`(`id`, `group_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_invoice_record');
ALTER TABLE `jshop_invoice_record` ADD INDEX `idx`(`code`, `name`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_login_log');
ALTER TABLE `jshop_login_log` ADD INDEX `idx`(`user_id`, `state`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_operation_log');
ALTER TABLE `jshop_operation_log` ADD INDEX `idx`(`manage_id`, `controller`, `method`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_order');
ALTER TABLE `jshop_order` ADD INDEX `idx`(`order_id`, `pay_status`, `ship_status`, `status`, `order_type`, `payment_code`, `ctime`) USING BTREE;

ALTER TABLE `jshop_order_items` MODIFY COLUMN `promotion_list` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '促销信息' AFTER `promotion_amount`;

CALL dropIndexIfExists('idx', 'jshop_order_items');
ALTER TABLE `jshop_order_items` ADD INDEX `idx`(`order_id`, `goods_id`, `product_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_order_log');
ALTER TABLE `jshop_order_log` ADD INDEX `idx`(`order_id`, `user_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_pages');
ALTER TABLE `jshop_pages` ADD INDEX `idx`(`code`, `is_main`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_pages_items');
ALTER TABLE `jshop_pages_items` ADD INDEX `idx`(`widget_code`, `page_code`, `position_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_pages_menu');
ALTER TABLE `jshop_pages_menu` ADD INDEX `idx`(`menu_id`, `pid`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_payments');
ALTER TABLE `jshop_payments` ADD INDEX `idx`(`code`, `is_online`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_pintuan_record');
ALTER TABLE `jshop_pintuan_record` ADD INDEX `idx`(`team_id`, `user_id`, `goods_id`, `status`, `order_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_pintuan_rule');
ALTER TABLE `jshop_pintuan_rule` ADD INDEX `idx`(`stime`, `etime`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_promotion');
ALTER TABLE `jshop_promotion` ADD INDEX `idx`(`status`, `type`, `stime`, `etime`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_promotion_record');
ALTER TABLE `jshop_promotion_record` ADD INDEX `idx`(`promotion_id`, `user_id`, `goods_id`, `order_id`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_promotion_result');
ALTER TABLE `jshop_promotion_result` ADD INDEX `idx`(`promotion_id`, `code`) USING BTREE;



CALL dropIndexIfExists('idx', 'jshop_ship');
ALTER TABLE `jshop_ship` ADD INDEX `idx`(`name`, `type`, `is_def`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_sms');

ALTER TABLE `jshop_sms` ADD INDEX `idx`(`mobile`, `code`, `status`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_store');
ALTER TABLE `jshop_store` ADD INDEX `idx`(`store_name`, `area_id`, `latitude`, `longitude`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user');
ALTER TABLE `jshop_user` ADD INDEX `idx`(`username`, `mobile`, `status`, `pid`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user_bankcards');
ALTER TABLE `jshop_user_bankcards` ADD INDEX `idx`(`user_id`, `bank_name`, `bank_code`, `is_default`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user_log');
ALTER TABLE `jshop_user_log` ADD INDEX `idx`(`user_id`, `state`, `type`) USING BTREE;


CALL addColumnIfNotExists('jshop_user_point_log', 'surplus_num', '`surplus_num` int(10) NULL DEFAULT NULL COMMENT \'剩余积分数量\' AFTER `num`');


CALL dropIndexIfExists('idx', 'jshop_user_point_log');
ALTER TABLE `jshop_user_point_log` ADD INDEX `idx`(`user_id`, `type`, `ctime`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user_ship');
ALTER TABLE `jshop_user_ship` ADD INDEX `idx`(`user_id`, `area_id`, `is_def`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user_tocash');
ALTER TABLE `jshop_user_tocash` ADD INDEX `idx`(`user_id`, `bank_name`, `bank_code`, `type`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user_token');
ALTER TABLE `jshop_user_token` ADD INDEX `idx`(`token`, `user_id`, `platform`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_user_wx');
ALTER TABLE `jshop_user_wx` ADD INDEX `idx`(`type`, `user_id`, `openid`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_weixin_menu');
ALTER TABLE `jshop_weixin_menu` ADD INDEX `idx`(`menu_id`, `pid`, `type`) USING BTREE;

CALL dropIndexIfExists('idx', 'jshop_weixin_message');
ALTER TABLE `jshop_weixin_message` ADD INDEX `idx`(`type`, `ctime`, `is_default`, `enable`) USING BTREE;


INSERT INTO `jshop_payments`(`id`, `code`, `name`, `is_online`, `params`, `sort`, `memo`, `status`) VALUES (5, 'deliverypay', '货到付款', 1, '', 100, '货到付款', 1);


DROP PROCEDURE IF EXISTS dropIndexIfExists;
DROP PROCEDURE IF EXISTS addColumnIfNotExists;


SET FOREIGN_KEY_CHECKS = 1;
