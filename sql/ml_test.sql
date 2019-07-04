#新建原始测试集表
drop table if exists db_ml.test;
create table db_ml.test
(
    id           int primary key comment 'id PK',
    start_geo_id varchar(255) comment '起始地点',
    end_geo_id   varchar(255) comment '终到地点',
    create_date  varchar(255) comment '约车日期',
    create_hour  int comment '约车时间'
) comment '原始测试集表';

-- λ mysql -u root -p --local-infile db_ml

#导入数据到原始测试集
load data local infile 'D:\\DevFiles\\machine-learning-project\\data\\test_Aug.csv'
# load data local infile '/Users/shiyao/OneDrive/DevFiles/machine-learning-project/data/test_id_Aug_agg_private5k.csv'
    into table db_ml.test
    fields terminated by ','
    ignore 1 lines;

select count(*)
from db_ml.test;


#利用原始测试集表的开始地理位置和公共设施表的地理位置关联形成test1
drop table if exists db_ml.test1;
create table db_ml.test1
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
from db_ml.test t
         left join
     db_ml.poi p1
     on t.start_geo_id = p1.id;

select count(*)
from db_ml.test1;


#利用原始测试集表的结束地理位置和公共设施表的地理位置关联形成test2
drop table if exists db_ml.test2;
create table db_ml.test2
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
from db_ml.test1 t1
         left join
     db_ml.poi p2
     on t1.end_geo_id = p2.id;

select count(*)
from db_ml.test2;

#利用订单创建时间形成测试集
drop table if exists db_ml.test_data;
create table db_ml.test_data
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
         db_ml.test2 t2
    where w.hour = t2.create_hour
      and w.date = t2.create_date
);

desc db_ml.test_data;

select count(*)
from db_ml.test_data;


select *
from db_ml.test_data
where s_petrol is null;


select *
from db_ml.test_data
where e_petrol is null;

# 为一些空字段补零形成最终测试集
update db_ml.test_data
set s_petrol     = 0,
    s_market     = 0,
    s_uptown     = 0,
    s_metro      = 0,
    s_bus        = 0,
    s_cafe       = 0,
    s_restaurant = 0,
    s_atm        = 0,
    s_office     = 0,
    s_hotel      = 0
where s_petrol is null;

update db_ml.test_data
set e_petrol     = 0,
    e_market     = 0,
    e_uptown     = 0,
    e_metro      = 0,
    e_bus        = 0,
    e_cafe       = 0,
    e_restaurant = 0,
    e_atm        = 0,
    e_office     = 0,
    e_hotel      = 0
where e_petrol is null;


