create database shop10 charset=utf8;
use shop10;

-- 品牌表
drop table if exists kang_brand;
create table kang_brand
(
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '名称',
  logo varchar(255) not null default '' comment 'LOGO',
  site varchar(255) not null default '' comment '官网',
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  key (title),
  key (sort)
) engine innodb charset utf8 comment '品牌';

-- 管理员
drop table if exists kang_admin;
create table kang_admin
(
  id int unsigned auto_increment primary key comment 'ID',
  username varchar(32) not null default '' comment '用户名',
  password varchar(64) not null default '' comment '密码',
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  key (username),
  key (password),
  key (sort)
) engine innodb charset utf8 comment '管理员';

-- 角色
drop table if exists kang_role;
create table kang_role
(
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '角色',
  description varchar(255) not null default '' comment '描述',
  is_super tinyint not null default 0 comment '是否为超管',
  sort int not null default 0 COMMENT '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  key (title),
  key (sort)
) engine innodb charset utf8 comment '角色';

-- 动作
drop table if exists kang_action;
create table kang_action
(
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '权限',
  rule varchar(255) not null default '' comment '规则', -- back/brand/set, brand-delete
  description varchar(255) not null default '' comment '描述',
  sort int not null default 0 COMMENT '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  key (title),
  key (rule),
  key (sort)
) engine innodb charset utf8 comment '动作';

-- 角色-动作
drop table if exists kang_role_action;
create table kang_role_action
(
  id int unsigned auto_increment primary key comment 'ID',
  role_id int unsigned not null default 0 comment '角色',
  action_id int unsigned not null default 0 comment '动作',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  unique key (role_id, action_id),
  key (action_id)
) engine innodb charset utf8 comment '角色-动作';

-- 角色-管理员
drop table if exists kang_role_admin;
create table kang_role_admin
(
  id int unsigned auto_increment primary key comment 'ID',
  role_id int unsigned not null default 0 comment '角色',
  admin_id int unsigned not null default 0 comment '管理员',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  unique key (role_id, admin_id),
  key (admin_id)
) engine innodb charset utf8 comment '角色-管理员';

-- 商品分类表
drop table if exists kang_category;
create table kang_category (
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '分类',
  parent_id int unsigned not null default 0 comment '上级分类',
  sort int not null default 0 COMMENT '排序',
  is_used boolean not null default 0 comment '启用', -- tinyint(1)
  -- SEO优化
  meta_title varchar(255) not null default '' comment 'SEO标题',
  meta_keywords varchar(255) not null default '' comment 'SEO关键字',
  meta_description varchar(1024) not null default '' comment 'SEO描述',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  index (title),
  index (parent_id),
  index (sort)
) engine innodb charset utf8 comment '分类';
-- 初始化了一条数据
insert into kang_category values (1, '未分类', 0, -1, 0, '', '', '', unix_timestamp(), unix_timestamp());

-- 产品表
drop table if exists kang_product;
create table kang_product (
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(255) not null default '' comment '名称',
  upc varchar(255) not null default '' comment '通用代码', -- 通用商品代码
  image varchar(255) not null default '' comment '图像',
  image_thumb varchar(255) not null default '' comment '缩略图',
  quantity int unsigned not null default 0 comment '库存', -- 库存
  sku_id int unsigned not null default 0 comment '库存单位', -- 库存单位
  stock_status_id int unsigned not null default 0 comment '库存状态', -- 库存状态ID
  is_subtract tinyint not null default 0 comment '扣减库存', -- 是否减少库存
  minimum int unsigned not null default 0 comment '最少起售', -- 最小起订数量
  price decimal(10, 2) not null default 0.0 comment '售价',
  price_origin decimal(10, 2) not null default 0.0 comment '原价',
  is_shipping tinyint not null default 0 comment '配送支持', -- 是否允许配送
  date_available timestamp not null default current_timestamp comment '起售时间', -- 供货日期
  length int unsigned not null default 0 comment '长',
  width int unsigned not null default 0 comment '宽',
  height int unsigned not null default 0 comment '高',
  length_unit_id int unsigned not null default 0 comment '长度单位', -- 长度单位
  weight int unsigned not null default 0 comment '重量',
  weight_unit_id int unsigned not null default 0 comment '重量单位', -- 重量的单位
  is_sale tinyint not null default 0 comment '上架', -- 是否可用
  description text comment '描述', -- 商品描述
  brand_id int unsigned not null default 0 comment '品牌', -- 所属品牌ID
  category_id int unsigned not null default 0 comment '分类', -- 所属主分类ID
  attribute_group_id int unsigned not null default 0 comment '属性组',
  group_id int unsigned not null default 0 comment '所属组',
  static_url varchar(255) not null default '' comment '静态URL',
  admin_id int unsigned not null default 0 comment '创建管理员id',
  -- SEO优化
  meta_title varchar(255) not null default '' comment 'SEO标题',
  meta_keywords varchar(255) not null default '' comment 'SEO关键字',
  meta_description varchar(1024) not null default '' comment 'SEO描述',
  sort int not null default 0 comment '排序', -- 排序
  delete_time int comment '删除时间', -- 用于支持软删除
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (title),
  unique key (upc),
  index (brand_id),
  index (category_id),
  index (sku_id),
  index (stock_status_id),
  index (length_unit_id),
  index (weight_unit_id),
  index (sort),
  index (price),
  index (quantity),
  index (delete_time)
) engine innodb charset utf8 comment '产品';

-- 库存单位
drop table if exists kang_sku;
create table kang_sku (
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '库存单位',
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  key (title),
  key (sort)
) ENGINE innodb charset utf8 comment '库存单位';
-- 参考测试数据
insert into kang_sku values (1, '部', 0, unix_timestamp(), unix_timestamp());
insert into kang_sku values (2, '台', 0, unix_timestamp(), unix_timestamp());
insert into kang_sku values (3, '只', 0, unix_timestamp(), unix_timestamp());
insert into kang_sku values (4, '条', 0, unix_timestamp(), unix_timestamp());
insert into kang_sku values (5, '头', 0, unix_timestamp(), unix_timestamp());

-- 库存状态
drop table if exists kang_stock_status;
create table kang_stock_status (
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '库存状态',
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  index (title),
  index (sort)
) engine innodb charset utf8 comment  '库存状态';
-- 参考测试数据
insert into kang_stock_status values (1, '库存充足', 0, unix_timestamp(), unix_timestamp());
insert into kang_stock_status values (2, '脱销', 0, unix_timestamp(), unix_timestamp());
insert into kang_stock_status values (3, '预定', 0, unix_timestamp(), unix_timestamp());
insert into kang_stock_status values (4, '1至3周销售', 0, unix_timestamp(), unix_timestamp());
insert into kang_stock_status values (5, '1至3天销售', 0, unix_timestamp(),unix_timestamp());

-- 长度单位
drop table if exists kang_length_unit;
create table kang_length_unit (
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '长度单位',
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  index (title),
  index (sort)
) engine=innodb charset=utf8 comment='长度单位';
-- 参考测试数据
insert into kang_length_unit values (1, '厘米', 0, unix_timestamp(), unix_timestamp());
insert into kang_length_unit values (2, '毫米', 0, unix_timestamp(), unix_timestamp());
insert into kang_length_unit values (3, '米', 0, unix_timestamp(), unix_timestamp());
insert into kang_length_unit values (4, '千米', 0, unix_timestamp(), unix_timestamp());
insert into kang_length_unit values (5, '英寸', 0, unix_timestamp(), unix_timestamp());


-- 重量单位
drop table if exists kang_weight_unit;
create table kang_weight_unit (
  id int unsigned auto_increment primary key comment 'ID',
  title varchar(32) not null default '' comment '重量单位',
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  index (title),
  index (sort)
) engine=innodb charset=utf8 comment='重量单位';
-- 参考测试数据
insert into kang_weight_unit values (1, '克', 0, unix_timestamp(), unix_timestamp());
insert into kang_weight_unit values (2, '千克', 0, unix_timestamp(), unix_timestamp());
insert into kang_weight_unit values (3, '克拉', 0, unix_timestamp(), unix_timestamp());
insert into kang_weight_unit values (4, '市斤', 0, unix_timestamp(), unix_timestamp());
insert into kang_weight_unit values (5, '吨', 0, unix_timestamp(), unix_timestamp());
insert into kang_weight_unit values (6, '磅', 0, unix_timestamp(), unix_timestamp());


-- 属性组
drop table if exists kang_attribute_group;
create table kang_attribute_group
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  title varchar(32) not null default '' comment '属性组',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (title),
  index (sort)
) ENGINE innodb CHARSET utf8 comment '属性组';

-- 属性
drop table if exists kang_attribute;
create table kang_attribute
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  title varchar(32) not null default '' comment '属性',
  attribute_group_id int unsigned not null default 0 comment '属性组',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (title),
  index (sort),
  index (attribute_group_id)
) ENGINE innodb CHARSET utf8 comment '属性';


-- 商品属性关联
drop table if exists kang_product_attribute;
create table kang_product_attribute
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  product_id int UNSIGNED not null default 0 comment '商品',
  attribute_id int UNSIGNED not null default 0 comment '属性',
  value varchar(255) not null default '' comment '属性值',
  is_extend tinyint not null default 0 comment '型号属性',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  unique index (product_id, attribute_id),
  index (sort),
  index (value)
) ENGINE innodb CHARSET utf8 comment '商品属性值';

-- 产品组
drop table if exists kang_group;
create table kang_group
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  title varchar(32) not null default '' comment '产品组',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (title),
  index (sort)
) ENGINE innodb CHARSET utf8 comment '产品组';


-- 产品相册
drop table if exists kang_gallery;
create table kang_gallery
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  product_id int unsigned not null default 0 comment '所属产品',
  image varchar(255) not null default '' comment '原图',
  image_big varchar(255) not null default '' comment '大图',
  image_small varchar(255) not null default '' comment '小图',
  description varchar(255) not null default '' comment '描述',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (sort)
) ENGINE innodb CHARSET utf8 comment '产品相册';


-- 配置系统
drop table if exists kang_config_group;
create table kang_config_group
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  title varchar(32) not null default '' comment '配置组',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (sort)
) ENGINE innodb CHARSET utf8 comment '配置组';

-- 配置项
drop table if exists kang_config;
create table kang_config
(
  id int unsigned AUTO_INCREMENT primary key comment 'ID',
  config_group_id int unsigned not null default 0 comment '所属组',
  input_type_id int unsigned not null default 0 comment '元素类型',
  title varchar(32) not null default '' comment '配置名称',
  name varchar(32) not null default '' comment '配置项标志',
  value varchar(255) not null default '' comment '配置值',
  sort int not null default 0 comment '排序',
  create_time int comment '创建时间',
  update_time int comment '修改时间',
  index (config_group_id),
  index (sort)
) ENGINE innodb CHARSET utf8 comment '配置项';


-- 会员
drop table if exists kang_member;
create table kang_member
(
  id int UNSIGNED AUTO_INCREMENT comment 'ID' primary key,
  telephone varchar(16) comment '手机',
  email varchar(255) comment '邮箱地址',
  username varchar(32) comment '姓名',
  password varchar(64) not null default '' comment '密码',
  hash_str varchar(128) not null default '' comment '混淆字符串',
  active_time int not null default 0 comment '激活时间',
  status tinyint not null default 0 comment '状态', -- 1未激活, 2已激活, 3封号
  sort int not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  unique key (email),
  unique key (telephone),
  unique key (username)
) ENGINE innodb charset utf8 comment '会员';


-- 购物车
drop table if exists kang_cart;
create table kang_cart
(
  id int UNSIGNED AUTO_INCREMENT comment 'ID' primary key,
  member_id int unsigned comment '所属会员',
  content text comment '购物车内容',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  unique index (member_id)
) ENGINE innodb charset utf8 comment '购物车';

-- 货运地址表
drop table if exists kang_address;
create table kang_address
(
  id int UNSIGNED AUTO_INCREMENT comment 'ID' primary key,
  member_id int UNSIGNED not null default 0 comment '会员',
  username varchar(32) not null default '' comment '姓名',
  telephone varchar(16) not null default '' comment '手机',
  company varchar(32) not null default '' comment '公司',
  region_id_1 int unsigned not null default 0 comment '一级地区',
  region_id_2 int unsigned not null default 0 comment '二级地区',
  region_id_3 int unsigned not null default 0 comment '三级地区',
  address varchar(255) not null default '' comment '详细地址',
  postcode varchar(12) not null default '' comment '邮政编码',
  is_default tinyint not null default 0 comment '是否为上次使用', -- 上次订单(新建的)的地址
  sort int unsigned not null default 0 comment '排序',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  key (region_id_1),
  key (region_id_2),
  key (region_id_3),
  key (member_id),
  key (username),
  key (telephone)
) ENGINE innodb charset utf8 comment '送货地址';

-- 配送方式
drop table if exists kang_shipping;
create table kang_shipping
(
  id int UNSIGNED AUTO_INCREMENT primary key comment 'ID',
  title varchar(64) not null default '' comment '标题',
  intro varchar(255) not null default '' comment '介绍',
  enabled tinyint not null default 0 comment '启用',
  sort int not null default 0 comment '顺序',
  name varchar(64) not null default '' comment '名字',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  unique key (name),
  index (title),
  index (sort)
) ENGINE innodb CHARSET utf8 comment '配送方式';

-- 订单表
drop table if exists kang_order;
create table kang_order
(
  id int UNSIGNED AUTO_INCREMENT comment 'ID',
  sn varchar(32) not null default '' comment '订单号',
  member_id int UNSIGNED not null default 0 comment '所属会员',
  address_id int UNSIGNED not null default 0 comment '收货地址id',
  address text comment '收货地址',
  shipping_id int UNSIGNED not null default 0 comment '配送方式',
  payment_id int UNSIGNED not null default 0 comment '支付方式',
  comment VARCHAR(255) not null default 0 comment '备注',
  status tinyint not null default 0 comment '订单状态', -- 1正在确认, 2确认通过, 3挂起（库存不足） 4交易取消, 5交易成功
  ensure_time int not null default 0 comment '确认时间',
  shipping_status tinyint not null default 0 comment '配送状态', -- 1商家未发货, 2商家已发货, 3买家已收货
  shipping_sn varchar(32) not null default '' comment '物流单号',
  payment_status tinyint not null default 0 comment '支付状态',-- 1未支付, 2已支付
  payment_time int not null default 0 comment '支付时间',
  product_quantity int not NULL  default 0 comment '产品总数量',
  product_weight double(10, 2) not NULL default 0 comment '产品总重量',
  product_amount DECIMAL(10, 2) not null default 0 comment '产品总金额',
  shipping_price DECIMAL(10, 2) not null default 0 comment '运费',
  order_amount DECIMAL(10, 2) not null default 0 comment '订单总金额',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  primary key (id),
  UNIQUE  key (sn),
  index (member_id),
  index (address_id),
  index (shipping_id),
  index (payment_id)
) engine innodb charset utf8 comment '订单';

-- 订单商品
drop table if exists kang_order_product;
create table kang_order_product
(
  id int UNSIGNED AUTO_INCREMENT comment 'ID',
  order_id int unsigned not null default 0 comment '订单',
  product_id int unsigned not null default 0 comment '商品',
  buy_quantity int not null default 0 comment '购买数量',
  product_attribute text comment '商品购买时的属性',
  create_time int not null default 0 comment '创建时间',
  update_time int not null default 0 comment '修改时间',
  PRIMARY KEY (id),
  index (order_id),
  index (product_id)
) engine innodb CHARSET utf8 comment '订单商品';

-- 地区
CREATE TABLE `kang_region` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `title` varchar(128) NOT NULL DEFAULT '',
    `parent_id` int(10) unsigned NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 地区数据
INSERT INTO `kang_region` VALUES (1,'中国',0),(2,'北京市',1),(3,'天津市',1),(4,'河北省',1),(5,'山西省',1),(6,'内蒙古自治区',1),(7,'辽宁省',1),(8,'吉林省',1),(9,'黑龙江省',1),(10,'上海市',1),(11,'江苏省',1),(12,'浙江省',1),(13,'安徽省',1),(14,'福建省',1),(15,'江西省',1),(16,'山东省',1),(17,'河南省',1),(18,'湖北省',1),(19,'湖南省',1),(20,'广东省',1),(21,'广西壮族自治区',1),(22,'海南省',1),(23,'重庆市',1),(24,'四川省',1),(25,'贵州省',1),(26,'云南省',1),(27,'西藏自治区',1),(28,'陕西省',1),(29,'甘肃省',1),(30,'青海省',1),(31,'宁夏回族自治区',1),(32,'新疆维吾尔自治区',1),(33,'市辖区',2),(34,'县',2),(35,'市辖区',3),(36,'县',3),(37,'石家庄市',4),(38,'唐山市',4),(39,'秦皇岛市',4),(40,'邯郸市',4),(41,'邢台市',4),(42,'保定市',4),(43,'张家口市',4),(44,'承德市',4),(45,'沧州市',4),(46,'廊坊市',4),(47,'衡水市',4),(48,'太原市',5),(49,'大同市',5),(50,'阳泉市',5),(51,'长治市',5),(52,'晋城市',5),(53,'朔州市',5),(54,'晋中市',5),(55,'运城市',5),(56,'忻州市',5),(57,'临汾市',5),(58,'吕梁市',5),(59,'呼和浩特市',6),(60,'包头市',6),(61,'乌海市',6),(62,'赤峰市',6),(63,'通辽市',6),(64,'鄂尔多斯市',6),(65,'呼伦贝尔市',6),(66,'巴彦淖尔市',6),(67,'乌兰察布市',6),(68,'兴安盟',6),(69,'锡林郭勒盟',6),(70,'阿拉善盟',6),(71,'沈阳市',7),(72,'大连市',7),(73,'鞍山市',7),(74,'抚顺市',7),(75,'本溪市',7),(76,'丹东市',7),(77,'锦州市',7),(78,'营口市',7),(79,'阜新市',7),(80,'辽阳市',7),(81,'盘锦市',7),(82,'铁岭市',7),(83,'朝阳市',7),(84,'葫芦岛市',7),(85,'长春市',8),(86,'吉林市',8),(87,'四平市',8),(88,'辽源市',8),(89,'通化市',8),(90,'白山市',8),(91,'松原市',8),(92,'白城市',8),(93,'延边朝鲜族自治州',8),(94,'哈尔滨市',9),(95,'齐齐哈尔市',9),(96,'鸡西市',9),(97,'鹤岗市',9),(98,'双鸭山市',9),(99,'大庆市',9),(100,'伊春市',9),(101,'佳木斯市',9),(102,'七台河市',9),(103,'牡丹江市',9),(104,'黑河市',9),(105,'绥化市',9),(106,'大兴安岭地区',9),(107,'市辖区',10),(108,'县',10),(109,'南京市',11),(110,'无锡市',11),(111,'徐州市',11),(112,'常州市',11),(113,'苏州市',11),(114,'南通市',11),(115,'连云港市',11),(116,'淮安市',11),(117,'盐城市',11),(118,'扬州市',11),(119,'镇江市',11),(120,'泰州市',11),(121,'宿迁市',11),(122,'杭州市',12),(123,'宁波市',12),(124,'温州市',12),(125,'嘉兴市',12),(126,'湖州市',12),(127,'绍兴市',12),(128,'金华市',12),(129,'衢州市',12),(130,'舟山市',12),(131,'台州市',12),(132,'丽水市',12),(133,'合肥市',13),(134,'芜湖市',13),(135,'蚌埠市',13),(136,'淮南市',13),(137,'马鞍山市',13),(138,'淮北市',13),(139,'铜陵市',13),(140,'安庆市',13),(141,'黄山市',13),(142,'滁州市',13),(143,'阜阳市',13),(144,'宿州市',13),(145,'巢湖市',13),(146,'六安市',13),(147,'亳州市',13),(148,'池州市',13),(149,'宣城市',13),(150,'福州市',14),(151,'厦门市',14),(152,'莆田市',14),(153,'三明市',14),(154,'泉州市',14),(155,'漳州市',14),(156,'南平市',14),(157,'龙岩市',14),(158,'宁德市',14),(159,'南昌市',15),(160,'景德镇市',15),(161,'萍乡市',15),(162,'九江市',15),(163,'新余市',15),(164,'鹰潭市',15),(165,'赣州市',15),(166,'吉安市',15),(167,'宜春市',15),(168,'抚州市',15),(169,'上饶市',15),(170,'济南市',16),(171,'青岛市',16),(172,'淄博市',16),(173,'枣庄市',16),(174,'东营市',16),(175,'烟台市',16),(176,'潍坊市',16),(177,'济宁市',16),(178,'泰安市',16),(179,'威海市',16),(180,'日照市',16),(181,'莱芜市',16),(182,'临沂市',16),(183,'德州市',16),(184,'聊城市',16),(185,'滨州市',16),(186,'菏泽市',16),(187,'郑州市',17),(188,'开封市',17),(189,'洛阳市',17),(190,'平顶山市',17),(191,'安阳市',17),(192,'鹤壁市',17),(193,'新乡市',17),(194,'焦作市',17),(195,'濮阳市',17),(196,'许昌市',17),(197,'漯河市',17),(198,'三门峡市',17),(199,'南阳市',17),(200,'商丘市',17),(201,'信阳市',17),(202,'周口市',17),(203,'驻马店市',17),(204,'武汉市',18),(205,'黄石市',18),(206,'十堰市',18),(207,'宜昌市',18),(208,'襄樊市',18),(209,'鄂州市',18),(210,'荆门市',18),(211,'孝感市',18),(212,'荆州市',18),(213,'黄冈市',18),(214,'咸宁市',18),(215,'随州市',18),(216,'恩施土家族苗族自治州',18),(217,'省直辖县级行政区划',18),(218,'长沙市',19),(219,'株洲市',19),(220,'湘潭市',19),(221,'衡阳市',19),(222,'邵阳市',19),(223,'岳阳市',19),(224,'常德市',19),(225,'张家界市',19),(226,'益阳市',19),(227,'郴州市',19),(228,'永州市',19),(229,'怀化市',19),(230,'娄底市',19),(231,'湘西土家族苗族自治州',19),(232,'广州市',20),(233,'韶关市',20),(234,'深圳市',20),(235,'珠海市',20),(236,'汕头市',20),(237,'佛山市',20),(238,'江门市',20),(239,'湛江市',20),(240,'茂名市',20),(241,'肇庆市',20),(242,'惠州市',20),(243,'梅州市',20),(244,'汕尾市',20),(245,'河源市',20),(246,'阳江市',20),(247,'清远市',20),(248,'东莞市',20),(249,'中山市',20),(250,'潮州市',20),(251,'揭阳市',20),(252,'云浮市',20),(253,'南宁市',21),(254,'柳州市',21),(255,'桂林市',21),(256,'梧州市',21),(257,'北海市',21),(258,'防城港市',21),(259,'钦州市',21),(260,'贵港市',21),(261,'玉林市',21),(262,'百色市',21),(263,'贺州市',21),(264,'河池市',21),(265,'来宾市',21),(266,'崇左市',21),(267,'海口市',22),(268,'三亚市',22),(269,'省直辖县级行政区划',22),(270,'市辖区',23),(271,'县',23),(273,'成都市',24),(274,'自贡市',24),(275,'攀枝花市',24),(276,'泸州市',24),(277,'德阳市',24),(278,'绵阳市',24),(279,'广元市',24),(280,'遂宁市',24),(281,'内江市',24),(282,'乐山市',24),(283,'南充市',24),(284,'眉山市',24),(285,'宜宾市',24),(286,'广安市',24),(287,'达州市',24),(288,'雅安市',24),(289,'巴中市',24),(290,'资阳市',24),(291,'阿坝藏族羌族自治州',24),(292,'甘孜藏族自治州',24),(293,'凉山彝族自治州',24),(294,'贵阳市',25),(295,'六盘水市',25),(296,'遵义市',25),(297,'安顺市',25),(298,'铜仁地区',25),(299,'黔西南布依族苗族自治州',25),(300,'毕节地区',25),(301,'黔东南苗族侗族自治州',25),(302,'黔南布依族苗族自治州',25),(303,'昆明市',26),(304,'曲靖市',26),(305,'玉溪市',26),(306,'保山市',26),(307,'昭通市',26),(308,'丽江市',26),(309,'普洱市',26),(310,'临沧市',26),(311,'楚雄彝族自治州',26),(312,'红河哈尼族彝族自治州',26),(313,'文山壮族苗族自治州',26),(314,'西双版纳傣族自治州',26),(315,'大理白族自治州',26),(316,'德宏傣族景颇族自治州',26),(317,'怒江傈僳族自治州',26),(318,'迪庆藏族自治州',26),(319,'拉萨市',27),(320,'昌都地区',27),(321,'山南地区',27),(322,'日喀则地区',27),(323,'那曲地区',27),(324,'阿里地区',27),(325,'林芝地区',27),(326,'西安市',28),(327,'铜川市',28),(328,'宝鸡市',28),(329,'咸阳市',28),(330,'渭南市',28),(331,'延安市',28),(332,'汉中市',28),(333,'榆林市',28),(334,'安康市',28),(335,'商洛市',28),(336,'兰州市',29),(337,'嘉峪关市',29),(338,'金昌市',29),(339,'白银市',29),(340,'天水市',29),(341,'武威市',29),(342,'张掖市',29),(343,'平凉市',29),(344,'酒泉市',29),(345,'庆阳市',29),(346,'定西市',29),(347,'陇南市',29),(348,'临夏回族自治州',29),(349,'甘南藏族自治州',29),(350,'西宁市',30),(351,'海东地区',30),(352,'海北藏族自治州',30),(353,'黄南藏族自治州',30),(354,'海南藏族自治州',30),(355,'果洛藏族自治州',30),(356,'玉树藏族自治州',30),(357,'海西蒙古族藏族自治州',30),(358,'银川市',31),(359,'石嘴山市',31),(360,'吴忠市',31),(361,'固原市',31),(362,'中卫市',31),(363,'乌鲁木齐市',32),(364,'克拉玛依市',32),(365,'吐鲁番地区',32),(366,'哈密地区',32),(367,'昌吉回族自治州',32),(368,'博尔塔拉蒙古自治州',32),(369,'巴音郭楞蒙古自治州',32),(370,'阿克苏地区',32),(371,'克孜勒苏柯尔克孜自治州',32),(372,'喀什地区',32),(373,'和田地区',32),(374,'伊犁哈萨克自治州',32),(375,'塔城地区',32),(376,'阿勒泰地区',32),(377,'自治区直辖县级行政区划',32),(378,'东城区',33),(379,'西城区',33),(382,'朝阳区',33),(383,'丰台区',33),(384,'石景山区',33),(385,'海淀区',33),(386,'门头沟区',33),(387,'房山区',33),(388,'通州区',33),(389,'顺义区',33),(390,'昌平区',33),(391,'大兴区',33),(392,'怀柔区',33),(393,'平谷区',33),(394,'密云县',34),(395,'延庆县',34),(396,'和平区',35),(397,'河东区',35),(398,'河西区',35),(399,'南开区',35),(400,'河北区',35),(401,'红桥区',35),(404,'滨海新区',35),(405,'东丽区',35),(406,'西青区',35),(407,'津南区',35),(408,'北辰区',35),(409,'武清区',35),(410,'宝坻区',35),(411,'宁河县',36),(412,'静海县',36),(413,'蓟县',36),(414,'市辖区',37),(415,'长安区',37),(416,'桥东区',37),(417,'桥西区',37),(418,'新华区',37),(419,'井陉矿区',37),(420,'裕华区',37),(421,'井陉县',37),(422,'正定县',37),(423,'栾城县',37),(424,'行唐县',37),(425,'灵寿县',37),(426,'高邑县',37),(427,'深泽县',37),(428,'赞皇县',37),(429,'无极县',37),(430,'平山县',37),(431,'元氏县',37),(432,'赵县',37),(433,'辛集市',37),(434,'藁城市',37),(435,'晋州市',37),(436,'新乐市',37),(437,'鹿泉市',37),(438,'市辖区',38),(439,'路南区',38),(440,'路北区',38),(441,'古冶区',38),(442,'开平区',38),(443,'丰南区',38),(444,'丰润区',38),(445,'滦县',38),(446,'滦南县',38),(447,'乐亭县',38),(448,'迁西县',38),(449,'玉田县',38),(450,'唐海县',38),(451,'遵化市',38),(452,'迁安市',38),(453,'市辖区',39),(454,'海港区',39),(455,'山海关区',39),(456,'北戴河区',39),(457,'青龙满族自治县',39),(458,'昌黎县',39),(459,'抚宁县',39),(460,'卢龙县',39),(461,'市辖区',40),(462,'邯山区',40),(463,'丛台区',40),(464,'复兴区',40),(465,'峰峰矿区',40),(466,'邯郸县',40),(467,'临漳县',40),(468,'成安县',40),(469,'大名县',40),(470,'涉县',40),(471,'磁县',40),(472,'肥乡县',40),(473,'永年县',40),(474,'邱县',40),(475,'鸡泽县',40),(476,'广平县',40),(477,'馆陶县',40),(478,'魏县',40),(479,'曲周县',40),(480,'武安市',40),(481,'市辖区',41),(482,'桥东区',41),(483,'桥西区',41),(484,'邢台县',41),(485,'临城县',41),(486,'内丘县',41),(487,'柏乡县',41),(488,'隆尧县',41),(489,'任县',41),(490,'南和县',41),(491,'宁晋县',41),(492,'巨鹿县',41),(493,'新河县',41),(494,'广宗县',41),(495,'平乡县',41),(496,'威县',41),(497,'清河县',41),(498,'临西县',41),(499,'南宫市',41),(500,'沙河市',41),(501,'市辖区',42),(502,'新市区',42),(503,'北市区',42),(504,'南市区',42),(505,'满城县',42),(506,'清苑县',42),(507,'涞水县',42),(508,'阜平县',42),(509,'徐水县',42),(510,'定兴县',42),(511,'唐县',42),(512,'高阳县',42),(513,'容城县',42),(514,'涞源县',42),(515,'望都县',42),(516,'安新县',42),(517,'易县',42),(518,'曲阳县',42),(519,'蠡县',42),(520,'顺平县',42),(521,'博野县',42),(522,'雄县',42),(523,'涿州市',42),(524,'定州市',42),(525,'安国市',42),(526,'高碑店市',42),(527,'市辖区',43),(528,'桥东区',43),(529,'桥西区',43),(530,'宣化区',43),(531,'下花园区',43),(532,'宣化县',43),(533,'张北县',43),(534,'康保县',43),(535,'沽源县',43),(536,'尚义县',43),(537,'蔚县',43),(538,'阳原县',43),(539,'怀安县',43),(540,'万全县',43),(541,'怀来县',43),(542,'涿鹿县',43),(543,'赤城县',43),(544,'崇礼县',43),(545,'市辖区',44),(546,'双桥区',44),(547,'双滦区',44),(548,'鹰手营子矿区',44),(549,'承德县',44),(550,'兴隆县',44),(551,'平泉县',44),(552,'滦平县',44),(553,'隆化县',44),(554,'丰宁满族自治县',44),(555,'宽城满族自治县',44),(556,'围场满族蒙古族自治县',44),(557,'市辖区',45),(558,'新华区',45),(559,'运河区',45),(560,'沧县',45),(561,'青县',45),(562,'东光县',45),(563,'海兴县',45),(564,'盐山县',45),(565,'肃宁县',45),(566,'南皮县',45),(567,'吴桥县',45),(568,'献县',45),(569,'孟村回族自治县',45),(570,'泊头市',45),(571,'任丘市',45),(572,'黄骅市',45),(573,'河间市',45),(574,'市辖区',46),(575,'安次区',46),(576,'广阳区',46),(577,'固安县',46),(578,'永清县',46),(579,'香河县',46),(580,'大城县',46),(581,'文安县',46),(582,'大厂回族自治县',46),(583,'霸州市',46),(584,'三河市',46),(585,'市辖区',47),(586,'桃城区',47),(587,'枣强县',47),(588,'武邑县',47),(589,'武强县',47),(590,'饶阳县',47),(591,'安平县',47),(592,'故城县',47),(593,'景县',47),(594,'阜城县',47),(595,'冀州市',47),(596,'深州市',47),(597,'市辖区',48),(598,'小店区',48),(599,'迎泽区',48),(600,'杏花岭区',48),(601,'尖草坪区',48),(602,'万柏林区',48),(603,'晋源区',48),(604,'清徐县',48),(605,'阳曲县',48),(606,'娄烦县',48),(607,'古交市',48),(608,'市辖区',49),(609,'城区',49),(610,'矿区',49),(611,'南郊区',49),(612,'新荣区',49),(613,'阳高县',49),(614,'天镇县',49),(615,'广灵县',49),(616,'灵丘县',49),(617,'浑源县',49),(618,'左云县',49),(619,'大同县',49),(620,'市辖区',50),(621,'城区',50),(622,'矿区',50),(623,'郊区',50),(624,'平定县',50),(625,'盂县',50),(626,'市辖区',51),(627,'城区',51),(628,'郊区',51),(629,'长治县',51),(630,'襄垣县',51),(631,'屯留县',51),(632,'平顺县',51),(633,'黎城县',51),(634,'壶关县',51),(635,'长子县',51),(636,'武乡县',51),(637,'沁县',51),(638,'沁源县',51),(639,'潞城市',51),(640,'市辖区',52),(641,'城区',52),(642,'沁水县',52),(643,'阳城县',52),(644,'陵川县',52),(645,'泽州县',52),(646,'高平市',52),(647,'市辖区',53),(648,'朔城区',53),(649,'平鲁区',53),(650,'山阴县',53),(651,'应县',53),(652,'右玉县',53),(653,'怀仁县',53),(654,'市辖区',54),(655,'榆次区',54),(656,'榆社县',54),(657,'左权县',54),(658,'和顺县',54),(659,'昔阳县',54),(660,'寿阳县',54),(661,'太谷县',54),(662,'祁县',54),(663,'平遥县',54),(664,'灵石县',54),(665,'介休市',54),(666,'市辖区',55),(667,'盐湖区',55),(668,'临猗县',55),(669,'万荣县',55),(670,'闻喜县',55),(671,'稷山县',55),(672,'新绛县',55),(673,'绛县',55),(674,'垣曲县',55),(675,'夏县',55),(676,'平陆县',55),(677,'芮城县',55),(678,'永济市',55),(679,'河津市',55),(680,'市辖区',56),(681,'忻府区',56),(682,'定襄县',56),(683,'五台县',56),(684,'代县',56),(685,'繁峙县',56),(686,'宁武县',56),(687,'静乐县',56),(688,'神池县',56),(689,'五寨县',56),(690,'岢岚县',56),(691,'河曲县',56),(692,'保德县',56),(693,'偏关县',56),(694,'原平市',56),(695,'市辖区',57),(696,'尧都区',57),(697,'曲沃县',57),(698,'翼城县',57),(699,'襄汾县',57),(700,'洪洞县',57),(701,'古县',57),(702,'安泽县',57),(703,'浮山县',57),(704,'吉县',57),(705,'乡宁县',57),(706,'大宁县',57),(707,'隰县',57),(708,'永和县',57),(709,'蒲县',57),(710,'汾西县',57),(711,'侯马市',57),(712,'霍州市',57),(713,'市辖区',58),(714,'离石区',58),(715,'文水县',58),(716,'交城县',58),(717,'兴县',58),(718,'临县',58),(719,'柳林县',58),(720,'石楼县',58),(721,'岚县',58),(722,'方山县',58),(723,'中阳县',58),(724,'交口县',58),(725,'孝义市',58),(726,'汾阳市',58),(727,'市辖区',59),(728,'新城区',59),(729,'回民区',59),(730,'玉泉区',59),(731,'赛罕区',59),(732,'土默特左旗',59),(733,'托克托县',59),(734,'和林格尔县',59),(735,'清水河县',59),(736,'武川县',59),(737,'市辖区',60),(738,'东河区',60),(739,'昆都仑区',60),(740,'青山区',60),(741,'石拐区',60),(742,'白云鄂博矿区',60),(743,'九原区',60),(744,'土默特右旗',60),(745,'固阳县',60),(746,'达尔罕茂明安联合旗',60),(747,'市辖区',61),(748,'海勃湾区',61),(749,'海南区',61),(750,'乌达区',61),(751,'市辖区',62),(752,'红山区',62),(753,'元宝山区',62),(754,'松山区',62),(755,'阿鲁科尔沁旗',62),(756,'巴林左旗',62),(757,'巴林右旗',62),(758,'林西县',62),(759,'克什克腾旗',62),(760,'翁牛特旗',62),(761,'喀喇沁旗',62),(762,'宁城县',62),(763,'敖汉旗',62),(764,'市辖区',63),(765,'科尔沁区',63),(766,'科尔沁左翼中旗',63),(767,'科尔沁左翼后旗',63),(768,'开鲁县',63),(769,'库伦旗',63),(770,'奈曼旗',63),(771,'扎鲁特旗',63),(772,'霍林郭勒市',63),(773,'东胜区',64),(774,'达拉特旗',64),(775,'准格尔旗',64),(776,'鄂托克前旗',64),(777,'鄂托克旗',64),(778,'杭锦旗',64),(779,'乌审旗',64),(780,'伊金霍洛旗',64),(781,'市辖区',65),(782,'海拉尔区',65),(783,'阿荣旗',65),(784,'莫力达瓦达斡尔族自治旗',65),(785,'鄂伦春自治旗',65),(786,'鄂温克族自治旗',65),(787,'陈巴尔虎旗',65),(788,'新巴尔虎左旗',65),(789,'新巴尔虎右旗',65),(790,'满洲里市',65),(791,'牙克石市',65),(792,'扎兰屯市',65),(793,'额尔古纳市',65),(794,'根河市',65),(795,'市辖区',66),(796,'临河区',66),(797,'五原县',66),(798,'磴口县',66),(799,'乌拉特前旗',66),(800,'乌拉特中旗',66),(801,'乌拉特后旗',66),(802,'杭锦后旗',66),(803,'市辖区',67),(804,'集宁区',67),(805,'卓资县',67),(806,'化德县',67),(807,'商都县',67),(808,'兴和县',67),(809,'凉城县',67),(810,'察哈尔右翼前旗',67),(811,'察哈尔右翼中旗',67),(812,'察哈尔右翼后旗',67),(813,'四子王旗',67),(814,'丰镇市',67),(815,'乌兰浩特市',68),(816,'阿尔山市',68),(817,'科尔沁右翼前旗',68),(818,'科尔沁右翼中旗',68),(819,'扎赉特旗',68),(820,'突泉县',68),(821,'二连浩特市',69),(822,'锡林浩特市',69),(823,'阿巴嘎旗',69),(824,'苏尼特左旗',69),(825,'苏尼特右旗',69),(826,'东乌珠穆沁旗',69),(827,'西乌珠穆沁旗',69),(828,'太仆寺旗',69),(829,'镶黄旗',69),(830,'正镶白旗',69),(831,'正蓝旗',69),(832,'多伦县',69),(833,'阿拉善左旗',70),(834,'阿拉善右旗',70),(835,'额济纳旗',70),(836,'市辖区',71),(837,'和平区',71),(838,'沈河区',71),(839,'大东区',71),(840,'皇姑区',71),(841,'铁西区',71),(842,'苏家屯区',71),(843,'东陵区',71),(844,'沈北新区',71),(845,'于洪区',71),(846,'辽中县',71),(847,'康平县',71),(848,'法库县',71),(849,'新民市',71),(850,'市辖区',72),(851,'中山区',72),(852,'西岗区',72),(853,'沙河口区',72),(854,'甘井子区',72),(855,'旅顺口区',72),(856,'金州区',72),(857,'长海县',72),(858,'瓦房店市',72),(859,'普兰店市',72),(860,'庄河市',72),(861,'市辖区',73),(862,'铁东区',73),(863,'铁西区',73),(864,'立山区',73),(865,'千山区',73),(866,'台安县',73),(867,'岫岩满族自治县',73),(868,'海城市',73),(869,'市辖区',74),(870,'新抚区',74),(871,'东洲区',74),(872,'望花区',74),(873,'顺城区',74),(874,'抚顺县',74),(875,'新宾满族自治县',74),(876,'清原满族自治县',74),(877,'市辖区',75),(878,'平山区',75),(879,'溪湖区',75),(880,'明山区',75),(881,'南芬区',75),(882,'本溪满族自治县',75),(883,'桓仁满族自治县',75),(884,'市辖区',76),(885,'元宝区',76),(886,'振兴区',76),(887,'振安区',76),(888,'宽甸满族自治县',76),(889,'东港市',76),(890,'凤城市',76),(891,'市辖区',77),(892,'古塔区',77),(893,'凌河区',77),(894,'太和区',77),(895,'黑山县',77),(896,'义县',77),(897,'凌海市',77),(898,'北镇市',77),(899,'市辖区',78),(900,'站前区',78),(901,'西市区',78),(902,'鲅鱼圈区',78),(903,'老边区',78),(904,'盖州市',78),(905,'大石桥市',78),(906,'市辖区',79),(907,'海州区',79),(908,'新邱区',79),(909,'太平区',79),(910,'清河门区',79),(911,'细河区',79),(912,'阜新蒙古族自治县',79),(913,'彰武县',79),(914,'市辖区',80),(915,'白塔区',80),(916,'文圣区',80),(917,'宏伟区',80),(918,'弓长岭区',80),(919,'太子河区',80),(920,'辽阳县',80),(921,'灯塔市',80),(922,'市辖区',81),(923,'双台子区',81),(924,'兴隆台区',81),(925,'大洼县',81),(926,'盘山县',81),(927,'市辖区',82),(928,'银州区',82),(929,'清河区',82),(930,'铁岭县',82),(931,'西丰县',82),(932,'昌图县',82),(933,'调兵山市',82),(934,'开原市',82),(935,'市辖区',83),(936,'双塔区',83),(937,'龙城区',83),(938,'朝阳县',83),(939,'建平县',83),(940,'喀喇沁左翼蒙古族自治县',83),(941,'北票市',83),(942,'凌源市',83),(943,'市辖区',84),(944,'连山区',84),(945,'龙港区',84),(946,'南票区',84),(947,'绥中县',84),(948,'建昌县',84),(949,'兴城市',84),(950,'市辖区',85),(951,'南关区',85),(952,'宽城区',85),(953,'朝阳区',85),(954,'二道区',85),(955,'绿园区',85),(956,'双阳区',85),(957,'农安县',85),(958,'九台市',85),(959,'榆树市',85),(960,'德惠市',85),(961,'市辖区',86),(962,'昌邑区',86),(963,'龙潭区',86),(964,'船营区',86),(965,'丰满区',86),(966,'永吉县',86),(967,'蛟河市',86),(968,'桦甸市',86),(969,'舒兰市',86),(970,'磐石市',86),(971,'市辖区',87),(972,'铁西区',87),(973,'铁东区',87),(974,'梨树县',87),(975,'伊通满族自治县',87),(976,'公主岭市',87),(977,'双辽市',87),(978,'市辖区',88),(979,'龙山区',88),(980,'西安区',88),(981,'东丰县',88),(982,'东辽县',88),(983,'市辖区',89),(984,'东昌区',89),(985,'二道江区',89),(986,'通化县',89),(987,'辉南县',89),(988,'柳河县',89),(989,'梅河口市',89),(990,'集安市',89),(991,'市辖区',90),(992,'八道江区',90),(993,'抚松县',90),(994,'靖宇县',90),(995,'长白朝鲜族自治县',90),(996,'江源区',90),(997,'临江市',90),(998,'市辖区',91),(999,'宁江区',91),(1000,'前郭尔罗斯蒙古族自治县',91),(1001,'长岭县',91),(1002,'乾安县',91),(1003,'扶余县',91),(1004,'市辖区',92),(1005,'洮北区',92),(1006,'镇赉县',92),(1007,'通榆县',92),(1008,'洮南市',92),(1009,'大安市',92),(1010,'延吉市',93),(1011,'图们市',93),(1012,'敦化市',93),(1013,'珲春市',93),(1014,'龙井市',93),(1015,'和龙市',93),(1016,'汪清县',93),(1017,'安图县',93),(1018,'市辖区',94),(1019,'道里区',94),(1020,'南岗区',94),(1021,'道外区',94),(1022,'香坊区',94),(1024,'平房区',94),(1025,'松北区',94),(1026,'呼兰区',94),(1027,'依兰县',94),(1028,'方正县',94),(1029,'宾县',94),(1030,'巴彦县',94),(1031,'木兰县',94),(1032,'通河县',94),(1033,'延寿县',94),(1034,'阿城区',94),(1035,'双城市',94),(1036,'尚志市',94),(1037,'五常市',94),(1038,'市辖区',95),(1039,'龙沙区',95),(1040,'建华区',95),(1041,'铁锋区',95),(1042,'昂昂溪区',95),(1043,'富拉尔基区',95),(1044,'碾子山区',95),(1045,'梅里斯达斡尔族区',95),(1046,'龙江县',95),(1047,'依安县',95),(1048,'泰来县',95),(1049,'甘南县',95),(1050,'富裕县',95),(1051,'克山县',95),(1052,'克东县',95),(1053,'拜泉县',95),(1054,'讷河市',95),(1055,'市辖区',96),(1056,'鸡冠区',96),(1057,'恒山区',96),(1058,'滴道区',96),(1059,'梨树区',96),(1060,'城子河区',96),(1061,'麻山区',96),(1062,'鸡东县',96),(1063,'虎林市',96),(1064,'密山市',96),(1065,'市辖区',97),(1066,'向阳区',97),(1067,'工农区',97),(1068,'南山区',97),(1069,'兴安区',97),(1070,'东山区',97),(1071,'兴山区',97),(1072,'萝北县',97),(1073,'绥滨县',97),(1074,'市辖区',98),(1075,'尖山区',98),(1076,'岭东区',98),(1077,'四方台区',98),(1078,'宝山区',98),(1079,'集贤县',98),(1080,'友谊县',98),(1081,'宝清县',98),(1082,'饶河县',98),(1083,'市辖区',99),(1084,'萨尔图区',99),(1085,'龙凤区',99),(1086,'让胡路区',99),(1087,'红岗区',99),(1088,'大同区',99),(1089,'肇州县',99),(1090,'肇源县',99),(1091,'林甸县',99),(1092,'杜尔伯特蒙古族自治县',99),(1093,'市辖区',100),(1094,'伊春区',100),(1095,'南岔区',100),(1096,'友好区',100),(1097,'西林区',100),(1098,'翠峦区',100),(1099,'新青区',100),(1100,'美溪区',100),(1101,'金山屯区',100),(1102,'五营区',100),(1103,'乌马河区',100),(1104,'汤旺河区',100),(1105,'带岭区',100),(1106,'乌伊岭区',100),(1107,'红星区',100),(1108,'上甘岭区',100),(1109,'嘉荫县',100),(1110,'铁力市',100),(1111,'市辖区',101),(1113,'向阳区',101),(1114,'前进区',101),(1115,'东风区',101),(1116,'郊区',101),(1117,'桦南县',101),(1118,'桦川县',101),(1119,'汤原县',101),(1120,'抚远县',101),(1121,'同江市',101),(1122,'富锦市',101),(1123,'市辖区',102),(1124,'新兴区',102),(1125,'桃山区',102),(1126,'茄子河区',102),(1127,'勃利县',102),(1128,'市辖区',103),(1129,'东安区',103),(1130,'阳明区',103),(1131,'爱民区',103),(1132,'西安区',103),(1133,'东宁县',103),(1134,'林口县',103),(1135,'绥芬河市',103),(1136,'海林市',103),(1137,'宁安市',103),(1138,'穆棱市',103),(1139,'市辖区',104),(1140,'爱辉区',104),(1141,'嫩江县',104),(1142,'逊克县',104),(1143,'孙吴县',104),(1144,'北安市',104),(1145,'五大连池市',104),(1146,'市辖区',105),(1147,'北林区',105),(1148,'望奎县',105),(1149,'兰西县',105),(1150,'青冈县',105),(1151,'庆安县',105),(1152,'明水县',105),(1153,'绥棱县',105),(1154,'安达市',105),(1155,'肇东市',105),(1156,'海伦市',105),(1157,'呼玛县',106),(1158,'塔河县',106),(1159,'漠河县',106),(1160,'黄浦区',107),(1161,'卢湾区',107),(1162,'徐汇区',107),(1163,'长宁区',107),(1164,'静安区',107),(1165,'普陀区',107),(1166,'闸北区',107),(1167,'虹口区',107),(1168,'杨浦区',107),(1169,'闵行区',107),(1170,'宝山区',107),(1171,'嘉定区',107),(1172,'浦东新区',107),(1173,'金山区',107),(1174,'松江区',107),(1175,'青浦区',107),(1177,'奉贤区',107),(1178,'崇明县',108),(1179,'市辖区',109),(1180,'玄武区',109),(1181,'白下区',109),(1182,'秦淮区',109),(1183,'建邺区',109),(1184,'鼓楼区',109),(1185,'下关区',109),(1186,'浦口区',109),(1187,'栖霞区',109),(1188,'雨花台区',109),(1189,'江宁区',109),(1190,'六合区',109),(1191,'溧水县',109),(1192,'高淳县',109),(1193,'市辖区',110),(1194,'崇安区',110),(1195,'南长区',110),(1196,'北塘区',110),(1197,'锡山区',110),(1198,'惠山区',110),(1199,'滨湖区',110),(1200,'江阴市',110),(1201,'宜兴市',110),(1202,'市辖区',111),(1203,'鼓楼区',111),(1204,'云龙区',111),(1206,'贾汪区',111),(1207,'泉山区',111),(1208,'丰县',111),(1209,'沛县',111),(1210,'铜山区',111),(1211,'睢宁县',111),(1212,'新沂市',111),(1213,'邳州市',111),(1214,'市辖区',112),(1215,'天宁区',112),(1216,'钟楼区',112),(1217,'戚墅堰区',112),(1218,'新北区',112),(1219,'武进区',112),(1220,'溧阳市',112),(1221,'金坛市',112),(1222,'市辖区',113),(1223,'沧浪区',113),(1224,'平江区',113),(1225,'金阊区',113),(1226,'虎丘区',113),(1227,'吴中区',113),(1228,'相城区',113),(1229,'常熟市',113),(1230,'张家港市',113),(1231,'昆山市',113),(1232,'吴江市',113),(1233,'太仓市',113),(1234,'市辖区',114),(1235,'崇川区',114),(1236,'港闸区',114),(1237,'海安县',114),(1238,'如东县',114),(1239,'启东市',114),(1240,'如皋市',114),(1241,'通州区',114),(1242,'海门市',114),(1243,'市辖区',115),(1244,'连云区',115),(1245,'新浦区',115),(1246,'海州区',115),(1247,'赣榆县',115),(1248,'东海县',115),(1249,'灌云县',115),(1250,'灌南县',115),(1251,'市辖区',116),(1252,'清河区',116),(1253,'楚州区',116),(1254,'淮阴区',116),(1255,'清浦区',116),(1256,'涟水县',116),(1257,'洪泽县',116),(1258,'盱眙县',116),(1259,'金湖县',116),(1260,'市辖区',117),(1261,'亭湖区',117),(1262,'盐都区',117),(1263,'响水县',117),(1264,'滨海县',117),(1265,'阜宁县',117),(1266,'射阳县',117),(1267,'建湖县',117),(1268,'东台市',117),(1269,'大丰市',117),(1270,'市辖区',118),(1271,'广陵区',118),(1272,'邗江区',118),(1273,'维扬区',118),(1274,'宝应县',118),(1275,'仪征市',118),(1276,'高邮市',118),(1277,'江都市',118),(1278,'市辖区',119),(1279,'京口区',119),(1280,'润州区',119),(1281,'丹徒区',119),(1282,'丹阳市',119),(1283,'扬中市',119),(1284,'句容市',119),(1285,'市辖区',120),(1286,'海陵区',120),(1287,'高港区',120),(1288,'兴化市',120),(1289,'靖江市',120),(1290,'泰兴市',120),(1291,'姜堰市',120),(1292,'市辖区',121),(1293,'宿城区',121),(1294,'宿豫区',121),(1295,'沭阳县',121),(1296,'泗阳县',121),(1297,'泗洪县',121),(1298,'市辖区',122),(1299,'上城区',122),(1300,'下城区',122),(1301,'江干区',122),(1302,'拱墅区',122),(1303,'西湖区',122),(1304,'滨江区',122),(1305,'萧山区',122),(1306,'余杭区',122),(1307,'桐庐县',122),(1308,'淳安县',122),(1309,'建德市',122),(1310,'富阳市',122),(1311,'临安市',122),(1312,'市辖区',123),(1313,'海曙区',123),(1314,'江东区',123),(1315,'江北区',123),(1316,'北仑区',123),(1317,'镇海区',123),(1318,'鄞州区',123),(1319,'象山县',123),(1320,'宁海县',123),(1321,'余姚市',123),(1322,'慈溪市',123),(1323,'奉化市',123),(1324,'市辖区',124),(1325,'鹿城区',124),(1326,'龙湾区',124),(1327,'瓯海区',124),(1328,'洞头县',124),(1329,'永嘉县',124),(1330,'平阳县',124),(1331,'苍南县',124),(1332,'文成县',124),(1333,'泰顺县',124),(1334,'瑞安市',124),(1335,'乐清市',124),(1336,'市辖区',125),(1338,'秀洲区',125),(1339,'嘉善县',125),(1340,'海盐县',125),(1341,'海宁市',125),(1342,'平湖市',125),(1343,'桐乡市',125),(1344,'市辖区',126),(1345,'吴兴区',126),(1346,'南浔区',126),(1347,'德清县',126),(1348,'长兴县',126),(1349,'安吉县',126),(1350,'市辖区',127),(1351,'越城区',127),(1352,'绍兴县',127),(1353,'新昌县',127),(1354,'诸暨市',127),(1355,'上虞市',127),(1356,'嵊州市',127),(1357,'市辖区',128),(1358,'婺城区',128),(1359,'金东区',128),(1360,'武义县',128),(1361,'浦江县',128),(1362,'磐安县',128),(1363,'兰溪市',128),(1364,'义乌市',128),(1365,'东阳市',128),(1366,'永康市',128),(1367,'市辖区',129),(1368,'柯城区',129),(1369,'衢江区',129),(1370,'常山县',129),(1371,'开化县',129),(1372,'龙游县',129),(1373,'江山市',129),(1374,'市辖区',130),(1375,'定海区',130),(1376,'普陀区',130),(1377,'岱山县',130),(1378,'嵊泗县',130),(1379,'市辖区',131),(1380,'椒江区',131),(1381,'黄岩区',131),(1382,'路桥区',131),(1383,'玉环县',131),(1384,'三门县',131),(1385,'天台县',131),(1386,'仙居县',131),(1387,'温岭市',131),(1388,'临海市',131),(1389,'市辖区',132),(1390,'莲都区',132),(1391,'青田县',132),(1392,'缙云县',132),(1393,'遂昌县',132),(1394,'松阳县',132),(1395,'云和县',132),(1396,'庆元县',132),(1397,'景宁畲族自治县',132),(1398,'龙泉市',132),(1399,'市辖区',133),(1400,'瑶海区',133),(1401,'庐阳区',133),(1402,'蜀山区',133),(1403,'包河区',133),(1404,'长丰县',133),(1405,'肥东县',133),(1406,'肥西县',133),(1407,'市辖区',1412),(1408,'镜湖区',1412),(1409,'三山区',1412),(1410,'弋江区',1412),(1411,'鸠江区',1412),(1412,'芜湖市',134),(1413,'繁昌县',1412),(1414,'南陵县',1412),(1415,'市辖区',135),(1416,'龙子湖区',135),(1417,'蚌山区',135),(1418,'禹会区',135),(1419,'淮上区',135),(1420,'怀远县',135),(1421,'五河县',135),(1422,'固镇县',135),(1423,'市辖区',136),(1424,'大通区',136),(1425,'田家庵区',136),(1426,'谢家集区',136),(1427,'八公山区',136),(1428,'潘集区',136),(1429,'凤台县',136),(1430,'市辖区',137),(1431,'金家庄区',137),(1432,'花山区',137),(1433,'雨山区',137),(1434,'当涂县',137),(1435,'市辖区',138),(1436,'杜集区',138),(1437,'相山区',138),(1438,'烈山区',138),(1439,'濉溪县',138),(1440,'市辖区',139),(1441,'铜官山区',139),(1442,'狮子山区',139),(1443,'郊区',139),(1444,'铜陵县',139),(1445,'市辖区',140),(1446,'迎江区',140),(1447,'大观区',140),(1448,'宜秀区',140),(1449,'怀宁县',140),(1450,'枞阳县',140),(1451,'潜山县',140),(1452,'太湖县',140),(1453,'宿松县',140),(1454,'望江县',140),(1455,'岳西县',140),(1456,'桐城市',140),(1457,'市辖区',141),(1458,'屯溪区',141),(1459,'黄山区',141),(1460,'徽州区',141),(1461,'歙县',141),(1462,'休宁县',141),(1463,'黟县',141),(1464,'祁门县',141),(1465,'市辖区',142),(1466,'琅琊区',142),(1467,'南谯区',142),(1468,'来安县',142),(1469,'全椒县',142),(1470,'定远县',142),(1471,'凤阳县',142),(1472,'天长市',142),(1473,'明光市',142),(1474,'市辖区',143),(1475,'颍州区',143),(1476,'颍东区',143),(1477,'颍泉区',143),(1478,'临泉县',143),(1479,'太和县',143),(1480,'阜南县',143),(1481,'颍上县',143),(1482,'界首市',143),(1483,'市辖区',144),(1484,'埇桥区',144),(1485,'砀山县',144),(1486,'萧县',144),(1487,'灵璧县',144),(1488,'泗县',144),(1489,'市辖区',145),(1490,'居巢区',145),(1491,'庐江县',145),(1492,'无为县',145),(1493,'含山县',145),(1494,'和县',145),(1495,'市辖区',146),(1496,'金安区',146),(1497,'裕安区',146),(1498,'寿县',146),(1499,'霍邱县',146),(1500,'舒城县',146),(1501,'金寨县',146),(1502,'霍山县',146),(1503,'市辖区',147),(1504,'谯城区',147),(1505,'涡阳县',147),(1506,'蒙城县',147),(1507,'利辛县',147),(1508,'市辖区',148),(1509,'贵池区',148),(1510,'东至县',148),(1511,'石台县',148),(1512,'青阳县',148),(1513,'市辖区',149),(1514,'宣州区',149),(1515,'郎溪县',149),(1516,'广德县',149),(1517,'泾县',149),(1518,'绩溪县',149),(1519,'旌德县',149),(1520,'宁国市',149),(1521,'市辖区',150),(1522,'鼓楼区',150),(1523,'台江区',150),(1524,'仓山区',150),(1525,'马尾区',150),(1526,'晋安区',150),(1527,'闽侯县',150),(1528,'连江县',150),(1529,'罗源县',150),(1530,'闽清县',150),(1531,'永泰县',150),(1532,'平潭县',150),(1533,'福清市',150),(1534,'长乐市',150),(1535,'市辖区',151),(1536,'思明区',151),(1537,'海沧区',151),(1538,'湖里区',151),(1539,'集美区',151),(1540,'同安区',151),(1541,'翔安区',151),(1542,'市辖区',152);

insert into kang_region values (1543,'城厢区',152),(1544,'涵江区',152),(1545,'荔城区',152),(1546,'秀屿区',152),(1547,'仙游县',152),(1548,'市辖区',153),(1549,'梅列区',153),(1550,'三元区',153),(1551,'明溪县',153),(1552,'清流县',153),(1553,'宁化县',153),(1554,'大田县',153),(1555,'尤溪县',153),(1556,'沙县',153),(1557,'将乐县',153),(1558,'泰宁县',153),(1559,'建宁县',153),(1560,'永安市',153),(1561,'市辖区',154),(1562,'鲤城区',154),(1563,'丰泽区',154),(1564,'洛江区',154),(1565,'泉港区',154),(1566,'惠安县',154),(1567,'安溪县',154),(1568,'永春县',154),(1569,'德化县',154),(1570,'金门县',154),(1571,'石狮市',154),(1572,'晋江市',154),(1573,'南安市',154),(1574,'市辖区',155),(1575,'芗城区',155),(1576,'龙文区',155),(1577,'云霄县',155),(1578,'漳浦县',155),(1579,'诏安县',155),(1580,'长泰县',155),(1581,'东山县',155),(1582,'南靖县',155),(1583,'平和县',155),(1584,'华安县',155),(1585,'龙海市',155),(1586,'市辖区',156),(1587,'延平区',156),(1588,'顺昌县',156),(1589,'浦城县',156),(1590,'光泽县',156),(1591,'松溪县',156),(1592,'政和县',156),(1593,'邵武市',156),(1594,'武夷山市',156),(1595,'建瓯市',156),(1596,'建阳市',156),(1597,'市辖区',157),(1598,'新罗区',157),(1599,'长汀县',157),(1600,'永定县',157),(1601,'上杭县',157),(1602,'武平县',157),(1603,'连城县',157),(1604,'漳平市',157),(1605,'市辖区',158),(1606,'蕉城区',158),(1607,'霞浦县',158),(1608,'古田县',158),(1609,'屏南县',158),(1610,'寿宁县',158),(1611,'周宁县',158),(1612,'柘荣县',158),(1613,'福安市',158),(1614,'福鼎市',158),(1615,'市辖区',159),(1616,'东湖区',159),(1617,'西湖区',159),(1618,'青云谱区',159),(1619,'湾里区',159),(1620,'青山湖区',159),(1621,'南昌县',159),(1622,'新建县',159),(1623,'安义县',159),(1624,'进贤县',159),(1625,'市辖区',160),(1626,'昌江区',160),(1627,'珠山区',160),(1628,'浮梁县',160),(1629,'乐平市',160),(1630,'市辖区',161),(1631,'安源区',161),(1632,'湘东区',161),(1633,'莲花县',161),(1634,'上栗县',161),(1635,'芦溪县',161),(1636,'市辖区',162),(1637,'庐山区',162),(1638,'浔阳区',162),(1639,'九江县',162),(1640,'武宁县',162),(1641,'修水县',162),(1642,'永修县',162),(1643,'德安县',162),(1644,'星子县',162),(1645,'都昌县',162),(1646,'湖口县',162),(1647,'彭泽县',162),(1648,'瑞昌市',162),(1649,'市辖区',163),(1650,'渝水区',163),(1651,'分宜县',163),(1652,'市辖区',164),(1653,'月湖区',164),(1654,'余江县',164),(1655,'贵溪市',164),(1656,'市辖区',165),(1657,'章贡区',165),(1658,'赣县',165),(1659,'信丰县',165),(1660,'大余县',165),(1661,'上犹县',165),(1662,'崇义县',165),(1663,'安远县',165),(1664,'龙南县',165),(1665,'定南县',165),(1666,'全南县',165),(1667,'宁都县',165),(1668,'于都县',165),(1669,'兴国县',165),(1670,'会昌县',165),(1671,'寻乌县',165),(1672,'石城县',165),(1673,'瑞金市',165),(1674,'南康市',165),(1675,'市辖区',166),(1676,'吉州区',166),(1677,'青原区',166),(1678,'吉安县',166),(1679,'吉水县',166),(1680,'峡江县',166),(1681,'新干县',166),(1682,'永丰县',166),(1683,'泰和县',166),(1684,'遂川县',166),(1685,'万安县',166),(1686,'安福县',166),(1687,'永新县',166),(1688,'井冈山市',166),(1689,'市辖区',167),(1690,'袁州区',167),(1691,'奉新县',167),(1692,'万载县',167),(1693,'上高县',167),(1694,'宜丰县',167),(1695,'靖安县',167),(1696,'铜鼓县',167),(1697,'丰城市',167),(1698,'樟树市',167),(1699,'高安市',167),(1700,'市辖区',168),(1701,'临川区',168),(1702,'南城县',168),(1703,'黎川县',168),(1704,'南丰县',168),(1705,'崇仁县',168),(1706,'乐安县',168),(1707,'宜黄县',168),(1708,'金溪县',168),(1709,'资溪县',168),(1710,'东乡县',168),(1711,'广昌县',168),(1712,'市辖区',169),(1713,'信州区',169),(1714,'上饶县',169),(1715,'广丰县',169),(1716,'玉山县',169),(1717,'铅山县',169),(1718,'横峰县',169),(1719,'弋阳县',169),(1720,'余干县',169),(1721,'鄱阳县',169),(1722,'万年县',169),(1723,'婺源县',169),(1724,'德兴市',169),(1725,'市辖区',170),(1726,'历下区',170),(1727,'市中区',170),(1728,'槐荫区',170),(1729,'天桥区',170),(1730,'历城区',170),(1731,'长清区',170),(1732,'平阴县',170),(1733,'济阳县',170),(1734,'商河县',170),(1735,'章丘市',170),(1736,'市辖区',171),(1737,'市南区',171),(1738,'市北区',171),(1739,'四方区',171),(1740,'黄岛区',171),(1741,'崂山区',171),(1742,'李沧区',171),(1743,'城阳区',171),(1744,'胶州市',171),(1745,'即墨市',171),(1746,'平度市',171),(1747,'胶南市',171),(1748,'莱西市',171),(1749,'市辖区',172),(1750,'淄川区',172),(1751,'张店区',172),(1752,'博山区',172),(1753,'临淄区',172),(1754,'周村区',172),(1755,'桓台县',172),(1756,'高青县',172),(1757,'沂源县',172),(1758,'市辖区',173),(1759,'市中区',173),(1760,'薛城区',173),(1761,'峄城区',173),(1762,'台儿庄区',173),(1763,'山亭区',173),(1764,'滕州市',173),(1765,'市辖区',174),(1766,'东营区',174),(1767,'河口区',174),(1768,'垦利县',174),(1769,'利津县',174),(1770,'广饶县',174),(1771,'市辖区',175),(1772,'芝罘区',175),(1773,'福山区',175),(1774,'牟平区',175),(1775,'莱山区',175),(1776,'长岛县',175),(1777,'龙口市',175),(1778,'莱阳市',175),(1779,'莱州市',175),(1780,'蓬莱市',175),(1781,'招远市',175),(1782,'栖霞市',175),(1783,'海阳市',175),(1784,'市辖区',176),(1785,'潍城区',176),(1786,'寒亭区',176),(1787,'坊子区',176),(1788,'奎文区',176),(1789,'临朐县',176),(1790,'昌乐县',176),(1791,'青州市',176),(1792,'诸城市',176),(1793,'寿光市',176),(1794,'安丘市',176),(1795,'高密市',176),(1796,'昌邑市',176),(1797,'市辖区',177),(1798,'市中区',177),(1799,'任城区',177),(1800,'微山县',177),(1801,'鱼台县',177),(1802,'金乡县',177),(1803,'嘉祥县',177),(1804,'汶上县',177),(1805,'泗水县',177),(1806,'梁山县',177),(1807,'曲阜市',177),(1808,'兖州市',177),(1809,'邹城市',177),(1810,'市辖区',178),(1811,'泰山区',178),(1812,'岱岳区',178),(1813,'宁阳县',178),(1814,'东平县',178),(1815,'新泰市',178),(1816,'肥城市',178),(1817,'市辖区',179),(1818,'环翠区',179),(1819,'文登市',179),(1820,'荣成市',179),(1821,'乳山市',179),(1822,'市辖区',180),(1823,'东港区',180),(1824,'岚山区',180),(1825,'五莲县',180),(1826,'莒县',180),(1827,'市辖区',181),(1828,'莱城区',181),(1829,'钢城区',181),(1830,'市辖区',182),(1831,'兰山区',182),(1832,'罗庄区',182),(1833,'河东区',182),(1834,'沂南县',182),(1835,'郯城县',182),(1836,'沂水县',182),(1837,'苍山县',182),(1838,'费县',182),(1839,'平邑县',182),(1840,'莒南县',182),(1841,'蒙阴县',182),(1842,'临沭县',182),(1843,'市辖区',183),(1844,'德城区',183),(1845,'陵县',183),(1846,'宁津县',183),(1847,'庆云县',183),(1848,'临邑县',183),(1849,'齐河县',183),(1850,'平原县',183),(1851,'夏津县',183),(1852,'武城县',183),(1853,'乐陵市',183),(1854,'禹城市',183),(1855,'市辖区',184),(1856,'东昌府区',184),(1857,'阳谷县',184),(1858,'莘县',184),(1859,'茌平县',184),(1860,'东阿县',184),(1861,'冠县',184),(1862,'高唐县',184),(1863,'临清市',184),(1864,'市辖区',185),(1865,'滨城区',185),(1866,'惠民县',185),(1867,'阳信县',185),(1868,'无棣县',185),(1869,'沾化县',185),(1870,'博兴县',185),(1871,'邹平县',185),(1873,'牡丹区',186),(1874,'曹县',186),(1875,'单县',186),(1876,'成武县',186),(1877,'巨野县',186),(1878,'郓城县',186),(1879,'鄄城县',186),(1880,'定陶县',186),(1881,'东明县',186),(1882,'市辖区',187),(1883,'中原区',187),(1884,'二七区',187),(1885,'管城回族区',187),(1886,'金水区',187),(1887,'上街区',187),(1888,'惠济区',187),(1889,'中牟县',187),(1890,'巩义市',187),(1891,'荥阳市',187),(1892,'新密市',187),(1893,'新郑市',187),(1894,'登封市',187),(1895,'市辖区',188),(1896,'龙亭区',188),(1897,'顺河回族区',188),(1898,'鼓楼区',188),(1899,'禹王台区',188),(1900,'金明区',188),(1901,'杞县',188),(1902,'通许县',188),(1903,'尉氏县',188),(1904,'开封县',188),(1905,'兰考县',188),(1906,'市辖区',189),(1907,'老城区',189),(1908,'西工区',189),(1909,'瀍河回族区',189),(1910,'涧西区',189),(1911,'吉利区',189),(1912,'洛龙区',189),(1913,'孟津县',189),(1914,'新安县',189),(1915,'栾川县',189),(1916,'嵩县',189),(1917,'汝阳县',189),(1918,'宜阳县',189),(1919,'洛宁县',189),(1920,'伊川县',189),(1921,'偃师市',189),(1922,'市辖区',190),(1923,'新华区',190),(1924,'卫东区',190),(1925,'石龙区',190),(1926,'湛河区',190),(1927,'宝丰县',190),(1928,'叶县',190),(1929,'鲁山县',190),(1930,'郏县',190),(1931,'舞钢市',190),(1932,'汝州市',190),(1933,'市辖区',191),(1934,'文峰区',191),(1935,'北关区',191),(1936,'殷都区',191),(1937,'龙安区',191),(1938,'安阳县',191),(1939,'汤阴县',191),(1940,'滑县',191),(1941,'内黄县',191),(1942,'林州市',191),(1943,'市辖区',192),(1944,'鹤山区',192),(1945,'山城区',192),(1946,'淇滨区',192),(1947,'浚县',192),(1948,'淇县',192),(1949,'市辖区',193),(1950,'红旗区',193),(1951,'卫滨区',193),(1952,'凤泉区',193),(1953,'牧野区',193),(1954,'新乡县',193),(1955,'获嘉县',193),(1956,'原阳县',193),(1957,'延津县',193),(1958,'封丘县',193),(1959,'长垣县',193),(1960,'卫辉市',193),(1961,'辉县市',193),(1962,'市辖区',194),(1963,'解放区',194),(1964,'中站区',194),(1965,'马村区',194),(1966,'山阳区',194),(1967,'修武县',194),(1968,'博爱县',194),(1969,'武陟县',194),(1970,'温县',194),(1971,'济源市',194),(1972,'沁阳市',194),(1973,'孟州市',194),(1974,'市辖区',195),(1975,'华龙区',195),(1976,'清丰县',195),(1977,'南乐县',195),(1978,'范县',195),(1979,'台前县',195),(1980,'濮阳县',195),(1981,'市辖区',196),(1982,'魏都区',196),(1983,'许昌县',196),(1984,'鄢陵县',196),(1985,'襄城县',196),(1986,'禹州市',196),(1987,'长葛市',196),(1988,'市辖区',197),(1989,'源汇区',197),(1990,'郾城区',197),(1991,'召陵区',197),(1992,'舞阳县',197),(1993,'临颍县',197),(1994,'市辖区',198),(1995,'湖滨区',198),(1996,'渑池县',198),(1997,'陕县',198),(1998,'卢氏县',198),(1999,'义马市',198),(2000,'灵宝市',198),(2001,'市辖区',199),(2002,'宛城区',199),(2003,'卧龙区',199),(2004,'南召县',199),(2005,'方城县',199),(2006,'西峡县',199),(2007,'镇平县',199),(2008,'内乡县',199),(2009,'淅川县',199),(2010,'社旗县',199),(2011,'唐河县',199),(2012,'新野县',199),(2013,'桐柏县',199),(2014,'邓州市',199),(2015,'市辖区',200),(2016,'梁园区',200),(2017,'睢阳区',200),(2018,'民权县',200),(2019,'睢县',200),(2020,'宁陵县',200),(2021,'柘城县',200),(2022,'虞城县',200),(2023,'夏邑县',200),(2024,'永城市',200),(2025,'市辖区',201),(2026,'浉河区',201),(2027,'平桥区',201),(2028,'罗山县',201),(2029,'光山县',201),(2030,'新县',201),(2031,'商城县',201),(2032,'固始县',201),(2033,'潢川县',201),(2034,'淮滨县',201),(2035,'息县',201),(2036,'市辖区',202),(2037,'川汇区',202),(2038,'扶沟县',202),(2039,'西华县',202),(2040,'商水县',202),(2041,'沈丘县',202),(2042,'郸城县',202),(2043,'淮阳县',202),(2044,'太康县',202),(2045,'鹿邑县',202),(2046,'项城市',202),(2047,'市辖区',203),(2048,'驿城区',203),(2049,'西平县',203),(2050,'上蔡县',203),(2051,'平舆县',203),(2052,'正阳县',203),(2053,'确山县',203),(2054,'泌阳县',203),(2055,'汝南县',203),(2056,'遂平县',203),(2057,'新蔡县',203),(2058,'市辖区',204),(2059,'江岸区',204),(2060,'江汉区',204),(2061,'硚口区',204),(2062,'汉阳区',204),(2063,'武昌区',204),(2064,'青山区',204),(2065,'洪山区',204),(2066,'东西湖区',204),(2067,'汉南区',204),(2068,'蔡甸区',204),(2069,'江夏区',204),(2070,'黄陂区',204),(2071,'新洲区',204),(2072,'市辖区',205),(2073,'黄石港区',205),(2074,'西塞山区',205),(2075,'下陆区',205),(2076,'铁山区',205),(2077,'阳新县',205),(2078,'大冶市',205),(2079,'市辖区',206),(2080,'茅箭区',206),(2081,'张湾区',206),(2082,'郧县',206),(2083,'郧西县',206),(2084,'竹山县',206),(2085,'竹溪县',206),(2086,'房县',206),(2087,'丹江口市',206),(2088,'市辖区',207),(2089,'西陵区',207),(2090,'伍家岗区',207),(2091,'点军区',207),(2092,'猇亭区',207),(2093,'夷陵区',207),(2094,'远安县',207),(2095,'兴山县',207),(2096,'秭归县',207),(2097,'长阳土家族自治县',207),(2098,'五峰土家族自治县',207),(2099,'宜都市',207),(2100,'当阳市',207),(2101,'枝江市',207),(2102,'市辖区',208),(2103,'襄城区',208),(2104,'樊城区',208),(2105,'襄阳区',208),(2106,'南漳县',208),(2107,'谷城县',208),(2108,'保康县',208),(2109,'老河口市',208),(2110,'枣阳市',208),(2111,'宜城市',208),(2112,'市辖区',209),(2113,'梁子湖区',209),(2114,'华容区',209),(2115,'鄂城区',209),(2116,'市辖区',210),(2117,'东宝区',210),(2118,'掇刀区',210),(2119,'京山县',210),(2120,'沙洋县',210),(2121,'钟祥市',210),(2122,'市辖区',211),(2123,'孝南区',211),(2124,'孝昌县',211),(2125,'大悟县',211),(2126,'云梦县',211),(2127,'应城市',211),(2128,'安陆市',211),(2129,'汉川市',211),(2130,'市辖区',212),(2131,'沙市区',212),(2132,'荆州区',212),(2133,'公安县',212),(2134,'监利县',212),(2135,'江陵县',212),(2136,'石首市',212),(2137,'洪湖市',212),(2138,'松滋市',212),(2139,'市辖区',213),(2140,'黄州区',213),(2141,'团风县',213),(2142,'红安县',213),(2143,'罗田县',213),(2144,'英山县',213),(2145,'浠水县',213),(2146,'蕲春县',213),(2147,'黄梅县',213),(2148,'麻城市',213),(2149,'武穴市',213),(2150,'市辖区',214),(2151,'咸安区',214),(2152,'嘉鱼县',214),(2153,'通城县',214),(2154,'崇阳县',214),(2155,'通山县',214),(2156,'赤壁市',214),(2157,'市辖区',215),(2158,'曾都区',215),(2159,'广水市',215),(2160,'恩施市',216),(2161,'利川市',216),(2162,'建始县',216),(2163,'巴东县',216),(2164,'宣恩县',216),(2165,'咸丰县',216),(2166,'来凤县',216),(2167,'鹤峰县',216),(2168,'仙桃市',217),(2169,'潜江市',217),(2170,'天门市',217),(2171,'神农架林区',217),(2172,'市辖区',218),(2173,'芙蓉区',218),(2174,'天心区',218),(2175,'岳麓区',218),(2176,'开福区',218),(2177,'雨花区',218),(2178,'长沙县',218),(2179,'望城县',218),(2180,'宁乡县',218),(2181,'浏阳市',218),(2182,'市辖区',219),(2183,'荷塘区',219),(2184,'芦淞区',219),(2185,'石峰区',219),(2186,'天元区',219),(2187,'株洲县',219),(2188,'攸县',219),(2189,'茶陵县',219),(2190,'炎陵县',219),(2191,'醴陵市',219),(2192,'市辖区',220),(2193,'雨湖区',220),(2194,'岳塘区',220),(2195,'湘潭县',220),(2196,'湘乡市',220),(2197,'韶山市',220),(2198,'市辖区',221),(2199,'珠晖区',221),(2200,'雁峰区',221),(2201,'石鼓区',221),(2202,'蒸湘区',221),(2203,'南岳区',221),(2204,'衡阳县',221),(2205,'衡南县',221),(2206,'衡山县',221),(2207,'衡东县',221),(2208,'祁东县',221),(2209,'耒阳市',221),(2210,'常宁市',221),(2211,'市辖区',222),(2212,'双清区',222),(2213,'大祥区',222),(2214,'北塔区',222),(2215,'邵东县',222),(2216,'新邵县',222),(2217,'邵阳县',222),(2218,'隆回县',222),(2219,'洞口县',222),(2220,'绥宁县',222),(2221,'新宁县',222),(2222,'城步苗族自治县',222),(2223,'武冈市',222),(2224,'市辖区',223),(2225,'岳阳楼区',223),(2226,'云溪区',223),(2227,'君山区',223),(2228,'岳阳县',223),(2229,'华容县',223),(2230,'湘阴县',223),(2231,'平江县',223),(2232,'汨罗市',223),(2233,'临湘市',223),(2234,'市辖区',224),(2235,'武陵区',224),(2236,'鼎城区',224),(2237,'安乡县',224),(2238,'汉寿县',224),(2239,'澧县',224),(2240,'临澧县',224),(2241,'桃源县',224),(2242,'石门县',224),(2243,'津市市',224),(2244,'市辖区',225),(2245,'永定区',225),(2246,'武陵源区',225),(2247,'慈利县',225),(2248,'桑植县',225),(2249,'市辖区',226),(2250,'资阳区',226),(2251,'赫山区',226),(2252,'南县',226),(2253,'桃江县',226),(2254,'安化县',226),(2255,'沅江市',226),(2256,'市辖区',227),(2257,'北湖区',227),(2258,'苏仙区',227),(2259,'桂阳县',227),(2260,'宜章县',227),(2261,'永兴县',227),(2262,'嘉禾县',227),(2263,'临武县',227),(2264,'汝城县',227),(2265,'桂东县',227),(2266,'安仁县',227),(2267,'资兴市',227),(2268,'市辖区',228),(2270,'冷水滩区',228),(2271,'祁阳县',228),(2272,'东安县',228),(2273,'双牌县',228),(2274,'道县',228),(2275,'江永县',228),(2276,'宁远县',228),(2277,'蓝山县',228),(2278,'新田县',228),(2279,'江华瑶族自治县',228),(2280,'市辖区',229),(2281,'鹤城区',229),(2282,'中方县',229),(2283,'沅陵县',229),(2284,'辰溪县',229),(2285,'溆浦县',229),(2286,'会同县',229),(2287,'麻阳苗族自治县',229),(2288,'新晃侗族自治县',229),(2289,'芷江侗族自治县',229),(2290,'靖州苗族侗族自治县',229),(2291,'通道侗族自治县',229),(2292,'洪江市',229),(2293,'市辖区',230),(2294,'娄星区',230),(2295,'双峰县',230),(2296,'新化县',230),(2297,'冷水江市',230),(2298,'涟源市',230),(2299,'吉首市',231),(2300,'泸溪县',231),(2301,'凤凰县',231),(2302,'花垣县',231),(2303,'保靖县',231),(2304,'古丈县',231),(2305,'永顺县',231),(2306,'龙山县',231),(2307,'市辖区',232),(2308,'南沙区',232),(2309,'荔湾区',232),(2310,'越秀区',232),(2311,'海珠区',232),(2312,'天河区',232),(2313,'萝岗区',232),(2314,'白云区',232),(2315,'黄埔区',232),(2316,'番禺区',232),(2317,'花都区',232),(2318,'增城市',232),(2319,'从化市',232),(2320,'市辖区',233),(2321,'武江区',233),(2322,'浈江区',233),(2323,'曲江区',233),(2324,'始兴县',233),(2325,'仁化县',233),(2326,'翁源县',233),(2327,'乳源瑶族自治县',233),(2328,'新丰县',233),(2329,'乐昌市',233),(2330,'南雄市',233),(2331,'市辖区',234),(2332,'罗湖区',234),(2333,'福田区',234),(2334,'南山区',234),(2335,'宝安区',234),(2336,'龙岗区',234),(2337,'盐田区',234),(2338,'市辖区',235),(2339,'香洲区',235),(2340,'斗门区',235),(2341,'金湾区',235),(2342,'市辖区',236),(2343,'龙湖区',236),(2344,'金平区',236),(2345,'濠江区',236),(2346,'潮阳区',236),(2347,'潮南区',236),(2348,'澄海区',236),(2349,'南澳县',236),(2350,'市辖区',237),(2351,'禅城区',237),(2352,'南海区',237),(2353,'顺德区',237),(2354,'三水区',237),(2355,'高明区',237),(2356,'市辖区',238),(2357,'蓬江区',238),(2358,'江海区',238),(2359,'新会区',238),(2360,'台山市',238),(2361,'开平市',238),(2362,'鹤山市',238),(2363,'恩平市',238),(2364,'市辖区',239),(2365,'赤坎区',239),(2366,'霞山区',239),(2367,'坡头区',239),(2368,'麻章区',239),(2369,'遂溪县',239),(2370,'徐闻县',239),(2371,'廉江市',239),(2372,'雷州市',239),(2373,'吴川市',239),(2374,'市辖区',240),(2375,'茂南区',240),(2376,'茂港区',240),(2377,'电白县',240),(2378,'高州市',240),(2379,'化州市',240),(2380,'信宜市',240),(2381,'市辖区',241),(2382,'端州区',241),(2383,'鼎湖区',241),(2384,'广宁县',241),(2385,'怀集县',241),(2386,'封开县',241),(2387,'德庆县',241),(2388,'高要市',241),(2389,'四会市',241),(2390,'市辖区',242),(2391,'惠城区',242),(2392,'惠阳区',242),(2393,'博罗县',242),(2394,'惠东县',242),(2395,'龙门县',242),(2396,'市辖区',243),(2397,'梅江区',243),(2398,'梅县',243),(2399,'大埔县',243),(2400,'丰顺县',243),(2401,'五华县',243),(2402,'平远县',243),(2403,'蕉岭县',243),(2404,'兴宁市',243),(2405,'市辖区',244),(2406,'城区',244),(2407,'海丰县',244),(2408,'陆河县',244),(2409,'陆丰市',244),(2410,'市辖区',245),(2411,'源城区',245),(2412,'紫金县',245),(2413,'龙川县',245),(2414,'连平县',245),(2415,'和平县',245),(2416,'东源县',245),(2417,'市辖区',246),(2418,'江城区',246),(2419,'阳西县',246),(2420,'阳东县',246),(2421,'阳春市',246),(2422,'市辖区',247),(2423,'清城区',247),(2424,'佛冈县',247),(2425,'阳山县',247),(2426,'连山壮族瑶族自治县',247),(2427,'连南瑶族自治县',247),(2428,'清新县',247),(2429,'英德市',247),(2430,'连州市',247),(2431,'市辖区',250),(2432,'湘桥区',250),(2433,'潮安县',250),(2434,'饶平县',250),(2435,'市辖区',251),(2436,'榕城区',251),(2437,'揭东县',251),(2438,'揭西县',251),(2439,'惠来县',251),(2440,'普宁市',251),(2441,'市辖区',252),(2442,'云城区',252),(2443,'新兴县',252),(2444,'郁南县',252),(2445,'云安县',252),(2446,'罗定市',252),(2447,'市辖区',253),(2448,'兴宁区',253),(2449,'青秀区',253),(2450,'江南区',253),(2451,'西乡塘区',253),(2452,'良庆区',253),(2453,'邕宁区',253),(2454,'武鸣县',253),(2455,'隆安县',253),(2456,'马山县',253),(2457,'上林县',253),(2458,'宾阳县',253),(2459,'横县',253),(2460,'市辖区',254),(2461,'城中区',254),(2462,'鱼峰区',254),(2463,'柳南区',254),(2464,'柳北区',254),(2465,'柳江县',254),(2466,'柳城县',254),(2467,'鹿寨县',254),(2468,'融安县',254),(2469,'融水苗族自治县',254),(2470,'三江侗族自治县',254),(2471,'市辖区',255),(2472,'秀峰区',255),(2473,'叠彩区',255),(2474,'象山区',255),(2475,'七星区',255),(2476,'雁山区',255),(2477,'阳朔县',255),(2478,'临桂县',255),(2479,'灵川县',255),(2480,'全州县',255),(2481,'兴安县',255),(2482,'永福县',255),(2483,'灌阳县',255),(2484,'龙胜各族自治县',255),(2485,'资源县',255),(2486,'平乐县',255),(2487,'荔蒲县',255),(2488,'恭城瑶族自治县',255),(2489,'市辖区',256),(2490,'万秀区',256),(2491,'蝶山区',256),(2492,'长洲区',256),(2493,'苍梧县',256),(2494,'藤县',256),(2495,'蒙山县',256),(2496,'岑溪市',256),(2497,'市辖区',257),(2498,'海城区',257),(2499,'银海区',257),(2500,'铁山港区',257),(2501,'合浦县',257),(2502,'市辖区',258),(2503,'港口区',258),(2504,'防城区',258),(2505,'上思县',258),(2506,'东兴市',258),(2507,'市辖区',259),(2508,'钦南区',259),(2509,'钦北区',259),(2510,'灵山县',259),(2511,'浦北县',259),(2512,'市辖区',260),(2513,'港北区',260),(2514,'港南区',260),(2515,'覃塘区',260),(2516,'平南县',260),(2517,'桂平市',260),(2518,'市辖区',261),(2519,'玉州区',261),(2520,'容县',261),(2521,'陆川县',261),(2522,'博白县',261),(2523,'兴业县',261),(2524,'北流市',261),(2525,'市辖区',262),(2526,'右江区',262),(2527,'田阳县',262),(2528,'田东县',262),(2529,'平果县',262),(2530,'德保县',262),(2531,'靖西县',262),(2532,'那坡县',262),(2533,'凌云县',262),(2534,'乐业县',262),(2535,'田林县',262),(2536,'西林县',262),(2537,'隆林各族自治县',262),(2538,'市辖区',263),(2539,'八步区',263),(2540,'昭平县',263),(2541,'钟山县',263),(2542,'富川瑶族自治县',263),(2543,'市辖区',264),(2544,'金城江区',264),(2545,'南丹县',264),(2546,'天峨县',264),(2547,'凤山县',264),(2548,'东兰县',264),(2549,'罗城仫佬族自治县',264),(2550,'环江毛南族自治县',264),(2551,'巴马瑶族自治县',264),(2552,'都安瑶族自治县',264),(2553,'大化瑶族自治县',264),(2554,'宜州市',264),(2555,'市辖区',265),(2556,'兴宾区',265),(2557,'忻城县',265),(2558,'象州县',265),(2559,'武宣县',265),(2560,'金秀瑶族自治县',265),(2561,'合山市',265),(2562,'市辖区',266),(2563,'江洲区',266),(2564,'扶绥县',266),(2565,'宁明县',266),(2566,'龙州县',266),(2567,'大新县',266),(2568,'天等县',266),(2569,'凭祥市',266),(2570,'市辖区',267),(2571,'秀英区',267),(2572,'龙华区',267),(2573,'琼山区',267),(2574,'美兰区',267),(2575,'市辖区',268),(2576,'五指山市',269),(2577,'琼海市',269),(2578,'儋州市',269),(2579,'文昌市',269),(2580,'万宁市',269),(2581,'东方市',269),(2582,'定安县',269),(2583,'屯昌县',269),(2584,'澄迈县',269),(2585,'临高县',269),(2586,'白沙黎族自治县',269),(2587,'昌江黎族自治县',269),(2588,'乐东黎族自治县',269),(2589,'陵水黎族自治县',269),(2590,'保亭黎族苗族自治县',269),(2591,'琼中黎族苗族自治县',269),(2592,'西沙群岛',269),(2593,'南沙群岛',269),(2594,'中沙群岛的岛礁及其海域',269),(2595,'万州区',270),(2596,'涪陵区',270),(2597,'渝中区',270),(2598,'大渡口区',270),(2599,'江北区',270),(2600,'沙坪坝区',270),(2601,'九龙坡区',270),(2602,'南岸区',270),(2603,'北碚区',270),(2604,'万盛区',270),(2605,'双桥区',270),(2606,'渝北区',270),(2607,'巴南区',270),(2608,'黔江区',270),(2609,'长寿区',270),(2610,'綦江县',271),(2611,'潼南县',271),(2612,'铜梁县',271),(2613,'大足县',271),(2614,'荣昌县',271),(2615,'璧山县',271),(2616,'梁平县',271),(2617,'城口县',271),(2618,'丰都县',271),(2619,'垫江县',271),(2620,'武隆县',271),(2621,'忠县',271),(2622,'开县',271),(2623,'云阳县',271),(2624,'奉节县',271),(2625,'巫山县',271),(2626,'巫溪县',271),(2627,'石柱土家族自治县',271),(2628,'秀山土家族苗族自治县',271),(2629,'酉阳土家族苗族自治县',271),(2630,'彭水苗族土家族自治县',271),(2631,'江津区',272),(2632,'合川区',272),(2633,'永川区',272),(2634,'南川区',272),(2635,'市辖区',273),(2636,'锦江区',273),(2637,'青羊区',273),(2638,'金牛区',273),(2639,'武侯区',273),(2640,'成华区',273),(2641,'龙泉驿区',273),(2642,'青白江区',273),(2643,'新都区',273),(2644,'温江区',273),(2645,'金堂县',273),(2646,'双流县',273),(2647,'郫县',273),(2648,'大邑县',273),(2649,'蒲江县',273),(2650,'新津县',273),(2651,'都江堰市',273),(2652,'彭州市',273),(2653,'邛崃市',273),(2654,'崇州市',273),(2655,'市辖区',274),(2656,'自流井区',274),(2657,'贡井区',274),(2658,'大安区',274),(2659,'沿滩区',274),(2660,'荣县',274),(2661,'富顺县',274),(2662,'市辖区',275),(2663,'东区',275),(2664,'西区',275),(2665,'仁和区',275),(2666,'米易县',275),(2667,'盐边县',275),(2668,'市辖区',276),(2669,'江阳区',276),(2670,'纳溪区',276),(2671,'龙马潭区',276),(2672,'泸县',276),(2673,'合江县',276),(2674,'叙永县',276),(2675,'古蔺县',276),(2676,'市辖区',277),(2677,'旌阳区',277),(2678,'中江县',277),(2679,'罗江县',277),(2680,'广汉市',277),(2681,'什邡市',277),(2682,'绵竹市',277),(2683,'市辖区',278),(2684,'涪城区',278),(2685,'游仙区',278),(2686,'三台县',278),(2687,'盐亭县',278),(2688,'安县',278),(2689,'梓潼县',278),(2690,'北川羌族自治县',278),(2691,'平武县',278),(2692,'江油市',278),(2693,'市辖区',279),(2694,'市中区',279),(2695,'元坝区',279),(2696,'朝天区',279),(2697,'旺苍县',279),(2698,'青川县',279),(2699,'剑阁县',279),(2700,'苍溪县',279),(2701,'市辖区',280),(2702,'船山区',280),(2703,'安居区',280),(2704,'蓬溪县',280),(2705,'射洪县',280),(2706,'大英县',280),(2707,'市辖区',281),(2708,'市中区',281),(2709,'东兴区',281),(2710,'威远县',281),(2711,'资中县',281),(2712,'隆昌县',281),(2713,'市辖区',282),(2714,'市中区',282),(2715,'沙湾区',282),(2716,'五通桥区',282),(2717,'金口河区',282),(2718,'犍为县',282),(2719,'井研县',282),(2720,'夹江县',282),(2721,'沐川县',282),(2722,'峨边彝族自治县',282),(2723,'马边彝族自治县',282),(2724,'峨眉山市',282),(2725,'市辖区',283),(2726,'顺庆区',283),(2727,'高坪区',283),(2728,'嘉陵区',283),(2729,'南部县',283),(2730,'营山县',283),(2731,'蓬安县',283),(2732,'仪陇县',283),(2733,'西充县',283),(2734,'阆中市',283),(2735,'市辖区',284),(2736,'东坡区',284),(2737,'仁寿县',284),(2738,'彭山县',284),(2739,'洪雅县',284),(2740,'丹棱县',284),(2741,'青神县',284),(2742,'市辖区',285),(2743,'翠屏区',285),(2744,'宜宾县',285),(2745,'南溪县',285),(2746,'江安县',285),(2747,'长宁县',285),(2748,'高县',285),(2749,'珙县',285),(2750,'筠连县',285),(2751,'兴文县',285),(2752,'屏山县',285),(2753,'市辖区',286),(2754,'广安区',286),(2755,'岳池县',286),(2756,'武胜县',286),(2757,'邻水县',286),(2759,'市辖区',287),(2760,'通川区',287),(2761,'达县',287),(2762,'宣汉县',287),(2763,'开江县',287),(2764,'大竹县',287),(2765,'渠县',287),(2766,'万源市',287),(2767,'市辖区',288),(2768,'雨城区',288),(2769,'名山县',288),(2770,'荥经县',288),(2771,'汉源县',288),(2772,'石棉县',288),(2773,'天全县',288),(2774,'芦山县',288),(2775,'宝兴县',288),(2776,'市辖区',289),(2777,'巴州区',289),(2778,'通江县',289),(2779,'南江县',289),(2780,'平昌县',289),(2781,'市辖区',290),(2782,'雁江区',290),(2783,'安岳县',290),(2784,'乐至县',290),(2785,'简阳市',290),(2786,'汶川县',291),(2787,'理县',291),(2788,'茂县',291),(2789,'松潘县',291),(2790,'九寨沟县',291),(2791,'金川县',291),(2792,'小金县',291),(2793,'黑水县',291),(2794,'马尔康县',291),(2795,'壤塘县',291),(2796,'阿坝县',291),(2797,'若尔盖县',291),(2798,'红原县',291),(2799,'康定县',292),(2800,'泸定县',292),(2801,'丹巴县',292),(2802,'九龙县',292),(2803,'雅江县',292),(2804,'道孚县',292),(2805,'炉霍县',292),(2806,'甘孜县',292),(2807,'新龙县',292),(2808,'德格县',292),(2809,'白玉县',292),(2810,'石渠县',292),(2811,'色达县',292),(2812,'理塘县',292),(2813,'巴塘县',292),(2814,'乡城县',292),(2815,'稻城县',292),(2816,'得荣县',292),(2817,'西昌市',293),(2818,'木里藏族自治县',293),(2819,'盐源县',293),(2820,'德昌县',293),(2821,'会理县',293),(2822,'会东县',293),(2823,'宁南县',293),(2824,'普格县',293),(2825,'布拖县',293),(2826,'金阳县',293),(2827,'昭觉县',293),(2828,'喜德县',293),(2829,'冕宁县',293),(2830,'越西县',293),(2831,'甘洛县',293),(2832,'美姑县',293),(2833,'雷波县',293),(2834,'市辖区',294),(2835,'南明区',294),(2836,'云岩区',294),(2837,'花溪区',294),(2838,'乌当区',294),(2839,'白云区',294),(2840,'小河区',294),(2841,'开阳县',294),(2842,'息烽县',294),(2843,'修文县',294),(2844,'清镇市',294),(2845,'钟山区',295),(2846,'六枝特区',295),(2847,'水城县',295),(2848,'盘县',295),(2849,'市辖区',296),(2850,'红花岗区',296),(2851,'汇川区',296),(2852,'遵义县',296),(2853,'桐梓县',296),(2854,'绥阳县',296),(2855,'正安县',296),(2856,'道真仡佬族苗族自治县',296),(2857,'务川仡佬族苗族自治县',296),(2858,'凤冈县',296),(2859,'湄潭县',296),(2860,'余庆县',296),(2861,'习水县',296),(2862,'赤水市',296),(2863,'仁怀市',296),(2864,'市辖区',297),(2865,'西秀区',297),(2866,'平坝县',297),(2867,'普定县',297),(2868,'镇宁布依族苗族自治县',297),(2869,'关岭布依族苗族自治县',297),(2870,'紫云苗族布依族自治县',297),(2871,'铜仁市',298),(2872,'江口县',298);

insert into kang_region values (2873,'玉屏侗族自治县',298),(2874,'石阡县',298),(2875,'思南县',298),(2876,'印江土家族苗族自治县',298),(2877,'德江县',298),(2878,'沿河土家族自治县',298),(2879,'松桃苗族自治县',298),(2880,'万山特区',298),(2881,'兴义市',299),(2882,'兴仁县',299),(2883,'普安县',299),(2884,'晴隆县',299),(2885,'贞丰县',299),(2886,'望谟县',299),(2887,'册亨县',299),(2888,'安龙县',299),(2889,'毕节市',300),(2890,'大方县',300),(2891,'黔西县',300),(2892,'金沙县',300),(2893,'织金县',300),(2894,'纳雍县',300),(2895,'威宁彝族回族苗族自治县',300),(2896,'赫章县',300),(2897,'凯里市',301),(2898,'黄平县',301),(2899,'施秉县',301),(2900,'三穗县',301),(2901,'镇远县',301),(2902,'岑巩县',301),(2903,'天柱县',301),(2904,'锦屏县',301),(2905,'剑河县',301),(2906,'台江县',301),(2907,'黎平县',301),(2908,'榕江县',301),(2909,'从江县',301),(2910,'雷山县',301),(2911,'麻江县',301),(2912,'丹寨县',301),(2913,'都匀市',302),(2914,'福泉市',302),(2915,'荔波县',302),(2916,'贵定县',302),(2917,'瓮安县',302),(2918,'独山县',302),(2919,'平塘县',302),(2920,'罗甸县',302),(2921,'长顺县',302),(2922,'龙里县',302),(2923,'惠水县',302),(2924,'三都水族自治县',302),(2925,'市辖区',303),(2926,'五华区',303),(2927,'盘龙区',303),(2928,'官渡区',303),(2929,'西山区',303),(2930,'东川区',303),(2931,'呈贡县',303),(2932,'晋宁县',303),(2933,'富民县',303),(2934,'宜良县',303),(2935,'石林彝族自治县',303),(2936,'嵩明县',303),(2937,'禄劝彝族苗族自治县',303),(2938,'寻甸回族彝族自治县',303),(2939,'安宁市',303),(2940,'市辖区',304),(2941,'麒麟区',304),(2942,'马龙县',304),(2943,'陆良县',304),(2944,'师宗县',304),(2945,'罗平县',304),(2946,'富源县',304),(2947,'会泽县',304),(2948,'沾益县',304),(2949,'宣威市',304),(2950,'市辖区',305),(2951,'红塔区',305),(2952,'江川县',305),(2953,'澄江县',305),(2954,'通海县',305),(2955,'华宁县',305),(2956,'易门县',305),(2957,'峨山彝族自治县',305),(2958,'新平彝族傣族自治县',305),(2959,'元江哈尼族彝族傣族自治县',305),(2960,'市辖区',306),(2961,'隆阳区',306),(2962,'施甸县',306),(2963,'腾冲县',306),(2964,'龙陵县',306),(2965,'昌宁县',306),(2966,'市辖区',307),(2967,'昭阳区',307),(2968,'鲁甸县',307),(2969,'巧家县',307),(2970,'盐津县',307),(2971,'大关县',307),(2972,'永善县',307),(2973,'绥江县',307),(2974,'镇雄县',307),(2975,'彝良县',307),(2976,'威信县',307),(2977,'水富县',307),(2978,'市辖区',308),(2979,'古城区',308),(2980,'玉龙纳西族自治县',308),(2981,'永胜县',308),(2982,'华坪县',308),(2983,'宁蒗彝族自治县',308),(2984,'市辖区',309),(2985,'思茅区',309),(2986,'宁洱哈尼族彝族自治县',309),(2987,'墨江哈尼族自治县',309),(2988,'景东彝族自治县',309),(2989,'景谷傣族彝族自治县',309),(2990,'镇沅彝族哈尼族拉祜族自治县',309),(2991,'江城哈尼族彝族自治县',309),(2992,'孟连傣族拉祜族佤族自治县',309),(2993,'澜沧拉祜族自治县',309),(2994,'西盟佤族自治县',309),(2995,'市辖区',310),(2996,'临翔区',310),(2997,'凤庆县',310),(2998,'云县',310),(2999,'永德县',310),(3000,'镇康县',310),(3001,'双江拉祜族佤族布朗族傣族自治县',310),(3002,'耿马傣族佤族自治县',310),(3003,'沧源佤族自治县',310),(3004,'楚雄市',311),(3005,'双柏县',311),(3006,'牟定县',311),(3007,'南华县',311),(3008,'姚安县',311),(3009,'大姚县',311),(3010,'永仁县',311),(3011,'元谋县',311),(3012,'武定县',311),(3013,'禄丰县',311),(3014,'个旧市',312),(3015,'开远市',312),(3016,'蒙自市',312),(3017,'屏边苗族自治县',312),(3018,'建水县',312),(3019,'石屏县',312),(3020,'弥勒县',312),(3021,'泸西县',312),(3022,'元阳县',312),(3023,'红河县',312),(3024,'金平苗族瑶族傣族自治县',312),(3025,'绿春县',312),(3026,'河口瑶族自治县',312),(3027,'文山县',313),(3028,'砚山县',313),(3029,'西畴县',313),(3030,'麻栗坡县',313),(3031,'马关县',313),(3032,'丘北县',313),(3033,'广南县',313),(3034,'富宁县',313),(3035,'景洪市',314),(3036,'勐海县',314),(3037,'勐腊县',314),(3038,'大理市',315),(3039,'漾濞彝族自治县',315),(3040,'祥云县',315),(3041,'宾川县',315),(3042,'弥渡县',315),(3043,'南涧彝族自治县',315),(3044,'巍山彝族回族自治县',315),(3045,'永平县',315),(3046,'云龙县',315),(3047,'洱源县',315),(3048,'剑川县',315),(3049,'鹤庆县',315),(3050,'瑞丽市',316),(3051,'芒市',316),(3052,'梁河县',316),(3053,'盈江县',316),(3054,'陇川县',316),(3055,'泸水县',317),(3056,'福贡县',317), (3057,'贡山独龙族怒族自治县',317),(3058,'兰坪白族普米族自治县',317),(3059,'香格里拉县',318),(3060,'德钦县',318),(3061,'维西傈僳族自治县',318),(3062,'市辖区',319),(3063,'城关区',319),(3064,'林周县',319),(3065,'当雄县',319),(3066,'尼木县',319),(3067,'曲水县',319),(3068,'堆龙德庆县',319),(3069,'达孜县',319),(3070,'墨竹工卡县',319),(3071,'昌都县',320),(3072,'江达县',320),(3073,'贡觉县',320),(3074,'类乌齐县',320),(3075,'丁青县',320),(3076,'察雅县',320),(3077,'八宿县',320),(3078,'左贡县',320),(3079,'芒康县',320),(3080,'洛隆县',320),(3081,'边坝县',320),(3082,'乃东县',321),(3083,'扎囊县',321),(3084,'贡嘎县',321),(3085,'桑日县',321),(3086,'琼结县',321),(3087,'曲松县',321),(3088,'措美县',321),(3089,'洛扎县',321),(3090,'加查县',321),(3091,'隆子县',321),(3092,'错那县',321),(3093,'浪卡子县',321),(3094,'日喀则市',322),(3095,'南木林县',322),(3096,'江孜县',322),(3097,'定日县',322),(3098,'萨迦县',322),(3099,'拉孜县',322),(3100,'昂仁县',322),(3101,'谢通门县',322),(3102,'白朗县',322),(3103,'仁布县',322),(3104,'康马县',322),(3105,'定结县',322),(3106,'仲巴县',322),(3107,'亚东县',322),(3108,'吉隆县',322),(3109,'聂拉木县',322),(3110,'萨嘎县',322),(3111,'岗巴县',322),(3112,'那曲县',323),(3113,'嘉黎县',323),(3114,'比如县',323),(3115,'聂荣县',323),(3116,'安多县',323),(3117,'申扎县',323),(3118,'索县',323),(3119,'班戈县',323),(3120,'巴青县',323),(3121,'尼玛县',323),(3122,'普兰县',324),(3123,'札达县',324),(3124,'噶尔县',324),(3125,'日土县',324),(3126,'革吉县',324),(3127,'改则县',324),(3128,'措勤县',324),(3129,'林芝县',325),(3130,'工布江达县',325),(3131,'米林县',325),(3132,'墨脱县',325),(3133,'波密县',325),(3134,'察隅县',325),(3135,'朗县',325),(3136,'市辖区',326),(3137,'新城区',326),(3138,'碑林区',326),(3139,'莲湖区',326),(3140,'灞桥区',326),(3141,'未央区',326),(3142,'雁塔区',326),(3143,'阎良区',326),(3144,'临潼区',326),(3145,'长安区',326),(3146,'蓝田县',326),(3147,'周至县',326),(3148,'户县',326),(3149,'高陵县',326),(3150,'市辖区',327),(3151,'王益区',327),(3152,'印台区',327),(3153,'耀州区',327),(3154,'宜君县',327),(3155,'市辖区',328),(3156,'渭滨区',328),(3157,'金台区',328),(3158,'陈仓区',328),(3159,'凤翔县',328),(3160,'岐山县',328),(3161,'扶风县',328),(3162,'眉县',328),(3163,'陇县',328),(3164,'千阳县',328),(3165,'麟游县',328),(3166,'凤县',328),(3167,'太白县',328),(3168,'市辖区',329),(3169,'秦都区',329),(3170,'杨陵区',329),(3171,'渭城区',329),(3172,'三原县',329),(3173,'泾阳县',329),(3174,'乾县',329),(3175,'礼泉县',329),(3176,'永寿县',329),(3177,'彬县',329),(3178,'长武县',329),(3179,'旬邑县',329),(3180,'淳化县',329),(3181,'武功县',329),(3182,'兴平市',329),(3183,'市辖区',330),(3184,'临渭区',330),(3185,'华县',330),(3186,'潼关县',330),(3187,'大荔县',330),(3188,'合阳县',330),(3189,'澄城县',330),(3190,'蒲城县',330),(3191,'白水县',330),(3192,'富平县',330),(3193,'韩城市',330),(3194,'华阴市',330),(3195,'市辖区',331),(3196,'宝塔区',331),(3197,'延长县',331),(3198,'延川县',331),(3199,'子长县',331),(3200,'安塞县',331),(3201,'志丹县',331),(3202,'吴起县',331),(3203,'甘泉县',331),(3204,'富县',331),(3205,'洛川县',331),(3206,'宜川县',331),(3207,'黄龙县',331),(3208,'黄陵县',331),(3209,'市辖区',332),(3210,'汉台区',332),(3211,'南郑县',332),(3212,'城固县',332),(3213,'洋县',332),(3214,'西乡县',332),(3215,'勉县',332),(3216,'宁强县',332),(3217,'略阳县',332),(3218,'镇巴县',332),(3219,'留坝县',332),(3220,'佛坪县',332),(3221,'市辖区',333),(3222,'榆阳区',333),(3223,'神木县',333),(3224,'府谷县',333),(3225,'横山县',333),(3226,'靖边县',333),(3227,'定边县',333),(3228,'绥德县',333),(3229,'米脂县',333),(3230,'佳县',333),(3231,'吴堡县',333),(3232,'清涧县',333),(3233,'子洲县',333),(3234,'市辖区',334),(3235,'汉滨区',334),(3236,'汉阴县',334),(3237,'石泉县',334),(3238,'宁陕县',334),(3239,'紫阳县',334),(3240,'岚皋县',334),(3241,'平利县',334),(3242,'镇坪县',334),(3243,'旬阳县',334),(3244,'白河县',334),(3245,'市辖区',335),(3246,'商州区',335),(3247,'洛南县',335),(3248,'丹凤县',335),(3249,'商南县',335),(3250,'山阳县',335),(3251,'镇安县',335),(3252,'柞水县',335),(3253,'市辖区',336),(3254,'城关区',336),(3255,'七里河区',336),(3256,'西固区',336),(3257,'安宁区',336),(3258,'红古区',336),(3259,'永登县',336),(3260,'皋兰县',336),(3261,'榆中县',336),(3262,'市辖区',337),(3263,'市辖区',338),(3264,'金川区',338),(3265,'永昌县',338),(3266,'市辖区',339),(3267,'白银区',339),(3268,'平川区',339),(3269,'靖远县',339),(3270,'会宁县',339),(3271,'景泰县',339),(3272,'市辖区',340),(3274,'秦州区',340),(3275,'清水县',340),(3276,'秦安县',340),(3277,'甘谷县',340),(3278,'武山县',340),(3279,'张家川回族自治县',340),(3280,'市辖区',341),(3281,'凉州区',341),(3282,'民勤县',341),(3283,'古浪县',341),(3284,'天祝藏族自治县',341),(3285,'市辖区',342),(3286,'甘州区',342),(3287,'肃南裕固族自治县',342),(3288,'民乐县',342),(3289,'临泽县',342),(3290,'高台县',342),(3291,'山丹县',342),(3292,'市辖区',343),(3293,'崆峒区',343),(3294,'泾川县',343),(3295,'灵台县',343),(3296,'崇信县',343),(3297,'华亭县',343),(3298,'庄浪县',343),(3299,'静宁县',343),(3300,'市辖区',344),(3301,'肃州区',344),(3302,'金塔县',344),(3304,'肃北蒙古族自治县',344),(3305,'阿克塞哈萨克族自治县',344),(3306,'玉门市',344),(3307,'敦煌市',344),(3308,'市辖区',345),(3309,'西峰区',345),(3310,'庆城县',345),(3311,'环县',345),(3312,'华池县',345),(3313,'合水县',345),(3314,'正宁县',345),(3315,'宁县',345),(3316,'镇原县',345),(3317,'市辖区',346),(3318,'安定区',346),(3319,'通渭县',346),(3320,'陇西县',346),(3321,'渭源县',346),(3322,'临洮县',346),(3323,'漳县',346),(3324,'岷县',346),(3325,'市辖区',347),(3326,'武都区',347),(3327,'成县',347),(3328,'文县',347),(3329,'宕昌县',347),(3330,'康县',347),(3331,'西和县',347),(3332,'礼县',347),(3333,'徽县',347),(3334,'两当县',347),(3335,'临夏市',348),(3336,'临夏县',348),(3337,'康乐县',348),(3338,'永靖县',348),(3339,'广河县',348),(3340,'和政县',348),(3341,'东乡族自治县',348),(3342,'积石山保安族东乡族撒拉族自治县',348),(3343,'合作市',349),(3344,'临潭县',349),(3345,'卓尼县',349),(3346,'舟曲县',349),(3347,'迭部县',349),(3348,'玛曲县',349),(3349,'碌曲县',349),(3350,'夏河县',349),(3351,'市辖区',350),(3352,'城东区',350),(3353,'城中区',350),(3354,'城西区',350),(3355,'城北区',350),(3356,'大通回族土族自治县',350),(3357,'湟中县',350),(3358,'湟源县',350),(3359,'平安县',351),(3360,'民和回族土族自治县',351),(3361,'乐都县',351),(3362,'互助土族自治县',351),(3363,'化隆回族自治县',351),(3364,'循化撒拉族自治县',351),(3365,'门源回族自治县',352),(3366,'祁连县',352),(3367,'海晏县',352),(3368,'刚察县',352),(3369,'同仁县',353),(3370,'尖扎县',353),(3371,'泽库县',353),(3372,'河南蒙古族自治县',353),(3373,'共和县',354),(3374,'同德县',354),(3375,'贵德县',354),(3376,'兴海县',354),(3377,'贵南县',354),(3378,'玛沁县',355),(3379,'班玛县',355),(3380,'甘德县',355),(3381,'达日县',355),(3382,'久治县',355),(3383,'玛多县',355),(3384,'玉树县',356),(3385,'杂多县',356),(3386,'称多县',356),(3387,'治多县',356),(3388,'囊谦县',356),(3389,'曲麻莱县',356),(3390,'格尔木市',357),(3391,'德令哈市',357),(3392,'乌兰县',357),(3393,'都兰县',357),(3394,'天峻县',357),(3395,'市辖区',358),(3396,'兴庆区',358),(3397,'西夏区',358),(3398,'金凤区',358),(3399,'永宁县',358),(3400,'贺兰县',358),(3401,'灵武市',358),(3402,'市辖区',359),(3403,'大武口区',359),(3404,'惠农区',359),(3405,'平罗县',359),(3406,'市辖区',360),(3407,'利通区',360),(3408,'盐池县',360),(3409,'同心县',360),(3410,'青铜峡市',360),(3411,'市辖区',361),(3412,'原州区',361),(3413,'西吉县',361),(3414,'隆德县',361),(3415,'泾源县',361),(3416,'彭阳县',361),(3417,'市辖区',362),(3418,'沙坡头区',362),(3419,'中宁县',362),(3420,'海原县',362),(3421,'市辖区',363),(3422,'天山区',363),(3423,'沙依巴克区',363),(3424,'新市区',363),(3425,'水磨沟区',363),(3426,'头屯河区',363),(3427,'达坂城区',363),(3428,'米东区',363),(3429,'乌鲁木齐县',363),(3430,'市辖区',364),(3431,'独山子区',364),(3432,'克拉玛依区',364),(3433,'白碱滩区',364),(3434,'乌尔禾区',364),(3435,'吐鲁番市',365),(3436,'鄯善县',365),(3437,'托克逊县',365),(3438,'哈密市',366),(3439,'巴里坤哈萨克自治县',366),(3440,'伊吾县',366),(3441,'昌吉市',367),(3442,'阜康市',367),(3444,'呼图壁县',367),(3445,'玛纳斯县',367),(3446,'奇台县',367),(3447,'吉木萨尔县',367),(3448,'木垒哈萨克自治县',367),(3449,'博乐市',368),(3450,'精河县',368),(3451,'温泉县',368),(3452,'库尔勒市',369),(3453,'轮台县',369),(3454,'尉犁县',369),(3455,'若羌县',369),(3456,'且末县',369),(3457,'焉耆回族自治县',369),(3458,'和静县',369),(3459,'和硕县',369),(3460,'博湖县',369),(3461,'阿克苏市',370),(3462,'温宿县',370),(3463,'库车县',370),(3464,'沙雅县',370),(3465,'新和县',370),(3466,'拜城县',370),(3467,'乌什县',370),(3468,'阿瓦提县',370),(3469,'柯坪县',370),(3470,'阿图什市',371),(3471,'阿克陶县',371),(3472,'阿合奇县',371),(3473,'乌恰县',371),(3474,'喀什市',372),(3475,'疏附县',372),(3476,'疏勒县',372),(3477,'英吉沙县',372),(3478,'泽普县',372),(3479,'莎车县',372),(3480,'叶城县',372),(3481,'麦盖提县',372),(3482,'岳普湖县',372),(3483,'伽师县',372),(3484,'巴楚县',372),(3485,'塔什库尔干塔吉克自治县',372),(3486,'和田市',373),(3487,'和田县',373),(3488,'墨玉县',373),(3489,'皮山县',373),(3490,'洛浦县',373),(3491,'策勒县',373),(3492,'于田县',373),(3493,'民丰县',373),(3494,'伊宁市',374),(3495,'奎屯市',374),(3496,'伊宁县',374),(3497,'察布查尔锡伯自治县',374),(3498,'霍城县',374),(3499,'巩留县',374),(3500,'新源县',374),(3501,'昭苏县',374),(3502,'特克斯县',374),(3503,'尼勒克县',374),(3504,'塔城市',375),(3505,'乌苏市',375),(3506,'额敏县',375),(3507,'沙湾县',375),(3508,'托里县',375),(3509,'裕民县',375),(3510,'和布克赛尔蒙古自治县',375),(3511,'阿勒泰市',376),(3512,'布尔津县',376),(3513,'富蕴县',376),(3514,'福海县',376),(3515,'哈巴河县',376),(3516,'青河县',376),(3517,'吉木乃县',376),(3518,'石河子市',377),(3519,'阿拉尔市',377),(3520,'图木舒克市',377),(3521,'五家渠市',377),(4000,'麦积区',340),(4001,'江津区',270),(4002,'合川区',270),(4003,'永川区',270),(4004,'南川区',270),(4006,'芜湖县',1412),(4100,'加格达奇区',106),(4101,'松岭区',106),(4102,'新林区',106),(4103,'呼中区',106),(4200,'南湖区',125),(4300,'共青城市',162),(4400,'红寺堡区',360),(4500,'瓜州县',344),(4600,'随县',215),(4700,'零陵区',228),(4800,'平桂管理区',263),(4900,'利州区',279),(5000,'华蓥市',286);
