/*
 Navicat Premium Data Transfer

 Source Server         : qfyu-service
 Source Server Type    : MySQL
 Source Server Version : 50725
 Source Host           : 192.168.0.60:3306
 Source Schema         : new_erp

 Target Server Type    : MySQL
 Target Server Version : 50725
 File Encoding         : 65001

 Date: 25/12/2020 08:41:44
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for qfyu_acconline
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_acconline`;
CREATE TABLE `qfyu_acconline`  (
  `bill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '即时盘点单编号',
  `ware_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编号',
  `empno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人编号',
  `auditno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审单员编号',
  `transfer` tinyint(1) NULL DEFAULT 0 COMMENT '是否已审核 1已审核 0未审核',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `creater` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `f_date` datetime(0) NULL DEFAULT NULL COMMENT '单据日期',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `grup` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源所属组',
  PRIMARY KEY (`bill_no`) USING BTREE,
  INDEX `ware_code`(`ware_code`) USING BTREE,
  INDEX `transfer`(`transfer`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '即时盘点单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_acconline
-- ----------------------------
INSERT INTO `qfyu_acconline` VALUES ('TO2012235610198489', 'CK003', '001', '001', 1, '即时盘点单测试', '001', '2020-12-23 00:00:00', '2020-12-23 18:24:40', '001', '2020-12-24 10:15:38', '1');
INSERT INTO `qfyu_acconline` VALUES ('TO2012241005550485', 'CK003', '001', '001', 1, NULL, '001', '2020-12-24 00:00:00', '2020-12-24 11:16:45', NULL, NULL, '1');

-- ----------------------------
-- Table structure for qfyu_acconline_detail
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_acconline_detail`;
CREATE TABLE `qfyu_acconline_detail`  (
  `bill_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '即时盘点单编号',
  `item_no` int(10) NOT NULL COMMENT '序号',
  `pos_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位编号',
  `goods_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编号',
  `unit` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品单位',
  `price` decimal(16, 6) NULL DEFAULT NULL COMMENT '产品价格',
  `qty` decimal(15, 5) NULL DEFAULT 0.00000 COMMENT '账面库存',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '库存总价值',
  `rqty` decimal(15, 5) NULL DEFAULT 0.00000 COMMENT '实际库存',
  `ramount` decimal(16, 6) NULL DEFAULT NULL COMMENT '实际总价值',
  `diff_qty` decimal(15, 5) NULL DEFAULT 0.00000 COMMENT '盈亏库存',
  `diff_amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '盈亏总价值',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品批号',
  `pro_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期',
  `sup_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `flag` tinyint(1) NOT NULL DEFAULT 1 COMMENT '类别 1手动添加 0关联库存记录',
  `stock_id` int(10) NULL DEFAULT NULL COMMENT '库存明细表id',
  `update_ver` bigint(10) NULL DEFAULT NULL COMMENT '防止未修改内容更新失败',
  INDEX `bill_no`(`bill_no`) USING BTREE,
  INDEX `bill_no_2`(`bill_no`, `item_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '即时盘点单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_acconline_detail
-- ----------------------------
INSERT INTO `qfyu_acconline_detail` VALUES ('TO2012235610198489', 3, 'WP0011', 'FG001', '盒', 9.900000, 0.00000, 0.000000, 8.00000, 79.200000, 8.00000, 79.200000, '20201223', '2020-12-22', '2022-12-13', 'FS002', '测试3', 1, 0, 1608776138);
INSERT INTO `qfyu_acconline_detail` VALUES ('TO2012241005550485', 3, 'WP0011', 'FG001', '盒', 9.800000, 0.00000, 0.000000, 1.00000, 9.800000, 1.00000, 9.800000, '20201224', '2020-12-24', '2023-12-20', 'FS002', NULL, 1, 0, 1608779805);

-- ----------------------------
-- Table structure for qfyu_accstock
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_accstock`;
CREATE TABLE `qfyu_accstock`  (
  `bill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '结存单编号',
  `ware_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编号',
  `empno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人编号',
  `auditno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审单员编号',
  `transfer` tinyint(1) NULL DEFAULT 0 COMMENT '是否已审核 1已审核 0未审核',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `creater` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `f_date` datetime(0) NULL DEFAULT NULL COMMENT '单据日期',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `grup` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源所属组',
  PRIMARY KEY (`bill_no`) USING BTREE,
  INDEX `ware_code`(`ware_code`) USING BTREE,
  INDEX `transfer`(`transfer`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存结存单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_accstock
-- ----------------------------
INSERT INTO `qfyu_accstock` VALUES ('AS2012165399975749', 'CK006', '001', '001', 1, NULL, '001', '2020-12-16 10:33:25', '2020-12-16 10:33:25', '001', '2020-12-16 10:34:16', '1');
INSERT INTO `qfyu_accstock` VALUES ('AS2012191025157100', 'CK004', '001', '001', 1, NULL, '001', '2020-12-19 17:07:11', '2020-12-19 17:07:11', '001', '2020-12-19 17:07:45', '1');
INSERT INTO `qfyu_accstock` VALUES ('AS2012225610010252', 'CK003', '001', '001', 1, NULL, '001', '2020-12-22 09:58:32', '2020-12-22 09:58:32', '001', '2020-12-22 09:59:03', '1');
INSERT INTO `qfyu_accstock` VALUES ('AS2012235353545054', 'CK003', '001', '001', 1, NULL, '001', '2020-12-23 14:09:41', '2020-12-23 14:09:41', '001', '2020-12-23 14:09:46', '1');

-- ----------------------------
-- Table structure for qfyu_accstock_detail
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_accstock_detail`;
CREATE TABLE `qfyu_accstock_detail`  (
  `itemno` int(10) NOT NULL COMMENT '序号',
  `bill_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '结存单编号',
  `goods_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编号',
  `pos_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位编号',
  `sup_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品批号',
  `pro_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期',
  `qty1` decimal(15, 5) NULL DEFAULT 0.00000 COMMENT '主单位库存',
  `qty2` decimal(15, 5) NULL DEFAULT 0.00000 COMMENT '辅单位库存',
  `price1` decimal(16, 6) NULL DEFAULT NULL COMMENT '主单位价格',
  `price2` decimal(16, 6) NULL DEFAULT NULL COMMENT '辅单位价格',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '库存总价值',
  `selprice` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考批发价',
  `rtlprice` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考零售价',
  `stock_id` int(10) NULL DEFAULT NULL COMMENT '库存明细表id',
  `dispatched` tinyint(1) NULL DEFAULT 0 COMMENT '分发标志',
  INDEX `bill_no`(`bill_no`) USING BTREE,
  INDEX `itemno`(`itemno`, `bill_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存结存单详情' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_accstock_detail
-- ----------------------------
INSERT INTO `qfyu_accstock_detail` VALUES (1, 'AS2012165399975749', 'FG001', 'WP007', 'FS003', '20200628', '2020-06-28', '2022-12-06', 30.00000, 30.00000, 25.000000, 25.000000, 750.000000, 6.000000, 7.000000, 107, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (2, 'AS2012165399975749', 'FG001', 'WP007', 'FS003', '20201004', '2020-10-04', '2022-11-21', 30.00000, 30.00000, 30.000000, 30.000000, 900.000000, 6.000000, 7.000000, 108, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (3, 'AS2012165399975749', 'FG001', 'WP007', 'FS003', '20200812', '2020-08-12', '2022-10-18', 30.00000, 30.00000, 25.000000, 25.000000, 750.000000, 6.000000, 7.000000, 109, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (4, 'AS2012165399975749', 'FG001', 'WP007', 'FS003', '20201022', '2020-10-22', '2022-12-28', 30.00000, 30.00000, 25.000000, 25.000000, 750.000000, 6.000000, 7.000000, 110, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (1, 'AS2012191025157100', 'FG001', 'WP0010', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 15.00000, 15.00000, 10.000000, 5.000000, 150.000000, 6.000000, 7.000000, 122, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (2, 'AS2012191025157100', 'FG002', 'WP0010', 'FS003', '20201219-002', '2019-08-20', '2021-12-30', 35.00000, 35.00000, 7.000000, 0.000000, 245.000000, 9.000000, NULL, 123, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (3, 'AS2012191025157100', 'FG002', 'WP0010', 'FS003', '20201219-003', '2019-12-24', '2022-12-22', 20.00000, 20.00000, 7.000000, 0.000000, 140.000000, 9.000000, NULL, 124, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (4, 'AS2012191025157100', 'FG001', 'WP0010', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 12.25000, 12.00000, 21.600000, 10.800000, 264.600000, 6.000000, 7.000000, 153, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (1, 'AS2012225610010252', 'FG001', 'WP0011', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 17.87500, 17.00000, 13.600000, 6.800000, 243.100000, 6.000000, 7.000000, 125, 0);
INSERT INTO `qfyu_accstock_detail` VALUES (2, 'AS2012225610010252', 'FG002', 'WP0011', 'FS003', '20201219-8888', '2018-12-20', '2022-12-20', 50.00000, 50.00000, 5.780000, 0.000000, 289.000000, 9.000000, NULL, 126, 0);
INSERT INTO `qfyu_accstock_detail` VALUES (3, 'AS2012225610010252', 'FG002', 'WP0011', 'FS003', '20201221-001', '2019-06-20', '2022-12-23', 50.00000, 50.00000, 12.680000, 0.000000, 634.000000, 9.000000, NULL, 164, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (1, 'AS2012235353545054', 'FG001', 'WP0011', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 17.87500, 17.00000, 13.600000, 6.800000, 243.100000, 6.000000, 7.000000, 125, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (2, 'AS2012235353545054', 'FG002', 'WP0011', 'FS003', '20201219-8888', '2018-12-20', '2022-12-20', 50.00000, 50.00000, 5.780000, 0.000000, 289.000000, 9.000000, NULL, 126, 1);
INSERT INTO `qfyu_accstock_detail` VALUES (3, 'AS2012235353545054', 'FG002', 'WP0011', 'FS003', '20201221-001', '2019-06-20', '2022-12-23', 48.00000, 48.00000, 12.680000, 0.000000, 608.640000, 9.000000, NULL, 164, 1);

-- ----------------------------
-- Table structure for qfyu_action_log
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_action_log`;
CREATE TABLE `qfyu_action_log`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL COMMENT '操作用户ID',
  `action` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作记录',
  `info` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '操作详情',
  `create_time` int(10) UNSIGNED NOT NULL COMMENT '操作时间',
  `create_ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '操作IP',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_area_mgt
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_area_mgt`;
CREATE TABLE `qfyu_area_mgt`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '地区id',
  `parent_id` int(10) NULL DEFAULT NULL COMMENT '父级id',
  `area_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地区名称',
  `level` tinyint(1) NULL DEFAULT NULL COMMENT '等级',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '地区管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_area_mgt
-- ----------------------------
INSERT INTO `qfyu_area_mgt` VALUES (1, 0, '所有地区', 0);
INSERT INTO `qfyu_area_mgt` VALUES (2, 1, '广东省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (3, 1, '广西省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (4, 2, '深圳市', 2);
INSERT INTO `qfyu_area_mgt` VALUES (5, 4, '龙华新区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (6, 5, '民治片区', 4);
INSERT INTO `qfyu_area_mgt` VALUES (7, 1, '海南省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (8, 6, '上塘社区', 5);
INSERT INTO `qfyu_area_mgt` VALUES (9, 2, '广州市', 2);
INSERT INTO `qfyu_area_mgt` VALUES (10, 2, '珠海市', 2);
INSERT INTO `qfyu_area_mgt` VALUES (11, 3, '桂林市', 2);
INSERT INTO `qfyu_area_mgt` VALUES (12, 3, '玉林市', 2);
INSERT INTO `qfyu_area_mgt` VALUES (13, 7, '三亚市', 2);
INSERT INTO `qfyu_area_mgt` VALUES (14, 9, '番禺区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (15, 10, '滨海区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (16, 4, '南山区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (17, 4, '宝安区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (18, 4, '光明区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (19, 4, '龙岗区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (20, 4, '罗湖区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (21, 4, '坪山区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (22, 4, '大鹏区', 3);
INSERT INTO `qfyu_area_mgt` VALUES (23, 22, '大鹏半岛', 4);
INSERT INTO `qfyu_area_mgt` VALUES (24, 1, '云南省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (25, 1, '四川省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (26, 1, '江西省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (27, 1, '湖南省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (28, 1, '湖北省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (29, 1, '重庆市', 1);
INSERT INTO `qfyu_area_mgt` VALUES (30, 1, '福建省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (31, 1, '贵州省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (32, 1, '浙江省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (33, 1, '安徽省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (34, 1, '上海市', 1);
INSERT INTO `qfyu_area_mgt` VALUES (35, 1, '江苏省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (36, 1, '河南省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (37, 1, '陕西省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (38, 1, '山西省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (39, 1, '甘肃省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (40, 1, '宁夏省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (41, 1, '青海省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (42, 1, '西藏省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (43, 1, '新疆省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (44, 1, '内蒙古', 1);
INSERT INTO `qfyu_area_mgt` VALUES (45, 1, '河北省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (46, 1, '山东省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (47, 1, '天津省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (48, 1, '北京市', 1);
INSERT INTO `qfyu_area_mgt` VALUES (49, 1, '辽宁省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (50, 1, '吉林省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (51, 1, '黑龙江省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (52, 1, '台湾省', 1);
INSERT INTO `qfyu_area_mgt` VALUES (53, 1, '香港', 1);
INSERT INTO `qfyu_area_mgt` VALUES (54, 1, '澳门', 1);

-- ----------------------------
-- Table structure for qfyu_branch
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_branch`;
CREATE TABLE `qfyu_branch`  (
  `branch_id` int(10) UNSIGNED NOT NULL,
  `network_num` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '入网序号',
  `tax_num` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '税务证号',
  `business_license` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业执照',
  `business_license_validity` int(10) NULL DEFAULT NULL COMMENT '有效期',
  `organization` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组织机构代码',
  `organization_validity` int(10) NULL DEFAULT NULL COMMENT '组织机构代码有效期',
  `drug_license` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '药品经营许可证',
  `drug_license_validity` int(10) NULL DEFAULT NULL COMMENT '药品经营许可证有效期',
  `gsp_license` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GSP证书',
  `gsp_license_validity` int(10) NULL DEFAULT NULL COMMENT 'GSP证书有效期',
  PRIMARY KEY (`branch_id`) USING BTREE,
  UNIQUE INDEX `qfyu_branch_ibfk_1`(`branch_id`) USING BTREE,
  CONSTRAINT `qfyu_branch_ibfk_1` FOREIGN KEY (`branch_id`) REFERENCES `qfyu_depart` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '企业机构资质表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_branch
-- ----------------------------
INSERT INTO `qfyu_branch` VALUES (1, '', '', '954165165161941', NULL, '', NULL, '', NULL, '', NULL);
INSERT INTO `qfyu_branch` VALUES (4, '', '5345345', '1561516565165', 0, 'wrwerwer', 0, '5345435345', 0, '', 0);
INSERT INTO `qfyu_branch` VALUES (8, NULL, NULL, '9546549816516', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity`;
CREATE TABLE `qfyu_commodity`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商品id',
  `goods_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编码',
  `goods_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '通用名称',
  `en_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '英文名称',
  `code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '条形码',
  `file_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '附件名',
  `pym` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拼音码',
  `specs` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '规格',
  `packspecs` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装规格',
  `electron_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电子监管类别码',
  `color_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '彩页码',
  `kinds_id` int(10) NULL DEFAULT NULL COMMENT '许可经营类别id',
  `category_id` int(10) NULL DEFAULT NULL COMMENT '商品大类id',
  `function_id` int(10) NOT NULL COMMENT '商品功能类别id',
  `top_fid` int(10) NULL DEFAULT NULL COMMENT '商品功能类别顶级id',
  `parent_fid` int(10) NULL DEFAULT NULL COMMENT '商品功能类别父级id',
  `depart_id` int(10) NULL DEFAULT NULL COMMENT '所属部门',
  `parent_kindid` int(10) NULL DEFAULT NULL COMMENT '商品功能类别上级id',
  `origin` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产地',
  `production` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '生产企业',
  `maker` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产企业简称',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主单位',
  `unit2` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '辅单位',
  `is_solit` tinyint(1) NULL DEFAULT NULL COMMENT '允许拆分 0不拆分 1拆分',
  `solit_value` int(10) UNSIGNED NULL DEFAULT 1 COMMENT '拆零比例(1:N)',
  `dosage` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '剂型',
  `tax` decimal(6, 2) NULL DEFAULT NULL COMMENT '税率',
  `approval_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '批准文号、注册证号',
  `approval_date` date NULL DEFAULT NULL COMMENT '批准文号、注册证号有效期',
  `shelf_life` int(10) NULL DEFAULT NULL COMMENT '保质期',
  `shelf_unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保质期单位',
  `take` decimal(12, 4) NULL DEFAULT NULL COMMENT '提成率(%)',
  `gsp_type` tinyint(1) NOT NULL COMMENT 'gsp验收类型',
  `standard_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '本位码',
  `supervise_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '监管码',
  `pack_specs1` int(10) NULL DEFAULT NULL COMMENT '中包装数',
  `pack_specs2` int(10) NULL DEFAULT NULL COMMENT '大包装数',
  `drug` decimal(12, 3) NULL DEFAULT NULL COMMENT '含量',
  `drug_unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '含量单位',
  `hours` int(10) NULL DEFAULT NULL COMMENT '运输在途时限(小时)',
  `element_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '成分类别',
  `coloc_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品色标',
  `billing_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开票类型',
  `pifaml` decimal(8, 4) NULL DEFAULT NULL COMMENT '批发毛利率',
  `retail` decimal(8, 4) NULL DEFAULT NULL COMMENT '零售毛利率',
  `markup` tinyint(1) NULL DEFAULT 0 COMMENT '涨跌价 默认0正常 2涨价 3跌',
  `is_medical` tinyint(1) NULL DEFAULT 0 COMMENT '基本医疗用药 默认0不限制 1限制医疗用药',
  `is_check` tinyint(1) NULL DEFAULT 0 COMMENT '澄明度检验 默认0不限制 1需要检验',
  `is_qty` tinyint(1) NULL DEFAULT 0 COMMENT '核算数量 默认0不限制 1需要核算',
  `is_first` tinyint(1) NULL DEFAULT 0 COMMENT '是否首营产品 默认0 1首营',
  `is_variety` tinyint(1) NULL DEFAULT 0 COMMENT '中标品种(禁销药店) 默认0不限制 1禁销药店',
  `is_rx` tinyint(1) NULL DEFAULT 0 COMMENT '是否处方药 默认0不是 1处方药',
  `is_shopping` tinyint(1) NULL DEFAULT 0 COMMENT '是否可网购 默认0不限制 1可网购 2不可网购',
  `is_yi` tinyint(1) NULL DEFAULT 0 COMMENT '限售医院H 默认0不限制 1限制只批发给医院客户',
  `is_yymz` tinyint(1) NULL DEFAULT 0 COMMENT '限售医院门诊C 默认0不限制 1限制医院门诊销售',
  `is_vip` tinyint(1) NULL DEFAULT 0 COMMENT '是否会员商品 默认0不限制 1会员',
  `is_supervise` tinyint(1) NULL DEFAULT 0 COMMENT '是否监管 默认0不监管 1监管',
  `is_drugs` tinyint(1) NULL DEFAULT 0 COMMENT '是否特殊药品复方制剂 默认0不是 1是',
  `is_gift` tinyint(1) NULL DEFAULT 0 COMMENT '是否赠品 默认0不是 1赠品',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '商品状态  默认0未审核 1审核通过 2审核不通过',
  `creater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `creater_date` datetime(0) NOT NULL COMMENT '创建时间',
  `checker` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `updater_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`, `goods_code`) USING BTREE,
  INDEX `goods_code`(`goods_code`) USING BTREE,
  INDEX `code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品基本信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity
-- ----------------------------
INSERT INTO `qfyu_commodity` VALUES (6, 'FG001', '999感冒灵颗粒', '999感冒灵颗粒', '999 Ganmaoling granules', '条形码456', '附件名123', '999GMLKL', '10g*9袋', '', '321456987', '', 13, 6, 49, 25, 32, 1, NULL, '惠州市', '惠州市九惠制药股份有限公司', '九惠制药', '盒', '千克', 1, 2, '颗粒剂', 15.00, '国药准字Z44021940', '2020-10-22', 2, '年', 15.0000, 1, '91441300196021697M', '', 1, 1, 1.000, '', 8, '鞣制', '红色', '普通发票', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-11-02 10:02:30', '001', '2020-12-21 08:54:06', '2020-12-21 08:54:00', '001', '首营品种');
INSERT INTO `qfyu_commodity` VALUES (19, 'FG002', '健胃消食片（成人）', '健胃消食片（成人）', '', '', '', 'JWXSP_CR_', '8片*4板', '8片一盒', '', '', 4, 18, 33, 0, 25, NULL, NULL, '广州', '广州白云山和记黄埔中药有限公司', '', '盒', '个', 1, 3, '片剂', NULL, '国药准字Z20055041', '2022-10-23', 20, '月', 0.0000, 2, '6903757998054', '', 1, 1, 1.000, '', NULL, '', '', '普通发票', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-11-06 11:17:01', '001', '2020-12-23 13:41:48', '2020-12-23 13:41:14', '001', '首营品种');
INSERT INTO `qfyu_commodity` VALUES (20, 'FG003', '肾宝片(汇仁)', '肾宝片(汇仁)', 'Shenbao tablet (Huiren)', '条形码', '附件名', 'SBP_HR_', '0.7g*9片*14板', '14板一盒', '电子监管码', '彩页码111', 3, 1, 47, 0, 29, 1, NULL, '江西', '江西汇仁药业有限公司', '汇仁药业', '盒', '箱', 1, 2, '片剂', 15.00, '国药准字Z20080627', '2020-10-23', NULL, NULL, 13.0000, 3, 'B12002011692', '监管码11', 1, 1, 11.000, '含量单位', 8, '', '1', NULL, 15.0000, 13.0000, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-11-06 11:46:08', '001', '2020-12-18 11:42:12', '2020-12-18 11:42:03', '001', '首营品种');
INSERT INTO `qfyu_commodity` VALUES (21, 'FG004', '84消毒液', '84消毒液', '', '', '', '84XDY', '111', '', '', '', 3, 2, 31, NULL, 0, 8, NULL, '', '测试', '', '盒', NULL, 0, 1, '酒剂', 17.00, '1111', '2020-10-27', NULL, '', 10.0000, 4, '111', '', 1, 1, 1.000, '', 8, '', '', '', 10.0000, 10.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:08:01', '2020-12-10 10:06:55', '009', '测试');
INSERT INTO `qfyu_commodity` VALUES (22, 'FG0011', '氨咖黄敏胶囊(特价)禾穗速效', '氨咖黄敏胶囊(特价)禾穗速效', 'Ankahuangmin capsule (special price) hesui quick acting', '534654', '132', 'AKHMJN_TJ_HSSX', '12粒', '', '', '', 5, 5, 41, 0, 26, NULL, NULL, '广州', '广州白云山光华制药股份有限公司', '', '盒', '', 0, 1, '胶囊剂', NULL, '国药准字H44024290', '2020-11-18', NULL, '', 0.0000, 5, '6900372205017', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:08:04', '2020-12-10 10:07:21', '009', '首营');
INSERT INTO `qfyu_commodity` VALUES (23, 'FG0010', 'J 75%酒精消毒液 P 500ml', 'J 75%酒精消毒液 P 500ml', '', '', '', 'J 75_JJXDY P 500ml', '500ml', '', '', '', 119, 2, 45, 0, 28, NULL, NULL, '山东', '山东利尔康医疗科技股份有限公司', '', '瓶', '', 0, 1, '酒剂', 13.00, '鲁卫消证字(2002)第0059号', '2020-10-29', NULL, '', 1.0000, 6, '509059', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:08:07', '2020-12-10 10:07:32', '009', '首营');
INSERT INTO `qfyu_commodity` VALUES (24, 'FG008', '测试产品', '测试产品', '', '', '', 'CSCP', '111', '', '', '', 12, 14, 38, 0, 26, 7, NULL, '', '测试', '', '盒', '盒', 0, 1, '混悬剂', NULL, '12321', '2020-10-27', 12, '月', 0.0000, 6, '11', '', 0, 0, 0.000, '', NULL, '钛镁铝鈊', '黄色', '普通发票', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:08:11', '2020-12-22 11:30:04', '009', '3123');
INSERT INTO `qfyu_commodity` VALUES (25, 'FG0012', '罗浮山百草油 P', '罗浮山百草油 P', '', '', '', 'LFSBCY P', '3ml', '', '', '', 105, NULL, 49, 25, 32, 4, NULL, '广东', '广东罗浮山国药股份有限公司', '', '瓶', '', 0, 1, '乳剂', NULL, '国药准字Z44022355', '2020-11-30', NULL, '', 0.0000, 5, 'b123456789', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, '009', '2020-11-11 08:56:09', '009', '2020-12-10 14:49:24', '2020-12-10 10:11:18', '009', '首营');
INSERT INTO `qfyu_commodity` VALUES (26, 'FG006', '测试3', '测试3', '', '', '', 'CS3', '测试3', '', '', '', 1, NULL, 49, 25, 32, NULL, NULL, '', '测试3', '', '袋', '包', 0, 2, '酊剂', NULL, '测试3', '2020-10-26', NULL, '', 0.0000, 4, '测试3', '', 1, 1, 1.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-11 08:56:31', '009', '2020-12-07 15:05:36', '2020-12-21 11:05:22', '009', '测试3');
INSERT INTO `qfyu_commodity` VALUES (27, 'FG009', '测试商品666', '测试商品666', '', '', '', 'CSSP666', '规格66', '', '', '', 100, 2, 39, 0, 26, 5, NULL, '广东', '测试生产企业', '', '盒', '把', 0, 2, '喷雾剂', 15.00, '批准文号666', '2020-10-28', 24, '月', 0.0000, 3, '312', '', 1, 1, 1.000, '', 12, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-11 08:56:44', '009', '2020-11-20 10:23:39', '2020-12-21 14:13:16', '009', '1323');
INSERT INTO `qfyu_commodity` VALUES (33, 'GD0014', '测试6666', '测试6666', '', '', '', 'CS6666', '规格11', '', '', '', 13, 2, 37, 0, 26, 3, NULL, '', '生产企业', '', '盒', '合', 1, 2, '丸剂', NULL, '批准文号111', NULL, NULL, '', 0.0000, 2, '', '', 1, 1, 1.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-11 10:36:23', '009', '2020-11-11 10:56:17', '2020-12-21 11:03:56', '009', '');
INSERT INTO `qfyu_commodity` VALUES (34, 'FG005', '测试2', '测试2', '', '', '', 'CS2', '11', '', '', '', 14, NULL, 36, 0, 26, NULL, NULL, '', '11', '', '袋', '', 0, 1, '滴鼻剂', NULL, '111', '2020-10-27', NULL, '', 0.0000, 1, '1', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-19 16:40:25', '009', '2020-12-07 15:05:58', '2020-12-10 10:14:29', '009', '1111');
INSERT INTO `qfyu_commodity` VALUES (35, 'FG0013', '荆防颗粒', '荆防颗粒', '', '', '', 'JFKL', '15g*20袋/包', '', '', '', 122, 6, 48, 0, 27, 2, NULL, '', '九寨沟天然药业集团有限责任公司', '', '盒', '', 0, 1, '颗粒剂', NULL, '国药准字Z51021290', '2020-11-16', NULL, '', 0.0000, 1, 'B10234656', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, '009', '2020-11-19 18:35:32', '009', '2020-12-10 14:49:19', '2020-12-10 10:13:28', '009', '首营');
INSERT INTO `qfyu_commodity` VALUES (38, 'GD0015', '东北大米', '东北大米', '', '', '', 'DBDM', '234', '', '', '', 121, NULL, 48, 0, 27, 1, NULL, '', '2', '', '袋', '', 0, 1, '搽剂', NULL, '批准111', NULL, NULL, '', 0.0000, 2, '', '', 1, 1, 1.000, '', 6, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, '009', '2020-11-20 09:00:52', '009', '2020-12-14 18:56:39', '2020-12-10 10:13:54', '009', '');
INSERT INTO `qfyu_commodity` VALUES (39, 'GD0016', '盐杜仲', '盐杜仲', '', '', '', 'YDZ', '啊啊啊', '', '', '', 103, NULL, 34, 0, 25, NULL, NULL, '', '石药集团欧意药业有限公司', '', '千克', '包', 0, 2, '搽剂', NULL, '批准文号77', NULL, NULL, '', 0.0000, 3, '', '', 1, 1, 1.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:45', '2020-12-22 11:29:38', '009', '');
INSERT INTO `qfyu_commodity` VALUES (40, 'GD0017', '商品名称', '通用名称', '英文名称', '条形码', '附件名', 'TYMC', '规格', '', '监管码', '彩页码', 13, NULL, 37, 0, 26, 5, NULL, '', '111', '', '盒', '包', 0, 2, '搽剂', NULL, '11', NULL, NULL, '', 0.0000, 4, '', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-20 14:35:11', NULL, NULL, '2020-12-10 10:14:07', '009', '');
INSERT INTO `qfyu_commodity` VALUES (41, 'GD0018', '111', '111', '', '', '', '111', '111', '', '', '', NULL, NULL, 36, 0, 26, NULL, NULL, '', '111', '', '盒', NULL, 0, 1, '搽剂', NULL, '111', NULL, NULL, '', 0.0000, 5, '', '', 1, 1, 1.000, '', NULL, '', '', '', 0.0000, 0.0000, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-20 14:40:07', NULL, NULL, '2020-12-10 10:14:14', '009', '');
INSERT INTO `qfyu_commodity` VALUES (42, 'GD0019', '111', '111', '', '', '', '111', '1111', '', '', '', NULL, NULL, 36, 0, 26, NULL, NULL, '', '111', '', '盒', '', 0, 12, '混悬剂', NULL, '111', NULL, 1, '年', 0.0000, 6, '', '', 1, 1, 1.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-11-20 14:44:34', NULL, NULL, '2020-12-21 13:54:36', '009', '');
INSERT INTO `qfyu_commodity` VALUES (43, 'GD0020', '商品名称', '商品通用名称', '英文名称', '', '', 'SPTYMC', '规格', '', '', '', 10, 1, 37, 0, 26, NULL, NULL, '产地', '生产企业', '', '支', NULL, 0, NULL, '胶囊剂', NULL, '批准文号/注册证号', '2020-12-05', NULL, '', 0.0000, 1, '本位码', '', 1, 1, 0.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '009', '2020-12-22 11:02:40', NULL, NULL, NULL, NULL, '申请原因');
INSERT INTO `qfyu_commodity` VALUES (44, 'GD0021', '黄芪', '黄芪 500g(统)', 'Astragalus membranaceus', '', '', 'HQ 500g_T_', '500g(统)', '', '', '', 103, NULL, 37, 0, 26, NULL, NULL, '惠州市', '惠州市泛生中药饮片有限公司', '', '支', '千克', 1, 2, '片剂', NULL, '200701', '2020-12-05', NULL, '', 0.0000, 1, '1006093', '', 2, 4, 0.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-12-22 11:15:07', '009', '2020-12-22 11:15:17', NULL, NULL, '申请原因');
INSERT INTO `qfyu_commodity` VALUES (45, 'FG0014', 'J 爱丽丝避孕套（大油量）特价 10只', 'J 爱丽丝避孕套（大油量）特价 10只', 'J Alice condom (large amount of oil) 10 on sale', '', '', 'J ALSBYT_DYL_TJ 10Z', '10只', '', '', '', NULL, NULL, 31, NULL, 0, NULL, NULL, '湛江', '广东省湛江市汇通药业有限公司', '', '支', '只', 0, 2, '胶囊剂', 13.00, '粤食药监械生产许20030837', '2020-12-31', NULL, '', 0.0000, 6, '', '', 1, 1, 0.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-12-22 11:22:24', '009', '2020-12-22 11:22:44', NULL, NULL, '申请原因');
INSERT INTO `qfyu_commodity` VALUES (46, 'GD0022', '格列美脲分散片(林美欣） P 2.0mg*12片', '格列美脲分散片(林美欣） P 2.0mg*12片', '', '', '', 'GLMNFSP_LMX_ P 2_0mg_12P', '2.0mg*12片', '', '', '', 107, NULL, 41, 0, 26, NULL, NULL, '', '石药集团欧意药业有限公司', '', '盒', '片', 0, 2, '片剂', NULL, '国药准字H20100182', NULL, NULL, '', NULL, 2, '6916119070862', '', 0, 0, 0.000, '', NULL, '', '', '', NULL, NULL, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, '009', '2020-12-22 11:27:57', '009', '2020-12-22 11:28:02', NULL, NULL, '');

-- ----------------------------
-- Table structure for qfyu_commodity_batch_discount
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_batch_discount`;
CREATE TABLE `qfyu_commodity_batch_discount`  (
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `max_qty` decimal(16, 5) NOT NULL COMMENT '最大批量',
  `min_qty` decimal(16, 5) NOT NULL COMMENT '最小批量',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `discount` decimal(6, 2) NOT NULL COMMENT '折扣%',
  `price` decimal(16, 6) NULL DEFAULT NULL,
  `retail_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '零售有效 默认0 无效 1有效',
  `update_date` datetime(0) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品批量折扣表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_batch_discount
-- ----------------------------
INSERT INTO `qfyu_commodity_batch_discount` VALUES ('FG005', 111.00000, 111.00000, '袋', 10.00, 0.000000, 1, '2020-12-21 18:00:55');

-- ----------------------------
-- Table structure for qfyu_commodity_buyer
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_buyer`;
CREATE TABLE `qfyu_commodity_buyer`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关联商品基本信息表商品编号',
  `buyer_type` tinyint(1) NULL DEFAULT 0 COMMENT '采购方式 默认0购销 1代销',
  `is_new` tinyint(1) NULL DEFAULT 0 COMMENT '新产品 默认0否 1是',
  `is_buyer` tinyint(1) NULL DEFAULT 0 COMMENT '暂停采购 默认0不暂停 1暂停',
  `supplier` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主要供应商',
  `amount` int(11) NULL DEFAULT NULL COMMENT '最小采购量',
  `buyer_id` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购负责人',
  `buyer_day` int(10) NULL DEFAULT NULL COMMENT '采购提前N天',
  `buyer_cycle` int(10) NULL DEFAULT NULL COMMENT '采购周期',
  `buyer_multiple` int(10) NULL DEFAULT NULL COMMENT '采购倍数',
  `creater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creater_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品采购相关表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_buyer
-- ----------------------------
INSERT INTO `qfyu_commodity_buyer` VALUES (5, 'FG001', 0, 1, 1, 'FS002', 500, '001', 90, 365, NULL, '009', '2020-11-05 17:35:26', '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_buyer` VALUES (18, 'FG002', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_buyer` VALUES (19, 'FG003', 0, 1, 0, 'FS002', 500, '009', 90, 90, 1, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_buyer` VALUES (20, 'FG004', 0, 1, 0, '', NULL, '011', NULL, NULL, NULL, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_buyer` VALUES (21, 'FG0011', 0, 1, 0, '', NULL, '002', 180, 365, NULL, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_buyer` VALUES (22, 'FG0010', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_buyer` VALUES (23, 'FG008', 0, 0, 0, 'FS002', NULL, '005', NULL, NULL, NULL, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_buyer` VALUES (24, 'FG0012', 0, 0, 0, 'FS002', NULL, '004', NULL, NULL, NULL, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_buyer` VALUES (25, 'FG006', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_buyer` VALUES (26, 'FG009', 0, 1, 0, 'FS002', 100, '002', 90, 365, 1, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_buyer` VALUES (32, 'GD0014', 0, 0, 0, 'FS002', NULL, '005', NULL, NULL, NULL, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_buyer` VALUES (33, 'FG005', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_buyer` VALUES (34, 'FG0013', 0, 0, 0, 'FS002', NULL, '005', NULL, NULL, NULL, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_buyer` VALUES (37, 'GD0015', 0, 1, 0, 'FS002', NULL, '006', NULL, NULL, NULL, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_buyer` VALUES (38, 'GD0016', 0, 1, 0, 'FS002', 300, '004', 90, 90, NULL, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_buyer` VALUES (39, 'GD0017', 0, 0, 0, 'FS003', NULL, '007', NULL, NULL, NULL, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_buyer` VALUES (40, 'GD0018', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_buyer` VALUES (41, 'GD0019', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_buyer` VALUES (42, 'GD0020', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_buyer` VALUES (43, 'GD0021', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_buyer` VALUES (44, 'FG0014', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_buyer` VALUES (45, 'GD0022', 0, 0, 0, '', NULL, '', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_category
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_category`;
CREATE TABLE `qfyu_commodity_category`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品大类名称',
  `sort` int(10) NOT NULL DEFAULT 100 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品大类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_category
-- ----------------------------
INSERT INTO `qfyu_commodity_category` VALUES (1, 'OTC补益类', 100);
INSERT INTO `qfyu_commodity_category` VALUES (2, 'OTC儿科用药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (3, 'OTC妇科外用', 100);
INSERT INTO `qfyu_commodity_category` VALUES (4, 'OTC妇科用药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (5, 'OTC肝胆类', 100);
INSERT INTO `qfyu_commodity_category` VALUES (6, 'OTC感冒用药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (7, 'OTC骨伤科口服', 100);
INSERT INTO `qfyu_commodity_category` VALUES (8, 'OTC骨伤科外用', 100);
INSERT INTO `qfyu_commodity_category` VALUES (9, 'OTC解热镇痛', 100);
INSERT INTO `qfyu_commodity_category` VALUES (10, 'OTC抗过敏及激素类', 100);
INSERT INTO `qfyu_commodity_category` VALUES (11, 'OTC泌尿系统类', 100);
INSERT INTO `qfyu_commodity_category` VALUES (12, 'OTC皮肤科外用药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (13, 'OTC皮肤科用药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (14, 'OTC清热解毒类', 100);
INSERT INTO `qfyu_commodity_category` VALUES (15, 'OTC维生素及矿物质', 100);
INSERT INTO `qfyu_commodity_category` VALUES (16, 'OTC五官科口服药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (17, 'OTC五官科外用药', 100);
INSERT INTO `qfyu_commodity_category` VALUES (18, 'OTC消化系统类', 100);
INSERT INTO `qfyu_commodity_category` VALUES (19, 'OTC心脑血管类', 100);

-- ----------------------------
-- Table structure for qfyu_commodity_drug_reports
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_drug_reports`;
CREATE TABLE `qfyu_commodity_drug_reports`  (
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '生产批号',
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `file_a` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '证照A面 名称规则：商品编号_供应商编号_A.jpg/png',
  `file_b` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '证照B面 名称规则：商品编号_供应商编号_B.jpg/png',
  `update_date` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`goods_code`, `batch`, `supplier_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品药检报告' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_drug_reports
-- ----------------------------
INSERT INTO `qfyu_commodity_drug_reports` VALUES ('FG001', '', 'FS003', 'FG001__FS003_A.jpg', 'FG001__FS003_B.jpg', '2020-12-24 10:47:00');
INSERT INTO `qfyu_commodity_drug_reports` VALUES ('FG001', '20201223', 'FS003', 'FG001_20201223_FS003_A.jpg', 'FG001_20201223_FS003_B.jpg', '2020-12-24 10:45:01');
INSERT INTO `qfyu_commodity_drug_reports` VALUES ('FG001', '20201224', 'FS003', 'FG001_20201224_FS003_A.jpg', NULL, NULL);
INSERT INTO `qfyu_commodity_drug_reports` VALUES ('FG002', '20201224', 'FS003', 'FG002_20201224_FS003_A.jpg', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_extend
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_extend`;
CREATE TABLE `qfyu_commodity_extend`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关联商品基础信息表商品编号',
  `abc` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'abc分类',
  `abkind` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '毛利率分类',
  `quality_standards` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量标准',
  `quality_date` date NULL DEFAULT NULL COMMENT '质量标准有效期',
  `exterior` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '外观质量',
  `brand` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商标',
  `brand_date` datetime(0) NULL DEFAULT NULL COMMENT '商标有效期',
  `level` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '等级',
  `gmp_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP证书号',
  `gmp_property` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP属性',
  `gmp_end_date` date NULL DEFAULT NULL COMMENT 'GMP有效期',
  `license_key` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产许可证号',
  `license_date` date NULL DEFAULT NULL COMMENT '生产许可证号有效期',
  `code1` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义证书编号1',
  `code1_date` date NULL DEFAULT NULL COMMENT '自定义证书编号1有效期',
  `code2` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义证书编号2',
  `code2_date` date NULL DEFAULT NULL COMMENT '自定义证书编号2有效期',
  `custom_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义分类',
  `custom_val` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义数值',
  `custom_code1` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义匹配码一',
  `custom_code2` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义匹配码二',
  `custom_code3` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义匹配码三',
  `start_give_amount` decimal(16, 5) NULL DEFAULT NULL COMMENT '起赠数量',
  `give_amount` decimal(16, 5) NULL DEFAULT NULL COMMENT '赠送数量',
  `times_give` tinyint(1) NULL DEFAULT 0 COMMENT '倍量计赠 默认0不计赠 1计赠',
  `give_date` datetime(0) NULL DEFAULT NULL COMMENT '截至日期',
  `integral` int(11) NULL DEFAULT NULL COMMENT '积分倍率',
  `creater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creater_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品扩展资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_extend
-- ----------------------------
INSERT INTO `qfyu_commodity_extend` VALUES (6, 'FG001', 'A', 'A', '合格', '2020-11-02', '外观质量', '注册商标', '2020-11-02 00:00:00', '一级品', 'GMP证书编号', 'GMP属性', NULL, '441300000016035', '2022-10-22', '', '2020-11-02', '', '2020-11-02', '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-05 17:35:26', '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_extend` VALUES (19, 'FG002', 'A', 'A', '合格', NULL, '', '', NULL, '合格品', 'Z20055041', '', '2022-10-23', '77330303', '2022-10-23', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_extend` VALUES (20, 'FG003', NULL, NULL, '合格', '2020-11-06', '合格', '商标', '2020-11-06 00:00:00', NULL, 'B12002011692', 'GMP属性', '2020-10-24', '73637362-7', '2020-11-06', '自定义证书1', '2020-11-06', '自定义证书2', '2020-11-06', '自定义分类11', '自定义数值11', '匹配码1', '匹配码2', '匹配码3', 500.00000, 10.00000, 0, NULL, 10, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_extend` VALUES (21, 'FG004', '1', '2', '1111', NULL, '', '', NULL, '', '12345678', '', '2020-10-27', '654789321', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_extend` VALUES (22, 'FG0011', '', '', '合格', NULL, '', '', NULL, '', 'GMP6548972', '', '2020-11-11', 'XKZ654123', '2020-11-11', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_extend` VALUES (23, 'FG0010', '', '1', '312', NULL, '', '', NULL, '1', 'GMP123654789', '', '2020-10-30', '6926378910021', '2020-11-30', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_extend` VALUES (24, 'FG008', 'A', 'A', '11', NULL, '', '', NULL, '一级品', '3123123', '', '2020-10-28', '213412', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_extend` VALUES (25, 'FG0012', '', '', '非常棒', NULL, '', '', NULL, '', 'GMP456987', '', '2020-11-30', '6926285816027', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_extend` VALUES (26, 'FG006', '', '', '测试3', NULL, '', '', NULL, '', '测试3', '', '2020-10-26', '测试3', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_extend` VALUES (27, 'FG009', '', '', '质量标准66', NULL, '', '', NULL, '', '123', '', '2020-10-28', '3123', '2021-05-05', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, '2020-12-21 00:00:00', NULL, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_extend` VALUES (33, 'GD0014', '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_extend` VALUES (34, 'FG005', '', '', '111', NULL, '', '', NULL, '', '11', '', '2020-10-29', '1', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_extend` VALUES (35, 'FG0013', '', '', '合格', NULL, '', '', NULL, '', 'GMP10257575', '', '2020-11-17', 'X10252527557', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_extend` VALUES (38, 'GD0015', '', '1', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_extend` VALUES (39, 'GD0016', '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_extend` VALUES (40, 'GD0017', '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_extend` VALUES (41, 'GD0018', '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_extend` VALUES (42, 'GD0019', '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_extend` VALUES (43, 'GD0020', '', '', '质量标准', NULL, '', '', NULL, '', 'GMP证书号', '', '2020-12-12', '许可证号', '2020-12-05', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_extend` VALUES (44, 'GD0021', '', '', '质量标准', NULL, '', '', NULL, '', 'GMP证书号', '', '2020-12-12', '许可证号', '2020-12-05', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_extend` VALUES (45, 'FG0014', '', '', '合格', NULL, '', '', NULL, '', 'GMP证书号', '', '2020-12-12', '许可证号', '2020-12-05', '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_extend` VALUES (46, 'GD0022', '', '', '', NULL, '', '', NULL, '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', '', '', '', '', NULL, NULL, 0, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_function
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_function`;
CREATE TABLE `qfyu_commodity_function`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增编码',
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `parent_id` int(11) NOT NULL COMMENT '上级id',
  `level` tinyint(1) NOT NULL COMMENT '分类级别',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效 默认1有效 0无效',
  `sort` int(10) NOT NULL DEFAULT 100 COMMENT '排序',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品功能类别表（系统内部使用）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_function
-- ----------------------------
INSERT INTO `qfyu_commodity_function` VALUES (25, '中成药', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (26, '西药', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (27, '中药饮片', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (28, '医疗器械', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (29, '进口药品', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (30, '保健品', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (31, '非药品', 0, 1, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (32, '五官用药', 25, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (33, '消化系统', 25, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (34, '清热消炎', 25, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (35, '心血管药', 25, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (36, '激素类', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (37, '泌尿系统', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (38, '抗感染药', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (39, '骨科用药', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (40, '止咳祛痰', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (41, '神经系统用药', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (42, '肝胆用药', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (43, '消炎镇痛', 26, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (44, '医用设备', 28, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (45, '其他器械', 28, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (46, '进口中成药', 29, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (47, '进口西药', 29, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (48, '清补凉系列', 27, 2, 1, 100, '');
INSERT INTO `qfyu_commodity_function` VALUES (49, '眼科用药', 32, 3, 1, 100, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_price
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_price`;
CREATE TABLE `qfyu_commodity_price`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `mode_id` int(10) NOT NULL COMMENT '价格体系代码',
  `mode_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '体系名称',
  `price` decimal(12, 5) NULL DEFAULT NULL COMMENT '单价',
  `price1` decimal(12, 5) NULL DEFAULT NULL COMMENT '主单位价格',
  `price2` decimal(12, 5) NULL DEFAULT NULL COMMENT '辅单位价格',
  `creater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creater_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `goods_code`(`goods_code`, `mode_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 799 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品价格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_price
-- ----------------------------
INSERT INTO `qfyu_commodity_price` VALUES (1, 'FG001', 1, '标准进价', NULL, 5.00000, 5.00000, NULL, NULL, '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_price` VALUES (2, 'FG001', 2, '标准批发价', NULL, 6.00000, 6.66600, NULL, NULL, '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_price` VALUES (3, 'FG001', 3, '标准零售价', NULL, 7.00000, 7.00000, NULL, NULL, '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_price` VALUES (4, 'FG001', 4, '最低进价', NULL, 1.00000, 0.00000, NULL, NULL, '009', '2020-12-18 16:50:20');
INSERT INTO `qfyu_commodity_price` VALUES (5, 'FG001', 5, '最高进价', NULL, 10.00000, 0.00000, NULL, NULL, '009', '2020-12-18 16:50:33');
INSERT INTO `qfyu_commodity_price` VALUES (6, 'FG001', 6, '最低批发价', NULL, 0.00000, 1.10000, NULL, NULL, '009', '2020-12-18 16:50:43');
INSERT INTO `qfyu_commodity_price` VALUES (7, 'FG001', 7, '最高批发价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (8, 'FG001', 8, '系统最近进价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (9, 'FG001', 9, '系统最初进价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (10, 'FG001', 10, '系统最高进价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (11, 'FG001', 11, '系统最低进价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (12, 'FG001', 12, '系统最近售价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (13, 'FG001', 13, '系统最初售价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (14, 'FG001', 14, '系统最高售价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (15, 'FG001', 15, '系统最低售价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (16, 'FG001', 16, '系统最低价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (17, 'FG001', 17, '系统最高价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (18, 'FG001', 18, '采购价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (19, 'FG001', 20, '批发价', NULL, 0.00000, 0.00000, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (267, 'FG002', 1, '标准进价', NULL, 7.00000, NULL, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_price` VALUES (268, 'FG002', 2, '标准批发价', NULL, 9.00000, 9.00000, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_price` VALUES (269, 'FG002', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_price` VALUES (270, 'FG002', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (271, 'FG002', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (272, 'FG002', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (273, 'FG002', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (274, 'FG002', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (275, 'FG002', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (276, 'FG002', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (277, 'FG002', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (278, 'FG002', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (279, 'FG002', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (280, 'FG002', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (281, 'FG002', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (282, 'FG002', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (283, 'FG002', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (284, 'FG002', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (285, 'FG002', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:17:01', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (286, 'FG003', 1, '标准进价', NULL, 3.00000, 6.30000, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_price` VALUES (287, 'FG003', 2, '标准批发价', NULL, 5.10000, 5.00000, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_price` VALUES (288, 'FG003', 3, '标准零售价', NULL, 3.00000, 5.10000, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_price` VALUES (289, 'FG003', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (290, 'FG003', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (291, 'FG003', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (292, 'FG003', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (293, 'FG003', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (294, 'FG003', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (295, 'FG003', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (296, 'FG003', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (297, 'FG003', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (298, 'FG003', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (299, 'FG003', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (300, 'FG003', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (301, 'FG003', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (302, 'FG003', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (303, 'FG003', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (304, 'FG003', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-06 11:46:08', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (305, 'FG004', 1, '标准进价', NULL, 10.00000, 11.00000, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_price` VALUES (306, 'FG004', 2, '标准批发价', NULL, 5.00000, 21.00000, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_price` VALUES (307, 'FG004', 3, '标准零售价', NULL, 11.00000, 25.00000, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_price` VALUES (308, 'FG004', 4, '最低进价', NULL, 21.00000, 0.00000, '009', '2020-11-09 08:52:21', '009', '2020-12-01 17:01:37');
INSERT INTO `qfyu_commodity_price` VALUES (309, 'FG004', 5, '最高进价', NULL, 25.00000, 0.00000, '009', '2020-11-09 08:52:21', '009', '2020-12-01 17:01:48');
INSERT INTO `qfyu_commodity_price` VALUES (310, 'FG004', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (311, 'FG004', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (312, 'FG004', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (313, 'FG004', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (314, 'FG004', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (315, 'FG004', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (316, 'FG004', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (317, 'FG004', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (318, 'FG004', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (319, 'FG004', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (320, 'FG004', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (321, 'FG004', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (322, 'FG004', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (323, 'FG004', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-09 08:52:21', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (324, 'FG0011', 1, '标准进价', NULL, 3.24000, NULL, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_price` VALUES (325, 'FG0011', 2, '标准批发价', NULL, NULL, 5.15000, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_price` VALUES (326, 'FG0011', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_price` VALUES (327, 'FG0011', 4, '最低进价', NULL, 3.24000, 0.00000, '009', '2020-11-10 17:56:15', '009', '2020-12-01 17:02:13');
INSERT INTO `qfyu_commodity_price` VALUES (328, 'FG0011', 5, '最高进价', NULL, 3.24000, 0.00000, '009', '2020-11-10 17:56:15', '009', '2020-12-01 17:02:23');
INSERT INTO `qfyu_commodity_price` VALUES (329, 'FG0011', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (330, 'FG0011', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (331, 'FG0011', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (332, 'FG0011', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (333, 'FG0011', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (334, 'FG0011', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (335, 'FG0011', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (336, 'FG0011', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (337, 'FG0011', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (338, 'FG0011', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (339, 'FG0011', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (340, 'FG0011', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (341, 'FG0011', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (342, 'FG0011', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:56:15', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (343, 'FG0010', 1, '标准进价', NULL, 3.90000, NULL, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_price` VALUES (344, 'FG0010', 2, '标准批发价', NULL, NULL, 4.20000, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_price` VALUES (345, 'FG0010', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_price` VALUES (346, 'FG0010', 4, '最低进价', NULL, 3.90000, 0.00000, '009', '2020-11-10 17:58:55', '009', '2020-12-01 17:02:38');
INSERT INTO `qfyu_commodity_price` VALUES (347, 'FG0010', 5, '最高进价', NULL, 3.90000, 0.00000, '009', '2020-11-10 17:58:55', '009', '2020-12-01 17:02:49');
INSERT INTO `qfyu_commodity_price` VALUES (348, 'FG0010', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (349, 'FG0010', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (350, 'FG0010', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (351, 'FG0010', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (352, 'FG0010', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (353, 'FG0010', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (354, 'FG0010', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (355, 'FG0010', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (356, 'FG0010', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (357, 'FG0010', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (358, 'FG0010', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (359, 'FG0010', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (360, 'FG0010', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (361, 'FG0010', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-10 17:58:55', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (362, 'FG008', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_price` VALUES (363, 'FG008', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_price` VALUES (364, 'FG008', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_price` VALUES (365, 'FG008', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (366, 'FG008', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (367, 'FG008', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (368, 'FG008', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (369, 'FG008', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (370, 'FG008', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (371, 'FG008', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (372, 'FG008', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (373, 'FG008', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (374, 'FG008', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (375, 'FG008', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (376, 'FG008', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (377, 'FG008', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (378, 'FG008', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (379, 'FG008', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (380, 'FG008', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:00', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (381, 'FG0012', 1, '标准进价', NULL, 9.00000, NULL, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_price` VALUES (382, 'FG0012', 2, '标准批发价', NULL, NULL, 9.60000, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_price` VALUES (383, 'FG0012', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_price` VALUES (384, 'FG0012', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (385, 'FG0012', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (386, 'FG0012', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (387, 'FG0012', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (388, 'FG0012', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (389, 'FG0012', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (390, 'FG0012', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (391, 'FG0012', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (392, 'FG0012', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (393, 'FG0012', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (394, 'FG0012', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (395, 'FG0012', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (396, 'FG0012', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (397, 'FG0012', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (398, 'FG0012', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (399, 'FG0012', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:09', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (400, 'FG006', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_price` VALUES (401, 'FG006', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_price` VALUES (402, 'FG006', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_price` VALUES (403, 'FG006', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (404, 'FG006', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (405, 'FG006', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (406, 'FG006', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (407, 'FG006', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (408, 'FG006', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (409, 'FG006', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (410, 'FG006', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (411, 'FG006', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (412, 'FG006', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (413, 'FG006', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (414, 'FG006', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (415, 'FG006', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (416, 'FG006', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (417, 'FG006', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (418, 'FG006', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:31', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (419, 'FG009', 1, '标准进价', NULL, 13.00000, NULL, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_price` VALUES (420, 'FG009', 2, '标准批发价', NULL, NULL, 13.00000, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_price` VALUES (421, 'FG009', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_price` VALUES (422, 'FG009', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (423, 'FG009', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (424, 'FG009', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (425, 'FG009', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (426, 'FG009', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (427, 'FG009', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (428, 'FG009', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (429, 'FG009', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (430, 'FG009', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (431, 'FG009', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (432, 'FG009', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (433, 'FG009', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (434, 'FG009', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (435, 'FG009', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (436, 'FG009', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (437, 'FG009', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 08:56:44', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (533, 'GD0014', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_price` VALUES (534, 'GD0014', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_price` VALUES (535, 'GD0014', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_price` VALUES (536, 'GD0014', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (537, 'GD0014', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (538, 'GD0014', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (539, 'GD0014', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (540, 'GD0014', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (541, 'GD0014', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (542, 'GD0014', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (543, 'GD0014', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (544, 'GD0014', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (545, 'GD0014', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (546, 'GD0014', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (547, 'GD0014', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (548, 'GD0014', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (549, 'GD0014', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (550, 'GD0014', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (551, 'GD0014', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-11 10:36:23', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (552, 'FG005', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_price` VALUES (553, 'FG005', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_price` VALUES (554, 'FG005', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_price` VALUES (555, 'FG005', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (556, 'FG005', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (557, 'FG005', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (558, 'FG005', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (559, 'FG005', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (560, 'FG005', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (561, 'FG005', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (562, 'FG005', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (563, 'FG005', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (564, 'FG005', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (565, 'FG005', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (566, 'FG005', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (567, 'FG005', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (568, 'FG005', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (569, 'FG005', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (570, 'FG005', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-19 16:40:25', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (571, 'FG0013', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_price` VALUES (572, 'FG0013', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_price` VALUES (573, 'FG0013', 3, '标准零售价', NULL, 18.00000, NULL, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_price` VALUES (574, 'FG0013', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (575, 'FG0013', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (576, 'FG0013', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (577, 'FG0013', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (578, 'FG0013', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (579, 'FG0013', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (580, 'FG0013', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (581, 'FG0013', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (582, 'FG0013', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (583, 'FG0013', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (584, 'FG0013', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (585, 'FG0013', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (586, 'FG0013', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (587, 'FG0013', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (588, 'FG0013', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (589, 'FG0013', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-19 18:35:32', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (628, 'GD0015', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_price` VALUES (629, 'GD0015', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_price` VALUES (630, 'GD0015', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_price` VALUES (631, 'GD0015', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (632, 'GD0015', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (633, 'GD0015', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (634, 'GD0015', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (635, 'GD0015', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (636, 'GD0015', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (637, 'GD0015', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (638, 'GD0015', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (639, 'GD0015', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (640, 'GD0015', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (641, 'GD0015', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (642, 'GD0015', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (643, 'GD0015', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (644, 'GD0015', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (645, 'GD0015', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (646, 'GD0015', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 09:00:52', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (647, 'GD0016', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_price` VALUES (648, 'GD0016', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_price` VALUES (649, 'GD0016', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_price` VALUES (650, 'GD0016', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (651, 'GD0016', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (652, 'GD0016', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (653, 'GD0016', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (654, 'GD0016', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (655, 'GD0016', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (656, 'GD0016', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (657, 'GD0016', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (658, 'GD0016', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (659, 'GD0016', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (660, 'GD0016', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (661, 'GD0016', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (662, 'GD0016', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (663, 'GD0016', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (664, 'GD0016', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (665, 'GD0016', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 10:28:30', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (666, 'GD0017', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_price` VALUES (667, 'GD0017', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_price` VALUES (668, 'GD0017', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_price` VALUES (669, 'GD0017', 4, '最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (670, 'GD0017', 5, '最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (671, 'GD0017', 6, '最低批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (672, 'GD0017', 7, '最高批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (673, 'GD0017', 8, '系统最近进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (674, 'GD0017', 9, '系统最初进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (675, 'GD0017', 10, '系统最高进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (676, 'GD0017', 11, '系统最低进价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (677, 'GD0017', 12, '系统最近售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (678, 'GD0017', 13, '系统最初售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (679, 'GD0017', 14, '系统最高售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (680, 'GD0017', 15, '系统最低售价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (681, 'GD0017', 16, '系统最低价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (682, 'GD0017', 17, '系统最高价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (683, 'GD0017', 18, '采购价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (684, 'GD0017', 20, '批发价', NULL, 0.00000, 0.00000, '009', '2020-11-20 14:35:11', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (685, 'GD0018', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_price` VALUES (686, 'GD0018', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_price` VALUES (687, 'GD0018', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_price` VALUES (688, 'GD0018', 4, '最低进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (689, 'GD0018', 5, '最高进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (690, 'GD0018', 6, '最低批发价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (691, 'GD0018', 7, '最高批发价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (692, 'GD0018', 8, '系统最近进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (693, 'GD0018', 9, '系统最初进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (694, 'GD0018', 10, '系统最高进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (695, 'GD0018', 11, '系统最低进价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (696, 'GD0018', 12, '系统最近售价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (697, 'GD0018', 13, '系统最初售价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (698, 'GD0018', 14, '系统最高售价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (699, 'GD0018', 15, '系统最低售价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (700, 'GD0018', 16, '系统最低价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (701, 'GD0018', 17, '系统最高价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (702, 'GD0018', 18, '采购价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (703, 'GD0018', 20, '批发价', NULL, NULL, NULL, '009', '2020-11-20 14:40:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (704, 'GD0019', 1, '标准进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_price` VALUES (705, 'GD0019', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_price` VALUES (706, 'GD0019', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_price` VALUES (707, 'GD0019', 4, '最低进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (708, 'GD0019', 5, '最高进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (709, 'GD0019', 6, '最低批发价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (710, 'GD0019', 7, '最高批发价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (711, 'GD0019', 8, '系统最近进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (712, 'GD0019', 9, '系统最初进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (713, 'GD0019', 10, '系统最高进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (714, 'GD0019', 11, '系统最低进价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (715, 'GD0019', 12, '系统最近售价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (716, 'GD0019', 13, '系统最初售价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (717, 'GD0019', 14, '系统最高售价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', '001', '2020-11-21 09:48:02');
INSERT INTO `qfyu_commodity_price` VALUES (718, 'GD0019', 15, '系统最低售价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (719, 'GD0019', 16, '系统最低价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (720, 'GD0019', 17, '系统最高价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (721, 'GD0019', 18, '采购价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (722, 'GD0019', 20, '批发价', NULL, NULL, NULL, '009', '2020-11-20 14:44:34', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (723, 'GD0020', 1, '标准进价', NULL, 2.00000, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (724, 'GD0020', 2, '标准批发价', NULL, 3.00000, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (725, 'GD0020', 3, '标准零售价', NULL, 4.00000, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (726, 'GD0020', 4, '最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (727, 'GD0020', 5, '最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (728, 'GD0020', 6, '最低批发价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (729, 'GD0020', 7, '最高批发价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (730, 'GD0020', 8, '系统最近进价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (731, 'GD0020', 9, '系统最初进价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (732, 'GD0020', 10, '系统最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (733, 'GD0020', 11, '系统最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (734, 'GD0020', 12, '系统最近售价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (735, 'GD0020', 13, '系统最初售价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (736, 'GD0020', 14, '系统最高售价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (737, 'GD0020', 15, '系统最低售价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (738, 'GD0020', 16, '系统最低价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (739, 'GD0020', 17, '系统最高价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (740, 'GD0020', 18, '采购价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (741, 'GD0020', 20, '批发价', NULL, NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (742, 'GD0021', 1, '标准进价', NULL, 2.00000, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (743, 'GD0021', 2, '标准批发价', NULL, 3.00000, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (744, 'GD0021', 3, '标准零售价', NULL, 4.00000, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (745, 'GD0021', 4, '最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (746, 'GD0021', 5, '最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (747, 'GD0021', 6, '最低批发价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (748, 'GD0021', 7, '最高批发价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (749, 'GD0021', 8, '系统最近进价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (750, 'GD0021', 9, '系统最初进价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (751, 'GD0021', 10, '系统最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (752, 'GD0021', 11, '系统最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (753, 'GD0021', 12, '系统最近售价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (754, 'GD0021', 13, '系统最初售价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (755, 'GD0021', 14, '系统最高售价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (756, 'GD0021', 15, '系统最低售价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (757, 'GD0021', 16, '系统最低价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (758, 'GD0021', 17, '系统最高价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (759, 'GD0021', 18, '采购价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (760, 'GD0021', 20, '批发价', NULL, NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (761, 'FG0014', 1, '标准进价', NULL, 2.00000, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (762, 'FG0014', 2, '标准批发价', NULL, 3.00000, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (763, 'FG0014', 3, '标准零售价', NULL, 4.00000, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (764, 'FG0014', 4, '最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (765, 'FG0014', 5, '最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (766, 'FG0014', 6, '最低批发价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (767, 'FG0014', 7, '最高批发价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (768, 'FG0014', 8, '系统最近进价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (769, 'FG0014', 9, '系统最初进价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (770, 'FG0014', 10, '系统最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (771, 'FG0014', 11, '系统最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (772, 'FG0014', 12, '系统最近售价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (773, 'FG0014', 13, '系统最初售价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (774, 'FG0014', 14, '系统最高售价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (775, 'FG0014', 15, '系统最低售价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (776, 'FG0014', 16, '系统最低价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (777, 'FG0014', 17, '系统最高价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (778, 'FG0014', 18, '采购价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (779, 'FG0014', 20, '批发价', NULL, NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (780, 'GD0022', 1, '标准进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (781, 'GD0022', 2, '标准批发价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (782, 'GD0022', 3, '标准零售价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (783, 'GD0022', 4, '最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (784, 'GD0022', 5, '最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (785, 'GD0022', 6, '最低批发价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (786, 'GD0022', 7, '最高批发价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (787, 'GD0022', 8, '系统最近进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (788, 'GD0022', 9, '系统最初进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (789, 'GD0022', 10, '系统最高进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (790, 'GD0022', 11, '系统最低进价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (791, 'GD0022', 12, '系统最近售价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (792, 'GD0022', 13, '系统最初售价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (793, 'GD0022', 14, '系统最高售价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (794, 'GD0022', 15, '系统最低售价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (795, 'GD0022', 16, '系统最低价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (796, 'GD0022', 17, '系统最高价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (797, 'GD0022', 18, '采购价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);
INSERT INTO `qfyu_commodity_price` VALUES (798, 'GD0022', 20, '批发价', NULL, NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_price_system
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_price_system`;
CREATE TABLE `qfyu_commodity_price_system`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '体系代码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '体系名称',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效 默认1有效 0无效',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creation_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `reviser` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `reviser_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `depart` int(10) NULL DEFAULT NULL COMMENT '所属部门(部门)',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品价格体系' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_price_system
-- ----------------------------
INSERT INTO `qfyu_commodity_price_system` VALUES (1, '标准进价', 1, '0', '2020-09-18 00:00:00', '001', '2020-12-11 08:42:50', 0, '111');
INSERT INTO `qfyu_commodity_price_system` VALUES (2, '标准批发价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (3, '标准零售价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (4, '最低进价', 1, '0', '2020-09-18 00:00:00', '001', '2020-11-30 18:40:17', 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (5, '最高进价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (6, '最低批发价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (7, '最高批发价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (8, '系统最近进价', 1, '0', '2020-09-18 00:00:00', '009', '2020-12-11 11:16:13', 0, '123123123');
INSERT INTO `qfyu_commodity_price_system` VALUES (9, '系统最初进价', 1, '0', '2020-09-18 00:00:00', '009', '2020-12-11 11:16:04', 0, '11');
INSERT INTO `qfyu_commodity_price_system` VALUES (10, '系统最高进价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (11, '系统最低进价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (12, '系统最近售价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (13, '系统最初售价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (14, '系统最高售价', 1, '0', '2020-09-18 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (15, '系统最低售价', 1, '0', '2020-09-18 00:00:00', '0', NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (16, '系统最低价', 1, '0', '2020-09-19 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (17, '系统最高价', 1, '0', '2020-09-19 00:00:00', NULL, NULL, 0, '');
INSERT INTO `qfyu_commodity_price_system` VALUES (18, '采购价', 1, '009', '2020-10-28 10:46:59', '009', '2020-10-28 10:46:59', 1, '测试11');
INSERT INTO `qfyu_commodity_price_system` VALUES (20, '批发价', 1, '009', '2020-10-28 11:01:53', '009', '2020-10-28 11:01:53', 1, '');

-- ----------------------------
-- Table structure for qfyu_commodity_sale
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_sale`;
CREATE TABLE `qfyu_commodity_sale`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关联商品基本信息表商品编号',
  `salesman` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售业务负责人',
  `wholesale_amount` int(11) NULL DEFAULT NULL COMMENT '批发限量',
  `retail_amount` int(11) NULL DEFAULT NULL COMMENT '零售限量',
  `sala_multiple` int(11) NULL DEFAULT NULL COMMENT '销售倍量',
  `is_sale` tinyint(1) NULL DEFAULT 0 COMMENT '暂停销售 默认0否 1暂停',
  `is_wholesale` tinyint(1) NULL DEFAULT 0 COMMENT '批发特价 默认0否 1特价',
  `is_retail` tinyint(1) NULL DEFAULT 0 COMMENT '零售特价 默认0否 1特价',
  `creater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creater_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品销售相关表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_sale
-- ----------------------------
INSERT INTO `qfyu_commodity_sale` VALUES (5, 'FG001', '003', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-05 17:35:26', '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_sale` VALUES (18, 'FG002', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_sale` VALUES (19, 'FG003', '009', 9999999, 1000000, 9999999, 0, 0, 0, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_sale` VALUES (20, 'FG004', '004', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_sale` VALUES (21, 'FG0011', '001', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_sale` VALUES (22, 'FG0010', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_sale` VALUES (23, 'FG008', '008', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_sale` VALUES (24, 'FG0012', '003', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_sale` VALUES (25, 'FG006', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_sale` VALUES (26, 'FG009', '006', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_sale` VALUES (32, 'GD0014', '005', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_sale` VALUES (33, 'FG005', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_sale` VALUES (34, 'FG0013', '004', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_sale` VALUES (37, 'GD0015', '003', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_sale` VALUES (38, 'GD0016', '005', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_sale` VALUES (39, 'GD0017', '007', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_sale` VALUES (40, 'GD0018', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_sale` VALUES (41, 'GD0019', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_sale` VALUES (42, 'GD0020', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_sale` VALUES (43, 'GD0021', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_sale` VALUES (44, 'FG0014', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_sale` VALUES (45, 'GD0022', '', NULL, NULL, NULL, 0, 0, 0, '009', '2020-12-22 11:27:57', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_sales_area
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_sales_area`;
CREATE TABLE `qfyu_commodity_sales_area`  (
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `area_id` int(10) NOT NULL COMMENT '地区id',
  `amount` int(10) NULL DEFAULT -1 COMMENT '限购数量 -1表示不限制  0禁购  其他：限购制定数值',
  `start_date` datetime(0) NULL DEFAULT NULL COMMENT '限购开始日期',
  `end_date` datetime(0) NULL DEFAULT NULL COMMENT '限购结束日期',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品控销区域' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_sales_area
-- ----------------------------
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG001', 4, -1, NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG001', 10, -1, NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG001', 2, -1, NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG001', 9, -1, '2020-12-18 00:00:00', '2020-12-18 00:00:00', '');
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG006', 1, -1, NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG006', 25, -1, '2020-12-17 00:00:00', NULL, '');
INSERT INTO `qfyu_commodity_sales_area` VALUES ('FG006', 2, 222, '2020-12-17 00:00:00', '2020-12-18 00:00:00', '');

-- ----------------------------
-- Table structure for qfyu_commodity_sales_category
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_sales_category`;
CREATE TABLE `qfyu_commodity_sales_category`  (
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '控销类别名称',
  `amount` int(10) NULL DEFAULT -1 COMMENT '限购数量 -1表示不限制  0禁购  其他：限购制定数值',
  `start_date` datetime(0) NULL DEFAULT NULL COMMENT '限购开始日期',
  `end_date` datetime(0) NULL DEFAULT NULL COMMENT '限购结束日期',
  `update_date` datetime(0) NULL DEFAULT NULL,
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  INDEX `goods_code`(`goods_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品控销类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_sales_category
-- ----------------------------
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG001', '中药饮片限购', -1, '2020-12-16 00:00:00', '2020-12-17 00:00:00', '2020-12-16 11:12:03', '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG001', '特殊药品限购', -1, '2020-12-16 00:00:00', '2020-12-31 00:00:00', NULL, '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG0011', '中药饮片限购', -1, '2020-12-17 00:00:00', '2020-12-17 00:00:00', NULL, '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG0011', '特殊药品限购', -1, NULL, NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG009', '中药饮片限购', -1, '2020-12-16 00:00:00', NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('GD0014', '中药饮片限购', -1, '2020-12-23 00:00:00', NULL, NULL, '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG005', '中药饮片限购', -1, '2020-12-16 00:00:00', NULL, '2020-12-16 11:35:09', '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG008', '特殊药品限购', -1, '2020-12-16 00:00:00', '2020-12-17 00:00:00', '2020-12-16 11:36:09', '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG006', '中药饮片限购', -1, NULL, NULL, '2020-12-17 15:24:58', '');
INSERT INTO `qfyu_commodity_sales_category` VALUES ('FG006', '特殊药品限购', -1, NULL, NULL, NULL, '');

-- ----------------------------
-- Table structure for qfyu_commodity_sell_limit
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_sell_limit`;
CREATE TABLE `qfyu_commodity_sell_limit`  (
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `cust_id` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `limit_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '限定最低售价'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售限制' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_sell_limit
-- ----------------------------
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0001', 3.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0002', 2.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0003', 3.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0004', 4.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0005', 5.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0010', 7.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR006', 3.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR007', 4.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR008', 5.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR009', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG001', 'CR0011', 1.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG003', 'CR0001', 1.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG003', 'CR0002', 2.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0003', 1.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0004', 2.000000);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0001', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0002', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0005', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0010', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR006', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR007', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR008', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR009', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0011', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0012', NULL);
INSERT INTO `qfyu_commodity_sell_limit` VALUES ('FG005', 'CR0013', NULL);

-- ----------------------------
-- Table structure for qfyu_commodity_ware
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_ware`;
CREATE TABLE `qfyu_commodity_ware`  (
  `goods_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编码',
  `ware_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编码',
  `pos_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '库位编码',
  `max_num` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '最大存量',
  `min_num` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '最小存量',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  PRIMARY KEY (`goods_code`, `ware_code`, `pos_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品-存放库位管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_ware
-- ----------------------------
INSERT INTO `qfyu_commodity_ware` VALUES ('FG001', 'CK004', 'WP0010', 0, 0, '兴国县');
INSERT INTO `qfyu_commodity_ware` VALUES ('FG009', 'CK003', 'WP0011', 0, 0, '');
INSERT INTO `qfyu_commodity_ware` VALUES ('FG009', 'CK004', 'WP0010', 0, 0, '兴国县');

-- ----------------------------
-- Table structure for qfyu_commodity_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_commodity_warehouse`;
CREATE TABLE `qfyu_commodity_warehouse`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `goods_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关联商品基本信息表商品编号',
  `day` int(11) NULL DEFAULT NULL COMMENT '保质期提前报警(单位:天)',
  `tend_type` tinyint(1) NULL DEFAULT NULL COMMENT '养护方式',
  `tend_day` int(11) NULL DEFAULT NULL COMMENT '养护天数（单位：天）',
  `storage_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '储存条件',
  `max_qty` decimal(15, 4) NULL DEFAULT NULL COMMENT '总库存最高',
  `min_qty` decimal(15, 4) NULL DEFAULT NULL COMMENT '总库存最低',
  `creater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creater_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品仓库相关信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_commodity_warehouse
-- ----------------------------
INSERT INTO `qfyu_commodity_warehouse` VALUES (5, 'FG001', 90, 1, 365, '常温储存', NULL, NULL, '009', '2020-11-05 17:35:26', '001', '2020-12-21 08:54:00');
INSERT INTO `qfyu_commodity_warehouse` VALUES (18, 'FG002', NULL, 1, NULL, '常温储存', NULL, NULL, '009', '2020-11-06 11:17:01', '001', '2020-12-22 15:58:34');
INSERT INTO `qfyu_commodity_warehouse` VALUES (19, 'FG003', 180, 1, 180, '常温储存', 999999.0000, 1.0000, '009', '2020-11-06 11:46:08', '009', '2020-12-10 10:06:29');
INSERT INTO `qfyu_commodity_warehouse` VALUES (20, 'FG004', NULL, 1, 90, '阴凉储存', NULL, NULL, '009', '2020-11-09 08:52:21', '009', '2020-12-10 10:06:55');
INSERT INTO `qfyu_commodity_warehouse` VALUES (21, 'FG0011', NULL, 1, NULL, '常温储存', NULL, NULL, '009', '2020-11-10 17:56:15', '009', '2020-12-10 10:07:21');
INSERT INTO `qfyu_commodity_warehouse` VALUES (22, 'FG0010', NULL, 1, NULL, '阴凉储存', NULL, NULL, '009', '2020-11-10 17:58:55', '009', '2020-12-10 10:07:32');
INSERT INTO `qfyu_commodity_warehouse` VALUES (23, 'FG008', NULL, 1, NULL, '常温储存', NULL, NULL, '009', '2020-11-11 08:56:00', '009', '2020-12-10 10:01:00');
INSERT INTO `qfyu_commodity_warehouse` VALUES (24, 'FG0012', NULL, 1, NULL, '常温储存', NULL, NULL, '009', '2020-11-11 08:56:09', '009', '2020-12-10 10:11:18');
INSERT INTO `qfyu_commodity_warehouse` VALUES (25, 'FG006', NULL, 2, NULL, '常温储存', NULL, NULL, '009', '2020-11-11 08:56:31', '009', '2020-12-21 11:05:22');
INSERT INTO `qfyu_commodity_warehouse` VALUES (26, 'FG009', 180, 1, 180, '阴凉储存', NULL, NULL, '009', '2020-11-11 08:56:44', '009', '2020-12-21 14:13:16');
INSERT INTO `qfyu_commodity_warehouse` VALUES (32, 'GD0014', NULL, 2, NULL, '常温储存', NULL, NULL, '009', '2020-11-11 10:36:23', '009', '2020-12-21 11:03:56');
INSERT INTO `qfyu_commodity_warehouse` VALUES (33, 'FG005', NULL, 1, NULL, '阴凉储存', NULL, NULL, '009', '2020-11-19 16:40:25', '009', '2020-12-10 10:14:29');
INSERT INTO `qfyu_commodity_warehouse` VALUES (34, 'FG0013', NULL, 1, NULL, '常温储存', NULL, NULL, '009', '2020-11-19 18:35:32', '009', '2020-12-10 10:13:28');
INSERT INTO `qfyu_commodity_warehouse` VALUES (37, 'GD0015', NULL, 1, NULL, '常温储存', NULL, NULL, '009', '2020-11-20 09:00:52', '009', '2020-12-10 10:13:54');
INSERT INTO `qfyu_commodity_warehouse` VALUES (38, 'GD0016', 180, 1, 180, '阴凉储存', NULL, NULL, '009', '2020-11-20 10:28:30', '009', '2020-12-22 11:29:38');
INSERT INTO `qfyu_commodity_warehouse` VALUES (39, 'GD0017', NULL, 3, NULL, '阴凉储存', NULL, NULL, '009', '2020-11-20 14:35:11', '009', '2020-12-10 10:14:07');
INSERT INTO `qfyu_commodity_warehouse` VALUES (40, 'GD0018', NULL, 0, NULL, '阴凉储存', NULL, NULL, '009', '2020-11-20 14:40:07', '009', '2020-12-10 10:14:14');
INSERT INTO `qfyu_commodity_warehouse` VALUES (41, 'GD0019', NULL, 1, NULL, '冷藏储存', NULL, NULL, '009', '2020-11-20 14:44:34', '009', '2020-12-21 13:54:36');
INSERT INTO `qfyu_commodity_warehouse` VALUES (42, 'GD0020', NULL, NULL, NULL, '阴凉储存', NULL, NULL, '009', '2020-12-22 11:02:40', NULL, NULL);
INSERT INTO `qfyu_commodity_warehouse` VALUES (43, 'GD0021', NULL, NULL, NULL, '常温储存', NULL, NULL, '009', '2020-12-22 11:15:07', NULL, NULL);
INSERT INTO `qfyu_commodity_warehouse` VALUES (44, 'FG0014', NULL, 0, NULL, '阴凉储存', NULL, NULL, '009', '2020-12-22 11:22:24', NULL, NULL);
INSERT INTO `qfyu_commodity_warehouse` VALUES (45, 'GD0022', NULL, 0, NULL, '常温储存', NULL, NULL, '009', '2020-12-22 11:27:57', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_custom_kinds
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_custom_kinds`;
CREATE TABLE `qfyu_custom_kinds`  (
  `kid` int(10) NOT NULL COMMENT '对应自定义许可经营类别表id',
  `top_kid` int(10) NULL DEFAULT NULL COMMENT '许可经营大类编号',
  `chlid_kid` int(10) NOT NULL COMMENT '许可经营小类编号',
  `creater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自定义许可经营类别详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_custom_kinds
-- ----------------------------
INSERT INTO `qfyu_custom_kinds` VALUES (3, 1, 16, '009', '2020-11-12 09:40:43');
INSERT INTO `qfyu_custom_kinds` VALUES (3, 2, 19, '009', '2020-11-12 09:40:43');
INSERT INTO `qfyu_custom_kinds` VALUES (3, 3, 23, '009', '2020-11-12 09:40:43');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 12, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 13, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 14, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 15, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 16, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 17, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 1, 18, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 2, 19, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 2, 20, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 2, 21, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (4, 2, 22, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 5, 5, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 4, 39, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 8, 26, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 8, 27, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 8, 28, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 10, 29, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 10, 30, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 10, 31, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (5, 10, 32, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 5, 5, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 7, 7, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 9, 9, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 11, 11, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 4, 39, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 6, 38, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 8, 26, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 8, 27, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 8, 28, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 10, 30, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 10, 29, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (6, 10, 31, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 5, 5, '009', '2020-11-12 10:23:31');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 7, 7, '009', '2020-11-12 10:23:31');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 11, 11, '009', '2020-11-12 10:23:31');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 4, 39, '009', '2020-11-12 10:23:31');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 6, 38, '009', '2020-11-12 10:23:31');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 8, 26, '009', '2020-11-12 10:23:31');
INSERT INTO `qfyu_custom_kinds` VALUES (7, 8, 28, '009', '2020-11-12 10:23:31');

-- ----------------------------
-- Table structure for qfyu_custom_kinds_name
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_custom_kinds_name`;
CREATE TABLE `qfyu_custom_kinds_name`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '自定义许可类别名称',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `creater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `creater_date` datetime(0) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自定义许可经营类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_custom_kinds_name
-- ----------------------------
INSERT INTO `qfyu_custom_kinds_name` VALUES (3, '医疗器械', NULL, '009', '2020-11-12 09:40:43');
INSERT INTO `qfyu_custom_kinds_name` VALUES (4, '医院诊所', NULL, '009', '2020-11-12 09:56:52');
INSERT INTO `qfyu_custom_kinds_name` VALUES (5, '药店', NULL, '009', '2020-11-12 10:11:52');
INSERT INTO `qfyu_custom_kinds_name` VALUES (6, '批发', NULL, '009', '2020-11-12 10:22:13');
INSERT INTO `qfyu_custom_kinds_name` VALUES (7, '零售', NULL, '009', '2020-11-12 10:23:31');

-- ----------------------------
-- Table structure for qfyu_customer
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_customer`;
CREATE TABLE `qfyu_customer`  (
  `auto_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `id` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `sname` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户简称',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户全称',
  `depart` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `mnecode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '助记码',
  `parlevel` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父级编号',
  `man` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `mannumber` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `comarea` varchar(90) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '公司地址',
  `deliorder` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货顺序',
  `warehouse` varchar(90) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库地址',
  `deliroute` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货线路',
  `swarehouse` varchar(90) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库地址2',
  `sdeliroute` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货线路2',
  `twarehouse` varchar(90) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库地址3',
  `tdeliroute` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货线路3',
  `telephone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机',
  `faxed` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '传真',
  `typebus` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业类型',
  `owner` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所有制性质',
  `opermode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经营方式',
  `quacontril` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理达标情况',
  `corentity` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业法人',
  `corposition` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法人职务',
  `capacity` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法定资格',
  `custlass` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户分类',
  `area` int(10) NULL DEFAULT NULL COMMENT '所在地区',
  `postcode` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮编',
  `charge` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务负责人',
  `busauthoruse_date` datetime(0) NULL DEFAULT NULL COMMENT '业务授权书有效期',
  `accoutbank` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户银行',
  `bankid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '银行账号',
  `taxcode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '税号',
  `abccla` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'ABC分类',
  `quota` decimal(15, 2) NULL DEFAULT NULL COMMENT '信用额度',
  `quotadata` int(10) NULL DEFAULT NULL COMMENT '信用天数',
  `priceshe` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '价格方案',
  `pricecoeff` decimal(15, 6) NULL DEFAULT 1.000000 COMMENT '价格系数',
  `monitcode` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '统一监管码',
  `settlemode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式编号',
  `department` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属部门ID',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `busliceid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '营业执照号',
  `busliceuse_date` datetime(0) NULL DEFAULT NULL COMMENT '营业执照有效期',
  `medbusliceid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '药品经营许可证编号',
  `medbusliceuse_date` datetime(0) NULL DEFAULT NULL COMMENT '药品经营许可证有效期',
  `medpremit` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '医疗许可证',
  `medpremituse_date` datetime(0) NULL DEFAULT NULL COMMENT '医疗许可证有效期',
  `gspid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GSP证书编号',
  `gspuse_date` datetime(0) NULL DEFAULT NULL COMMENT 'GSP证书有效期',
  `organid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组织机构代码证编号',
  `organuse_date` datetime(0) NULL DEFAULT NULL COMMENT '组织机构代码证有效期',
  `foodbusid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '食品经营许可证编号',
  `foodbususe_date` datetime(0) NULL DEFAULT NULL COMMENT '食品经营许可证有效期',
  `healthid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保健品经营许可证编号',
  `healthuse_date` datetime(0) NULL DEFAULT NULL COMMENT '保健品经营许可证有效期',
  `medmentid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '医疗器械许可证编号',
  `medmentuse_date` datetime(0) NULL DEFAULT NULL COMMENT '医疗器械许可证有效期',
  `customoid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义证书1编号',
  `customouse_date` datetime(0) NULL DEFAULT NULL COMMENT '自定义证书1有效期',
  `customsid` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义证书2编号',
  `customsuse_date` datetime(0) NULL DEFAULT NULL COMMENT '自定义证书2有效期',
  `control` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '控销类别编号',
  `qualityman` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理机构负责人',
  `qmnumber` int(10) NULL DEFAULT NULL COMMENT '质量管理机构人数',
  `qmphone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理机构联系电话',
  `createmanid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人编号',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `editmanid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `edit_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `stopuser` tinyint(1) NULL DEFAULT 0 COMMENT '暂停往来',
  `dataable` tinyint(1) NULL DEFAULT 1 COMMENT '资料有效',
  `ismem` tinyint(1) NULL DEFAULT 0 COMMENT '是否会员',
  `agreekind` tinyint(1) NULL DEFAULT NULL COMMENT '可记录协议品种',
  `customid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义编号',
  `ddkindid` varchar(12000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '许可经营类别(分类ID)',
  `isvalid` tinyint(1) NULL DEFAULT 0 COMMENT '资质审核状态 0未审核 1已通过',
  `retime` bigint(10) NULL DEFAULT NULL COMMENT '更新时间(防止无修改保存失败)',
  PRIMARY KEY (`auto_id`) USING BTREE,
  INDEX `id`(`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户资料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_customer
-- ----------------------------
INSERT INTO `qfyu_customer` VALUES (1, 'CR0001', '医药云药业', '深圳医药云药业有限公司', '购方部门', 'YYYYY', '', '张总', '0755-88988564', '深圳市福田区平安大厦', '2', '梅龙苑仓库地址', '2', '大为商务时空仓库地址2', '2', '深圳市龙华区隔震新村仓库地址3', '2', '18562658546', '0755888888', '药品生产企业', '股份制', '零售', '达标率99.95%', '高先生', '总经理', '法人代表', '社康服务站', 6, '612000', '8888', '2023-11-04 00:00:00', '中国农业银行', '61228521456887459774', '9144030071526726XG', 'B', 1000.00, 90, '3', 1.000000, '7214512331122', 'JS001', '2', '优质潜力客户', '9144030071526726XG', '2021-07-04 00:00:00', '341281198708286572', '2025-11-04 00:00:00', 'PDY00698-14412831702112', '2021-12-04 00:00:00', 'C-GD-17-HZH-0017', '2021-10-04 00:00:00', '72030348-0', '2029-11-04 00:00:00', 'JY15203820047444', '2023-11-04 00:00:00', '', NULL, '粤汕食药监器械经营许20190022号', '2024-12-01 00:00:00', '', NULL, '', NULL, '', '蕾娜', 2, '13528858896', '8888', '2020-11-01 15:13:47', '001', '2020-12-14 10:58:42', 0, 1, 1, 1, '18955', '11,12,55,56', 0, 1607914737);
INSERT INTO `qfyu_customer` VALUES (2, 'CR0002', '方舟药业', '惠州市方舟药业有限公司', '购方部门', 'FZYY', '', '姚总1', '0755-89988888', '深圳市福田区平安大厦', '2', '梅龙苑仓库地址', '2', '大为商务时空', '2', '深圳市龙华区隔震新村', '2', '18562658546', '0755888888', '药品生产企业', '股份制', '零售', '达标率99.95%', '高先生', '总经理', '法人代表', '社康服务站', 5, '612000', '8888', '2023-11-04 00:00:00', '中国农业银行', '61228521456887459774', '9144030071526726XG', 'B', 1000.00, 90, '3', 1.200000, '7214512331122', 'JS001', '2', '优质潜力客户', '9144030071526726XG', '2021-07-04 00:00:00', '341281198708286572', '2025-11-04 00:00:00', 'PDY00698-14412831702112', '2021-12-04 00:00:00', 'C-GD-17-HZH-0017', '2021-10-04 00:00:00', '72030348-0', '2029-11-04 00:00:00', 'JY15203820047444', '2023-11-04 00:00:00', '', NULL, '粤汕食药监器械经营许20190022号', '2024-12-01 00:00:00', '', NULL, '', NULL, 'A', '蕾娜', 2, '13528858896', '8888', '2020-11-01 15:13:47', '001', '2020-12-14 10:47:09', 1, 1, 1, 1, '18955', '3,99,100,101,2,54,55,56,57,58,59,60,61,62,63,64,65,66,67,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98', 0, 1607914037);
INSERT INTO `qfyu_customer` VALUES (3, 'CR0003', '家之和', '惠州市家之和药业有限公司', '采购部', 'FZYY', NULL, '唐总', '0755888888', '深圳市福田区平安大厦', '2', '梅龙苑', '2', '大为商务时空', '2', '深圳市龙华区隔震新村', '2', '18562658546', '0755888888', '药品生产企业', '股份制', '零售', '达标率99.95%', '高先生', '总经理', '法人代表', '社康服务站', 3, '612000', '8888', '2023-11-04 15:05:50', '中国农业银行', '61228521456887459774', '9144030071526726XG', 'B', 1000.00, 90, '3', 1.000000, '7214512331122', 'JS001', '2', '优质潜力客户', '9144030071526726XG', '2021-07-04 15:10:43', '341281198708286572', '2025-11-04 15:11:09', 'PDY00698-14412831702112', '2021-12-04 15:11:32', 'C-GD-17-HZH-0017', '2021-10-04 15:11:49', '72030348-0', '2029-11-04 15:12:11', 'JY15203820047444', '2023-11-04 15:12:27', NULL, NULL, '粤汕食药监器械经营许20190022号', '2024-12-01 18:01:06', NULL, NULL, NULL, NULL, NULL, '蕾娜', 2, '13528858896', '8888', '2020-11-01 15:13:47', '8888', '2020-11-04 15:14:00', 1, 1, 1, 1, '18955', '3', 0, NULL);
INSERT INTO `qfyu_customer` VALUES (4, 'CR0004', '明华堂', '深圳明华堂药业有限公司', '采购部', 'FZYY', NULL, '罗总', '0755888888', '深圳市福田区平安大厦', '2', '梅龙苑', '2', '大为商务时空', '2', '深圳市龙华区隔震新村', '2', '18562658546', '0755888888', '药品生产企业', '股份制', '零售', '达标率99.95%', '高先生', '总经理', '法人代表', '社康服务站', 4, '612000', '8888', '2023-11-04 15:05:50', '中国农业银行', '61228521456887459774', '9144030071526726XG', 'B', 1000.00, 90, '3', 1.000000, '7214512331122', 'JS001', '2', '优质潜力客户', '9144030071526726XG', '2021-07-04 15:10:43', '341281198708286572', '2025-11-04 15:11:09', 'PDY00698-14412831702112', '2021-12-04 15:11:32', 'C-GD-17-HZH-0017', '2021-10-04 15:11:49', '72030348-0', '2029-11-04 15:12:11', 'JY15203820047444', '2023-11-04 15:12:27', NULL, NULL, '粤汕食药监器械经营许20190022号', '2024-12-01 18:01:06', NULL, NULL, NULL, NULL, NULL, '蕾娜', 2, '13528858896', '8888', '2020-11-01 15:13:47', '8888', '2020-11-04 15:14:00', 0, 1, 1, 1, '18955', '3', 0, NULL);
INSERT INTO `qfyu_customer` VALUES (5, 'CR0005', '同心泰', '深圳同心泰药业有限公司', '采购部', 'FZYY', NULL, '蓝总', '0755888888', '深圳市福田区平安大厦', '2', '梅龙苑', '2', '大为商务时空', '2', '深圳市龙华区隔震新村', '2', '18562658546', '0755888888', NULL, '股份制', '零售', '达标率99.95%', '高先生', '总经理', '法人代表', '社康服务站', 2, '612000', '8888', '2023-11-04 15:05:50', '中国农业银行', '61228521456887459774', '9144030071526726XG', 'B', 1000.00, 90, '3', 1.000000, '7214512331122', 'JS001', '2', '优质潜力客户', '9144030071526726XG', '2021-07-04 15:10:43', '341281198708286572', '2025-11-04 15:11:09', 'PDY00698-14412831702112', '2021-12-04 15:11:32', 'C-GD-17-HZH-0017', '2021-10-04 15:11:49', '72030348-0', '2029-11-04 15:12:11', 'JY15203820047444', '2023-11-04 15:12:27', NULL, NULL, '粤汕食药监器械经营许20190022号', '2024-12-01 18:01:06', NULL, NULL, NULL, NULL, NULL, '蕾娜', 2, '13528858896', '8888', '2020-11-01 15:13:47', '8888', '2020-11-04 15:14:00', 1, 1, 1, 1, '18955', '11,12,55,56', 0, NULL);
INSERT INTO `qfyu_customer` VALUES (6, 'CR0010', '测试新增', '庆丰裕测试新增', '人事部', '', '', '吴三桂', '075536630087', '深圳庆丰裕', '', '', '', '', '', '', '', '18812345678', '', '药品批发企业', '', '242全额', '9989', '', '', '', '', 0, '', '', NULL, '农行', '1619146549164949', '218489464', '', 0.00, 0, '', 1.000000, '', '', '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', 0, '', '001', '2020-11-18 10:22:51', '001', '2020-11-18 10:41:12', 0, 0, 0, 0, '', '', 0, 1605667273);
INSERT INTO `qfyu_customer` VALUES (7, 'CR006', '测试客户', '庆丰裕测试客户', NULL, NULL, NULL, NULL, NULL, '大为商务时空', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '药品零售企业', NULL, '零售加批发', '99.6%', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '中国银行', '9144254646464646487', '48461646461', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 0, NULL, NULL, 0, NULL);
INSERT INTO `qfyu_customer` VALUES (8, 'CR007', '测试二', '庆丰裕测试二', '', '', 'CR0002', '1', '', '大为商务时空2', '', '', '惠州至深圳', '', '东莞至江西', '', '东莞至深圳', '', '', '药品批发企业', '', '批发', '99.9999%', '', '', '', '优质客户你', 0, '', '', NULL, '建行', '62122654458855', '1233421312', '', 0.00, 0, '', 0.000000, '', '', '4', '', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', 0, '', '', NULL, '001', '2020-11-16 16:45:38', 0, 0, 0, 0, '', '1,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53', 0, 1605516343);
INSERT INTO `qfyu_customer` VALUES (9, 'CR008', '测试新增', '庆丰裕测试新增', '人事部', NULL, NULL, '吴三桂', '075536630087', '深圳庆丰裕', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '18812345678', NULL, '药品批发企业', NULL, '242全额', '9989', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '农行', '1619146549164949', '218489464', NULL, NULL, NULL, NULL, 1.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '001', '2020-11-18 10:22:51', '001', '2020-11-18 10:22:51', 0, 0, 0, 0, NULL, NULL, 0, 1605666242);
INSERT INTO `qfyu_customer` VALUES (10, 'CR009', '测试新增', '庆丰裕测试新增', '人事部', NULL, NULL, '吴三桂', '075536630087', '深圳庆丰裕', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '18812345678', NULL, '药品批发企业', NULL, '242全额', '9989', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '农行', '1619146549164949', '218489464', NULL, NULL, NULL, NULL, 1.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '001', '2020-11-18 10:22:51', '001', '2020-11-18 10:22:51', 0, 0, 0, 0, NULL, NULL, 0, 1605666249);
INSERT INTO `qfyu_customer` VALUES (12, 'CR0011', '测试实施所', '撒旦法是方式方式', '', '', '', '吴啊贵', '075536630087', '深圳', '', '', '', '', '', '', '', '18012345678', '', '药品批发企业', '', '胜多负少', '9989', '', '', '', '', 0, '', '', NULL, '中行', '49646464', '654949494', '', 0.00, 0, '', 1.000000, '', '', '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', 0, '', '001', '2020-11-18 10:27:25', '001', '2020-11-18 10:35:26', 0, 0, 0, 0, '', '', 0, 1605666927);
INSERT INTO `qfyu_customer` VALUES (13, 'CR0012', '测测测', '测测测', '行政部', NULL, NULL, '吴三', '36630087', '测测测', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '18812345688', NULL, '药品零售企业', NULL, '1122', '全达标', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '工商银行', '65464979764646464', '2342342424', NULL, NULL, NULL, NULL, 1.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '001', '2020-11-18 10:52:20', '001', '2020-11-18 10:52:20', 0, 0, 0, 0, NULL, NULL, 0, 1606957870);
INSERT INTO `qfyu_customer` VALUES (14, 'CR0013', '测测测', '测测测', '行政部', '', '', '吴', '075536630087', '测测测', '', '', '', '', '', '', '', '18812345678', '', '药品零售企业', '', '1122', '全达标', '', '', '', '', 0, '', '', NULL, '工商银行', '65464979764646464', '2342342424', '', 0.00, 0, '', 1.000000, '', '', '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', 0, '', '001', '2020-11-18 10:52:20', '001', '2020-11-18 10:58:07', 0, 0, 0, 0, '', '', 0, 1605668287);
INSERT INTO `qfyu_customer` VALUES (15, 'CR0014', '是的发送到发送到', '是的发送到发送到', '', '', '', '', '', '是的发送到发送到', '', '', '', '', '', '', '', '', '', '药品批发企业', '', '味儿翁', '二位人翁r', '', '', '', '', 0, '', '', NULL, '味儿翁', '949849494', '万3452342424', '', 0.00, 0, '', 1.000000, '', '', '', '', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', 0, '', '001', '2020-11-18 10:58:09', '001', '2020-11-18 10:58:29', 0, 0, 0, 0, '', '', 0, 1605668309);

-- ----------------------------
-- Table structure for qfyu_customer_business
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_customer_business`;
CREATE TABLE `qfyu_customer_business`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户编号',
  `submatter` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '洽谈主题',
  `area` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '洽谈方式或地点',
  `mman` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方洽谈人编号',
  `yman` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方洽谈人',
  `bus_date` datetime(0) NULL DEFAULT NULL COMMENT '洽谈时间',
  `content` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '洽谈内容',
  `retime` bigint(10) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户洽谈记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_customer_business
-- ----------------------------
INSERT INTO `qfyu_customer_business` VALUES (1, 'CR0005', '合作会', '深圳龙华', '001', '方总', '2020-11-18 19:37:59', '关于合作开放中国电信6G万物互联系统', 152);

-- ----------------------------
-- Table structure for qfyu_customer_goods
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_customer_goods`;
CREATE TABLE `qfyu_customer_goods`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `goods_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品编号',
  `cgoods_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户产品编号',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '主单位协议价格',
  `price2` decimal(10, 2) NULL DEFAULT NULL COMMENT '辅单位协议价格',
  `month_limit` int(10) NULL DEFAULT 0 COMMENT '限制月销量 0表示不限制',
  `day_limit` int(10) NULL DEFAULT 0 COMMENT '限制日销量 0表示不限制',
  `is_valid` tinyint(1) NULL DEFAULT 1 COMMENT '是否有效 0无效 1有效',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `near_date` date NULL DEFAULT NULL COMMENT '最近交易日期',
  `no_auto_price` tinyint(1) NULL DEFAULT 1 COMMENT '不自动调价 1不自动 0自动',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `cid`(`cid`, `goods_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户协议品种' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_customer_goods
-- ----------------------------
INSERT INTO `qfyu_customer_goods` VALUES (2, 'CR0001', 'FG001', '', 0.00, 0.00, 0, 0, 1, '', NULL, 0, '2020-12-04 18:32:26');
INSERT INTO `qfyu_customer_goods` VALUES (3, 'CR0001', 'FG0011', '', 160.00, 12.00, 0, 0, 1, '', NULL, 0, '2020-12-04 18:43:44');

-- ----------------------------
-- Table structure for qfyu_customer_img
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_customer_img`;
CREATE TABLE `qfyu_customer_img`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户编号',
  `pic_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称',
  `pic_url` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `pic_date` datetime(0) NULL DEFAULT NULL COMMENT '采集日期',
  `use_date` datetime(0) NULL DEFAULT NULL COMMENT '失效日期',
  `man` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采集人',
  `retime` bigint(20) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户证照图片' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_customer_img
-- ----------------------------
INSERT INTO `qfyu_customer_img` VALUES (1, 'CR0005', 'YPJYXKZ', '/uploads/customer_img/CR0005_YPJYXKZ.png', '2020-12-04 18:30:00', '2021-02-26 00:00:00', '001', 158963262626);

-- ----------------------------
-- Table structure for qfyu_customer_supplier
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_customer_supplier`;
CREATE TABLE `qfyu_customer_supplier`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户主表ID',
  `user_name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` tinyint(1) NULL DEFAULT NULL COMMENT '性别',
  `depart` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `duties` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职务',
  `tel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '办公电话',
  `email` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `salesdepart` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售部负责人编号',
  `salesdepart_date` datetime(0) NULL DEFAULT NULL COMMENT '销售部负责人审核时间',
  `qcdepart` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量部负责人编号',
  `qcdepart_date` datetime(0) NULL DEFAULT NULL COMMENT '质量部负责人审核时间',
  `qcid` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量负责人编号',
  `qc_date` datetime(0) NULL DEFAULT NULL COMMENT '质量负责人审核时间',
  `attorney_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '委托书编号',
  `attorney_content` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '委托书内容',
  `attorney_validity` tinyint(1) NULL DEFAULT 0 COMMENT '委托书是否有效',
  `validity_date` datetime(0) NULL DEFAULT NULL COMMENT '委托书有效期',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '资料是否有效',
  `check_status` tinyint(1) NULL DEFAULT 0 COMMENT '是否审核合格',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `re_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `isdefault` tinyint(1) NULL DEFAULT 0 COMMENT '是否为默认联系人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 48 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户采购人' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_customer_supplier
-- ----------------------------
INSERT INTO `qfyu_customer_supplier` VALUES (41, 'CR0012', '吴三', NULL, '行政部', '', '18812345688', '36630087', '', '', '', NULL, '', NULL, '', NULL, '', '', 0, NULL, 0, 0, '', '001', '2020-11-18 10:53:15', '001', '2020-12-03 09:10:37', 1);
INSERT INTO `qfyu_customer_supplier` VALUES (42, 'CR0013', '吴', NULL, '行政部', '', '18812345678', '75536630087', '', '', '001', '2020-12-03 00:00:00', '002', '2020-12-03 00:00:00', '', NULL, '', '', 1, '2020-12-04 00:00:00', 0, 0, '', '001', '2020-11-18 10:53:15', '001', '2020-12-03 08:46:04', 1);
INSERT INTO `qfyu_customer_supplier` VALUES (43, 'CR0002', '姚总1', 1, '购方部门', '总经理', '18562658546', '0755-89988888', '110025', '深圳龙华', '001', '2020-12-02 00:00:00', '002', '2020-12-02 00:00:00', '002', '2020-12-02 00:00:00', '123456', '123456789', 1, '2020-12-10 00:00:00', 1, 1, '资料有效', '001', '2020-11-19 16:58:21', '001', '2020-12-14 10:47:17', 1);
INSERT INTO `qfyu_customer_supplier` VALUES (45, 'CR0001', 'vr', 2, '', '', '', '0', '', '', '001', '2020-12-07 00:00:00', '001', '2020-12-07 00:00:00', '001', NULL, '2665669++6', '', 1, '2021-04-30 00:00:00', 0, 1, '', '001', '2020-12-07 15:58:56', '001', '2020-12-07 15:59:57', 0);
INSERT INTO `qfyu_customer_supplier` VALUES (46, 'CR0001', 'fdsf', 1, '', '', '', '0', '', '', '', NULL, '', NULL, '', NULL, '4515687688678678', '', 1, '2022-12-23 00:00:00', 0, 0, '', '001', '2020-12-07 16:00:22', '001', '2020-12-07 16:04:30', 0);
INSERT INTO `qfyu_customer_supplier` VALUES (47, 'CR0001', '张总', NULL, '购方部门', NULL, '18562658546', '0755-88988564', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, '001', '2020-12-14 10:51:11', '001', '2020-12-14 10:58:57', 1);

-- ----------------------------
-- Table structure for qfyu_db_work
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_db_work`;
CREATE TABLE `qfyu_db_work`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `field_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字段名',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '值',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `duties`(`value`, `field_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 251 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '自定义数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_db_work
-- ----------------------------
INSERT INTO `qfyu_db_work` VALUES (1, 'duties', 'New Yo', NULL);
INSERT INTO `qfyu_db_work` VALUES (17, 'duties', '作业员1541561', NULL);
INSERT INTO `qfyu_db_work` VALUES (21, 'duties', '作业员56165165', NULL);
INSERT INTO `qfyu_db_work` VALUES (22, 'duties', '1516', NULL);
INSERT INTO `qfyu_db_work` VALUES (23, 'prov_kind', '456546', NULL);
INSERT INTO `qfyu_db_work` VALUES (26, 'custlass', '优质客户', '2020-11-16 16:10:00');
INSERT INTO `qfyu_db_work` VALUES (32, 'custlass', '优质客户你', '2020-11-16 16:45:00');
INSERT INTO `qfyu_db_work` VALUES (216, 'duties', '质检员', '2020-11-19 14:17:00');
INSERT INTO `qfyu_db_work` VALUES (217, 'duties', '质量负责人', '2020-11-19 14:31:00');
INSERT INTO `qfyu_db_work` VALUES (218, 'duties', '负责人方法', '2020-11-19 14:33:00');
INSERT INTO `qfyu_db_work` VALUES (230, 'duties', '作业员', '2020-12-04 13:38:00');
INSERT INTO `qfyu_db_work` VALUES (245, 'custlass', '社康服务站', '2020-12-14 10:58:00');
INSERT INTO `qfyu_db_work` VALUES (250, 'prov_kind', '二位二翁', '2020-12-16 17:08:00');

-- ----------------------------
-- Table structure for qfyu_delivery
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_delivery`;
CREATE TABLE `qfyu_delivery`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `dname` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '线路名称',
  `licpla` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车牌号',
  `driver` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '司机姓名',
  `send_time` time(0) NULL DEFAULT NULL COMMENT '计划发车时间',
  `sttimeman` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '跟车人',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '送货路线编排表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_delivery
-- ----------------------------
INSERT INTO `qfyu_delivery` VALUES (1, '东莞至深圳', '粤S56398', '谢师傅', '10:35:48', '林有劲', '周末不出车');
INSERT INTO `qfyu_delivery` VALUES (2, '惠州至深圳', '粤B55568', '吴师傅', '08:49:01', '王德安', '大型车');
INSERT INTO `qfyu_delivery` VALUES (3, '惠州至湖南', '湘B88845', '萧汽运', '07:50:33', '马大力', '长途线路每周两趟');
INSERT INTO `qfyu_delivery` VALUES (4, '东莞至江西', '赣A00000', '刘长途', '08:52:17', '牛旺', '每周一出车');

-- ----------------------------
-- Table structure for qfyu_depart
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_depart`;
CREATE TABLE `qfyu_depart`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `branch_id` int(10) UNSIGNED NOT NULL COMMENT '所属公司ID',
  `dept_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '部门名称',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '地址',
  `tel` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `fax` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '传真',
  `leader` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '负责人',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '默认有效 0表示失效',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者code',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `re_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `branch_id`(`branch_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '企业机构部门' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_depart
-- ----------------------------
INSERT INTO `qfyu_depart` VALUES (1, 0, '深圳总部', '深圳龙华', '0755-567567,13826516165', 'xxxxxxxxxxxxxxx', '李总', 1, '001', NULL, '2020-09-10 00:00:00', '2020-09-10 00:00:00', NULL);
INSERT INTO `qfyu_depart` VALUES (2, 1, '品控部', '深圳龙华', '0755-567567,13826516165', 'xxxxxxxxxxxxxxx', '好总', 1, '', '001', '2020-09-10 00:00:00', '2020-11-19 15:03:01', NULL);
INSERT INTO `qfyu_depart` VALUES (3, 1, '销售部', '深圳福田', '0755-567567,13826516165', 'xxxxxxxxxxxxxxx', '里总1', 1, '001', '001', '2020-09-10 00:00:00', '2020-11-19 15:03:07', NULL);
INSERT INTO `qfyu_depart` VALUES (4, 0, '深圳观澜分部3', '深圳观澜1', '0755-567567,13826516165', 'xxxxxxxxxxxxxxx', '刘总1', 1, '001', '001', '2020-09-10 00:00:00', '2020-11-19 15:06:29', NULL);
INSERT INTO `qfyu_depart` VALUES (5, 4, '运营部', '湖南长沙', '0736-4161616,18995999', '0736-48984464', '周总', 1, '001', NULL, '2020-09-10 00:00:00', '2020-09-10 00:00:00', NULL);
INSERT INTO `qfyu_depart` VALUES (6, 4, '开发部', '陕西宝鸡', '0658-5651611', '0986-16516516', '郝总', 1, '001', NULL, '2020-09-10 00:00:00', '2020-09-10 00:00:00', NULL);
INSERT INTO `qfyu_depart` VALUES (7, 4, '生产部', '深圳观澜', '0755-1516516', '165216516', '李总1', 1, '001', NULL, '2020-09-10 00:00:00', '2020-09-10 00:00:00', NULL);
INSERT INTO `qfyu_depart` VALUES (8, 0, '上海分公司', '深圳观澜', '0755-1516516', '165216516', '李总', 1, '001', NULL, '2020-09-10 00:00:00', '2020-09-10 00:00:00', NULL);

-- ----------------------------
-- Table structure for qfyu_employee
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_employee`;
CREATE TABLE `qfyu_employee`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '员工编号',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '姓名',
  `sex` tinyint(1) NULL DEFAULT NULL COMMENT '性别（1男 2女）',
  `birthday_date` datetime(0) NULL DEFAULT NULL COMMENT '出生日期',
  `native_place` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '籍贯',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `phone` bigint(11) NULL DEFAULT NULL COMMENT '手机号',
  `urgent_phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '紧急联系方式',
  `card_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '身份证号',
  `edu` tinyint(1) NULL DEFAULT NULL COMMENT '学历1=>\'小学\',2=>\'初中\',3=>\'中专\',4=>\'高中\',5=>\'专科\',6=>\'本科\',7=>\'研究生\',8=>\'博士\'',
  `profess` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '专业',
  `grad_date` datetime(0) NULL DEFAULT NULL COMMENT '毕业时间',
  `entry_date` datetime(0) NULL DEFAULT NULL COMMENT '入职时间',
  `resign_date` datetime(0) NULL DEFAULT NULL COMMENT '辞职时间',
  `depart_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  `depart_id` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '部门编号',
  `duties` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职务',
  `tech_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '技术职称',
  `seniority` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '执业资格',
  `appraisal` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '执业资格鉴定单位',
  `comm_rate` decimal(10, 2) NULL DEFAULT NULL COMMENT '提成率',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `identification_card` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份识别卡',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '在职状态 默认在职 0不在职',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者code',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `re_time` datetime(0) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE,
  INDEX `depart_id`(`depart_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '员工资料信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_employee
-- ----------------------------
INSERT INTO `qfyu_employee` VALUES (1, '001', '小李', 1, NULL, '湖南', '', 13549194161, '18551651651616', '4265126526', 6, '医药医学', '2020-09-25 00:00:00', '2020-09-09 00:00:00', NULL, '深圳总部', 1, '作业员', '医药学', 'gdfgfdg', '', 0.00, '121', '', 1, '', '001', '2020-09-09 00:00:00', '2020-11-20 10:39:16');
INSERT INTO `qfyu_employee` VALUES (2, '002', '小李1', 2, NULL, '湖南', '', 13549194162, '1855165165', '43044161265161616', 6, '医药医学', '2021-06-11 00:00:00', '2020-09-09 00:00:00', NULL, '深圳总部', 1, '作业员', '医药学', '', '', 0.00, '33', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (3, '003', '小米', 1, NULL, '广东深圳', '', 13589498151, '1886541654161616', '89498484641', 3, 'xxx', '2020-09-16 00:00:00', '2020-09-10 00:00:00', NULL, '深圳总部', 1, '作业员', '', '', '', 0.00, '445956', '', 1, '', '001', '2020-09-09 00:00:00', '2020-12-04 13:38:27');
INSERT INTO `qfyu_employee` VALUES (4, '004', '小黄', 1, NULL, '广东深圳', '', 13589498151, '188654165', '89498484641', 3, 'xxx', '2020-09-16 00:00:00', '2020-09-24 00:00:00', NULL, '深圳总部', 1, '作业员', '45456456', '', '', 0.00, '55', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (5, '005', '小明', 1, NULL, '广东惠州', '', 18926515616, '0516526156165', '8651561531616', 5, 'xxx', '2020-09-10 00:00:00', '2020-09-25 00:00:00', NULL, '深圳总部', 1, '作业员', '', '', '', 0.00, '6', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (6, '006', '小明1', 1, NULL, '广东惠州', '', 18926515616, '0516526156165', '8651561531616', 6, 'xxx', '2020-09-10 00:00:00', '2020-09-25 00:00:00', NULL, '深圳总部', 1, '质检员', '', '', '', 0.00, '77', '', 1, '', '', '2020-09-09 00:00:00', '2020-11-19 14:16:54');
INSERT INTO `qfyu_employee` VALUES (7, '007', '小化', 1, NULL, '广东惠州', '', 18926515616, '0516526156165', '8651561531616', 6, 'xxx', '2020-09-10 00:00:00', '2020-09-25 00:00:00', NULL, '深圳总部', 1, '作业员', '', '', '', 0.00, '888', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (8, '008', '小王1', 1, NULL, '广东惠州', '', 18926515616, '0516526156165', '8651561531616', 6, 'xxx', '2020-09-11 00:00:00', '2020-09-26 00:00:00', NULL, '深圳总部', 1, '作业员', '', '', '', 0.00, '99', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (9, '009', '小米', 1, '1970-01-01 00:00:00', '广东深圳', '', 13589498152, '1886541654161616', '89498484641', 3, 'xxx', '2020-09-16 00:00:00', '2020-09-24 00:00:00', NULL, '深圳总部', 1, '作业员', '', '', '', 0.00, '11', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (10, '010', '小李', 2, '2020-09-08 00:00:00', '湖南1', '', 13549194163, '1855165165', '43044161265161616', 2, '医药医学', '2021-06-11 00:00:00', '2020-09-09 00:00:00', NULL, '深圳总部', 1, '作业员', '医药学', '4545', '', 0.00, '1221', NULL, 1, '', '', '2020-09-09 00:00:00', '2020-09-09 00:00:00');
INSERT INTO `qfyu_employee` VALUES (12, 'PE011', '小李2524', 1, NULL, '湖南', '', 13549194161, '18551651651616', '4265126526', 6, '医药医学', '2020-09-25 00:00:00', '2020-09-09 00:00:00', NULL, '深圳总部', 1, '质检员', '医药学', 'gdfgfdg', '', 0.05, '144', '', 1, '', '', '2020-09-09 00:00:00', '2020-11-19 14:17:06');
INSERT INTO `qfyu_employee` VALUES (13, 'PE0012', '于总', 1, NULL, '汉', '', 13111111111, '165156165161', '43044161265161616', 5, '似懂非懂', '2020-11-27 00:00:00', '2020-12-05 00:00:00', NULL, '品控部', 2, '负责人方法', '', '', '', NULL, '', NULL, 1, '', '', '2020-11-19 14:33:26', '2020-11-19 14:33:26');

-- ----------------------------
-- Table structure for qfyu_enterprise_photo
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_enterprise_photo`;
CREATE TABLE `qfyu_enterprise_photo`  (
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `kind` tinyint(1) NULL DEFAULT 0 COMMENT '0首营审核 1供应商资料',
  `img_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称',
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '采集日期',
  `validity_date` date NULL DEFAULT NULL COMMENT '有效期',
  `creator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采集人',
  UNIQUE INDEX `supplier_code_2`(`supplier_code`, `img_name`, `kind`) USING BTREE,
  INDEX `supplier_code`(`supplier_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商证照' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_enterprise_photo
-- ----------------------------
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS004', 0, 'YZYSTP', '/uploads/first_enterprise/FS004_YZYSTP.jpg', '2020-10-23 18:01:00', '2020-10-23', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS004', 0, 'SHTXD', '/uploads/first_enterprise/FS004_SHTXD.jpg', '2020-10-23 16:43:00', '2020-10-23', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS008', 0, 'YZYSTP', '/uploads/first_enterprise/FS008_YZYSTP.jpg', '2020-10-24 09:38:00', '1970-01-01', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS008', 0, 'SHTXD', '/uploads/first_enterprise/FS008_SHTXD.jpg', '2020-10-24 09:39:00', '1970-01-01', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'YYZZ', '/uploads/first_enterprise/FS001_YYZZ.jpg', '2020-11-30 18:45:00', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'GSP_GMP', '/uploads/first_enterprise/FS001_GSP_GMP.jpg', '2020-12-07 15:27:06', '2020-12-07', '009');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'ZZJGDMZ', '/uploads/first_enterprise/FS001_ZZJGDMZ.jpg', '2020-11-30 18:18:00', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 0, 'YZYSTP', '/uploads/first_enterprise/FS004_YZYSTP.jpg', '2020-10-23 18:01:00', '2020-10-23', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 0, 'SHTXD', '/uploads/first_enterprise/FS004_SHTXD.jpg', '2020-10-23 16:43:00', '2020-10-23', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'BJPJYXKZ', '/uploads/first_enterprise/FS001_BJPJYXKZ.jpg', '2020-12-05 14:27:10', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'YPJYXKZ', '/uploads/first_enterprise/FS001_YPJYXKZ.jpg', '2020-11-30 18:25:00', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'SHTXD', '/uploads/first_enterprise/FS001_SHTXD.jpg', '2020-11-30 18:25:00', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'FRWTS', '/uploads/first_enterprise/FS001_FRWTS.jpg', '2020-11-30 18:43:00', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS001', 1, 'ZGZS', '/uploads/first_enterprise/FS001_ZGZS.jpg', '2020-11-30 18:46:00', '2020-11-02', '001');
INSERT INTO `qfyu_enterprise_photo` VALUES ('FS003', 1, 'ZZJGDMZ', '/uploads/first_enterprise/FS003_ZZJGDMZ.jpg', '2020-12-01 19:13:00', '2020-12-23', '001');

-- ----------------------------
-- Table structure for qfyu_enterprise_supplier
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_enterprise_supplier`;
CREATE TABLE `qfyu_enterprise_supplier`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `orderid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单据号',
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` tinyint(1) NULL DEFAULT NULL COMMENT '性别',
  `id_card` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `depart` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `duties` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职务',
  `tel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `phone` bigint(11) NULL DEFAULT NULL COMMENT '手机',
  `qq` bigint(15) NULL DEFAULT NULL COMMENT 'qq',
  `attorney_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '委托书编号',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '资料是否有效',
  `content_power` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '委托书内容',
  `validity_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期',
  `attorney_validity` tinyint(1) NULL DEFAULT 1 COMMENT '委托书是否有效',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '住址',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `re_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `orderid`(`orderid`) USING BTREE,
  INDEX `supplier_code`(`supplier_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商销售人员（首营申请）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_enterprise_supplier
-- ----------------------------
INSERT INTO `qfyu_enterprise_supplier` VALUES (7, 'FS2010215056521021', 'FS005', '销售', 0, '432712198911288595', '', '', '', NULL, NULL, '', 1, '', NULL, 1, '', '', '001', '2020-10-26 08:46:06', NULL, NULL);
INSERT INTO `qfyu_enterprise_supplier` VALUES (8, 'FS2010215056521021', 'FS005', 'zero', 0, '432712198911288596', '', '', '', NULL, NULL, '', 1, '', NULL, 1, '', '', '001', '2020-10-26 11:55:34', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_extend_define
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_extend_define`;
CREATE TABLE `qfyu_extend_define`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) NOT NULL,
  `mode_code` varchar(33) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `t_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '默认有效  0无效',
  PRIMARY KEY (`id`, `mode_id`, `t_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_extend_define
-- ----------------------------
INSERT INTO `qfyu_extend_define` VALUES (1, 1, 'manager', '总经理', 1);
INSERT INTO `qfyu_extend_define` VALUES (2, 1, 'finance', '财务部负责人', 1);
INSERT INTO `qfyu_extend_define` VALUES (3, 1, 'quality_admin', '质量管理员', 1);
INSERT INTO `qfyu_extend_define` VALUES (4, 1, 'quality_depart', '质量管理部负责人', 1);
INSERT INTO `qfyu_extend_define` VALUES (5, 1, 'quality_director', '质量负责人', 1);
INSERT INTO `qfyu_extend_define` VALUES (6, 1, 'purch_depart', '采购部负责人', 1);
INSERT INTO `qfyu_extend_define` VALUES (7, 1, 'sales_depart', '销售部负责人', 1);
INSERT INTO `qfyu_extend_define` VALUES (8, 201, '', '修改业务信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (9, 201, '', '修改基本信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (10, 201, '', '修改授权资料', 1);
INSERT INTO `qfyu_extend_define` VALUES (11, 202, '', '修改业务信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (12, 202, '', '修改基本信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (13, 202, '', '修改授权资料', 1);
INSERT INTO `qfyu_extend_define` VALUES (14, 207, '', '修改业务信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (15, 207, '', '修改基本信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (16, 207, '', '显示价格_供货历史', 1);
INSERT INTO `qfyu_extend_define` VALUES (17, 207, '', '显示价格_库存信息', 1);
INSERT INTO `qfyu_extend_define` VALUES (18, 207, '', '显示价格_购进记录', 1);
INSERT INTO `qfyu_extend_define` VALUES (19, 207, '', '隐藏购进记录', 1);
INSERT INTO `qfyu_extend_define` VALUES (20, 305, '', '下载总部销售单', 1);
INSERT INTO `qfyu_extend_define` VALUES (21, 305, '', '导入药检报告', 1);
INSERT INTO `qfyu_extend_define` VALUES (22, 305, '', '管理药检报告', 1);
INSERT INTO `qfyu_extend_define` VALUES (23, 311, '', '财务审核权', 1);
INSERT INTO `qfyu_extend_define` VALUES (24, 311, '', '质管审核权', 1);
INSERT INTO `qfyu_extend_define` VALUES (25, 405, '', '修改已审销售单备注', 1);
INSERT INTO `qfyu_extend_define` VALUES (26, 405, '', '修改已审销售单装箱', 1);
INSERT INTO `qfyu_extend_define` VALUES (27, 405, '', '可授权亏本销售', 1);
INSERT INTO `qfyu_extend_define` VALUES (28, 405, '', '门店下载管理', 1);
INSERT INTO `qfyu_extend_define` VALUES (29, 509, '', '财务审核权', 1);
INSERT INTO `qfyu_extend_define` VALUES (30, 509, '', '质管审核权', 1);
INSERT INTO `qfyu_extend_define` VALUES (31, 510, '', '财务审核权', 1);
INSERT INTO `qfyu_extend_define` VALUES (32, 510, '', '质管审核权', 1);
INSERT INTO `qfyu_extend_define` VALUES (33, 704, '', '后台兑奖', 1);
INSERT INTO `qfyu_extend_define` VALUES (34, 704, '', '后台换券', 1);
INSERT INTO `qfyu_extend_define` VALUES (35, 1401, '', '不管控请货数量', 1);

-- ----------------------------
-- Table structure for qfyu_goods_check_accept
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_goods_check_accept`;
CREATE TABLE `qfyu_goods_check_accept`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据编号',
  `delivery_date` date NULL DEFAULT NULL COMMENT '来货日期',
  `accept_date` date NULL DEFAULT NULL COMMENT '验收日期',
  `depart` int(10) NOT NULL COMMENT '资源所属',
  `come_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来货登记单单据号',
  `supplier_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `check_type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '单据类别 1、采购验收',
  `gsp_type` tinyint(1) NOT NULL COMMENT '验收类型',
  `create_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `update_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `checker_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员',
  `checker_date` datetime(0) NULL DEFAULT NULL COMMENT '复核日期',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '单据状态 默认0未审核 1已审核',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `accept_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验收员',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '质量验收-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_goods_check_accept
-- ----------------------------
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012031001005010', '2020-12-03', '2020-12-03', 1, 'PC2012015299505655', 'FS003', 1, 1, '009', '2020-12-03 14:47:09', NULL, NULL, '009', '2020-12-03 18:50:10', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012035199495010', '2020-12-03', '2020-12-03', 1, 'PC2012015299505655', 'FS003', 1, 2, '009', '2020-12-03 18:42:11', NULL, NULL, '009', '2020-12-04 08:45:35', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012045297495710', '2020-12-04', '2020-12-04', 1, 'PC2012015299505655', 'FS003', 1, 3, '009', '2020-12-04 08:38:28', NULL, NULL, '009', '2020-12-04 08:51:00', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012045352499957', '2020-12-04', '2020-12-04', 1, 'PC2012015299505655', 'FS003', 1, 4, '009', '2020-12-04 08:39:17', NULL, NULL, '009', '2020-12-04 08:58:49', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012049999569710', '2020-12-04', '2020-12-04', 1, 'PC2012015299505655', 'FS003', 1, 5, '009', '2020-12-04 08:35:08', NULL, NULL, '009', '2020-12-04 08:52:10', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012125198565348', '2020-12-12', '2020-12-12', 2, 'PC2012051019752545', 'FS003', 1, 1, '009', '2020-12-12 09:29:23', '009', '2020-12-14 11:22:28', NULL, NULL, 0, '123123123', '005');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012125198579798', '2020-12-12', '2020-12-12', 2, 'PC2012051019752545', 'FS003', 1, 2, '009', '2020-12-12 09:29:23', NULL, NULL, '009', '2020-12-14 08:46:21', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012125198975597', '2020-12-12', '2020-12-12', 2, 'PC2012051019752545', 'FS003', 1, 3, '009', '2020-12-12 09:29:23', NULL, NULL, NULL, NULL, 0, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012141025252995', '2020-12-14', '2020-12-14', 1, 'PC2012141011009810', 'FS003', 1, 2, '009', '2020-12-14 10:35:27', '009', '2020-12-21 18:03:01', '009', '2020-12-21 18:03:03', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012141025256501', '2020-12-14', '2020-12-14', 1, 'PC2012141011009810', 'FS003', 1, 5, '009', '2020-12-14 10:35:27', '009', '2020-12-21 18:03:49', NULL, NULL, 0, '', '004');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012145299555249', '2020-12-14', '2020-12-14', 1, 'PC2012105310053574', 'FS007', 1, 4, '009', '2020-12-14 10:41:08', NULL, NULL, '009', '2020-12-14 17:28:44', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012145299571009', '2020-12-14', '2020-12-14', 1, 'PC2012105310053574', 'FS007', 1, 6, '009', '2020-12-14 10:41:08', '009', '2020-12-14 17:39:04', '009', '2020-12-14 17:39:16', 1, '', '005');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012145299979810', '2020-12-14', '2020-12-14', 1, 'PC2012105310053574', 'FS007', 1, 5, '009', '2020-12-14 10:41:08', '009', '2020-12-14 17:44:17', '009', '2020-12-14 18:52:16', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012154851499751', '2020-12-15', '2020-12-15', 1, 'PC2012149953100501', 'FS003', 1, 2, '009', '2020-12-15 10:14:56', '009', '2020-12-15 10:16:45', '009', '2020-12-15 10:17:10', 1, '备注', '004');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012154851515549', '2020-12-15', '2020-12-15', 1, 'PC2012149953100501', 'FS003', 1, 3, '009', '2020-12-15 10:14:56', NULL, NULL, '009', '2020-12-15 10:17:44', 1, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155399545153', '2020-12-15', '2020-12-15', 1, 'PC2012155251971005', 'FS002', 1, 5, '009', '2020-12-15 16:14:13', '009', '2020-12-15 16:18:58', '009', '2020-12-15 16:20:34', 1, '', '005');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155499484997', '2020-12-15', '2020-12-15', 1, 'PC2012159751501005', 'FS009', 1, 1, '009', '2020-12-15 10:54:14', '009', '2020-12-15 14:58:51', '009', '2020-12-15 14:59:26', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155499525653', '2020-12-15', '2020-12-15', 1, 'PC2012159751501005', 'FS009', 1, 3, '009', '2020-12-15 10:54:14', '009', '2020-12-15 15:09:27', '009', '2020-12-15 15:09:57', 1, '111112312312', '007');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155499545598', '2020-12-15', '2020-12-15', 1, 'PC2012159751501005', 'FS009', 1, 4, '009', '2020-12-15 10:54:14', '009', '2020-12-15 15:47:28', '009', '2020-12-15 15:52:57', 1, '1211212', '004');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155597499853', '2020-12-15', '2020-12-15', 1, 'PC2012159857525455', 'FS003', 1, 1, '009', '2020-12-15 15:58:15', '009', '2020-12-15 16:00:00', '009', '2020-12-15 16:00:01', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155597535197', '2020-12-15', '2020-12-15', 1, 'PC2012159857525455', 'FS003', 1, 2, '009', '2020-12-15 15:58:15', '009', '2020-12-15 16:09:35', '009', '2020-12-15 16:09:37', 1, '', '005');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012155597545610', '2020-12-15', '2020-12-15', 1, 'PC2012159857525455', 'FS003', 1, 3, '009', '2020-12-15 15:58:15', '009', '2020-12-15 16:12:07', '009', '2020-12-15 16:12:09', 1, '', '005');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012159810048485', '2020-12-15', '2020-12-15', 1, 'PC2012154857525157', 'FS003', 1, 1, '009', '2020-12-15 10:49:31', NULL, NULL, NULL, NULL, 0, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012159810051989', '2020-12-15', '2020-12-15', 1, 'PC2012154857525157', 'FS003', 1, 2, '009', '2020-12-15 10:49:31', NULL, NULL, NULL, NULL, 0, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012181029854564', '2020-12-18', '2020-12-18', 1, 'PC2012185050551021', 'FS002', 1, 1, '009', '2020-12-18 18:00:15', '009', '2020-12-18 18:00:36', '009', '2020-12-18 18:00:38', 1, '', '004');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012181029856554', '2020-12-18', '2020-12-18', 1, 'PC2012185050551021', 'FS002', 1, 2, '009', '2020-12-18 18:00:15', '009', '2020-12-18 18:01:20', '009', '2020-12-18 18:04:21', 1, '', '004');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012185648545797', '2020-12-18', '2020-12-18', 1, 'PC2012185152565552', 'FS003', 1, 1, '001', '2020-12-18 17:51:20', '001', '2020-12-18 17:52:22', '001', '2020-12-18 17:52:26', 1, '', '005');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012185648565298', '2020-12-18', '2020-12-18', 1, 'PC2012185152565552', 'FS003', 1, 2, '001', '2020-12-18 17:51:20', '001', '2020-12-18 18:00:02', '001', '2020-12-18 18:07:11', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012191024997505', '2020-12-19', '2020-12-19', 1, 'PC2012191015610057', 'FS003', 1, 1, '001', '2020-12-19 10:17:35', '001', '2020-12-19 10:18:12', '001', '2020-12-19 10:18:14', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012191024998995', '2020-12-19', '2020-12-19', 1, 'PC2012191015610057', 'FS003', 1, 2, '001', '2020-12-19 10:17:35', '001', '2020-12-19 10:19:23', '001', '2020-12-19 10:19:25', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012195250975749', '2020-12-19', '2020-12-19', 1, 'PC2012199752495256', 'FS003', 1, 1, '001', '2020-12-19 10:45:08', '001', '2020-12-19 10:45:28', '001', '2020-12-19 10:45:30', 1, '', '004');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012219957535097', '2020-12-21', '2020-12-21', 1, 'PC2012215250505710', 'FS003', 1, 2, '001', '2020-12-21 17:05:32', '001', '2020-12-21 17:06:03', '001', '2020-12-21 17:06:07', 1, '', '003');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012225550489897', '2020-12-22', '2020-12-22', 1, 'PC2012225057539810', 'FS003', 1, 2, '001', '2020-12-22 14:58:15', '001', '2020-12-22 14:58:40', '001', '2020-12-22 15:09:28', 1, '', '006');
INSERT INTO `qfyu_goods_check_accept` VALUES ('CY2012235755102565', '2020-12-23', '2020-12-23', 1, 'PC2012235248539955', 'FS003', 1, 2, '009', '2020-12-23 14:44:09', '009', '2020-12-23 15:23:09', NULL, NULL, 0, '', '003');

-- ----------------------------
-- Table structure for qfyu_goods_check_accept_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_goods_check_accept_details`;
CREATE TABLE `qfyu_goods_check_accept_details`  (
  `a_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `item_no` int(10) NULL DEFAULT NULL COMMENT '项次',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '数量',
  `qualified_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '合格数量',
  `rejection_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '拒收数量',
  `spot_check_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '抽样数量',
  `price` decimal(15, 6) NULL DEFAULT NULL COMMENT '实际单价',
  `money` decimal(15, 6) NULL DEFAULT NULL COMMENT '金额',
  `batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号/序列号',
  `sterilization_batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `production_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `production_end_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `verify_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '药检报告',
  `pass_gate_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通关文号',
  `quality_state` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '外观质量',
  `package_state` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装情况',
  `label_state` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签状况',
  `directions` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明书状况',
  `check_verdict` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验收结论',
  `checker` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验货人',
  `accepter` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `come_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源单号',
  `rejection_type` tinyint(1) NULL DEFAULT 0 COMMENT '不合格处理方式 默认0直接拒收 1先收货入库',
  `storage_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '储存条件',
  `traceability_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追溯号'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '质量验收-明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_goods_check_accept_details
-- ----------------------------
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012031001005010', NULL, 'FG001', '0', NULL, 25.00000, 5.00000, 1.00000, 28.000000, 560.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '001', '001', NULL, 'PC2012015299505655', 0, '1', NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012035199495010', NULL, 'FG001', '0', NULL, 25.00000, 5.00000, 1.00000, 28.000000, 700.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '001', '001', NULL, 'PC2012015299505655', 0, '1', NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012045297495710', NULL, 'FG001', '0', NULL, 25.00000, 5.00000, 1.00000, 28.000000, 700.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '001', '001', NULL, 'PC2012015299505655', 0, '1', NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012045352499957', NULL, 'FG001', '0', NULL, 25.00000, 5.00000, 1.00000, 28.000000, 700.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '001', '001', NULL, 'PC2012015299505655', 0, '1', NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012049999569710', NULL, 'FG001', '0', NULL, 25.00000, 5.00000, 1.00000, 28.000000, 700.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '001', '001', NULL, 'PC2012015299505655', 0, '1', NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012125198579798', NULL, 'FG002', '0', NULL, 50.00000, NULL, 1.00000, 36.000000, 1800.000000, '', '', NULL, NULL, '药检报告', '通过文号', '1', '1', '1', '1', '1', '003', '003', NULL, 'PC2012051019752545', 0, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012125198975597', NULL, 'FG003', '0', NULL, 20.00000, NULL, 1.00000, 28.000000, 560.000000, '生产批号', '灭菌批号', NULL, NULL, NULL, NULL, '1', '1', '1', '1', '1', '003', '003', NULL, 'PC2012051019752545', 0, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012145299555249', 1, 'FG004', '0', 10.00000, 10.00000, NULL, 1.00000, 25.000000, 250.000000, NULL, NULL, NULL, NULL, NULL, NULL, '1', '1', '1', '1', '1', '009', '009', NULL, 'PC2012105310053574', 0, NULL, NULL);
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012145299555249', 2, 'FG004', '0', 1.00000, 1.00000, NULL, 1.00000, 10.000000, 10.000000, NULL, NULL, NULL, NULL, NULL, NULL, '1', '1', '1', '1', '1', '009', '009', NULL, 'PC2012105310053574', 0, NULL, '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012125198565348', NULL, 'FG001', '0', 0.00000, 33.00000, 0.00000, 1.00000, 2.900000, 95.700000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '001', '001', '', 'PC2012051019752545', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012145299571009', 3, 'FG0010', '0', 3.00000, 3.00000, 0.00000, 1.00000, 3.900000, 11.700000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '002', '002', '', 'PC2012105310053574', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012145299979810', 4, 'FG0012', '0', 10.00000, 10.00000, 0.00000, 1.00000, 9.000000, 90.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '009', '009', '', 'PC2012105310053574', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012154851515549', 2, 'FG003', '0', 10.00000, 10.00000, NULL, 1.00000, 3.000000, 30.000000, '生产批号', '灭菌批号', '2020-12-15', '2020-12-31', '', '', '合格', '合格', '合格', '有', '合格', '003', '003', NULL, 'PC2012149953100501', 0, NULL, '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012154851499751', NULL, 'FG002', '0', 43.00000, 43.00000, 0.00000, 1.00000, 20.000000, 860.000000, '', '', '2020-12-14', '2020-12-14', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012149953100501', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012159810048485', 1, 'FG001', '0', 10.00000, 10.00000, NULL, NULL, 5.000000, 50.000000, '', '', NULL, NULL, '', '', '合格', '合格', '合格', '有', '合格', '001', '001', NULL, 'PC2012154857525157', 0, NULL, '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012159810051989', 2, 'FG002', '0', 10.00000, 10.00000, NULL, NULL, 7.000000, 70.000000, '', '', NULL, NULL, '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', NULL, 'PC2012154857525157', 0, NULL, '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155499484997', 1, 'FG001', '0', 15.00000, 15.00000, 0.00000, 15.00000, 5.000000, 25.000000, '生产批号', '灭菌批号', '2020-12-11', '2021-01-27', '有', '通关文号', '合格', '合格', '合格', '有', '合格', '001', '001', '备注', 'PC2012159751501005', 1, '存储条件', '追溯号');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155499525653', 2, 'FG003', '0', 3.00000, 3.00000, 0.00000, 1.00000, 3.000000, 9.000000, '生产批号', '灭菌批号', '2020-12-15', '2020-12-31', '有', '1231321', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012159751501005', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155499545598', 3, 'FG004', '0', 4.00000, 4.00000, 0.00000, 1.00000, 10.000000, 10.000000, '生产批号', '灭菌批号', '2020-12-12', '2020-12-28', '有', '通关单号', '合格', '合格', '合格', '有', '合格', '009', '009', '备注', 'PC2012159751501005', 0, '存储条件', '追溯号');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155597499853', 1, 'FG001', '0', 1.00000, 1.00000, 0.00000, 1.00000, 5.000000, 5.000000, '', '', '2020-12-15', '2020-12-15', '有', '', '合格', '合格', '合格', '有', '合格', '001', '001', '', 'PC2012159857525455', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155597535197', 2, 'FG002', '0', 5.00000, 5.00000, 0.00000, 1.00000, 7.000000, 35.000000, '', '', '2020-12-14', '2020-12-14', '有', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012159857525455', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155597545610', 3, 'FG003', '0', 20.00000, 20.00000, 0.00000, 1.00000, 3.000000, 60.000000, '生产批号', '灭菌批号', '2020-12-14', '2020-12-31', '有', '', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012159857525455', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012155399545153', 1, 'FG0012', '0', 100.00000, 100.00000, 100.00000, 100.00000, 9.000000, 900.000000, '20201215', '', '2020-12-15', '2020-12-31', '有', '', '合格', '合格', '合格', '有', '合格', '009', '009', '', 'PC2012155251971005', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012185648545797', 1, 'FG001', '0', 30.25000, 30.25000, 0.00000, 2.00000, 12.680000, 383.570000, '', '', '2020-12-17', '2020-12-17', '', '', '合格', '合格', '合格', '有', '合格', '001', '001', '', 'PC2012185152565552', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012185648565298', 2, 'FG002', '0', 22.00000, 22.00000, 0.00000, 3.00000, 15.600000, 343.200000, '', '', '2020-12-18', '2020-12-18', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012185152565552', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012181029854564', 1, 'FG001', '0', 10.00000, 10.00000, 0.00000, 1.00000, 5.000000, 50.000000, '', '', NULL, NULL, '', '', '合格', '合格', '合格', '有', '合格', '001', '001', '', 'PC2012185050551021', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012181029856554', 2, 'FG002', '0', 10.00000, 10.00000, 0.00000, 1.00000, 7.000000, 70.000000, '', '', NULL, NULL, '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012185050551021', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012181029856554', 3, 'FG002', '0', 10.00000, 10.00000, 0.00000, 1.00000, 7.000000, 70.000000, '', '', NULL, NULL, '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012185050551021', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012191024997505', 1, 'FG001', '0', 35.75000, 35.75000, 0.00000, 3.00000, 15.580000, 556.985000, '', '', '2020-12-18', '2020-12-18', '', '', '合格', '合格', '合格', '有', '合格', '001', '001', '', 'PC2012191015610057', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012191024998995', 2, 'FG002', '0', 50.00000, 50.00000, 0.00000, 2.00000, 12.800000, 640.000000, '', '', '2020-12-19', '2020-12-19', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012191015610057', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012195250975749', 1, 'FG001', '0', 24.50000, 24.50000, 0.00000, 2.00000, 10.800000, 264.600000, '', '', '2020-12-18', '2020-12-18', '', '', '合格', '合格', '合格', '有', '合格', '001', '001', '', 'PC2012199752495256', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012219957535097', 1, 'FG002', '0', 50.00000, 50.00000, 0.00000, 2.00000, 12.680000, 634.000000, '', '', '2020-12-21', '2020-12-21', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012215250505710', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012141025252995', 0, 'FG002', '0', 1.00000, 1.00000, 0.00000, 1.00000, 7.000000, 7.000000, '', '灭菌批号', '2020-12-14', '2020-12-31', '药检报告', '通过文号', '1', '1', '1', '1', '1', '003', '003', '', 'PC2012141011009810', 0, '', '追溯号');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012141025252995', 0, 'FG002', '0', 1.00000, 1.00000, 0.00000, 1.00000, 7.000000, 7.000000, '', '', NULL, NULL, '药检报告', '通过文号', '1', '1', '1', '1', '1', '003', '003', '', 'PC2012141011009810', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012141025256501', 0, 'FG0012', '0', 1.00000, 1.00000, 0.00000, 1.00000, 9.000000, 9.000000, '', '', NULL, NULL, '', '', '1', '1', '1', '1', '1', '009', '009', '', 'PC2012141011009810', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012225550489897', 1, 'FG002', '0', 30.00000, 30.00000, 0.00000, 2.00000, 7.200000, 216.000000, '', '', '2020-12-21', '2020-12-21', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012225057539810', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012235755102565', 1, 'FG002', '盒', 100.00000, 100.00000, 0.00000, 0.00000, 4.200000, 420.000000, '20201222', '', '2020-12-22', '2020-12-22', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012235248539955', 0, '', '');
INSERT INTO `qfyu_goods_check_accept_details` VALUES ('CY2012235755102565', 2, 'GD0022', '盒', 300.00000, 300.00000, 0.00000, 0.00000, 4.950000, 1485.000000, '20201223', '20201223-22', '2020-12-23', '2021-12-23', '药检报告', '通过文号', '合格', '合格', '合格', '有', '合格', '003', '003', '', 'PC2012235248539955', 0, '', '20201223-11');

-- ----------------------------
-- Table structure for qfyu_goods_check_default
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_goods_check_default`;
CREATE TABLE `qfyu_goods_check_default`  (
  `gsp_type` tinyint(1) NOT NULL COMMENT 'gsp验收类型',
  `batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号',
  `sterilization_batch` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `verify_report` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '药检报告',
  `pass_gate_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通关文号',
  `register_card_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '注册证号',
  `certificato` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合格证',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '外观质量',
  `package_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '包装情况',
  `label_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签状况',
  `directions` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '说明书状况',
  `check_verdict` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验收结论',
  `checker` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验货人',
  `accepter` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '质量验收-默认设置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_goods_check_default
-- ----------------------------
INSERT INTO `qfyu_goods_check_default` VALUES (1, '', '', '', '', '', '合格证', '合格', '合格', '合格', '有', '合格', '001', '001', '2020-12-14 17:25:12');
INSERT INTO `qfyu_goods_check_default` VALUES (2, '', '', '药检报告', '通过文号', '', '合格证', '合格', '合格', '合格', '有', '合格', '003', '003', '2020-12-14 17:24:04');
INSERT INTO `qfyu_goods_check_default` VALUES (3, '生产批号', '灭菌批号', '', '', '注册证号', '合格证', '合格', '合格', '合格', '有', '合格', '003', '003', '2020-12-14 17:24:25');
INSERT INTO `qfyu_goods_check_default` VALUES (4, '', '', '', '', '', '合格证', '合格', '合格', '合格', '有', '合格', '009', '009', '2020-12-14 17:25:24');
INSERT INTO `qfyu_goods_check_default` VALUES (5, '', '', '', '', '', '合格证', '合格', '合格', '合格', '有', '合格', '009', '009', '2020-12-14 17:25:35');
INSERT INTO `qfyu_goods_check_default` VALUES (6, '', '', '', '', '', '合格证', '合格', '合格', '合格', '有', '合格', '002', '002', '2020-12-14 17:25:44');

-- ----------------------------
-- Table structure for qfyu_goods_photo
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_goods_photo`;
CREATE TABLE `qfyu_goods_photo`  (
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `img_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片名称',
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '采集日期',
  `validity_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期',
  `creator` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采集人',
  `updated_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `updated_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '状态 默认0正常 1已删除',
  INDEX `goods_code`(`goods_code`) USING BTREE,
  INDEX `qfyu_goods_photo_creator`(`creator`) USING BTREE,
  CONSTRAINT `qfyu_goods_photo_creator` FOREIGN KEY (`creator`) REFERENCES `qfyu_employee` (`code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品证照' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_goods_photo
-- ----------------------------
INSERT INTO `qfyu_goods_photo` VALUES ('FG001', 'SCQYYYZZ', '/uploads/first_goods/FG001_SCQYYYZZ.png', '2020-10-26 08:48:57', '2020-10-26 08:48:32', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG001', 'GMP', '/uploads/first_goods/FG001_GMP.jpg', '2020-10-26 09:23:37', '2020-10-26 09:22:34', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG003', 'SCQYYYZZ', '/uploads/first_goods/FG003_SCQYYYZZ.jpg', '2020-10-26 10:12:18', '2020-10-26 10:11:07', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG003', 'GMP', '/uploads/first_goods/FG003_GMP.jpg', '2020-10-26 10:12:35', '2020-11-09 14:44:03', '009', '009', '2020-11-09 14:44:15', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG003', 'SCXKZ', '/uploads/first_goods/FG003_SCXKZ.jpg', '2020-10-26 10:12:51', '2020-10-26 10:11:07', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG002', 'SCQYYYZZ', '/uploads/first_goods/FG002_SCQYYYZZ.jpg', '2020-10-26 11:14:59', '2020-10-26 11:10:53', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG002', 'GMP', '/uploads/first_goods/FG002_GMP.jpg', '2020-10-26 11:15:19', '2020-10-26 11:10:53', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG002', 'SCXKZ', '/uploads/first_goods/FG002_SCXKZ.png', '2020-10-26 11:53:24', '2020-10-26 11:47:58', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG005', 'SCXKZ', '/uploads/first_goods/FG005_SCXKZ.png', '2020-10-26 16:49:40', NULL, '001', '009', '2020-11-09 16:52:56', 1);
INSERT INTO `qfyu_goods_photo` VALUES ('FG006', 'SCQYYYZZ', '/uploads/first_goods/FG006_SCQYYYZZ.png', '2020-10-27 08:56:31', '2020-10-27 08:49:30', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG006', 'GMP', '/uploads/first_goods/FG006_GMP.png', '2020-10-27 08:56:46', '2020-10-27 08:49:30', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG006', 'SCXKZ', '/uploads/first_goods/FG006_SCXKZ.jpg', '2020-10-27 08:57:02', '2020-10-27 08:49:30', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG008', 'SCQYYYZZ', '/uploads/first_goods/FG008_SCQYYYZZ.jpg', '2020-10-27 17:46:18', '2020-12-10 00:00:00', '001', '009', '2020-12-09 17:33:14', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG004', 'SCQYYYZZ', '/uploads/first_goods/FG004_SCQYYYZZ.jpg', '2020-10-28 11:04:56', '2020-11-09 14:49:18', '009', '009', '2020-11-09 14:57:20', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG004', 'GMP', '/uploads/first_goods/FG004_GMP.png', '2020-11-09 11:20:52', '2020-11-09 15:37:44', '009', '009', '2020-11-09 16:08:07', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG004', 'ZLZS', '/uploads/first_goods/FG004_ZLZS.jpg', '2020-11-09 11:46:14', '2020-11-09 16:10:54', '009', '009', '2020-11-09 16:11:20', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG004', 'ZCSB', '/uploads/first_goods/FG004_ZCSB.jpg', '2020-11-09 14:24:17', '2020-11-09 15:37:44', '009', '009', '2020-11-09 16:08:44', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG0010', 'SCQYYYZZ', '/uploads/first_goods/FG0010_SCQYYYZZ.jpg', '2020-11-09 16:15:44', '2020-11-09 16:20:57', '009', '009', '2020-11-09 16:21:19', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG0010', 'GMP', '/uploads/first_goods/FG0010_GMP.png', '2020-11-09 16:21:08', '2020-11-09 16:20:57', '009', '009', '2020-11-09 16:21:10', 1);
INSERT INTO `qfyu_goods_photo` VALUES ('FG0011', 'SCQYYYZZ', '/uploads/first_goods/FG0011_SCQYYYZZ.jpg', '2020-11-10 14:09:45', '2020-11-10 13:42:20', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG0012', 'SCXKZ', '/uploads/first_goods/FG0012_SCXKZ.jpg', '2020-11-10 15:49:35', '2020-12-11 00:00:00', '009', '009', '2020-12-10 10:41:47', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG005', 'SCQYYYZZ', '/uploads/first_goods/FG005_SCQYYYZZ.jpg', '2020-11-19 16:41:09', '2020-11-19 16:40:00', '009', '009', '2020-12-07 15:42:42', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('GD0019', 'GMP', '/uploads/first_goods/GD0019_GMP.jpg', '2020-12-05 14:16:57', '2020-12-05 14:16:03', '001', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('GD0017', 'SCQYYYZZ', '/uploads/first_goods/GD0017_SCQYYYZZ.jpg', '2020-12-07 15:38:24', '2020-12-07 15:02:38', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG008', 'GMP', '/uploads/first_goods/FG008_GMP.jpg', '2020-12-09 17:04:39', '2020-12-10 00:00:00', '009', '009', '2020-12-09 17:32:01', 0);
INSERT INTO `qfyu_goods_photo` VALUES ('FG008', 'SCXKZ', '/uploads/first_goods/FG008_SCXKZ.jpg', '2020-12-09 17:33:31', '2020-12-10 00:00:00', '009', NULL, NULL, 0);
INSERT INTO `qfyu_goods_photo` VALUES ('GD0016', 'GMP', '/uploads/first_goods/GD0016_GMP.jpg', '2020-12-10 10:39:31', '2020-12-11 00:00:00', '009', NULL, NULL, 0);

-- ----------------------------
-- Table structure for qfyu_goods_rejection
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_goods_rejection`;
CREATE TABLE `qfyu_goods_rejection`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据编号',
  `orderid_date` date NULL DEFAULT NULL COMMENT '单据日期',
  `depart_id` int(10) NULL DEFAULT NULL COMMENT '开单部门',
  `supplier_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `supplier_depart` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `supplier_sale` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售人',
  `supplier_contact` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方联系人',
  `transport_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输方式',
  `car_addr` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输到站',
  `invoice` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '进货凭证',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '进货地址',
  `salesman` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编号',
  `come_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源单号',
  `create_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `checker_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员',
  `checker_date` datetime(0) NULL DEFAULT NULL COMMENT '复核日期',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) NULL DEFAULT 0 COMMENT '单据状态 默认0未审核 1已审核',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '来货拒收' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_goods_rejection
-- ----------------------------
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012031001005110', '2020-12-03', NULL, 'FS003', 'FS003', 'FS003', 'FS003', NULL, NULL, NULL, NULL, '负责人', 'PC2012015299505655', '009', '2020-12-03 14:47:09', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012035199504999', '2020-12-03', NULL, 'FS003', 'FS003', 'FS003', 'FS003', NULL, NULL, NULL, NULL, '负责人', 'PC2012015299505655', '009', '2020-12-03 18:42:11', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012045297505499', '2020-12-04', NULL, 'FS003', 'FS003', 'FS003', 'FS003', NULL, NULL, NULL, NULL, '负责人', 'PC2012015299505655', '009', '2020-12-04 08:38:28', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012045352505798', '2020-12-04', NULL, 'FS003', 'FS003', 'FS003', 'FS003', NULL, NULL, NULL, NULL, '负责人', 'PC2012015299505655', '009', '2020-12-04 08:39:17', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012049999579810', '2020-12-04', NULL, 'FS003', 'FS003', 'FS003', 'FS003', NULL, NULL, NULL, NULL, '负责人', 'PC2012015299505655', '009', '2020-12-04 08:35:08', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012141025254579', '2020-12-14', 1, 'FS003', '5535435', '张三歌', '张三歌', NULL, NULL, NULL, NULL, '004', 'PC2012141011009810', '009', '2020-12-14 10:35:27', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012145299565549', '2020-12-14', 1, 'FS007', '', '', '', NULL, NULL, NULL, NULL, '003', 'PC2012105310053574', '009', '2020-12-14 10:41:08', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012154851509998', '2020-12-15', 1, 'FS003', '5535435', '张三歌', '张三歌', NULL, NULL, NULL, NULL, '004', 'PC2012149953100501', '009', '2020-12-15 10:14:56', NULL, NULL, '*来货登记时直接拒收*', 0);
INSERT INTO `qfyu_goods_rejection` VALUES ('LJ2012155097511021', '2020-12-15', 1, '1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'PC2012155251971005', '009', '2020-12-15 16:20:34', NULL, NULL, '质量验收时直接拒收', 0);

-- ----------------------------
-- Table structure for qfyu_goods_rejection_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_goods_rejection_details`;
CREATE TABLE `qfyu_goods_rejection_details`  (
  `r_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `goods_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `come_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '订货数量',
  `rejection_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '拒收数量',
  `rejection_remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拒收理由',
  `money` decimal(15, 6) NULL DEFAULT NULL COMMENT '金额',
  `batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号',
  `check_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '抽检数量',
  `check_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '检验标准',
  `supplier_goods_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方产品编号',
  `production_end_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期至',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `emp_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务部负责人编号',
  `emp_remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务部负责人意见',
  `qc_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理部负责人编号',
  `qc_remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理部负责人意见'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '来货拒收-明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_goods_rejection_details
-- ----------------------------
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012031001005110', 'FG001', '0', 25.00000, 5.00000, NULL, 140.000000, 'FG001', 25.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012035199504999', 'FG001', '0', 25.00000, 5.00000, NULL, 140.000000, 'FG001', 25.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012045297505499', 'FG001', '0', 25.00000, 5.00000, NULL, 140.000000, 'FG001', 25.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012045352505798', 'FG001', '0', 25.00000, 5.00000, NULL, 140.000000, 'FG001', 25.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012049999579810', 'FG001', '0', 25.00000, 5.00000, NULL, 140.000000, 'FG001', 25.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012141025254579', 'FG002', '0', 2.00000, 1.00000, NULL, 7.000000, 'FG002', 2.00000, NULL, NULL, '2020-12-31 00:00:00', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012141025254579', 'FG002', '0', 2.00000, 1.00000, NULL, 7.000000, 'FG002', 2.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012141025254579', 'FG0012', '0', 2.00000, 1.00000, '', 9.000000, 'FG0012', 2.00000, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012145299565549', 'FG004', '0', 11.00000, 1.00000, NULL, 25.000000, 'FG004', 11.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012145299565549', 'FG004', '0', 4.00000, 3.00000, '', 30.000000, 'FG004', 4.00000, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012145299565549', 'FG0010', '0', 4.00000, 1.00000, '', 3.900000, 'FG0010', 4.00000, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012145299565549', 'FG0012', '0', 20.00000, 10.00000, '', 90.000000, 'FG0012', 20.00000, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012154851509998', 'FG002', '0', 40.00000, 5.00000, NULL, 100.000000, 'FG002', 40.00000, NULL, NULL, '2020-12-14 00:00:00', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012154851509998', 'FG003', '0', 20.00000, 10.00000, '', 30.000000, 'FG003', 20.00000, NULL, '', '2020-12-31 00:00:00', NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_goods_rejection_details` VALUES ('LJ2012155097511021', 'FG0012', '0', 100.00000, 100.00000, NULL, 900.000000, '20201215', NULL, NULL, NULL, '2020-12-31 00:00:00', NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_gsp_first_approval
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_gsp_first_approval`;
CREATE TABLE `qfyu_gsp_first_approval`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '关联首营品种、企业表orderid字段',
  `buyer_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购负责人意见',
  `buyer_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购负责人',
  `buyer_date` datetime(0) NULL DEFAULT NULL COMMENT '采购负责人审批日期 ',
  `buyer_status` tinyint(1) NULL DEFAULT 0 COMMENT '采购负责人审批状态 默认0 未审批 1、审批通过 2、审批不通过',
  `qa_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理部负责人意见',
  `qa_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理部负责人',
  `qa_date` datetime(0) NULL DEFAULT NULL COMMENT '质量管理部负责人审批日期 ',
  `qa_status` tinyint(1) NULL DEFAULT 0 COMMENT '质量管理部负责人审批状态 默认0 未审批 1、审批通过 2、审批不通过',
  `principal_reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量负责人意见',
  `principal_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量负责人',
  `principal_date` datetime(0) NULL DEFAULT NULL COMMENT '质量负责人审批日期 ',
  `principal_status` tinyint(1) NULL DEFAULT 0 COMMENT '质量负责人审批状态 默认0 未审批 1、审批通过 2、审批不通过',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '订单类型 默认1 首营品种  2 首营企业',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '首营品种、企业审批记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_gsp_first_approval
-- ----------------------------
INSERT INTO `qfyu_gsp_first_approval` VALUES (1, 'FG2010224897575257', '测试审批订单1、通过', '009', '2020-12-10 08:39:28', 1, '同意', '009', '2020-10-23 16:06:03', 1, '不同意', '009', '2020-10-23 17:09:42', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (2, 'FG2010235357100505', 'butongguo', '009', '2020-12-10 08:39:22', 1, '同意', '009', '2020-10-26 11:54:05', 1, '不同意', '009', '2020-10-26 11:54:47', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (3, 'FG2010235354994953', '同意', '009', '2020-12-10 08:39:16', 1, '同意', '009', '2020-10-23 15:53:25', 1, '同意', '009', '2020-10-23 18:08:25', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (4, 'FG2010265054559854', '同意', '009', '2020-12-10 08:39:08', 1, '不同意', '009', '2020-10-28 11:04:42', 1, '同意', '009', '2020-10-28 11:05:15', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (5, 'FG2010269797501001', '同意', '009', '2020-12-10 08:38:51', 1, '不同意', '009', '2020-11-16 17:01:15', 1, '同意', '009', '2020-11-16 17:01:24', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (6, 'FG2010261024953985', '不同意', '009', '2020-12-09 18:31:18', 1, '同意', '009', '2020-11-10 14:18:13', 1, '不同意', '009', '2020-11-10 14:19:09', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (7, 'FG2010265757575510', '同意', '009', '2020-12-09 17:35:30', 1, '同意', '001', '2020-10-27 17:46:47', 1, '同意', '001', '2020-10-27 17:47:21', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (9, 'FG2010275755485199', '同意', '009', '2020-12-10 08:39:34', 1, '12', '001', '2020-10-27 17:27:40', 1, '同意', '001', '2020-10-27 17:36:36', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (10, 'FS2010215056521021', '同意', '001', '2020-10-27 16:11:51', 1, '不同意', '001', '2020-10-27 17:12:42', 1, '同意', '001', '2020-10-27 17:12:50', 1, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (11, 'FS2010219854535197', '审批通过', '001', '2020-10-27 17:20:41', 1, '同意', '001', '2020-10-27 17:20:52', 1, '同意', '001', '2020-10-27 17:21:10', 1, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (12, 'FS2010211025651495', '同意', '001', '2020-10-30 18:20:26', 1, '同意', '001', '2020-10-30 18:23:37', 1, '同意', '001', '2020-10-30 18:59:44', 1, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (13, 'FG2010295455102101', '同意', '009', '2020-12-07 14:57:57', 1, '同意', '009', '2020-11-10 14:35:57', 1, '同意', '009', '2020-11-10 14:36:04', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (14, 'FS2010209955565751', '同意', '001', '2020-10-30 19:00:14', 1, '同意', '001', '2020-10-30 19:00:21', 1, '同意', '001', '2020-10-30 19:00:29', 1, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (15, 'FS2010215010050100', NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, NULL, NULL, NULL, 0, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (16, 'FS2010231004898102', '同意', '001', '2020-11-27 14:45:01', 1, '质量管理部负责人意见同意', '001', '2020-11-27 14:46:32', 1, '同意', '001', '2020-11-27 14:46:40', 1, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (17, 'FG2011104999485597', '同意', '009', '2020-12-10 08:39:40', 1, '同意', '001', '2020-11-10 14:14:18', 1, '同意', '009', '2020-11-10 14:19:52', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (18, 'FG2011105054101571', '同意', '009', '2020-12-10 08:39:45', 1, '同意', '009', '2020-11-10 15:50:12', 1, '同意', '009', '2020-11-10 15:50:19', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (19, 'FG2011164810157974', '同意', '009', '2020-12-09 17:41:26', 1, '同意', '009', '2020-11-16 16:59:37', 1, '同意', '009', '2020-11-16 16:59:44', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (20, 'FS2010209898101995', '同意', '001', '2020-11-26 15:39:49', 1, '同意', '001', '2020-11-26 15:42:43', 1, '同意', '001', '2020-11-26 15:44:14', 1, 2);
INSERT INTO `qfyu_gsp_first_approval` VALUES (21, 'FG2012055752100564', '同意', '009', '2020-12-10 08:39:51', 1, '同意', '009', '2020-12-07 09:25:16', 1, '同意', '009', '2020-12-07 09:25:22', 1, 1);
INSERT INTO `qfyu_gsp_first_approval` VALUES (22, 'FG2012079951575055', '同意', '009', '2020-12-10 08:39:56', 1, '不同意', '009', '2020-12-10 08:48:16', 2, NULL, NULL, NULL, 0, 1);

-- ----------------------------
-- Table structure for qfyu_gsp_first_enterprise
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_gsp_first_enterprise`;
CREATE TABLE `qfyu_gsp_first_enterprise`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `orderid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单据号',
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业名称',
  `mnemonic_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '助记码',
  `area` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业地址',
  `tel` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `fax` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '传真',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'E-mail',
  `post_code` int(6) NULL DEFAULT NULL COMMENT '邮编\r\n',
  `enterprise_leader` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业负责人',
  `tech_mans` int(10) NULL DEFAULT 0 COMMENT '技术人员数',
  `business_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业执照编号',
  `business_scope` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '经营范围',
  `business_issuing_authority` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发照机关',
  `business_issue_date` datetime(0) NULL DEFAULT NULL COMMENT '发照日期',
  `business_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '营业执照有效期',
  `attorney_book` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法人委托书',
  `attorney_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '委托书有效期',
  `business_leader` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务负责人',
  `business_leader_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务负责人code',
  `contract_start_date` datetime(0) NULL DEFAULT NULL COMMENT '合同开始时间',
  `contract_end_date` datetime(0) NULL DEFAULT NULL COMMENT '合同到期时间',
  `enterprise_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业类型',
  `output_year` decimal(10, 2) NULL DEFAULT NULL COMMENT '年产值（万元）',
  `major_honors` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主要荣誉',
  `supply_var` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拟供品种',
  `drug_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '药品经营许可证号',
  `drug_issuing_authority` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发证机关',
  `drug_issue_date` datetime(0) NULL DEFAULT NULL COMMENT '发证日期',
  `drug_validity_date` datetime(0) NOT NULL COMMENT '有效期至',
  `apparatus_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '医疗器械经营许可证号',
  `apparatus_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '医疗器械经营许有效期至',
  `food_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '食品经营许可证号',
  `food_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '食品经营许有效期至',
  `health_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保健品经营许可证号',
  `health_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '保健品经营许有效期至',
  `organization_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织机构代码证号',
  `organization_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '组织机构代码有效期至',
  `legal_person` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '法人代表',
  `registered_capital` decimal(12, 2) NULL DEFAULT NULL COMMENT '注册资金',
  `economic_nature` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经济性质',
  `operation_mode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经营方式',
  `contact` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系人',
  `card_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系人身份证',
  `gsp_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'GSP证书编号',
  `gsp_validity_date` datetime(0) NOT NULL COMMENT 'GSP证书有效期至',
  `gmp_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP认证范围',
  `gmp_two_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP2证书编号',
  `gmp_two_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP2认证范围',
  `gmp_two_validity_date` datetime(0) NULL DEFAULT NULL COMMENT 'GMP2证书有效期至',
  `gmp_three_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP3证书编号',
  `gmp_three_range` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP3认证范围',
  `gmp_three_validity_date` datetime(0) NULL DEFAULT NULL COMMENT 'GMP3证书有效期至',
  `bank_area` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '开户行',
  `bank_account` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账号',
  `tax_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '税号',
  `is_quality_agreement` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否提交质量协议保证书',
  `quality_validity_date` datetime(0) NOT NULL COMMENT '质量协议保证书有效期',
  `ddkindid` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '自定义经营许可类别',
  `depart_id` int(10) UNSIGNED NOT NULL COMMENT '申请部门id',
  `depart_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '申请部门名称',
  `main_pro` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主要产品',
  `pro_advant` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品优势',
  `quality_organization` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业质量机构名称',
  `quality_system` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量保证体系',
  `mana_system` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理与制度情况',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者code',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `auditer` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核员',
  `audit_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `is_audit` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '默认未审核 1已审核',
  `is_approval` tinyint(1) NULL DEFAULT 0 COMMENT '默认未审批 1已审批',
  `is_transfer` tinyint(1) NULL DEFAULT NULL COMMENT '默认未转供应商信息 1已转',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `re_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `supplier_code`(`supplier_code`) USING BTREE,
  UNIQUE INDEX `orderid`(`orderid`) USING BTREE,
  INDEX `apply_depart`(`depart_id`) USING BTREE,
  CONSTRAINT `qfyu_gsp_first_enterprise_ibfk_1` FOREIGN KEY (`depart_id`) REFERENCES `qfyu_depart` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '首营企业' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_gsp_first_enterprise
-- ----------------------------
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (1, 'FS2010209898101995', 'FS001', '你哈佛教发送到发送到', 'NHFJFSDFSD', '5345热特特人', '', '', '', 4864, ' 热天 ', NULL, '特特热太热', '个人提供热', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', NULL, '', ' ', '特热太热', '', NULL, '2020-10-17 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', '太热 ', ' 特然太热 ', '特瑞特人', '2020-10-23 00:00:00', '', '', '', NULL, '', '', NULL, '特热太热', '特瑞特人', '特瑞特人', 0, '2020-10-23 00:00:00', '2', 1, '', NULL, NULL, NULL, NULL, NULL, '001', NULL, '001', '2020-11-21 10:30:00', 1, 1, NULL, '2020-10-20 16:22:19', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (2, 'FS2010209955565751', 'FS002', '企业名称12', 'QYMC12', '企业资质156156', '', '', '', 568974, '发生地方都是', NULL, '541461651651', '第三方是否水电费', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', NULL, '', '', '发送到发送到', '', NULL, '2020-10-30 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 1.25, '', '', '是的范德萨', '489465161651', '分手大师', '2020-10-21 00:00:00', '', '', '', NULL, '', '', NULL, '发生地方都是', '发送到发送到', '8565161651', 0, '2020-10-23 00:00:00', '1', 7, '', NULL, NULL, NULL, NULL, NULL, '001', NULL, '001', '2020-10-30 19:00:00', 1, 1, NULL, '2020-10-20 18:19:08', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (3, 'FS2010211025651495', 'FS003', '企业名称1', 'QYMC1', '企业地址1', '135159156161', '161651', '16516516', 123584, '451541', NULL, '56161165156', '165156161616', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', NULL, '', '', '15415616', '', NULL, '2020-10-31 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 1.25, '', '', '14515', '165165', '49849', '2020-10-31 00:00:00', '', '', '', NULL, '', '', NULL, '161', '156161', '165111616', 0, '2020-10-31 00:00:00', '3', 7, '', NULL, NULL, NULL, NULL, NULL, '001', NULL, '001', '2020-10-27 18:55:00', 1, 1, NULL, '2020-10-21 08:51:59', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (4, 'FS2010215010050100', 'FS004', '企业名称1', 'QYMC1', '企业地址1', '135159156161', '161651', '16516516', 896545, '451541', NULL, '56161165156', '165156161616', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', NULL, '', '', '15415616', '', NULL, '2020-10-31 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 1.25, '', '', '14515', '165165', '49849', '2020-10-31 00:00:00', '', '', '', NULL, '', '', NULL, '161', '156161', '165111616', 0, '2020-10-31 00:00:00', '3', 8, '', NULL, NULL, NULL, NULL, NULL, '001', NULL, '001', '2020-11-02 16:36:00', 1, 0, NULL, '2020-10-21 09:13:54', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (5, 'FS2010215056521021', 'FS005', '企业名称1', 'QYMC1', '企业地址1', '135159156161', '161651', '16516516', 687655, '451541', NULL, '56161165156', '165156161616', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', NULL, '', '', '15415616', '', NULL, '2020-10-31 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 1.25, '', '', '14515', '165165', '49849', '2020-10-31 00:00:00', '', '', '', NULL, '', '', NULL, '161', '156161', '165111616', 0, '2020-10-31 00:00:00', '2', 8, '', NULL, NULL, NULL, NULL, NULL, '001', NULL, '001', '2020-10-27 11:02:00', 1, 1, NULL, '2020-10-21 09:19:14', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (6, 'FS2010219854535197', 'FS006', '深圳庆丰裕信息科技有限公司', 'SQFYXXKJYXGS', '深圳龙华大为商务时空', '', '', '', 4564, '李总', NULL, '4201465161616411', '粉丝滤镜福克斯交电话费快乐圣诞节雷锋精神来得及发零售价的', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', NULL, '', '', '付款交水电费开始打飞机凉快圣诞节', '', NULL, '2020-10-31 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 1.25, '', '', '15156516', '42302165165165161', '581465146516', '2020-10-31 00:00:00', '', '', '', NULL, '', '', NULL, '中国银行', '62016516516161651', '184164646416416', 0, '2020-10-31 00:00:00', '3', 7, '', NULL, NULL, NULL, NULL, NULL, '001', NULL, '001', '2020-10-27 17:20:00', 1, 1, NULL, '2020-10-21 10:21:15', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (7, 'FS2010231004898102', 'FS007', '绕弯儿翁二', 'RWEWE', '热热翁', '', '', '', 0, '热污染', 0, '312313', '1321312', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '2', 0.00, '', '', '3123213', '', NULL, '2020-10-31 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 0.00, '', '', '123', '430722199802086126', '3123', '2020-10-31 00:00:00', '', '', '', NULL, '', '', NULL, '1323', '3123', '123', 0, '2020-10-31 00:00:00', '1', 7, '', '', '', '', '', '', '001', NULL, '001', '2020-11-06 11:33:00', 1, 1, NULL, '2020-10-23 18:52:13', NULL);
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (8, 'FS2010235756579854', 'FS008', '35345', '35345', '5345345', '1351854151', '', '', 0, '345345', 0, '5345', '5345345', '', NULL, NULL, '', NULL, '小明', '005', NULL, NULL, '药品生产企业', 0.00, '', '', '5345345', '', NULL, '2020-10-30 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 0.00, '', '', '5345', '430722199812189863', '534534', '2020-10-31 00:00:00', '', '', '', NULL, '', '', NULL, '5345', '5345', '5345345', 0, '2020-10-23 00:00:00', '3', 3, '销售部', '', '', '', '', '', '001', '001', '', NULL, 0, 0, 0, '2020-10-23 18:59:53', '2020-12-16 16:23:37');
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (9, 'FS2011199852975350', 'FS009', '企业名称1', 'QYMC1', '企业地址2', '', '', '', 0, '于总', 0, '95461256161651', '营业执照经营范围', '', NULL, NULL, '', NULL, '', '', NULL, NULL, '商品经营企业', 0.00, '', '', '622156165165', '', NULL, '2020-11-28 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 0.00, '', '', '的冯', '430722199010086598', '1515166516565', '2020-11-28 00:00:00', '', '', '', NULL, '', '', NULL, '兴业银行卡', '622185416516516', '65116516566', 0, '2020-11-28 00:00:00', '4,3,99,100,101,2,54,55,56,57,58,59,60,61,62,63,64,65,66,67,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98', 4, '深圳观澜分部3', '', '', '', '', '', '001', '001', '', NULL, 0, 0, 0, '2020-11-19 16:53:31', '2020-12-16 16:28:06');
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (10, 'FS2011199748564848', 'FS0010', '企业名称12', 'QYMC1', '企业地址2', '', '', '', NULL, '于总', NULL, '95461256161651', '营业执照经营范围', '', NULL, NULL, '', NULL, '小米', '009', NULL, NULL, '2', NULL, '', '', '622156165165', '', NULL, '2020-11-28 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', NULL, '', '', '的冯', '430722199010086598', '1515166516565', '2020-11-28 00:00:00', '', '', '', NULL, '', '', NULL, '兴业银行卡', '622185416516516', '65116516566', 0, '2020-11-28 00:00:00', '4,3,99,100,101,2,54,55,56,57,58,59,60,61,62,63,64,65,66,67,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98', 4, '深圳观澜分部3', '', '', '', '', '', '001', '001', '', NULL, 0, 0, 0, '2020-11-19 16:54:18', '2020-12-04 15:51:09');
INSERT INTO `qfyu_gsp_first_enterprise` VALUES (11, 'FS2011194910048555', 'FS0011', '深圳庆丰裕', 'SZQFY', '勤奋路', '', '', '', 0, '李总', 0, '95416515165445', '营业执照经营范围', '', NULL, NULL, '', NULL, '', NULL, NULL, NULL, '1', 0.00, '', '', '414165651651', '', NULL, '2020-11-28 00:00:00', '', NULL, '', NULL, '', NULL, '', NULL, '', 0.00, '', '', '史蒂', '430722199010086598', '4454564161', '2020-11-26 00:00:00', '', '', '', NULL, '', '', NULL, '中国银行', '62218515616526549', '6516265', 0, '2020-11-28 00:00:00', '7,117,9,118,119', 4, '深圳观澜分部3', '', '', '', '', '', '001', NULL, NULL, NULL, 0, 0, NULL, '2020-11-19 17:01:53', NULL);

-- ----------------------------
-- Table structure for qfyu_gsp_first_goods
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_gsp_first_goods`;
CREATE TABLE `qfyu_gsp_first_goods`  (
  `orderid` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据编号',
  `depart_id` int(10) NULL DEFAULT NULL COMMENT '申请部门',
  `create_date` datetime(0) NOT NULL COMMENT '填报日期',
  `goods_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品名称',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通用名称',
  `en_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '英文名称',
  `dosage` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '剂型',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `specs` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规格',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品性能，作用描述',
  `pack_specs1` int(10) NULL DEFAULT NULL COMMENT '中包装规格',
  `pack_specs2` int(10) NULL DEFAULT NULL COMMENT '大包装规格',
  `quality_standards` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '质量标准',
  `standard_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '本位码',
  `approval_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '批准文号/注册证号',
  `approval_date` date NOT NULL COMMENT '批准文号/注册证号有效期',
  `kinds_id` int(10) NULL DEFAULT NULL COMMENT '许可经营大类id',
  `kinds_kid` int(10) NULL DEFAULT NULL COMMENT '许可经营小类id',
  `category_id` int(10) NULL DEFAULT NULL COMMENT '商品大类id',
  `function_id` int(10) NOT NULL COMMENT '商品功能类别id',
  `parent_fid` int(10) NULL DEFAULT NULL COMMENT '父级功能类别id',
  `top_fid` int(10) NULL DEFAULT NULL COMMENT '顶级功能类别id',
  `gsp_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'gsp验收类型',
  `origin` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产地',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '申请原因',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '单据状态 默认0未审核 1审核成功',
  `audit_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `order_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '单据审批状态 默认0未审批  1已审批(只有在各个部门负责人确认审批通过后更新为1)',
  `production` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '生产企业',
  `production_addr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '生产企业地址',
  `production_mouth` int(10) NOT NULL COMMENT '有效（使用）期（单位：月）',
  `gmp_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP证书号',
  `gmp_date` date NULL DEFAULT NULL COMMENT 'GMP认证时间',
  `gmp_end_date` date NULL DEFAULT NULL COMMENT 'GMP证书有效期',
  `factory_price` decimal(17, 5) NULL DEFAULT NULL COMMENT '出厂价',
  `buyer_price` decimal(17, 5) NULL DEFAULT NULL COMMENT '采购价',
  `trade_price` decimal(17, 5) NULL DEFAULT NULL COMMENT '批发价',
  `retail_price` decimal(17, 5) NULL DEFAULT NULL COMMENT '零售价',
  `storage_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '储存条件',
  `book` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出厂检验报告书',
  `license_key` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '许可证号',
  `license_date` date NULL DEFAULT NULL COMMENT '许可证号有效期',
  `business_license_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '营业执照号',
  `business_date` date NULL DEFAULT NULL COMMENT '营业执照有效期',
  `ht_date` date NULL DEFAULT NULL COMMENT '合同开始日期',
  `ht_end_date` date NULL DEFAULT NULL COMMENT '合同结束日期',
  `sample_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '样品批号',
  `sample_date` date NULL DEFAULT NULL COMMENT '样品有效期',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '制单人',
  `creator_date` datetime(0) NOT NULL COMMENT '制单时间',
  `reviser` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `reviser_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `new_state` tinyint(1) NULL DEFAULT 0 COMMENT '是否生成商品资料 默认0未生成 1已生成',
  `salesman` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员（采购员）',
  `salesman_date` datetime(0) NULL DEFAULT NULL COMMENT '业务员（采购员）申请时间',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '首营品种申请' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_gsp_first_goods
-- ----------------------------
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010224897575257', 7, '2020-10-22 17:56:16', '999感冒灵颗粒', 'FG001', '999感冒灵颗粒', '', '口服溶液', '盒', '10g*9袋', '解热镇痛。用于感冒引起的头痛', 1, 1, '合格', '91441300196021697M', '国药准字Z44021940', '2020-10-22', 2, NULL, 6, 32, NULL, NULL, '1', '惠州市', '首营品种', 1, '2020-12-09 17:42:33', 1, '惠州市九惠制药股份有限公司', '惠州市惠城区南岸路199号', 24, '1111', '2020-10-22', '2020-10-23', 10.00000, 10.00000, 10.00000, 10.00000, '常温储存', '有', '441300000016035', '2022-10-22', '91441300196021697M', NULL, '2020-10-22', '2020-10-23', '91441300196021697M', NULL, '001', '2020-10-22 18:06:34', '009', '2020-12-10 10:05:29', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010235354994953', 8, '2020-10-23 09:43:17', '健胃消食片（成人）', 'FG002', '健胃消食片（成人）', '', '滴鼻剂', '盒', '8片*4板', '健胃消食。用于脾胃虚弱所致的食积，症见不思饮食、嗳腐酸臭、脘腹胀满。', 1, 1, '合格', '6903757998054', '国药准字Z20055041', '2022-10-23', 1, 14, 18, 33, 25, 0, '2', '广州', '首营品种', 1, '2020-10-23 10:43:45', 1, '广州白云山和记黄埔中药有限公司', '广州市白云区沙太北路389号', 24, 'Z20055041', '2020-10-23', '2022-10-23', 6.00000, 7.00000, 8.00000, 9.00000, '阴凉储存', '', '77330303', '2022-10-23', '91440101773303038C', NULL, NULL, NULL, '20050048', '2022-10-23', '001', '2020-10-23 09:56:15', '009', '2020-12-10 10:06:07', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010235357100505', 8, '2020-10-23 09:08:37', '肾宝片(汇仁)', 'FG003', '肾宝片(汇仁)', '', '滴鼻剂', '盒', '0.7g*9片*14板', '调和阴阳，温阳补肾，扶正固本。用于腰腿酸痛，精神不振，夜尿频多，畏寒怕冷，妇女白带清稀。', 1, 1, '合格', 'B12002011692', '国药准字Z20080627', '2020-10-23', 3, 100, 1, 34, 25, 0, '3', '江西', '首营品种', 1, '2020-10-26 11:53:13', 1, '江西汇仁药业有限公司', '江西南昌小蓝经济技术开发区汇仁大道1266号', 24, 'B12002011692', '2020-10-23', '2020-10-24', 2.00000, 3.00000, 4.00000, 5.00000, '阴凉储存', '无', '73637362-7', NULL, '91360121736373627B', NULL, '2020-10-23', '2020-10-24', '2005143', '2022-10-23', '001', '2020-10-23 09:12:43', '009', '2020-12-10 10:06:29', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010261024953985', 3, '2020-10-26 14:59:43', '测试3', 'FG006', '测试3', '', '混悬剂', '袋', '测试3', '测试3', 1, 1, '测试3', '测试3', '测试3', '2020-10-26', NULL, NULL, 0, 37, 26, 0, '6', '', '测试3', 1, '2020-10-26 18:05:03', 1, '测试3', '测试3', 12, '测试3', '2020-10-20', '2020-10-26', 0.00000, 0.00000, 0.00000, 0.00000, '阴凉储存', '', '测试3', NULL, '测试3', NULL, NULL, NULL, '测试3', NULL, '009', '2020-10-26 15:00:32', '009', '2020-12-09 18:28:06', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010265054559854', 8, '2020-10-26 14:49:38', '测试', 'FG004', '测试', '', '搽剂', '袋', '111', '测试', 1, 1, '1111', '111', '1111', '2020-10-27', 1, 16, 2, 35, 25, 0, '4', '', '测试', 1, '2020-10-27 18:28:02', 1, '测试', '测试', 111, '1111', '2020-10-26', '2020-10-27', 0.00000, 0.00000, 0.00000, 0.00000, '冷藏储存', '', '111111', NULL, '11111', NULL, NULL, NULL, '1111', NULL, '009', '2020-10-26 14:54:13', '009', '2020-12-10 10:06:55', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010265757575510', 6, '2020-10-26 15:23:46', '31', 'FG008', '测试4', NULL, '搽剂', '瓶', '111', '31231', 1, 1, '11', '11', '12321', '2020-10-27', NULL, NULL, NULL, 38, NULL, NULL, '1', NULL, '3123', 1, '2020-12-09 17:38:41', 1, '测试', '3123', 11, '3123123', '2020-10-20', '2020-10-28', NULL, NULL, NULL, NULL, '常温储存', NULL, '213412', NULL, '123', NULL, NULL, NULL, '111', NULL, '009', '2020-10-26 15:36:09', '009', '2020-12-09 17:38:41', 1, NULL, NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010269797501001', 2, '2020-10-26 14:55:22', '测试2', 'FG005', '测试2', '', '酊剂', '袋', '11', '11', 1, 1, '111', '1', '111', '2020-10-27', NULL, NULL, NULL, 36, 26, 0, '5', '', '1111', 1, '2020-10-26 16:51:08', 1, '11', '11', 1, '11', '2020-10-26', '2020-10-29', 0.00000, 0.00000, 0.00000, 0.00000, '阴凉储存', '', '1', NULL, '111', NULL, NULL, NULL, '1', NULL, '009', '2020-10-26 14:56:02', '009', '2020-12-09 18:27:55', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010275755485199', 8, '2020-10-27 08:57:13', '12312', 'FG009', '123', '', '滴鼻剂', '千克', '3123', '312', 3123, 123, '3123', '312', '123', '2020-10-28', 3, NULL, 2, 39, 26, 0, '2', '213', '1323', 1, '2020-10-27 17:27:10', 1, '312', '3123', 123, '123', '2020-10-21', '2020-10-28', 12.00000, 13.00000, 213.00000, 13.00000, '阴凉储存', '123', '3123', '2021-05-05', '1231', '2020-10-28', '2020-10-13', '2020-10-28', '123', '2020-10-27', '009', '2020-10-27 08:58:54', '009', '2020-12-10 10:14:44', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2010295455102101', 6, '2020-10-29 17:02:17', 'J 75%酒精消毒液 P 500ml', 'FG0010', 'J 75%酒精消毒液 P 500ml', '', '7', '片', '500ml', '医用酒精主要用于消毒、杀菌', 1, 1, '312', '509059', '鲁卫消证字(2002)第0059号', '2020-10-29', 2, NULL, 2, 31, 0, NULL, '3', '山东', '首营', 1, '2020-12-07 14:57:32', 1, '山东利尔康医疗科技股份有限公司', '山东省德州市经济技术开发区利尔康路1号', 24, 'GMP123654789', '2020-10-29', '2020-10-30', 3.00000, 3.90000, 4.00000, 4.20000, '常温储存', '', '6926378910021', '2020-11-30', '91371400167306079Y', '2020-11-30', '2020-11-10', '2020-11-30', '200907', '2020-11-30', '009', '2020-10-29 17:15:34', '009', '2020-12-07 15:04:06', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2011104999485597', 1, '2020-11-10 05:42:19', '氨咖黄敏胶囊(特价)禾穗速效', 'FG0011', '氨咖黄敏胶囊(特价)禾穗速效', 'Ankahuangmin capsule (special price) hesui quick acting', '滴鼻剂', '盒', '12粒', '适用于缓解普通感冒及流行性感冒引起的发热、头痛、四肢酸痛、打喷嚏、流鼻涕、鼻塞、咽痛等症状。', 241, 1, '合格', '6900372205017', '国药准字H44024290', '2020-11-18', 2, 57, 5, 41, 26, 0, '4', '广州', '首营', 1, '2020-11-10 14:13:51', 1, '广州白云山光华制药股份有限公司', '广州市海珠区南石路一号', 24, 'GMP6548972', '2020-11-10', '2020-11-11', 3.12000, 3.24000, 3.33000, 5.15000, '阴凉储存', '有', 'XKZ654123', '2020-11-11', '914401011904851166', '2020-11-30', '2020-11-10', '2020-11-30', 'T00015', '2020-11-30', '009', '2020-11-10 14:05:21', '009', '2020-12-10 10:07:21', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2011105054101571', 1, '2020-11-10 15:27:40', '罗浮山百草油 P', 'FG0012', '罗浮山百草油 P', '', '滴鼻剂', '瓶', '3ml', '祛风解毒，消肿止痛。用于感冒头痛，虫蚊咬伤，无名肿毒，舟车眩晕。', 1, 1, '非常棒', 'b123456789', '国药准字Z44022355', '2020-11-30', 1, 13, 0, 49, 32, 25, '5', '广东', '首营', 1, '2020-11-10 15:49:40', 1, '广东罗浮山国药股份有限公司', '惠州市博罗县长宁镇广汕公路边岭排工业区(罗浮山药业城)', 24, 'GMP456987', '2020-11-10', '2020-11-30', 0.00000, 0.00000, 0.00000, 9.60000, '常温储存', '', '6926285816027', NULL, '91441300682485577H', NULL, NULL, NULL, '6926285816027', NULL, '009', '2020-11-10 15:37:22', '009', '2020-12-09 18:27:03', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2011164810157974', 4, '2020-11-16 13:48:40', '荆防颗粒', 'FG0013', '荆防颗粒', '', '口服溶液', '袋', '15g*20袋/包', '15g*20袋/包', 1, 1, '合格', 'B10234656', '国药准字Z51021290', '2020-11-16', 103, NULL, 6, 48, 27, 0, '6', '', '首营', 1, '2020-12-09 17:41:09', 1, '九寨沟天然药业集团有限责任公司', '四川省阿坝藏族羌族自治州九寨沟县', 24, 'GMP10257575', '2020-11-16', '2020-11-17', 0.00000, 0.00000, 0.00000, 18.00000, '常温储存', '', 'X10252527557', NULL, '91513200211350588K', NULL, NULL, NULL, 'Z51021290', NULL, '009', '2020-11-16 14:10:08', '009', '2020-12-10 10:13:28', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2012055752100564', 3, '2020-12-05 15:25:09', '商品名称', 'FG0014', '商品通用名称', '英文名称', '胶囊剂', '支', '规格', '商品性能成分、质量、用途疗效、副作用描述', 1, 1, '质量标准', '本位码', '批准文号/注册证号', '2020-12-05', 10, 105, 1, 37, 26, 0, '1', '产地', '申请原因', 1, '2020-12-05 16:56:13', 1, '生产企业', '生产企业详细地址', 12, 'GMP证书号', '2020-12-05', '2020-12-12', 1.00000, 2.00000, 3.00000, 4.00000, '阴凉储存', '出厂检验报告书', '许可证号', '2020-12-05', '营业执照号', '2020-12-05', '2020-12-05', '2020-12-06', '样品批号', '2020-12-05', '009', '2020-12-05 15:32:09', '009', '2020-12-09 18:28:52', 1, '', NULL);
INSERT INTO `qfyu_gsp_first_goods` VALUES ('FG2012079951575055', 3, '2020-12-07 10:10:13', '商品名称', 'FG0015', '通用名称', '英文名称', '口服溶液', '袋', '规格', '商品性能成分、质量、用途疗效、副作用描述', 1, 1, '质量标准', '本位码', '批准文号/注册证号', '2020-12-09', 3, 100, 2, 49, 32, 25, '1', '产地', '申请原因', 1, NULL, 0, '生产企业', '生产企业详细地址', 12, 'GMP证书号', '2020-12-07', '2020-12-09', 5.00000, 6.00000, 7.00000, 8.00000, '阴凉储存', '出厂检验报告书', '许可证号', '2020-12-08', '营业执照号', '2020-12-08', '2020-12-09', '2020-12-10', '样品批号', '2020-12-16', '009', '2020-12-07 10:26:04', '009', '2020-12-09 18:29:08', 0, '', NULL);

-- ----------------------------
-- Table structure for qfyu_inout_kind
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_inout_kind`;
CREATE TABLE `qfyu_inout_kind`  (
  `kind_id` int(10) NOT NULL,
  `kind_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `inout` tinyint(1) NOT NULL,
  PRIMARY KEY (`kind_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出入库类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_inout_kind
-- ----------------------------
INSERT INTO `qfyu_inout_kind` VALUES (-1, '期初库存', 1);
INSERT INTO `qfyu_inout_kind` VALUES (1, '采购入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (2, '采购赠送', 1);
INSERT INTO `qfyu_inout_kind` VALUES (3, '移库入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (4, '配送入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (5, '拆解入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (6, '组合入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (7, '销售退货', 1);
INSERT INTO `qfyu_inout_kind` VALUES (8, '盘盈入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (9, '原料采购入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (10, '生产加工入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (11, '直营配送入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (12, '配送退回(总部)', 1);
INSERT INTO `qfyu_inout_kind` VALUES (13, '报溢入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (14, '生产余料入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (15, '不合格入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (16, '锁定入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (17, '解锁入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (49, '其它入库', 1);
INSERT INTO `qfyu_inout_kind` VALUES (51, '销售出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (52, '销售赠送', -1);
INSERT INTO `qfyu_inout_kind` VALUES (53, '移库出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (54, '配送出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (55, '拆解出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (56, '组合出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (57, '采购退货', -1);
INSERT INTO `qfyu_inout_kind` VALUES (58, '盘亏出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (59, '解锁出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (60, '锁定出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (61, '药品报损', -1);
INSERT INTO `qfyu_inout_kind` VALUES (62, '原料抽检出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (63, '生产领料出库', -1);
INSERT INTO `qfyu_inout_kind` VALUES (99, '其它出库', -1);

-- ----------------------------
-- Table structure for qfyu_login_token
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_login_token`;
CREATE TABLE `qfyu_login_token`  (
  `token` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '管理员token',
  `uid` int(10) UNSIGNED NOT NULL COMMENT '管理员id',
  `login_time` int(10) NOT NULL COMMENT '登录时间',
  `out_time` int(10) NOT NULL COMMENT '过期时间',
  PRIMARY KEY (`token`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `login_time`(`login_time`) USING BTREE,
  CONSTRAINT `qfyu_login_token_ibfk_1` FOREIGN KEY (`uid`) REFERENCES `qfyu_operators` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '管理员 登录 token' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_login_token
-- ----------------------------
INSERT INTO `qfyu_login_token` VALUES ('0035cd87cb4a0432e1ed213193833b93', 7, 1602472592, 1605064592);
INSERT INTO `qfyu_login_token` VALUES ('03fcd1cb44075719fec70d2d75ec0137', 6, 1607934103, 1610526103);
INSERT INTO `qfyu_login_token` VALUES ('064c043d487dbc55068b95791ad2d2e0', 7, 1602474147, 1605066147);
INSERT INTO `qfyu_login_token` VALUES ('09f1ee9b00b8605e90f0315286fb0cb6', 7, 1602226103, 1604818103);
INSERT INTO `qfyu_login_token` VALUES ('0c172d015d3edd151e0a62138c87051b', 7, 1602472888, 1605064888);
INSERT INTO `qfyu_login_token` VALUES ('0c3841145084a0457f004c2bddbff7e6', 7, 1607931326, 1610523326);
INSERT INTO `qfyu_login_token` VALUES ('137970f1d041602ffabd27eed6ee2733', 7, 1602473843, 1605065843);
INSERT INTO `qfyu_login_token` VALUES ('13ab2883450366947b4629a82fbd28ee', 7, 1605491480, 1608083480);
INSERT INTO `qfyu_login_token` VALUES ('169270cb4d159428c3260511f5e04772', 7, 1602473179, 1605065179);
INSERT INTO `qfyu_login_token` VALUES ('1e9204e925ed8779b78cb00304174044', 7, 1602316042, 1604908042);
INSERT INTO `qfyu_login_token` VALUES ('1efa4b49d6c82b0f321afe9418fcdddd', 7, 1604399236, 1606991236);
INSERT INTO `qfyu_login_token` VALUES ('25c24b54306e9abd2532f25ab3a28b69', 7, 1606114549, 1608706549);
INSERT INTO `qfyu_login_token` VALUES ('25e677b3bdaa473c2eb97378b433d40d', 7, 1608369608, 1610961608);
INSERT INTO `qfyu_login_token` VALUES ('26f709cc07b9c09839e3bb17d1f89990', 7, 1608206416, 1610798416);
INSERT INTO `qfyu_login_token` VALUES ('292c6401844d7cce59d471dfbacb25d2', 7, 1607931132, 1610523132);
INSERT INTO `qfyu_login_token` VALUES ('2986135d555c4a40780d3fc77ec3a643', 7, 1602410173, 1605002173);
INSERT INTO `qfyu_login_token` VALUES ('2db86d24581e8adab59611664b108fdb', 7, 1602472814, 1605064814);
INSERT INTO `qfyu_login_token` VALUES ('2f8ceca5c94bccd2a70014cf5490f3b9', 7, 1602474109, 1605066109);
INSERT INTO `qfyu_login_token` VALUES ('326700614c0c5b7c7f4255ef4a71bb36', 7, 1603866395, 1606458395);
INSERT INTO `qfyu_login_token` VALUES ('33fca4cac23f598eb182d3b776e92053', 7, 1607934013, 1610526013);
INSERT INTO `qfyu_login_token` VALUES ('34e78802a82665b8caec3a78250b9a4d', 7, 1602663559, 1605255559);
INSERT INTO `qfyu_login_token` VALUES ('379ecc2bb55193203fc04cb7158f3f8e', 7, 1602472685, 1605064685);
INSERT INTO `qfyu_login_token` VALUES ('37f6d67350ccba97e71d6595f0582c3e', 7, 1605928168, 1608520168);
INSERT INTO `qfyu_login_token` VALUES ('3889c805e271007eb72655e6a70c6a97', 7, 1602474060, 1605066060);
INSERT INTO `qfyu_login_token` VALUES ('388e52723795ab46d50cc873dd568a50', 7, 1607929808, 1610521808);
INSERT INTO `qfyu_login_token` VALUES ('391e81129d97a09c4296144ed849efa4', 7, 1602385122, 1604977122);
INSERT INTO `qfyu_login_token` VALUES ('3a19cf1f5a40a72130e358c4f4c09cdb', 7, 1602399606, 1604991606);
INSERT INTO `qfyu_login_token` VALUES ('3e646b24599c8ea5481c3ba9e5b08726', 7, 1602473248, 1605065248);
INSERT INTO `qfyu_login_token` VALUES ('41b6fab4e619c944afb6926c0dd6a013', 7, 1602235257, 1604827257);
INSERT INTO `qfyu_login_token` VALUES ('43fdc5b98b781f7c967a9798b0d4ea9b', 7, 1603674904, 1606266904);
INSERT INTO `qfyu_login_token` VALUES ('47153c387a3a0a815d22db8c7b5ddc01', 7, 1605237870, 1607829870);
INSERT INTO `qfyu_login_token` VALUES ('4878bc42694bd948604b9099c0f12a5c', 7, 1602655008, 1605247008);
INSERT INTO `qfyu_login_token` VALUES ('4c004fdc7faf56c46a759db4f6abd38d', 7, 1602474162, 1605066162);
INSERT INTO `qfyu_login_token` VALUES ('4dd97c9e510777a05d18e5b0d4b0fac9', 7, 1602410153, 1605002153);
INSERT INTO `qfyu_login_token` VALUES ('50a5a20f02f26e9d963489be6aa260aa', 7, 1604113679, 1606705679);
INSERT INTO `qfyu_login_token` VALUES ('53b29c59a5b104a32b83debc1b89464c', 7, 1608021465, 1610613465);
INSERT INTO `qfyu_login_token` VALUES ('55ee2f2390d70d19e1a1ad20ea953b42', 7, 1605228742, 1607820742);
INSERT INTO `qfyu_login_token` VALUES ('56b7190cc4d6f6ee1151c9d79c91544a', 7, 1602754572, 1605346572);
INSERT INTO `qfyu_login_token` VALUES ('5982103cc4cfd2edc6c08d63fb5feb8a', 7, 1604654762, 1607246762);
INSERT INTO `qfyu_login_token` VALUES ('5dc6a097469a1f0cfdf9c2a129780479', 7, 1602471603, 1605063603);
INSERT INTO `qfyu_login_token` VALUES ('615e78ac9ffd08cfcbd1bd0d2ea0018f', 7, 1604733417, 1607325417);
INSERT INTO `qfyu_login_token` VALUES ('68878192fd4df2d8e3bb09c2fc3ba0d6', 7, 1604385528, 1606977528);
INSERT INTO `qfyu_login_token` VALUES ('71f63407e9b13713fb1e37c70f0dc4ba', 7, 1602226150, 1604818150);
INSERT INTO `qfyu_login_token` VALUES ('72b0191cb5cf0fe0547a6131e36a3a02', 13, 1604989067, 1607581067);
INSERT INTO `qfyu_login_token` VALUES ('73d8d6a933374a95a63121c44ce6d471', 7, 1604555221, 1607147221);
INSERT INTO `qfyu_login_token` VALUES ('76443f93771616869c33f0ed1e6fa4ee', 7, 1605573570, 1608165570);
INSERT INTO `qfyu_login_token` VALUES ('7cb2ca4624a047dc74d19f16c9844fce', 7, 1602472992, 1605064992);
INSERT INTO `qfyu_login_token` VALUES ('80847d3bf57d2eee2883c661f2df199f', 7, 1602406132, 1604998132);
INSERT INTO `qfyu_login_token` VALUES ('8208c2d4a90b3f1775da1a7be3836538', 13, 1603420984, 1606012984);
INSERT INTO `qfyu_login_token` VALUES ('86fc0001e69ff8595cd5127cf1c1a7e0', 7, 1602403025, 1604995025);
INSERT INTO `qfyu_login_token` VALUES ('90e334c5754b5ca59fcc63391cc77eca', 7, 1603068892, 1605660892);
INSERT INTO `qfyu_login_token` VALUES ('911c9532d0b9e7c02c8f02c498046094', 7, 1607930705, 1610522705);
INSERT INTO `qfyu_login_token` VALUES ('946def3b547526b261d204e2736155b5', 7, 1602316132, 1604908132);
INSERT INTO `qfyu_login_token` VALUES ('9b203e3593352f795ab4699e53db916b', 13, 1607503507, 1610095507);
INSERT INTO `qfyu_login_token` VALUES ('9caf8b5ed8ae1410f930d765e666c005', 7, 1602471580, 1605063580);
INSERT INTO `qfyu_login_token` VALUES ('9fc048e3022bd3b6661e0cd65d3f119d', 7, 1605748778, 1608340778);
INSERT INTO `qfyu_login_token` VALUES ('a524f014c43a222d173fb7cb0342c9e4', 6, 1608107397, 1610699397);
INSERT INTO `qfyu_login_token` VALUES ('b1295f7525b95e7d41e19b886b6f24d1', 7, 1604988606, 1607580606);
INSERT INTO `qfyu_login_token` VALUES ('b20204560d4e1a5c6a6622a9620703ce', 7, 1602226216, 1604818216);
INSERT INTO `qfyu_login_token` VALUES ('b595bc0bda6544bca757e9fb0968f90a', 7, 1602554389, 1605146389);
INSERT INTO `qfyu_login_token` VALUES ('b77dd87a1573add0f0b93783b617a72f', 7, 1604882499, 1607474499);
INSERT INTO `qfyu_login_token` VALUES ('bb087768979530e75b043edf966b63f7', 7, 1604104785, 1606696785);
INSERT INTO `qfyu_login_token` VALUES ('bc39dd839a9bf8c4a992811f352c8b93', 7, 1602923791, 1605515791);
INSERT INTO `qfyu_login_token` VALUES ('bca57b1fd5ac83c747b0a54468a248f6', 7, 1602473791, 1605065791);
INSERT INTO `qfyu_login_token` VALUES ('bd7a5eadbcb7aeefb043ab706f839066', 7, 1602316152, 1604908152);
INSERT INTO `qfyu_login_token` VALUES ('bf9b2a6bfb7ca5e6df83e7490d0757af', 7, 1607075839, 1609667839);
INSERT INTO `qfyu_login_token` VALUES ('c76a51856204bb817b16e106e22fe2e8', 7, 1607926214, 1610518214);
INSERT INTO `qfyu_login_token` VALUES ('c906a7315cbd7f39192581552b50b868', 7, 1602399647, 1604991647);
INSERT INTO `qfyu_login_token` VALUES ('cc6d90764f709416104577218c5803c9', 7, 1602316035, 1604908035);
INSERT INTO `qfyu_login_token` VALUES ('ce2a1849d303a8b1c0cc721b7d0dfeff', 7, 1602811788, 1605403788);
INSERT INTO `qfyu_login_token` VALUES ('d9403525254b44c541d5a36512fcced8', 7, 1602584185, 1605176185);
INSERT INTO `qfyu_login_token` VALUES ('da1b344396cf6d3c457e6f6e705d597a', 7, 1604052013, 1606644013);
INSERT INTO `qfyu_login_token` VALUES ('de15dc98287aed59b35eaaaa1b8e3e1e', 7, 1608107738, 1610699738);
INSERT INTO `qfyu_login_token` VALUES ('e380a6986cea83b57119d83a3815ac77', 7, 1603247475, 1605839475);
INSERT INTO `qfyu_login_token` VALUES ('e859976064b8fc23c8e5def99b675bd6', 7, 1602405107, 1604997107);
INSERT INTO `qfyu_login_token` VALUES ('e8eda934884458234ca478d34b54b96d', 7, 1602385528, 1604977528);
INSERT INTO `qfyu_login_token` VALUES ('eb769168e9a8cadb00c47dc74d916a67', 7, 1605598789, 1608190789);
INSERT INTO `qfyu_login_token` VALUES ('ed06fa8f52c2f9e896b0fbd7a202a6a0', 7, 1602472536, 1605064536);
INSERT INTO `qfyu_login_token` VALUES ('efb79a8933714d830aa682de442fecdb', 7, 1602402659, 1604994659);
INSERT INTO `qfyu_login_token` VALUES ('f376549d3918946b8d10cd8bab3a4c9c', 7, 1605605025, 1608197025);
INSERT INTO `qfyu_login_token` VALUES ('f8333162cba5b5f69b7f5b80a539bedc', 7, 1607930042, 1610522042);
INSERT INTO `qfyu_login_token` VALUES ('fb33b2b3e5435134fa43e48499316dc2', 7, 1607929678, 1610521678);
INSERT INTO `qfyu_login_token` VALUES ('fd078fee64d15e26c41d7d98b47e91fa', 7, 1603701687, 1606293687);

-- ----------------------------
-- Table structure for qfyu_make_orderid
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_make_orderid`;
CREATE TABLE `qfyu_make_orderid`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prefix` char(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '前缀',
  `created_at` int(8) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`orderid`) USING BTREE,
  INDEX `type`(`prefix`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_make_orderid
-- ----------------------------
INSERT INTO `qfyu_make_orderid` VALUES ('OS2012245010148989', 'OS', 201224);
INSERT INTO `qfyu_make_orderid` VALUES ('XJ2012245010099565', 'XJ', 201224);

-- ----------------------------
-- Table structure for qfyu_menu
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_menu`;
CREATE TABLE `qfyu_menu`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `parent_id` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0表示不启用 1启用',
  `level` tinyint(4) NOT NULL,
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sort` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 229 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_menu
-- ----------------------------
INSERT INTO `qfyu_menu` VALUES (1, '系统管理', 0, 1, 1, '', 1);
INSERT INTO `qfyu_menu` VALUES (2, '用户设置', 1, 0, 2, '', 1);
INSERT INTO `qfyu_menu` VALUES (3, '权限设置', 1, 1, 2, '/power', 1);
INSERT INTO `qfyu_menu` VALUES (4, '资料管理', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (5, '商品资料', 4, 1, 2, '/commodity', 1);
INSERT INTO `qfyu_menu` VALUES (7, '采购管理', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (8, '缺货登记', 7, 1, 2, '/lackList', 1);
INSERT INTO `qfyu_menu` VALUES (9, '采购计划', 7, 1, 2, '/purchasePlan', 1);
INSERT INTO `qfyu_menu` VALUES (10, '采购合同', 7, 1, 2, '/contractList', 1);
INSERT INTO `qfyu_menu` VALUES (11, '销售管理', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (12, '仓储物流', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (14, '财务管理', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (15, '统计分析', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (16, 'GSP管理', 0, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (17, '采购询价', 7, 1, 2, '', 1);
INSERT INTO `qfyu_menu` VALUES (18, '采购订单', 7, 1, 2, '/purOrderList', 1);
INSERT INTO `qfyu_menu` VALUES (19, '操作日志', 1, 1, 2, '', 1);
INSERT INTO `qfyu_menu` VALUES (21, '员工资料', 4, 1, 2, '/employee', 1);
INSERT INTO `qfyu_menu` VALUES (22, '首营品种管理', 16, 1, 1, '/first_variety_list', 1);
INSERT INTO `qfyu_menu` VALUES (23, '首营企业管理', 16, 1, 1, '/first_enterprise', 1);
INSERT INTO `qfyu_menu` VALUES (24, '仓库及库位管理', 4, 1, 1, '/warelist', 1);
INSERT INTO `qfyu_menu` VALUES (25, '企业机构管理', 4, 1, 1, '/branch', 1);
INSERT INTO `qfyu_menu` VALUES (26, '来货登记', 7, 1, 2, '/registerList', 1);
INSERT INTO `qfyu_menu` VALUES (27, '加盟店资料管理', 4, 0, 1, '/franchiser', 1);
INSERT INTO `qfyu_menu` VALUES (28, '结算方式', 4, 1, 1, '/settlement', 1);
INSERT INTO `qfyu_menu` VALUES (29, '价格体系管理', 4, 1, 1, '/pricesystem', 1);
INSERT INTO `qfyu_menu` VALUES (30, '冷藏药品收货登记', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (31, '运输超时检测（收货）', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (32, '质量验收', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (33, '质量验收查询', 32, 1, 3, '/qualityList', 1);
INSERT INTO `qfyu_menu` VALUES (39, '来货拒收', 7, 1, 2, '/RejectionList', 1);
INSERT INTO `qfyu_menu` VALUES (40, '入库通知单', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (41, '商品购进退回', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (42, '退补差价单', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (43, '未完成采购订单失效警报', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (44, '历史供货查询', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (45, '单据查询', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (46, '记录查询', 7, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (47, '历史应付款', 14, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (48, '采购结算', 14, 1, 2, '/PchSettleList', 1);
INSERT INTO `qfyu_menu` VALUES (49, '采购付款', 14, 1, 2, '/PchPayList', 1);
INSERT INTO `qfyu_menu` VALUES (50, '商品类别管理', 4, 1, 1, '/category', 1);
INSERT INTO `qfyu_menu` VALUES (51, '生产企业资料', 4, 1, 1, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (52, '商品库位维护', 4, 1, 1, '/uphold', 1);
INSERT INTO `qfyu_menu` VALUES (53, '销售合同', 11, 1, 2, '/sales_contract', 1);
INSERT INTO `qfyu_menu` VALUES (54, '销售报价单', 11, 1, 2, '/sel_speer', 1);
INSERT INTO `qfyu_menu` VALUES (55, '网上订单', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (56, '销售订单', 11, 1, 2, '/sel_order', 1);
INSERT INTO `qfyu_menu` VALUES (57, '销售开单', 11, 1, 2, '/sel_export', 1);
INSERT INTO `qfyu_menu` VALUES (58, '直调订单', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (59, '直调开单', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (60, '销售退回管理', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (61, '销退质量验收', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (62, '销退拒收', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (63, '销退入库通知单', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (64, '冷藏药品销退收货登记', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (65, '销售发货运输登记', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (66, '冷藏药品运输登记', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (67, '运输超时检测', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (68, '送货回单管理', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (69, '退补差价单', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (70, '批发促销管理', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (71, '批发限量特价管理', 70, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (72, '销售退回申请', 60, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (73, '销售退回登记', 60, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (74, '未完成销售订单失效报警', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (75, '历史销售情况查询', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (76, '销售日报明细表', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (77, '网络订单跟踪', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (78, '业务员月度对账单', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (79, '销售回款提成统计', 11, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (80, '单据查询', 11, 1, 2, NULL, 2);
INSERT INTO `qfyu_menu` VALUES (81, '销售合同查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (82, '客户询价查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (83, '销售订单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (84, '销售开单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (85, '直调销售单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (86, '网上订单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (87, '销售退回申请查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (88, '销售退回登记单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (89, '销售退回质量验收查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (90, '销退入库通知单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (91, '销退拒收单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (92, '销售发货运输登记查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (93, '运货回单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (94, '销售结算单查询', 80, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (95, '记录查询', 11, 1, 2, NULL, 2);
INSERT INTO `qfyu_menu` VALUES (96, '商品销售记录', 95, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (97, '商品销售退回记录', 95, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (98, '库存初始化', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (99, '库存盘点', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (100, '账面库存结存单', 99, 1, 3, '/accstock', 1);
INSERT INTO `qfyu_menu` VALUES (101, '实物盘点单', 99, 1, 3, '/realstock', 1);
INSERT INTO `qfyu_menu` VALUES (104, '即时盘点单', 99, 1, 3, '/immediate', 1);
INSERT INTO `qfyu_menu` VALUES (105, '整仓盘点单', 99, 1, 3, '/whole', 1);
INSERT INTO `qfyu_menu` VALUES (106, '盘点查询', 99, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (107, '验收入库/复核', 12, 1, 2, '/recheckList', 1);
INSERT INTO `qfyu_menu` VALUES (108, '电子监管码采集', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (109, '出库登记/复核', 12, 1, 2, '/StockOutList', 1);
INSERT INTO `qfyu_menu` VALUES (110, '直调出库单', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (111, '出库流水号登记', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (112, '质量疑问商品', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (113, '不合格药品管理', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (114, '商品报损', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (115, '不合格药品报告确认表', 115, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (116, '不合格药品台账', 115, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (117, '不合格药品退货', 115, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (118, '不合格药品报损审核表', 115, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (119, '不合格药品销毁审批', 115, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (120, '不合格药品退货记录', 115, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (121, '商品报溢', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (122, '商品分解作业', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (123, '库存综合预警', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (124, '近效期商品报警', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (125, '过期商品报警', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (126, '分仓库存预警', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (127, '药品拆零单', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (128, '中药饮片拆零单', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (129, '药品养护预警', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (130, '药品养护检查计划', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (131, '调拨申请表', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (132, '调拨质量验收', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (133, '更新批号', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (134, '滞销商品查询', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (135, '库存查询', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (136, '单据查询', 12, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (146, '预收/预付款、结余款统计', 14, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (147, '应收应付款财务对账单', 14, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (148, '销售结算', 14, 1, 2, '/selSettleList', 1);
INSERT INTO `qfyu_menu` VALUES (149, '支出单', 14, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (150, '收入单', 14, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (151, '客户资质审核', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (152, '人员与培训', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (153, '工作岗位设置', 152, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (154, '人员岗位认证', 152, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (155, '人员健康检查', 152, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (156, '人员培训记录', 152, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (157, '年度质量培训计划', 152, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (158, '质量管理', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (159, '质量事故记录', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (160, '药品验收入库通知单', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (161, '销后退回通知单', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (162, '国家药品不良反应报告管理', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (163, '医疗器械不良反应报告管理', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (164, '麻醉精神药品月度统计', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (165, '药品验收抽样记录', 158, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (166, '库存与设施', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (167, '库房温湿度记录', 166, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (168, '库外温湿度记录', 166, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (169, '设备管理', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (170, '设备检查维护记录', 169, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (171, '设备使用记录', 169, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (172, '中药饮片分装工具管理台账', 169, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (173, '计量器具管理台账', 169, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (174, '设施设备管理台账', 169, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (175, '计量器具使用记录', 169, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (176, 'GSP文档管理器', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (177, '记录查询', 16, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (178, '出库复核记录查询', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (179, '销后退回药品验收记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (180, '药品购货计划记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (181, '首次经营药品记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (182, '首次经营企业记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (183, '人员综合记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (184, '质量验收记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (185, '药品质量记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (186, '药品拒收记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (187, '样品购进退回记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (188, '库房温湿度记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (189, '库外温湿度记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (190, '药品销售记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (191, '药品退回记录', 177, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (192, '药品购销配存货查询', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (193, '商品业务流向查询', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (194, '商品进出库分析', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (195, '商品批次进销存查询', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (196, '库存商品分析', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (197, '批号库存商品分析', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (198, '价格波动查询', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (199, '商品进货分析', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (200, '商品进货统计', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (201, '供应商进货统计', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (202, '业务员进货统计', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (203, '商品进货排行表', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (204, '供应商排行表', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (205, '商品购进ABC分析', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (206, '商品购进汇总表', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (207, '批号商品购进汇总表', 199, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (208, '商品销售分析', 15, 1, 2, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (209, '商品销售日报表', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (210, '商品销售期间分析', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (211, '客户购货统计', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (212, '代销客户往来分析', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (213, '商品销售分类统计', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (214, '商品销售排行表统计分析', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (215, '客户销售排行表', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (216, '业务员销售业绩统计表', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (217, '业务员销售排行表', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (218, '购销月报表', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (219, '商品销售ABC分析表', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (220, '供应商销售统计', 208, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (221, '客户资料管理', 4, 1, 2, '/customer', 1);
INSERT INTO `qfyu_menu` VALUES (222, '供应商管理', 4, 1, 2, '/supplier', 1);
INSERT INTO `qfyu_menu` VALUES (223, '质量验收默认设置', 32, 1, 3, '/goodsCheckAcceptDefault', 100);
INSERT INTO `qfyu_menu` VALUES (224, '地区资料', 4, 1, 2, '/areaList', 1);
INSERT INTO `qfyu_menu` VALUES (225, '系统设置', 1, 1, 2, '/config', 100);
INSERT INTO `qfyu_menu` VALUES (226, '商品出入库查询', 135, 1, 3, '/GoodsInOutList', 1);
INSERT INTO `qfyu_menu` VALUES (227, '无库存商品查询', 135, 1, 3, NULL, 1);
INSERT INTO `qfyu_menu` VALUES (228, '库存条码查询', 135, 1, 3, NULL, 1);

-- ----------------------------
-- Table structure for qfyu_operators
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_operators`;
CREATE TABLE `qfyu_operators`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `emp_id` int(10) UNSIGNED NOT NULL COMMENT '员工信息ID',
  `passwd` char(56) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `role_ids` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '角色',
  `power_ids` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '拥有权限',
  `post_auth` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '岗位权限',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  `re_time` int(10) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `emp_id`(`emp_id`) USING BTREE,
  CONSTRAINT `emp_id` FOREIGN KEY (`emp_id`) REFERENCES `qfyu_employee` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '后台管理员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_operators
-- ----------------------------
INSERT INTO `qfyu_operators` VALUES (6, 2, 'Jpgb3JaXCIvSneNAbKJgpBkTLpGC/973y1x017TvyhemMPiaHYCD0g==', '2,7,1,6', 'a:9:{i:0;a:1:{i:0;a:0:{}}i:1;a:2:{i:9;a:0:{}i:12;a:0:{}}i:2;a:10:{i:13;a:0:{}i:14;a:0:{}i:29;a:0:{}i:31;a:0:{}i:36;a:0:{}i:48;a:0:{}i:54;a:0:{}i:57;a:0:{}i:63;a:0:{}i:65;a:0:{}}i:3;a:8:{i:71;a:0:{}i:106;a:0:{}i:119;a:0:{}i:123;a:0:{}i:131;a:0:{}i:154;a:0:{}i:155;a:0:{}i:176;a:0:{}}i:4;a:3:{i:166;a:0:{}i:191;a:0:{}i:215;a:0:{}}i:5;a:2:{i:183;a:0:{}i:193;a:8:{i:0;s:3:\"194\";i:1;s:3:\"206\";i:2;s:3:\"209\";i:3;s:3:\"211\";i:4;s:3:\"213\";i:5;s:3:\"222\";i:6;s:3:\"226\";i:7;s:3:\"227\";}}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:0:{}i:33;a:0:{}}}', 'a:6:{i:0;i:6;i:1;i:3;i:2;i:7;i:3;i:5;i:4;i:4;i:5;i:2;}', 1600332854, 1608606103);
INSERT INTO `qfyu_operators` VALUES (7, 1, 'e5odi8uUDN3SnL4RNvhp9U0Ud8HSo46qlVx007bvnRGgN/nPTNeD1Q==', '5,1,7', 'a:9:{i:0;a:1:{i:0;a:20:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"20\";i:19;s:2:\"21\";}}i:1;a:2:{i:9;a:6:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";i:5;s:3:\"130\";}i:12;a:0:{}}i:2;a:10:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:8:{i:0;s:2:\"49\";i:1;s:2:\"53\";i:2;s:2:\"59\";i:3;s:2:\"62\";i:4;s:2:\"67\";i:5;s:3:\"122\";i:6;s:3:\"181\";i:7;s:3:\"240\";}i:54;a:10:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:2:\"96\";}i:57;a:8:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"101\";i:3;s:3:\"117\";i:4;s:3:\"118\";i:5;s:3:\"124\";i:6;s:3:\"125\";i:7;s:3:\"126\";}i:63;a:12:{i:0;s:2:\"64\";i:1;s:3:\"110\";i:2;s:3:\"111\";i:3;s:3:\"112\";i:4;s:3:\"161\";i:5;s:3:\"162\";i:6;s:3:\"170\";i:7;s:3:\"171\";i:8;s:3:\"174\";i:9;s:3:\"175\";i:10;s:3:\"189\";i:11;s:3:\"190\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}}i:3;a:5:{i:71;a:7:{i:0;s:2:\"85\";i:1;s:2:\"88\";i:2;s:2:\"89\";i:3;s:2:\"90\";i:4;s:2:\"91\";i:5;s:2:\"92\";i:6;s:2:\"94\";}i:106;a:7:{i:0;s:3:\"108\";i:1;s:3:\"113\";i:2;s:3:\"114\";i:3;s:3:\"115\";i:4;s:3:\"116\";i:5;s:3:\"109\";i:6;s:3:\"107\";}i:119;a:6:{i:0;s:3:\"120\";i:1;s:3:\"121\";i:2;s:3:\"135\";i:3;s:3:\"140\";i:4;s:3:\"143\";i:5;s:3:\"146\";}i:123;a:3:{i:0;s:3:\"127\";i:1;s:3:\"128\";i:2;s:3:\"129\";}i:131;a:7:{i:0;s:3:\"133\";i:1;s:3:\"134\";i:2;s:3:\"149\";i:3;s:3:\"150\";i:4;s:3:\"151\";i:5;s:3:\"152\";i:6;s:3:\"153\";}}i:4;a:0:{}i:5;a:280:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;N;i:5;N;i:6;N;i:7;N;i:8;N;i:9;N;i:10;N;i:11;N;i:12;N;i:13;N;i:14;N;i:15;N;i:16;N;i:17;N;i:18;N;i:19;N;i:20;N;i:21;N;i:22;N;i:23;N;i:24;N;i:25;N;i:26;N;i:27;N;i:28;N;i:29;N;i:30;N;i:31;N;i:32;N;i:33;N;i:34;N;i:35;N;i:36;N;i:37;N;i:38;N;i:39;N;i:40;N;i:41;N;i:42;N;i:43;N;i:44;N;i:45;N;i:46;N;i:47;N;i:48;N;i:49;N;i:50;N;i:51;N;i:52;N;i:53;N;i:54;N;i:55;N;i:56;N;i:57;N;i:58;N;i:59;N;i:60;N;i:61;N;i:62;N;i:63;N;i:64;N;i:65;N;i:66;N;i:67;N;i:68;N;i:69;N;i:70;N;i:71;N;i:72;N;i:73;N;i:74;N;i:75;N;i:76;N;i:77;N;i:78;N;i:79;N;i:80;N;i:81;N;i:82;N;i:83;N;i:84;N;i:85;N;i:86;N;i:87;N;i:88;N;i:89;N;i:90;N;i:91;N;i:92;N;i:93;N;i:94;N;i:95;N;i:96;N;i:97;N;i:98;N;i:99;N;i:100;N;i:101;N;i:102;N;i:103;N;i:104;N;i:105;N;i:106;N;i:107;N;i:108;N;i:109;N;i:110;N;i:111;N;i:112;N;i:113;N;i:114;N;i:115;N;i:116;N;i:117;N;i:118;N;i:119;N;i:120;N;i:121;N;i:122;N;i:123;N;i:124;N;i:125;N;i:126;N;i:127;N;i:128;N;i:129;N;i:130;N;i:131;N;i:132;N;i:133;N;i:134;N;i:135;N;i:136;N;i:137;N;i:138;N;i:139;N;i:140;N;i:141;N;i:142;N;i:143;N;i:144;N;i:145;N;i:146;N;i:147;N;i:148;N;i:149;N;i:150;N;i:151;N;i:152;N;i:153;N;i:154;N;i:155;N;i:156;N;i:157;N;i:158;N;i:159;N;i:160;N;i:161;N;i:162;N;i:163;N;i:164;N;i:165;N;i:166;N;i:167;N;i:168;N;i:169;N;i:170;N;i:171;N;i:172;N;i:173;N;i:174;N;i:175;N;i:176;N;i:177;N;i:178;N;i:179;N;i:180;N;i:181;N;i:182;N;i:183;a:5:{i:0;s:3:\"184\";i:1;s:3:\"186\";i:2;s:3:\"187\";i:3;s:3:\"188\";i:4;s:3:\"201\";}i:184;N;i:185;N;i:186;N;i:187;N;i:188;N;i:189;N;i:190;N;i:191;N;i:192;N;i:193;a:8:{i:0;s:3:\"194\";i:1;s:3:\"206\";i:2;s:3:\"209\";i:3;s:3:\"211\";i:4;s:3:\"213\";i:5;s:3:\"226\";i:6;s:3:\"222\";i:7;s:3:\"227\";}i:194;N;i:195;N;i:196;N;i:197;N;i:198;N;i:199;N;i:200;N;i:201;N;i:202;N;i:203;N;i:204;N;i:205;N;i:206;N;i:207;N;i:208;N;i:209;N;i:210;N;i:211;N;i:212;N;i:213;N;i:214;N;i:215;N;i:216;N;i:217;N;i:218;N;i:219;N;i:220;N;i:221;N;i:222;N;i:223;N;i:224;N;i:225;N;i:226;N;i:227;N;i:228;N;i:229;N;i:230;N;i:231;N;i:232;N;i:233;N;i:234;N;i:235;N;i:236;N;i:237;N;i:238;N;i:239;N;i:240;N;i:241;N;i:242;N;i:243;N;i:244;N;i:245;N;i:246;N;i:247;N;i:248;N;i:249;N;i:250;N;i:251;N;i:252;N;i:253;N;i:254;N;i:255;N;i:256;N;i:257;N;i:258;N;i:259;N;i:260;N;i:261;N;i:262;N;i:263;N;i:264;N;i:265;N;i:266;N;i:267;a:5:{i:0;s:3:\"268\";i:1;s:3:\"269\";i:2;s:3:\"270\";i:3;s:3:\"271\";i:4;s:3:\"272\";}i:268;N;i:269;N;i:270;N;i:271;N;i:272;N;i:273;N;i:274;N;i:275;N;i:276;N;i:277;N;i:278;N;i:279;a:1:{i:0;s:3:\"280\";}}i:6;a:265:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;N;i:5;N;i:6;N;i:7;N;i:8;N;i:9;N;i:10;N;i:11;N;i:12;N;i:13;N;i:14;N;i:15;N;i:16;N;i:17;N;i:18;N;i:19;N;i:20;N;i:21;N;i:22;N;i:23;N;i:24;N;i:25;N;i:26;N;i:27;N;i:28;N;i:29;N;i:30;N;i:31;N;i:32;N;i:33;N;i:34;N;i:35;N;i:36;N;i:37;N;i:38;N;i:39;N;i:40;N;i:41;N;i:42;N;i:43;N;i:44;N;i:45;N;i:46;N;i:47;N;i:48;N;i:49;N;i:50;N;i:51;N;i:52;N;i:53;N;i:54;N;i:55;N;i:56;N;i:57;N;i:58;N;i:59;N;i:60;N;i:61;N;i:62;N;i:63;N;i:64;N;i:65;N;i:66;N;i:67;N;i:68;N;i:69;N;i:70;N;i:71;N;i:72;N;i:73;N;i:74;N;i:75;N;i:76;N;i:77;N;i:78;N;i:79;N;i:80;N;i:81;N;i:82;N;i:83;N;i:84;N;i:85;N;i:86;N;i:87;N;i:88;N;i:89;N;i:90;N;i:91;N;i:92;N;i:93;N;i:94;N;i:95;N;i:96;N;i:97;N;i:98;N;i:99;N;i:100;N;i:101;N;i:102;N;i:103;N;i:104;N;i:105;N;i:106;N;i:107;N;i:108;N;i:109;N;i:110;N;i:111;N;i:112;N;i:113;N;i:114;N;i:115;N;i:116;N;i:117;N;i:118;N;i:119;N;i:120;N;i:121;N;i:122;N;i:123;N;i:124;N;i:125;N;i:126;N;i:127;N;i:128;N;i:129;N;i:130;N;i:131;N;i:132;N;i:133;N;i:134;N;i:135;N;i:136;N;i:137;N;i:138;N;i:139;N;i:140;N;i:141;N;i:142;N;i:143;N;i:144;N;i:145;N;i:146;N;i:147;N;i:148;N;i:149;N;i:150;N;i:151;N;i:152;N;i:153;N;i:154;N;i:155;N;i:156;N;i:157;N;i:158;N;i:159;N;i:160;N;i:161;N;i:162;N;i:163;N;i:164;N;i:165;N;i:166;N;i:167;N;i:168;N;i:169;N;i:170;N;i:171;N;i:172;N;i:173;N;i:174;N;i:175;N;i:176;N;i:177;N;i:178;N;i:179;N;i:180;N;i:181;N;i:182;N;i:183;N;i:184;N;i:185;N;i:186;N;i:187;N;i:188;N;i:189;N;i:190;N;i:191;N;i:192;N;i:193;N;i:194;N;i:195;N;i:196;N;i:197;N;i:198;N;i:199;N;i:200;N;i:201;N;i:202;N;i:203;N;i:204;N;i:205;N;i:206;N;i:207;N;i:208;N;i:209;N;i:210;N;i:211;N;i:212;N;i:213;N;i:214;N;i:215;N;i:216;N;i:217;N;i:218;N;i:219;N;i:220;N;i:221;N;i:222;N;i:223;N;i:224;N;i:225;N;i:226;N;i:227;N;i:228;N;i:229;N;i:230;N;i:231;N;i:232;N;i:233;N;i:234;N;i:235;N;i:236;N;i:237;N;i:238;N;i:239;N;i:240;N;i:241;N;i:242;N;i:243;N;i:244;N;i:245;N;i:246;N;i:247;N;i:248;N;i:249;N;i:250;N;i:251;N;i:252;N;i:253;N;i:254;N;i:255;N;i:256;N;i:257;N;i:258;N;i:259;N;i:260;a:1:{i:0;s:3:\"261\";}i:261;N;i:262;N;i:263;N;i:264;a:1:{i:0;s:3:\"265\";}}i:7;a:0:{}i:8;a:2:{i:20;a:6:{i:0;s:2:\"21\";i:1;s:2:\"38\";i:2;s:2:\"41\";i:3;s:2:\"43\";i:4;s:2:\"44\";i:5;s:2:\"46\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', 'a:7:{i:0;i:2;i:1;i:1;i:2;i:4;i:3;i:5;i:4;i:6;i:5;i:7;i:6;i:3;}', 1600332865, 1608795370);
INSERT INTO `qfyu_operators` VALUES (8, 3, 'Jpgb3JaXCIvSneNAbKJgpBkTLpGC/973y1x017TvyhemMPiaHYCD0g==', '7', 'a:9:{i:0;a:1:{i:0;a:20:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"20\";i:19;s:2:\"21\";}}i:1;a:2:{i:9;a:5:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";}i:12;a:0:{}}i:2;a:10:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:6:{i:0;s:2:\"49\";i:1;s:2:\"53\";i:2;s:2:\"59\";i:3;s:2:\"62\";i:4;s:2:\"67\";i:5;s:3:\"122\";}i:54;a:10:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:2:\"96\";}i:57;a:8:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"101\";i:3;s:3:\"117\";i:4;s:3:\"118\";i:5;s:3:\"124\";i:6;s:3:\"125\";i:7;s:3:\"126\";}i:63;a:13:{i:0;s:2:\"64\";i:1;s:2:\"70\";i:2;s:2:\"73\";i:3;s:2:\"77\";i:4;s:2:\"79\";i:5;s:2:\"81\";i:6;s:2:\"83\";i:7;s:2:\"97\";i:8;s:3:\"103\";i:9;s:3:\"105\";i:10;s:3:\"110\";i:11;s:3:\"111\";i:12;s:3:\"112\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}}i:3;a:4:{i:71;a:10:{i:0;s:2:\"72\";i:1;s:2:\"74\";i:2;s:2:\"76\";i:3;s:2:\"85\";i:4;s:2:\"88\";i:5;s:2:\"89\";i:6;s:2:\"90\";i:7;s:2:\"91\";i:8;s:2:\"92\";i:9;s:2:\"94\";}i:106;a:7:{i:0;s:3:\"107\";i:1;s:3:\"108\";i:2;s:3:\"109\";i:3;s:3:\"113\";i:4;s:3:\"114\";i:5;s:3:\"115\";i:6;s:3:\"116\";}i:119;a:2:{i:0;s:3:\"120\";i:1;s:3:\"121\";}i:123;a:3:{i:0;s:3:\"127\";i:1;s:3:\"128\";i:2;s:3:\"129\";}}i:4;a:0:{}i:5;a:0:{}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:6:{i:0;s:2:\"21\";i:1;s:2:\"38\";i:2;s:2:\"41\";i:3;s:2:\"43\";i:4;s:2:\"44\";i:5;s:2:\"46\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', NULL, 1600502159, 1606303643);
INSERT INTO `qfyu_operators` VALUES (10, 4, 'LMkQ28eRC4+BnOZBOv5n+ksRJ5DSpdyiyFly1rW9zxCobPXJTIHW0A==', '6,7', 'a:9:{i:0;a:1:{i:0;a:20:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"20\";i:19;s:2:\"21\";}}i:1;a:2:{i:9;a:6:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";i:5;s:3:\"130\";}i:12;a:0:{}}i:2;a:10:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:6:{i:0;s:2:\"49\";i:1;s:2:\"53\";i:2;s:2:\"59\";i:3;s:2:\"62\";i:4;s:2:\"67\";i:5;s:3:\"122\";}i:54;a:10:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:2:\"96\";}i:57;a:8:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"101\";i:3;s:3:\"117\";i:4;s:3:\"118\";i:5;s:3:\"124\";i:6;s:3:\"125\";i:7;s:3:\"126\";}i:63;a:13:{i:0;s:2:\"64\";i:1;s:2:\"70\";i:2;s:2:\"73\";i:3;s:2:\"77\";i:4;s:2:\"79\";i:5;s:2:\"81\";i:6;s:2:\"83\";i:7;s:2:\"97\";i:8;s:3:\"103\";i:9;s:3:\"105\";i:10;s:3:\"110\";i:11;s:3:\"111\";i:12;s:3:\"112\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}}i:3;a:4:{i:71;a:10:{i:0;s:2:\"72\";i:1;s:2:\"74\";i:2;s:2:\"76\";i:3;s:2:\"85\";i:4;s:2:\"88\";i:5;s:2:\"89\";i:6;s:2:\"90\";i:7;s:2:\"91\";i:8;s:2:\"92\";i:9;s:2:\"94\";}i:106;a:7:{i:0;s:3:\"107\";i:1;s:3:\"108\";i:2;s:3:\"109\";i:3;s:3:\"113\";i:4;s:3:\"114\";i:5;s:3:\"115\";i:6;s:3:\"116\";}i:119;a:2:{i:0;s:3:\"120\";i:1;s:3:\"121\";}i:123;a:3:{i:0;s:3:\"127\";i:1;s:3:\"128\";i:2;s:3:\"129\";}}i:4;a:0:{}i:5;a:0:{}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:6:{i:0;s:2:\"21\";i:1;s:2:\"38\";i:2;s:2:\"41\";i:3;s:2:\"43\";i:4;s:2:\"44\";i:5;s:2:\"46\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', NULL, 1600502265, 1606370726);
INSERT INTO `qfyu_operators` VALUES (11, 5, 'Jpgb3JaXCIvSneNAbKJgpBkTLpGC/973y1x017TvyhemMPiaHYCD0g==', '5,7', 'a:9:{i:0;a:1:{i:0;a:20:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"20\";i:19;s:2:\"21\";}}i:1;a:2:{i:9;a:5:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";}i:12;a:0:{}}i:2;a:10:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:6:{i:0;s:2:\"49\";i:1;s:2:\"53\";i:2;s:2:\"59\";i:3;s:2:\"62\";i:4;s:2:\"67\";i:5;s:3:\"122\";}i:54;a:10:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:2:\"96\";}i:57;a:8:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"101\";i:3;s:3:\"117\";i:4;s:3:\"118\";i:5;s:3:\"124\";i:6;s:3:\"125\";i:7;s:3:\"126\";}i:63;a:13:{i:0;s:2:\"64\";i:1;s:2:\"70\";i:2;s:2:\"73\";i:3;s:2:\"77\";i:4;s:2:\"79\";i:5;s:2:\"81\";i:6;s:2:\"83\";i:7;s:2:\"97\";i:8;s:3:\"103\";i:9;s:3:\"105\";i:10;s:3:\"110\";i:11;s:3:\"111\";i:12;s:3:\"112\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}}i:3;a:4:{i:71;a:10:{i:0;s:2:\"72\";i:1;s:2:\"74\";i:2;s:2:\"76\";i:3;s:2:\"85\";i:4;s:2:\"88\";i:5;s:2:\"89\";i:6;s:2:\"90\";i:7;s:2:\"91\";i:8;s:2:\"92\";i:9;s:2:\"94\";}i:106;a:7:{i:0;s:3:\"107\";i:1;s:3:\"108\";i:2;s:3:\"109\";i:3;s:3:\"113\";i:4;s:3:\"114\";i:5;s:3:\"115\";i:6;s:3:\"116\";}i:119;a:2:{i:0;s:3:\"120\";i:1;s:3:\"121\";}i:123;a:3:{i:0;s:3:\"127\";i:1;s:3:\"128\";i:2;s:3:\"129\";}}i:4;a:0:{}i:5;a:0:{}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:6:{i:0;s:2:\"21\";i:1;s:2:\"38\";i:2;s:2:\"41\";i:3;s:2:\"43\";i:4;s:2:\"44\";i:5;s:2:\"46\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', NULL, 1600502898, 1606303590);
INSERT INTO `qfyu_operators` VALUES (12, 6, 'LMkQ28eRC4+BnOZBOv5n+ksRJ5DSpdyiyFly1rW9zxCobPXJTIHW0A==', '6', 'a:9:{i:0;a:1:{i:0;a:20:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"20\";i:19;s:2:\"21\";}}i:1;a:2:{i:9;a:5:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";}i:12;a:0:{}}i:2;a:10:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:6:{i:0;s:2:\"49\";i:1;s:2:\"53\";i:2;s:2:\"59\";i:3;s:2:\"62\";i:4;s:2:\"67\";i:5;s:3:\"122\";}i:54;a:10:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:2:\"96\";}i:57;a:8:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"101\";i:3;s:3:\"117\";i:4;s:3:\"118\";i:5;s:3:\"124\";i:6;s:3:\"125\";i:7;s:3:\"126\";}i:63;a:13:{i:0;s:2:\"64\";i:1;s:2:\"70\";i:2;s:2:\"73\";i:3;s:2:\"77\";i:4;s:2:\"79\";i:5;s:2:\"81\";i:6;s:2:\"83\";i:7;s:2:\"97\";i:8;s:3:\"103\";i:9;s:3:\"105\";i:10;s:3:\"110\";i:11;s:3:\"111\";i:12;s:3:\"112\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}}i:3;a:4:{i:71;a:10:{i:0;s:2:\"72\";i:1;s:2:\"74\";i:2;s:2:\"76\";i:3;s:2:\"85\";i:4;s:2:\"88\";i:5;s:2:\"89\";i:6;s:2:\"90\";i:7;s:2:\"91\";i:8;s:2:\"92\";i:9;s:2:\"94\";}i:106;a:7:{i:0;s:3:\"107\";i:1;s:3:\"108\";i:2;s:3:\"109\";i:3;s:3:\"113\";i:4;s:3:\"114\";i:5;s:3:\"115\";i:6;s:3:\"116\";}i:119;a:2:{i:0;s:3:\"120\";i:1;s:3:\"121\";}i:123;a:3:{i:0;s:3:\"127\";i:1;s:3:\"128\";i:2;s:3:\"129\";}}i:4;a:0:{}i:5;a:0:{}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:6:{i:0;s:2:\"21\";i:1;s:2:\"38\";i:2;s:2:\"41\";i:3;s:2:\"43\";i:4;s:2:\"44\";i:5;s:2:\"46\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', NULL, 1600502934, 1600938866);
INSERT INTO `qfyu_operators` VALUES (13, 9, 'e5odi8uUDN3SnL4RNvhp9U0Ud8HSo46qlVx007bvnRGgN/nPTNeD1Q==', '5,1,7', 'a:9:{i:0;a:1:{i:0;a:20:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"21\";i:19;s:2:\"20\";}}i:1;a:2:{i:9;a:5:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";}i:12;a:0:{}}i:2;a:11:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:6:{i:0;s:2:\"49\";i:1;s:2:\"53\";i:2;s:2:\"59\";i:3;s:2:\"62\";i:4;s:2:\"67\";i:5;s:3:\"122\";}i:54;a:17:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:3:\"195\";i:10;s:3:\"203\";i:11;s:3:\"204\";i:12;s:3:\"205\";i:13;s:3:\"229\";i:14;s:3:\"230\";i:15;s:3:\"232\";i:16;s:3:\"233\";}i:57;a:8:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"101\";i:3;s:3:\"117\";i:4;s:3:\"118\";i:5;s:3:\"124\";i:6;s:3:\"125\";i:7;s:3:\"126\";}i:63;a:13:{i:0;s:2:\"64\";i:1;s:2:\"70\";i:2;s:2:\"73\";i:3;s:2:\"77\";i:4;s:2:\"79\";i:5;s:2:\"81\";i:6;s:2:\"83\";i:7;s:2:\"97\";i:8;s:3:\"103\";i:9;s:3:\"105\";i:10;s:3:\"110\";i:11;s:3:\"111\";i:12;s:3:\"112\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}i:235;a:1:{i:0;s:3:\"236\";}}i:3;a:8:{i:71;a:10:{i:0;s:2:\"72\";i:1;s:2:\"74\";i:2;s:2:\"76\";i:3;s:2:\"85\";i:4;s:2:\"88\";i:5;s:2:\"89\";i:6;s:2:\"90\";i:7;s:2:\"91\";i:8;s:2:\"92\";i:9;s:2:\"94\";}i:106;a:7:{i:0;s:3:\"107\";i:1;s:3:\"108\";i:2;s:3:\"109\";i:3;s:3:\"113\";i:4;s:3:\"114\";i:5;s:3:\"115\";i:6;s:3:\"116\";}i:119;a:6:{i:0;s:3:\"120\";i:1;s:3:\"121\";i:2;s:3:\"135\";i:3;s:3:\"140\";i:4;s:3:\"143\";i:5;s:3:\"146\";}i:123;a:3:{i:0;s:3:\"127\";i:1;s:3:\"128\";i:2;s:3:\"129\";}i:131;a:7:{i:0;s:3:\"133\";i:1;s:3:\"134\";i:2;s:3:\"149\";i:3;s:3:\"150\";i:4;s:3:\"151\";i:5;s:3:\"152\";i:6;s:3:\"153\";}i:154;a:5:{i:0;s:3:\"164\";i:1;s:3:\"168\";i:2;s:3:\"210\";i:3;s:3:\"214\";i:4;s:3:\"220\";}i:155;a:2:{i:0;s:3:\"157\";i:1;s:3:\"158\";}i:176;a:2:{i:0;s:3:\"177\";i:1;s:3:\"179\";}}i:4;a:0:{}i:5;a:184:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;N;i:5;N;i:6;N;i:7;N;i:8;N;i:9;N;i:10;N;i:11;N;i:12;N;i:13;N;i:14;N;i:15;N;i:16;N;i:17;N;i:18;N;i:19;N;i:20;N;i:21;N;i:22;N;i:23;N;i:24;N;i:25;N;i:26;N;i:27;N;i:28;N;i:29;N;i:30;N;i:31;N;i:32;N;i:33;N;i:34;N;i:35;N;i:36;N;i:37;N;i:38;N;i:39;N;i:40;N;i:41;N;i:42;N;i:43;N;i:44;N;i:45;N;i:46;N;i:47;N;i:48;N;i:49;N;i:50;N;i:51;N;i:52;N;i:53;N;i:54;N;i:55;N;i:56;N;i:57;N;i:58;N;i:59;N;i:60;N;i:61;N;i:62;N;i:63;N;i:64;N;i:65;N;i:66;N;i:67;N;i:68;N;i:69;N;i:70;N;i:71;N;i:72;N;i:73;N;i:74;N;i:75;N;i:76;N;i:77;N;i:78;N;i:79;N;i:80;N;i:81;N;i:82;N;i:83;N;i:84;N;i:85;N;i:86;N;i:87;N;i:88;N;i:89;N;i:90;N;i:91;N;i:92;N;i:93;N;i:94;N;i:95;N;i:96;N;i:97;N;i:98;N;i:99;N;i:100;N;i:101;N;i:102;N;i:103;N;i:104;N;i:105;N;i:106;N;i:107;N;i:108;N;i:109;N;i:110;N;i:111;N;i:112;N;i:113;N;i:114;N;i:115;N;i:116;N;i:117;N;i:118;N;i:119;N;i:120;N;i:121;N;i:122;N;i:123;N;i:124;N;i:125;N;i:126;N;i:127;N;i:128;N;i:129;N;i:130;N;i:131;N;i:132;N;i:133;N;i:134;N;i:135;N;i:136;N;i:137;N;i:138;N;i:139;N;i:140;N;i:141;N;i:142;N;i:143;N;i:144;N;i:145;N;i:146;N;i:147;N;i:148;N;i:149;N;i:150;N;i:151;N;i:152;N;i:153;N;i:154;N;i:155;N;i:156;N;i:157;N;i:158;N;i:159;N;i:160;N;i:161;N;i:162;N;i:163;N;i:164;N;i:165;N;i:166;N;i:167;N;i:168;N;i:169;N;i:170;N;i:171;N;i:172;N;i:173;N;i:174;N;i:175;N;i:176;N;i:177;N;i:178;N;i:179;N;i:180;N;i:181;N;i:182;N;i:183;a:5:{i:0;s:3:\"184\";i:1;s:3:\"186\";i:2;s:3:\"187\";i:3;s:3:\"188\";i:4;s:3:\"201\";}}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:8:{i:0;s:2:\"21\";i:1;s:2:\"38\";i:2;s:2:\"41\";i:3;s:2:\"43\";i:4;s:2:\"44\";i:5;s:2:\"46\";i:6;s:2:\"23\";i:7;s:3:\"198\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', 'a:3:{i:0;i:6;i:1;i:5;i:2;i:4;}', 1600502936, 1608104732);

-- ----------------------------
-- Table structure for qfyu_organization
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_organization`;
CREATE TABLE `qfyu_organization`  (
  `code` char(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织机构编码',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '名称',
  `parent_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上级组织编码',
  `nature` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组织性质',
  PRIMARY KEY (`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '组织机构' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_permit_kinds
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_permit_kinds`;
CREATE TABLE `qfyu_permit_kinds`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) NOT NULL COMMENT '父级id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态 默认1启用 0失效',
  `creater_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `creater_date` datetime(0) NULL DEFAULT NULL,
  `updated_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `updated_date` datetime(0) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 123 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '许可经营类别' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_permit_kinds
-- ----------------------------
INSERT INTO `qfyu_permit_kinds` VALUES (1, 0, 'I类医疗器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (2, 0, 'II类医疗器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (3, 0, 'III类医疗器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (4, 0, '保健食品', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (5, 0, '保健用品', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (6, 0, '化妆品', '测试00', 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (7, 0, '非药品', '11', 1, NULL, NULL, '009', '2020-11-14 10:08:28');
INSERT INTO `qfyu_permit_kinds` VALUES (8, 0, '食品', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (9, 0, '消毒产品', '', 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (10, 0, '药品', '', 1, NULL, NULL, '009', '2020-11-14 10:07:53');
INSERT INTO `qfyu_permit_kinds` VALUES (11, 1, '基础外科手术器械', '测试', 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (12, 1, '显微外科手术器械', '测试', 1, NULL, NULL, '009', '2020-11-14 11:46:48');
INSERT INTO `qfyu_permit_kinds` VALUES (13, 1, '神经外科手术器械', '', 1, NULL, NULL, '009', '2020-11-14 15:33:44');
INSERT INTO `qfyu_permit_kinds` VALUES (14, 1, '眼科手术器械', '测试', 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (15, 1, '耳鼻喉科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (16, 1, '口腔科手术器械', '', 1, NULL, NULL, '009', '2020-11-14 15:34:09');
INSERT INTO `qfyu_permit_kinds` VALUES (17, 1, '胸腔心血管外科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (18, 1, '腹部外科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (19, 1, '泌尿肛肠外科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (20, 1, '矫形外科(骨科)手术器械', '', 1, NULL, NULL, '009', '2020-11-14 15:34:13');
INSERT INTO `qfyu_permit_kinds` VALUES (21, 1, '妇产科用手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (22, 1, '计划生育手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (23, 1, '注射穿刺器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (24, 1, '烧伤（整形）科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (25, 1, '普通诊察器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (26, 1, '医用电子仪器设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (27, 1, '医用光学器具、仪器及内窥镜设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (28, 1, '医用超声仪器及有关设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (29, 1, '医用激光仪器设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (30, 1, '医用高频仪器设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (31, 1, '物理治疗及康复设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (32, 1, '中医器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (33, 1, '医用磁共振设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (34, 1, '医用X射线设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (35, 1, '医用X射线附属设备及部件', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (36, 1, '医用高能射线设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (37, 1, '医用核素设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (38, 1, '医用射线防护用品、装置', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (39, 1, '临床检验分析仪器', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (40, 1, '医用化验和基础设备器具', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (41, 1, '体外循环及血液处理设备', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (42, 1, '植入材料和人工器官', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (43, 1, '手术室、急救室、诊疗室设备及器具', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (44, 1, '口腔科设备及器具', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (45, 1, '病房护理设备及器具', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (46, 1, '消毒和灭菌设备及器具', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (47, 1, '医用冷疗、低温、冷藏设备及器具', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (48, 1, '口腔科材料', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (49, 1, '医用卫生材料及敷料', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (50, 1, '医用缝合材料及粘合剂', NULL, 1, NULL, NULL, '009', '2020-11-14 15:29:22');
INSERT INTO `qfyu_permit_kinds` VALUES (51, 1, '医用高分子材料及制品', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (52, 1, '软件', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (53, 1, '介入器材', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (54, 2, '基础外科手术', NULL, 1, NULL, NULL, '009', '2020-11-16 10:56:02');
INSERT INTO `qfyu_permit_kinds` VALUES (55, 2, '显微外科手术', '测试', 1, NULL, NULL, '009', '2020-11-16 10:56:07');
INSERT INTO `qfyu_permit_kinds` VALUES (56, 2, '神经外科手术器械', '1111', 1, NULL, NULL, '009', '2020-11-14 11:47:16');
INSERT INTO `qfyu_permit_kinds` VALUES (57, 2, '眼科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (58, 2, '耳鼻喉科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (59, 2, '口腔科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (60, 2, '胸腔心血管外科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (61, 2, '腹部外科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (62, 2, '泌尿肛肠外科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (63, 2, '矫形外科(骨科)手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (64, 2, '妇产科用手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (65, 2, '计划生育手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (66, 2, '注射穿刺器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (67, 2, '烧伤（整形）科手术器械', NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (68, 0, '婴儿奶粉', '11', 1, '009', '2020-11-14 10:09:07', '009', '2020-11-14 10:26:42');
INSERT INTO `qfyu_permit_kinds` VALUES (69, 0, '测试11', '11', 1, '009', '2020-11-14 13:41:41', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (70, 2, '普通诊察器械', '测试', 1, '009', '2020-11-14 14:14:57', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (71, 2, '医用电子仪器设备', '', 1, '009', '2020-11-14 14:22:25', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (72, 2, '医用光学器具、仪器及内窥镜设备', '', 1, '009', '2020-11-14 14:28:09', '009', '2020-11-14 15:31:13');
INSERT INTO `qfyu_permit_kinds` VALUES (73, 2, '医用超声仪器及有关设备', '', 1, '009', '2020-11-14 14:30:17', '009', '2020-11-14 15:31:21');
INSERT INTO `qfyu_permit_kinds` VALUES (74, 2, '医用激光仪器设备', '', 1, '009', '2020-11-14 14:31:14', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (75, 2, '医用高频仪器设备11', '', 1, '009', '2020-11-14 14:32:51', '009', '2020-11-14 15:09:49');
INSERT INTO `qfyu_permit_kinds` VALUES (76, 2, '物理治疗及康复设备', '', 1, '009', '2020-11-14 14:34:28', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (77, 2, '中医器械', '', 1, '009', '2020-11-14 14:39:15', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (78, 2, '医用磁共振设备', '', 1, '009', '2020-11-14 14:39:57', '009', '2020-11-14 15:32:44');
INSERT INTO `qfyu_permit_kinds` VALUES (79, 2, '医用X射线设备', '', 1, '009', '2020-11-14 14:41:12', '009', '2020-11-14 15:32:36');
INSERT INTO `qfyu_permit_kinds` VALUES (80, 2, '医用X射线附属设备及部件', '1', 1, '009', '2020-11-14 14:41:29', '009', '2020-11-14 15:31:29');
INSERT INTO `qfyu_permit_kinds` VALUES (81, 2, '医用高能射线设备', '', 1, '009', '2020-11-14 15:35:42', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (82, 2, '医用核素设备', '', 1, '009', '2020-11-14 15:35:50', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (83, 2, '医用射线防护用品、装置', '', 1, '009', '2020-11-14 15:36:00', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (84, 2, '临床检验分析仪器', '', 1, '009', '2020-11-14 15:36:07', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (85, 2, '医用化验和基础设备器具', '', 1, '009', '2020-11-14 15:36:15', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (86, 2, '体外循环及血液处理设备', '', 1, '009', '2020-11-14 15:36:21', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (87, 2, '植入材料和人工器官', '', 1, '009', '2020-11-14 15:36:28', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (88, 2, '手术室、急救室、诊疗室设备及器具', '', 1, '009', '2020-11-14 15:36:37', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (89, 2, '口腔科设备及器具', '', 1, '009', '2020-11-14 15:36:48', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (90, 2, '病房护理设备及器具', '', 1, '009', '2020-11-14 15:36:58', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (91, 2, '消毒和灭菌设备及器具', '', 1, '009', '2020-11-14 15:37:08', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (92, 2, '医用冷疗、低温、冷藏设备及器具', '', 1, '009', '2020-11-14 15:37:19', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (93, 2, '口腔科材料', '', 1, '009', '2020-11-14 15:37:29', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (94, 2, '医用卫生材料及敷料', '', 1, '009', '2020-11-14 15:37:36', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (95, 2, '医用缝合材料及粘合剂', '', 1, '009', '2020-11-14 15:37:43', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (96, 2, '医用高分子材料及制品', '', 1, '009', '2020-11-14 15:37:50', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (97, 2, '软件', '', 1, '009', '2020-11-14 15:37:56', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (98, 2, '介入器材', '', 1, '009', '2020-11-14 15:38:03', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (99, 3, '基础外科手术器械', '', 1, '009', '2020-11-14 15:38:27', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (100, 3, '显微外科手术器械', '', 1, '009', '2020-11-14 15:38:45', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (101, 3, '神经外科手术器械', '', 1, '009', '2020-11-14 15:38:56', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (102, 10, '中药材（收购）', '', 1, '009', '2020-11-14 15:39:18', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (103, 10, '中药材', '', 1, '009', '2020-11-14 15:39:29', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (104, 10, '中药饮片', '', 1, '009', '2020-11-14 15:39:37', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (105, 10, '中成药', '', 1, '009', '2020-11-14 15:39:43', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (106, 10, '化学原料药', '', 1, '009', '2020-11-14 15:39:50', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (107, 10, '化学药制剂', '', 1, '009', '2020-11-14 15:39:56', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (108, 10, '抗生素原料药', '', 1, '009', '2020-11-14 15:40:03', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (109, 10, '抗生素制剂', '', 1, '009', '2020-11-14 15:40:10', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (110, 10, '生化药品', '', 1, '009', '2020-11-14 15:40:17', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (111, 10, '生物制品（除疫苗）', '', 1, '009', '2020-11-14 15:40:23', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (112, 10, '生物制品（含体外诊断试剂；除疫苗）', '', 1, '009', '2020-11-14 15:40:29', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (113, 10, '生物制品（含疫苗）', '', 1, '009', '2020-11-14 15:40:35', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (114, 10, '生物制品（含疫苗和体外诊断试剂）', '', 1, '009', '2020-11-14 15:40:42', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (115, 10, '生物制品（限诊断药品）', '', 1, '009', '2020-11-14 15:40:48', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (116, 10, '体外诊断试剂', '', 1, '009', '2020-11-14 15:40:55', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (117, 7, '医用口罩', '', 1, '009', '2020-11-14 15:53:15', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (118, 9, '84消毒水', '', 1, '009', '2020-11-14 16:21:59', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (119, 9, '74消毒水', '', 1, '009', '2020-11-14 16:22:27', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (120, 69, '测试1111', '', 1, '009', '2020-11-14 16:23:28', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (121, 8, '大米', '', 1, '009', '2020-11-14 16:23:49', NULL, NULL);
INSERT INTO `qfyu_permit_kinds` VALUES (122, 8, '食用油', '', 1, '009', '2020-11-14 16:24:03', NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_power_list
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_power_list`;
CREATE TABLE `qfyu_power_list`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) UNSIGNED NOT NULL,
  `m_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '模块名称',
  `action` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '后台请求方法',
  `menu_id` int(10) NULL DEFAULT NULL COMMENT '菜单ID',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '默认有效 0无效',
  `is_control` tinyint(1) NULL DEFAULT 1 COMMENT '是否权限控制 0不控制',
  `sort` int(10) NOT NULL DEFAULT 1 COMMENT '排序',
  `create_time` timestamp(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `action`(`action`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 286 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_power_list
-- ----------------------------
INSERT INTO `qfyu_power_list` VALUES (1, 0, '系统管理', NULL, 1, 1, 1, 1, '2020-12-17 17:57:42');
INSERT INTO `qfyu_power_list` VALUES (2, 0, '资料管理', NULL, 4, 1, 1, 1, '2020-09-18 10:14:17');
INSERT INTO `qfyu_power_list` VALUES (3, 0, '采购管理', NULL, 7, 1, 1, 1, '2020-09-18 10:14:26');
INSERT INTO `qfyu_power_list` VALUES (4, 0, '销售管理', NULL, 11, 1, 1, 1, '2020-09-18 10:14:34');
INSERT INTO `qfyu_power_list` VALUES (5, 0, '仓储物流', NULL, 12, 1, 1, 1, '2020-12-04 15:55:25');
INSERT INTO `qfyu_power_list` VALUES (6, 0, '财务管理', NULL, 14, 1, 1, 1, '2020-09-18 10:14:49');
INSERT INTO `qfyu_power_list` VALUES (7, 0, '统计分析', NULL, 15, 1, 1, 1, '2020-09-18 10:14:53');
INSERT INTO `qfyu_power_list` VALUES (8, 0, 'GSP管理', NULL, 16, 1, 1, 1, '2020-09-18 10:14:56');
INSERT INTO `qfyu_power_list` VALUES (9, 1, '权限设置', '', NULL, 1, 1, 1, '2020-09-18 16:51:17');
INSERT INTO `qfyu_power_list` VALUES (10, 9, '用户编辑', 'editOp', NULL, 1, 1, 1, '2020-09-18 10:00:46');
INSERT INTO `qfyu_power_list` VALUES (11, 9, '角色编辑', 'editRole', NULL, 1, 1, 1, '2020-09-18 10:01:09');
INSERT INTO `qfyu_power_list` VALUES (12, 1, '操作日志', NULL, NULL, 1, 1, 1, '2020-09-23 09:58:37');
INSERT INTO `qfyu_power_list` VALUES (13, 2, '员工资料', 'employee', 21, 1, 1, 1, '2020-09-18 10:15:59');
INSERT INTO `qfyu_power_list` VALUES (14, 2, '企业机构管理', '', NULL, 1, 1, 1, '2020-09-18 16:52:34');
INSERT INTO `qfyu_power_list` VALUES (15, 14, '编辑部门信息', 'comDepart', NULL, 1, 1, 1, '2020-09-18 10:04:33');
INSERT INTO `qfyu_power_list` VALUES (16, 14, '编辑企业信息', 'addCompany', NULL, 1, 1, 1, '2020-09-18 10:04:59');
INSERT INTO `qfyu_power_list` VALUES (17, 13, '编辑员工信息', 'comEmployee', NULL, 1, 1, 1, '2020-09-18 10:05:28');
INSERT INTO `qfyu_power_list` VALUES (18, 9, '查询', 'powerInit', 3, 1, 1, 1, '2020-09-25 16:05:03');
INSERT INTO `qfyu_power_list` VALUES (19, 14, '查询', 'branchList', 25, 1, 1, 1, '2020-09-26 10:19:23');
INSERT INTO `qfyu_power_list` VALUES (20, 8, '首营品种管理', 'getFirstGoodsList', 22, 1, 1, 1, '2020-09-27 09:26:17');
INSERT INTO `qfyu_power_list` VALUES (21, 20, '新增首营产品', 'getGspCategory', NULL, 1, 1, 1, '2020-09-25 17:40:03');
INSERT INTO `qfyu_power_list` VALUES (22, 9, '确认授权', 'setPower', NULL, 1, 1, 1, '2020-09-25 17:40:00');
INSERT INTO `qfyu_power_list` VALUES (23, 20, '保存提交', 'addFirstGoods', NULL, 1, 1, 1, '2020-12-05 15:31:49');
INSERT INTO `qfyu_power_list` VALUES (26, 13, '查询', 'employeeInit', NULL, 1, 1, 1, '2020-09-26 09:40:19');
INSERT INTO `qfyu_power_list` VALUES (27, 13, '添加', 'comEmployee', NULL, 1, 1, 1, '2020-09-26 10:05:11');
INSERT INTO `qfyu_power_list` VALUES (28, 9, '设置角色', 'setOpRole', NULL, 1, 1, 1, '2020-10-09 18:00:17');
INSERT INTO `qfyu_power_list` VALUES (29, 2, '商品类别管理', '', 50, 1, 1, 1, '2020-11-11 18:12:57');
INSERT INTO `qfyu_power_list` VALUES (30, 29, '查询', 'categoryInit', 50, 1, 1, 1, '2020-10-10 10:08:38');
INSERT INTO `qfyu_power_list` VALUES (31, 2, '价格体系管理', '', NULL, 1, 1, 1, '2020-10-13 09:47:05');
INSERT INTO `qfyu_power_list` VALUES (32, 31, '查询', 'getPriceSystem', NULL, 1, 1, 1, '2020-10-13 09:46:37');
INSERT INTO `qfyu_power_list` VALUES (33, 8, '首营企业申请', '', NULL, 1, 1, 1, '2020-10-17 14:34:57');
INSERT INTO `qfyu_power_list` VALUES (34, 33, '初始化', 'editEnterpriseInit', NULL, 1, 1, 1, '2020-10-17 14:34:59');
INSERT INTO `qfyu_power_list` VALUES (35, 21, '审核首营产品资料', 'checkFirstGoods', NULL, 1, 1, 1, '2020-10-17 16:55:21');
INSERT INTO `qfyu_power_list` VALUES (36, 2, '商品类别管理', '', 5, 0, 1, 1, '2020-11-11 18:14:53');
INSERT INTO `qfyu_power_list` VALUES (37, 29, '获取自定义许可类别', 'getCustomList', NULL, 1, 1, 1, '2020-11-11 18:14:36');
INSERT INTO `qfyu_power_list` VALUES (38, 20, '审核首营产品资料', 'checkFirstGoods', NULL, 1, 1, 1, '2020-10-19 14:39:38');
INSERT INTO `qfyu_power_list` VALUES (39, 33, '保存', 'saveEnterprise', NULL, 1, 1, 1, '2020-10-19 15:21:11');
INSERT INTO `qfyu_power_list` VALUES (40, 33, '首营企业查询', 'enterpriseList', NULL, 1, 1, 1, '2020-10-21 17:18:39');
INSERT INTO `qfyu_power_list` VALUES (41, 20, '首营品种审批', 'admCheckFirstGoods', NULL, 1, 1, 1, '2020-10-21 18:29:44');
INSERT INTO `qfyu_power_list` VALUES (42, 33, '图片上传', 'enterPriseUpload', NULL, 1, 1, 1, '2020-10-23 14:43:33');
INSERT INTO `qfyu_power_list` VALUES (43, 20, '上传商品证照', 'firstGoodsUpload', NULL, 1, 1, 1, '2020-10-23 17:32:02');
INSERT INTO `qfyu_power_list` VALUES (44, 20, '保存商品证照', 'firstGoodsInfoUpload', NULL, 1, 1, 1, '2020-10-24 11:08:04');
INSERT INTO `qfyu_power_list` VALUES (45, 33, '保存供方销售人员信息', 'saveContacts', NULL, 1, 1, 1, '2020-10-24 14:56:58');
INSERT INTO `qfyu_power_list` VALUES (46, 20, '删除商品证照', 'firstGoodsImgDel', NULL, 1, 1, 1, '2020-10-26 11:00:07');
INSERT INTO `qfyu_power_list` VALUES (47, 33, '审核首营企业资料', 'examEnterprise', NULL, 1, 1, 1, '2020-10-26 17:23:09');
INSERT INTO `qfyu_power_list` VALUES (48, 2, '仓库及库位管理', '', 24, 1, 1, 1, '2020-11-04 15:41:51');
INSERT INTO `qfyu_power_list` VALUES (49, 48, '查询', 'ware_list', NULL, 1, 1, 1, '2020-12-04 11:52:35');
INSERT INTO `qfyu_power_list` VALUES (50, 33, '首营信息审批', 'approvalProExam', NULL, 1, 1, 1, '2020-10-27 16:49:13');
INSERT INTO `qfyu_power_list` VALUES (51, 31, '新增', 'addOrUpdatePriceSystem', NULL, 1, 1, 1, '2020-10-28 08:52:10');
INSERT INTO `qfyu_power_list` VALUES (52, 31, '删除', 'delPriceSystem', NULL, 1, 1, 1, '2020-10-28 10:27:34');
INSERT INTO `qfyu_power_list` VALUES (53, 48, '初始化', 'ware_init', NULL, 1, 0, 3, '2020-12-04 11:52:09');
INSERT INTO `qfyu_power_list` VALUES (54, 2, '商品资料管理', '', 4, 1, 1, 1, '2020-10-29 08:46:53');
INSERT INTO `qfyu_power_list` VALUES (55, 54, '查询', 'getCommodityList', NULL, 1, 1, 1, '2020-10-29 08:47:15');
INSERT INTO `qfyu_power_list` VALUES (56, 54, '新增', 'newCommodity', NULL, 1, 1, 1, '2020-10-30 14:31:06');
INSERT INTO `qfyu_power_list` VALUES (57, 2, '供应商管理', '', 222, 1, 1, 1, '2020-10-31 10:23:38');
INSERT INTO `qfyu_power_list` VALUES (58, 57, '查询', 'getSupplier', NULL, 1, 1, 1, '2020-10-31 10:22:53');
INSERT INTO `qfyu_power_list` VALUES (59, 48, '保存', 'ware_save', NULL, 1, 1, 4, '2020-12-04 11:52:14');
INSERT INTO `qfyu_power_list` VALUES (60, 54, '查询首营品种', 'getComFirstGoodsList', NULL, 1, 1, 1, '2020-10-31 17:31:07');
INSERT INTO `qfyu_power_list` VALUES (61, 29, '新增功能类别', 'setKinds', NULL, 1, 1, 1, '2020-11-02 09:34:07');
INSERT INTO `qfyu_power_list` VALUES (62, 48, '查询货位', 'warepos_list', NULL, 1, 1, 7, '2020-12-04 11:53:48');
INSERT INTO `qfyu_power_list` VALUES (63, 2, '客户资料管理', NULL, 221, 1, 1, 1, '2020-11-04 09:50:47');
INSERT INTO `qfyu_power_list` VALUES (64, 63, '查询', 'customerList', NULL, 1, 1, 1, '2020-11-04 09:51:43');
INSERT INTO `qfyu_power_list` VALUES (65, 2, '结算方式', NULL, 28, 1, 1, 1, '2020-11-04 15:39:57');
INSERT INTO `qfyu_power_list` VALUES (66, 65, '查询', 'settlementList', NULL, 1, 1, 1, '2020-11-04 15:40:29');
INSERT INTO `qfyu_power_list` VALUES (67, 48, '保存货位', 'warepos_save', NULL, 1, 1, 8, '2020-12-04 11:53:39');
INSERT INTO `qfyu_power_list` VALUES (68, 65, '新增/编辑保存', 'saveSettlement', NULL, 1, 1, 1, '2020-11-04 18:05:18');
INSERT INTO `qfyu_power_list` VALUES (69, 57, '保存', 'comSupplier', NULL, 1, 1, 1, '2020-11-04 18:32:00');
INSERT INTO `qfyu_power_list` VALUES (70, 63, '编辑客户资料', 'customerEdit', NULL, 1, 0, 1, '2020-12-03 11:11:12');
INSERT INTO `qfyu_power_list` VALUES (71, 3, '采购计划', NULL, 9, 1, 1, 1, '2020-11-06 11:13:03');
INSERT INTO `qfyu_power_list` VALUES (72, 71, '新增/修改查询', 'initPlan', NULL, 1, 0, 1, '2020-11-06 13:49:12');
INSERT INTO `qfyu_power_list` VALUES (73, 63, '选择客户', 'selectCustomer', NULL, 1, 0, 1, '2020-11-16 09:45:09');
INSERT INTO `qfyu_power_list` VALUES (74, 71, '校验用户身份', 'verifyPlan', NULL, 1, 0, 1, '2020-11-06 13:48:54');
INSERT INTO `qfyu_power_list` VALUES (75, 54, '审核', 'checkerCommodity', NULL, 1, 1, 1, '2020-11-06 14:39:33');
INSERT INTO `qfyu_power_list` VALUES (76, 54, '选择商品信息', 'chooseGoodsList', NULL, 1, 0, 1, '2020-12-10 15:19:01');
INSERT INTO `qfyu_power_list` VALUES (77, 63, '选择送货线路', 'selectDelivery', NULL, 1, 0, 1, '2020-11-16 09:45:13');
INSERT INTO `qfyu_power_list` VALUES (78, 54, '获取商品价格', 'getPriceList', NULL, 1, 1, 1, '2020-11-07 09:53:04');
INSERT INTO `qfyu_power_list` VALUES (79, 63, '选择地区', 'selectArea', NULL, 1, 0, 1, '2020-11-16 09:45:15');
INSERT INTO `qfyu_power_list` VALUES (80, 54, '修改商品价格', 'editPrice', NULL, 1, 1, 1, '2020-11-07 14:09:26');
INSERT INTO `qfyu_power_list` VALUES (81, 63, '选择员工', 'selectEmployee', NULL, 1, 0, 1, '2020-11-16 09:45:18');
INSERT INTO `qfyu_power_list` VALUES (82, 54, '获取商品证照', 'getGoodsPhoto', NULL, 1, 1, 1, '2020-11-07 16:33:28');
INSERT INTO `qfyu_power_list` VALUES (83, 63, '选择部门', 'selectDepart', NULL, 1, 0, 1, '2020-11-16 09:45:20');
INSERT INTO `qfyu_power_list` VALUES (84, 54, '删除商品证照', 'delGoodsPhoto', NULL, 1, 1, 1, '2020-11-09 15:39:55');
INSERT INTO `qfyu_power_list` VALUES (85, 71, '保存', 'savePlanOrder', NULL, 1, 1, 1, '2020-11-10 10:54:20');
INSERT INTO `qfyu_power_list` VALUES (86, 54, '获取商品详情', 'getCommodityInfo', NULL, 1, 1, 1, '2020-12-15 18:07:38');
INSERT INTO `qfyu_power_list` VALUES (87, 29, '新增自定义许可经营类别', 'addCustomKinds', NULL, 1, 1, 1, '2020-11-11 18:07:28');
INSERT INTO `qfyu_power_list` VALUES (88, 71, '查询', 'planList', NULL, 1, 1, 1, '2020-11-12 08:38:19');
INSERT INTO `qfyu_power_list` VALUES (89, 71, '审核', 'checkPlanOrder', NULL, 1, 1, 1, '2020-11-12 17:08:32');
INSERT INTO `qfyu_power_list` VALUES (90, 71, '还原', 'backPlanOrder', NULL, 1, 1, 1, '2020-11-12 17:41:52');
INSERT INTO `qfyu_power_list` VALUES (91, 71, '结案', 'closePlanOrder', NULL, 1, 1, 1, '2020-11-12 18:04:43');
INSERT INTO `qfyu_power_list` VALUES (92, 71, '删除', 'deletePlanOrder', NULL, 1, 1, 1, '2020-11-13 11:49:27');
INSERT INTO `qfyu_power_list` VALUES (93, 29, '删除自定义许可经营类别小类', 'delCustomKinds', NULL, 1, 1, 1, '2020-11-13 13:57:32');
INSERT INTO `qfyu_power_list` VALUES (94, 71, '生成订单', 'generateOrder', NULL, 1, 1, 1, '2020-11-13 14:09:41');
INSERT INTO `qfyu_power_list` VALUES (95, 29, '获取许可经营小类', 'getDelKinds', NULL, 1, 1, 1, '2020-11-13 16:50:25');
INSERT INTO `qfyu_power_list` VALUES (96, 54, '选择商品', 'chooseGoodsList', NULL, 1, 0, 1, '2020-11-16 11:17:30');
INSERT INTO `qfyu_power_list` VALUES (97, 63, '选择经营类别', 'selectDdkind', NULL, 1, 0, 1, '2020-11-16 09:45:22');
INSERT INTO `qfyu_power_list` VALUES (98, 29, '新增/编辑许可大类', 'setPermitKinds', NULL, 1, 1, 1, '2020-11-14 09:20:31');
INSERT INTO `qfyu_power_list` VALUES (99, 29, '删除许可大类', 'delPermitKinds', NULL, 1, 1, 1, '2020-11-14 10:14:11');
INSERT INTO `qfyu_power_list` VALUES (100, 29, '新增/编辑许可小类', 'editSmallPermitKind', NULL, 1, 1, 1, '2020-11-14 11:08:22');
INSERT INTO `qfyu_power_list` VALUES (101, 57, '选择供应商', 'chooseProvider', NULL, 1, 0, 1, '2020-11-14 11:10:23');
INSERT INTO `qfyu_power_list` VALUES (102, 29, '删除许可小类', 'delSmallPermitKind', NULL, 1, 1, 1, '2020-11-14 15:51:04');
INSERT INTO `qfyu_power_list` VALUES (103, 63, '查看已设置的经营类别', 'getCustDdk', NULL, 1, 0, 1, '2020-11-16 09:45:28');
INSERT INTO `qfyu_power_list` VALUES (104, 29, '选择许可经营大/小类', 'getPopupKind', NULL, 1, 1, 1, '2020-11-14 17:23:32');
INSERT INTO `qfyu_power_list` VALUES (105, 63, '新增/编辑', 'saveCust', NULL, 1, 0, 1, '2020-11-16 09:47:24');
INSERT INTO `qfyu_power_list` VALUES (106, 3, '缺货登记', NULL, 8, 1, 1, 1, '2020-11-18 09:04:10');
INSERT INTO `qfyu_power_list` VALUES (107, 106, '查询', 'lackList', NULL, 1, 1, 1, '2020-11-18 09:14:36');
INSERT INTO `qfyu_power_list` VALUES (108, 106, '新增/修改初始化', 'initLack', NULL, 1, 0, 1, '2020-11-18 14:47:31');
INSERT INTO `qfyu_power_list` VALUES (109, 106, '保存', 'saveLackOrder', NULL, 1, 1, 1, '2020-11-18 16:23:35');
INSERT INTO `qfyu_power_list` VALUES (110, 63, '客户联系人管理', 'contactList', NULL, 1, 1, 1, '2020-11-18 17:17:58');
INSERT INTO `qfyu_power_list` VALUES (111, 63, '客户洽谈记录', 'negList', NULL, 1, 1, 1, '2020-11-18 19:14:02');
INSERT INTO `qfyu_power_list` VALUES (112, 63, '客户证照列表', 'cimgList', NULL, 1, 1, 1, '2020-11-19 08:47:49');
INSERT INTO `qfyu_power_list` VALUES (113, 106, '审核', 'checkLackOrder', NULL, 1, 1, 1, '2020-11-19 09:42:39');
INSERT INTO `qfyu_power_list` VALUES (114, 106, '还原', 'resetLackOrder', NULL, 1, 1, 1, '2020-11-19 09:43:53');
INSERT INTO `qfyu_power_list` VALUES (115, 106, '转单', 'transPlanOrder', NULL, 1, 1, 1, '2020-11-19 09:45:41');
INSERT INTO `qfyu_power_list` VALUES (116, 106, '删除', 'deleteLackOrder', NULL, 1, 1, 1, '2020-11-19 14:57:10');
INSERT INTO `qfyu_power_list` VALUES (117, 57, '撤销', 'revokeSupplier', NULL, 1, 1, 1, '2020-11-21 18:02:47');
INSERT INTO `qfyu_power_list` VALUES (118, 57, '审核', 'examSupplier', NULL, 1, 1, 1, '2020-11-21 18:02:43');
INSERT INTO `qfyu_power_list` VALUES (119, 3, '来货登记', NULL, 26, 1, 1, 1, '2020-11-23 14:47:51');
INSERT INTO `qfyu_power_list` VALUES (120, 119, '查询', 'getRegisterList', NULL, 1, 1, 1, '2020-11-23 14:49:23');
INSERT INTO `qfyu_power_list` VALUES (121, 119, '新增/编辑', 'getRegisterDel', NULL, 1, 1, 1, '2020-11-23 15:29:13');
INSERT INTO `qfyu_power_list` VALUES (122, 48, '选择仓库', 'getWarehouseMod', NULL, 1, 1, 5, '2020-12-04 11:53:15');
INSERT INTO `qfyu_power_list` VALUES (123, 3, '采购合同', NULL, 10, 1, 1, 1, '2020-11-24 08:50:00');
INSERT INTO `qfyu_power_list` VALUES (124, 57, '添加编辑协议品种', 'comVarieties', NULL, 1, 0, 1, '2020-11-24 16:52:19');
INSERT INTO `qfyu_power_list` VALUES (125, 57, '选择供方销售人员', 'chooseSupsales', NULL, 1, 0, 1, '2020-11-24 14:51:27');
INSERT INTO `qfyu_power_list` VALUES (126, 57, '查询协议品种', 'getProGoods', NULL, 1, 0, 1, '2020-11-24 16:51:53');
INSERT INTO `qfyu_power_list` VALUES (127, 123, '初始化', 'initContract', NULL, 1, 0, 1, '2020-11-25 16:15:49');
INSERT INTO `qfyu_power_list` VALUES (128, 123, '查询', 'contractList', NULL, 1, 1, 1, '2020-11-25 16:16:15');
INSERT INTO `qfyu_power_list` VALUES (129, 123, '保存', 'saveContract', NULL, 1, 1, 1, '2020-11-25 16:16:32');
INSERT INTO `qfyu_power_list` VALUES (130, 9, '岗位权限授权', 'setOpPost', NULL, 1, 1, 1, '2020-11-26 11:01:14');
INSERT INTO `qfyu_power_list` VALUES (131, 3, '采购订单', NULL, 18, 1, 1, 1, '2020-11-26 11:22:28');
INSERT INTO `qfyu_power_list` VALUES (132, 131, '初始化查询', 'initPurOrder', NULL, 1, 0, 1, '2020-11-26 11:23:34');
INSERT INTO `qfyu_power_list` VALUES (133, 131, '查询', 'purOrderList', NULL, 1, 1, 1, '2020-11-26 11:23:17');
INSERT INTO `qfyu_power_list` VALUES (134, 131, '保存', 'savePurOrder', NULL, 1, 1, 1, '2020-11-26 11:23:47');
INSERT INTO `qfyu_power_list` VALUES (135, 119, '保存', 'addRegister', NULL, 1, 1, 1, '2020-11-26 17:53:26');
INSERT INTO `qfyu_power_list` VALUES (136, 123, '选择', 'chooseContractList', NULL, 1, 0, 1, '2020-11-26 18:35:49');
INSERT INTO `qfyu_power_list` VALUES (137, 57, '供方销售人员保存', 'saveProSales', NULL, 1, 1, 1, '2020-11-27 10:48:19');
INSERT INTO `qfyu_power_list` VALUES (138, 57, '查询供方联系人', 'getProSales', NULL, 1, 0, 1, '2020-11-27 10:48:14');
INSERT INTO `qfyu_power_list` VALUES (139, 57, '设置默认联系人', 'setProSalesDefault', NULL, 1, 0, 1, '2020-11-28 11:42:00');
INSERT INTO `qfyu_power_list` VALUES (140, 119, '查看发票', 'getBillDetail', NULL, 1, 1, 1, '2020-11-28 13:58:05');
INSERT INTO `qfyu_power_list` VALUES (141, 57, '保存联系记录', 'saveRecords', NULL, 1, 0, 1, '2020-11-28 15:46:35');
INSERT INTO `qfyu_power_list` VALUES (142, 57, '查询联系记录', 'getRecords', NULL, 1, 0, 1, '2020-11-28 16:21:44');
INSERT INTO `qfyu_power_list` VALUES (143, 119, '新增发票', 'editBill', NULL, 1, 1, 1, '2020-11-28 16:27:22');
INSERT INTO `qfyu_power_list` VALUES (144, 57, '保存自产商品', 'comProduced', NULL, 1, 0, 1, '2020-11-28 17:41:59');
INSERT INTO `qfyu_power_list` VALUES (145, 57, '查询自产商品', 'getProduced', NULL, 1, 0, 1, '2020-11-28 17:58:19');
INSERT INTO `qfyu_power_list` VALUES (146, 119, '审核', 'checkRegister', NULL, 1, 1, 1, '2020-11-30 10:29:43');
INSERT INTO `qfyu_power_list` VALUES (147, 57, '证照图片', 'getProvPhoto', NULL, 1, 0, 1, '2020-11-30 11:53:09');
INSERT INTO `qfyu_power_list` VALUES (148, 57, '保存证照', 'comProvPhoto', NULL, 1, 0, 1, '2020-11-30 15:23:01');
INSERT INTO `qfyu_power_list` VALUES (149, 131, '审核', 'checkPurOrder', NULL, 1, 1, 1, '2020-11-30 16:01:48');
INSERT INTO `qfyu_power_list` VALUES (150, 131, '还原', 'backPurOrder', NULL, 1, 1, 1, '2020-11-30 16:02:12');
INSERT INTO `qfyu_power_list` VALUES (151, 131, '结案', 'closePurOrder', NULL, 1, 1, 1, '2020-11-30 16:02:31');
INSERT INTO `qfyu_power_list` VALUES (152, 131, '删除', 'deletePurOrder', NULL, 1, 1, 1, '2020-11-30 16:02:47');
INSERT INTO `qfyu_power_list` VALUES (153, 131, '转单', 'generateRegOrder', NULL, 1, 1, 1, '2020-11-30 16:03:04');
INSERT INTO `qfyu_power_list` VALUES (154, 3, '质量验收', NULL, 32, 1, 1, 1, '2020-12-01 11:28:56');
INSERT INTO `qfyu_power_list` VALUES (155, 3, '质量验收默认设置', '', 223, 1, 1, 1, '2020-12-01 11:30:49');
INSERT INTO `qfyu_power_list` VALUES (156, 57, '供方销售人员授权品种管理', 'getProGrant', NULL, 1, 0, 1, '2020-11-30 19:06:40');
INSERT INTO `qfyu_power_list` VALUES (157, 155, '修改', 'editGoodsCheckDefault', NULL, 1, 1, 1, '2020-12-01 11:27:51');
INSERT INTO `qfyu_power_list` VALUES (158, 155, '查询', 'getGoodsCheckDefault', NULL, 1, 1, 1, '2020-12-01 11:29:33');
INSERT INTO `qfyu_power_list` VALUES (159, 57, '保存供销人员授权品种', 'comProvGrant', NULL, 1, 1, 1, '2020-12-01 11:34:25');
INSERT INTO `qfyu_power_list` VALUES (160, 63, '查看客户联系人', 'editContact', NULL, 1, 0, 1, '2020-12-01 17:58:23');
INSERT INTO `qfyu_power_list` VALUES (161, 63, '编辑客户联系人', 'saveCustContact', NULL, 1, 1, 1, '2020-12-04 17:45:06');
INSERT INTO `qfyu_power_list` VALUES (162, 63, '删除联系人', 'delCustConcat', NULL, 1, 1, 1, '2020-12-04 17:45:03');
INSERT INTO `qfyu_power_list` VALUES (163, 63, '设置默认联系人', 'defCustConcat', NULL, 1, 0, 1, '2020-12-02 12:01:44');
INSERT INTO `qfyu_power_list` VALUES (164, 154, '获取普通药品质量验收明细', 'getGeneralMedicine', NULL, 1, 1, 1, '2020-12-03 08:47:47');
INSERT INTO `qfyu_power_list` VALUES (165, 57, '检测供应商资料', 'checkProv', NULL, 1, 0, 1, '2020-12-07 17:04:57');
INSERT INTO `qfyu_power_list` VALUES (166, 4, '销售合同', '', 53, 1, 1, 1, '2020-12-03 11:09:31');
INSERT INTO `qfyu_power_list` VALUES (167, 166, '上传销售合同', 'upSalesContract', NULL, 1, 0, 1, '2020-12-03 10:10:58');
INSERT INTO `qfyu_power_list` VALUES (168, 154, '审核质量验收单', 'checkQuality', NULL, 1, 1, 1, '2020-12-03 11:09:22');
INSERT INTO `qfyu_power_list` VALUES (169, 166, '初始化', 'salesContractInit', NULL, 1, 0, 1, '2020-12-03 11:11:37');
INSERT INTO `qfyu_power_list` VALUES (170, 63, '新增/编辑业务联系记录', 'saveBusiness', NULL, 1, 1, 1, '2020-12-04 17:44:57');
INSERT INTO `qfyu_power_list` VALUES (171, 63, '删除业务联系记录', 'delBusiness', NULL, 1, 1, 1, '2020-12-04 17:44:54');
INSERT INTO `qfyu_power_list` VALUES (172, 63, '查看客户证照', 'getCustPhoto', NULL, 1, 0, 1, '2020-12-03 15:12:59');
INSERT INTO `qfyu_power_list` VALUES (173, 63, '上传客户证照', 'custImgUpload', NULL, 1, 0, 1, '2020-12-03 16:57:29');
INSERT INTO `qfyu_power_list` VALUES (174, 63, '新增/修改客户证照', 'comCustPhoto', NULL, 1, 1, 1, '2020-12-04 17:44:49');
INSERT INTO `qfyu_power_list` VALUES (175, 63, '删除证照', 'delCustPhoto', NULL, 1, 1, 1, '2020-12-04 17:44:45');
INSERT INTO `qfyu_power_list` VALUES (176, 3, '来货拒收', NULL, 39, 1, 1, 1, '2020-12-04 09:53:15');
INSERT INTO `qfyu_power_list` VALUES (177, 176, '查询', 'getGoodsRejectionList', NULL, 1, 1, 1, '2020-12-04 09:53:36');
INSERT INTO `qfyu_power_list` VALUES (178, 166, '保存', 'comSalesContract', NULL, 1, 1, 1, '2020-12-09 17:15:40');
INSERT INTO `qfyu_power_list` VALUES (179, 176, '获取详情', 'getGoodsRejectionDtl', NULL, 1, 1, 1, '2020-12-04 10:50:42');
INSERT INTO `qfyu_power_list` VALUES (180, 63, '客户协议品种', 'custGoodsList', NULL, 1, 0, 1, '2020-12-04 11:15:01');
INSERT INTO `qfyu_power_list` VALUES (181, 48, '启用/禁用', 'ware_set', NULL, 1, 1, 6, '2020-12-04 11:53:17');
INSERT INTO `qfyu_power_list` VALUES (183, 5, '验收入库/复核', NULL, 107, 1, 1, 1, '2020-12-04 15:55:44');
INSERT INTO `qfyu_power_list` VALUES (184, 183, '查询', 'stockReceiveList', NULL, 1, 1, 1, '2020-12-04 15:53:41');
INSERT INTO `qfyu_power_list` VALUES (185, 183, '初始化', 'initStockReceive', NULL, 1, 0, 1, '2020-12-04 15:53:39');
INSERT INTO `qfyu_power_list` VALUES (186, 183, '审核', 'checkStockReceive', NULL, 1, 1, 1, '2020-12-04 15:53:37');
INSERT INTO `qfyu_power_list` VALUES (187, 183, '还原', 'backStockReceive', NULL, 1, 1, 1, '2020-12-04 15:04:08');
INSERT INTO `qfyu_power_list` VALUES (188, 183, '结案', 'closeStockReceive', NULL, 1, 1, 1, '2020-12-04 16:10:22');
INSERT INTO `qfyu_power_list` VALUES (189, 63, '新增/修改协议品种', 'comCustGoods', NULL, 1, 1, 1, '2020-12-04 17:44:41');
INSERT INTO `qfyu_power_list` VALUES (190, 63, '删除协议品种', 'delCustGoods', NULL, 1, 1, 1, '2020-12-04 18:38:59');
INSERT INTO `qfyu_power_list` VALUES (191, 4, '销售报价单', '', 54, 1, 1, 1, '2020-12-05 17:49:04');
INSERT INTO `qfyu_power_list` VALUES (192, 191, '查询', 'selSpeerList', NULL, 1, 1, 1, '2020-12-12 10:58:05');
INSERT INTO `qfyu_power_list` VALUES (193, 5, '库存盘点', NULL, 99, 1, 1, 1, '2020-12-07 09:31:34');
INSERT INTO `qfyu_power_list` VALUES (194, 193, '账面库存结存单', 'bookList', 100, 1, 1, 1, '2020-12-07 15:49:00');
INSERT INTO `qfyu_power_list` VALUES (195, 54, '获取商品功能类别', 'getGoodsCategory', NULL, 1, 1, 1, '2020-12-07 11:53:04');
INSERT INTO `qfyu_power_list` VALUES (196, 63, '选择客户联系人', 'selectCustomerSales', NULL, 1, 0, 1, '2020-12-07 13:57:49');
INSERT INTO `qfyu_power_list` VALUES (197, 193, '编辑结存单', 'editAccstock', NULL, 1, 0, 1, '2020-12-12 10:11:49');
INSERT INTO `qfyu_power_list` VALUES (198, 20, '获取商品证照', 'getFirstGoodsPhoto', NULL, 1, 1, 1, '2020-12-07 16:18:22');
INSERT INTO `qfyu_power_list` VALUES (199, 191, '编辑', 'editSpeerInit', NULL, 1, 1, 1, '2020-12-12 19:40:53');
INSERT INTO `qfyu_power_list` VALUES (200, 183, '设定收货仓', 'setWare', NULL, 1, 0, 1, '2020-12-09 14:11:45');
INSERT INTO `qfyu_power_list` VALUES (201, 183, '保存', 'saveStockReceive', NULL, 1, 1, 1, '2020-12-09 14:48:51');
INSERT INTO `qfyu_power_list` VALUES (202, 191, '提交', 'comSelSpeer', NULL, 1, 1, 1, '2020-12-12 10:58:18');
INSERT INTO `qfyu_power_list` VALUES (203, 54, '获取商品库位', 'getGoodsWareList', NULL, 1, 1, 1, '2020-12-10 11:41:07');
INSERT INTO `qfyu_power_list` VALUES (204, 54, '新增商品库位', 'addGoodsWare', NULL, 1, 1, 1, '2020-12-10 13:34:54');
INSERT INTO `qfyu_power_list` VALUES (205, 54, '删除商品库位', 'delGoodsWare', NULL, 1, 1, 1, '2020-12-10 14:19:12');
INSERT INTO `qfyu_power_list` VALUES (206, 193, '新增结存单', 'addAccstock', NULL, 1, 1, 1, '2020-12-10 15:40:12');
INSERT INTO `qfyu_power_list` VALUES (207, 191, '审核', 'auditSelSpeer', NULL, 1, 1, 1, '2020-12-12 10:58:29');
INSERT INTO `qfyu_power_list` VALUES (208, 191, '还原', 'reductionSelSpeer', NULL, 1, 1, 1, '2020-12-12 10:58:31');
INSERT INTO `qfyu_power_list` VALUES (209, 193, '修改结存单', 'upAccstock', NULL, 1, 1, 1, '2020-12-11 18:27:33');
INSERT INTO `qfyu_power_list` VALUES (210, 154, '查询', 'getQualityAllList', NULL, 1, 1, 1, '2020-12-12 10:00:20');
INSERT INTO `qfyu_power_list` VALUES (211, 193, '审核结存单', 'checkAccstock', NULL, 1, 1, 1, '2020-12-12 11:15:23');
INSERT INTO `qfyu_power_list` VALUES (212, 191, '转单', 'transferSelSpeer', NULL, 1, 1, 1, '2020-12-12 10:59:03');
INSERT INTO `qfyu_power_list` VALUES (213, 193, '删除结存单', 'delAccstock', NULL, 1, 1, 1, '2020-12-12 11:15:15');
INSERT INTO `qfyu_power_list` VALUES (214, 154, '保存', 'editGoodsCheckAccept', NULL, 1, 1, 1, '2020-12-12 17:02:59');
INSERT INTO `qfyu_power_list` VALUES (215, 4, '销售订单', NULL, 56, 1, 1, 1, '2020-12-12 19:29:11');
INSERT INTO `qfyu_power_list` VALUES (216, 215, '查询', 'selOrderList', NULL, 1, 1, 1, '2020-12-12 19:34:08');
INSERT INTO `qfyu_power_list` VALUES (217, 215, '编辑', 'editSelOrderInit', NULL, 1, 1, 1, '2020-12-12 19:39:16');
INSERT INTO `qfyu_power_list` VALUES (218, 1, 'initApp', 'initApp', NULL, 1, 0, 1, '2020-12-14 11:52:13');
INSERT INTO `qfyu_power_list` VALUES (219, 193, '实物盘点表', 'invAccstock', NULL, 1, 0, 1, '2020-12-14 14:33:01');
INSERT INTO `qfyu_power_list` VALUES (221, 215, '选择合同', 'selContract', NULL, 1, 0, 1, '2020-12-15 10:00:16');
INSERT INTO `qfyu_power_list` VALUES (222, 193, '结存单分发', 'saveAccstock', NULL, 1, 1, 1, '2020-12-15 10:07:18');
INSERT INTO `qfyu_power_list` VALUES (223, 215, '审核', 'auditSelOrder', NULL, 1, 1, 1, '2020-12-15 14:57:55');
INSERT INTO `qfyu_power_list` VALUES (224, 215, '撤回', 'reductionSelOrder', NULL, 1, 1, 1, '2020-12-15 14:59:20');
INSERT INTO `qfyu_power_list` VALUES (225, 215, '转单', 'transferSelOrder', NULL, 1, 1, 1, '2020-12-15 14:59:22');
INSERT INTO `qfyu_power_list` VALUES (226, 193, '实物盘点单', 'realstock', 101, 1, 1, 1, '2020-12-15 15:53:36');
INSERT INTO `qfyu_power_list` VALUES (227, 193, '实物盘点单审核', 'checkReal', NULL, 1, 1, 1, '2020-12-15 17:29:44');
INSERT INTO `qfyu_power_list` VALUES (229, 54, '获取商品控销类别', 'getSalesCategoryList', NULL, 1, 1, 1, '2020-12-16 10:28:05');
INSERT INTO `qfyu_power_list` VALUES (230, 54, '新增/编辑控销类别', 'editSalesCategory', NULL, 1, 1, 1, '2020-12-16 10:28:08');
INSERT INTO `qfyu_power_list` VALUES (231, 193, '删除实物盘点单', 'delRealstock', NULL, 1, 1, 1, '2020-12-16 11:00:31');
INSERT INTO `qfyu_power_list` VALUES (232, 54, '删除商品控销类别', 'delSalesCategory', NULL, 1, 1, 1, '2020-12-16 11:42:43');
INSERT INTO `qfyu_power_list` VALUES (233, 54, '获取商品库存信息', 'getGoodsQty', NULL, 1, 1, 1, '2020-12-16 13:53:46');
INSERT INTO `qfyu_power_list` VALUES (234, 193, '编辑实物盘点单', 'editRealstock', NULL, 1, 1, 1, '2020-12-16 13:54:46');
INSERT INTO `qfyu_power_list` VALUES (235, 2, '地区资料', '', 224, 1, 1, 1, '2020-12-16 15:45:14');
INSERT INTO `qfyu_power_list` VALUES (236, 235, '查询', 'getAreaList', NULL, 1, 1, 1, '2020-12-16 15:45:01');
INSERT INTO `qfyu_power_list` VALUES (237, 193, '实物盘点新增/修改', 'upRealstock', NULL, 1, 1, 1, '2020-12-23 14:24:41');
INSERT INTO `qfyu_power_list` VALUES (238, 235, '新增/修改', 'editArea', NULL, 1, 1, 1, '2020-12-17 08:42:48');
INSERT INTO `qfyu_power_list` VALUES (239, 54, '获取商品控销区域', 'getGoodsSalesAreaList', NULL, 1, 1, 1, '2020-12-17 11:59:56');
INSERT INTO `qfyu_power_list` VALUES (240, 48, '查询盘点锁定', 'wareLockList', NULL, 1, 1, 1, '2020-12-17 14:27:04');
INSERT INTO `qfyu_power_list` VALUES (241, 54, '新增/编辑商品控销区域', 'editSalesArea', NULL, 1, 1, 1, '2020-12-17 14:29:02');
INSERT INTO `qfyu_power_list` VALUES (242, 1, '系统设置', '', 225, 1, 1, 1, '2020-12-17 17:59:10');
INSERT INTO `qfyu_power_list` VALUES (243, 242, '常用参考资料', 'getReferenceDataInit', NULL, 1, 1, 1, '2020-12-17 17:59:37');
INSERT INTO `qfyu_power_list` VALUES (244, 54, '获取商品销售限制', 'getSellLimitList', NULL, 1, 1, 1, '2020-12-18 17:38:10');
INSERT INTO `qfyu_power_list` VALUES (245, 63, '获取销售限制客户', 'getCustomerLimit', NULL, 1, 1, 1, '2020-12-18 18:23:59');
INSERT INTO `qfyu_power_list` VALUES (246, 63, '新增销售限制', 'addCustomerLimit', NULL, 1, 1, 1, '2020-12-19 10:41:13');
INSERT INTO `qfyu_power_list` VALUES (247, 193, '新增结存单获取配置', 'getAddCfg', NULL, 1, 0, 1, '2020-12-19 13:52:03');
INSERT INTO `qfyu_power_list` VALUES (248, 63, '编辑销售限制', 'editCustomerLimit', NULL, 1, 1, 1, '2020-12-19 14:37:38');
INSERT INTO `qfyu_power_list` VALUES (249, 63, '删除销售限制', 'delCustomerLimit', NULL, 1, 1, 1, '2020-12-19 14:39:48');
INSERT INTO `qfyu_power_list` VALUES (250, 54, '获取商品批量折扣', 'getGoodsBatchList', NULL, 1, 1, 1, '2020-12-21 14:54:51');
INSERT INTO `qfyu_power_list` VALUES (251, 54, '新增/编辑商品批量折扣', 'editGoodsBatch', NULL, 1, 1, 1, '2020-12-21 14:55:21');
INSERT INTO `qfyu_power_list` VALUES (252, 54, '删除商品批量折扣', 'delGoodsBatch', NULL, 1, 1, 1, '2020-12-21 14:55:42');
INSERT INTO `qfyu_power_list` VALUES (253, 54, '查询商品购进记录', 'PurchaseRecordList', NULL, 1, 1, 1, '2020-12-22 08:52:47');
INSERT INTO `qfyu_power_list` VALUES (254, 193, '即时盘点单', 'imList', 104, 1, 1, 1, '2020-12-22 11:33:37');
INSERT INTO `qfyu_power_list` VALUES (255, 54, '查询商品供货历史', 'supplyHistoryList', NULL, 1, 1, 1, '2020-12-22 10:40:04');
INSERT INTO `qfyu_power_list` VALUES (256, 193, '即时盘点从库存添加盘点记录', 'imStockList', NULL, 1, 0, 1, '2020-12-23 14:22:34');
INSERT INTO `qfyu_power_list` VALUES (257, 4, '销售开单', NULL, 57, 1, 1, 1, '2020-12-22 17:34:53');
INSERT INTO `qfyu_power_list` VALUES (258, 257, '查询', 'selExportList', NULL, 1, 1, 1, '2020-12-22 17:35:28');
INSERT INTO `qfyu_power_list` VALUES (259, 257, '编辑', 'editSelExportInit', NULL, 1, 1, 1, '2020-12-22 18:10:16');
INSERT INTO `qfyu_power_list` VALUES (260, 6, '采购结算', NULL, 48, 1, 1, 1, '2020-12-23 09:33:59');
INSERT INTO `qfyu_power_list` VALUES (261, 260, '查询', 'pchSettleList', NULL, 1, 1, 1, '2020-12-23 09:35:11');
INSERT INTO `qfyu_power_list` VALUES (262, 257, '审核', 'auditSelExport', NULL, 1, 1, 1, '2020-12-23 17:55:50');
INSERT INTO `qfyu_power_list` VALUES (263, 193, '即时盘点新增/修改', 'upAccOnline', NULL, 1, 1, 1, '2020-12-23 14:24:43');
INSERT INTO `qfyu_power_list` VALUES (264, 6, '采购付款', NULL, 49, 1, 1, 1, '2020-12-23 14:31:52');
INSERT INTO `qfyu_power_list` VALUES (265, 264, '查询', 'purchasePayList', NULL, 1, 1, 1, '2020-12-23 14:32:24');
INSERT INTO `qfyu_power_list` VALUES (266, 193, '修改即时盘点单', 'editAcconline', NULL, 1, 1, 1, '2020-12-23 17:01:37');
INSERT INTO `qfyu_power_list` VALUES (267, 5, '商品出入库查询', NULL, 226, 1, 1, 1, '2020-12-23 17:55:11');
INSERT INTO `qfyu_power_list` VALUES (268, 267, '入库查询', 'getInQtyList', NULL, 1, 1, 1, '2020-12-24 13:44:50');
INSERT INTO `qfyu_power_list` VALUES (269, 267, '出库查询', 'getOutQtyList', NULL, 1, 1, 1, '2020-12-24 13:44:54');
INSERT INTO `qfyu_power_list` VALUES (270, 267, '库存明细', 'getQtyDetailList', NULL, 1, 1, 1, '2020-12-24 13:44:59');
INSERT INTO `qfyu_power_list` VALUES (271, 267, '分仓库存', 'getBatchPartQtyList', NULL, 1, 1, 1, '2020-12-24 13:45:03');
INSERT INTO `qfyu_power_list` VALUES (272, 267, '总库存', 'getTotalQtyList', NULL, 1, 1, 1, '2020-12-24 13:45:06');
INSERT INTO `qfyu_power_list` VALUES (273, 193, '删除即时盘点单', 'delAcconline', NULL, 1, 1, 1, '2020-12-23 18:08:17');
INSERT INTO `qfyu_power_list` VALUES (274, 119, '上传药检报告', 'drugUoload', NULL, 1, 1, 1, '2020-12-23 18:26:46');
INSERT INTO `qfyu_power_list` VALUES (275, 193, '审核即时盘点单', 'checkAcconline', NULL, 1, 1, 1, '2020-12-24 08:39:02');
INSERT INTO `qfyu_power_list` VALUES (276, 54, '上传药检报告', 'addGoodsDrugReports', NULL, 1, 1, 1, '2020-12-24 09:27:35');
INSERT INTO `qfyu_power_list` VALUES (277, 54, '查看药检报告', 'getGoodsDrugReports', NULL, 1, 1, 1, '2020-12-24 11:18:48');
INSERT INTO `qfyu_power_list` VALUES (278, 193, '即时盘点单审核删除库存变动的记录', 'delAccerr', NULL, 1, 0, 1, '2020-12-24 11:44:25');
INSERT INTO `qfyu_power_list` VALUES (279, 5, '出库登记/复核', NULL, 109, 1, 1, 1, '2020-12-24 15:22:16');
INSERT INTO `qfyu_power_list` VALUES (280, 279, '查询', 'getStockOutList', NULL, 1, 1, 1, '2020-12-24 15:23:14');
INSERT INTO `qfyu_power_list` VALUES (281, 279, '查询复核单信息', 'getStockOutInfo', NULL, 1, 0, 1, '2020-12-24 16:56:36');
INSERT INTO `qfyu_power_list` VALUES (282, 6, '销售结算', NULL, 148, 1, 1, 1, '2020-12-24 17:26:23');
INSERT INTO `qfyu_power_list` VALUES (283, 282, '查询', 'getSelSettleList', NULL, 1, 1, 1, '2020-12-24 17:26:59');
INSERT INTO `qfyu_power_list` VALUES (284, 282, '查询明细', 'getSelSettleDtl', NULL, 1, 1, 1, '2020-12-24 17:42:21');
INSERT INTO `qfyu_power_list` VALUES (285, 193, '整仓盘点单', 'wholeList', NULL, 1, 1, 1, '2020-12-23 18:49:36');

-- ----------------------------
-- Table structure for qfyu_providers
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_providers`;
CREATE TABLE `qfyu_providers`  (
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业简称',
  `full_name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业全称',
  `mnemonic_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '助记码',
  `prov_kind` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '厂商分类',
  `abckind` tinyint(3) NULL DEFAULT NULL COMMENT 'ABC分类',
  `business_leader` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务负责人',
  `enterprise_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '企业类型',
  `is_production` tinyint(1) NULL DEFAULT 0 COMMENT '是否为生产企业 1是 0否',
  `subject_dept` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `operation_mode` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经营方式',
  `legal_person` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '法人代表',
  `corp_duty` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法人职务',
  `economic_nature` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经济性质',
  `quality_system` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量保证体系',
  `drug_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '药品经营许可证号',
  `confirm_state` tinyint(1) NOT NULL DEFAULT 0 COMMENT '认证状态 默认未认证',
  `confirm_man` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '认证人',
  `competency` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法定资格',
  `quality_principal` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理机构负责人',
  `quality_man_count` int(10) NULL DEFAULT NULL COMMENT '质量管理机构人数',
  `quality_depart_tel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理机构电话',
  `post_code` int(6) NULL DEFAULT NULL COMMENT '邮编\r\n',
  `area` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所在地区',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '详细地址',
  `mobile` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '移动电话',
  `tel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `fax` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '传真',
  `bank_area` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '开户行',
  `bank_account` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '账号',
  `tax_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '税号',
  `coin_kind` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算比别',
  `credit` decimal(10, 0) NULL DEFAULT NULL COMMENT '信用额度',
  `credit_days` int(10) NULL DEFAULT NULL COMMENT '信用天数',
  `pay_mode_no` char(6) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '默认结算方式',
  `pause` tinyint(1) NOT NULL DEFAULT 1 COMMENT '暂停往来 0表示已暂停',
  `firstdeal_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '首营单据号',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `data_usable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1表示有效',
  `prov_goods_able` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `business_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '营业执照编号',
  `gmp_two_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP2证书编号',
  `gmp_two_validity_date` datetime(0) NULL DEFAULT NULL COMMENT 'GMP2证书有效期至',
  `gmp_three_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'GMP3证书编号',
  `gmp_three_validity_date` datetime(0) NULL DEFAULT NULL COMMENT 'GMP3证书有效期至',
  `parent_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '父级编号',
  `depot_addr` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库地址',
  `qualification` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资格证书',
  `auth_period_date` datetime(0) NULL DEFAULT NULL COMMENT '授权期限',
  `quality_regime` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量管理与制度情况',
  `gsp_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'GSP证书编号',
  `gsp_validity_date` datetime(0) NOT NULL COMMENT 'GSP证书有效期至',
  `business_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '营业执照有效期',
  `drug_validity_date` datetime(0) NOT NULL COMMENT '药品经营许可证有效期至',
  `apparatus_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '医疗器械经营许可证号',
  `quality_validity_date` datetime(0) NOT NULL COMMENT '质量协议保证书有效期',
  `attorney_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '法人委托书有效期',
  `organization_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织机构代码证号',
  `organization_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '组织机构代码有效期至',
  `food_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '食品经营许可证号',
  `food_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '食品经营许有效期至',
  `health_license` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '保健品经营许可证号',
  `health_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '保健品经营许有效期至',
  `apparatus_validity_date` datetime(0) NULL DEFAULT NULL COMMENT '医疗器械经营许有效期至',
  `ywysqsyxq_date` datetime(0) NULL DEFAULT NULL COMMENT '业务员授权书有效期',
  `watch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '统一监管码',
  `qc_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量负责人姓名',
  `qc_sex` tinyint(1) NULL DEFAULT NULL COMMENT '性别 1男 2女',
  `qc_technic_title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '技术职称',
  `qc_post` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职务',
  `qc_education` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文化程度',
  `qc_year` tinyint(2) NULL DEFAULT NULL COMMENT '质量负责人质量工作年限',
  `duty` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '法人职务',
  `degree` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `depart_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '申请部门名称',
  `depart_id` int(10) NULL DEFAULT NULL COMMENT '申请部门id',
  `output_year` decimal(10, 2) NULL DEFAULT NULL COMMENT '年产值（万元）',
  `major_honors` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '主要荣誉',
  `quality_organization` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '企业质量机构名称',
  `quality_state` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状况',
  `staple` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '授权品种',
  `record_varieties` tinyint(1) NULL DEFAULT 0 COMMENT '记录协议品种',
  `ddkindid` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '许可经营类别',
  `audit_status` tinyint(1) NULL DEFAULT 0 COMMENT '审核标志 默认未审核 1已审核',
  `auditer` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核员',
  `audit_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '添加时间',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者code',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  UNIQUE INDEX `supplier_code`(`supplier_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商资料' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_providers
-- ----------------------------
INSERT INTO `qfyu_providers` VALUES ('FS001', '你哈佛教发送到发送到', '你哈佛教发送到发送到', 'NHFJFSDFSD', '二位二翁', 1, '009', '药品批发企业', 0, '', '56yyr', 'seffsdsfdsdf', '', '', '', '特热太热', 0, '', '', '', NULL, '', 4864, '广西', '5345热特特人', '', '', '', '特热太热', '特瑞特人', '特瑞特人', '', NULL, NULL, 'JS003', 1, 'FS2010209898101995', '', 1, '', '特特热太热', '', NULL, '', NULL, '', '', '', NULL, '', '特瑞特人', '2020-10-23 00:00:00', '2020-12-24 00:00:00', '2020-10-17 00:00:00', '', '2020-10-23 00:00:00', '2020-12-25 00:00:00', '', NULL, '', NULL, '', NULL, NULL, '2020-12-31 00:00:00', 'sererwer', '', NULL, '', '', '', NULL, '', '', '', 1, NULL, '', '', '', '', 0, '2', 0, '', NULL, '2020-11-26 15:44:00', '001', '001', '2020-12-16 17:08:42');
INSERT INTO `qfyu_providers` VALUES ('FS002', '企业名称12', '企业名称12', 'QYMC12', '', 2, '002', '药品生产企业', 1, '', '11', '11', '', '', '', '发送到发送到', 0, '', '', '', NULL, '', 568974, '广东省深圳市龙华新区', '企业资质156156', '', '', '', '发生地方都是', '发送到发送到', '8565161651', '', NULL, NULL, 'JS004', 1, 'FS2010209955565751', '', 1, '', '541461651651', '', NULL, '', NULL, '', '', '', NULL, '', '分手大师', '2020-10-21 00:00:00', '2020-12-10 00:00:00', '2020-10-30 00:00:00', '', '2020-10-23 00:00:00', '2020-12-10 00:00:00', '', NULL, '', NULL, '', NULL, NULL, '2020-12-10 00:00:00', '111', '', NULL, '', '', '', NULL, '', '', '2', 7, NULL, '', '', '', '', 0, '1', 1, '001', NULL, '2020-10-30 19:00:00', '001', '001', '2020-12-16 15:16:00');
INSERT INTO `qfyu_providers` VALUES ('FS003', '庆丰裕科技1', '深圳庆丰裕信息科技有限公司', 'QYMC1', '', 0, '004', '非商品经营企业', 0, '5535435', '民营公司', '郝总', '', '', '', '15415616', 0, '', '', '', 0, '', 123584, '', '企业地址1', '', '135159156161', '161651', '161', '156161', '165111616', '', NULL, NULL, 'JS003', 1, 'FS2010211025651495', '', 1, '', '56161165156', '', NULL, '', NULL, '', '', '', NULL, '', '49849', '2020-10-31 00:00:00', '2020-12-05 00:00:00', '2020-10-31 00:00:00', '', '2020-10-31 00:00:00', '2020-12-12 00:00:00', '', NULL, '', NULL, '', NULL, NULL, '2020-12-12 00:00:00', '64161654', '', NULL, '', '', '', NULL, '', '', '2', 7, NULL, '', '', '', '', 0, '2', 1, '001', NULL, '2020-10-30 18:59:00', '001', '001', '2020-12-16 15:17:00');
INSERT INTO `qfyu_providers` VALUES ('FS007', '绕弯儿翁二', '绕弯儿翁二', 'RWEWE', '', 1, '004', '商品生产企业', 1, '', '3453', '45343', '', '', '', '3123213', 0, '', '', '', NULL, '', 0, '', '热热翁', '', '', '', '1323', '3123', '123', '', NULL, NULL, 'JS003', 1, 'FS2010231004898102', '', 1, '', '312313', '', NULL, '', NULL, '', '', '', NULL, '', '3123', '2020-10-31 00:00:00', '2020-12-25 00:00:00', '2020-10-31 00:00:00', '', '2020-10-31 00:00:00', '2020-12-25 00:00:00', '', NULL, '', NULL, '', NULL, NULL, '2020-12-30 00:00:00', '74453', '', NULL, '', '', '', NULL, '', '', '', 7, 0.00, '', '', '', '', 0, '1,11,1', 0, '009', NULL, '2020-11-27 14:46:00', '001', '001', '2020-12-16 15:32:45');
INSERT INTO `qfyu_providers` VALUES ('FS009', '庆丰裕科技', '深圳庆丰裕信息科技有限公司1111', 'JC', '二位二翁', 1, '005', '药品批发企业', 0, '', '经营方式', '企业法人', '', '', '', '651351165464', 0, '', '', '', 10, '', NULL, '', '详细地址', '', '', '', '中国银行', '6201981651651', '464465641', '', NULL, NULL, 'JS002', 0, '', '备注', 1, '', '954961666554', '', NULL, '', NULL, '', '', '', NULL, '', '78848056626', '2022-01-08 00:00:00', '2021-12-23 00:00:00', '2021-12-31 00:00:00', '', '2021-12-31 00:00:00', '2024-05-15 00:00:00', '', NULL, '', NULL, '', NULL, NULL, '2021-12-16 00:00:00', '统一监管码', '', NULL, '', '', '', NULL, '', '', '销售部', 3, NULL, '', '', '', '', 0, '2,54,55,56,57,58,59,60,61,62,63,64,65,66,67,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,3,99,100,101', 0, '009', NULL, '2020-11-07 16:50:09', '001', '001', '2020-12-16 15:15:49');

-- ----------------------------
-- Table structure for qfyu_providers_auth_variety
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_providers_auth_variety`;
CREATE TABLE `qfyu_providers_auth_variety`  (
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `prov_s_id` int(10) UNSIGNED NOT NULL COMMENT '供方销售人员ID',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`supplier_code`, `prov_s_id`, `goods_code`) USING BTREE,
  INDEX `prov_s_id`(`prov_s_id`) USING BTREE,
  INDEX `goods_code`(`goods_code`) USING BTREE,
  INDEX `supplier_code`(`supplier_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供方销售人员授权品种' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_providers_auth_variety
-- ----------------------------
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 7, 'FG002');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS002', 7, 'FG002');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS003', 7, 'FG001');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS003', 7, 'FG002');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS003', 7, 'FG003');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS003', 7, 'FG008');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 8, 'FG003');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 9, 'FG002');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 9, 'FG003');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 10, 'FG001');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 10, 'FG0012');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS001', 10, 'FG002');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS002', 11, 'FG002');
INSERT INTO `qfyu_providers_auth_variety` VALUES ('FS002', 11, 'FG003');

-- ----------------------------
-- Table structure for qfyu_providers_goods
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_providers_goods`;
CREATE TABLE `qfyu_providers_goods`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `goods_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编码',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '主单位协议价格',
  `price2` decimal(10, 2) NULL DEFAULT NULL COMMENT '主单位协议价格',
  `prov_goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方产品编号',
  `is_valid` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否有效  默认有效 0无效',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `near_date` date NULL DEFAULT NULL COMMENT '最近交易日期',
  `wtsxq_date` date NULL DEFAULT NULL COMMENT '委托书有效期',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `supplier_code_2`(`supplier_code`, `goods_code`) USING BTREE,
  INDEX `supplier_code`(`supplier_code`) USING BTREE,
  INDEX `goods_code`(`goods_code`) USING BTREE,
  CONSTRAINT `qfyu_providers_goods_ibfk_1` FOREIGN KEY (`goods_code`) REFERENCES `qfyu_commodity` (`goods_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商协议品种' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_providers_goods
-- ----------------------------
INSERT INTO `qfyu_providers_goods` VALUES (1, 'FS002', 'FG001', 52.10, 33.00, '123', 1, '', '2020-11-11', '2024-06-22', '2020-11-25 09:22:43');
INSERT INTO `qfyu_providers_goods` VALUES (2, 'FS002', 'FG0010', NULL, NULL, '', 1, '', NULL, NULL, '2020-11-25 09:19:19');
INSERT INTO `qfyu_providers_goods` VALUES (3, 'FS001', 'FG001', NULL, NULL, '', 1, '', NULL, NULL, '2020-11-30 17:23:00');

-- ----------------------------
-- Table structure for qfyu_providers_sales
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_providers_sales`;
CREATE TABLE `qfyu_providers_sales`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `user_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `sex` tinyint(1) NULL DEFAULT NULL COMMENT '性别（1男 2女）',
  `id_card` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `depart` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门',
  `duties` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职务',
  `tel` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `phone` bigint(11) NULL DEFAULT NULL COMMENT '手机',
  `qq` bigint(15) NULL DEFAULT NULL COMMENT 'qq',
  `attorney_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '委托书编号',
  `status` tinyint(1) NULL DEFAULT 1 COMMENT '资料是否有效',
  `content_power` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '委托书内容',
  `validity_date` date NULL DEFAULT NULL COMMENT '有效期',
  `attorney_validity` tinyint(1) NULL DEFAULT 1 COMMENT '委托书是否有效',
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '住址',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `purcher` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购部负责人',
  `purch_exam_date` date NULL DEFAULT NULL COMMENT '采购部审核时间',
  `qualityer` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量负责人',
  `quality_exam_date` date NULL DEFAULT NULL COMMENT '质量负责人审核时间',
  `qcer` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量部负责人',
  `qc_exam_date` date NULL DEFAULT NULL COMMENT '质量部审核时间',
  `exam_status` tinyint(1) NULL DEFAULT 0 COMMENT '1审核通过',
  `is_default` tinyint(1) NULL DEFAULT 0 COMMENT '1默认',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者code',
  `re_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `supplier_code`(`supplier_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供方销售人员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_providers_sales
-- ----------------------------
INSERT INTO `qfyu_providers_sales` VALUES (7, 'FS003', '张三歌', 1, '432712198911288595', '', '', '', NULL, NULL, '', 1, '', NULL, 1, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, '001', NULL, NULL, '2020-10-26 08:46:06');
INSERT INTO `qfyu_providers_sales` VALUES (8, 'FS003', 'zero', 1, '432712198911288596', '', '', '', NULL, NULL, '', 1, '', NULL, 1, '', '', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, '001', NULL, NULL, '2020-10-26 11:55:34');
INSERT INTO `qfyu_providers_sales` VALUES (9, 'FS001', 'zero', 1, '430722197801018558', '', '', '', NULL, NULL, '5895946456', 1, '', '2020-12-30', 1, '', '', '001', '2020-12-02', '002', '2020-12-02', '002', '2020-12-02', 1, 0, '001', '001', '2020-12-02 12:02:31', '2020-11-27 09:44:24');
INSERT INTO `qfyu_providers_sales` VALUES (10, 'FS001', 'zero', 1, '36073219890416441X', '', '', '', NULL, NULL, '', 1, '', '2020-12-31', 1, '', '', '', '2020-11-27', '', '2020-12-02', '', '2020-12-02', 0, 1, '001', '001', '2020-12-02 12:02:31', '2020-11-27 09:45:20');
INSERT INTO `qfyu_providers_sales` VALUES (11, 'FS002', 'zero', 2, '432712198911288538', '', '', '', NULL, NULL, '', 1, '', NULL, 1, '', '', '', NULL, '', NULL, '', NULL, 0, 1, '001', '001', '2020-11-27 11:03:51', '2020-11-27 09:46:30');

-- ----------------------------
-- Table structure for qfyu_providers_self_goods
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_providers_self_goods`;
CREATE TABLE `qfyu_providers_self_goods`  (
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`supplier_code`, `goods_code`) USING BTREE,
  INDEX `qfyu_providers_self_goods_ibfk_2`(`goods_code`) USING BTREE,
  INDEX `supplier_code_2`(`supplier_code`) USING BTREE,
  CONSTRAINT `qfyu_providers_self_goods_ibfk_1` FOREIGN KEY (`supplier_code`) REFERENCES `qfyu_providers` (`supplier_code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_providers_self_goods_ibfk_2` FOREIGN KEY (`goods_code`) REFERENCES `qfyu_commodity` (`goods_code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商自产商品' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_providers_self_goods
-- ----------------------------
INSERT INTO `qfyu_providers_self_goods` VALUES ('FS001', 'FG0011', '');
INSERT INTO `qfyu_providers_self_goods` VALUES ('FS001', 'FG002', '');
INSERT INTO `qfyu_providers_self_goods` VALUES ('FS001', 'FG003', '');
INSERT INTO `qfyu_providers_self_goods` VALUES ('FS003', 'FG001', '');
INSERT INTO `qfyu_providers_self_goods` VALUES ('FS003', 'FG002', '');

-- ----------------------------
-- Table structure for qfyu_providers_visit_record
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_providers_visit_record`;
CREATE TABLE `qfyu_providers_visit_record`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `supplier_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `f_date` date NOT NULL COMMENT '洽谈日期',
  `emp_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '我方洽谈人',
  `subject` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '洽谈主题',
  `visit_man` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方洽谈负责人',
  `visit_place` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '洽谈方式/地点',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '洽谈内容',
  `re_date` datetime(0) NULL DEFAULT NULL COMMENT '更新日期',
  PRIMARY KEY (`id`, `supplier_code`) USING BTREE,
  INDEX `emp_code`(`emp_code`) USING BTREE,
  INDEX `supplier_code`(`supplier_code`) USING BTREE,
  CONSTRAINT `qfyu_providers_visit_record_ibfk_1` FOREIGN KEY (`supplier_code`) REFERENCES `qfyu_providers` (`supplier_code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_providers_visit_record_ibfk_2` FOREIGN KEY (`emp_code`) REFERENCES `qfyu_employee` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '业务联系记录管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_providers_visit_record
-- ----------------------------
INSERT INTO `qfyu_providers_visit_record` VALUES (2, 'FS001', '2020-12-05', '004', '修改洽谈主题', '李总', '深圳龙湖1', '是尽快发货速度快粉红色的合肥市极度恐慌放款时间', '2020-12-03 11:38:57');
INSERT INTO `qfyu_providers_visit_record` VALUES (3, 'FS001', '2020-12-05', '007', '', '', '', '测试添加业务联系记录', '2020-11-28 16:18:43');

-- ----------------------------
-- Table structure for qfyu_purchase_contract
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_contract`;
CREATE TABLE `qfyu_purchase_contract`  (
  `orderid` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '合同号',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '合同标题',
  `sup_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `delivery` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货地点',
  `sign_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '签约地点',
  `sign_date` date NULL DEFAULT NULL COMMENT '签约日期',
  `sign_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '签约人',
  `sign_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '签约人姓名',
  `start_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `validity_date` date NULL DEFAULT NULL COMMENT '失效日期',
  `settlement` int(10) NOT NULL COMMENT '结算方式',
  `pay_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `explain` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `filepath` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同文件路径',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '修改者',
  `update_date` datetime(0) NOT NULL COMMENT '修改时间',
  `dept_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '资源所属',
  PRIMARY KEY (`orderid`) USING BTREE,
  INDEX `sup_code`(`sup_code`) USING BTREE,
  INDEX `sign_code`(`sign_code`) USING BTREE,
  INDEX `settlement`(`settlement`) USING BTREE,
  INDEX `creator`(`creator`) USING BTREE,
  INDEX `updator`(`updator`) USING BTREE,
  INDEX `dept_id`(`dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购合同-单据信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_contract
-- ----------------------------
INSERT INTO `qfyu_purchase_contract` VALUES ('CH2011255149100971', '商品采购原料合同资料说明', 'FS009', '深圳市龙华区大为商务大厦', '深圳市龙华新区上塘大厦5楼', '2020-11-18', '003', '小米', '2020-11-26', '2020-11-28', 1, '2020-12-30', 'aaaaaaaaaaaaa', '', '001', '2020-11-25 18:44:03', '001', '2020-12-11 09:23:17', 1);
INSERT INTO `qfyu_purchase_contract` VALUES ('CH2011269856985356', '商品购销合同资料', 'FS003', '深圳市龙华区', '大为商务大厦', '2020-11-19', '001', '小李', '2020-11-24', '2020-11-28', 3, '2020-11-30', 'bbbbbbbbb', '', '001', '2020-11-26 09:41:47', '001', '2020-12-23 08:34:40', 1);

-- ----------------------------
-- Table structure for qfyu_purchase_lack
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_lack`;
CREATE TABLE `qfyu_purchase_lack`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据号',
  `register_date` date NOT NULL COMMENT '登记日期',
  `validity_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `emp_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编码',
  `nums` int(10) NOT NULL COMMENT '缺货品种数',
  `total` decimal(16, 5) NOT NULL COMMENT '缺货总数量',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `ischeck` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否审核 1已审核',
  `check_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `istrans` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否转单 1已转单',
  `deptid` int(10) NULL DEFAULT NULL COMMENT '资源所属部门ID',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '修改者',
  `update_date` datetime(0) NOT NULL COMMENT '修改时间',
  INDEX `emp_code`(`emp_code`) USING BTREE,
  INDEX `ischeck`(`ischeck`) USING BTREE,
  INDEX `check_code`(`check_code`) USING BTREE,
  INDEX `istrans`(`istrans`) USING BTREE,
  INDEX `creator`(`creator`) USING BTREE,
  INDEX `updator`(`updator`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '缺货登记-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_lack
-- ----------------------------
INSERT INTO `qfyu_purchase_lack` VALUES ('QH2012011005610110', '2020-12-01', '2020-12-15', '002', 1, 300.00000, '', 0, NULL, NULL, 0, 1, '001', '2020-12-01 17:04:45', '001', '2020-12-01 17:05:24');
INSERT INTO `qfyu_purchase_lack` VALUES ('QH2012145256100545', '2020-12-14', NULL, '003', 2, 0.00000, '', 0, '001', '2020-12-14 09:42:50', 0, 1, '001', '2020-12-14 09:42:28', '001', '2020-12-14 09:50:21');
INSERT INTO `qfyu_purchase_lack` VALUES ('QH2012154998509853', '2020-12-15', NULL, '004', 1, 500.00000, '', 1, '001', '2020-12-15 15:53:27', 1, 1, '001', '2020-12-15 14:56:17', '001', '2020-12-15 17:03:11');
INSERT INTO `qfyu_purchase_lack` VALUES ('QH2012161005110055', '2020-12-16', NULL, '', 0, 0.00000, '', 0, NULL, NULL, 0, 1, '001', '2020-12-16 18:05:33', '001', '2020-12-16 18:05:33');

-- ----------------------------
-- Table structure for qfyu_purchase_lack_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_lack_details`;
CREATE TABLE `qfyu_purchase_lack_details`  (
  `item_no` int(10) NOT NULL COMMENT '编号',
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据号',
  `goodsid` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `nums` decimal(16, 5) UNSIGNED NOT NULL COMMENT '缺货数量',
  `already_nums` decimal(16, 5) UNSIGNED NULL DEFAULT 0.00000 COMMENT '已订购数量',
  `explain` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  PRIMARY KEY (`item_no`, `orderid`) USING BTREE,
  UNIQUE INDEX `item_orderid`(`item_no`, `orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '缺货登记-单据详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_lack_details
-- ----------------------------
INSERT INTO `qfyu_purchase_lack_details` VALUES (1, 'QH2012011005610110', 'FG001', '2', 300.00000, 0.00000, '');
INSERT INTO `qfyu_purchase_lack_details` VALUES (1, 'QH2012145256100545', 'FG002', '盒', 0.00000, 0.00000, '');
INSERT INTO `qfyu_purchase_lack_details` VALUES (1, 'QH2012154998509853', 'FG001', '盒', 500.00000, 0.00000, '');
INSERT INTO `qfyu_purchase_lack_details` VALUES (2, 'QH2012145256100545', 'FG003', '盒', 0.00000, 0.00000, '');

-- ----------------------------
-- Table structure for qfyu_purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_order`;
CREATE TABLE `qfyu_purchase_order`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '采购单据号',
  `plan_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单号（采购计划单）',
  `effectivity_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `invalid_date` date NULL DEFAULT NULL COMMENT '失效日期',
  `order_date` date NULL DEFAULT NULL COMMENT '订单日期',
  `delivery_date` date NULL DEFAULT NULL COMMENT '到货日期',
  `contract_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同类型',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `settle_type` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式',
  `sales_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编码',
  `sales_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员姓名',
  `sup_sell` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售人员',
  `sup_contact` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方联系人',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `ispay` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否预付款 1预付款',
  `pay_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `paymoney` decimal(12, 2) NULL DEFAULT NULL COMMENT '预付款金额',
  `sign_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '签约地点',
  `contract_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同号',
  `sup_remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商备注',
  `delivery_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货方式',
  `nums` decimal(16, 5) NOT NULL COMMENT '货品总数',
  `payment` decimal(16, 6) NOT NULL COMMENT '货款总额',
  `tax_total` decimal(16, 6) UNSIGNED NOT NULL COMMENT '税款总额',
  `total` decimal(16, 6) UNSIGNED NOT NULL DEFAULT 0.000000 COMMENT '合计总额',
  `transport_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输方式',
  `delivery_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货地点',
  `transport_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输到站',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `istrans` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已转单 1已转单',
  `isclose` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否结案 1已结案',
  `ischeck` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '审核状态 1已审核',
  `check_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员编码',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `dept_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '开单部门',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '修改者',
  `update_date` datetime(0) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`orderid`) USING BTREE,
  INDEX `sup_code`(`sup_code`) USING BTREE,
  INDEX `sales_code`(`sales_code`) USING BTREE,
  INDEX `check_code`(`check_code`) USING BTREE,
  INDEX `creator`(`creator`) USING BTREE,
  INDEX `updator`(`updator`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购订单-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_order
-- ----------------------------
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012015056102505', NULL, '2020-12-01', '2020-12-08', '2020-12-01', '2020-12-01', '0', 'FS003', NULL, '004', '小黄', '张三歌', 'zero', '5535435', 0, '2020-12-01', 0.00, '', '', '', '', 103.00000, 2237.610000, 218.090000, 2455.700000, '', '', '', '', 1, 0, 1, '001', '2020-12-01 15:02:18', 1, '001', '2020-12-01 14:08:02', '001', '2020-12-05 17:42:54');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012015110148529', 'JH2012015050102529', '2020-12-01', '2020-12-08', '2020-12-01', '2020-12-01', '0', 'FS003', NULL, '001', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 20.00000, 485.410000, 74.590000, 560.000000, NULL, NULL, NULL, '本订单由采购计划单自动生成2020-12-01 16:46:11', 1, 1, 1, '001', '2020-12-01 16:49:47', 0, '001', '2020-12-01 16:46:11', '001', '2020-12-04 17:33:43');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012015510054995', NULL, '2020-12-01', '2020-12-08', '2020-12-01', '2020-12-01', '0', 'FS003', NULL, '005', '小明', '张三歌', 'zero', '5535435', 0, '2020-12-01', 0.00, '', '', '', '', 90.00000, 1509.960000, 153.240000, 1663.200000, '', '', '', '', 0, 1, 0, '001', '2020-12-01 15:46:31', 1, '001', '2020-12-01 14:11:19', '001', '2020-12-03 08:33:48');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012035655525653', NULL, '2020-12-03', '2020-12-10', '2020-12-03', '2020-12-03', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-03', 0.00, '', '', '', '', 50.00000, 296.283170, 38.516830, 334.800000, '', '', '', '', 1, 0, 1, '001', '2020-12-03 10:30:54', 1, '001', '2020-12-03 10:13:44', '001', '2020-12-03 10:30:58');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012041005649102', NULL, '2020-12-04', '2020-12-11', '2020-12-04', '2020-12-04', '1', 'FS003', NULL, '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-04', 0.00, '', '', '', '', 0.40000, 0.017822, 0.000178, 0.018000, '', '', '', '', 1, 0, 1, '009', '2020-12-04 17:29:24', 1, '009', '2020-12-04 17:29:17', '009', '2020-12-04 17:29:29');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012045297505757', NULL, '2020-12-04', '2020-12-11', '2020-12-04', '2020-12-04', '0', 'FS003', NULL, '003', '小米', '张三歌', '张三歌', '5535435', 0, '2020-12-04', 0.00, '1111', '', '111', '1', 0.00000, 0.000000, 0.000000, 0.000000, '1', '1', '1', '1', 0, 0, 0, NULL, NULL, 1, '009', '2020-12-04 16:01:56', '009', '2020-12-04 16:01:56');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012045552995398', NULL, '2020-12-04', '2020-12-11', '2020-12-04', '2020-12-04', '0', 'FS003', NULL, '003', '小米', '张三歌', '张三歌', '5535435', 0, '2020-12-04', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-04 16:03:01', 1, '009', '2020-12-04 16:02:47', '009', '2020-12-04 16:03:10');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012051005248489', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 12.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:07:41', '001', '2020-12-05 11:07:41');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012051029951481', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 12.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:09:03', '001', '2020-12-05 11:09:03');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012054852565010', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 30.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:13:04', '001', '2020-12-05 11:13:04');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012054949511019', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 122.00000, 1106.000000, 0.000000, 1106.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 10:56:17', '001', '2020-12-05 10:56:17');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055098504810', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 5.00000, 25.000000, 0.000000, 25.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '009', '2020-12-05 10:39:14', '009', '2020-12-05 10:39:14');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055149975649', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 12.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:08:19', '001', '2020-12-05 11:08:19');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055210010197', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '009', '2020-12-05 10:38:44', '009', '2020-12-05 10:38:54');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055250545099', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 12.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:20:36', '001', '2020-12-05 11:20:36');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055351575799', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 12.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:13:57', '001', '2020-12-05 11:13:57');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055498499851', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '003', '小米', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '009', '2020-12-05 08:39:50', '009', '2020-12-05 10:21:23');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055553535352', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 24.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:12:07', '001', '2020-12-05 11:12:07');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012055756491025', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 10:44:25', '001', '2020-12-05 10:44:54');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059710097985', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 30.00000, 192.000000, 0.000000, 192.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 10:51:38', '001', '2020-12-05 10:51:38');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059751495453', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 24.00000, 240.000000, 0.000000, 240.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:05:14', '001', '2020-12-05 11:05:14');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059753102999', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 12.00000, 60.000000, 0.000000, 60.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:10:34', '001', '2020-12-05 11:10:34');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059848555457', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 10:48:59', '001', '2020-12-05 10:48:59');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059851531021', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 15:35:07', '001', '2020-12-05 15:35:07');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059854494957', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 11:11:23', '001', '2020-12-05 11:11:23');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012059955534855', NULL, '2020-12-05', '2020-12-12', '2020-12-05', '2020-12-05', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-05', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-05 15:35:40', '001', '2020-12-05 15:35:40');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012101011005449', NULL, '2020-12-10', '2020-12-17', '2020-12-10', '2020-12-10', '0', 'FS003', NULL, '002', '小李1', '张三歌', '张三歌', '5535435', 0, '2020-12-10', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-10 14:11:42', '001', '2020-12-10 14:11:56');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012105597545010', NULL, '2020-12-10', '2020-12-17', '2020-12-10', '2020-12-10', '0', 'FS003', NULL, '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-10', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 1, '009', '2020-12-10 15:27:23', 1, '009', '2020-12-10 15:27:19', '009', '2020-12-10 15:27:19');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012109810099491', NULL, '2020-12-10', '2020-12-17', '2020-12-10', '2020-12-10', '1', 'FS003', NULL, '006', '小明1', '张三歌', '张三歌', '5535435', 0, '2020-12-10', 0.00, '', '', '', '', 30.00000, 426.991160, 23.008840, 450.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-10 15:01:34', 1, '009', '2020-12-10 15:00:27', '009', '2020-12-10 15:01:41');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012124852971011', NULL, '2020-12-12', '2020-12-19', '2020-12-12', '2020-12-12', '0', 'FS003', NULL, '002', '小李1', '张三歌', '张三歌', '5535435', 0, '2020-12-12', 0.00, '龙华新区', 'CH2011269856985356', '', '', 30.00000, 530.973450, 69.026550, 600.000000, '', '', '', '', 1, 0, 1, '001', '2020-12-12 16:06:13', 1, '001', '2020-12-12 16:06:08', '001', '2020-12-14 09:26:20');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012125553991005', NULL, '2020-12-12', '2020-12-19', '2020-12-12', '2020-12-12', '0', 'FS003', 'JS003', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-12', 0.00, '', '', '', '', 30.00000, 63.716820, 8.283180, 72.000000, '', '', '', '', 1, 0, 1, '001', '2020-12-12 16:38:17', 1, '001', '2020-12-12 16:17:11', '001', '2020-12-12 16:38:22');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012144898575549', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '计划合同', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-14', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-14 18:16:32', '001', '2020-12-14 18:17:51');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012145198505552', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '0', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 1, '2020-12-14', 500.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 1, '001', '2020-12-14 17:37:52', 1, '001', '2020-12-14 17:34:43', '001', '2020-12-14 17:35:05');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012145350534810', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '0', 'FS003', '', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-14', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-14 10:08:08', 1, '009', '2020-12-14 10:08:05', '009', '2020-12-14 10:08:14');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012145449521019', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '0', 'FS003', '', '005', '小明', '张三歌', '张三歌', '5535435', 0, '2020-12-14', 0.00, '', '', '', '', 15.00000, 43.491410, 6.508590, 50.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-14 18:57:46', 1, '009', '2020-12-14 18:57:42', '009', '2020-12-14 18:57:50');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012145753559955', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '-1', 'FS003', 'JS003', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-14', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-14 18:43:05', '001', '2020-12-14 18:43:05');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012149849975110', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '0', 'FS003', 'JS003', '003', '小米', '张三歌', '张三歌', '5535435', 0, '2020-12-14', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '009', '2020-12-14 18:59:55', '009', '2020-12-14 18:59:55');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012149899524957', NULL, '2020-12-14', '2020-12-21', '2020-12-14', '2020-12-14', '0', 'FS003', '', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-14', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-14 16:44:59', '001', '2020-12-14 16:44:59');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012151015148551', NULL, '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '-1', 'FS003', 'JS003', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-15', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-15 14:58:06', '001', '2020-12-15 14:58:06');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155151535150', NULL, '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '-1', 'FS003', 'JS003', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-15', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 1, 0, 1, '001', '2020-12-15 18:21:20', 1, '001', '2020-12-15 14:59:47', '001', '2020-12-15 18:21:23');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155349102529', NULL, '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '-1', 'FS003', 'JS003', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-15', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-15 09:40:05', '001', '2020-12-15 10:06:50');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155452975648', 'JH2012155256481019', '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '', 'FS003', 'JS003', '006', '小明1', '张三歌', 'zero', '5535435', 0, NULL, 0.00, '', '', '', '', 500.00000, 9734.513275, 1265.486725, 11000.000000, '', '', '', '本订单由采购计划单自动生成2020-12-15 18:26:30', 0, 0, 0, NULL, NULL, 0, '001', '2020-12-15 18:26:30', '001', '2020-12-16 09:11:11');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155652505655', 'JH2012155256481019', '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '0', 'FS003', NULL, '001', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 500.00000, 9734.513500, 1265.486500, 11000.000000, NULL, NULL, NULL, '本订单由采购计划单自动生成2020-12-15 18:26:16', 0, 0, 0, NULL, NULL, 0, '001', '2020-12-15 18:26:16', '001', '2020-12-15 18:26:16');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155655555455', 'JH2012155256481019', '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '0', 'FS003', NULL, '001', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 500.00000, 9734.513500, 1265.486500, 11000.000000, NULL, NULL, NULL, '本订单由采购计划单自动生成2020-12-15 18:18:32', 0, 0, 0, NULL, NULL, 0, '001', '2020-12-15 18:18:32', '001', '2020-12-15 18:18:32');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155748971029', NULL, '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '0', 'FS003', '', '', '', '张三歌', '张三歌', '5535435', 0, '2020-12-15', 0.00, '', '', '', '', 20.00000, 109.829060, 10.170940, 120.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-15 10:25:48', 1, '009', '2020-12-15 10:25:45', '009', '2020-12-15 10:25:52');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155751975610', 'JH2012155256481019', '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '0', 'FS003', NULL, '001', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 500.00000, 9734.513500, 1265.486500, 11000.000000, NULL, NULL, NULL, '本订单由采购计划单自动生成2020-12-15 18:24:57', 0, 0, 0, NULL, NULL, 0, '001', '2020-12-15 18:24:57', '001', '2020-12-15 18:24:57');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012155754100491', NULL, '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '0', 'FS001', '', '003', '小米', 'zero', 'zero', NULL, 0, '2020-12-15', 0.00, '', '', '', '', 15.00000, 62.834785, 4.565215, 67.400000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '009', '2020-12-15 10:36:25', '009', '2020-12-15 10:36:25');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012159710198981', NULL, '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '计划合同', 'FS003', 'JS003', '005', '小明', '张三歌', '张三歌', '5535435', 1, '2020-12-15', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-15 11:13:14', '001', '2020-12-15 11:13:14');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012159910098485', 'JH2012155256481019', '2020-12-15', '2020-12-22', '2020-12-15', '2020-12-15', '0', 'FS003', NULL, '001', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, 500.00000, 9734.513500, 1265.486500, 11000.000000, NULL, NULL, NULL, '本订单由采购计划单自动生成2020-12-15 18:21:48', 0, 0, 0, NULL, NULL, 0, '001', '2020-12-15 18:21:48', '001', '2020-12-15 18:21:48');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012164855102561', NULL, '2020-12-16', '2020-12-23', '2020-12-16', '2020-12-16', '-1', 'FS003', 'JS003', '006', '小明1', '张三歌', '张三歌', '5535435', 0, '2020-12-16', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-16 11:05:04', '001', '2020-12-16 11:05:04');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012169854511015', NULL, '2020-12-16', '2020-12-23', '2020-12-16', '2020-12-16', '-1', 'FS003', 'JS003', '006', '小明1', '张三歌', '张三歌', '5535435', 0, '2020-12-16', 0.00, '', '', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '', '', '', '', 0, 0, 1, '001', '2020-12-16 11:09:59', 1, '001', '2020-12-16 11:07:07', '001', '2020-12-16 11:07:07');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012169899495357', NULL, '2020-12-16', '2020-12-23', '2020-12-16', '2020-12-16', '计划合同', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-16', 0.00, '深圳市龙华新区', 'CH2011269856985356', '', '配送上门', 41.00000, 218.761062, 28.438938, 247.200000, '专车配送', '深圳市龙华新区大为商务时空B座', '', '', 1, 0, 1, '001', '2020-12-16 15:25:09', 1, '001', '2020-12-16 15:21:31', '001', '2020-12-16 16:44:25');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012189757575398', NULL, '2020-12-18', '2020-12-25', '2020-12-18', '2020-12-18', '-1', 'FS002', 'JS004', '002', '小李1', '张三歌', 'zero', '', 0, '2020-12-18', 0.00, '', '', '', '', 30.00000, 168.318310, 21.681690, 190.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-18 17:59:42', 1, '009', '2020-12-18 17:59:38', '009', '2020-12-18 17:59:46');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012224949975510', NULL, '2020-12-22', '2020-12-29', '2020-12-22', '2020-12-22', '电话合同', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-22', 0.00, '', 'CH2011269856985356', '', '', 3.00000, 19.115044, 2.484956, 21.600000, '', '', '', '', 0, 0, 0, NULL, NULL, 1, '001', '2020-12-22 11:48:49', '001', '2020-12-22 13:41:48');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012225250489955', NULL, '2020-12-22', '2020-12-29', '2020-12-22', '2020-12-22', '-1', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-22', 0.00, '', '', '', '', 30.00000, 191.150443, 24.849557, 216.000000, '', '', '', '', 1, 0, 1, '001', '2020-12-22 14:56:15', 1, '001', '2020-12-22 14:56:04', '001', '2020-12-22 14:56:18');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012231019853985', NULL, '2020-12-23', '2020-12-30', '2020-12-23', '2020-12-23', '-1', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-23', 0.00, '', '', '', '', 110.00000, 916.153846, 143.846154, 1060.000000, '', '', '', '', 1, 0, 1, '009', '2020-12-23 08:42:38', 1, '009', '2020-12-23 08:42:22', '009', '2020-12-23 08:42:44');
INSERT INTO `qfyu_purchase_order` VALUES ('PO2012231024849995', NULL, '2020-12-23', '2020-12-30', '2020-12-23', '2020-12-23', '-1', 'FS003', 'JS003', '004', '小黄', '张三歌', '张三歌', '5535435', 0, '2020-12-23', 0.00, NULL, NULL, NULL, NULL, 30.00000, 148.672566, 19.327434, 168.000000, NULL, NULL, NULL, NULL, 1, 0, 1, '001', '2020-12-23 13:42:52', 1, '001', '2020-12-23 13:42:39', '001', '2020-12-23 13:42:57');

-- ----------------------------
-- Table structure for qfyu_purchase_order_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_order_details`;
CREATE TABLE `qfyu_purchase_order_details`  (
  `item_no` int(10) NOT NULL COMMENT '编码',
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '采购单据号',
  `goodsid` varbinary(10) NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单位',
  `sup_goodsid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方商品编号',
  `nums` decimal(16, 5) UNSIGNED NULL DEFAULT NULL COMMENT '采购数量',
  `price` decimal(16, 6) UNSIGNED NULL DEFAULT NULL COMMENT '单价',
  `discount` decimal(6, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '折扣',
  `reality_price` decimal(16, 6) UNSIGNED NULL DEFAULT NULL COMMENT '实际单价',
  `taxrate` decimal(6, 2) UNSIGNED NULL DEFAULT NULL COMMENT '税率',
  `notax_price` decimal(16, 6) UNSIGNED NULL DEFAULT NULL COMMENT '无税单价',
  `notax_total` decimal(16, 6) UNSIGNED NULL DEFAULT NULL COMMENT '无税金额',
  `tax_total` decimal(16, 6) UNSIGNED NULL DEFAULT NULL COMMENT '税款',
  `total` decimal(16, 6) UNSIGNED NULL DEFAULT NULL COMMENT '合计总额',
  `received_nums` decimal(16, 5) UNSIGNED NULL DEFAULT 0.00000 COMMENT '已收数量',
  `batch` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号/序列号',
  `register_num` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来货序号',
  `goods_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '货品状态',
  `quality_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '质量状态',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  PRIMARY KEY (`item_no`, `orderid`) USING BTREE,
  INDEX `goodsid`(`goodsid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购订单-单据详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_order_details
-- ----------------------------
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012015056102505', 0x4647303031, '3', NULL, 33.00000, 29.000000, 10.00, 2.900000, 13.00, 2.566372, 84.690000, 11.010000, 95.700000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012015110148529', 0x4647303031, '3', NULL, 20.00000, 28.000000, 0.00, 28.000000, 15.37, 24.270414, 485.410000, 74.590000, 560.000000, 0.00000, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012015510054995', 0x4647303031, '3', NULL, 30.00000, 22.000000, 0.00, 22.000000, 13.00, 19.469027, 584.070000, 75.930000, 660.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012035655525653', 0x4647303031, '6', NULL, 20.00000, 18.000000, 68.00, 12.240000, 13.00, 10.831858, 216.637160, 28.162840, 244.800000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012041005649102', 0x4647303032, '7', NULL, 0.40000, 9.000000, 0.50, 0.045000, 1.00, 0.044554, 0.017822, 0.000178, 0.018000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012051005248489', 0x4647303031, '7', NULL, 12.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012051029951481', 0x4647303031, '7', NULL, 12.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012054852565010', 0x4647303031, '7', NULL, 30.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012054949511019', 0x4647303031, '7', NULL, 12.00000, 28.000000, 0.00, 28.000000, 0.00, 28.000000, 336.000000, 0.000000, 336.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055098504810', 0x4647303031, '7', NULL, 5.00000, 5.000000, 0.00, 5.000000, 0.00, 5.000000, 25.000000, 0.000000, 25.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055149975649', 0x4647303031, '7', NULL, 12.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055210010197', 0x4647303033, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055250545099', 0x4647303031, '7', NULL, 12.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055351575799', 0x4647303031, '7', NULL, 12.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055498499851', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055553535352', 0x4647303031, '7', NULL, 24.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012055756491025', 0x4647303031, '7', NULL, 0.00000, 7.000000, 0.00, 7.000000, 0.00, 7.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059710097985', 0x4647303031, '7', NULL, 12.00000, 7.000000, 0.00, 7.000000, 0.00, 7.000000, 84.000000, 0.000000, 84.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059751495453', 0x4647303031, '7', NULL, 12.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059753102999', 0x4647303031, '7', NULL, 12.00000, 5.000000, 0.00, 5.000000, 0.00, 5.000000, 60.000000, 0.000000, 60.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059848555457', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059851531021', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059854494957', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012059955534855', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012105597545010', 0x4647303032, '盒', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012109810099491', 0x4647303034, '盒', NULL, 10.00000, 25.000000, 0.00, 25.000000, 0.00, 25.000000, 250.000000, 0.000000, 250.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012124852971011', 0x4647303032, '盒', NULL, 30.00000, 25.000000, 80.00, 20.000000, 13.00, 17.699115, 530.973450, 69.026550, 600.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012125553991005', 0x4647303032, '盒', NULL, 30.00000, 24.000000, 10.00, 2.400000, 13.00, 2.123894, 63.716820, 8.283180, 72.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012145350534810', 0x4647303032, '盒', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012145449521019', 0x4647303031, '盒', NULL, 5.00000, 5.000000, 0.00, 5.000000, 17.00, 4.273504, 21.367520, 3.632480, 25.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012155452975648', 0x4647303031, '盒', NULL, 500.00000, 22.000000, 0.00, 22.000000, 13.00, 19.469027, 9734.513275, 1265.486725, 11000.000000, 0.00000, NULL, NULL, '0', '0', '本订单由采购计划单自动生成2020-12-15 18:26:30');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012155652505655', 0x4647303031, '盒', NULL, 500.00000, 22.000000, 0.00, 22.000000, 13.00, 19.469027, 9734.513500, 1265.486500, 11000.000000, 0.00000, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012155655555455', 0x4647303031, '盒', NULL, 500.00000, 22.000000, 0.00, 22.000000, 13.00, 19.469027, 9734.513500, 1265.486500, 11000.000000, 0.00000, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012155748971029', 0x4647303031, '盒', NULL, 10.00000, 5.000000, 0.00, 5.000000, 0.00, 5.000000, 50.000000, 0.000000, 50.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012155751975610', 0x4647303031, '盒', NULL, 500.00000, 22.000000, 0.00, 22.000000, 13.00, 19.469027, 9734.513500, 1265.486500, 11000.000000, 0.00000, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012155754100491', 0x4647303032, '盒', NULL, 5.00000, 7.000000, 0.00, 7.000000, 15.00, 6.086957, 30.434785, 4.565215, 35.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012159910098485', 0x4647303031, '盒', NULL, 500.00000, 22.000000, 0.00, 22.000000, 13.00, 19.469027, 9734.513500, 1265.486500, 11000.000000, 0.00000, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012169899495357', 0x4647303031, '盒', NULL, 30.00000, 7.000000, 80.00, 5.600000, 13.00, 4.955752, 148.672566, 19.327434, 168.000000, 0.00000, NULL, NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012189757575398', 0x4647303032, '盒', NULL, 10.00000, 7.000000, 0.00, 7.000000, 10.00, 6.363636, 63.636364, 6.363636, 70.000000, 0.00000, NULL, NULL, '', '合格', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012224949975510', 0x4647303032, '盒', NULL, 3.00000, 9.000000, 80.00, 7.200000, 13.00, 6.371681, 19.115044, 2.484956, 21.600000, 0.00000, NULL, NULL, '', '', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012225250489955', 0x4647303032, '盒', NULL, 30.00000, 9.000000, 80.00, 7.200000, 13.00, 6.371681, 191.150443, 24.849557, 216.000000, 0.00000, NULL, NULL, '', '', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012231019853985', 0x4647303032, '盒', NULL, 10.00000, 7.000000, 0.00, 7.000000, 0.00, 7.000000, 70.000000, 0.000000, 70.000000, 0.00000, NULL, NULL, '合格', '隔离', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (1, 'PO2012231024849995', 0x4647303032, '盒', NULL, 30.00000, 7.000000, 80.00, 5.600000, 13.00, 4.955752, 148.672566, 19.327434, 168.000000, 0.00000, NULL, NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012015056102505', 0x4647303032, '7', NULL, 50.00000, 36.000000, 0.00, 36.000000, 13.00, 31.858407, 1592.920000, 207.080000, 1800.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012015510054995', 0x4647303033, '7', NULL, 50.00000, 16.800000, 80.00, 13.440000, 13.00, 11.893805, 594.690000, 77.310000, 672.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012035655525653', 0x4647303032, '7', NULL, 30.00000, 30.000000, 10.00, 3.000000, 13.00, 2.654867, 79.646010, 10.353990, 90.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012051005248489', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012051029951481', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012054852565010', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012054949511019', 0x4647303031, '7', NULL, 110.00000, 7.000000, 0.00, 7.000000, 0.00, 7.000000, 770.000000, 0.000000, 770.000000, 0.00000, NULL, NULL, '0', '1', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012055149975649', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012055250545099', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012055351575799', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012055498499851', 0x4647303032, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '2', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012055553535352', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '1', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012055756491025', 0x4647303032, '7', NULL, 0.00000, 9.000000, 0.00, 9.000000, 0.00, 9.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012059710097985', 0x4647303031, '7', NULL, 18.00000, 6.000000, 0.00, 6.000000, 0.00, 6.000000, 108.000000, 0.000000, 108.000000, 0.00000, NULL, NULL, '0', '1', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012059751495453', 0x4647303031, '7', NULL, 12.00000, 20.000000, 0.00, 20.000000, 0.00, 20.000000, 240.000000, 0.000000, 240.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012059753102999', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '2', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012059848555457', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '1', '1', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012059854494957', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012059955534855', 0x4647303031, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012105597545010', 0x464730303131, '盒', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012109810099491', 0x4647303038, '盒', NULL, 20.00000, 10.000000, 0.00, 10.000000, 13.00, 8.849558, 176.991160, 23.008840, 200.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012145350534810', 0x4647303032, '盒', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012145449521019', 0x4647303031, '盒', NULL, 10.00000, 5.000000, 50.00, 2.500000, 13.00, 2.212389, 22.123890, 2.876110, 25.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012155748971029', 0x4647303032, '盒', NULL, 10.00000, 7.000000, 0.00, 7.000000, 17.00, 5.982906, 59.829060, 10.170940, 70.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012155754100491', 0x464730303131, '盒', NULL, 10.00000, 3.240000, 0.00, 3.240000, 0.00, 3.240000, 32.400000, 0.000000, 32.400000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012169899495357', 0x4647303032, '盒', NULL, 11.00000, 9.000000, 80.00, 7.200000, 13.00, 6.371681, 70.088496, 9.111504, 79.200000, 0.00000, NULL, NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012189757575398', 0x4647303031, '盒', NULL, 10.00000, 5.000000, 0.00, 5.000000, 17.00, 4.273504, 42.735043, 7.264957, 50.000000, 0.00000, NULL, NULL, '', '', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (2, 'PO2012231019853985', 0x474430303232, '盒', NULL, 100.00000, 9.900000, 0.00, 9.900000, 17.00, 8.461538, 846.153846, 143.846154, 990.000000, 0.00000, NULL, NULL, '质量抽样', '合格', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (3, 'PO2012015056102505', 0x4647303033, '7', NULL, 20.00000, 28.000000, 0.00, 28.000000, 0.00, 28.000000, 560.000000, 0.000000, 560.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (3, 'PO2012015510054995', 0x4647303034, '1', NULL, 10.00000, 36.800000, 90.00, 33.120000, 0.00, 33.120000, 331.200000, 0.000000, 331.200000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (3, 'PO2012055498499851', 0x464730303131, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (3, 'PO2012055756491025', 0x4647303034, '1', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '1', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (3, 'PO2012059848555457', 0x4647303032, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (3, 'PO2012189757575398', 0x4647303032, '盒', NULL, 10.00000, 7.000000, 0.00, 7.000000, 13.00, 6.194690, 61.946903, 8.053097, 70.000000, 0.00000, NULL, NULL, '', '', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (4, 'PO2012055498499851', 0x464730303130, '12', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (5, 'PO2012055498499851', 0x4647303038, '1', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (6, 'PO2012055498499851', 0x464730303132, '7', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (7, 'PO2012055498499851', 0x4647303039, '1', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_order_details` VALUES (8, 'PO2012055498499851', 0x474430303134, '3', NULL, 0.00000, 0.000000, 0.00, 0.000000, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.00000, NULL, NULL, '0', '0', '');

-- ----------------------------
-- Table structure for qfyu_purchase_pay
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_pay`;
CREATE TABLE `qfyu_purchase_pay`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '采购付款单号',
  `reforderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '采购单号/结算单号',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商',
  `sup_sell` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售人员',
  `sup_contact` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方联系人',
  `sup_dept` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `emp_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人',
  `emp_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人姓名',
  `order_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `paykind` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '付款类型',
  `paymode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式',
  `sales_deptid` int(10) NULL DEFAULT NULL COMMENT '业务部门',
  `account` decimal(16, 2) NULL DEFAULT NULL COMMENT '总金额',
  `isprepay` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否使用结余款 1是',
  `cur_pay` decimal(12, 2) UNSIGNED NOT NULL COMMENT '付款金额',
  `discount_pay` decimal(12, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '折让金额',
  `paid_pay` decimal(12, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  `cheque_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支票号',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '单据备注说明',
  `ischeck` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否审核 1已审核',
  `check_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核付款时间',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '最后一次更新者',
  `update_date` datetime(0) NOT NULL COMMENT '最后一次更新时间',
  `dept_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '购方部门',
  PRIMARY KEY (`orderid`, `reforderid`) USING BTREE,
  INDEX `sup_code`(`sup_code`) USING BTREE,
  INDEX `emp_code`(`emp_code`) USING BTREE,
  INDEX `paykind`(`paykind`) USING BTREE,
  INDEX `sales_deptid`(`sales_deptid`) USING BTREE,
  INDEX `ischeck`(`ischeck`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购付款单-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_pay
-- ----------------------------
INSERT INTO `qfyu_purchase_pay` VALUES ('CF2012144848495253', 'PO2012145198505552', 'FS003', '张三歌', '张三歌', '5535435', '004', '小黄', '2020-12-14', 1, 'JS003', 1, 0.00, 0, 0.00, 0.00, 0.00, NULL, '本付款单由采购订单生成', 0, NULL, NULL, '001', '2020-12-14 17:37:52', '001', '2020-12-14 17:37:52', 0);

-- ----------------------------
-- Table structure for qfyu_purchase_pay_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_pay_details`;
CREATE TABLE `qfyu_purchase_pay_details`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '采购付款单号',
  `reforderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '账款单号',
  `item_no` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '项次',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `goodsqty` decimal(16, 5) NOT NULL COMMENT '采购数量',
  `price` decimal(16, 6) NOT NULL COMMENT '采购单价',
  `account` decimal(16, 6) NOT NULL COMMENT '应付总金额',
  `unpaid_price` decimal(16, 6) NOT NULL COMMENT '欠付金额',
  `pay_price` decimal(16, 6) NOT NULL COMMENT '本次实付金额',
  `is_settle` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否已结清 1已结清',
  PRIMARY KEY (`id`, `orderid`) USING BTREE,
  INDEX `reforderid`(`reforderid`) USING BTREE,
  INDEX `item_no`(`item_no`) USING BTREE,
  INDEX `goods_code`(`goods_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购付款单-单据详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_purchase_plan
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_plan`;
CREATE TABLE `qfyu_purchase_plan`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '计划单号',
  `typeid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计划类型 1 常规计划 2紧急计划',
  `prepared_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编制人员',
  `prepared_date` date NULL DEFAULT NULL COMMENT '编制日期',
  `invalid_date` date NULL DEFAULT NULL COMMENT '失效日期',
  `nums` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '计划品种数',
  `account` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '计划总金额',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '制单员',
  `creator_date` datetime(0) NULL DEFAULT NULL COMMENT '制单时间',
  `updater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后更新员',
  `updater_date` datetime(0) NULL DEFAULT NULL COMMENT '最后更新时间',
  `isclose` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否已结案 0未结案  1已结案',
  `ischeck` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否已审核 0未审核  1 已审核',
  `istrans` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否已转单 0未转单  1已转单',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `check_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `depart_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '资源所属',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购计划-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_plan
-- ----------------------------
INSERT INTO `qfyu_purchase_plan` VALUES ('JH2012015050102529', '1', '001', '2020-12-01', NULL, 1, 560.000000, '001', '2020-12-01 16:30:10', '001', '2020-12-23 08:33:53', 1, 1, 1, '', '001', '2020-12-01 16:45:15', 1);
INSERT INTO `qfyu_purchase_plan` VALUES ('JH2012151025449545', '1', NULL, '2020-12-15', '2020-12-22', 1, 0.000000, '001', '2020-12-15 17:03:11', '001', '2020-12-16 18:26:24', 0, 1, 0, '该订单由采购缺货登记单转入', NULL, NULL, 0);
INSERT INTO `qfyu_purchase_plan` VALUES ('JH2012155256481019', '1', '001', '2020-12-15', '2020-12-22', 1, 11000.000000, '001', '2020-12-15 16:55:32', '001', '2020-12-15 18:26:30', 0, 1, 1, '该订单由采购缺货登记转入', '001', '2020-12-15 18:16:37', 1);
INSERT INTO `qfyu_purchase_plan` VALUES ('JH2012155310110253', '1', NULL, '2020-12-15', '2020-12-22', 1, 0.000000, '001', '2020-12-15 16:58:13', '001', '2020-12-15 16:58:13', 0, 0, 0, '该订单由采购缺货登记单转入', NULL, NULL, 0);
INSERT INTO `qfyu_purchase_plan` VALUES ('JH2012165150495752', '常规计划', '001', '2020-12-16', '2020-12-23', 0, 0.000000, '001', '2020-12-16 18:01:23', '001', '2020-12-16 18:04:20', 0, 0, 0, '', NULL, NULL, 0);
INSERT INTO `qfyu_purchase_plan` VALUES ('JH2012175454514910', '常规计划', '001', '2020-12-17', '2020-12-24', 0, 0.000000, '001', '2020-12-17 11:15:02', '001', '2020-12-17 11:15:02', 0, 0, 0, '', NULL, NULL, 0);

-- ----------------------------
-- Table structure for qfyu_purchase_plan_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_plan_details`;
CREATE TABLE `qfyu_purchase_plan_details`  (
  `itemno` int(10) NOT NULL COMMENT '编码',
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '计划单号',
  `goodsid` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '单位',
  `buynum` decimal(16, 5) UNSIGNED NOT NULL DEFAULT 0.00000 COMMENT '采购数量',
  `buyprice` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '单价',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `taxrate` decimal(6, 2) UNSIGNED NULL DEFAULT 0.00 COMMENT '税率',
  `notaxprice` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '不含税单价',
  `goodsprice` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '货款',
  `taxprice` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '税款',
  `totalprice` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '合计总额',
  `provprice1` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商1价',
  `provprice2` decimal(16, 6) NULL DEFAULT 0.000000 COMMENT '供应商2价',
  `provprice3` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商3价',
  `provprice4` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商4价',
  `provprice5` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商5价',
  `provprice6` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商6价',
  `provprice7` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商7价',
  `provprice8` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '供应商8价',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  PRIMARY KEY (`itemno`, `orderid`) USING BTREE,
  UNIQUE INDEX `orderid_itemno`(`itemno`, `orderid`) USING BTREE,
  INDEX `goodsid`(`goodsid`) USING BTREE,
  INDEX `sup_code`(`sup_code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购计划-单据详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_plan_details
-- ----------------------------
INSERT INTO `qfyu_purchase_plan_details` VALUES (1, 'JH2012015050102529', 'FG001', '3', 20.00000, 28.000000, 'FS003', 15.37, 24.270414, 485.410000, 74.590000, 560.000000, 0.000000, 0.000000, 0.000000, NULL, NULL, 0.000000, 0.000000, 0.000000, '');
INSERT INTO `qfyu_purchase_plan_details` VALUES (1, 'JH2012151025449545', 'FG001', '盒', 500.00000, 0.000000, NULL, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, '');
INSERT INTO `qfyu_purchase_plan_details` VALUES (1, 'JH2012155256481019', 'FG001', '盒', 500.00000, 22.000000, 'FS003', 13.00, 19.469027, 9734.513500, 1265.486500, 11000.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, '');
INSERT INTO `qfyu_purchase_plan_details` VALUES (1, 'JH2012155310110253', 'FG001', '盒', 500.00000, 0.000000, NULL, 0.00, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, '');

-- ----------------------------
-- Table structure for qfyu_purchase_register
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_register`;
CREATE TABLE `qfyu_purchase_register`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据号',
  `supplier_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编号',
  `supplier_sale` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售人',
  `supplier_contact` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方联系人',
  `supplier_depart` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `supplier_orderid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售单号',
  `supplier_remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商备注',
  `receiving_date` datetime(0) NULL DEFAULT NULL COMMENT '接货日期',
  `contract_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同号',
  `salesman` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '业务员',
  `o_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购订单单据编号（由采购订单转单生成）',
  `pay_type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式(关联结算方式表主键id)',
  `transport_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输方式',
  `transport_equipment` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输设备',
  `car_number` char(7) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输车牌号',
  `hours` int(10) NULL DEFAULT NULL COMMENT '运途时间（小时）',
  `transport_certificate` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '特殊品运输证',
  `temperature` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '温度控制状况',
  `ware_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '收货仓库',
  `cnee_code1` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第一收货人',
  `cnee_code2` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第二收货人',
  `serial_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '流水号',
  `total_amount` decimal(15, 5) NULL DEFAULT NULL COMMENT '货品总数',
  `total_money` decimal(15, 6) NULL DEFAULT NULL COMMENT '货款',
  `taxes` decimal(15, 6) NULL DEFAULT NULL COMMENT '税款',
  `total_payprice` decimal(15, 6) NULL DEFAULT NULL COMMENT '合计',
  `creator_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `creation_date` datetime(0) NOT NULL COMMENT '创建时间',
  `checker_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员',
  `checker_date` datetime(0) NULL DEFAULT NULL COMMENT '复核时间',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否审核 默认0未审核  1已审核',
  `order_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否转单 默认0未转单  1已转单',
  `recipient_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否代销收货 默认0不代销收货 1代销收货',
  `sale_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否委托销售 默认0不委托销售 1委托销售',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '来货登记表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_register
-- ----------------------------
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012011024948545', 'FS003', '张三歌', 'zero', '5535435', NULL, '', NULL, '', '004', 'PO2012015056102505', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 103.00000, 2237.610000, 218.090000, 2455.700000, '001', '2020-12-01 19:01:03', NULL, NULL, '本订单由采购订单自动生成2020-12-01 19:01:03', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012015299505655', 'FS003', '', '', '', '11', '', '2020-12-03 00:00:00', '', '001', 'PO2012015110148529', '0', '', '', '', NULL, '', '', '', '005', '', '', 20.00000, 485.000000, 74.000000, 560.000000, '009', '2020-12-01 18:56:36', '009', '2020-12-04 08:39:17', '本订单由采购订单自动生成2020-12-01 18:56:36', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012029910056971', 'FS003', '张三歌', 'zero', '5535435', NULL, '', NULL, '', '004', 'PO2012015056102505', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 103.00000, 2237.610000, 218.090000, 2455.700000, '001', '2020-12-02 11:29:48', NULL, NULL, '本订单由采购订单自动生成2020-12-02 11:29:48', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012035048564810', 'FS003', '张三歌', '张三歌', '5535435', '', '', '1970-01-01 00:00:00', '', '004', 'PO2012035655525653', 'JS003', '', '', '', NULL, '', '', '', '004', '', '', 50.00000, 153.097345, 19.902655, 173.000000, '001', '2020-12-03 10:30:58', '009', '2020-12-24 10:02:01', '本订单由采购订单自动生成2020-12-03 10:30:58', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012041019710050', 'FS003', '张三歌', '张三歌', '5535435', NULL, '', '2020-12-04 16:03:10', '', '003', 'PO2012045552995398', '2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00000, 0.000000, 0.000000, 0.000000, '009', '2020-12-04 16:03:10', NULL, NULL, '本订单由采购订单自动生成2020-12-04 16:03:10', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012041029950975', 'FS003', '张三歌', 'zero', '5535435', '', '', '1970-01-01 08:00:00', '', '004', 'PO2012015056102505', 'JS003', '', '', '', NULL, '', '', '', '006', '', '', 103.00000, 2161.000000, 208.000000, 2369.000000, '001', '2020-12-04 14:39:11', '009', '2020-12-11 09:41:38', '本订单由采购订单自动生成2020-12-04 14:39:11', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012045753521019', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-11 14:08:29', '', '004', 'PO2012041005649102', 'JS003', '', '', '', NULL, '', '', '', '005', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '009', '2020-12-04 17:29:29', '009', '2020-12-11 14:08:29', '本订单由采购订单自动生成2020-12-04 17:29:29', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012051019752545', 'FS003', '张三歌', 'zero', '5535435', '', '', '2020-12-11 02:01:01', '', '004', 'PO2012015056102505', 'JS003', '', '', '', NULL, '', '', '', '003', '', '', 103.00000, 2161.000000, 208.000000, 2369.000000, '001', '2020-12-05 17:42:54', '009', '2020-12-12 09:29:23', '本订单由采购订单自动生成2020-12-05 17:42:54', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012105310053574', 'FS007', '', '', '', '', '', '2020-12-11 00:00:00', '', '003', 'PO2012109810099491', 'JS003', '', '', '', NULL, '', '', '', '003', '003', '', 101.00000, 2508.000000, 1.000000, 25010.000000, '009', '2020-12-10 15:01:41', '009', '2020-12-14 10:41:08', '本订单由采购订单自动生成2020-12-10 15:01:41', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012121015310056', 'FS003', '张三歌', '张三歌', '5535435', NULL, '', '2020-12-12 16:38:22', '', '', 'PO2012125553991005', 'JS003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30.00000, 63.716820, 8.283180, 72.000000, '001', '2020-12-12 16:38:22', NULL, NULL, '本订单由采购订单自动生成2020-12-12 16:38:22', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012129753561021', 'FS003', '张三歌', '张三歌', '5535435', NULL, '', '2020-12-12 16:06:18', 'CH2011269856985356', '002', 'PO2012124852971011', '3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30.00000, 530.973450, 69.026550, 600.000000, '001', '2020-12-12 16:06:18', NULL, NULL, '本订单由采购订单自动生成2020-12-12 16:06:18', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012141011009810', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-14 00:00:00', '', '004', 'PO2012145350534810', 'JS003', '', '', '', NULL, '', '', '', '006', '004', '', 3.00000, 23.000000, 0.000000, 23.000000, '009', '2020-12-14 10:08:14', '009', '2020-12-14 10:35:27', '本订单由采购订单自动生成2020-12-14 10:08:14', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012141019910151', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-14 00:00:00', '', '004', 'PO2012145449521019', 'JS003', '', '', '', NULL, '', '', '', '005', '', '', 15.00000, 43.000000, 6.000000, 50.000000, '009', '2020-12-14 18:57:50', '009', '2020-12-15 09:26:04', '本订单由采购订单自动生成', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012149953100501', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-14 00:00:00', 'CH2011269856985356', '004', 'PO2012124852971011', 'JS003', '', '', '', NULL, '', '', '', '004', '', '', 3510.00000, 495.000000, 64.000000, 56030.000000, '001', '2020-12-14 09:26:20', '009', '2020-12-15 10:14:56', '本订单由采购订单自动生成2020-12-14 09:26:20', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012154857525157', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-15 10:49:08', '', '004', 'PO2012155748971029', 'JS003', '', '', '', NULL, '', '', '', '003', '', '', 20.00000, 109.000000, 10.000000, 120.000000, '009', '2020-12-15 10:25:52', '009', '2020-12-15 10:49:31', '本订单由采购订单自动生成', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012155156995010', 'FS003', '张三歌', '张三歌', '5535435', NULL, '', '2020-12-15 18:21:23', '', '', 'PO2012155151535150', 'JS003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00000, 0.000000, 0.000000, 0.000000, '001', '2020-12-15 18:21:23', NULL, NULL, '本订单由采购订单自动生成', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012155251971005', 'FS002', '', 'zero', '', '', '', '2020-12-15 00:00:00', '', '002', '', 'JS004', '', '', '', NULL, '', '', '', '009', '002', '', 100.00000, 676.000000, 115.000000, 792.000000, '009', '2020-12-15 16:13:56', '009', '2020-12-15 16:14:13', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012155452514810', 'FS009', '', '', '', '', '备注', '2020-12-15 10:26:00', '', '005', '', 'JS002', '', '', '', NULL, '', '', '', '004', '', '', 15.00000, 78.000000, 6.000000, 85.000000, '009', '2020-12-15 10:46:14', '', NULL, '', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012159751501005', 'FS009', '', '', '', '', '备注', '2020-12-15 10:26:00', '', '005', '', 'JS002', '', '', '', NULL, '', '', '', '006', '', '', 9.00000, 38.000000, 5.000000, 44.000000, '009', '2020-12-15 10:53:46', '009', '2020-12-15 10:54:14', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012159857525455', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-15 15:56:06', '', '004', '', 'JS003', '', '', '', NULL, '', '', 'CK004', '005', '', '', 26.00000, 91.000000, 8.000000, 100.000000, '009', '2020-12-15 15:58:03', '009', '2020-12-15 15:58:15', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012165710057519', 'FS003', '张三歌', '张三歌', '5535435', NULL, '', '2020-12-16 15:25:13', 'CH2011269856985356', '004', 'PO2012169899495357', 'JS003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41.00000, 218.761062, 28.438938, 247.200000, '001', '2020-12-16 15:25:13', NULL, NULL, '本订单由采购订单自动生成', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012165754545397', 'FS003', '张三歌', '张三歌', '5535435', NULL, '', '2020-12-16 16:44:25', 'CH2011269856985356', '004', 'PO2012169899495357', 'JS003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 41.00000, 218.761062, 28.438938, 247.200000, '001', '2020-12-16 16:44:25', NULL, NULL, '本订单由采购订单自动生成', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012185050551021', 'FS002', '张三歌', 'zero', '', '', '', '2020-12-18 00:00:00', '', '002', 'PO2012189757575398', 'JS004', '', '', '', NULL, '', '', '', '003', '', '', 30.00000, 168.000000, 21.000000, 190.000000, '009', '2020-12-18 17:59:46', '009', '2020-12-18 18:00:15', '本订单由采购订单自动生成', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012185152565552', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-18 00:00:00', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '004', '005', '', 52.00000, 676.000000, 50.000000, 726.000000, '001', '2020-12-18 17:50:27', '001', '2020-12-18 17:51:20', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012191015610057', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-19 00:00:00', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '003', '', '', 85.00000, 1124.000000, 72.000000, 1196.000000, '001', '2020-12-19 10:14:54', '001', '2020-12-19 10:17:35', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012199710056545', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-19 14:57:45', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '002', '', '', 13.00000, 135.000000, 20.000000, 156.000000, '001', '2020-12-19 15:00:58', '', NULL, '', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012199752495256', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-19 00:00:00', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '001', '', '', 24.00000, 234.000000, 30.000000, 264.000000, '001', '2020-12-19 10:43:54', '001', '2020-12-19 10:45:08', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012215250505710', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-21 17:03:32', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '004', '', '', 50.00000, 634.000000, 0.000000, 634.000000, '001', '2020-12-21 17:05:08', '001', '2020-12-21 17:05:32', '', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012225057539810', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-22 00:00:00', '', '004', 'PO2012225250489955', 'JS003', '', '', '', NULL, '', '', '', '004', '', '', 30.00000, 152.000000, 19.000000, 172.000000, '001', '2020-12-22 14:56:18', '001', '2020-12-22 14:58:15', '本订单由采购订单自动生成', 1, 1, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012225598575656', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-22 00:00:00', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '003', '', '', 10.00000, 63.000000, 6.000000, 70.000000, '009', '2020-12-22 13:57:43', '009', '2020-12-22 14:10:29', '', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012229910057575', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-22 00:00:00', '', '004', '', 'JS003', '', '', '', NULL, '', '', '', '004', '', '', 0.00000, 0.000000, 0.000000, 0.000000, '009', '2020-12-22 16:55:40', '009', '2020-12-22 18:30:58', '', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012234951100101', 'FS003', '张三歌', '张三歌', '5535435', NULL, NULL, '2020-12-23 13:42:57', NULL, '004', 'PO2012231024849995', 'JS003', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30.00000, 148.672566, 19.327434, 168.000000, '001', '2020-12-23 13:42:57', NULL, NULL, '本订单由采购订单自动生成', 0, 0, 0, 0);
INSERT INTO `qfyu_purchase_register` VALUES ('PC2012235248539955', 'FS003', '张三歌', '张三歌', '5535435', '', '', '2020-12-23 00:00:00', '', '004', 'PO2012231019853985', 'JS003', '公路运输', '汽车', '粤B12345', NULL, '', '', '', '004', '009', '', 400.00000, 1640.912185, 264.087815, 1905.000000, '009', '2020-12-23 08:42:44', '009', '2020-12-23 14:44:09', '本订单由采购订单自动生成', 1, 1, 0, 0);

-- ----------------------------
-- Table structure for qfyu_purchase_register_bill
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_register_bill`;
CREATE TABLE `qfyu_purchase_register_bill`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `bill_no` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发票号码',
  `orderid` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '来货单号',
  `address` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发票地址',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发票抬头',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '发票类型 1普通发票 2增值税发票',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '发票日期',
  `money` decimal(15, 6) NOT NULL COMMENT '发票总金额',
  `track` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票轨号',
  `tel` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票电话',
  `remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`, `bill_no`, `orderid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '随货同行发票信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_purchase_register_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_register_details`;
CREATE TABLE `qfyu_purchase_register_details`  (
  `r_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '来货订单单据编号',
  `ref_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购订单单据号',
  `item_no` int(10) NOT NULL COMMENT '商品项次',
  `goods_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '单位',
  `order_amount` decimal(16, 5) NULL DEFAULT NULL COMMENT '订货数量',
  `come_amount` decimal(16, 5) NULL DEFAULT NULL COMMENT '来货数量',
  `gift_amount` decimal(16, 5) NULL DEFAULT NULL COMMENT '赠品数量',
  `rejection_amount` decimal(16, 5) NULL DEFAULT NULL COMMENT '拒收数量',
  `rejection_remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拒收原因',
  `discount` decimal(6, 2) NULL DEFAULT NULL COMMENT '折扣(%)',
  `order_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来货序号',
  `tax` decimal(6, 2) NULL DEFAULT NULL COMMENT '税率(%)',
  `not_tax_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '无税单价',
  `not_tax_money` decimal(16, 6) NULL DEFAULT NULL COMMENT '无税金额',
  `tax_total` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `total_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计',
  `gross_profit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '毛利率分类',
  `qualified_amout` decimal(16, 5) NULL DEFAULT NULL COMMENT '合格数量',
  `supplier_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方发货项次',
  `supplier_goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方商品编号',
  `supplier_orderid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方发货单号',
  `supplier_sale_orderid` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售单号',
  `receipts_amout` decimal(16, 5) NULL DEFAULT NULL COMMENT '实收数量',
  `price1` decimal(16, 6) NULL DEFAULT NULL COMMENT '单价',
  `price` decimal(16, 6) NULL DEFAULT NULL COMMENT '实际单价',
  `batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号',
  `production_date` datetime(0) NULL DEFAULT NULL COMMENT '生产日期',
  `production_end_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期至',
  `pifaml` decimal(16, 6) NULL DEFAULT NULL COMMENT '批发毛利',
  `retail` decimal(16, 6) NULL DEFAULT NULL COMMENT '零售毛利',
  `new_whole` decimal(16, 6) NULL DEFAULT NULL COMMENT '最新批发价',
  `new_retail` decimal(16, 6) NULL DEFAULT NULL COMMENT '最新零售价',
  `traceability_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追溯号',
  `sterilization_batch` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `production_code` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产许可证编号',
  `drug` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '药检报告 默认null，否则有',
  `product_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货品状态',
  `quality_status` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状态',
  `del_remark` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '来货登记明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_register_details
-- ----------------------------
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012011024948545', NULL, 1, 'FG001', '3', 33.00000, NULL, NULL, NULL, NULL, 10.00, NULL, 13.00, 2.566372, 84.690000, 11.010000, 95.700000, '', NULL, NULL, NULL, NULL, NULL, 33.00000, NULL, 2.900000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012011024948545', NULL, 2, 'FG002', '7', 50.00000, NULL, NULL, NULL, NULL, 0.00, NULL, 13.00, 31.858407, 1592.920000, 207.080000, 1800.000000, '', NULL, NULL, NULL, NULL, NULL, 50.00000, NULL, 36.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012011024948545', NULL, 3, 'FG003', '7', 20.00000, NULL, NULL, NULL, NULL, 0.00, NULL, 0.00, 28.000000, 560.000000, 0.000000, 560.000000, '', NULL, NULL, NULL, NULL, NULL, 20.00000, NULL, 28.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012029910056971', NULL, 1, 'FG001', '3', 33.00000, NULL, NULL, NULL, NULL, 10.00, NULL, 13.00, 2.566372, 84.690000, 11.010000, 95.700000, '', NULL, NULL, NULL, NULL, NULL, 33.00000, NULL, 2.900000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012029910056971', NULL, 2, 'FG002', '7', 50.00000, NULL, NULL, NULL, NULL, 0.00, NULL, 13.00, 31.858407, 1592.920000, 207.080000, 1800.000000, '', NULL, NULL, NULL, NULL, NULL, 50.00000, NULL, 36.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012029910056971', NULL, 3, 'FG003', '7', 20.00000, NULL, NULL, NULL, NULL, 0.00, NULL, 0.00, 28.000000, 560.000000, 0.000000, 560.000000, '', NULL, NULL, NULL, NULL, NULL, 20.00000, NULL, 28.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012015299505655', NULL, 1, 'FG001', '0', 20.00000, 25.00000, 5.00000, 5.00000, NULL, 0.00, NULL, 15.37, 24.270414, 485.408280, 74.591720, 560.000000, '', NULL, NULL, NULL, NULL, NULL, 20.00000, NULL, 28.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012041029950975', NULL, 1, 'FG001', '0', 33.00000, 33.00000, 0.00000, 0.00000, NULL, 10.00, NULL, 13.00, 0.256637, 8.469027, 1.100973, 9.570000, '', NULL, NULL, NULL, NULL, NULL, 33.00000, NULL, 2.900000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '样品', NULL, NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012041029950975', NULL, 2, 'FG002', '0', 50.00000, 50.00000, 0.00000, 0.00000, NULL, 0.00, NULL, 13.00, 31.858407, 1592.920354, 207.079646, 1800.000000, '', NULL, NULL, NULL, NULL, NULL, 50.00000, NULL, 36.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, '1321', '122', NULL, NULL, '0', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012041029950975', NULL, 3, 'FG003', '0', 20.00000, 20.00000, 0.00000, 0.00000, NULL, 0.00, NULL, 0.00, 28.000000, 560.000000, 0.000000, 560.000000, '', NULL, NULL, NULL, NULL, NULL, 20.00000, NULL, 28.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012051019752545', NULL, 1, 'FG001', '0', 33.00000, 33.00000, 0.00000, 0.00000, NULL, 10.00, NULL, 13.00, 0.256637, 8.469027, 1.100973, 9.570000, '', NULL, NULL, NULL, NULL, NULL, 33.00000, NULL, 2.900000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012051019752545', NULL, 2, 'FG002', '0', 50.00000, 50.00000, 0.00000, 0.00000, NULL, 0.00, NULL, 13.00, 31.858407, 1592.920354, 207.079646, 1800.000000, '', NULL, NULL, NULL, NULL, NULL, 50.00000, NULL, 36.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012051019752545', NULL, 3, 'FG003', '0', 20.00000, 20.00000, 0.00000, 0.00000, NULL, 0.00, NULL, 0.00, 28.000000, 560.000000, 0.000000, 560.000000, '', NULL, NULL, NULL, NULL, NULL, 20.00000, NULL, 28.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012045753521019', NULL, 1, 'FG002', '0', 4.00000, 4.00000, 0.00000, 0.00000, NULL, 0.00, NULL, 15.00, 6.086957, 24.347826, 3.652174, 28.000000, '', NULL, NULL, NULL, NULL, NULL, 4.00000, NULL, 7.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012129753561021', NULL, 1, 'FG002', '盒', 30.00000, 30.00000, NULL, NULL, NULL, 80.00, NULL, 13.00, 17.699115, 530.973450, 69.026550, 600.000000, '', NULL, NULL, NULL, NULL, NULL, 30.00000, NULL, 20.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012121015310056', NULL, 1, 'FG002', '盒', 30.00000, 30.00000, NULL, NULL, NULL, 10.00, NULL, 13.00, 2.123894, 63.716820, 8.283180, 72.000000, '', NULL, NULL, NULL, NULL, NULL, 30.00000, NULL, 2.400000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012105310053574', NULL, 1, 'FG004', '0', 10.00000, 11.00000, 0.00000, 1.00000, NULL, 0.00, NULL, 0.00, 25.000000, 250.000000, 0.000000, 250.000000, 'C', NULL, NULL, NULL, NULL, NULL, 10.00000, NULL, 25.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012105310053574', NULL, 2, 'FG004', '0', 3.00000, 4.00000, 0.00000, 3.00000, '', 0.00, '', 17.00, 8.547009, 8.547009, 1.452991, 10.000000, '', NULL, '', '', '', '', 1.00000, NULL, 10.000000, '', NULL, NULL, 10.000000, 10.000000, NULL, NULL, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012105310053574', NULL, 3, 'FG0010', '0', 4.00000, 4.00000, 0.00000, 1.00000, '', 0.00, '', 13.00, 3.451327, 10.353982, 1.346018, 11.700000, '', NULL, '', '', '', '', 3.00000, NULL, 3.900000, '', NULL, NULL, 0.000000, 0.000000, NULL, NULL, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012105310053574', NULL, 4, 'FG0012', '0', 10.00000, 20.00000, 0.00000, 10.00000, '', 0.00, '', 0.00, 9.000000, 90.000000, 0.000000, 90.000000, '', NULL, '', '', '', '', 10.00000, NULL, 9.000000, '', NULL, NULL, 0.000000, 0.000000, NULL, NULL, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012141011009810', NULL, 1, 'FG002', '0', 3.00000, 2.00000, 0.00000, 1.00000, NULL, 0.00, NULL, 0.00, 7.000000, 7.000000, 0.000000, 7.000000, '', NULL, NULL, NULL, NULL, NULL, 1.00000, NULL, 7.000000, NULL, '2020-12-14 00:00:00', '2020-12-31 00:00:00', 3.000000, 3.000000, NULL, NULL, '追溯号', '灭菌批号', NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012141011009810', NULL, 2, 'FG002', '0', 7.00000, 2.00000, 0.00000, 1.00000, NULL, 0.00, NULL, 0.00, 7.000000, 7.000000, 0.000000, 7.000000, '', NULL, NULL, NULL, NULL, NULL, 1.00000, NULL, 7.000000, NULL, NULL, NULL, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012141011009810', NULL, 3, 'FG0012', '0', 6.00000, 2.00000, 0.00000, 1.00000, '', 0.00, '', 0.00, 9.000000, 9.000000, 0.000000, 9.000000, '', NULL, '', '', '', '', 1.00000, NULL, 9.000000, '', NULL, NULL, 0.000000, 0.000000, NULL, NULL, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012141019910151', NULL, 1, 'FG001', '0', 5.00000, 5.00000, NULL, NULL, NULL, 0.00, NULL, 17.00, 4.273504, 21.367520, 3.632480, 25.000000, '', NULL, NULL, NULL, NULL, NULL, 5.00000, NULL, 5.000000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012141019910151', NULL, 2, 'FG001', '0', 10.00000, 10.00000, NULL, NULL, NULL, 50.00, NULL, 13.00, 2.212389, 22.123890, 2.876110, 25.000000, '', NULL, NULL, NULL, NULL, NULL, 10.00000, NULL, 2.500000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012149953100501', NULL, 1, 'FG002', '0', 40.00000, 40.00000, 8.00000, 5.00000, NULL, 80.00, NULL, 13.00, 14.159292, 495.575221, 64.424779, 560.000000, '', NULL, NULL, NULL, NULL, NULL, 35.00000, NULL, 20.000000, NULL, '2020-12-14 00:00:00', '2020-12-14 00:00:00', 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012149953100501', NULL, 2, 'FG003', '0', 10.00000, 20.00000, 0.00000, 10.00000, '', 0.00, '', 15.00, 2.608696, 26.086957, 3.913043, 30.000000, '', NULL, '', '', '', '', 10.00000, NULL, 3.000000, '', '2020-12-15 00:00:00', '2020-12-31 00:00:00', 15.000000, 13.000000, NULL, NULL, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012155452514810', NULL, 1, 'FG001', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 15.00, 4.347826, 43.478261, 6.521739, 50.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 5.000000, '', '2020-12-15 00:00:00', '2020-12-15 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012155452514810', NULL, 2, 'FG002', '0', 5.00000, 5.00000, 0.00000, 0.00000, '', 0.00, '', 0.00, 7.000000, 35.000000, 0.000000, 35.000000, '', 0.00000, '', '', '', '', 5.00000, NULL, 7.000000, '', '2020-12-15 00:00:00', '2020-12-15 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012154857525157', NULL, 1, 'FG001', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 0.00, 5.000000, 50.000000, 0.000000, 50.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 5.000000, '', NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012154857525157', NULL, 2, 'FG002', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 17.00, 5.982906, 59.829060, 10.170940, 70.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 7.000000, '', NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '0', '0', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012159751501005', NULL, 1, 'FG001', '0', 5.00000, 5.00000, 0.00000, 0.00000, '', 0.00, '', 15.00, 4.347826, 21.739130, 3.260870, 25.000000, '', 0.00000, '', '', '', '', 5.00000, NULL, 5.000000, '', '2020-12-15 00:00:00', '2020-12-31 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012159751501005', NULL, 2, 'FG003', '0', 3.00000, 3.00000, 0.00000, 0.00000, '', 0.00, '', 15.00, 2.608696, 7.826087, 1.173913, 9.000000, '', 0.00000, '', '', '', '', 3.00000, NULL, 3.000000, '', '2020-12-15 00:00:00', '2020-12-31 00:00:00', 15.000000, 13.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012159751501005', NULL, 3, 'FG004', '0', 1.00000, 1.00000, 0.00000, 0.00000, '', 0.00, '1212', 17.00, 8.547009, 8.547009, 1.452991, 10.000000, '', 0.00000, '', '', '', '', 1.00000, NULL, 10.000000, '20201215', '2020-12-15 00:00:00', '2020-12-31 00:00:00', 10.000000, 10.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012159857525455', NULL, 1, 'FG001', '0', 1.00000, 1.00000, 0.00000, 0.00000, '', 0.00, '', 15.00, 4.347826, 4.347826, 0.652174, 5.000000, '', 0.00000, '', '', '', '', 1.00000, NULL, 5.000000, '', '2020-12-15 00:00:00', '2020-12-15 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012159857525455', NULL, 2, 'FG002', '0', 5.00000, 5.00000, 0.00000, 0.00000, '', 0.00, '', 0.00, 7.000000, 35.000000, 0.000000, 35.000000, '', 0.00000, '', '', '', '', 5.00000, NULL, 7.000000, '', '2020-12-14 00:00:00', '2020-12-14 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012159857525455', NULL, 3, 'FG003', '0', 20.00000, 20.00000, 0.00000, 0.00000, '', 0.00, '', 15.00, 2.608696, 52.173913, 7.826087, 60.000000, '', 0.00000, '', '', '', '', 20.00000, NULL, 3.000000, '', '2020-12-15 00:00:00', '2020-12-15 00:00:00', 15.000000, 13.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012155251971005', NULL, 1, 'FG0012', '0', 100.00000, 100.00000, 0.00000, 0.00000, '', 88.00, '', 17.00, 6.769231, 676.923077, 115.076923, 792.000000, '', 0.00000, '', '', '', '', 100.00000, NULL, 9.000000, '20201215', '2020-12-15 00:00:00', '2020-12-31 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '样品', '隔离', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012165710057519', NULL, 1, 'FG001', '盒', 30.00000, 30.00000, NULL, NULL, NULL, 80.00, NULL, 13.00, 4.955752, 148.672566, 19.327434, 168.000000, '', NULL, NULL, NULL, NULL, NULL, 30.00000, NULL, 5.600000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012165710057519', NULL, 2, 'FG002', '盒', 11.00000, 11.00000, NULL, NULL, NULL, 80.00, NULL, 13.00, 6.371681, 70.088496, 9.111504, 79.200000, '', NULL, NULL, NULL, NULL, NULL, 11.00000, NULL, 7.200000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012165754545397', 'PO2012169899495357', 1, 'FG001', '盒', 30.00000, 30.00000, NULL, NULL, NULL, 80.00, NULL, 13.00, 4.955752, 148.672566, 19.327434, 168.000000, '', NULL, NULL, NULL, NULL, NULL, 30.00000, NULL, 5.600000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012165754545397', 'PO2012169899495357', 2, 'FG002', '盒', 11.00000, 11.00000, NULL, NULL, NULL, 80.00, NULL, 13.00, 6.371681, 70.088496, 9.111504, 79.200000, '', NULL, NULL, NULL, NULL, NULL, 11.00000, NULL, 7.200000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012185152565552', NULL, 1, 'FG001', '0', 30.25000, 30.25000, 0.00000, 0.00000, '', 0.00, '', 15.00, 11.026087, 333.539130, 50.030870, 383.570000, '', 0.00000, '', '', '', '', 30.25000, NULL, 12.680000, '', '2020-12-17 00:00:00', '2020-12-17 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012185152565552', NULL, 2, 'FG002', '0', 22.00000, 22.00000, 0.00000, 0.00000, '', 0.00, '', 0.00, 15.600000, 343.200000, 0.000000, 343.200000, '', 0.00000, '', '', '', '', 22.00000, NULL, 15.600000, '', '2020-12-18 00:00:00', '2020-12-18 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012185050551021', NULL, 1, 'FG001', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 17.00, 4.273504, 42.735043, 7.264957, 50.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 5.000000, '', NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012185050551021', NULL, 2, 'FG002', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 10.00, 6.363636, 63.636364, 6.363636, 70.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 7.000000, '', NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012185050551021', NULL, 3, 'FG002', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 13.00, 6.194690, 61.946903, 8.053097, 70.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 7.000000, '', NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012191015610057', NULL, 1, 'FG001', '0', 35.75000, 35.75000, 0.00000, 0.00000, '', 0.00, '', 15.00, 13.547826, 484.334783, 72.650217, 556.985000, '', 0.00000, '', '', '', '', 35.75000, NULL, 15.580000, '', '2020-12-18 00:00:00', '2020-12-18 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012191015610057', NULL, 2, 'FG002', '0', 50.00000, 50.00000, 0.00000, 0.00000, '', 0.00, '', 0.00, 12.800000, 640.000000, 0.000000, 640.000000, '', 0.00000, '', '', '', '', 50.00000, NULL, 12.800000, '', '2020-12-19 00:00:00', '2020-12-19 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012199752495256', NULL, 1, 'FG001', '0', 24.50000, 24.50000, 0.00000, 0.00000, '', 0.00, '', 13.00, 9.557522, 234.159292, 30.440708, 264.600000, '', 0.00000, '', '', '', '', 24.50000, NULL, 10.800000, '', '2020-12-18 00:00:00', '2020-12-18 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012199710056545', NULL, 1, 'FG001', '0', 20.00000, 13.00000, 0.00000, 0.00000, '', 0.00, '', 15.00, 10.434783, 135.652174, 20.347826, 156.000000, '', 0.00000, '', '', '', '', 13.00000, NULL, 12.000000, '', '2020-12-19 00:00:00', '2020-12-19 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012215250505710', NULL, 1, 'FG002', '0', 50.00000, 50.00000, 0.00000, 0.00000, '', 0.00, '', 0.00, 12.680000, 634.000000, 0.000000, 634.000000, '', 0.00000, '', '', '', '', 50.00000, NULL, 12.680000, '', '2020-12-21 00:00:00', '2020-12-21 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012225598575656', NULL, 1, 'FG002', '0', 10.00000, 10.00000, 0.00000, 0.00000, '', 0.00, '', 10.00, 6.363636, 63.636364, 6.363636, 70.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 7.000000, '', '2020-12-22 00:00:00', '2020-12-22 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012225057539810', NULL, 1, 'FG002', '0', 30.00000, 30.00000, 0.00000, 0.00000, '', 80.00, '', 13.00, 5.097345, 152.920354, 19.879646, 172.800000, '', 0.00000, '', '', '', '', 30.00000, NULL, 7.200000, '', '2020-12-21 00:00:00', '2020-12-21 00:00:00', 0.000000, 0.000000, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012229910057575', NULL, 1, 'FG002', '盒', 10.00000, 10.00000, 0.00000, 0.00000, '', 50.00, '来货序号', 13.00, 17.699115, 176.991150, 23.008850, 200.000000, '', 0.00000, '', '', '', '', 10.00000, NULL, 40.000000, '生产批号', '2020-12-22 00:00:00', '2020-12-30 00:00:00', -176.991150, -176.991150, 0.000000, 0.000000, '11', '111', '', NULL, '合格', '合格', '111');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012229910057575', NULL, 2, 'FG001', '盒', 50.00000, 30.00000, 0.00000, 0.00000, '', 50.00, '', 15.00, 2.173913, 65.217391, 9.782609, 75.000000, '', 0.00000, '', '', '', '', 30.00000, NULL, 5.000000, '', '2020-12-22 00:00:00', '2020-12-22 00:00:00', 114.782610, 144.782610, 0.000000, 0.000000, '', '', '', NULL, '', '', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012234951100101', 'PO2012231024849995', 1, 'FG002', '盒', 30.00000, 30.00000, NULL, NULL, NULL, 80.00, NULL, 13.00, 4.955752, 148.672566, 19.327434, 168.000000, '', NULL, NULL, NULL, NULL, NULL, 30.00000, NULL, 5.600000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '合格', '合格', NULL);
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012235248539955', NULL, 1, 'FG002', '盒', 100.00000, 100.00000, 0.00000, 0.00000, '', 60.00, '20201223', 13.00, 3.716814, 371.681416, 48.318584, 420.000000, '', 0.00000, '', '', '', '', 100.00000, 7.000000, 4.200000, '20201222', '2020-12-22 00:00:00', '2020-12-22 00:00:00', -371.681400, -371.681400, 10.000000, 12.000000, '', '', '', NULL, '合格', '隔离', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012235248539955', NULL, 2, 'GD0022', '盒', 1000.00000, 300.00000, 0.00000, 0.00000, '', 50.00, '2020120101', 17.00, 4.230769, 1269.230769, 215.769231, 1485.000000, '', 0.00000, '', '00001', '', 'XS20201223135359', 300.00000, 9.900000, 4.950000, '20201223', '2020-12-23 00:00:00', '2021-12-23 00:00:00', -1269.230700, -1269.230700, 12.000000, 14.000000, '20201223-11', '20201223-22', '', NULL, '质量抽样', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012035048564810', NULL, 1, 'FG001', '盒', 20.00000, 20.00000, 0.00000, 0.00000, '', 68.00, '', 13.00, 3.008850, 60.176991, 7.823009, 68.000000, '', 0.00000, '', '', '', '', 20.00000, 5.000000, 3.400000, '20201223', '2020-12-23 00:00:00', '2020-12-23 00:00:00', -60.177000, -60.177000, 6.000000, 8.000000, '', '', '', NULL, '合格', '合格', '');
INSERT INTO `qfyu_purchase_register_details` VALUES ('PC2012035048564810', NULL, 2, 'FG002', '盒', 30.00000, 30.00000, 0.00000, 0.00000, '', 50.00, '', 13.00, 3.097345, 92.920354, 12.079646, 105.000000, '', 0.00000, '', '', '', '', 30.00000, 7.000000, 3.500000, '20201224', '2020-12-24 00:00:00', '2020-12-24 00:00:00', -92.920350, -92.920350, 0.000000, 0.000000, '', '', '', NULL, NULL, NULL, '');

-- ----------------------------
-- Table structure for qfyu_purchase_settle
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_settle`;
CREATE TABLE `qfyu_purchase_settle`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '结算单号',
  `reforderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '送货单号',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `sales_deptid` int(10) NOT NULL COMMENT '业务部门ID',
  `settle_date` date NULL DEFAULT NULL COMMENT '结算日期',
  `paymode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '结算方式',
  `sup_sell` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售人员',
  `sup_contact` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方联系人',
  `emp_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人',
  `emp_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人姓名',
  `invoice_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发票类型',
  `invoice_date` date NULL DEFAULT NULL COMMENT '发票时间',
  `company_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票抬头',
  `invoice_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票号码',
  `invoice_trackno` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票轨号',
  `telephone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票电话',
  `invoice_amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '发票金额',
  `invoice_address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票地址',
  `goods_qty` decimal(16, 5) NOT NULL COMMENT '商品总数',
  `goods_sum` decimal(16, 6) NOT NULL COMMENT '货款',
  `taxsum` decimal(16, 6) NOT NULL COMMENT '税额',
  `amount` decimal(16, 6) NOT NULL COMMENT '合计总额',
  `orig_amount` decimal(16, 6) NOT NULL COMMENT '送货金额',
  `account_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商账号',
  `tax_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商税号',
  `bank_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `proof_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证号',
  `stock_amount` decimal(16, 6) UNSIGNED NOT NULL COMMENT '入库金额',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `makeup_amount` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '退补合计金额',
  `ischeck` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否审核 1已审核',
  `istrans` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否已转单 1已转单',
  `check_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `creater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后一次更新人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '最后更新时间',
  `dept_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '资源所属部门',
  PRIMARY KEY (`orderid`) USING BTREE,
  UNIQUE INDEX `reforderid`(`reforderid`) USING BTREE,
  INDEX `sup_code`(`sup_code`) USING BTREE,
  INDEX `sales_deptid`(`sales_deptid`) USING BTREE,
  INDEX `ischeck`(`ischeck`) USING BTREE,
  INDEX `istrans`(`istrans`) USING BTREE,
  INDEX `check_code`(`check_code`) USING BTREE,
  INDEX `creater`(`creater`) USING BTREE,
  INDEX `updator`(`updator`) USING BTREE,
  INDEX `dept_id`(`dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购结算单-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_settle
-- ----------------------------
INSERT INTO `qfyu_purchase_settle` VALUES ('CJ2012199855504897', 'IS2012185348575157', 'FS003', '5535435', 1, '2020-12-19', '', '张三歌', 'zero', '004', '小黄', 0, '2020-12-19', '深圳庆丰裕信息科技有限公司', NULL, NULL, NULL, 535.000000, '企业地址1', 70.00000, 474.826195, 60.173805, 535.000000, 535.000000, '156161', '165111616', '161', NULL, 535.000000, NULL, 0.000000, 0, 0, NULL, NULL, '001', '2020-12-19 10:10:51', '001', '2020-12-19 10:10:51', 1);
INSERT INTO `qfyu_purchase_settle` VALUES ('CJ2012221015252100', 'IS2012211025198485', 'FS003', '5535435', 1, '2020-12-22', '', '张三歌', 'zero', '004', '小黄', 0, '2020-12-22', '深圳庆丰裕信息科技有限公司', NULL, NULL, NULL, 634.000000, '企业地址1', 50.00000, 634.000000, 0.000000, 634.000000, 634.000000, '156161', '165111616', '161', NULL, 634.000000, NULL, 0.000000, 0, 0, NULL, NULL, '001', '2020-12-22 09:57:50', '001', '2020-12-22 09:57:50', 1);
INSERT INTO `qfyu_purchase_settle` VALUES ('CJ2012221025550555', 'IS2012225649975097', 'FS003', '5535435', 1, '2020-12-22', '', '张三歌', 'zero', '004', '小黄', 0, '2020-12-22', '深圳庆丰裕信息科技有限公司', NULL, NULL, NULL, 270.000000, '企业地址1', 30.00000, 238.938060, 31.061940, 270.000000, 270.000000, '156161', '165111616', '161', NULL, 270.000000, NULL, 0.000000, 0, 0, NULL, NULL, '001', '2020-12-22 18:30:23', '001', '2020-12-22 18:30:23', 1);

-- ----------------------------
-- Table structure for qfyu_purchase_settle_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_purchase_settle_details`;
CREATE TABLE `qfyu_purchase_settle_details`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '结算单号',
  `reforderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品入库单号',
  `item_no` int(10) UNSIGNED NOT NULL COMMENT '项次序号',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `giftqty` decimal(16, 5) UNSIGNED NOT NULL DEFAULT 0.00000 COMMENT '赠品数量',
  `qty` decimal(16, 5) UNSIGNED NOT NULL COMMENT '数量',
  `price` decimal(16, 6) UNSIGNED NOT NULL COMMENT '实际单价',
  `settle_price` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '结算单价',
  `taxrate` decimal(6, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '税率%',
  `notax_price` decimal(16, 6) NOT NULL COMMENT '无税单价',
  `goodssum` decimal(16, 6) NOT NULL COMMENT '无税金额',
  `taxsum` decimal(16, 6) NOT NULL COMMENT '税额',
  `amount` decimal(16, 6) NOT NULL COMMENT '合计总额',
  `batchno` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号/序列号',
  `prod_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `updator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '最后一次更新者',
  `update_date` datetime(0) NOT NULL COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `reforderid`(`reforderid`, `item_no`) USING BTREE,
  INDEX `orderid`(`orderid`) USING BTREE,
  INDEX `goods_code`(`goods_code`) USING BTREE,
  INDEX `updator`(`updator`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 91 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '采购结算单-单据详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_purchase_settle_details
-- ----------------------------
INSERT INTO `qfyu_purchase_settle_details` VALUES (80, 'CJ2012199855504897', 'IS2012185348575157', 26, 'FG001', '千克', 0.00000, 15.00000, 5.000000, 10.000000, 17.00, 8.547009, 128.205135, 21.794865, 150.000000, '20201219-001', '2019-10-14', '2022-12-20', NULL, '001', '2020-12-19 10:10:51');
INSERT INTO `qfyu_purchase_settle_details` VALUES (81, 'CJ2012199855504897', 'IS2012185348575157', 27, 'FG002', '盒', 0.00000, 35.00000, 7.000000, 7.000000, 10.00, 6.363636, 222.727260, 22.272740, 245.000000, '20201219-002', '2019-08-20', '2021-12-30', NULL, '001', '2020-12-19 10:10:51');
INSERT INTO `qfyu_purchase_settle_details` VALUES (82, 'CJ2012199855504897', 'IS2012185348575157', 28, 'FG002', '盒', 0.00000, 20.00000, 7.000000, 7.000000, 13.00, 6.194690, 123.893800, 16.106200, 140.000000, '20201219-003', '2019-12-24', '2022-12-22', NULL, '001', '2020-12-19 10:10:51');
INSERT INTO `qfyu_purchase_settle_details` VALUES (87, 'CJ2012221015252100', 'IS2012211025198485', 34, 'FG002', '盒', 0.00000, 50.00000, 12.680000, 12.680000, 0.00, 12.680000, 634.000000, 0.000000, 634.000000, '20201221-001', '2019-06-20', '2022-12-23', NULL, '001', '2020-12-22 09:57:50');
INSERT INTO `qfyu_purchase_settle_details` VALUES (90, 'CJ2012221025550555', 'IS2012225649975097', 35, 'FG002', '盒', 0.00000, 30.00000, 9.000000, 9.000000, 13.00, 7.964602, 238.938060, 31.061940, 270.000000, '20201222-001', '2018-12-05', '2022-12-21', NULL, '001', '2020-12-22 18:30:23');

-- ----------------------------
-- Table structure for qfyu_real_stocktak
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_real_stocktak`;
CREATE TABLE `qfyu_real_stocktak`  (
  `bill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '实物盘点编号',
  `f_date` datetime(0) NULL DEFAULT NULL COMMENT '订单时间',
  `ware_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库编号',
  `empno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '盘点经手人',
  `auditno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `transfer` tinyint(1) NULL DEFAULT 0 COMMENT '是否已审核 1已审核 0未审核',
  `remark` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `pbill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上一步骤单号',
  `sn1` int(10) NULL DEFAULT NULL COMMENT '起始序号',
  `sn2` int(10) NULL DEFAULT NULL COMMENT '结束序号',
  `grup` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源所属组',
  `opkind` int(10) NULL DEFAULT NULL COMMENT '盘点类型 0结存单盘点 2直接实物盘点',
  `creater` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`bill_no`) USING BTREE,
  INDEX `pbill_no`(`pbill_no`) USING BTREE,
  INDEX `sn1`(`sn1`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '实物盘点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_real_stocktak
-- ----------------------------
INSERT INTO `qfyu_real_stocktak` VALUES ('AR2012165097995597', '2020-12-16 10:35:14', 'CK006', '003', NULL, 1, '本单盘点序号区间：1~2', 'AS2012165399975749', 1, 2, '1', 2, '001', '2020-12-16 10:35:14', '001', '2020-12-21 17:48:05');
INSERT INTO `qfyu_real_stocktak` VALUES ('AR2012191009810256', '2020-12-19 17:07:57', 'CK004', '005', '001', 1, '本单盘点序号区间：1~4', 'AS2012191025157100', 1, 4, '1', 2, '001', '2020-12-19 17:07:57', '001', '2020-12-21 10:33:58');
INSERT INTO `qfyu_real_stocktak` VALUES ('AR2012224910248102', '2020-12-22 09:59:13', 'CK003', '001', '001', 1, '本单盘点序号区间：3~3', 'AS2012225610010252', 3, 3, '1', 2, '001', '2020-12-22 09:59:13', '001', '2020-12-22 09:59:39');
INSERT INTO `qfyu_real_stocktak` VALUES ('AR2012235297102579', '2020-12-23 14:09:56', 'CK003', '004', '001', 1, '本单盘点序号区间：1~3', 'AS2012235353545054', 1, 3, '1', 2, '001', '2020-12-23 14:09:56', '001', '2020-12-23 14:11:03');

-- ----------------------------
-- Table structure for qfyu_real_stocktak_detail
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_real_stocktak_detail`;
CREATE TABLE `qfyu_real_stocktak_detail`  (
  `bill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '盘点单编号',
  `item_no` int(10) NULL DEFAULT NULL COMMENT '序号',
  `goods_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编号',
  `pos_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位编号',
  `sup_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '批次号',
  `pro_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期',
  `qty1` decimal(15, 5) NULL DEFAULT NULL COMMENT '主单位库存',
  `qty2` decimal(15, 5) NULL DEFAULT NULL COMMENT '辅单位库存',
  `price1` decimal(16, 6) NULL DEFAULT NULL COMMENT '主单位价格',
  `price2` decimal(16, 6) NULL DEFAULT NULL COMMENT '辅单位价格',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '库存总价值',
  `rqty1` decimal(15, 5) NULL DEFAULT NULL COMMENT '主单位实际库存',
  `rqty2` decimal(15, 5) NULL DEFAULT NULL COMMENT '辅单位实际库存',
  `ramount` decimal(16, 6) NULL DEFAULT NULL COMMENT '实际库存总价值',
  `diffqty1` decimal(15, 5) NULL DEFAULT NULL COMMENT '主单位库存差值',
  `diffqty2` decimal(15, 5) NULL DEFAULT NULL COMMENT '辅单位库存差值',
  `diffamount` decimal(16, 6) NULL DEFAULT NULL COMMENT '总价值差值',
  `selprice` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考批发价',
  `rtlprice` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考零售价',
  `pbill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上一步骤编号',
  `pitem_no` int(10) NULL DEFAULT NULL COMMENT '对应上一步骤序号',
  `stock_id` int(10) NULL DEFAULT NULL COMMENT '库存详情表id',
  `update_ver` bigint(10) NULL DEFAULT NULL COMMENT '防止详情未修改保存失败',
  UNIQUE INDEX `bill_no_2`(`bill_no`, `item_no`) USING BTREE,
  INDEX `bill_no`(`bill_no`) USING BTREE,
  INDEX `pbill_no`(`pbill_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '实物盘点详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_real_stocktak_detail
-- ----------------------------
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012165097995597', 1, 'FG001', 'WP007', 'FS003', '20200628', '2020-06-28', '2022-12-06', 30.00000, 30.00000, 25.000000, 25.000000, 750.000000, 3.00000, NULL, 75.000000, -27.00000, NULL, -675.000000, 6.000000, 7.000000, 'AS2012165399975749', 1, 107, 1608544085);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012165097995597', 2, 'FG001', 'WP007', 'FS003', '20201004', '2020-10-04', '2022-11-21', 30.00000, 30.00000, 30.000000, 30.000000, 900.000000, 5.00000, NULL, 150.000000, -25.00000, NULL, -750.000000, 6.000000, 7.000000, 'AS2012165399975749', 2, 108, 1608544085);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012191009810256', 1, 'FG001', 'WP0010', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 15.00000, 15.00000, 10.000000, 5.000000, 150.000000, 0.00000, NULL, 0.000000, -15.00000, NULL, -150.000000, 6.000000, 7.000000, 'AS2012191025157100', 1, 122, 1608518038);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012191009810256', 2, 'FG002', 'WP0010', 'FS003', '20201219-002', '2019-08-20', '2021-12-30', 35.00000, 35.00000, 7.000000, 0.000000, 245.000000, 0.00000, NULL, 0.000000, -35.00000, NULL, -245.000000, 9.000000, NULL, 'AS2012191025157100', 2, 123, 1608518038);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012191009810256', 3, 'FG002', 'WP0010', 'FS003', '20201219-003', '2019-12-24', '2022-12-22', 20.00000, 20.00000, 7.000000, 0.000000, 140.000000, 0.00000, NULL, 0.000000, -20.00000, NULL, -140.000000, 9.000000, NULL, 'AS2012191025157100', 3, 124, 1608518038);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012191009810256', 4, 'FG001', 'WP0010', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 12.25000, 12.00000, 21.600000, 10.800000, 264.600000, 0.00000, NULL, 0.000000, -12.25000, NULL, -264.600000, 6.000000, 7.000000, 'AS2012191025157100', 4, 153, 1608518038);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012191009810256', 5, 'FG001', 'WP0010', '', '1122', '2020-12-21', NULL, NULL, NULL, 0.000000, NULL, NULL, 0.00000, NULL, 0.000000, 0.00000, NULL, 0.000000, 6.000000, 7.000000, NULL, NULL, 0, 1608518038);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012224910248102', 1, 'FG002', 'WP0011', 'FS003', '20201221-001', '2019-06-20', '2022-12-23', 50.00000, 50.00000, 12.680000, 0.000000, 634.000000, 48.00000, NULL, 608.640000, -2.00000, NULL, -25.360000, 9.000000, NULL, 'AS2012225610010252', 3, 164, 1608602379);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012235297102579', 1, 'FG001', 'WP0011', 'FS003', '20201219-001', '2019-10-14', '2022-12-20', 17.87500, 17.00000, 13.600000, 6.800000, 243.100000, 17.87500, NULL, 243.100000, 0.00000, NULL, 0.000000, 6.000000, 7.000000, 'AS2012235353545054', 1, 125, 1608703863);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012235297102579', 2, 'FG002', 'WP0011', 'FS003', '20201219-8888', '2018-12-20', '2022-12-20', 50.00000, 50.00000, 5.780000, 0.000000, 289.000000, 50.00000, NULL, 289.000000, 0.00000, NULL, 0.000000, 9.000000, NULL, 'AS2012235353545054', 2, 126, 1608703863);
INSERT INTO `qfyu_real_stocktak_detail` VALUES ('AR2012235297102579', 3, 'FG002', 'WP0011', 'FS003', '20201221-001', '2019-06-20', '2022-12-23', 48.00000, 48.00000, 12.680000, 0.000000, 608.640000, 48.00000, NULL, 608.640000, 0.00000, NULL, 0.000000, 9.000000, NULL, 'AS2012235353545054', 3, 164, 1608703863);

-- ----------------------------
-- Table structure for qfyu_role
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_role`;
CREATE TABLE `qfyu_role`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `power_ids` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '拥有权限',
  `create_time` int(10) NOT NULL COMMENT '创建时间',
  `re_time` int(10) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_role
-- ----------------------------
INSERT INTO `qfyu_role` VALUES (1, '超级管理员', 'a:9:{i:0;a:1:{i:0;a:19:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";i:17;s:2:\"18\";i:18;s:2:\"20\";}}i:1;a:3:{i:9;a:6:{i:0;s:2:\"10\";i:1;s:2:\"11\";i:2;s:2:\"18\";i:3;s:2:\"22\";i:4;s:2:\"28\";i:5;s:3:\"130\";}i:12;a:0:{}i:242;a:1:{i:0;s:3:\"243\";}}i:2;a:11:{i:13;a:3:{i:0;s:2:\"17\";i:1;s:2:\"26\";i:2;s:2:\"27\";}i:14;a:3:{i:0;s:2:\"15\";i:1;s:2:\"16\";i:2;s:2:\"19\";}i:29;a:11:{i:0;s:2:\"30\";i:1;s:2:\"37\";i:2;s:2:\"61\";i:3;s:2:\"87\";i:4;s:2:\"93\";i:5;s:2:\"95\";i:6;s:2:\"98\";i:7;s:2:\"99\";i:8;s:3:\"100\";i:9;s:3:\"102\";i:10;s:3:\"104\";}i:31;a:3:{i:0;s:2:\"32\";i:1;s:2:\"51\";i:2;s:2:\"52\";}i:36;a:0:{}i:48;a:7:{i:0;s:2:\"49\";i:1;s:2:\"59\";i:2;s:2:\"62\";i:3;s:2:\"67\";i:4;s:3:\"122\";i:5;s:3:\"181\";i:6;s:3:\"240\";}i:54;a:27:{i:0;s:2:\"55\";i:1;s:2:\"56\";i:2;s:2:\"60\";i:3;s:2:\"75\";i:4;s:2:\"78\";i:5;s:2:\"80\";i:6;s:2:\"82\";i:7;s:2:\"84\";i:8;s:2:\"86\";i:9;s:3:\"195\";i:10;s:3:\"203\";i:11;s:3:\"204\";i:12;s:3:\"205\";i:13;s:3:\"229\";i:14;s:3:\"230\";i:15;s:3:\"232\";i:16;s:3:\"233\";i:17;s:3:\"239\";i:18;s:3:\"241\";i:19;s:3:\"244\";i:20;s:3:\"250\";i:21;s:3:\"251\";i:22;s:3:\"252\";i:23;s:3:\"253\";i:24;s:3:\"255\";i:25;s:3:\"276\";i:26;s:3:\"277\";}i:57;a:6:{i:0;s:2:\"58\";i:1;s:2:\"69\";i:2;s:3:\"117\";i:3;s:3:\"118\";i:4;s:3:\"137\";i:5;s:3:\"159\";}i:63;a:16:{i:0;s:2:\"64\";i:1;s:3:\"110\";i:2;s:3:\"111\";i:3;s:3:\"112\";i:4;s:3:\"161\";i:5;s:3:\"162\";i:6;s:3:\"170\";i:7;s:3:\"171\";i:8;s:3:\"174\";i:9;s:3:\"175\";i:10;s:3:\"189\";i:11;s:3:\"190\";i:12;s:3:\"245\";i:13;s:3:\"246\";i:14;s:3:\"248\";i:15;s:3:\"249\";}i:65;a:2:{i:0;s:2:\"66\";i:1;s:2:\"68\";}i:235;a:2:{i:0;s:3:\"236\";i:1;s:3:\"238\";}}i:3;a:8:{i:71;a:7:{i:0;s:2:\"85\";i:1;s:2:\"88\";i:2;s:2:\"89\";i:3;s:2:\"90\";i:4;s:2:\"91\";i:5;s:2:\"92\";i:6;s:2:\"94\";}i:106;a:6:{i:0;s:3:\"107\";i:1;s:3:\"109\";i:2;s:3:\"113\";i:3;s:3:\"114\";i:4;s:3:\"115\";i:5;s:3:\"116\";}i:119;a:7:{i:0;s:3:\"120\";i:1;s:3:\"121\";i:2;s:3:\"135\";i:3;s:3:\"140\";i:4;s:3:\"143\";i:5;s:3:\"146\";i:6;s:3:\"274\";}i:123;a:2:{i:0;s:3:\"128\";i:1;s:3:\"129\";}i:131;a:7:{i:0;s:3:\"133\";i:1;s:3:\"134\";i:2;s:3:\"149\";i:3;s:3:\"150\";i:4;s:3:\"151\";i:5;s:3:\"152\";i:6;s:3:\"153\";}i:154;a:4:{i:0;s:3:\"164\";i:1;s:3:\"168\";i:2;s:3:\"210\";i:3;s:3:\"214\";}i:155;a:2:{i:0;s:3:\"157\";i:1;s:3:\"158\";}i:176;a:2:{i:0;s:3:\"177\";i:1;s:3:\"179\";}}i:4;a:4:{i:166;a:1:{i:0;s:3:\"178\";}i:191;a:6:{i:0;s:3:\"192\";i:1;s:3:\"199\";i:2;s:3:\"202\";i:3;s:3:\"207\";i:4;s:3:\"208\";i:5;s:3:\"212\";}i:215;a:5:{i:0;s:3:\"216\";i:1;s:3:\"217\";i:2;s:3:\"223\";i:3;s:3:\"224\";i:4;s:3:\"225\";}i:257;a:3:{i:0;s:3:\"258\";i:1;s:3:\"259\";i:2;s:3:\"262\";}}i:5;a:2:{i:183;a:5:{i:0;s:3:\"184\";i:1;s:3:\"186\";i:2;s:3:\"187\";i:3;s:3:\"188\";i:4;s:3:\"201\";}i:193;a:17:{i:0;s:3:\"194\";i:1;s:3:\"206\";i:2;s:3:\"209\";i:3;s:3:\"211\";i:4;s:3:\"213\";i:5;s:3:\"222\";i:6;s:3:\"226\";i:7;s:3:\"227\";i:8;s:3:\"231\";i:9;s:3:\"234\";i:10;s:3:\"237\";i:11;s:3:\"254\";i:12;s:3:\"263\";i:13;s:3:\"266\";i:14;s:3:\"273\";i:15;s:3:\"275\";i:16;s:3:\"285\";}}i:6;a:283:{i:0;N;i:1;N;i:2;N;i:3;N;i:4;N;i:5;N;i:6;N;i:7;N;i:8;N;i:9;N;i:10;N;i:11;N;i:12;N;i:13;N;i:14;N;i:15;N;i:16;N;i:17;N;i:18;N;i:19;N;i:20;N;i:21;N;i:22;N;i:23;N;i:24;N;i:25;N;i:26;N;i:27;N;i:28;N;i:29;N;i:30;N;i:31;N;i:32;N;i:33;N;i:34;N;i:35;N;i:36;N;i:37;N;i:38;N;i:39;N;i:40;N;i:41;N;i:42;N;i:43;N;i:44;N;i:45;N;i:46;N;i:47;N;i:48;N;i:49;N;i:50;N;i:51;N;i:52;N;i:53;N;i:54;N;i:55;N;i:56;N;i:57;N;i:58;N;i:59;N;i:60;N;i:61;N;i:62;N;i:63;N;i:64;N;i:65;N;i:66;N;i:67;N;i:68;N;i:69;N;i:70;N;i:71;N;i:72;N;i:73;N;i:74;N;i:75;N;i:76;N;i:77;N;i:78;N;i:79;N;i:80;N;i:81;N;i:82;N;i:83;N;i:84;N;i:85;N;i:86;N;i:87;N;i:88;N;i:89;N;i:90;N;i:91;N;i:92;N;i:93;N;i:94;N;i:95;N;i:96;N;i:97;N;i:98;N;i:99;N;i:100;N;i:101;N;i:102;N;i:103;N;i:104;N;i:105;N;i:106;N;i:107;N;i:108;N;i:109;N;i:110;N;i:111;N;i:112;N;i:113;N;i:114;N;i:115;N;i:116;N;i:117;N;i:118;N;i:119;N;i:120;N;i:121;N;i:122;N;i:123;N;i:124;N;i:125;N;i:126;N;i:127;N;i:128;N;i:129;N;i:130;N;i:131;N;i:132;N;i:133;N;i:134;N;i:135;N;i:136;N;i:137;N;i:138;N;i:139;N;i:140;N;i:141;N;i:142;N;i:143;N;i:144;N;i:145;N;i:146;N;i:147;N;i:148;N;i:149;N;i:150;N;i:151;N;i:152;N;i:153;N;i:154;N;i:155;N;i:156;N;i:157;N;i:158;N;i:159;N;i:160;N;i:161;N;i:162;N;i:163;N;i:164;N;i:165;N;i:166;N;i:167;N;i:168;N;i:169;N;i:170;N;i:171;N;i:172;N;i:173;N;i:174;N;i:175;N;i:176;N;i:177;N;i:178;N;i:179;N;i:180;N;i:181;N;i:182;N;i:183;N;i:184;N;i:185;N;i:186;N;i:187;N;i:188;N;i:189;N;i:190;N;i:191;N;i:192;N;i:193;N;i:194;N;i:195;N;i:196;N;i:197;N;i:198;N;i:199;N;i:200;N;i:201;N;i:202;N;i:203;N;i:204;N;i:205;N;i:206;N;i:207;N;i:208;N;i:209;N;i:210;N;i:211;N;i:212;N;i:213;N;i:214;N;i:215;N;i:216;N;i:217;N;i:218;N;i:219;N;i:220;N;i:221;N;i:222;N;i:223;N;i:224;N;i:225;N;i:226;N;i:227;N;i:228;N;i:229;N;i:230;N;i:231;N;i:232;N;i:233;N;i:234;N;i:235;N;i:236;N;i:237;N;i:238;N;i:239;N;i:240;N;i:241;N;i:242;N;i:243;N;i:244;N;i:245;N;i:246;N;i:247;N;i:248;N;i:249;N;i:250;N;i:251;N;i:252;N;i:253;N;i:254;N;i:255;N;i:256;N;i:257;N;i:258;N;i:259;N;i:260;N;i:261;N;i:262;N;i:263;N;i:264;N;i:265;N;i:266;N;i:267;N;i:268;N;i:269;N;i:270;N;i:271;N;i:272;N;i:273;N;i:274;N;i:275;N;i:276;N;i:277;N;i:278;N;i:279;N;i:280;N;i:281;N;i:282;a:2:{i:0;s:3:\"283\";i:1;s:3:\"284\";}}i:7;a:0:{}i:8;a:2:{i:20;a:8:{i:0;s:2:\"21\";i:1;s:2:\"23\";i:2;s:2:\"38\";i:3;s:2:\"41\";i:4;s:2:\"43\";i:5;s:2:\"44\";i:6;s:2:\"46\";i:7;s:3:\"198\";}i:33;a:7:{i:0;s:2:\"34\";i:1;s:2:\"39\";i:2;s:2:\"40\";i:3;s:2:\"42\";i:4;s:2:\"45\";i:5;s:2:\"47\";i:6;s:2:\"50\";}}}', 1600333240, 1608807064);
INSERT INTO `qfyu_role` VALUES (2, '拣货员', '', 1600500689, 1601029796);
INSERT INTO `qfyu_role` VALUES (4, '质量管理员', '', 1600500755, 1600839832);
INSERT INTO `qfyu_role` VALUES (5, '质管部经理', '', 1600500873, 1605665630);
INSERT INTO `qfyu_role` VALUES (6, '验收员', '', 1600500908, 1600830126);
INSERT INTO `qfyu_role` VALUES (7, '管理员', 'a:9:{i:0;a:1:{i:0;a:17:{i:0;s:1:\"1\";i:1;s:1:\"2\";i:2;s:1:\"3\";i:3;s:1:\"4\";i:4;s:1:\"5\";i:5;s:1:\"6\";i:6;s:1:\"7\";i:7;s:1:\"8\";i:8;s:1:\"9\";i:9;s:2:\"10\";i:10;s:2:\"11\";i:11;s:2:\"12\";i:12;s:2:\"13\";i:13;s:2:\"14\";i:14;s:2:\"15\";i:15;s:2:\"16\";i:16;s:2:\"17\";}}i:1;a:2:{i:9;a:0:{}i:12;a:0:{}}i:2;a:10:{i:13;a:0:{}i:14;a:0:{}i:29;a:0:{}i:31;a:0:{}i:36;a:0:{}i:48;a:0:{}i:54;a:0:{}i:57;a:0:{}i:63;a:0:{}i:65;a:0:{}}i:3;a:4:{i:71;a:0:{}i:106;a:0:{}i:119;a:0:{}i:123;a:0:{}}i:4;a:0:{}i:5;a:0:{}i:6;a:0:{}i:7;a:0:{}i:8;a:2:{i:20;a:0:{}i:33;a:0:{}}}', 1600500994, 1606352228);
INSERT INTO `qfyu_role` VALUES (8, '打单员', NULL, 1600501069, 1600501069);
INSERT INTO `qfyu_role` VALUES (10, '送货员', NULL, 1600501574, 1600501574);

-- ----------------------------
-- Table structure for qfyu_sales_contract
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sales_contract`;
CREATE TABLE `qfyu_sales_contract`  (
  `contract_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '合同号',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '合同标题',
  `cust_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `cust_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户名称',
  `delivery` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货地点',
  `sign_date` date NULL DEFAULT NULL COMMENT '签约日期',
  `sign_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '签约人',
  `sign_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '签约人姓名',
  `start_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `validity_date` date NULL DEFAULT NULL COMMENT '失效日期',
  `settlement` char(6) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式',
  `pay_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `sign_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '签约地点',
  `explain` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `file_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同文件路径',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改者',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  `dept_id` int(10) NULL DEFAULT NULL COMMENT '所属部门',
  `dept_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  PRIMARY KEY (`contract_no`) USING BTREE,
  INDEX `cust_code`(`cust_code`) USING BTREE,
  INDEX `sign_code`(`sign_code`) USING BTREE,
  INDEX `settlement`(`settlement`) USING BTREE,
  INDEX `creator`(`creator`) USING BTREE,
  INDEX `updator`(`updater`) USING BTREE,
  CONSTRAINT `qfyu_sales_contract_ibfk_1` FOREIGN KEY (`cust_code`) REFERENCES `qfyu_customer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售合同' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sales_contract
-- ----------------------------
INSERT INTO `qfyu_sales_contract` VALUES ('XH2012041001014910', '深圳医药购销合同', 'CR0005', '深圳同心泰药业有限公司', '', NULL, '003', '小米', '2020-12-17', '2020-12-17', 'JS003', NULL, '', '', '/uploads/sales_contract/XH2012041001014910/优化反馈_0224bd5f15536644e9db4a1092b28dc3.docx', '001', '2020-12-04 15:22:37', '001', '2020-12-07 19:08:57', 1, '深圳总部');
INSERT INTO `qfyu_sales_contract` VALUES ('XH2012041005010255', '恶64363', 'CR0003', '惠州市家之和药业有限公司', '深圳龙华', '2020-12-19', '005', '小明', '2019-12-04', '2021-01-09', 'JS004', '2021-01-09', '深圳龙华', '社交高房价四大皆空光标的发窘【个空间大富科技欧股份公交', '/uploads/sales_contract/XH2012041005010255/优化反馈_0224bd5f15536644e9db4a1092b28dc3.docx', '001', '2020-12-04 11:34:21', '001', '2020-12-07 19:09:01', 1, '深圳总部');
INSERT INTO `qfyu_sales_contract` VALUES ('XH2012049749495457', '恶64363', 'CR0003', '惠州市家之和药业有限公司', '', '2020-12-19', '005', '小明', '2028-09-23', '2020-12-31', 'JS003', '2021-01-09', '', '', '/uploads/sales_contract/XH2012049749495457/零售方案_4aee7a8ffc03e2cf37e772ba22564906.docx', '001', '2020-12-04 11:35:22', '001', '2020-12-07 18:59:46', 1, '深圳总部');
INSERT INTO `qfyu_sales_contract` VALUES ('XH2012049755525348', 'dsdjkfdfjk', 'CR008', '庆丰裕测试新增', '', NULL, '004', '小黄', '2021-02-03', NULL, 'JS003', NULL, '', '', '/uploads/sales_contract/XH2012049755525348/零售方案_4aee7a8ffc03e2cf37e772ba22564906.docx', '001', '2020-12-04 13:41:14', '001', '2020-12-07 18:59:57', 1, '深圳总部');

-- ----------------------------
-- Table structure for qfyu_sel_export
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_export`;
CREATE TABLE `qfyu_sel_export`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单编号',
  `f_date` date NOT NULL COMMENT '创建日期',
  `in_out_kind` smallint(6) NOT NULL COMMENT '销售方式',
  `order_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源订单号',
  `contract_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同号',
  `emp_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编号',
  `cust_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `link_man` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `goods_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '货品总数',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `tax_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '总计',
  `pay_mode_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `pay_date` date NULL DEFAULT NULL COMMENT '支付日期',
  `need_deliver` tinyint(1) NOT NULL DEFAULT 0 COMMENT '需要送货',
  `fungible` tinyint(1) NOT NULL DEFAULT 0 COMMENT '代销发货',
  `audit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员',
  `audit_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `is_transfer` tinyint(1) NOT NULL DEFAULT 0 COMMENT '过账',
  `is_finish` tinyint(1) NULL DEFAULT 0 COMMENT '完结',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `print_count` smallint(6) NULL DEFAULT NULL COMMENT '打印次数',
  `creater` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `mender` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新日期',
  `dept_id` int(11) NOT NULL COMMENT '开单部门',
  `rec_no` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '流水号',
  `ref_cost` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考成本',
  `ref_profit` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考毛利',
  `ref_profit_rate` decimal(4, 2) NULL DEFAULT NULL COMMENT '参考毛利率',
  `up_amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '退补差价合计',
  `pick_addr` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地址',
  `is_reject` tinyint(1) NULL DEFAULT 0 COMMENT '不合格品标志',
  `contacts` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `deliver_kind` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发货方式',
  `deliver_level` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发货级别',
  `pri_deliver_cause` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '优先发货原因',
  `deliver_line` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货线路',
  `pc_order_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来货登记单号',
  `pack_qty` int(11) NULL DEFAULT NULL COMMENT '货物件数',
  `pack_worker` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '装箱人',
  `pick_worker` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拣货人',
  `express_corp` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流公司',
  `express_no` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物流单号',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售开单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_export
-- ----------------------------
INSERT INTO `qfyu_sel_export` VALUES ('SE2012224850515510', '2020-12-22', 51, 'SO2012215556495456', NULL, '001', 'CR0002', '姚总1', 67.87500, 596.082471, 94.067529, 690.150000, NULL, NULL, 0, 0, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-22 17:08:32', NULL, NULL, 1, '2012220001', 121.550000, 474.532470, NULL, NULL, NULL, 0, NULL, NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_export` VALUES ('SE2012235654515156', '2020-12-23', 51, 'SO2012215210250525', NULL, '001', 'CR0002', '姚总1', 12.00000, 91.664170, 13.935830, 105.600000, NULL, NULL, 0, 0, '001', '2020-12-24 11:47:14', 1, 0, NULL, NULL, '001', '2020-12-23 20:04:08', NULL, NULL, 1, '2012230001', 68.000000, 23.664170, 0.26, NULL, NULL, 0, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_sel_export_dtl
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_export_dtl`;
CREATE TABLE `qfyu_sel_export_dtl`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单编号',
  `item_no` int(11) NOT NULL COMMENT '项次',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品编号',
  `unit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '数量',
  `o_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '单价',
  `rebate` decimal(8, 2) NULL DEFAULT NULL COMMENT '折扣',
  `price` decimal(16, 6) NULL DEFAULT NULL COMMENT '实际单价',
  `tax_rate` decimal(6, 2) NULL DEFAULT NULL COMMENT '税率',
  `un_tax_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '无税单价',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `tax_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '总价',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状况',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '批号',
  `prod_date` datetime(0) NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期至',
  `prov_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `ware_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库编号',
  `pos_code` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位',
  `p_order_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应单号',
  `p_item_no` int(11) NULL DEFAULT NULL COMMENT '对应项次',
  `cust_goods_code` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方产品编号',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `order_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '订货数量',
  `paid_up` decimal(16, 5) NULL DEFAULT NULL COMMENT '已发数量',
  `ret_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '退回数量',
  `settle_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '已结算数量',
  `ref_cost_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考成本价',
  `ref_cost` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考成本',
  `ref_profit_rate` decimal(4, 2) NULL DEFAULT NULL COMMENT '参考毛利率',
  `ref_profit` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考毛利',
  `makeupfor_amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '退补差价合计',
  `makeupfor_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '退补差价',
  `whole_qty` int(11) NULL DEFAULT NULL COMMENT '整件数量',
  `bulk_qty` int(11) NULL DEFAULT NULL COMMENT '散装数量',
  `spf_lag` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '特价标志',
  `gift_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '赠送数量',
  `std_rtl_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '标准零售价',
  `th_order_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退货登记单号',
  `th_item_no` int(11) NULL DEFAULT NULL COMMENT '退货登记单项次',
  `reason_return` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '退货原因',
  `trace_back_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追溯号',
  `germicidal_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `goods_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货品状态',
  PRIMARY KEY (`orderid`, `item_no`) USING BTREE,
  INDEX `goods_code`(`goods_code`) USING BTREE,
  CONSTRAINT `qfyu_sel_export_dtl_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `qfyu_sel_export` (`orderid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售开单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_export_dtl
-- ----------------------------
INSERT INTO `qfyu_sel_export_dtl` VALUES ('SE2012224850515510', 1, 'FG001', '盒', 17.87500, 8.400000, NULL, 8.400000, 15.00, 7.304348, 130.565221, 19.584779, 150.150000, NULL, '20201219-001', '2019-10-14 00:00:00', '2022-12-20 00:00:00', NULL, NULL, NULL, 'SO2012215556495456', 1, NULL, NULL, NULL, NULL, NULL, NULL, 6.800000, 121.550000, 0.07, 9.015221, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_export_dtl` VALUES ('SE2012224850515510', 2, 'FG002', '盒', 48.00000, 10.800000, NULL, 10.800000, 16.00, 9.310345, 446.896560, 71.503440, 518.400000, NULL, '20201221-001', '2019-06-20 00:00:00', '2022-12-23 00:00:00', NULL, NULL, NULL, 'SO2012215556495456', 2, NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 1.00, 446.896560, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_export_dtl` VALUES ('SE2012224850515510', 3, 'FG002', '盒', 2.00000, 10.800000, NULL, 10.800000, 16.00, 9.310345, 18.620690, 2.979310, 21.600000, NULL, '20201219-8888', '2018-12-20 00:00:00', '2022-12-20 00:00:00', NULL, NULL, NULL, 'SO2012215556495456', 2, NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 1.00, 18.620690, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_export_dtl` VALUES ('SE2012235654515156', 1, 'FG001', '盒', 10.00000, 8.400000, NULL, 8.400000, 15.00, 7.304348, 73.043480, 10.956520, 84.000000, NULL, '20201219-001', '2019-10-14 00:00:00', '2022-12-20 00:00:00', 'FS003', 'CK003', 'WP0011', 'SO2012215210250525', 1, '', NULL, NULL, NULL, NULL, NULL, 6.800000, 68.000000, 0.07, 5.043480, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_export_dtl` VALUES ('SE2012235654515156', 2, 'FG002', '盒', 2.00000, 10.800000, NULL, 10.800000, 16.00, 9.310345, 18.620690, 2.979310, 21.600000, NULL, '20201219-8888', '2018-12-20 00:00:00', '2022-12-20 00:00:00', 'FS003', 'CK003', 'WP0011', 'SO2012215210250525', 2, '', NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 1.00, 18.620690, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_sel_order
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_order`;
CREATE TABLE `qfyu_sel_order`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `f_date` date NOT NULL COMMENT '单据日期（签约日期）',
  `deal_date` date NULL DEFAULT NULL COMMENT '交货时间',
  `sign_addr` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '签约地点',
  `begin_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `end_date` date NULL DEFAULT NULL COMMENT '失效日期',
  `contract_type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同类型',
  `contract_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '合同编号',
  `emp_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编号',
  `audit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核员（复核员）',
  `cust_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `link_man` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购人员',
  `deal_mode` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '交货方式',
  `carr_kind` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输方式',
  `carr_addr` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '运输到站',
  `pick_addr` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货地址',
  `goods_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '货品总数',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `tax_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计',
  `pay_mode_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式',
  `pay_date` datetime(0) NULL DEFAULT NULL COMMENT '付款日期',
  `is_transfer` tinyint(1) NULL DEFAULT 0 COMMENT '过账',
  `is_finish` tinyint(1) NULL DEFAULT 0 COMMENT '完成结案',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `print_num` smallint(6) NULL DEFAULT NULL COMMENT '打印次数',
  `creater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `dept_id` int(11) NOT NULL COMMENT '开单部门',
  `is_pre_pay` tinyint(4) NULL DEFAULT NULL COMMENT '是否收取预付款',
  `pre_pay` decimal(16, 6) NULL DEFAULT NULL COMMENT '预付款',
  `net_order_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '网上订单编号',
  `contacts` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `dcc_ustno` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '直调客户编号',
  `deliver_level` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '正常发货' COMMENT '发货级别',
  `pri_deliver_cause` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '优先发货原因',
  `deliver_line` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '送货路线',
  `deliver_kind` varchar(12) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发货方式',
  `fungible` tinyint(1) NULL DEFAULT 0 COMMENT '代销发货',
  `need_deliver` tinyint(1) NULL DEFAULT 0 COMMENT '需要送货',
  `ref_cost` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考成本价',
  `ref_profit` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考毛利',
  `is_pass_on` tinyint(1) NULL DEFAULT 0 COMMENT '转单标志',
  PRIMARY KEY (`orderid`) USING BTREE,
  INDEX `emp_no`(`emp_no`) USING BTREE,
  CONSTRAINT `qfyu_sel_order_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `qfyu_employee` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_order
-- ----------------------------
INSERT INTO `qfyu_sel_order` VALUES ('SO2012121015153504', '2020-12-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 18.00000, 143.709400, 12.530600, 156.240000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-12 19:21:18', '001', '2020-12-12 19:21:18', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012121015410251', '2020-12-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 18.00000, 143.709400, 12.530600, 156.240000, NULL, NULL, 0, 0, NULL, NULL, '002', '2020-12-12 19:22:22', '001', '2020-12-16 14:17:09', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012121029899529', '2020-12-12', NULL, NULL, NULL, NULL, NULL, NULL, '006', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 28.00000, 174.081080, 16.478920, 190.560000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-12 19:51:27', '001', '2020-12-18 17:19:05', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012125455975110', '2020-12-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 18.00000, 143.709400, 12.530600, 156.240000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-12 19:20:54', '001', '2020-12-12 19:20:54', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012125457495151', '2020-12-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 18.00000, 143.709400, 12.530600, 156.240000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-12 19:23:34', '001', '2020-12-12 19:23:34', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012129950564854', '2020-12-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 18.00000, 143.709400, 12.530600, 156.240000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-12 19:23:08', '001', '2020-12-12 19:23:08', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012161005651555', '2020-12-16', NULL, NULL, NULL, NULL, NULL, NULL, '006', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 28.00000, 174.081080, 16.478920, 190.560000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-16 17:24:13', '001', '2020-12-16 17:24:13', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012165355515254', '2020-12-16', NULL, NULL, NULL, NULL, NULL, NULL, '006', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 28.00000, 174.081080, 16.478920, 190.560000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-16 17:25:41', '001', '2020-12-16 17:25:41', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012169953100569', '2020-12-16', NULL, NULL, NULL, NULL, NULL, NULL, '006', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 28.00000, 174.081080, 16.478920, 190.560000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-16 17:24:44', '001', '2020-12-16 17:24:44', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012184810110253', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 19:55:12', '001', '2020-12-18 19:55:12', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012184848100505', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 19:57:36', '001', '2020-12-18 19:57:36', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012184999102984', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 19:53:53', '001', '2020-12-18 19:53:53', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012185349545651', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 19:58:29', '001', '2020-12-21 10:08:40', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, 0);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012185450481025', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 17:21:42', '001', '2020-12-18 17:21:42', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012189850100524', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 19:54:03', '001', '2020-12-18 19:54:03', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012189948991024', '2020-12-18', NULL, NULL, NULL, NULL, NULL, NULL, '003', NULL, 'CR0001', 'vr', NULL, NULL, NULL, NULL, 78.00000, 1745.401164, 114.998836, 1860.400000, NULL, NULL, 0, 0, NULL, NULL, '001', '2020-12-18 19:57:00', '001', '2020-12-18 19:57:00', 1, NULL, NULL, NULL, 'fdsf', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012215210250525', '2020-12-21', NULL, NULL, NULL, NULL, NULL, NULL, '001', '001', 'CR0002', '姚总1', NULL, NULL, NULL, NULL, 12.00000, 91.664170, 13.935830, 105.600000, NULL, NULL, 1, 0, NULL, NULL, '001', '2020-12-21 11:36:05', '001', '2020-12-21 16:28:51', 1, NULL, NULL, NULL, '', NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, 1);
INSERT INTO `qfyu_sel_order` VALUES ('SO2012215556495456', '2020-12-21', NULL, NULL, NULL, NULL, NULL, NULL, '001', '001', 'CR0002', '姚总1', NULL, NULL, NULL, NULL, 100.00000, 830.734650, 129.265350, 960.000000, NULL, NULL, 1, 0, NULL, NULL, '001', '2020-12-21 17:18:31', '001', '2020-12-21 17:18:37', 1, NULL, NULL, NULL, NULL, NULL, '正常发货', NULL, NULL, NULL, 0, 0, NULL, NULL, 1);

-- ----------------------------
-- Table structure for qfyu_sel_order_dtl
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_order_dtl`;
CREATE TABLE `qfyu_sel_order_dtl`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单编号',
  `item_no` smallint(6) NOT NULL COMMENT '项次',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品编号',
  `unit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '数量',
  `o_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '单价',
  `rebate` decimal(6, 2) NULL DEFAULT NULL COMMENT '折扣',
  `price` decimal(16, 6) NULL DEFAULT NULL COMMENT '实际单价',
  `tax_rate` decimal(6, 2) NULL DEFAULT NULL COMMENT '税率',
  `un_tax_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '无税单价',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `tax_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '批号',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `paid_up` decimal(16, 6) NULL DEFAULT NULL COMMENT '已发数量',
  `cust_goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对方产品编号',
  `net_order_item` smallint(6) NULL DEFAULT NULL COMMENT '网上订单项次',
  `written_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '已转单数量',
  `valid_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期至',
  `prod_date` datetime(0) NULL DEFAULT NULL COMMENT '生产日期',
  `prov_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `dept_id` int(11) NULL DEFAULT NULL COMMENT '仓库ID',
  `berth_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状况',
  `ref_cost` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考成本',
  `ref_profit` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考毛利',
  `ref_cost_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考成本价',
  `whole_qty` int(11) NULL DEFAULT NULL COMMENT '整件数量',
  `bulk_qty` int(11) NULL DEFAULT NULL COMMENT '散件数量',
  `spf_lag` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '特价标志',
  `gift_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '赠品数量',
  `std_rtl_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '标准零售价',
  `trace_back_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追溯号',
  `germicidal_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `goods_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货品状态',
  PRIMARY KEY (`orderid`, `item_no`) USING BTREE,
  INDEX `orderid`(`orderid`) USING BTREE,
  CONSTRAINT `qfyu_sel_order_dtl_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `qfyu_sel_order` (`orderid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售订单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_order_dtl
-- ----------------------------
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121015153504', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121015153504', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121015410251', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121015410251', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121029899529', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121029899529', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012121029899529', 3, 'FG0010', '瓶', 10.00000, 3.900000, 88.00, 3.432000, 13.00, 3.037168, 30.371680, 3.948320, 34.320000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012125455975110', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012125455975110', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012125457495151', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012125457495151', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012129950564854', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012129950564854', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012161005651555', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012161005651555', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012161005651555', 3, 'FG0010', '瓶', 10.00000, 3.900000, 88.00, 3.432000, 13.00, 3.037168, 30.371680, 3.948320, 34.320000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012165355515254', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012165355515254', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012165355515254', 3, 'FG0010', '瓶', 10.00000, 3.900000, 88.00, 3.432000, 13.00, 3.037168, 30.371680, 3.948320, 34.320000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012169953100569', 1, 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012169953100569', 2, 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012169953100569', 3, 'FG0010', '瓶', 10.00000, 3.900000, 88.00, 3.432000, 13.00, 3.037168, 30.371680, 3.948320, 34.320000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184810110253', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184810110253', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184810110253', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184848100505', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184848100505', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184848100505', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184999102984', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184999102984', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012184999102984', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012185349545651', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012185349545651', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012185349545651', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012185450481025', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012185450481025', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012185450481025', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012189850100524', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012189850100524', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012189850100524', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012189948991024', 1, 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012189948991024', 2, 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012189948991024', 3, 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012215210250525', 1, 'FG001', '盒', 10.00000, 8.400000, NULL, 8.400000, 15.00, 7.304348, 73.043480, 10.956520, 84.000000, NULL, NULL, NULL, '', NULL, 10.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012215210250525', 2, 'FG002', '盒', 2.00000, 10.800000, NULL, 10.800000, 16.00, 9.310345, 18.620690, 2.979310, 21.600000, NULL, NULL, NULL, '', NULL, 2.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012215556495456', 1, 'FG001', '盒', 50.00000, 8.400000, NULL, 8.400000, 15.00, 7.304348, 365.217400, 54.782600, 420.000000, NULL, NULL, NULL, NULL, NULL, 17.87500, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_order_dtl` VALUES ('SO2012215556495456', 2, 'FG002', '盒', 50.00000, 10.800000, NULL, 10.800000, 16.00, 9.310345, 465.517250, 74.482750, 540.000000, NULL, NULL, NULL, NULL, NULL, 50.00000, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_sel_settle
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_settle`;
CREATE TABLE `qfyu_sel_settle`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '销售结算单据号',
  `f_date` date NOT NULL COMMENT '结算日期',
  `in_out_kind` smallint(6) NOT NULL COMMENT '结算类型',
  `cust_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `link_man` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户采购人员',
  `company_name` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票抬头',
  `telephone` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票电话号码',
  `address` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票地址',
  `account_bank` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开户行',
  `account_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '帐号',
  `tax_no` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '税号',
  `invoice_type` tinyint(2) NOT NULL DEFAULT 1 COMMENT '发票类型',
  `invoice_date` datetime(0) NULL DEFAULT NULL COMMENT '发票日期',
  `invoice_no` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '发票号码',
  `yw_dept_id` int(11) NOT NULL COMMENT '业务部门',
  `emp_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人',
  `audit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员',
  `goods_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '货品总数',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '无税金额（货款）',
  `tax_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计',
  `pay_mode_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '付款方式',
  `pay_date` datetime(0) NULL DEFAULT NULL COMMENT '付款日期',
  `gather_at_once` decimal(16, 6) NULL DEFAULT NULL COMMENT '现收金额',
  `is_transfer` tinyint(1) NOT NULL DEFAULT 0 COMMENT '过账',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `print_count` smallint(6) NULL DEFAULT NULL COMMENT '打印次数',
  `flag` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标志信息',
  `creater` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '开单人',
  `creat_date` datetime(0) NULL DEFAULT NULL COMMENT '开单日期',
  `mender` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `dept_id` int(11) NOT NULL COMMENT '开单部门',
  `makeupfor_amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '退补差价合计',
  `warrant_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '凭证号',
  `invoice_id` varchar(22) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发票轨号',
  `invoice_money` decimal(16, 6) NULL DEFAULT NULL COMMENT '发票总金额',
  `contacts` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售结算单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_settle
-- ----------------------------
INSERT INTO `qfyu_sel_settle` VALUES ('XJ2012245010099565', '2020-12-24', 51, 'CR0002', '姚总1', NULL, NULL, NULL, '中国农业银行', '61228521456887459774', '9144030071526726XG', 1, NULL, NULL, 1, '001', NULL, 12.00000, 91.664170, 13.935830, 105.600000, NULL, NULL, NULL, 0, NULL, NULL, NULL, '001', '2020-12-24 11:47:14', NULL, NULL, 1, NULL, NULL, NULL, NULL, '');

-- ----------------------------
-- Table structure for qfyu_sel_settle_dtl
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_settle_dtl`;
CREATE TABLE `qfyu_sel_settle_dtl`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '销售结算单据号',
  `item_no` int(11) NOT NULL COMMENT '项次',
  `goods_code` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品编号',
  `unit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号',
  `qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '数量',
  `price` decimal(16, 6) NULL DEFAULT NULL COMMENT '单价',
  `tax_rate` decimal(6, 2) NOT NULL COMMENT '税率',
  `un_tax_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '无税单价',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `tax_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税款',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计',
  `ref_cost_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '成本价',
  `ref_cost` decimal(16, 6) NULL DEFAULT NULL COMMENT '总成本',
  `p_order_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应单号',
  `p_item_no` int(11) NULL DEFAULT NULL COMMENT '对应项次',
  `paid_up` decimal(16, 6) NULL DEFAULT NULL COMMENT '累计付款金额',
  `pay_done` tinyint(1) NOT NULL DEFAULT 0 COMMENT '付款完成',
  `pay_done_date` datetime(0) NULL DEFAULT NULL COMMENT '付款完成日期',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `makeupfor_amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '退补差价合计',
  `makeupfor_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '退补差价',
  PRIMARY KEY (`orderid`, `item_no`) USING BTREE,
  CONSTRAINT `qfyu_sel_settle_dtl_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `qfyu_sel_settle` (`orderid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售结算明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_settle_dtl
-- ----------------------------
INSERT INTO `qfyu_sel_settle_dtl` VALUES ('XJ2012245010099565', 1, 'FG001', '盒', '20201219-001', 10.00000, 8.400000, 15.00, 7.304348, 73.043480, 10.956520, 84.000000, 6.800000, 68.000000, 'SE2012235654515156', 1, NULL, 0, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_sel_settle_dtl` VALUES ('XJ2012245010099565', 2, 'FG002', '盒', '20201219-8888', 2.00000, 10.800000, 16.00, 9.310345, 18.620690, 2.979310, 21.600000, 0.000000, 0.000000, 'SE2012235654515156', 2, NULL, 0, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_sel_speer
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_speer`;
CREATE TABLE `qfyu_sel_speer`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `f_date` date NOT NULL COMMENT '创建时间',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效日期',
  `emp_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编号',
  `emp_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工姓名',
  `audit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核员',
  `cust_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户编号',
  `link_man` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '采购人员',
  `goods_sum` decimal(18, 6) NULL DEFAULT NULL COMMENT '无税总金额',
  `tax_sum` decimal(18, 6) NULL DEFAULT NULL COMMENT '税额',
  `amount` decimal(18, 6) NULL DEFAULT NULL COMMENT '总金额	',
  `goods_qty` decimal(18, 6) NULL DEFAULT NULL COMMENT '产品总数',
  `pay_mode_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算方式',
  `is_transfer` tinyint(1) NULL DEFAULT 0 COMMENT '过账',
  `is_finish` tinyint(1) NULL DEFAULT 0 COMMENT '是否完成',
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `print_count` smallint(6) NULL DEFAULT NULL COMMENT '打印次数',
  `creater` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `dept_id` int(10) UNSIGNED NOT NULL COMMENT '开单部门',
  `contacts` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系人',
  PRIMARY KEY (`orderid`) USING BTREE,
  INDEX `emp_no`(`emp_no`) USING BTREE,
  INDEX `audit`(`audit`) USING BTREE,
  INDEX `cust_no`(`cust_no`) USING BTREE,
  INDEX `creater`(`creater`) USING BTREE,
  INDEX `mender`(`mender`) USING BTREE,
  INDEX `pay_mode_no`(`pay_mode_no`) USING BTREE,
  INDEX `dept_id`(`dept_id`) USING BTREE,
  CONSTRAINT `qfyu_sel_speer_ibfk_1` FOREIGN KEY (`pay_mode_no`) REFERENCES `qfyu_settlement` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_sel_speer_ibfk_2` FOREIGN KEY (`emp_no`) REFERENCES `qfyu_employee` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_sel_speer_ibfk_3` FOREIGN KEY (`audit`) REFERENCES `qfyu_employee` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_sel_speer_ibfk_4` FOREIGN KEY (`cust_no`) REFERENCES `qfyu_customer` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_sel_speer_ibfk_5` FOREIGN KEY (`creater`) REFERENCES `qfyu_employee` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_sel_speer_ibfk_6` FOREIGN KEY (`mender`) REFERENCES `qfyu_employee` (`code`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `qfyu_sel_speer_ibfk_7` FOREIGN KEY (`dept_id`) REFERENCES `qfyu_depart` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售报价单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_speer
-- ----------------------------
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012105248575553', '2020-12-10', '2020-12-10', '001', NULL, NULL, 'CR0001', 'vr', 130.542557, 20.803603, 151.346160, 40.001000, 'JS002', 0, 0, '', 0, '001', '2020-12-10 13:57:08', '001', '2020-12-18 10:06:06', 1, '');
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012105351102529', '2020-12-10', '2020-12-10', '006', '', NULL, 'CR0001', 'vr', 174.081080, 16.478920, 190.560000, 28.000000, 'JS003', 0, 0, '', 0, '001', '2020-12-10 15:09:09', '001', '2020-12-18 09:52:15', 1, '');
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012105399481009', '2020-12-10', '2020-12-10', '001', '', NULL, 'CR0001', 'vr', 818.643484, 122.796516, 941.440000, 68.000000, 'JS003', 0, 0, '', 0, '001', '2020-12-10 15:16:05', '001', '2020-12-15 09:35:27', 1, 'fdsf');
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012105453101481', '2020-12-10', '2020-12-10', '003', '小米', '001', 'CR0001', 'vr', 1745.401164, 114.998836, 1860.400000, 78.000000, 'JS004', 1, 0, 'drtgrtggdgfd', 0, '001', '2020-12-10 15:19:34', '001', '2020-12-18 17:21:39', 1, 'fdsf');
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012105453985157', '2020-12-10', '2020-12-10', '001', NULL, NULL, 'CR0001', 'vr', 818.643484, 122.796516, 941.440000, 68.000000, 'JS003', 0, 0, '', 0, '001', '2020-12-10 15:15:50', NULL, NULL, 1, '');
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012105552565654', '2020-12-10', '2020-12-10', '003', '', '001', 'CR009', '', 91.520000, 10.982400, 102.502400, 22.000000, 'JS002', 0, 0, '', 0, '001', '2020-12-10 15:17:27', '001', '2020-12-11 17:11:50', 1, '');
INSERT INTO `qfyu_sel_speer` VALUES ('SS2012211009954481', '2020-12-21', '2020-12-21', '001', '小李', NULL, 'CR0002', '姚总1', 830.734650, 129.265350, 960.000000, 100.000000, 'JS001', 0, 0, NULL, NULL, '001', '2020-12-21 11:34:37', '001', '2020-12-23 14:35:30', 1, NULL);

-- ----------------------------
-- Table structure for qfyu_sel_speer_dtl
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sel_speer_dtl`;
CREATE TABLE `qfyu_sel_speer_dtl`  (
  `item_no` smallint(5) NOT NULL COMMENT '项次',
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '订单编号',
  `goods_code` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品编号',
  `unit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `qty` decimal(18, 5) NULL DEFAULT NULL COMMENT '数量',
  `o_price` decimal(18, 6) NULL DEFAULT NULL COMMENT '单价',
  `rebate` decimal(8, 2) NULL DEFAULT NULL COMMENT '折扣',
  `price` decimal(18, 6) NULL DEFAULT NULL COMMENT '折后单价',
  `tax_rate` decimal(6, 2) NULL DEFAULT NULL COMMENT '税率',
  `un_tax_price` decimal(18, 6) NULL DEFAULT NULL COMMENT '无税单价',
  `goods_sum` decimal(18, 6) NULL DEFAULT NULL COMMENT '无税总金额',
  `tax_sum` decimal(18, 6) NULL DEFAULT NULL COMMENT '税款总金额',
  `amount` decimal(18, 6) NULL DEFAULT NULL COMMENT '总金额',
  `cust_goods_code` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客方产品编号',
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`item_no`, `orderid`) USING BTREE,
  INDEX `orderid`(`orderid`) USING BTREE,
  CONSTRAINT `qfyu_sel_speer_dtl_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `qfyu_sel_speer` (`orderid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '销售报价单明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sel_speer_dtl
-- ----------------------------
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012105248575553', 'FG001', '盒', 10.00000, 5.000000, 88.00, 4.400000, 15.00, 3.826087, 38.260870, 5.739130, 44.000000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012105351102529', 'FG002', '盒', 10.00000, 7.000000, 100.00, 7.000000, NULL, 7.000000, 70.000000, 0.000000, 70.000000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012105399481009', 'FG002', '盒', 10.00000, 88.000000, 88.00, 77.440000, 15.00, 67.339130, 673.391300, 101.008700, 774.400000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012105453101481', 'FG0011', '盒', 58.00000, 25.000000, 68.00, 17.000000, 13.00, 15.044248, 872.566384, 113.433616, 986.000000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012105453985157', 'FG002', '盒', 10.00000, 88.000000, 88.00, 77.440000, 15.00, 67.339130, 673.391300, 101.008700, 774.400000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012105552565654', 'FG002', '盒', 10.00000, 7.000000, 92.00, 6.440000, 12.00, 5.750000, 57.500000, 6.900000, 64.400000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (1, 'SS2012211009954481', 'FG001', '盒', 50.00000, 8.400000, NULL, 8.400000, 15.00, 7.304348, 365.217400, 54.782600, 420.000000, NULL, NULL);
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012105248575553', 'FG003', '盒', 10.00000, 2.000000, 78.00, 1.560000, 15.00, 1.356522, 13.565220, 2.034780, 15.600000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012105351102529', 'FG004', '盒', 8.00000, 11.000000, 98.00, 10.780000, 17.00, 9.213675, 73.709400, 12.530600, 86.240000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012105399481009', 'FG003', '盒', 58.00000, 3.000000, 96.00, 2.880000, 15.00, 2.504348, 145.252184, 21.787816, 167.040000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012105453101481', 'FG008', '盒', 10.00000, 10.000000, 12.00, 1.200000, 15.00, 1.043478, 10.434780, 1.565220, 12.000000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012105453985157', 'FG003', '盒', 58.00000, 3.000000, 96.00, 2.880000, 15.00, 2.504348, 145.252184, 21.787816, 167.040000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012105552565654', 'FG0011', '盒', 12.00000, 3.240000, 98.00, 3.175200, 12.00, 2.835000, 34.020000, 4.082400, 38.102400, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (2, 'SS2012211009954481', 'FG002', '盒', 50.00000, 10.800000, NULL, 10.800000, 16.00, 9.310345, 465.517250, 74.482750, 540.000000, NULL, NULL);
INSERT INTO `qfyu_sel_speer_dtl` VALUES (3, 'SS2012105248575553', 'FG004', '盒', 10.00000, 11.000000, 65.00, 7.150000, 17.00, 6.111111, 61.111110, 10.388890, 71.500000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (3, 'SS2012105351102529', 'FG0010', '瓶', 10.00000, 3.900000, 88.00, 3.432000, 13.00, 3.037168, 30.371680, 3.948320, 34.320000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (3, 'SS2012105453101481', 'FG0011', '盒', 10.00000, 88.000000, 98.00, 86.240000, NULL, 86.240000, 862.400000, 0.000000, 862.400000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (4, 'SS2012105248575553', 'FG0012', '瓶', 10.00000, 2.300000, 88.00, 2.024000, 15.00, 1.760000, 17.600000, 2.640000, 20.240000, '', '');
INSERT INTO `qfyu_sel_speer_dtl` VALUES (5, 'SS2012105248575553', 'FG001', '盒', 0.00100, 7.000000, 88.00, 6.160000, 15.00, 5.356522, 0.005357, 0.000803, 0.006160, '4453', '');

-- ----------------------------
-- Table structure for qfyu_settlement
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_settlement`;
CREATE TABLE `qfyu_settlement`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` char(6) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '方式编码',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '结算名称',
  `overday` int(10) NULL DEFAULT NULL COMMENT '结算期限（单位：天）',
  `cid` int(10) UNSIGNED NOT NULL COMMENT '公司ID',
  `deptid` int(10) UNSIGNED NOT NULL COMMENT '部门ID',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `iseffective` tinyint(1) NULL DEFAULT 1 COMMENT '资料是否有效 1有效',
  `creater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `updater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE,
  INDEX `iseffective`(`iseffective`) USING BTREE,
  INDEX `settlelement_branch`(`cid`) USING BTREE,
  INDEX `settlelement_dept`(`deptid`) USING BTREE,
  CONSTRAINT `settlelement_dept` FOREIGN KEY (`deptid`) REFERENCES `qfyu_depart` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '结算方式信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_settlement
-- ----------------------------
INSERT INTO `qfyu_settlement` VALUES (1, 'JS001', '周结', 10, 3, 2, '', 1, NULL, NULL, '001', '2020-11-16 09:36:20');
INSERT INTO `qfyu_settlement` VALUES (2, 'JS002', '批结', 60, 3, 8, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_settlement` VALUES (3, 'JS003', '月结', 10, 3, 8, NULL, 1, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_settlement` VALUES (4, 'JS004', '现结', 7, 3, 2, 'bbbbbbbbbbbb', 1, NULL, NULL, '001', '2020-11-16 09:36:12');

-- ----------------------------
-- Table structure for qfyu_stock_batchpart
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_batchpart`;
CREATE TABLE `qfyu_stock_batchpart`  (
  `ware_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编码',
  `pos_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '货位编码',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编码',
  `batch_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '生产批号/序号',
  `qty` decimal(16, 5) NOT NULL DEFAULT 0.00000 COMMENT '商品库存(主单位)',
  `qty1` decimal(16, 5) NOT NULL DEFAULT 0.00000 COMMENT '整数库存',
  `qty2` decimal(16, 5) NOT NULL DEFAULT 0.00000 COMMENT '散装数量',
  `price1` decimal(16, 6) NOT NULL DEFAULT 0.000000 COMMENT '单价',
  `price2` decimal(16, 6) NOT NULL DEFAULT 0.000000 COMMENT '单价2（辅单位）',
  `amount` decimal(16, 6) NOT NULL DEFAULT 0.000000 COMMENT '合计总额',
  `prod_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `goods_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '商品状态',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状态',
  PRIMARY KEY (`ware_code`, `pos_code`, `sup_code`, `goods_code`, `batch_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存批次-商品库存总表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_batchpart
-- ----------------------------
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK002', 'WP0012', 'FS003', 'FG002', '20201222-001', 30.00000, 30.00000, 0.00000, 9.000000, 3.000000, 270.000000, '2018-12-05', '2022-12-21', '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK003', 'WP0011', 'FS002', 'FG001', '20201223', 8.00000, 8.00000, 0.00000, 9.900000, 4.950000, 79.200000, '2020-12-22', '2022-12-13', '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK003', 'WP0011', 'FS002', 'FG001', '20201224', 1.00000, 1.00000, 0.00000, 9.800000, 4.900000, 9.800000, '2020-12-24', '2023-12-20', '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK003', 'WP0011', 'FS003', 'FG001', '20201219-001', 17.87500, 17.00000, 1.75000, 13.600000, 6.800000, 243.100000, '2019-10-14', '2022-12-20', '合格', '合格');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK003', 'WP0011', 'FS003', 'FG002', '20201219-8888', 50.00000, 50.00000, 0.00000, 5.780000, 0.000000, 289.000000, '2018-12-20', '2022-12-20', '合格', '合格');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK003', 'WP0011', 'FS003', 'FG002', '20201221-001', 48.00000, 48.00000, 0.00000, 13.736667, 0.000000, 659.360000, '2019-06-20', '2022-12-23', '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK004', 'WP0010', '', 'FG001', '1122', 0.00000, 0.00000, 0.00000, 0.000000, 0.000000, 0.000000, '2020-12-21', NULL, '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK004', 'WP0010', 'FS003', 'FG001', '20201219-001', 54.50000, 54.00000, 1.00000, 15.214679, 7.607339, 829.200000, '2019-10-14', '2022-12-20', '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK004', 'WP0010', 'FS003', 'FG002', '20201219-002', 70.00000, 70.00000, 0.00000, 7.000000, 0.000000, 490.000000, '2019-08-20', '2021-12-30', '', '');
INSERT INTO `qfyu_stock_batchpart` VALUES ('CK004', 'WP0010', 'FS003', 'FG002', '20201219-003', 40.00000, 40.00000, 0.00000, 7.000000, 0.000000, 280.000000, '2019-12-24', '2022-12-22', '', '');

-- ----------------------------
-- Table structure for qfyu_stock_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_details`;
CREATE TABLE `qfyu_stock_details`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '序号',
  `reforderid` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据号',
  `item_no` smallint(6) NOT NULL COMMENT '单据号-项次号',
  `goods_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `inout_kind` int(10) NOT NULL DEFAULT -1 COMMENT '出入库类型',
  `unit` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `batch_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号',
  `pro_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `qty` decimal(16, 5) NOT NULL DEFAULT 0.00000 COMMENT '库存（主单位）',
  `qty1` decimal(16, 5) NULL DEFAULT 0.00000 COMMENT '整装数量',
  `qty2` decimal(16, 6) NOT NULL DEFAULT 0.000000 COMMENT '散装数量',
  `price1` decimal(16, 6) NULL DEFAULT NULL COMMENT '主单价（主单位）',
  `price2` decimal(16, 6) NULL DEFAULT 0.000000 COMMENT '辅单价（辅单位）',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计总额',
  `ware_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库编码',
  `pos_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位编码',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编码',
  `inqty` decimal(16, 5) UNSIGNED NOT NULL COMMENT '最初入库数量',
  `updator` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '最后一次操作员',
  `update_date` datetime(0) NOT NULL COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `reforderid`(`reforderid`, `item_no`) USING BTREE,
  INDEX `ware_code`(`ware_code`) USING BTREE,
  INDEX `pos_code`(`pos_code`) USING BTREE,
  INDEX `qty`(`qty`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 170 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库存批次-商品库存明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_details
-- ----------------------------
INSERT INTO `qfyu_stock_details` VALUES (122, 'AR2012191009810256', 1, 'FG001', 1, '千克', '20201219-001', '2019-10-14', '2022-12-20', 0.00000, 0.00000, 0.000000, 10.000000, 5.000000, 0.000000, 'CK004', 'WP0010', 'FS003', 30.00000, '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_details` VALUES (123, 'AR2012191009810256', 2, 'FG002', 1, '盒', '20201219-002', '2019-08-20', '2021-12-30', 0.00000, 0.00000, 0.000000, 7.000000, 0.000000, 0.000000, 'CK004', 'WP0010', 'FS003', 35.00000, '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_details` VALUES (124, 'AR2012191009810256', 3, 'FG002', 1, '盒', '20201219-003', '2019-12-24', '2022-12-22', 0.00000, 0.00000, 0.000000, 7.000000, 0.000000, 0.000000, 'CK004', 'WP0010', 'FS003', 20.00000, '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_details` VALUES (125, 'IS2012191009910254', 31, 'FG001', 1, '千克', '20201219-001', '2019-10-14', '2022-12-20', 17.87500, 17.00000, 1.750000, 13.600000, 6.800000, 243.100000, 'CK003', 'WP0011', 'FS003', 35.75000, '001', '2020-12-19 10:34:55');
INSERT INTO `qfyu_stock_details` VALUES (126, 'IS2012191009910254', 32, 'FG002', 1, '盒', '20201219-8888', '2018-12-20', '2022-12-20', 51.00000, 50.00000, 0.000000, 5.780000, 0.000000, 289.000000, 'CK003', 'WP0011', 'FS003', 50.00000, '001', '2020-12-19 10:34:55');
INSERT INTO `qfyu_stock_details` VALUES (153, 'AR2012191009810256', 4, 'FG001', 1, '千克', '20201219-001', '2019-10-14', '2022-12-20', 0.00000, 0.00000, 0.000000, 21.600000, 10.800000, 0.000000, 'CK004', 'WP0010', 'FS003', 24.50000, '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_details` VALUES (158, 'AR2012191009810256', 5, 'FG001', 1, '盒', '1122', '2020-12-21', NULL, 0.00000, 0.00000, 0.000000, 0.000000, NULL, 0.000000, 'CK004', 'WP0010', '', 0.00000, '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_details` VALUES (164, 'AR2012224910248102', 1, 'FG002', 1, '盒', '20201221-001', '2019-06-20', '2022-12-23', 49.00000, 48.00000, 0.000000, 12.680000, 0.000000, 608.640000, 'CK003', 'WP0011', 'FS003', 50.00000, '001', '2020-12-22 09:59:42');
INSERT INTO `qfyu_stock_details` VALUES (167, 'IS2012225649975097', 35, 'FG002', 1, '盒', '20201222-001', '2018-12-05', '2022-12-21', 30.00000, 30.00000, 0.000000, 9.000000, 3.000000, 270.000000, 'CK002', 'WP0012', 'FS003', 30.00000, '001', '2020-12-22 18:30:23');
INSERT INTO `qfyu_stock_details` VALUES (168, 'TO2012235610198489', 3, 'FG001', -1, '盒', '20201223', '2020-12-22', '2022-12-13', 8.00000, 8.00000, 0.000000, 9.900000, 4.950000, 79.200000, 'CK003', 'WP0011', 'FS002', 8.00000, '001', '2020-12-24 11:00:50');
INSERT INTO `qfyu_stock_details` VALUES (169, 'TO2012241005550485', 3, 'FG001', 8, '盒', '20201224', '2020-12-24', '2023-12-20', 1.00000, 1.00000, 0.000000, 9.800000, 4.900000, 9.800000, 'CK003', 'WP0011', 'FS002', 1.00000, '001', '2020-12-24 14:06:53');

-- ----------------------------
-- Table structure for qfyu_stock_goodsinout
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_goodsinout`;
CREATE TABLE `qfyu_stock_goodsinout`  (
  `reforderid` char(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据号',
  `item_no` smallint(6) UNSIGNED NOT NULL COMMENT '项次号',
  `stock_id` int(10) UNSIGNED NOT NULL COMMENT '库存编号',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编码',
  `order_date` datetime(0) NOT NULL COMMENT '单据日期',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `ware_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编码',
  `pos_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '货位编码',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `inout_kind` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '出入库类型',
  `qty` decimal(16, 5) UNSIGNED NULL DEFAULT 0.00000 COMMENT '库存数量',
  `price` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '单价',
  `account` decimal(16, 6) UNSIGNED NULL DEFAULT 0.000000 COMMENT '合计总额',
  `batch_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号/序列号',
  `prod_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `goods_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货品状态',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '质量状态',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建者时间',
  PRIMARY KEY (`reforderid`, `item_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出入库-商品出入库记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_goodsinout
-- ----------------------------
INSERT INTO `qfyu_stock_goodsinout` VALUES ('AR2012191009810256', 1, 122, 'FG001', '2020-12-21 17:46:04', '盒', 'CK004', 'WP0010', 'FS003', 58, 15.00000, 0.000000, 150.000000, '20201219-001', '2019-10-14', '2022-12-20', NULL, '', '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('AR2012191009810256', 2, 123, 'FG002', '2020-12-21 17:46:04', '盒', 'CK004', 'WP0010', 'FS003', 58, 35.00000, 0.000000, 245.000000, '20201219-002', '2019-08-20', '2021-12-30', NULL, '', '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('AR2012191009810256', 3, 124, 'FG002', '2020-12-21 17:46:04', '盒', 'CK004', 'WP0010', 'FS003', 58, 20.00000, 0.000000, 140.000000, '20201219-003', '2019-12-24', '2022-12-22', NULL, '', '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('AR2012191009810256', 4, 153, 'FG001', '2020-12-21 17:46:04', '盒', 'CK004', 'WP0010', 'FS003', 58, 12.25000, 0.000000, 264.600000, '20201219-001', '2019-10-14', '2022-12-20', NULL, '', '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('AR2012191009810256', 5, 158, 'FG001', '2020-12-21 17:46:04', '盒', 'CK004', 'WP0010', '', 8, 0.00000, 0.000000, 0.000000, '1122', '2020-12-21', NULL, NULL, '', '001', '2020-12-21 17:46:04');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('AR2012224910248102', 1, 164, 'FG002', '2020-12-22 09:59:42', '盒', 'CK003', 'WP0011', 'FS003', 58, 2.00000, 0.000000, 25.360000, '20201221-001', '2019-06-20', '2022-12-23', NULL, '', '001', '2020-12-22 09:59:42');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012185348575157', 26, 122, 'FG001', '2020-12-19 10:10:51', '千克', 'CK004', 'WP0010', 'FS003', 1, 30.00000, 0.000000, 150.000000, '20201219-001', '2019-10-14', '2022-12-20', '合格', '合格', '001', '2020-12-19 10:10:51');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012185348575157', 27, 123, 'FG002', '2020-12-19 10:10:51', '盒', 'CK004', 'WP0010', 'FS003', 1, 35.00000, 0.000000, 245.000000, '20201219-002', '2019-08-20', '2021-12-30', '合格', '合格', '001', '2020-12-19 10:10:51');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012185348575157', 28, 124, 'FG002', '2020-12-19 10:10:51', '盒', 'CK004', 'WP0010', 'FS003', 1, 20.00000, 0.000000, 140.000000, '20201219-003', '2019-12-24', '2022-12-22', '合格', '合格', '001', '2020-12-19 10:10:51');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012191009910254', 31, 125, 'FG001', '2020-12-19 10:34:55', '千克', 'CK003', 'WP0011', 'FS003', 1, 35.75000, 0.000000, 243.100000, '20201219-001', '2019-10-14', '2022-12-20', '合格', '合格', '001', '2020-12-19 10:34:55');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012191009910254', 32, 126, 'FG002', '2020-12-19 10:34:55', '盒', 'CK003', 'WP0011', 'FS003', 1, 50.00000, 0.000000, 289.000000, '20201219-8888', '2018-12-20', '2022-12-20', '合格', '合格', '001', '2020-12-19 10:34:55');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012199710048102', 33, 153, 'FG001', '2020-12-19 11:32:17', '千克', 'CK004', 'WP0010', 'FS003', 1, 24.50000, 0.000000, 264.600000, '20201219-001', '2019-10-14', '2022-12-20', '合格', '合格', '001', '2020-12-19 11:32:17');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012211025198485', 34, 164, 'FG002', '2020-12-22 09:57:50', '盒', 'CK003', 'WP0011', 'FS003', 1, 50.00000, 0.000000, 634.000000, '20201221-001', '2019-06-20', '2022-12-23', '合格', '合格', '001', '2020-12-22 09:57:50');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('IS2012225649975097', 35, 167, 'FG002', '2020-12-22 18:30:23', '盒', 'CK002', 'WP0012', 'FS003', 1, 30.00000, 0.000000, 270.000000, '20201222-001', '2018-12-05', '2022-12-21', '', '', '001', '2020-12-22 18:30:23');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('TO2012235610198489', 3, 168, 'FG001', '2020-12-24 11:00:50', '盒', 'CK003', 'WP0011', 'FS002', 8, 8.00000, 9.900000, 79.200000, '20201223', '2020-12-22', '2022-12-13', NULL, '', '001', '2020-12-24 11:00:50');
INSERT INTO `qfyu_stock_goodsinout` VALUES ('TO2012241005550485', 3, 169, 'FG001', '2020-12-24 14:06:53', '盒', 'CK003', 'WP0011', 'FS002', 8, 1.00000, 9.800000, 9.800000, '20201224', '2020-12-24', '2023-12-20', NULL, '', '001', '2020-12-24 14:06:53');

-- ----------------------------
-- Table structure for qfyu_stock_out
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_out`;
CREATE TABLE `qfyu_stock_out`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `f_date` date NOT NULL COMMENT '单据日期',
  `ware_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编号',
  `cust_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编号',
  `in_out_kind` int(11) NOT NULL COMMENT '出库方式',
  `goods_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '货品总数',
  `goods_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `cost_sum` decimal(16, 6) NULL DEFAULT NULL COMMENT '成本总计',
  `emp_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验货员编号',
  `shipper` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发货人',
  `audit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '复核员',
  `is_transfer` tinyint(1) NOT NULL DEFAULT 0 COMMENT '过账',
  `p_order_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '销售/销退单号',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `print_count` smallint(6) NULL DEFAULT NULL COMMENT '打印次数',
  `creater` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `creat_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新者',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `dept_id` int(11) NOT NULL COMMENT '开单部门',
  `rec_no` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '流水号',
  `sort_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '拣货状态',
  `sort_print_count` int(11) NOT NULL DEFAULT 0 COMMENT '拣货单打印次数',
  `sort_man` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '拣货人',
  `check_status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '验货状态',
  `audit2` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第二复核员',
  `is_reject` tinyint(1) NULL DEFAULT NULL COMMENT '不合格品标志',
  `sort_print_date` datetime(0) NULL DEFAULT NULL COMMENT '拣货单打印时间',
  `checked_date` datetime(0) NULL DEFAULT NULL COMMENT '验货时间',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库登记/复核' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_out
-- ----------------------------
INSERT INTO `qfyu_stock_out` VALUES ('OS2012245010148989', '2020-12-24', 'CK003', 'CR0002', 51, 12.00000, 91.664170, 68.000000, NULL, NULL, NULL, 0, 'SE2012235654515156', NULL, NULL, '001', '2020-12-24 11:47:14', NULL, NULL, 1, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_stock_out_dtl
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_out_dtl`;
CREATE TABLE `qfyu_stock_out_dtl`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `item_no` int(11) NOT NULL COMMENT '项次',
  `goods_code` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品编号',
  `unit` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '数量',
  `price` decimal(16, 6) NULL DEFAULT NULL COMMENT '单价',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计',
  `cost` decimal(16, 6) NULL DEFAULT NULL COMMENT '成本金额',
  `pos_code` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '存货货位',
  `group_no` smallint(6) NOT NULL DEFAULT 0 COMMENT '批次',
  `prov_no` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状况',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号/序列号',
  `prod_date` datetime(0) NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` datetime(0) NULL DEFAULT NULL COMMENT '有效期至',
  `p_order_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '对应单号',
  `p_item_no` int(11) NULL DEFAULT NULL COMMENT '对应项次',
  `orig_price` decimal(16, 6) NULL DEFAULT NULL COMMENT '原发货价',
  `ret_qty` decimal(16, 5) NULL DEFAULT NULL COMMENT '退货数量',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `rec_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出库流水号',
  `trace_back_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追溯号',
  `germicidal_no` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `goods_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货品状态',
  PRIMARY KEY (`orderid`, `item_no`) USING BTREE,
  CONSTRAINT `qfyu_stock_out_dtl_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `qfyu_stock_out` (`orderid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '出库登记/复核 明细' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_out_dtl
-- ----------------------------
INSERT INTO `qfyu_stock_out_dtl` VALUES ('OS2012245010148989', 1, 'FG001', '盒', 10.00000, 7.304348, 73.043480, 68.000000, 'WP0011', 0, 'FS003', NULL, '20201219-001', '2019-10-14 00:00:00', '2022-12-20 00:00:00', 'SE2012235654515156', 1, 8.400000, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `qfyu_stock_out_dtl` VALUES ('OS2012245010148989', 2, 'FG002', '盒', 2.00000, 9.310345, 18.620690, 0.000000, 'WP0011', 0, 'FS003', NULL, '20201219-8888', '2018-12-20 00:00:00', '2022-12-20 00:00:00', 'SE2012235654515156', 2, 10.800000, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for qfyu_stock_receive
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_receive`;
CREATE TABLE `qfyu_stock_receive`  (
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单据号',
  `reforderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '来货登记单号',
  `emp_no` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验货员',
  `emp_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '验货员姓名',
  `sup_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `order_date` date NOT NULL COMMENT '单据日期',
  `sup_sell` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供方销售人',
  `sup_contact` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方联系人',
  `sales_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员编码',
  `sales_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '业务员姓名',
  `paymode` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '结算方式',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方部门',
  `fungible` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否代销收货 1是',
  `pay_date` date NULL DEFAULT NULL COMMENT '付款日期',
  `goodsqty` decimal(16, 5) NOT NULL COMMENT '货品总数',
  `goodssum` decimal(16, 6) NULL DEFAULT NULL COMMENT '货款',
  `taxsum` decimal(16, 6) NULL DEFAULT NULL COMMENT '税额',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '合计总额',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `dept_id` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '资源所属',
  `isclose` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否已结案 1已结案',
  `ischeck` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否审核 1：已审核',
  `check_date` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `check_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核人',
  `creator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `updator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '最后修改人',
  `update_date` datetime(0) NOT NULL COMMENT '最后一次修改时间',
  `keeper1_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第一保管员',
  `keeper1_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '第一保管员姓名',
  `keeper2_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第二保管员',
  `keeper2_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '第二保管员姓名',
  PRIMARY KEY (`orderid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品入库单-单据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_receive
-- ----------------------------
INSERT INTO `qfyu_stock_receive` VALUES ('IS2012185348575157', 'PC2012185050551021', '', '', 'FS003', '2020-12-18', '张三歌', 'zero', '004', '小黄', 'JS003', '5535435', 1, NULL, 85.00000, 474.826180, 60.173820, 535.000000, '该订单由来货验收后转单通知入库复核', 1, 0, 1, '2020-12-19 10:10:51', '001', '009', '2020-12-18 18:04:21', '001', '2020-12-19 10:05:17', '', '', '', '');
INSERT INTO `qfyu_stock_receive` VALUES ('IS2012191009910254', 'PC2012191015610057', '', '', 'FS003', '2020-12-19', '张三歌', 'zero', '009', '', 'JS003', '5535435', 0, NULL, 85.75000, 500.391287, 31.708713, 532.100000, '该订单由来货验收后转单通知入库复核', 1, 0, 1, '2020-12-19 10:34:55', '001', '001', '2020-12-19 10:19:25', '001', '2020-12-19 10:32:25', '', '', '', '');
INSERT INTO `qfyu_stock_receive` VALUES ('IS2012199710048102', 'PC2012199752495256', '', '', 'FS003', '2020-12-19', '张三歌', 'zero', '009', '', 'JS003', '5535435', 0, NULL, 24.50000, 234.159289, 30.440711, 264.600000, '该订单由来货验收后转单通知入库复核', 1, 0, 1, '2020-12-19 11:32:17', '001', '001', '2020-12-19 10:45:30', '001', '2020-12-19 10:46:43', '', '', '', '');
INSERT INTO `qfyu_stock_receive` VALUES ('IS2012211025198485', 'PC2012215250505710', '', '', 'FS003', '2020-12-21', '张三歌', 'zero', '004', '小黄', 'JS003', '5535435', 0, NULL, 50.00000, 634.000000, 0.000000, 634.000000, '该订单由来货验收后转单通知入库复核', 1, 0, 1, '2020-12-22 09:57:50', '001', '001', '2020-12-21 17:06:07', '001', '2020-12-22 09:57:26', '', '', '', '');
INSERT INTO `qfyu_stock_receive` VALUES ('IS2012225649975097', 'PC2012225057539810', '', '', 'FS003', '2020-12-22', '张三歌', 'zero', '004', '小黄', 'JS003', '5535435', 0, NULL, 30.00000, 238.938060, 31.061940, 270.000000, '该订单由来货验收后转单通知入库复核', 1, 0, 1, '2020-12-22 18:30:23', '001', '001', '2020-12-22 15:09:28', '001', '2020-12-22 18:30:19', '', '', '', '');

-- ----------------------------
-- Table structure for qfyu_stock_receive_details
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_stock_receive_details`;
CREATE TABLE `qfyu_stock_receive_details`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `item_no` int(10) UNSIGNED NULL DEFAULT NULL COMMENT '单据明细编码',
  `orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '入库单号',
  `reforderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来货登记号',
  `in_orderid` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量验收单据号',
  `goods_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '商品编号',
  `unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位',
  `giftqty` decimal(16, 5) UNSIGNED NULL DEFAULT NULL COMMENT '赠品数量',
  `qty` decimal(16, 5) UNSIGNED NOT NULL COMMENT '数量',
  `price` decimal(16, 6) UNSIGNED NOT NULL COMMENT '单价',
  `taxrate` decimal(6, 2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '税率%',
  `notax_price` decimal(16, 6) NOT NULL COMMENT '无税单价',
  `goodssum` decimal(16, 6) NOT NULL COMMENT '无税金额',
  `taxsum` decimal(16, 6) NOT NULL COMMENT '税额',
  `amount` decimal(16, 6) NOT NULL COMMENT '合计总额',
  `batchno` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生产批号/序列号',
  `prod_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期至',
  `ware_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库编码',
  `pos_code` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '库位编码',
  `sup_sellno` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方销售编号',
  `sup_goodsid` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供方产品编号',
  `traceback_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '追溯号',
  `germicidal_no` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '灭菌批号',
  `goods_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货品状态',
  `quality_state` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '质量状态',
  `inqty` decimal(16, 5) UNSIGNED NULL DEFAULT 0.00000 COMMENT '已入库数量',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `updator` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后一次更新者',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `item_no`(`item_no`, `orderid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品入库单-单据详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_stock_receive_details
-- ----------------------------
INSERT INTO `qfyu_stock_receive_details` VALUES (26, 1, 'IS2012185348575157', 'PC2012185050551021', 'CY2012181029854564', 'FG001', '千克', 0.00000, 30.00000, 5.000000, 17.00, 4.273504, 128.205120, 21.794880, 150.000000, '20201219-001', '2019-10-14', '2022-12-20', 'CK004', 'WP0010', '', '', '', '', '合格', '合格', 15.00000, '', '001', '2020-12-19 10:05:17');
INSERT INTO `qfyu_stock_receive_details` VALUES (27, 2, 'IS2012185348575157', 'PC2012185050551021', 'CY2012181029856554', 'FG002', '盒', 0.00000, 35.00000, 7.000000, 10.00, 6.363636, 222.727260, 22.272740, 245.000000, '20201219-002', '2019-08-20', '2021-12-30', 'CK004', 'WP0010', '', '', '', '', '合格', '合格', 35.00000, '', '001', '2020-12-19 10:05:17');
INSERT INTO `qfyu_stock_receive_details` VALUES (28, 3, 'IS2012185348575157', 'PC2012185050551021', 'CY2012181029856554', 'FG002', '盒', 0.00000, 20.00000, 7.000000, 13.00, 6.194690, 123.893800, 16.106200, 140.000000, '20201219-003', '2019-12-24', '2022-12-22', 'CK004', 'WP0010', '', '', '', '', '合格', '合格', 20.00000, '', '001', '2020-12-19 10:05:17');
INSERT INTO `qfyu_stock_receive_details` VALUES (31, 1, 'IS2012191009910254', 'PC2012191015610057', 'CY2012191024997505', 'FG001', '千克', 0.00000, 35.75000, 6.800000, 15.00, 5.913043, 211.391287, 31.708713, 243.100000, '20201219-001', '2019-10-14', '2022-12-20', 'CK003', 'WP0011', '', '', '', '', '合格', '合格', 17.87500, '', '001', '2020-12-19 10:32:25');
INSERT INTO `qfyu_stock_receive_details` VALUES (32, 2, 'IS2012191009910254', 'PC2012191015610057', 'CY2012191024998995', 'FG002', '盒', 0.00000, 50.00000, 5.780000, 0.00, 5.780000, 289.000000, 0.000000, 289.000000, '20201219-8888', '2018-12-20', '2022-12-20', 'CK003', 'WP0011', '', '', '', '', '合格', '合格', 50.00000, '', '001', '2020-12-19 10:32:25');
INSERT INTO `qfyu_stock_receive_details` VALUES (33, 1, 'IS2012199710048102', 'PC2012199752495256', 'CY2012195250975749', 'FG001', '千克', 0.00000, 24.50000, 10.800000, 13.00, 9.557522, 234.159289, 30.440711, 264.600000, '20201219-001', '2019-10-14', '2022-12-20', 'CK004', 'WP0010', '', '', '', '', '合格', '合格', 12.25000, '', '001', '2020-12-19 10:46:43');
INSERT INTO `qfyu_stock_receive_details` VALUES (34, 1, 'IS2012211025198485', 'PC2012215250505710', 'CY2012219957535097', 'FG002', '盒', 0.00000, 50.00000, 12.680000, 0.00, 12.680000, 634.000000, 0.000000, 634.000000, '20201221-001', '2019-06-20', '2022-12-23', 'CK003', 'WP0011', '', '', '', '', '合格', '合格', 50.00000, '', '001', '2020-12-21 17:08:30');
INSERT INTO `qfyu_stock_receive_details` VALUES (35, 1, 'IS2012225649975097', 'PC2012225057539810', 'CY2012225550489897', 'FG002', '盒', 0.00000, 30.00000, 9.000000, 13.00, 7.964602, 238.938060, 31.061940, 270.000000, '20201222-001', '2018-12-05', '2022-12-21', 'CK002', 'WP0012', '', '', '', '', '', '', 30.00000, '', '001', '2020-12-22 18:30:19');

-- ----------------------------
-- Table structure for qfyu_sys_category
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_category`;
CREATE TABLE `qfyu_sys_category`  (
  `value` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品大类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_category
-- ----------------------------
INSERT INTO `qfyu_sys_category` VALUES ('OTC补益类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC补益类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC儿科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC儿科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC妇科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC妇科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC妇科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC妇科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC肝胆类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC肝胆类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC感冒用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC感冒用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC骨伤科口服', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC骨伤科口服', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC骨伤科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC骨伤科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC解热镇痛', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC解热镇痛', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC抗过敏及激素类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC抗过敏及激素类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC泌尿系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC泌尿系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC皮肤科外用药的', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC皮肤科外用药的', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC皮肤科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC皮肤科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC清热解毒类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC清热解毒类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC维生素及矿物质', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC维生素及矿物质', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC五官科口服药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC五官科口服药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC五官科外用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC五官科外用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC消化系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC消化系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC心脑血管类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC心脑血管类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC镇静安神类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC镇静安神类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC镇咳祛痰药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('OTC镇咳祛痰药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX补益类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX补益类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX儿科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX儿科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX妇科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX妇科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX妇科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX妇科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX肝胆类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX肝胆类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX感冒用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX感冒用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('Rx骨伤科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('Rx骨伤科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX抗过敏及激素类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX抗过敏及激素类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX抗炎抗风湿类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX抗炎抗风湿类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX泌尿系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX泌尿系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX免疫降糖类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX免疫降糖类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('Rx皮肤科外用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('Rx皮肤科外用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX皮肤科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX皮肤科用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX清热解毒类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX清热解毒类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX五官科口服药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX五官科口服药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX五官科外用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX五官科外用药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX消化系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX消化系统类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX心脑血管类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX心脑血管类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX镇静安神类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX镇静安神类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX镇咳祛痰药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('RX镇咳祛痰药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('办公及消耗材料', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('办公及消耗材料', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('保健食品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('保健食品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('参茸专柜', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('参茸专柜', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('处方药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('处方药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('毒性中药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('毒性中药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('儿童用抗生素', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('儿童用抗生素', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('妇科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('妇科外用', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('妇科消毒用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('妇科消毒用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('骨伤科用非药品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('骨伤科用非药品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('贵重药品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('贵重药品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('化妆品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('化妆品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('计生外用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('计生外用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('计生用口服药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('计生用口服药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('进口类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('皮肤科外用(器械)', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('进口类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('皮肤科消毒用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('皮肤科外用(器械)', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('其他类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('皮肤科消毒用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('糖烟酒等', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('其他类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('外用类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('糖烟酒等', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('卫生材料', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('外用类', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('五官科消毒用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('卫生材料', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('消毒杀虫剂', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('五官科消毒用品', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('医疗器械', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('消毒杀虫剂', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('云南植物', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('医疗器械', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('针剂及糖盐水', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('云南植物', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('镇咳祛痰药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('针剂及糖盐水', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('镇咳祛痰药', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('中药材', NULL);
INSERT INTO `qfyu_sys_category` VALUES ('中药材', NULL);

-- ----------------------------
-- Table structure for qfyu_sys_config
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_config`;
CREATE TABLE `qfyu_sys_config`  (
  `f_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `fd_escr` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `f_value` smallint(6) NULL DEFAULT NULL,
  `ref_values` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `Key_words` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `flag` int(11) NOT NULL,
  PRIMARY KEY (`f_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配置信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_config
-- ----------------------------
INSERT INTO `qfyu_sys_config` VALUES ('gmp_pch_expired_disabled', 'GMP证书过期的商品禁止采购', 1, '1|0', '', '此项设置1，GMP证书有效期过期的商品禁止在采购计划、采购订单、来货登记等模块中使用', 0);
INSERT INTO `qfyu_sys_config` VALUES ('lock_pch_emp_bill', '锁定采购业务员', 1, '1|0', '采购单;锁定业务员', '如果此项设置1，则在采购时只能使用供应商资料中设置的业务负责人', 0);
INSERT INTO `qfyu_sys_config` VALUES ('lock_pch_pay_mode', '锁定采购结算方式', 1, '1|0', '采购业务;锁定结算方式', '如果此项设置1，则在采购时只能使用供应商资料中设置的结算方式', 0);
INSERT INTO `qfyu_sys_config` VALUES ('lock_sel_pay_mode', '锁定销售结算方式', 1, '1|0', '销售业务;锁定结算方式', '如果此项设置1，则销售时只能使用客户资料中设置的结算方式', 0);
INSERT INTO `qfyu_sys_config` VALUES ('pch_mustinput_invoice_check', '来货时必须录入随货同行发票信息', 1, '1|0', NULL, '此选项设为1时，在做来货登记时必须录入发票信息才可以审核。', 0);
INSERT INTO `qfyu_sys_config` VALUES ('pch_order_plan_invalid_days', '采购计划、采购订单默认失效天数', 7, '3|7|9|15', '', '采购计划、采购订单失效日期的默认天数，天数必须为整数', 0);

-- ----------------------------
-- Table structure for qfyu_sys_config_bak
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_config_bak`;
CREATE TABLE `qfyu_sys_config_bak`  (
  `f_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `fd_escr` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `f_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ref_values` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `Key_words` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `flag` int(11) NOT NULL,
  PRIMARY KEY (`f_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_config_bak
-- ----------------------------
INSERT INTO `qfyu_sys_config_bak` VALUES ('AllowFirstCorpToProvOnApprover', '首营企业审批后允许转为供应商资料', 'Y', 'Y|N', '', 'Y：审批首营企业时自动将首营企业资料转为供应商资料', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AuditCheckLostNeedSP', '审核盘亏记录需要特权', 'N', 'Y|N', '', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditLackGoodsOnStockMoveApply', '自动审核调拨申请单审核时生成的缺货单', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditPchSettleBill', '自动审核生成的采购结算单', 'N', 'Y|N', '', '此选项设为Y时，自动生成的采购结算单将在生成后被审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditPosBillOnUpload', '门店上传POS单时自动过账', 'Y', 'Y|N', '', '为Y时，门店在上传POS单时将自动审核，为N则不审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditSelSettleBill', '自动审核生成的销售结算单', 'Y', 'Y|N', '', '此选项设为Y时，自动生成的销售结算单将在生成后被自动审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditStockInBill', '自动审核入库单', 'Y', 'Y|N', '采购单转入库', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditStockMoveOnApply', '自动审核调拨申请单审核时生成的调拨单', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditStockOutBill', '自动审核出库单', 'Y', 'Y|N', '销售单转出库', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoAuditSupplyStockOutBill', '自动审核配送出库单', 'Y', 'Y|N', '', '此选项设为Y时，将自动审核配送出库单。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoBuildPchSettleBill', '自动生成采购结算单', 'Y', 'Y|N', '采购结算', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoBuildSelSettleBill', '自动生成销售结算单', 'Y', 'Y|N', '销售结算', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoBuildSpotCheckRec', '自动生成药品验收抽样记录', 'N', 'Y|N', '', '如果设置为Y，则在采购药品质量验收单审核时自动生成“药品验收抽样记录”。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoBuildSupplySettleBill', '自动生成配送结算单', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoCheckGoodsForPurchaseOnSave', '自动检测所供品种合法性', 'N', 'Y|N', '', '此选项设为Y时，则在采购订单、来货登记、入库通知单保存时自动检测供应商所供商品是否符合许可经营类别限制、协议品种限制。如果“仅允许在许可经营范围内进货”和“仅允许从协议品种中进货”等选项都为N，则此选项设置为Y也无意义。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoCheckGoodsForSellOnSave', '自动检测销售品种的合法性', 'N', 'Y|N', '', '此选项设为Y时，则在销售订单、销售开单保存时自动检测销售的商品是否符合客户许可经营类别限制。如果“仅允许销售在客户许可经营范围内的商品”设为N，则此选项设置为Y也无意义。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoFillConsignee1OnPchCheckIn', '自动填写来货登记单的第一收货人', 'Y', 'Y|N', '', '如果设置为Y，采购订单转来货登记时，自动将转单人设为来货登记第一收货人，新增来货登记时，自动将做单人设为第一收货人。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoInsertInjectionCheckup', '在采购入库时为指定剂型药品生成澄明度检查记录', 'Y', 'Y|N', '针剂,注射剂', '将需要澄明度检查的剂型输入到[关键字]栏内。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoMadeSettleBillUseSelExportBillOwner', '自动生成的结算单沿用销售单上的创建人及所属部门', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoModifyInDateByUnauditedSellRec', '根据未过帐销售记录自动修改入库日期', 'N', 'Y|N', '', '此选项设为Y时，将检查零售表中是否有开单日期在此次入库日期之前而又因库存不足不能过帐的记录，如果有，将修改此次入库日期为彼单的销售日期。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoRefGoodsRemarkOnSell', '销售订单及发货单自动引用商品备注', 'Y', 'Y|N', '销售', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('AutoSetGiftQtyOnSelExport', '销售开单时自动应用商品买赠设置', 'Y', 'Y|N', NULL, '为N时，将不会根据商品资料中的买赠设置自动更新赠品数量。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('BatchSellLimitNearValidDateFirst', '批发销售时限制近效期必须先出', 'N', 'Y|N', '', '为Y时在销售订单、销售开单等模块中选择批号时，必须先选效期近的商品。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('BillMsgOnlySendToAuditer', '仅对具有相应单据审核权限的用户发送单据消息', 'N', 'Y|N', '', '如果设置为Y，对于启用了单据消息的模块，仅向具有该模块审核权限的用户发送单据消息。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('BuildStockOutOnSelExportAudit', '发货单审核后自动生成出库单', 'Y', 'Y|N', '发货单;出库单', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('BuildSupplyStockOutOnShopShupplyAudit', '总部配送单审核时自动生成配送出库单', 'Y', 'Y|N', '', '此选项设为Y时，总部配送单审核时将自动生成配送出库单。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CanModifySelExportGiftQty', '销售发货单赠品数量是否允许修改', 'Y', 'Y|N', NULL, '为N时，就算用户有特权，也不允许修改赠品数量。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CargoFlow_DelLine_SP', '验货时删除行需要验证特权', 'N', 'Y|N', '', '为Y时验货时删除行需要验证用户特权', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CargoFlow_ForceComplete_SP', '强制完成验货需要验证特权', 'N', 'Y|N', '', '为Y时强制完成验货需要验证用户特权', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CargoFlow_ModifyQty_SP', '验货时改数量需要验证特权', 'N', 'Y|N', '', '为Y时验货时改数量需要验证用户特权', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CargoFlow_Negative_SP', '验货时输负数需要验证特权', 'N', 'Y|N', '', '为Y时验货时输负数需要验证用户特权', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CargoFlow_NoUseStockOutPick', '仓库物流平台-略过拣货打印流程', 'N', 'Y|N', '', '设置为Y后，可以直接验货，而不需要打印拣货单', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CargoFlow_Recheck_SP', '重新验货需要验证特权', 'N', 'Y|N', '', '为Y时重新验货需要验证用户特权', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ChangeSellPriceMustSpecialPopedom', '销售开单修改已存在的价格需要验证用户特权', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckDealinKindsOnRation', '配送时检查许可经营范围', 'N', 'Y|N', '', '此选项设为Y时，则做配送时，所选商品必须属于分店许可经营的类别(商品未指定许可经营类别则不限制)。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckIDCardOnSaveProvLinkman', '供应方销售人员（联系人）保存时检查身份证', 'Y', 'Y|N', '', '此选项设为Y时，编辑供方销售人员（联系人）资料时必须填写其身份证号，且不能重复。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckSelfDealinKindsOnPurchase', '进货时检查本公司的许可经营范围', 'N', 'Y|N', '', '此选项设为Y时，则做采购订单、来货登记、入库通知单时，所选商品必须属于本公司许可经营的类别(商品未指定许可经营类别则不限制)。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckSelLimitQtyOnSelExport', '销售开单时检查所售商品是否超过每单限量', 'N', 'Y|N', '', '此选项设为Y时，销售开单保存时将检查所销售的商品数量是否超出其资料中设定的批发限量。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckShopDealinKindsOnSend', '直营配送时检查分店的许可经营范围', 'N', 'Y|N', '', '此选项设为Y时，则做直营配送单据时，所选商品必须属于分店许可经营的类别(商品未指定许可经营类别则不限制)。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckStockOnSelOrderAudit', '销售订单审核时检测库存', 'Y', 'Y/N', '', '在销售订单审核时，对所订商品进行库存检测。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CheckUsableStockOnSelExportSaved', '销售开单保存时检测可用量', 'N', 'Y|N', '', '此选项设为Y时，销售开单在保存时将检查所开品种的可用量，开单数高于可用量将禁止保存。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CloseUnpaidPosTradeNeedSP', 'POS关闭未结账交易需特权', 'N', 'Y|N', '', '此选项设为Y时，POS关闭未结账的交易时需要特权用户许可。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ColdTransitTemperatureHigh', '冷藏运输允许温上限', 'N', 'N|2|8', '', '设为N不起作用，设置其它值将在审核冷藏运输登记时检查该单登记的发货时温度和到货时温度，如果高于设定值将不允许审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ColdTransitTemperatureLow', '冷藏运输允许温下限', 'N', 'N|2|8', '', '设为N不起作用，设置其它值将在审核冷藏运输登记时检查该单登记的发货时温度和到货时温度，如果低于设定值将不允许审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CreditLimitedOnlyAuditedSS', '仅已审核的销售结算单参与信用计算', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CtmPackCheckOnlyShowSameCompany', '中药饮片装斗复核记录只显示本公司的记录', 'Y', 'N|Y', '', '设为Y时，中药饮片装斗复核记录、中药饮片清斗装斗复核记录只显示与当前登录用户同一公司的记录。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CustHasCertExpiredDisableSell', '客户任一证书过期不允许开单', 'N', 'Y|N', '', '此选项设为Y时，客户任一证书有效期过期将禁止开单', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('CustProvMustInputEmpAndPayMode', '客商资料必须填写业务负责人和结算方式', 'N', 'Y|N', '', '此选项设为Y时，客户和供应商资料必须填写业务负责人和结算方式。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DelRepeatedBerthOnAutoUpdate', '自动更新商品存放货位时重复货位处理方式', '每个商品在每个仓库中只保留一个', '每个商品只保留一个|每个商品在每个仓库中只保留一个|不限制', '', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableAuditGCAHasUnauditCSCR', '存在未审冷藏收货登记单时禁止审核质量验收单', 'N', 'Y|N', '', '设置为Y时，在审核来货质量验收单时，将检查对应的冷藏药品收货登记单是否都已审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableAuditOwnShopBillNoEWatchCode', '直营连锁单据未扫描监管码禁止审核', 'Y', 'Y|N', '', '设置为Y时，直营连锁流程中的总部配送出库单、分店质量验收单、分店退货单、退货总部验收单中如果有监管商品且未扫描电子监管码时禁止审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableAuditSellOutNoneEWatchCode', '销售出库单据未扫描监管码禁止审核', 'N', 'Y|N', '', '设置为Y时，销售出库流程中的出库复核单中如果有监管商品且未扫描电子监管码时禁止审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableAuditStockInNoneEWatchCode', '采购入库单据未扫描监管码禁止审核', 'Y', 'Y|N', '', '设置为Y时，采购入库流程中的入库复核单中如果有监管商品且未扫描电子监管码时禁止审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableAuditSupplyOutNoneEWatchCode', '配送出库单据未扫描监管码禁止审核', 'N', 'Y|N', '', '设置为Y时，配送出库流程中的配送出库复核单中如果有监管商品且未扫描电子监管码时禁止审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableAuditZeroSalesPrice', '销售开单价格为零时不允许审核', 'N', 'Y|N', '销售', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableBuyFromUnauditedProvider', '禁止从未通过首营审批的供应商采购', 'N', 'Y|N', '', '为Y时在采购订单和来货登记模块中禁止使用未通过首营审批的供应商。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableBuyOutsideOfProvSalesmanLicensed', '禁止采购供方销售员授权商品以外的品种', 'N', 'Y|N', '', '为Y时在采购订单和来货登记模块中禁止录入供方销售员授权商品以外的品种，如果供方销售员未指定授权品种，则表示可销售所有品种。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableBuyProdDateGreaterthanPED', '生产日期超出批准文号有效期禁止采购', 'N', 'Y|N', '', '为Y时，如果生产日期超过了商品资料中的批准文号有效期，禁止采购。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableChangeDeptOnFirstDealApply', '首营申请不允许修改默认部门', 'N', 'Y|N', '', '此选项设为Y时，首营申请的申请部门默认使用当前制单人的所属部门，且不允许修改。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisabledAddDelLineOnCheckAccept', '质量验收单不允许增行删行', 'Y', 'Y|N', '', '此选项设为Y时，在各个质量验收单模块将不允许增加或删除明细行。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableDelAddLineYHJHFromYHYJ', '从养护预警生成的养护计划禁止增行、删行', 'Y', 'Y|N', '', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisabledPchReceiveAddNew', '禁用入库通知单模块的“新增”功能', 'Y', 'Y|N', NULL, '设置为Y时，入库通知单模块的“新增”按钮将被禁用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableInvalidOnModifyCustomer', '修改已通过资质审核的客户资料时不让其审核失效', 'N', 'Y|N', '', '为Y时，修改客户资料时，不会让已通过三级审核的资质失效。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableModifyAuditedDatum', '禁止修改审核合格的资料', 'Y', 'Y|N', '', '此选项设为Y时，已审核合格的资料不允许修改。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableModifyBillDate', '禁止修改单据日期', 'Y', 'Y|N', '', '此选项设为Y时，所有单据的日期禁止手工修改。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableOrderIfProvExpired', '供应商任一证照过期禁止下单', 'Y', 'Y|N', '', '此选项设为Y时，供应商任一证照过期将禁止做采购订单！', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisablePchIfProvExpired', '供应商任一证照过期禁止交易', 'Y', 'Y|N', '', '此选项设为Y时，供应商任一证照过期将禁止做来货登记！', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisablePchSellNoneDDKindGoods', '未指定许可经营类别的商品禁止采购销售', 'N', 'Y|N', '', '此选项设为Y时，未指定许可经营类别的商品禁止采购和销售。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisablePrintWMSExcludeDepts', '不受WMS系统验货打印控制的开单部门', '', '', '', '不受“未经WMS系统验货完成的销售单禁止打印”选项控制的部门列表（部门ID，以逗号分隔多个）', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisablePrintWMSExcludeWareHouse', '不受WMS系统验货打印控制的仓库', '', '', '', '不受“未经WMS系统验货完成的销售单禁止打印”选项控制的仓库列表（仓库ID，以逗号分隔多个）', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisablePrintWMSUnfinishedSelBills', '未经WMS系统验货完成的销售单禁止打印', 'N', 'Y|N', '', '为Y时，销售开单未经WMS系统验货完成时禁止打印。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableResetPrintCount', '禁用“重置打印次数”功能', 'Y', 'Y|N', '', '为Y时，所有单据模块中的“重置打印次数”功能菜单将被禁用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableSellLimitGoods', '禁止向非医疗机构批发限售药品', 'Y', 'Y|N', '', '为Y时，禁止向非医疗机构批发限售医院或门诊的药品；为N时，则仅提示(仍可开单)。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableSellValidateExpired', '商品超过有效期不允许销售', 'N', 'Y|N', '', '此选项设为Y时，则不允许销售超过有效期的商品！', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('DisableUseExclusiveGoodsesOnSelExport', '销售开单禁止开业务员专属商品', 'N', 'Y|N', '', '为Y时在销售开单模块将不能使用指定了专属业务员的商品。', 4);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableBillModifyLocker', '启用单据修改锁定机制', 'Y', 'Y|N', '单机使用请设为N，以提高性能', '将此项设为Y可以防止多个用户同时修改同一单据，保障数据一致性。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableCustFirstDealFourAudit', '启用客户资质、首营企业、品种四级审核', 'N', 'Y|N', '', '此选项设为Y时，客户资质、首营企业、品种将由三级审核变为需要四级审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableCustomersExtendPriv', '客户资料分权限编辑', 'N', 'Y|N', '', '此选项设为Y时，编辑客户资料将区分基本信息修改及业务信息修改权限', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnabledKX', '启用控销检测', 'N', 'Y|N', '', '此选项设为Y时，在销售开单模块将执行控销检测！', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableEWCodeDuorongIntf', '启用电子监管码多融接口', 'N', 'Y|N', '', '此选项设为Y时，电子监管码扫描将使用多网融合接口', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableGoodsesExtendPriv', '商品资料分权限编辑', 'N', 'Y|N', '', '此选项设为Y时，编辑商品资料将区分基本信息修改及业务信息修改权限', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableProvidersExtendPriv', '供应商资料分权限编辑', 'N', 'Y|N', '', '此选项设为Y时，编辑供应商资料将区分基本信息修改及业务信息修改权限', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableShopApplyQtyControl', '启用门店请货数量管控', 'N', 'Y|N', '', '为Y时，无“不管控请货数量”权限的用户在分店请货模块请货的数量不能超过“门店历史销量-门店实时库存”，且必须是5的倍数。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EnableShopDealRangeLimit', '启用本公司及分店许可经营范围限制', 'N', 'Y|N', '', '设置为Y时，在采购时将检查本公司的许可经营范围，在调拨、直营配送时将检查分店的许可经营范围。企业机构资料中编辑许可经营范围。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('EWatchCodeNeedScanQty', '监管码码数获取方式', '3', '1|2|3', '', '1：按数量；2：按件数；3：自动(如果有整件数，则取整件数加散件数，如果没有整件数，取数量。)', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('FirstDealCorp', '新增首营企业资料必填项必须有值', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('FirstDealDatumAuditNeedSelfLogin', '首营资料审批必须是本人登录', 'Y', 'N|Y', '', '设为Y时，首营资料审批时，必须是本人登录并且验证相关岗位权限才可通过。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('FirstDealGoodses', '新增首营药品资料必填项必须有值', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ForbidSaveCreditLimitedSE', '禁止保存信用超限的销售单', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('GMPExpiredDisablePurchase', 'GMP证书过期的商品禁止采购', 'Y', 'Y|N', '', '此选项设为Y时，GMP证书有效期过期的商品禁止在采购计划、采购订单、来货登记等模块中使用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('GMPExpiredDisableSell', 'GMP证书过期的商品禁止销售', 'N', 'Y|N', '', '此选项设为Y时，GMP证书有效期过期的商品禁止在销售订单、销售开单等模块中使用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('GoodsCertPicturesDir', '保存药品证照图片的目录', 'D:\\GoodsCertPic', '', '', '保存药品证照图片的目录，一般由系统选择服务器上空间最大的磁盘并创建名为GoodsCertPic的目录，如非必要，请勿修改。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('Goodses', '新增商品基本资料必填项必须有值', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('GoodsIntegral_Rate*Qty', '商品积分使用“倍率×数量=积分”的规则', 'N', 'Y|N', '', '此选项设为N时，使用“倍率×金额=积分”的规则。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('GoodsSalesPromotionOnlyShowSameCompany', '近效期药品催销表只显示本公司的记录', 'Y', 'N|Y', '', '设为Y时，近效期药品催销表只显示与当前登录用户同一公司的记录。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('GSPPersonNeedValid', '填写GSP相关人员必须验证密码', 'Y', 'Y|N', '', '此选项设为Y时，以下人员需要验证而不能直接输入：编制人员(采购计划)、收货人(来货登记)、发货员/送货员/经手人(冷藏药品运输登记)、验货员/保管员(验收入库/复核)、验货员/复核员(出库登记/复核)、请货人(调拨申请单)', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('HideDetailOnStockPick', '拣货模块不显示明细', 'N', 'Y|N', '', '此选项设为Y时，在仓库物流平台的拣货模块中将不再显示明细记录（以防有人挑单拣货）。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('HideOldGSPModules', '隐藏已停用的GSP旧功能模块', 'Y', 'Y|N', '', '此选项设为Y时，已信用的旧GSP模块将不显示。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('IncEphedrineMonthLimitQtyByShop', '每月每分店含麻药品限量', '100', '100|200|300|500', '', '每个月每个分店可配送的含麻黄碱药品的数量（按主单位计算）。注意：此值只可填整数，填其它内容将引发软件错误！', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('InitWillOutStockInterval', '自动初始化待出库表间隔', '24', '2|4|8|12|24|48|72|120|168|N', '', '客户端登录时，自动初始化待出库表的间隔时间，单位：小时。设置为N时，表示不自动初始化待出库表，可以随时在销售开单模块执行初始化待出库表的操作。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('IntegralExcludeSpecialPriceGoods', '特价商品不参与VIP积分及消费额累加', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LimitPchFromDealinKinds', '仅允许在许可经营范围内进货', 'N', 'Y|N', '', '此选项设为Y时，则做采购订单、来货登记、入库通知单时，所选商品必须属于此列表中的类别(商品未指定许可经营类别则不限制)。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LimitPchFromProvGoods', '仅允许从协议品种中进货', 'N', 'Y|N', '', '此选项设为Y时，如果供应商的协议品种列表不为空，则做采购订单、来货登记、入库通知单时，只能从此列表中选择。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LimitSellOutDealinKinds', '仅允许销售在客户许可经营范围内的商品', 'N', 'Y|N', '', '此选项设为Y时，则做销售订单、销售开单时，所选商品必须属于此客户许可经营列表中的类别(商品未指定许可经营类别则不限制)。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LoadBillListOptions', '加载单号列表选项', '30', '30|0|-1', '', '0：不加载单号；-1：加载当月单据；其它数字：加载指定数的当月单据号。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LockEmpOfNewPurchBill', '锁定采购业务员', 'Y', 'Y|N', '采购单;锁定业务员', '如果此项设置Y，则在采购时只能使用供应商资料中设置的业务员', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LockEmpOfNewSellBill', '锁定销售业务员', 'N', 'Y|N', '销售开单;锁定业务员', '如果此项设置Y，则销售时只能使用客户资料中设置的业务员', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LockPayModeOfNewPurchBill', '锁定采购结算方式', 'Y', 'Y|N', '采购业务;锁定结算方式', '如果此项设置Y，则在采购时只能使用供应商资料中设置的结算方式', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LockPayModeOfNewSellBill', '锁定销售结算方式', 'Y', 'Y|N', '销售业务;锁定结算方式', '如果此项设置Y，则销售时只能使用客户资料中设置的结算方式', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('LowSellProfitNeedSpicalPriv', '销售毛利率低于指定值审核时需要验证特权', 'N', 'Y|N', '10', '请在【关键字】栏中指定最低毛利率(%)', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MaintainPlanAuditOptions', '药品养护检查计划审核后自动转为确定表', 'Y', 'Y|N', '', '此选项设为Y时，药品养护检查计划审核后将自动转为药品养护确定表。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MakerNameMustSelected', '商品资料的生产企业必须从生产企业资料中选择', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MoneyCardInjectNeedRatifier1', '购物卡充值需要店长确认', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MoneyCardInjectNeedRatifier2', '购物卡充值需要经理确认', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MustInputInvoiceOnPchCheckIn', '来货时必须录入随货同行发票信息', 'Y', 'Y|N', '', '此选项设为Y时，在做来货登记时必须录入发票信息才可以审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MustSelectLinkManOnPurchase', '进货时必须选择供方销售人员', 'N', 'Y|N', '', '此选项设为Y时，则在采购询价单、采购订单、来货登记单、购进退出单保存时自动检测是否已选择了供方销售人员资料（原联系人）。如未选择，则不允许保存。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('MustSelectLinkManOnSell', '销售时必须选择客户采购人员', 'N', 'Y|N', '', '此选项设为Y时，则在销售报价单、销售订单、销售开单、销退登记单保存时自动检测是否已选择了客户采购人员资料（原联系人）。如未选择，则不允许保存。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NearPeriodDisableSellDays', '近效期禁销天数', '30', '30|60|90|180|0', '', '选择或输入天数，设置天数内将过期的商品禁止批发开单，输入0表示不启用禁销功能。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NearPeriodDisableSupplyDays', '近效期禁止配送天数', '30', '30|60|90|180|0', '', '选择或输入天数，设置天数内将过期的商品禁止配送给门店，输入0表示不启用此功能。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NeedConsignee2OnPchCheckIn', '特殊药品来货需要填写第二收货人', 'Y', 'Y|N', '', '此选项设为Y时，包含特殊药品的来货登记单需要填写第二收货人才可以审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NeedConsignee2OnSelRetCheckIn', '特殊药品销退登记需要填写第二收货人', 'Y', 'Y|N', '', '此选项设为Y时，包含特殊药品的销退登记单需要填写第二收货人才可以审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NeedDeliverOfSelExport', '销售单默认需要送货', 'N', 'Y|N', '销售发货;送货', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NeedDeliverOfShopSupply', '配送单默认需要送货', 'N', 'Y|N', '门店配送;送货', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NeedSPOfModifySelExportGiftQty', '修改销售发货单赠品数量需要特权', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NetOrderNoCheck', '网上订货不使用验收流程', 'N', 'Y|N', '', '此选项设为Y时，发货单上传后不需门店验收即自动完成订单。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NetOrderToSellOrderUseCustPrice', '网上订单转为销售订单时使用协议价', 'N', 'Y|N', '', 'Y：将使用客户协议作为销售订单上的价格。如无协议价，则使用网上订单上的价格。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NoLimitPriceOnPchReturnFreeMode', '购进退回在自由退货模式下不限制价格', 'N', 'Y|N', '', '为N时在购进退回的自由退货模式下，会自动将价格限制为同批号最近一次进货的价格。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NoScanRangeLimitOnGoodsesStockInfo', '商品资料模块的库存信息不限制浏览范围', 'N', 'Y|N', '', '为Y时在商品资料模块的库存信息页，将不按浏览权限限制范围', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NoScanRangeLimitOnGoodsInOutQuery', '商品出入库查询模块不限制浏览范围', 'N', 'Y|N', '', '为Y时，商品出入库查询模块将不受资料浏览权限范围限制', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NoScanRangeLimitOnStockMoveApplyDepots', '调拨申请单、店间调出单选择仓库不限制浏览范围', 'N', 'Y|N', '', '为Y时调拨申请单、店间调出单选择仓库时，将不按浏览权限限制范围', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('NoScanRangeLimitOnStockMoveDepots', '调拨单选择仓库不限制浏览范围', 'N', 'Y|N', '', '为Y时调拨单选择仓库时，将不按浏览权限限制范围', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('Notify8888OnPosLimitOperate', 'POS发生受限操作时通知8888用户', 'N', 'Y|N', '', '此选项设为Y时，POS端发生启动、退货、作废、删行、关闭等操作时给8888发送消息。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OnlyBuyFromHasAuditedSellmanProvider', '仅允许从有审核合格的销售人员的供应商采购', 'N', 'Y|N', '', '为Y时在采购计划、订单和来货登记等模块中禁止没有审核合格的供方销售人员的供应商。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OnlyReturnBillCanGathering', '仅已回单的发货单允许生成收款单', 'N', 'Y|N', '销售', '', 1);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OnlySellForIsValidCustomer', '仅允许对资质审核合格的客户销售', 'N', 'Y|N', '', '此选项设为Y时，则在做销售订单、销售开单选择客户时，只允许选择资质审核已合格的客户资料。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OnlySPUserUpdGoodsTiCheng', '仅允许特权用户修改商品提成率', 'Y', 'Y|N', '', '为Y时，只允许具有商品资料模块特权的用户修改商品提成率；为N时则无限制。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OperatorPopedomChangedNeedAudit', '操作员权限修改后需要审核', 'N', 'Y|N', '', '此选项设为Y时，用户的权限被修改后，必须经过审核才可以登录（审核操作员权限，需要有操作员权限管理模块的特权）。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OverflowWastageNeedQCAndCWAudit', '报损报溢单需经质管和财务审核后才能审核', 'N', 'Y|N', '', '此选项设为Y时，报损报溢单需经质管和财务审核后才能审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OwnShopApplyStockRangeLimitKind', '直营连锁分店请货时库存范围限制方式', '按用户权限', '按用户权限|不限制总部仓库|不限制', '', '用户权限即操作员的资料浏览范围；不限制总部仓库：表示除总部仓库以外按用户权限来限制；不限制：显示所有仓库的库存，不检查用户浏览范围。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('OwnShopAutoFillShopCheckIn', '直营连锁生成分店质量验收单时自动填写所有字段', 'Y', 'Y|N', '', '设置为N时，直营连锁总部配送出库单转为分店质量验收单时不自动填写：生产批号、生产日期、有效期及验收结论。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PassNoExpiredDisablePurchase', '批准文号有效期过期的商品禁止采购', 'Y', 'Y|N', '', '此选项设为Y时，批准文号有效期过期的商品禁止在采购计划、采购订单、来货登记等模块中使用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PassNoExpiredDisableSell', '批准文号有效期过期的商品禁止销售', 'N', 'Y|N', '', '此选项设为Y时，批准文号有效期过期的商品禁止在销售订单、销售开单等模块中使用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PassNoRegularLimit', '批准文号规则化录入管控', 'N', 'N|Y', '', '设为Y时，首营企业和商品资料中录入批准文号的度只能是两种情况：17字节 或 25字节。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PchCheckInMustFromPchOrder', '来货登记商品必须与采购订单相对应', 'Y', 'Y|N', '', '此选项设为Y时，来货登记明细中的商品必须来源于对应的采购订单，且来货数量不能大于订单数量。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PchOrderPchPlanDefaultInvalidDays', '采购计划、采购订单默认失效天数', '7', '3|7|9|15', '', '采购计划、采购订单失效日期的默认天数，请输入整数。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PchPlanShowGoodsIOS', '采购计划启用商品进销存简表', 'Y', 'Y|N', '', '为Y时，在采购计划明细中双击显示商品进销存简表', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PchPlan_ShowAllStock', '采购计划的现有库存显示总库存', 'N', 'Y|N', '', '该项为Y时，采购计划编制向导里的现有库存字段将显示商品的总库存。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PchReturnNeedQCAndCWAudit', '购进退回需经质管和财务审核后才能审核', 'N', 'Y|N', '', '此选项设为Y时，购进退回单需经质管和财务审核后才能审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PchSettleToPayUseSettleDate', '采购结算单转付款时沿用结算日期', 'N', 'Y|N', '', '为Y时，付款单使用结算单日期；为N时，付款单使用当前日期。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PreferUsingNewClientSystem', '优先使用新客户端系统', 'N', 'Y|N', '', '此选项设为Y时，将优先使用新客户端系统。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PrintPchReceiveAfterStockIn', '完成相关药品入库后才能打印采购单', 'N', 'Y|N', '采购单;打印', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PrintPchReturnAfterStockIn', '完成相关药品出库后才能打印采购退货单', 'N', 'Y|N', '采购退货单;打印', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PrintSelExportAfterStockOut', '完成相关药品出库后才能打印销售发货单', 'N', 'Y|N', '销售发货单;打印', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('PrintSelReturnAfterStockOut', '完成相关药品入库后才能打印销售退货单', 'N', 'Y|N', '销售退货单;打印', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ProvCustCertPicturesDir', '保存客商证照图片的目录', 'D:\\ProvCustCertPic', '', '', '保存客商证照图片的目录，一般由系统选择服务器上空间最大的磁盘并创建名为ProvCustCertPic的目录，如非必要，请勿修改。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ProvCustDealMode', '客商运营方式', '普通', '普通|特殊', '', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ProvCustIDCardNoAllowRepeat', '客商人员身份证号允许重复', 'Y', 'Y|N', '', '此选项设为Y时，客商人员身份证号允许重复。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RecipeRegPic', '保存处方登记表的处方图片的目录', 'D:\\RecipeRegPic', '', '', '保存处方登记表的处方图片的目录，一般由系统选择服务器上空间最大的磁盘并创建名为RecipeRegPic的目录，如非必要，请勿修改。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RejectConfirmReportNeedValid', '不合格药品报告确认表各负责人需要验证', 'Y', 'Y|N', '', '此选项设为Y时，输入不合格药品报告确认表中的各个负责人需要验证密码。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RejectLostAuditNeedValid', '不合格药品报损审核表各负责人需要验证', 'Y', 'Y|N', '', '此选项设为Y时，输入不合格药品报损审核表中的各个负责人需要验证密码。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RetailAuditStockOutByItem', '启用POS过帐单项出库', 'N', 'Y|N', '', '零售过帐库存不足时，有库存的项先出库', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ReturnMustCallOriginalBill', '采购和销售退货只允许按单退货', 'N', 'Y|N', '', '此选项设为Y时，采购和销售退货只能选择原单明细来退货。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RS_AllowSOFreeTurnBill', '委托销售时，允许销售订单自由转单', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RS_AutoUploadSOAfterAudited', '委托销售时，在销售订单审核后自动上传为报货单', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RS_DisableDelPchCheckInBills', '来货登记单被标记为委托销售时不允许删除', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RS_DisableEditPchCheckInBills', '来货登记单被标记为委托销售时不允许修改', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('RS_OnlyAllowRevertUnconfirmedSO', '委托销售时，仅允许反审核未处理的销售订单', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SCXKZExpiredDisablePurchase', '生产许可证过期的商品禁止采购', 'Y', 'Y|N', '', '此选项设为Y时，生产许可证有效期过期的商品禁止在采购计划、采购订单、来货登记等模块中使用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SCXKZExpiredDisableSell', '生产许可证过期的商品禁止销售', 'N', 'Y|N', '', '此选项设为Y时，生产许可证有效期过期的商品禁止在销售订单、销售开单等模块中使用。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SelExportRecQueryBigDataLimit', '商品销售记录查询启用大数据条件限制', 'Y', 'Y|N', '', '为“Y”时，如果查询的时间跨度大于31天，则必须指定至少一个其它查询条件。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SelExportUnderCostNeedValidPopedom', '销售开单低于成本价时需要授权', 'N', 'Y|N', '', '此选项设为Y时，销售开单低于成本价时需要验证“可授权亏本销售”的用户。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SellReturnNoCargoFlowCheck', '销售退货不验货直接审核', 'N', 'Y|N', '', '此选项设为Y时，销售退货生成的出库单不走物流验货，直接审核', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SellSelectBatchByUsableQty', '销售开单按可用量选批号', 'Y', 'Y|N', '', 'Y：选批号时检测可用库存；N：选批号时检测实际库存', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SellWholeReturnDisableChangePrice', '销售按原单退货时不允许修改价格和批号', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SelOrderToExportByInvoiceKind', '销售订单转单时按开票类型分单', 'N', 'Y|N', '', '为Y时，销售订单转为销售开单时，将商品资料中的开票类型分单。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SelReturnMustFromSelRetDemand', '销售退回登记单只能由审核后的销售退回申请单生成', 'Y', 'Y|N', '销售退回登记', NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SelSettleToPayUseSettleDate', '销售结算单转收款时沿用结算日期', 'N', 'Y|N', '', '为Y时，收款单使用结算单日期；为N时，收款单使用当前日期。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SetPchCheckInDateToCheckDate', '验收时将验收日期设为来货日期', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ShopDisplayGoodsQCOnlyShowSameCompany', '门店陈列药品质量检查只显示本公司的记录', 'Y', 'N|Y', '', '设为Y时，门店陈列药品质量检查记录只显示与当前登录用户同一公司的记录。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ShowDepotStockQtyOnPriceAdjust', '在商品调价明细中显示各库库存', 'N', 'Y|N', '', '', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ShowRealStockOnAdjustPrice', '调价时显示所在公司的实时库存', 'N', 'Y|N', '', '此选项设为Y时，商品调价单明细上将显示当前登录用户所属公司的仓库中的实时库存。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ShowStockDtlOnSelReturnSelectItmes', '销售退货选择原单时显示相应出库复核记录', 'Y', 'N|Y', '', '设为Y时，销售退货勾选原单时，将显示与所选销售单对应的出库复核记录。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ShowUnauditedGoodsNeedSP', '显示未审核的商品资料需要特权', 'N', 'Y|N', '', '如果设置为Y，在商品资料模块需要有“特权”才能查看全部商品或未审核的商品。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SpecialDrugNeedChecker2OnCheckAccept', '特殊药品验收需要填写第二验收人', 'Y', 'Y|N', '', '此选项设为Y时，包含特殊药品的质量验收单需要填写第二验收人才可以审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('StockinNeedBatchNo', '商品入库时必须填写批号', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('StockinNeedProdDate', '商品入库时必须填写生产日期', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('StockLackSelOrderDisableAudit', '销售订单检测到库存不足时禁止审核', 'Y', 'Y|N', '', '在“销售订单审核时检测库存”选项为Y的情况下，如果库存检测发现问题，则禁止审核销售订单。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('StockOutBillUseSelExportBillOwner', '销售单转为出库复核单时沿用销售单上的创建人及所属部门', 'Y', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('SupplyReturnNoCargoFlowCheck', '配送退货不验货直接审核', 'Y', 'Y|N', '', '此选项设为Y时，配送退货将不走验货流程，直接审核。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('TeardownRegisterOnlyShowSameCompany', '药品拆零登记表只显示本公司的拆零记录', 'Y', 'N|Y', '', '设为Y时，药品拆零登记表只显示与当前登录用户同一公司的人员拆零的记录。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('UpdCustPriceOnSelExportSaved', '在销售单保存时更新客户协议价', 'N', 'Y|N', NULL, NULL, 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('UpdGoodsBerthOnStockCheck', '盘点入库时更新商品存放货位', 'N', 'Y|N', '', '为Y时，每次盘点入库将使用输入的货位更新商品的存放货位资料。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('UpdGoodsBerthOnStockIn', '采购入库时更新商品存放货位', 'N', 'Y|N', '', '为Y时，每次采购入库将使用输入的货位更新商品的存放货位资料。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('UseCargoFlowInCheck', '使用入库验货流程', 'N', 'Y|N', '', '此选项设为Y时，入库单必须经过物流验货后才可审核', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('UseCargoFlowOutCheck', '使用出库验货流程', 'N', 'Y|N', '', '此选项设为Y时，出库单必须经过物流验货后才可审核', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ValidForEverySellSortPrint', '为每次销售拣货打印验证责任人', 'N', 'Y|N', '', 'Y：登录后，每次销售拣货打印前验证用户身份；N：仅第一次打印验证身份', 2);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ValidInDepotBerthOnPchCheckInToReceive', '来货登记转入库通知时检测存放库位', 'N', 'Y|N', '', '设置为Y时，在来货登记转到入库通知单时，将检测每一个品种是否有指定收货仓库及货位，如果存在没有指定则不能转单。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ValidSPForCargoFlowModifyBill', '物流平台的改单操作需要验证特权', 'Y', 'Y|N', '', '此选项设为Y时，物流平台中出库验货模块的改单操作，需要验证特权用户。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ValidUserForCheckAcceptDefaultParam', '质量验收默认设置中的人员设置需验证其身份', 'N', 'Y|N', '', '此选项设为Y时，在采购、销退、配送退货质量验收默认设置模块设置验收员（质检员）、收货人等信息时，需要验证被设置人员的用户身份。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('ValidUserForGoodsCheckAcceptChecker', '修改质量验收人员需验证其身份', 'N', 'Y|N', '', '此选项设为Y时，在采购、销退、配送退货的所有质量验收模块修改验收员信息时，需要验证验收人员的用户身份。', 0);
INSERT INTO `qfyu_sys_config_bak` VALUES ('VIPIntegralModifyNeedSP', '后台修改VIP积分需要特权', 'Y', 'Y|N', '', '', 0);

-- ----------------------------
-- Table structure for qfyu_sys_depart
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_depart`;
CREATE TABLE `qfyu_sys_depart`  (
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门参考表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_depart
-- ----------------------------
INSERT INTO `qfyu_sys_depart` VALUES ('采购部', NULL);
INSERT INTO `qfyu_sys_depart` VALUES ('销售部', NULL);
INSERT INTO `qfyu_sys_depart` VALUES ('财务部', NULL);
INSERT INTO `qfyu_sys_depart` VALUES ('人事部', NULL);

-- ----------------------------
-- Table structure for qfyu_sys_dosage
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_dosage`;
CREATE TABLE `qfyu_sys_dosage`  (
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '剂型参考表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_dosage
-- ----------------------------
INSERT INTO `qfyu_sys_dosage` VALUES ('搽剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('滴鼻剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('滴眼剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('酊剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('混悬剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('胶囊剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('酒剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('颗粒剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('口服溶液', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('膜剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('凝胶剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('喷雾剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('片剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('其他', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('气粉雾剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('乳剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('软膏剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('散剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('栓剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('糖浆剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('透皮贴剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('丸剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('洗剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('眼膏剂', NULL);
INSERT INTO `qfyu_sys_dosage` VALUES ('注射剂', NULL);

-- ----------------------------
-- Table structure for qfyu_sys_duties
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_duties`;
CREATE TABLE `qfyu_sys_duties`  (
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '职务参考表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_sys_illness
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_illness`;
CREATE TABLE `qfyu_sys_illness`  (
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`value`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '疾病参考表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_illness
-- ----------------------------
INSERT INTO `qfyu_sys_illness` VALUES ('乙肝', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('冠心病 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('前列腺炎  ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('哮喘', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('器官移植抗排治疗', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('尿毒症', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('恶性肿瘤术后放疗', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('慢性支气管炎 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('慢性结肠炎', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('慢性胃炎  ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('慢性胰腺炎', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('癫痫', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('盆腔炎 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('神经性头痛', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('神经衰弱  ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('类风湿性关节炎  ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('精神病 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('糖尿病 NOS', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('系统性红斑狼疮  ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('肝硬化 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('肺心病 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('肺结核 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('肾病', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('肾结石 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('胃溃疡 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('胆囊炎 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('胆结石 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('胸膜炎 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('脑血栓及脑血管意外后遗症 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('腰椎间盘突出 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('造血系统疾病 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('颈椎病 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('风湿性心脏病 ', NULL);
INSERT INTO `qfyu_sys_illness` VALUES ('高血压 ', NULL);

-- ----------------------------
-- Table structure for qfyu_sys_order_reason
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_order_reason`;
CREATE TABLE `qfyu_sys_order_reason`  (
  `value` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`value`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '优先发货原因' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_sys_sales_category
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_sales_category`;
CREATE TABLE `qfyu_sys_sales_category`  (
  `value` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '控销类别管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_sales_category
-- ----------------------------
INSERT INTO `qfyu_sys_sales_category` VALUES ('控销类别1', NULL);

-- ----------------------------
-- Table structure for qfyu_sys_trades
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_trades`;
CREATE TABLE `qfyu_sys_trades`  (
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '行业参考表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_sys_unit
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_unit`;
CREATE TABLE `qfyu_sys_unit`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '值',
  `remark` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '商品计量单位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_sys_unit
-- ----------------------------
INSERT INTO `qfyu_sys_unit` VALUES (1, '把', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (2, '包', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (3, '袋', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (4, '对', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (5, '个', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (6, '合', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (7, '盒', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (8, '件', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (9, '克', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (10, '粒', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (11, '片', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (12, '瓶', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (13, '千克', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (14, '条', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (15, '箱', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (16, '支', NULL);
INSERT INTO `qfyu_sys_unit` VALUES (17, '只', NULL);

-- ----------------------------
-- Table structure for qfyu_sys_words
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_sys_words`;
CREATE TABLE `qfyu_sys_words`  (
  `value` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remark` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '常用文字' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_user
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_user`;
CREATE TABLE `qfyu_user`  (
  `id` int(11) NOT NULL,
  `uname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录口令',
  `code` char(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `organization_code` char(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织机构编码',
  `status` tinyint(4) NOT NULL COMMENT '0表示禁用',
  `add_time` int(11) NOT NULL COMMENT '添加时间',
  `re_time` int(11) NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_ware_locked
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_ware_locked`;
CREATE TABLE `qfyu_ware_locked`  (
  `ware_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库编号',
  `bill_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '盘点单号',
  `lock_time` datetime(0) NULL DEFAULT NULL COMMENT '锁仓时间',
  UNIQUE INDEX `ware_code_2`(`ware_code`, `bill_no`) USING BTREE,
  INDEX `ware_code`(`ware_code`) USING BTREE,
  INDEX `bill_no`(`bill_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库锁定' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_ware_position
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_ware_position`;
CREATE TABLE `qfyu_ware_position`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键 库位编号',
  `pos_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位编码',
  `ware_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库编码',
  `pos_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所属区域',
  `pos_desc` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '位置描述',
  `pos_deposit` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '存放描述',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `pos_long` decimal(10, 2) NULL DEFAULT NULL COMMENT '长度',
  `pos_width` decimal(10, 2) NULL DEFAULT NULL COMMENT '宽度',
  `pos_height` decimal(10, 2) NULL DEFAULT NULL COMMENT '高度',
  `pos_unit` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '(长宽高)单位',
  `pos_weight` decimal(10, 2) NULL DEFAULT NULL COMMENT '货位可承重量',
  `pos_unit1` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '(可承重量)单位',
  `isstock` tinyint(1) NULL DEFAULT NULL COMMENT '库存可用 1库存可用',
  `inventory_date` date NULL DEFAULT NULL COMMENT '上次盘存日期',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建日期',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `updater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `pos_code`(`pos_code`) USING BTREE,
  INDEX `ware_code`(`ware_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '库位管理信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_ware_position
-- ----------------------------
INSERT INTO `qfyu_ware_position` VALUES (1, 'WP001', 'CK001', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-10-29', '2020-10-29 09:34:22', '001', '2020-10-29 09:34:22', '001');
INSERT INTO `qfyu_ware_position` VALUES (2, 'WP002', 'CK001', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-10-30', '2020-10-30 18:52:06', '001', '2020-10-30 18:52:06', '001');
INSERT INTO `qfyu_ware_position` VALUES (3, 'WP003', 'CK001', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-10-30', '2020-10-30 18:52:58', '001', '2020-10-30 18:52:58', '001');
INSERT INTO `qfyu_ware_position` VALUES (4, 'WP004', 'CK001', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-10-30', '2020-10-30 18:54:13', '001', '2020-10-30 18:54:13', '001');
INSERT INTO `qfyu_ware_position` VALUES (5, 'WP005', 'CK001', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-10-30', '2020-10-30 18:56:09', '001', '2020-10-30 18:56:09', '001');
INSERT INTO `qfyu_ware_position` VALUES (6, 'WP006', 'CK001', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-10-30', '2020-10-30 18:59:07', '001', '2020-10-30 18:59:07', '001');
INSERT INTO `qfyu_ware_position` VALUES (7, 'WP007', 'CK006', '', '', '', '', 0.00, 0.00, 0.00, '米', 300.00, '千克', 1, '2020-11-02', '2020-11-02 17:27:08', '001', '2020-11-02 00:00:00', '001');
INSERT INTO `qfyu_ware_position` VALUES (8, 'WP008', 'CK006', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 0, '2020-11-02', '2020-11-02 17:27:17', '001', '2020-12-03 16:14:06', '001');
INSERT INTO `qfyu_ware_position` VALUES (9, 'WP009', 'CK005', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-11-02', NULL, '001', NULL, '001');
INSERT INTO `qfyu_ware_position` VALUES (10, 'WP0010', 'CK004', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-11-02', NULL, '001', NULL, '001');
INSERT INTO `qfyu_ware_position` VALUES (11, 'WP0011', 'CK003', '', 'aaaaaaaaaaaaaaaaa', 'dfgagfda', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-11-02', NULL, '001', '2020-12-17 09:18:03', '001');
INSERT INTO `qfyu_ware_position` VALUES (12, 'WP0012', 'CK002', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-11-02', NULL, '001', NULL, '001');
INSERT INTO `qfyu_ware_position` VALUES (13, 'WP0013', 'CK007', '广东省深圳市', 'aaaaaaaa', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-11-16', '2020-11-16 08:53:39', '001', '2020-12-03 15:09:20', '001');
INSERT INTO `qfyu_ware_position` VALUES (14, 'WP0014', 'CK007', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-12-03', '2020-12-03 15:09:31', '001', '2020-12-03 15:10:32', '001');
INSERT INTO `qfyu_ware_position` VALUES (15, 'WP0015', 'CK008', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-12-04', '2020-12-04 13:38:14', '001', '2020-12-04 13:38:14', '001');
INSERT INTO `qfyu_ware_position` VALUES (16, 'WP0016', 'CK0010', '', '', '', '', 0.00, 0.00, 0.00, '', 0.00, '', 1, '2020-12-04', '2020-12-04 14:04:18', '001', '2020-12-04 14:04:18', '001');

-- ----------------------------
-- Table structure for qfyu_warehouse
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_warehouse`;
CREATE TABLE `qfyu_warehouse`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ware_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编码',
  `parent_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '上级仓库编码',
  `pos_code` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '默认库位（库位编码）',
  `ware_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库名称',
  `ware_deptid` int(10) NOT NULL COMMENT '部门ID',
  `ware_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库面积',
  `retail_pid` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '零售价格方案',
  `move_pid` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '移库价格方案',
  `limit_pid` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '限定售价方案',
  `user_pid` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '会员价格方案',
  `phone` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '电话',
  `fax` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '传真',
  `ware_empid` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库管理员ID',
  `ware_examid` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '仓库验货员ID',
  `region` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '所在地区',
  `address` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  `storage_id` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '储存属性',
  `type_id` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '仓库类别',
  `canbyonline` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否可网购 1可网购',
  `canbyonsale` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否可销售 1可销售',
  `canheadoffice` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否总部仓库 1总部仓库',
  `canvirtual` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否虚拟分级仓 1虚拟分级仓',
  `cancomplete` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '是否整件仓 1整件仓',
  `cannotice` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '销售时警告 1销售发货时警告用户',
  `status` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '仓库状态 0 停用 1启用',
  `candel` tinyint(1) UNSIGNED NULL DEFAULT 1 COMMENT '删除状态 0 删除 1正常',
  `add_date` datetime(0) NOT NULL COMMENT '添加时间',
  `update_date` datetime(0) NOT NULL COMMENT '修改时间',
  `creator` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建者',
  `updater` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新者',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ware_code`(`ware_code`) USING BTREE,
  INDEX `ware_deptid`(`ware_deptid`) USING BTREE,
  INDEX `ware_empid`(`ware_empid`) USING BTREE,
  INDEX `ware_examid`(`ware_examid`) USING BTREE,
  INDEX `status`(`status`) USING BTREE,
  INDEX `candel`(`candel`) USING BTREE,
  INDEX `canbyonline`(`canbyonline`) USING BTREE,
  INDEX `canbyonsale`(`canbyonsale`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '仓库资料信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qfyu_warehouse
-- ----------------------------
INSERT INTO `qfyu_warehouse` VALUES (4, 'CK001', '0', 'WP001', '广东重点仓库', 8, '', 0, 0, 0, 0, '', '', '004', '001', '', '', '', 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, '2020-10-29 09:34:22', '2020-12-04 13:39:17', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (5, 'CK002', '0', '', '深圳福田仓', 8, '300平米', 1, 1, 2, 1, '', '', '0', '0', '', '', '', 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, '2020-10-30 18:52:06', '2020-10-30 18:52:06', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (6, 'CK003', '0', '', '广东惠州仓', 2, '', 1, 1, 2, 1, '', '', '0', '0', '', '', '', 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, '2020-10-30 18:52:58', '2020-10-30 18:52:58', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (7, 'CK004', '0', '', '江西赣州仓', 5, '', 1, 1, 0, 0, '', '', '0', '0', '江西赣州市', '', '兴国县', 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, '2020-10-30 18:54:13', '2020-10-30 18:54:13', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (8, 'CK005', '0', 'WP009', '陕西西安分仓', 3, '5000平米', 1, 1, 1, 0, '', '', '007', '008', '陕西西安市', '西安市莲湖区城西客运站500米', '仓库贵重物品，请妥善保管', 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, '2020-10-30 18:56:09', '2020-12-17 10:56:14', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (9, 'CK006', 'CK001', 'WP007', '广西桂林仓库', 2, '6000平米', 0, 0, 0, 0, '0755-88888888', '0755-88888888', '008', '006', '广西南宁市', '广西南宁市北大街90号', '', 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, '2020-10-30 18:59:07', '2020-12-03 16:06:09', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (13, 'CK007', 'CK001', 'WP0013', '深圳仓', 5, '', 0, 0, 0, 0, '', '', '007', '002', '', '', '', 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, '2020-11-16 08:53:39', '2020-12-04 13:39:52', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (14, 'CK008', 'CK001', '', '佛山仓', 2, '', 0, 0, 0, 0, '', '', '0', '0', '', '', '', 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, '2020-12-04 13:38:13', '2020-12-04 13:39:45', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (15, 'CK009', '0', '', '江西库', 8, '', 0, 0, 0, 0, '', '', '0', '0', '', '', '', 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, '2020-12-04 13:46:02', '2020-12-04 13:46:02', '001', '001');
INSERT INTO `qfyu_warehouse` VALUES (16, 'CK0010', 'CK001', '', '惠州仓', 6, '', 0, 0, 0, 0, '', '', '0', '0', '', '', '', 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, '2020-12-04 14:04:18', '2020-12-04 14:04:18', '001', '001');

-- ----------------------------
-- Table structure for qfyu_whole_stock
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_whole_stock`;
CREATE TABLE `qfyu_whole_stock`  (
  `bill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '结存单编号',
  `ware_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '仓库编号',
  `empno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '经手人编号',
  `auditno` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审单员编号',
  `transfer` tinyint(1) NULL DEFAULT 0 COMMENT '是否已审核 1已审核 0未审核',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `creater` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `f_date` datetime(0) NULL DEFAULT NULL COMMENT '单据日期',
  `create_date` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `mender` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '修改人',
  `update_date` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `grup` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源所属组',
  PRIMARY KEY (`bill_no`) USING BTREE,
  INDEX `ware_code`(`ware_code`) USING BTREE,
  INDEX `transfer`(`transfer`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '整仓盘点单' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for qfyu_whole_stock_detail
-- ----------------------------
DROP TABLE IF EXISTS `qfyu_whole_stock_detail`;
CREATE TABLE `qfyu_whole_stock_detail`  (
  `bill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '盘点单编号',
  `item_no` int(10) NULL DEFAULT NULL COMMENT '序号',
  `goods_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品编号',
  `pos_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '货位编号',
  `sup_code` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `batch_no` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '批次号',
  `pro_date` date NULL DEFAULT NULL COMMENT '生产日期',
  `valid_date` date NULL DEFAULT NULL COMMENT '有效期',
  `qty1` decimal(15, 5) NULL DEFAULT NULL COMMENT '主单位库存',
  `qty2` decimal(15, 5) NULL DEFAULT NULL COMMENT '辅单位库存',
  `price1` decimal(16, 6) NULL DEFAULT NULL COMMENT '主单位价格',
  `price2` decimal(16, 6) NULL DEFAULT NULL COMMENT '辅单位价格',
  `amount` decimal(16, 6) NULL DEFAULT NULL COMMENT '库存总价值',
  `rqty1` decimal(15, 5) NULL DEFAULT NULL COMMENT '主单位实际库存',
  `rqty2` decimal(15, 5) NULL DEFAULT NULL COMMENT '辅单位实际库存',
  `ramount` decimal(16, 6) NULL DEFAULT NULL COMMENT '实际库存总价值',
  `diffqty1` decimal(15, 5) NULL DEFAULT NULL COMMENT '主单位库存差值',
  `diffqty2` decimal(15, 5) NULL DEFAULT NULL COMMENT '辅单位库存差值',
  `diffamount` decimal(16, 6) NULL DEFAULT NULL COMMENT '总价值差值',
  `selprice` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考批发价',
  `rtlprice` decimal(16, 6) NULL DEFAULT NULL COMMENT '参考零售价',
  `pbill_no` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '上一步骤编号',
  `pitem_no` int(10) NULL DEFAULT NULL COMMENT '对应上一步骤序号',
  `stock_id` int(10) NULL DEFAULT NULL COMMENT '库存详情表id',
  `update_ver` bigint(10) NULL DEFAULT NULL COMMENT '防止详情未修改保存失败',
  UNIQUE INDEX `bill_no_2`(`bill_no`, `item_no`) USING BTREE,
  INDEX `bill_no`(`bill_no`) USING BTREE,
  INDEX `pbill_no`(`pbill_no`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '整仓盘点详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- View structure for qfyu_commodity_list
-- ----------------------------
DROP VIEW IF EXISTS `qfyu_commodity_list`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `qfyu_commodity_list` AS select `c`.`id` AS `id`,`c`.`goods_code` AS `goods_code`,`c`.`goods_name` AS `goods_name`,`c`.`name` AS `name`,`c`.`en_name` AS `en_name`,`c`.`code` AS `code`,`c`.`file_name` AS `file_name`,`c`.`pym` AS `pym`,`c`.`specs` AS `specs`,`c`.`packspecs` AS `packspecs`,`c`.`electron_code` AS `electron_code`,`c`.`color_code` AS `color_code`,`c`.`kinds_id` AS `kinds_kid`,`c`.`category_id` AS `category_id`,`c`.`function_id` AS `function_id`,`c`.`top_fid` AS `top_fid`,`c`.`parent_fid` AS `parent_fid`,`c`.`origin` AS `origin`,`c`.`production` AS `production`,`c`.`maker` AS `maker`,`c`.`unit` AS `unit`,`c`.`unit2` AS `unit2`,`c`.`is_solit` AS `is_solit`,`c`.`solit_value` AS `solit_value`,`c`.`dosage` AS `dosage`,`c`.`tax` AS `tax`,`c`.`approval_code` AS `approval_code`,`c`.`approval_date` AS `approval_date`,`c`.`shelf_life` AS `shelf_life`,`c`.`shelf_unit` AS `shelf_unit`,`c`.`take` AS `take`,`c`.`gsp_type` AS `gsp_type`,`c`.`standard_code` AS `standard_code`,`c`.`supervise_code` AS `supervise_code`,`c`.`pack_specs1` AS `pack_specs1`,`c`.`pack_specs2` AS `pack_specs2`,`c`.`drug` AS `drug`,`c`.`drug_unit` AS `drug_unit`,`c`.`hours` AS `hours`,`c`.`element_type` AS `element_type`,`c`.`coloc_type` AS `coloc_type`,`c`.`billing_type` AS `billing_type`,`c`.`pifaml` AS `pifaml`,`c`.`retail` AS `retail`,`c`.`depart_id` AS `depart_id`,`c`.`markup` AS `markup`,`c`.`is_medical` AS `is_medical`,`c`.`is_check` AS `is_check`,`c`.`is_qty` AS `is_qty`,`c`.`is_first` AS `is_first`,`c`.`is_variety` AS `is_variety`,`c`.`is_rx` AS `is_rx`,`c`.`is_shopping` AS `is_shopping`,`c`.`is_yi` AS `is_yi`,`c`.`is_yymz` AS `is_yymz`,`c`.`is_vip` AS `is_vip`,`c`.`is_supervise` AS `is_supervise`,`c`.`is_drugs` AS `is_drugs`,`c`.`is_gift` AS `is_gift`,`c`.`status` AS `status`,`c`.`creater` AS `creater`,`c`.`creater_date` AS `creater_date`,`c`.`checker` AS `checker`,`c`.`updater_code` AS `updater_code`,`c`.`check_date` AS `check_date`,`c`.`updater_date` AS `updater_date`,`c`.`remark` AS `remark`,`e`.`abc` AS `abc`,`e`.`abkind` AS `abkind`,`e`.`brand` AS `brand`,`e`.`brand_date` AS `brand_date`,`e`.`code1` AS `code1`,`e`.`code1_date` AS `code1_date`,`e`.`code2` AS `code2`,`e`.`code2_date` AS `code2_date`,`e`.`custom_code1` AS `custom_code1`,`e`.`custom_code2` AS `custom_code2`,`e`.`custom_code3` AS `custom_code3`,`e`.`custom_name` AS `custom_name`,`e`.`custom_val` AS `custom_val`,`e`.`quality_standards` AS `quality_standards`,`e`.`quality_date` AS `quality_date`,`e`.`exterior` AS `exterior`,`e`.`gmp_code` AS `gmp_code`,`e`.`gmp_end_date` AS `gmp_end_date`,`e`.`gmp_property` AS `gmp_property`,`e`.`level` AS `level`,`e`.`license_key` AS `license_key`,`e`.`license_date` AS `license_date`,`e`.`start_give_amount` AS `start_give_amount`,`e`.`give_amount` AS `give_amount`,`e`.`times_give` AS `times_give`,`e`.`give_date` AS `give_date`,`e`.`integral` AS `integral`,`s`.`salesman` AS `salesman`,`s`.`wholesale_amount` AS `wholesale_amount`,`s`.`retail_amount` AS `retail_amount`,`s`.`sala_multiple` AS `sala_multiple`,`s`.`is_sale` AS `is_sale`,`s`.`is_wholesale` AS `is_wholesale`,`s`.`is_retail` AS `is_retail`,`b`.`buyer_type` AS `buyer_type`,`b`.`is_new` AS `is_new`,`b`.`is_buyer` AS `is_buyer`,`b`.`supplier` AS `supplier`,`b`.`amount` AS `amount`,`b`.`buyer_id` AS `buyer_id`,`b`.`buyer_day` AS `buyer_day`,`b`.`buyer_cycle` AS `buyer_cycle`,`b`.`buyer_multiple` AS `buyer_multiple`,`w`.`day` AS `day`,`w`.`tend_day` AS `tend_day`,`w`.`tend_type` AS `tend_type`,`w`.`storage_type` AS `storage_type`,`w`.`max_qty` AS `max_qty`,`w`.`min_qty` AS `min_qty`,`ca`.`title` AS `category`,`k`.`name` AS `kinds_name`,`k`.`parent_id` AS `kinds_id`,`f`.`title` AS `function` from (((((((`qfyu_commodity` `c` left join `qfyu_permit_kinds` `k` on((`c`.`kinds_id` = `k`.`id`))) left join `qfyu_commodity_category` `ca` on((`c`.`category_id` = `ca`.`id`))) left join `qfyu_commodity_function` `f` on((`c`.`function_id` = `f`.`id`))) left join `qfyu_commodity_extend` `e` on((`c`.`goods_code` = `e`.`goods_code`))) left join `qfyu_commodity_sale` `s` on((`c`.`goods_code` = `s`.`goods_code`))) left join `qfyu_commodity_buyer` `b` on((`c`.`goods_code` = `b`.`goods_code`))) left join `qfyu_commodity_warehouse` `w` on((`c`.`goods_code` = `w`.`goods_code`))) order by `c`.`creater_date` desc;

-- ----------------------------
-- View structure for qfyu_first_supplier
-- ----------------------------
DROP VIEW IF EXISTS `qfyu_first_supplier`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `qfyu_first_supplier` AS select `gf`.`id` AS `id`,`gf`.`orderid` AS `orderid`,`gf`.`supplier_code` AS `supplier_code`,`gf`.`name` AS `name`,`gf`.`mnemonic_code` AS `mnemonic_code`,`gf`.`area` AS `area`,`gf`.`tel` AS `tel`,`gf`.`fax` AS `fax`,`gf`.`email` AS `email`,`gf`.`post_code` AS `post_code`,`gf`.`enterprise_leader` AS `enterprise_leader`,`gf`.`tech_mans` AS `tech_mans`,`gf`.`business_license` AS `business_license`,`gf`.`business_scope` AS `business_scope`,`gf`.`business_issuing_authority` AS `business_issuing_authority`,`gf`.`business_issue_date` AS `business_issue_date`,`gf`.`business_validity_date` AS `business_validity_date`,`gf`.`attorney_book` AS `attorney_book`,`gf`.`attorney_validity_date` AS `attorney_validity_date`,`gf`.`business_leader` AS `business_leader`,`gf`.`contract_start_date` AS `contract_start_date`,`gf`.`contract_end_date` AS `contract_end_date`,`gf`.`enterprise_type` AS `enterprise_type`,`gf`.`output_year` AS `output_year`,`gf`.`major_honors` AS `major_honors`,`gf`.`supply_var` AS `supply_var`,`gf`.`drug_license` AS `drug_license`,`gf`.`drug_issuing_authority` AS `drug_issuing_authority`,`gf`.`drug_issue_date` AS `drug_issue_date`,`gf`.`drug_validity_date` AS `drug_validity_date`,`gf`.`apparatus_license` AS `apparatus_license`,`gf`.`apparatus_validity_date` AS `apparatus_validity_date`,`gf`.`food_license` AS `food_license`,`gf`.`food_validity_date` AS `food_validity_date`,`gf`.`health_license` AS `health_license`,`gf`.`health_validity_date` AS `health_validity_date`,`gf`.`organization_license` AS `organization_license`,`gf`.`organization_validity_date` AS `organization_validity_date`,`gf`.`legal_person` AS `legal_person`,`gf`.`registered_capital` AS `registered_capital`,`gf`.`economic_nature` AS `economic_nature`,`gf`.`operation_mode` AS `operation_mode`,`gf`.`contact` AS `contact`,`gf`.`card_id` AS `card_id`,`gf`.`gsp_license` AS `gsp_license`,`gf`.`gsp_validity_date` AS `gsp_validity_date`,`gf`.`gmp_range` AS `gmp_range`,`gf`.`gmp_two_license` AS `gmp_two_license`,`gf`.`gmp_two_range` AS `gmp_two_range`,`gf`.`gmp_two_validity_date` AS `gmp_two_validity_date`,`gf`.`gmp_three_license` AS `gmp_three_license`,`gf`.`gmp_three_range` AS `gmp_three_range`,`gf`.`gmp_three_validity_date` AS `gmp_three_validity_date`,`gf`.`bank_area` AS `bank_area`,`gf`.`bank_account` AS `bank_account`,`gf`.`tax_code` AS `tax_code`,`gf`.`is_quality_agreement` AS `is_quality_agreement`,`gf`.`quality_validity_date` AS `quality_validity_date`,`gf`.`kinds_id` AS `kinds_id`,`gf`.`apply_branch` AS `apply_branch`,`gf`.`apply_depart` AS `apply_depart`,`gf`.`main_pro` AS `main_pro`,`gf`.`pro_advant` AS `pro_advant`,`gf`.`quality_organization` AS `quality_organization`,`gf`.`quality_system` AS `quality_system`,`gf`.`mana_system` AS `mana_system`,`gf`.`creator` AS `creator`,`gf`.`updater` AS `updater`,`gf`.`is_audit` AS `is_audit`,`gf`.`is_approval` AS `is_approval`,`gf`.`is_transfer` AS `is_transfer`,`gf`.`create_date` AS `create_date`,`gf`.`re_date` AS `re_date`,`ce`.`name` AS `e_name`,`shtxd`.`file_name` AS `SHTXD_img`,`shtxd`.`validity_date` AS `shtxd_validity_date`,`yzystp`.`file_name` AS `YZYSTP_img`,`yzystp`.`validity_date` AS `yzystp_validity_date`,`ue`.`name` AS `ue_name`,`gf`.`auditer` AS `auditer`,`gf`.`audit_date` AS `audit_date` from ((((`qfyu_gsp_first_enterprise` `gf` join `qfyu_employee` `ce` on((`ce`.`code` = `gf`.`creator`))) left join `qfyu_enterprise_photo` `shtxd` on(((`shtxd`.`supplier_code` = `gf`.`supplier_code`) and (`shtxd`.`img_name` = 'SHTXD')))) left join `qfyu_enterprise_photo` `yzystp` on(((`yzystp`.`supplier_code` = `gf`.`supplier_code`) and (`yzystp`.`img_name` = 'YZYSTP')))) left join `qfyu_employee` `ue` on((`ue`.`code` = `gf`.`updater`)));

-- ----------------------------
-- View structure for qfyu_purchaseplan_list
-- ----------------------------
DROP VIEW IF EXISTS `qfyu_purchaseplan_list`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `qfyu_purchaseplan_list` AS select `o`.`orderid` AS `orderid`,`o`.`typeid` AS `typeid`,`o`.`prepared_code` AS `prepared_code`,`o`.`prepared_date` AS `prepared_date`,`o`.`invalid_date` AS `invalid_date`,`o`.`nums` AS `nums`,(0 + cast(`o`.`account` as char charset utf8mb4)) AS `account`,`o`.`remark` AS `remark`,`o`.`creator` AS `creator`,`o`.`updater` AS `updater`,`o`.`isclose` AS `isclose`,`o`.`ischeck` AS `ischeck`,`o`.`istrans` AS `istrans`,`o`.`check_code` AS `check_code`,`o`.`depart_id` AS `depart_id`,`d`.`dept_name` AS `dept_name`,`em`.`name` AS `prepared_name`,`ek`.`name` AS `check_name`,`ec`.`name` AS `create_name`,`eu`.`name` AS `update_name`,date_format(`o`.`creator_date`,'%Y-%m-%d %H:%i') AS `creator_date`,date_format(`o`.`updater_date`,'%Y-%m-%d %H:%i') AS `updater_date` from (((((`qfyu_purchase_plan` `o` left join `qfyu_employee` `em` on((`em`.`code` = `o`.`prepared_code`))) left join `qfyu_employee` `ec` on((`ec`.`code` = `o`.`creator`))) left join `qfyu_employee` `eu` on((`eu`.`code` = `o`.`updater`))) left join `qfyu_employee` `ek` on((`ek`.`code` = `o`.`check_code`))) left join `qfyu_depart` `d` on((`d`.`id` = `o`.`depart_id`)));

-- ----------------------------
-- View structure for qfyu_view_total_stock
-- ----------------------------
DROP VIEW IF EXISTS `qfyu_view_total_stock`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `qfyu_view_total_stock` AS select `qfyu_stock_batchpart`.`ware_code` AS `ware_code`,`qfyu_stock_batchpart`.`batch_no` AS `batch_no`,`qfyu_stock_batchpart`.`goods_code` AS `goods_code`,sum(`qfyu_stock_batchpart`.`qty`) AS `qty`,sum(`qfyu_stock_batchpart`.`qty1`) AS `qty1`,sum(`qfyu_stock_batchpart`.`amount`) AS `amount` from `qfyu_stock_batchpart` group by `qfyu_stock_batchpart`.`ware_code`,`qfyu_stock_batchpart`.`batch_no`,`qfyu_stock_batchpart`.`goods_code`;

-- ----------------------------
-- Procedure structure for insertOrUpdateStockBatch
-- ----------------------------
DROP PROCEDURE IF EXISTS `insertOrUpdateStockBatch`;
delimiter ;;
CREATE PROCEDURE `insertOrUpdateStockBatch`(IN wareCode varchar(20),
		IN posCode varchar(20),
		IN supCode varchar(20),
		IN goodsCode varchar(20),
		IN batchNo varchar(20),
		IN Qty_Num decimal(16,5),
		IN Amount_Num decimal(16,6),
		IN prodDate date,
		IN validDate date,
		IN goodsState varchar(20),
		IN qualityState varchar(20),
		IN convRatePercent decimal(16,5),
		IN hasSplit TINYINT(1))
BEGIN
	 declare hasQty VARCHAR(20);
	 declare Qty1_Num decimal(16,5);
	 declare Qty2_Num  decimal(16,5);
	 declare Price1_Num decimal(16,6);
	 declare Price2_Num decimal(16,6);
	 SELECT ware_code INTO hasQty FROM qfyu_stock_batchpart WHERE ware_code=wareCode AND pos_code=posCode AND sup_code=supCode AND goods_code=goodsCode AND batch_no=batchNo;
	 IF hasQty IS NULL THEN
			SET Qty1_Num = CASE WHEN hasSplit=1 THEN FLOOR(Qty_Num) ELSE Qty_Num END;
			SET Qty2_Num = CASE WHEN hasSplit=1 THEN ROUND((Qty_Num-Qty1_Num)*convRatePercent,5) ELSE 0 END;
			SET Price1_Num = ROUND(Amount_Num/Qty_Num,6);
			set Price2_Num = CASE WHEN hasSplit=1 THEN ROUND(Price1_Num/convRatePercent,6) ELSE 0 END;
			INSERT INTO qfyu_stock_batchpart(ware_code,pos_code,sup_code,goods_code,batch_no,qty,qty1,qty2,price1,price2,amount,prod_date,valid_date,goods_state,quality_state) VALUES 
			(wareCode,posCode,supCode,goodsCode,batchNo,Qty_Num,Qty1_Num,Qty2_Num,Price1_Num,Price2_Num,Amount_Num,prodDate,validDate,goodsState,qualityState);
	 ELSE
			UPDATE qfyu_stock_batchpart set 
				qty=ROUND(`qty`+Qty_Num,5),
				qty1=CASE WHEN hasSplit=1 THEN FLOOR(qty) ELSE qty END,
				qty2=CASE WHEN hasSplit=1 THEN ROUND((qty-qty1)*convRatePercent,5) ELSE 0 END,
				amount=ROUND(amount+Amount_Num,6),
				price1=CASE WHEN qty>0 THEN ROUND(amount/qty,6) ELSE 0 END,
				price2=CASE WHEN hasSplit=1 THEN ROUND(price1/convRatePercent,6) ELSE 0 END,
				prod_date=prodDate,
				valid_date=validDate,
				goods_state=goodsState,
				quality_state=qualityState
		  WHERE ware_code=wareCode AND pos_code=posCode AND sup_code=supCode AND goods_code=goodsCode AND batch_no=batchNo;
	 END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_acconline
-- ----------------------------
DROP TRIGGER IF EXISTS `del_onlinedtl`;
delimiter ;;
CREATE TRIGGER `del_onlinedtl` AFTER DELETE ON `qfyu_acconline` FOR EACH ROW BEGIN
	DELETE FROM qfyu_acconline_detail WHERE bill_no=old.bill_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_accstock
-- ----------------------------
DROP TRIGGER IF EXISTS `del_detail`;
delimiter ;;
CREATE TRIGGER `del_detail` AFTER DELETE ON `qfyu_accstock` FOR EACH ROW BEGIN
	DELETE FROM qfyu_accstock_detail WHERE bill_no=old.bill_no;
	DELETE FROM qfyu_ware_locked WHERE bill_no=old.bill_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_purchase_settle
-- ----------------------------
DROP TRIGGER IF EXISTS `delete_pch_settle`;
delimiter ;;
CREATE TRIGGER `delete_pch_settle` AFTER DELETE ON `qfyu_purchase_settle` FOR EACH ROW begin
	DELETE from qfyu_purchase_settle_details where reforderid=old.reforderid;
end
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_real_stocktak
-- ----------------------------
DROP TRIGGER IF EXISTS `del_rdetail`;
delimiter ;;
CREATE TRIGGER `del_rdetail` AFTER DELETE ON `qfyu_real_stocktak` FOR EACH ROW BEGIN
	DELETE FROM qfyu_real_stocktak_detail WHERE bill_no=old.bill_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_stock_details
-- ----------------------------
DROP TRIGGER IF EXISTS `update_receive_items`;
delimiter ;;
CREATE TRIGGER `update_receive_items` AFTER INSERT ON `qfyu_stock_details` FOR EACH ROW BEGIN
	update qfyu_stock_receive_details set inqty=new.qty where id=new.item_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_stock_details
-- ----------------------------
DROP TRIGGER IF EXISTS `update_receive_zero`;
delimiter ;;
CREATE TRIGGER `update_receive_zero` BEFORE DELETE ON `qfyu_stock_details` FOR EACH ROW BEGIN
	update qfyu_stock_receive_details set inqty=0 where id=old.item_no;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_stock_goodsinout
-- ----------------------------
DROP TRIGGER IF EXISTS `update_stock_id`;
delimiter ;;
CREATE TRIGGER `update_stock_id` BEFORE INSERT ON `qfyu_stock_goodsinout` FOR EACH ROW BEGIN
	SET new.stock_id = (SELECT id FROM qfyu_stock_details WHERE reforderid = new.reforderid and item_no = new.item_no);
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table qfyu_whole_stock
-- ----------------------------
DROP TRIGGER IF EXISTS `del_detail_copy1`;
delimiter ;;
CREATE TRIGGER `del_detail_copy1` AFTER DELETE ON `qfyu_whole_stock` FOR EACH ROW BEGIN
	DELETE FROM qfyu_accstock_detail WHERE bill_no=old.bill_no;
	DELETE FROM qfyu_ware_locked WHERE bill_no=old.bill_no;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
