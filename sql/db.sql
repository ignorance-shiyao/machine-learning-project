-- 1. 获取用于训练模型的训练集
-- csv pandas
-- MySQL
-- 创建三个表：train，weather, poi
-- 导入数据 csv -> table
-- 关联查询，获取真实的训练集
-- 2. 选择合适的算法训练模型
-- sk-learn 模块，选择一种算法
-- 传入真实的训练集，训练模型
-- 3. 将测试集导入模型，获取预测结果

drop database if exists db_ml;
create database db_ml;

#新建原始训练集表

drop table if exists db_ml.train;
create table db_ml.train
(
    id                varchar(255) primary key comment 'id PK',
    driver_id         varchar(255) comment '司机 ID',
    member_id         varchar(255) comment '乘客 ID',
    create_date       varchar(255) comment '约车日期',
    create_hour       int comment '约车时间',
    status            int comment '约车装态：0-未预约成功，1-预约取消，2-出行成功',
    estimate_money    decimal(6, 2) comment '预估金额',
    estimate_distance double(12, 2) comment '预估距离',
    estimate_term     int comment '预估时间',
    start_geo_id      varchar(255) comment '起始地点',
    end_geo_id        varchar(255) comment '终到地点'
) comment '原始训练集表';

#新建天气表

drop table if exists db_ml.weather;
create table db_ml.weather
(
    id                    int auto_increment primary key comment 'id PK',
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
) comment '天气表';

#新建公共设施表

drop table if exists db_ml.poi;
create table db_ml.poi
(
    id         varchar(255) comment 'id PK',
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

select *
from db_ml.train
limit 0, 3;

select *
from db_ml.weather;

select *
from db_ml.poi;



# OSX   /usr/local/mysql/bin/mysql -u root -p --local-infile db_ml

# WIN   mysql -u root -p --local-infile db_ml

SET GLOBAL local_infile = 1;

#导入数据到原始训练集表

load data local infile 'D:\\ProjectFile\\machine-learning-project\\data\\UAI_Data\\train_July.csv' into table db_ml.train fields terminated by ','
    ignore 1 lines;

#导入数据到天气表

load data local infile 'D:\ProjectFile\machine-learning-project\data\UAI_Data/weather.csv'
    into table db_ml.weather
    fields terminated by ','
    ignore 1 lines
    (datetime, text, code, temperature, feels_like, pressure, humidity, visibility, wind_direction,
     wind_direction_degree, wind_speed, wind_scale);

#导入数据到基础设施表

load data local infile 'D:\ProjectFile\machine-learning-project\data\UAI_Data/poi.csv'
    into table db_ml.poi
    fields terminated by ','
    ignore 1 lines
    (id, @dummy, petrol, @dummy, market, @dummy, uptown, @dummy, metro, @dummy, bus, @dummy, cafe, @dummy, restaurant,
     @dummy, atm, @dummy, office, @dummy, hotel);


drop table if exists db_ml.temp1;
create table db_ml.temp1
as
select t.*,
       p1.petrol     as s_petrol,
       p1.market     as s_market,
       p1.uptown     as s_uptown,
       p1.metro      as s_metro,
       p1.bus        as s_bus,
       p1.cafe       as s_cafe,
       p1.restaurant as s_restaurant,
       p1.atm        as s_atm,
       p1.office     as s_office,
       p1.hotel      as s_hotel
from db_ml.train t,
     db_ml.poi p1
where t.start_geo_id = p1.id;

select count(*)
from db_ml.temp1;

drop table if exists db_ml.temp2;
create table db_ml.temp2
as
select t1.*,
       p2.petrol     as e_petrol,
       p2.market     as e_market,
       p2.uptown     as e_uptown,
       p2.metro      as e_metro,
       p2.bus        as e_bus,
       p2.cafe       as e_cafe,
       p2.restaurant as e_restaurant,
       p2.atm        as e_atm,
       p2.office     as e_office,
       p2.hotel      as e_hotel
from db_ml.temp1 t1,
     db_ml.poi p2
where t1.end_geo_id = p2.id;

select count(*)
from db_ml.temp2;

select *
from db_ml.temp2;



select datetime, date(datetime), hour(datetime), minute(datetime)
from db_ml.weather;

create table db_ml.temp3
as (
    select t2.*,
           w.temperature           w_temperature,
           w.feels_like            w_feels_like,
           w.pressure              w_pressure,
           w.humidity              w_humidity,
           w.visibility            w_visibility,
           w.wind_direction_degree w_direction_degree,
           w.wind_speed            w_wind_speed
    from (
             select date(datetime)             date,
                    hour(datetime)             hour,
                    avg(temperature)           temperature,
                    avg(feels_like)            feels_like,
                    avg(pressure)              pressure,
                    avg(humidity)              humidity,
                    avg(visibility)            visibility,
                    avg(wind_direction_degree) wind_direction_degree,
                    avg(wind_speed)            wind_speed
             from db_ml.weather
             group by date, hour
         ) as w,
         db_ml.temp2 t2
    where w.hour = t2.create_hour
      and w.date = t2.create_date
);

show tables from db_ml;


# truncate db_ml.train;
show variables like 'coll%';
show variables like 'char%';


create database db_test default character set utf8mb4 collate utf8mb4_unicode_ci;
drop table db_test.test;
create table db_test.test
(
    text varchar(255)
);

insert into db_test.test value ('测试');
select *
from db_test.test;

SELECT DATE_FORMAT(datetime, '%Y-%m-%d') as date,
       DATE_FORMAT(datetime, '%H')       as hour,
       DATE_FORMAT(datetime, '%i')       as min
from db_ml.weather;
SELECT DATE_FORMAT(datetime, '%Y-%m-%d %H:%i:%s')
from db_ml.weather;