CREATE TABLE hk_immigration_selected
(
    日期       DATE,
    cn机场入境 INTEGER,
    gl机场入境 INTEGER,
    cn机场出境 INTEGER,
    gl机场出境 INTEGER

);

INSERT INTO hk_immigration_selected(日期, cn机场入境, gl机场入境, cn机场出境, gl机场出境)
SELECT 日期,
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) AS 'cn机场入境',
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) AS 'gl机场入境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) AS 'gl机场出境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) AS 'cn机场出境'
FROM hk_immigration
where 日期 >= '2020-02-01'
GROUP BY 日期;