-- 创建新表
CREATE TABLE hk_immigration_sum_daliy (
    日期 DATE,
    hk机场入境 INTEGER,
    cn机场入境 INTEGER,
    gl机场入境 INTEGER,
    机场入境 INTEGER,
    总计入境 INTEGER,
    hk机场出境 INTEGER,
    cn机场出境 INTEGER,
    gl机场出境 INTEGER,
    机场出境 INTEGER,
    总计出境 INTEGER,
    总计出入境 INTEGER
);

-- 插入数据
INSERT INTO hk_immigration_sum_daliy(日期, hk机场入境, cn机场入境, gl机场入境, 机场入境, 总计入境, hk机场出境, cn机场出境, gl机场出境, 机场出境, 总计出境, 总计出入境)
SELECT 日期,
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 香港居民 ELSE 0 END) AS 'hk机场入境',
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) AS 'cn机场入境',
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) AS 'gl机场入境',
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 总计 ELSE 0 END) AS '机场入境',
       SUM(CASE WHEN 出入境 = '入境' THEN 总计 ELSE 0 END) AS '总计入境',

       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 香港居民 ELSE 0 END) AS 'hk机场出境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) AS 'cn机场出境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) AS 'gl机场出境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 总计 ELSE 0 END) AS '机场出境',
       SUM(CASE WHEN 出入境 = '出境' THEN 总计 ELSE 0 END) AS '总计出境',

       SUM(总计) AS '总计出入境'
FROM hk_immigration
GROUP BY 日期
ORDER BY 日期;


