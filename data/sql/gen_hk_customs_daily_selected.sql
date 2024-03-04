CREATE TABLE hk_customs_daily_selected
(
    date                 DATE,
    HK_airport_departure INTEGER,
    CN_airport_departure INTEGER
);

INSERT INTO hk_customs_daily_selected(date, HK_airport_departure, CN_airport_departure)
SELECT date,
       SUM(CASE WHEN entry_or_exit = '出境' AND control_station = '机场' THEN cn ELSE 0 END)     AS 'CN_airport_departure',
       SUM(CASE WHEN entry_or_exit = '出境' AND control_station = '机场' THEN hk ELSE 0 END)     AS 'HK_airport_departure'
FROM hk_customs
GROUP BY date;
