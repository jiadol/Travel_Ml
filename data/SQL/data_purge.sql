CREATE TABLE hk_data_pg (
    日期 DATE,
    外籍机场入境 INT,
    机场入境 INT,
    总计入境 INT,
    总计出入境 INT
);


INSERT INTO hk_data_pg (日期, 外籍机场入境, 机场入境, 总计入境, 总计出入境)
SELECT 日期,
       SUM(IF(出入境 = '入境' AND 管制站 = '机场', 其他访客, 0)) AS '外籍机场入境',
       SUM(IF(出入境 = '入境' AND 管制站 = '机场', 总计, 0)) AS '机场入境',
       SUM(IF(出入境 = '入境', 总计, 0))                     AS '总计入境',
       SUM(总计)                                             AS '总计出入境'
FROM hk_data
GROUP BY 日期
ORDER BY 日期;
