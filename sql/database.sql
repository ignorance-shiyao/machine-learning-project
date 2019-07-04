drop database if exists db_ml;
create database db_ml;

drop table if exists db_ml.train;
create table db_ml.train
(
    id                varchar(255) primary key comment 'id PK',
    driver_id         varchar(255) comment '司机 ID',
    member_id         varchar(255) comment '乘客 ID',
    create_date       varchar(255) comment '约车日期',
    create_hour       int(2) comment '约车时间',
    status            int(1) comment '约车装态：0-未预约成功，1-预约取消，2-出行成功',
    estimate_money    decimal(6, 2) comment '预估金额',
    estimate_distance double(12, 2) comment '预估距离',
    estimate_term     int(3) comment '预估时间',
    start_geo_id      varchar(255) comment '起始地点',
    end_geo_id        varchar(255) comment '终到地点'
) comment '训练集表';

drop table if exists db_ml.weather;
create table db_ml.weather
(
    date                  varchar(255) comment '日期',
    text                  varchar(255) comment '天气',
    code                  int(11) comment '代码',
    temperature           int(11) comment '温度',
    feels_like            int(11) comment '体感温度',
    pressure              int(11) comment '气压',
    humidity              int(11) comment '相对湿度',
    visibility            double(6, 2) comment '能见度',
    wind_direction        varchar(255) comment '风向',
    wind_direction_degree int(11) comment '风向角度',
    wind_speed            double(6, 2) comment '风速',
    wind_scale            int(11) comment '风力等级'
) comment '天气表';

select *
from db_ml.train;

select *
from db_ml.weather;

# λ mysql -u root -p --local-infile db_ml

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

load data local infile 'D:\\ProjectFile\\machine-learning-project\\data\\UAI_Data\\train_July.csv' into table db_ml.train fields terminated by ',' ignore 1 lines;

load data local infile 'D:\\ProjectFile\\machine-learning-project\\data\\UAI_Data\\weather.csv' into table db_ml.weather fields terminated by ',' ignore 1 lines;

# truncate db_ml.train;