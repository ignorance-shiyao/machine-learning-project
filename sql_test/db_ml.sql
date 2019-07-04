drop database if exists db_ml;
create database db_ml;

# 创建训练集表
drop table if exists db_ml.t_train;
CREATE TABLE db_ml.t_train
(
    order_id          varchar(45) primary key comment 'id PK',
    driver_id         varchar(45)    default null comment '司机 ID',
    member_id         varchar(45)    default null comment '乘客 ID',
    create_date       varchar(45)    default null comment '约车日期',
    create_hour       int(11)        default null comment '约车时间',
    status            int(11)        default null comment '约车状态：0-未预约成功，1-预约取消，2-出行成功',
    estimate_money    decimal(12, 4) default null comment '预估金额',
    estimate_distance decimal(12, 4) default null comment '预估距离',
    estimate_term     decimal(12, 4) default null comment '预估时间',
    start_geo_id      varchar(45)    default null comment '起始地点',
    end_geo_id        varchar(45)    default null comment '终到地点'
) comment '原始训练集表';


#导入数据到原始训练集表

load data local infile '/Users/shiyao/OneDrive/DevFiles/machine-learning-project/data/train_July.csv'
    into table db_ml.t_train
    fields terminated by ','
    ignore 1 lines;


# 新建公共设施表
drop table if exists db_ml.t_poi;
CREATE TABLE db_ml.t_poi
(
    rid        varchar(255) primary key comment 'id PK',
    petrol     int default 0 comment '加油站',
    market     int default 0 comment '超市',
    uptown     int default 0 comment '住宅区',
    metro      int default 0 comment '地铁站',
    bus        int default 0 comment '公交站',
    cafe       int default 0 comment '咖啡厅',
    restaurant int default 0 comment '中餐厅',
    atm        int default 0 comment 'ATM',
    office     int default 0 comment '写字楼',
    hotel      int default 0 comment '酒店'
) comment '公共设施表';

#导入数据到基础设施表

load data local infile '/Users/shiyao/OneDrive/DevFiles/machine-learning-project/data/poi.csv'
    into table db_ml.t_poi
    fields terminated by ','
    ignore 1 lines
    (rid, @dummy, petrol, @dummy, market, @dummy, uptown, @dummy, metro, @dummy, bus, @dummy, cafe, @dummy, restaurant,
     @dummy, atm, @dummy, office, @dummy, hotel);


#利用连接查询将地区与对应的设施连接
select d.*,
       p.petrol     s_petrol,
       p.market     s_market,
       p.uptown     s_uptown,
       p.metro      s_metro,
       p.bus        s_bus,
       p.cafe       s_cafe,
       p.restaurant s_restaurant,
       p.atm        s_atm,
       p.office     s_office,
       p.hotel      s_hotel
from t_train d,
     t_poi p
where d.start_geo_id = p.rid;

select temp1.*,
       p2.petrol     e_petrol,
       p2.market     e_market,
       p2.uptown     e_uptown,
       p2.metro      e_metro,
       p2.bus        e_bus,
       p2.cafe       e_cafe,
       p2.restaurant e_restaurant,
       p2.atm        e_atm,
       p2.office     e_office,
       p2.hotel      e_hotel
from t_poi p2,
     (select d.*,
             p.petrol     s_petrol,
             p.market     s_market,
             p.uptown     s_uptown,
             p.metro      s_metro,
             p.bus        s_bus,
             p.cafe       s_cafe,
             p.restaurant s_restaurant,
             p.atm        s_atm,
             p.office     s_office,
             p.hotel      s_hotel
      from t_train d,
           t_poi p
      where d.start_geo_id = p.rid) as temp1
where p2.rid = temp1.end_geo_id;

#新建初始天气表

drop table if exists db_ml.weather;
create table db_ml.weather
(
    wid                   int auto_increment primary key comment 'id PK',
    datetime              datetime comment '日期',
    text                  varchar(255) comment '天气',
    code                  int comment '代码',
    temperature           int comment '温度',
    feels_like            int comment '体感温度',
    pressure              int comment '气压',
    humidity              int comment '相对湿度',
    visibility            double(6, 2) comment '能见度',
    wind_direction        varchar(255) comment '风向',
    wind_direction_degree int comment '风向角度',
    wind_speed            double(6, 2) comment '风速',
    wind_scale            int comment '风力等级'
) comment '初始天气表';

#导入数据到天气表

load data local infile '/Users/shiyao/OneDrive/DevFiles/machine-learning-project/data/weather.csv'
    into table db_ml.weather
    fields terminated by ','
    ignore 1 lines
    (datetime, text, code, temperature, feels_like, pressure, humidity, visibility, wind_direction,
     wind_direction_degree, wind_speed, wind_scale);

#新建天气表
drop table if exists db_ml.t_weather;
CREATE TABLE db_ml.t_weather
select wid,
       DATE_FORMAT(datetime, '%Y-%m-%d') date,
       DATE_FORMAT(datetime, '%H')       hour,
       DATE_FORMAT(datetime, '%i')       min,
       text,
       code,
       temperature,
       feels_like,
       pressure,
       humidity,
       visibility,
       wind_direction,
       wind_direction_degree,
       wind_speed,
       wind_scale
from db_ml.weather;

# 联合查询创建训练集
drop table if exists db_ml.t_train_combine;
create table db_ml.t_train_combine
select tt.*,
       tw.temperature           w_temperature,
       tw.feels_like            w_feels_like,
       tw.pressure              w_pressure,
       tw.humidity              w_humidity,
       tw.visibility            w_visibility,
       tw.wind_direction_degree w_wind_direction_degree,
       tw.wind_speed            w_wind_speed
from (select date,
             hour,
             avg(temperature)           temperature,
             avg(feels_like)            feels_like,
             avg(pressure)              pressure,
             avg(humidity)              humidity,
             avg(visibility)            visibility,
             avg(wind_direction_degree) wind_direction_degree,
             avg(wind_speed)            wind_speed
      from db_ml.t_weather
      group by date, hour
     ) as tw,
     (
         select temp1.*,
                p2.petrol     e_petrol,
                p2.market     e_market,
                p2.uptown     e_uptown,
                p2.metro      e_metro,
                p2.bus        e_bus,
                p2.cafe       e_cafe,
                p2.restaurant e_restaurant,
                p2.atm        e_atm,
                p2.office     e_office,
                p2.hotel      e_hotel
         from db_ml.t_poi p2,
              (select d.*,
                      p.petrol     s_petrol,
                      p.market     s_market,
                      p.uptown     s_uptown,
                      p.metro      s_metro,
                      p.bus        s_bus,
                      p.cafe       s_cafe,
                      p.restaurant s_restaurant,
                      p.atm        s_atm,
                      p.office     s_office,
                      p.hotel      s_hotel
               from db_ml.t_train d,
                    db_ml.t_poi p
               where d.start_geo_id = p.rid) as temp1
         where p2.rid = temp1.end_geo_id
     ) as tt
where date_format(tt.create_date, '%Y-%m-%d') = date_format(tw.date, '%Y-%m-%d')
  and tt.create_hour = tw.hour;


# 联合查询创建训练集
drop table if exists db_ml.t_train_combine;
create table db_ml.t_train_combine
select tt.*,
       tw.temperature           w_temperature,
       tw.feels_like            w_feels_like,
       tw.pressure              w_pressure,
       tw.humidity              w_humidity,
       tw.visibility            w_visibility,
       tw.wind_direction_degree w_wind_direction_degree,
       tw.wind_speed            w_wind_speed
from (
         select datetime,
                avg(temperature)           temperature,
                avg(feels_like)            feels_like,
                avg(pressure)              pressure,
                avg(humidity)              humidity,
                avg(visibility)            visibility,
                avg(wind_direction_degree) wind_direction_degree,
                avg(wind_speed)            wind_speed
         from db_ml.weather
         group by datetime
     ) as tw,
     (
         select temp1.*,
                p2.petrol     e_petrol,
                p2.market     e_market,
                p2.uptown     e_uptown,
                p2.metro      e_metro,
                p2.bus        e_bus,
                p2.cafe       e_cafe,
                p2.restaurant e_restaurant,
                p2.atm        e_atm,
                p2.office     e_office,
                p2.hotel      e_hotel
         from db_ml.t_poi p2,
              (select d.*,
                      p.petrol     s_petrol,
                      p.market     s_market,
                      p.uptown     s_uptown,
                      p.metro      s_metro,
                      p.bus        s_bus,
                      p.cafe       s_cafe,
                      p.restaurant s_restaurant,
                      p.atm        s_atm,
                      p.office     s_office,
                      p.hotel      s_hotel
               from db_ml.t_train d,
                    db_ml.t_poi p
               where d.start_geo_id = p.rid) as temp1
         where p2.rid = temp1.end_geo_id
     ) as tt
where date_format(tt.create_date, '%Y-%m-%d') = date_format(tw.datetime, '%Y-%m-%d')
  and tt.create_hour = date_format(tw.datetime, '%H');

# 联合查询创建真实训练集
drop table if exists db_ml.t_train_real;
create table db_ml.t_train_real
SELECT s_petrol,
       s_market,
       s_uptown,
       s_metro,
       s_bus,
       s_cafe,
       s_restaurant,
       s_atm,
       s_office,
       s_hotel,
       e_petrol,
       e_market,
       e_uptown,
       e_metro,
       e_bus,
       e_cafe,
       e_restaurant,
       e_atm,
       e_office,
       e_hotel,
       w_temperature,
       w_feels_like,
       w_pressure,
       w_humidity,
       w_visibility,
       w_wind_direction_degree,
       w_wind_speed,
       count(order_id) order_count
FROM db_ml.t_train_combine
group by s_petrol, s_market, s_uptown, s_metro, s_bus, s_cafe,
         s_restaurant, s_atm, s_office, s_hotel,
         e_petrol, e_market, e_uptown, e_metro, e_bus,
         e_cafe, e_restaurant, e_atm, e_office, e_hotel,
         w_temperature, w_feels_like, w_pressure, w_humidity,
         w_visibility, w_wind_direction_degree, w_wind_speed;

# 新建测试集表
drop table if exists db_ml.t_aug_test;
CREATE TABLE db_ml.t_aug_test
(
    test_id      int primary key comment '测试 ID',
    start_geo_id VARCHAR(45) default null comment '起始地点',
    end_geo_id   VARCHAR(45) default null comment '终到地点',
    create_date  VARCHAR(45) default null comment '约车日期',
    create_hour  int         default null comment '约车时间'
);

# 导入测试集数据
load data local infile '/Users/shiyao/OneDrive/DevFiles/machine-learning-project/data/test_id_Aug_agg_private5k.csv'
    into table db_ml.t_aug_test
    fields terminated by ','
    ignore 1 lines;

drop table if exists db_ml.t_aug_test_real;
create table db_ml.t_aug_test_real
select tt.*,
       tw.temperature           w_temperature,
       tw.feels_like            w_feels_like,
       tw.pressure              w_pressure,
       tw.humidity              w_humidity,
       tw.visibility            w_visibility,
       tw.wind_direction_degree w_wind_direction_degree,
       tw.wind_speed            w_wind_speed
from (
         select temp1.*,
                p2.petrol     e_petrol,
                p2.market     e_market,
                p2.uptown     e_uptown,
                p2.metro      e_metro,
                p2.bus        e_bus,
                p2.cafe       e_cafe,
                p2.restaurant e_restaurant,
                p2.atm        e_atm,
                p2.office     e_office,
                p2.hotel      e_hotel
         from (select d.*,
                      p.petrol     s_petrol,
                      p.market     s_market,
                      p.uptown     s_uptown,
                      p.metro      s_metro,
                      p.bus        s_bus,
                      p.cafe       s_cafe,
                      p.restaurant s_restaurant,
                      p.atm        s_atm,
                      p.office     s_office,
                      p.hotel      s_hotel
               from db_ml.t_aug_test d
                        left join db_ml.t_poi p
                                  on d.start_geo_id = p.rid) as temp1
                  left join db_ml.t_poi p2
                            on p2.rid = temp1.end_geo_id
     ) as tt
         left join
     (
         select date,
                hour,
                avg(temperature)           temperature,
                avg(feels_like)            feels_like,
                avg(pressure)              pressure,
                avg(humidity)              humidity,
                avg(visibility)            visibility,
                avg(wind_direction_degree) wind_direction_degree,
                avg(wind_speed)            wind_speed
         from db_ml.t_weather
         group by date, hour
     ) as tw
     on date_format(tt.create_date, '%Y-%m-%d') = date_format(tw.date, '%Y-%m-%d')
         and tt.create_hour = tw.hour;