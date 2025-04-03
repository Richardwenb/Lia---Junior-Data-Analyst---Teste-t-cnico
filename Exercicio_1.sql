



WITH enrollment_summary AS (
SELECT 
    sc.name AS nome_escola,
    st.enrolled_at AS data_matricula,
    COUNT(st.id) AS total_estudantes, 
    COALESCE(SUM(c.price), 0) AS total_pago 
FROM students st
JOIN courses c ON st.course_id = c.id
JOIN schools sc ON c.school_id = sc.id
WHERE c.name <> 'Data'
GROUP BY sc.name, st.enrolled_at
ORDER BY st.enrolled_at desc
)

SELECT 
    nome_escola,
    data_matricula,
    total_estudantes,
    -- Soma acumulada de alunos matriculados por escola ao longo do tempo
    SUM(total_estudantes) OVER (
        PARTITION BY nome_escola 
        ORDER BY data_matricula ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS acumulativo_estudantes,
    -- Média móvel de 7 dias
    AVG(total_estudantes) OVER (
        PARTITION BY nome_escola 
        ORDER BY data_matricula ASC
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS movel_7d,
    -- Média móvel de 30 dias
    AVG(total_estudantes) OVER (
        PARTITION BY nome_escola 
        ORDER BY data_matricula ASC
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS movel_30d
FROM enrollment_summary
ORDER BY nome_escola, data_matricula ASC;