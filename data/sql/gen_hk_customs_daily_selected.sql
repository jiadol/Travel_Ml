CREATE TABLE hk_customs_daily_selected
(
    date              DATE,
    CN_airport_entry  INTEGER,
    global_airport_entry  INTEGER,
    CN_airport_departure  INTEGER,
    global_airport_departure INTEGER
);

INSERT INTO hk_customs_daily_selected(date, CN_airport_entry, global_airport_entry, CN_airport_departure, global_airport_departure)
SELECT date,
       SUM(CASE WHEN entry_or_exit = '入境' AND control_station = '机场' THEN cn ELSE 0 END) AS 'CN_airport_entry',
       SUM(CASE WHEN entry_or_exit = '入境' AND control_station = '机场' THEN global ELSE 0 END) AS 'global_airport_entry',
       SUM(CASE WHEN entry_or_exit = '出境' AND control_station = '机场' THEN cn ELSE 0 END) AS 'CN_airport_departure',
       SUM(CASE WHEN entry_or_exit = '出境' AND control_station = '机场' THEN global ELSE 0 END) AS 'global_airport_departure'
FROM hk_customs
GROUP BY date;
