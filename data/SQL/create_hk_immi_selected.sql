CREATE TABLE hk_immigration_selected
(
    日期       DATE,
    cn机场入境 INTEGER,
    gl机场入境 INTEGER,
    cn机场出境 INTEGER,
    gl机场出境 INTEGER

);

-- 插入数据
INSERT INTO hk_immigration_selected(日期, cn机场入境, gl机场入境, cn机场出境, gl机场出境)

with monthly_totals AS (SELECT 日期                                                                        as mon,
                               SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) AS 'cn_m_in',
                               SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) AS 'gl_m_in',
                               SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) AS 'gl_m_out',
                               SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) AS 'cn_m_out'
                        FROM hk_immigration
                        GROUP BY strftime('%Y-%m', 日期)
                        ORDER BY 日期)

SELECT 日期,
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) /
       CAST(cn_m_in as float)  AS 'cn机场入境',
       SUM(CASE WHEN 出入境 = '入境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) /
       CAST(cn_m_out as float) AS 'gl机场入境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 其他访客 ELSE 0 END) /
       CAST(gl_m_out as float) AS 'gl机场出境',
       SUM(CASE WHEN 出入境 = '出境' AND 管制站 = '机场' THEN 内地访客 ELSE 0 END) /
       CAST(cn_m_in as float)  AS 'cn机场出境'
FROM hk_immigration h
         join monthly_totals m on m.mon = h.日期
GROUP BY 日期
ORDER BY 日期;