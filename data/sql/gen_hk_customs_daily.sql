-- 创建新表
CREATE TABLE hk_visitors_daily
(
    date                     DATE,
    HK_airport_entry         INTEGER,
    CN_airport_entry         INTEGER,
    global_airport_entry     INTEGER,
    airport_entry            INTEGER,
    HK_airport_departure     INTEGER,
    CN_airport_departure     INTEGER,
    global_airport_departure INTEGER,
    airport_departure        INTEGER
);

-- 插入数据
INSERT INTO hk_visitors_daily(date, HK_airport_entry, CN_airport_entry, global_airport_entry, airport_entry,
                                 HK_airport_departure, CN_airport_departure, global_airport_departure,
                                 airport_departure)
SELECT DATE(strftime('%Y-%m-%d', date))                                                         AS 'date',
       SUM(CASE
               WHEN entry_or_exit = '入境' AND control_station = '机场' THEN hk
               ELSE 0 END)                                                                      AS 'HK_airport_entry',
       SUM(CASE
               WHEN entry_or_exit = '入境' AND control_station = '机场' THEN cn
               ELSE 0 END)                                                                      AS 'CN_airport_entry',
       SUM(CASE
               WHEN entry_or_exit = '入境' AND control_station = '机场' THEN global
               ELSE 0 END)                                                                      AS 'global_airport_entry',
       SUM(CASE WHEN entry_or_exit = '入境' AND control_station = '机场' THEN total ELSE 0 END) AS 'airport_entry',

       SUM(CASE
               WHEN entry_or_exit = '出境' AND control_station = '机场' THEN hk
               ELSE 0 END)                                                                      AS 'HK_airport_departure',
       SUM(CASE
               WHEN entry_or_exit = '出境' AND control_station = '机场' THEN cn
               ELSE 0 END)                                                                      AS 'CN_airport_departure',
       SUM(CASE
               WHEN entry_or_exit = '出境' AND control_station = '机场' THEN global
               ELSE 0 END)                                                                      AS 'global_airport_departure',
       SUM(CASE WHEN entry_or_exit = '出境' AND control_station = '机场' THEN total ELSE 0 END) AS 'airport_departure'
FROM hk_visitors
GROUP BY strftime('%Y-%m-%d', date)
ORDER BY date;
