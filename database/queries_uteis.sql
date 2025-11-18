-- ============================================================
-- QUERIES ÚTEIS - PLATAFORMA DE CURSOS CORPORATIVA
-- Consultas prontas para análise e relatórios
-- ============================================================

-- ============================================================
-- 1. ANÁLISE DE FUNCIONÁRIOS
-- ============================================================

-- 1.1 Ranking de funcionários por pontos
SELECT
    ROWNUM as posicao,
    f.nome,
    f.cargo,
    f.nivel_atual,
    f.pontos_acumulados,
    e.nome_fantasia as empresa
FROM (
    SELECT * FROM funcionario
    WHERE status = 'ATIVO'
    ORDER BY pontos_acumulados DESC
) f
INNER JOIN empresa e ON f.id_empresa = e.id_empresa
WHERE ROWNUM <= 10;

-- 1.2 Distribuição de funcionários por nível
SELECT
    nivel_atual,
    COUNT(*) as total_funcionarios,
    ROUND(AVG(pontos_acumulados), 2) as media_pontos,
    MIN(pontos_acumulados) as min_pontos,
    MAX(pontos_acumulados) as max_pontos
FROM funcionario
WHERE status = 'ATIVO'
GROUP BY nivel_atual
ORDER BY media_pontos DESC;

-- 1.3 Funcionários com mais competências
SELECT
    f.nome,
    f.cargo,
    COUNT(fc.id_competencia) as total_competencias,
    LISTAGG(c.nome_competencia, ', ') WITHIN GROUP (ORDER BY c.nome_competencia) as competencias
FROM funcionario f
INNER JOIN funcionario_competencia fc ON f.id_funcionario = fc.id_funcionario
INNER JOIN competencia c ON fc.id_competencia = c.id_competencia
GROUP BY f.nome, f.cargo
ORDER BY total_competencias DESC
FETCH FIRST 10 ROWS ONLY;

-- 1.4 Taxa de conclusão por funcionário
SELECT
    f.nome,
    f.nivel_atual,
    COUNT(m.id_matricula) as total_matriculas,
    COUNT(CASE WHEN m.status = 'CONCLUIDO' THEN 1 END) as concluidos,
    COUNT(CASE WHEN m.status = 'EM_ANDAMENTO' THEN 1 END) as em_andamento,
    ROUND(
        COUNT(CASE WHEN m.status = 'CONCLUIDO' THEN 1 END) * 100.0 /
        NULLIF(COUNT(m.id_matricula), 0),
        2
    ) as taxa_conclusao_pct
FROM funcionario f
LEFT JOIN matricula m ON f.id_funcionario = m.id_funcionario
WHERE f.status = 'ATIVO'
GROUP BY f.nome, f.nivel_atual
HAVING COUNT(m.id_matricula) > 0
ORDER BY taxa_conclusao_pct DESC;

-- ============================================================
-- 2. ANÁLISE DE CURSOS
-- ============================================================

-- 2.1 Cursos mais populares
SELECT
    c.nome_curso,
    cat.nome_categoria,
    c.nivel_dificuldade,
    c.carga_horaria,
    c.pontos_conclusao,
    COUNT(m.id_matricula) as total_matriculas,
    COUNT(CASE WHEN m.status = 'CONCLUIDO' THEN 1 END) as concluidos,
    ROUND(AVG(m.nota_final), 2) as media_notas
FROM curso c
INNER JOIN categoria_curso cat ON c.id_categoria = cat.id_categoria
LEFT JOIN matricula m ON c.id_curso = m.id_curso
GROUP BY c.nome_curso, cat.nome_categoria, c.nivel_dificuldade, c.carga_horaria, c.pontos_conclusao
ORDER BY total_matriculas DESC
FETCH FIRST 10 ROWS ONLY;

-- 2.2 Cursos por categoria
SELECT
    cat.nome_categoria,
    COUNT(c.id_curso) as total_cursos,
    ROUND(AVG(c.carga_horaria), 2) as media_carga_horaria,
    SUM(CASE WHEN c.nivel_dificuldade = 'INICIANTE' THEN 1 ELSE 0 END) as iniciante,
    SUM(CASE WHEN c.nivel_dificuldade = 'INTERMEDIARIO' THEN 1 ELSE 0 END) as intermediario,
    SUM(CASE WHEN c.nivel_dificuldade = 'AVANCADO' THEN 1 ELSE 0 END) as avancado
FROM categoria_curso cat
LEFT JOIN curso c ON cat.id_categoria = c.id_categoria
GROUP BY cat.nome_categoria
ORDER BY total_cursos DESC;

-- 2.3 Cursos com melhor avaliação
SELECT
    c.nome_curso,
    c.nivel_dificuldade,
    COUNT(m.id_matricula) as total_avaliacoes,
    ROUND(AVG(m.nota_final), 2) as nota_media,
    MIN(m.nota_final) as nota_minima,
    MAX(m.nota_final) as nota_maxima
FROM curso c
INNER JOIN matricula m ON c.id_curso = m.id_curso
WHERE m.nota_final IS NOT NULL
GROUP BY c.nome_curso, c.nivel_dificuldade
HAVING COUNT(m.id_matricula) >= 3
ORDER BY nota_media DESC
FETCH FIRST 10 ROWS ONLY;

-- 2.4 Módulos por curso
SELECT
    c.nome_curso,
    COUNT(m.id_modulo) as total_modulos,
    SUM(m.duracao_minutos) as duracao_total_minutos,
    ROUND(SUM(m.duracao_minutos) / 60.0, 2) as duracao_total_horas
FROM curso c
INNER JOIN modulo m ON c.id_curso = m.id_curso
GROUP BY c.nome_curso
ORDER BY total_modulos DESC;

-- ============================================================
-- 3. ANÁLISE DE COMPETÊNCIAS
-- ============================================================

-- 3.1 Competências em alta no mercado
SELECT
    c.nome_competencia,
    c.categoria,
    c.nivel_mercado,
    COUNT(fc.id_funcionario) as total_funcionarios_com_competencia,
    ROUND(
        COUNT(fc.id_funcionario) * 100.0 /
        (SELECT COUNT(*) FROM funcionario WHERE status = 'ATIVO'),
        2
    ) as percentual_cobertura
FROM competencia c
LEFT JOIN funcionario_competencia fc ON c.id_competencia = fc.id_competencia
WHERE c.status = 'ATIVO' AND c.nivel_mercado = 'EM_ALTA'
GROUP BY c.nome_competencia, c.categoria, c.nivel_mercado
ORDER BY total_funcionarios_com_competencia DESC;

-- 3.2 Competências por categoria
SELECT
    categoria,
    COUNT(*) as total_competencias,
    SUM(CASE WHEN nivel_mercado = 'EM_ALTA' THEN 1 ELSE 0 END) as em_alta,
    SUM(CASE WHEN nivel_mercado = 'ESTAVEL' THEN 1 ELSE 0 END) as estavel,
    SUM(CASE WHEN nivel_mercado = 'EM_BAIXA' THEN 1 ELSE 0 END) as em_baixa
FROM competencia
WHERE status = 'ATIVO'
GROUP BY categoria
ORDER BY total_competencias DESC;

-- 3.3 Gap de competências (competências em alta com poucos profissionais)
SELECT
    c.nome_competencia,
    c.categoria,
    COUNT(fc.id_funcionario) as total_profissionais,
    (SELECT COUNT(*) FROM funcionario WHERE status = 'ATIVO') as total_funcionarios_ativos,
    ROUND(
        (SELECT COUNT(*) FROM funcionario WHERE status = 'ATIVO') -
        COUNT(fc.id_funcionario)
    ) as gap_profissionais
FROM competencia c
LEFT JOIN funcionario_competencia fc ON c.id_competencia = fc.id_competencia
WHERE c.nivel_mercado = 'EM_ALTA' AND c.status = 'ATIVO'
GROUP BY c.nome_competencia, c.categoria
HAVING COUNT(fc.id_funcionario) < (SELECT COUNT(*) FROM funcionario WHERE status = 'ATIVO') * 0.3
ORDER BY gap_profissionais DESC;

-- ============================================================
-- 4. ANÁLISE DE TIMES
-- ============================================================

-- 4.1 Performance por time
SELECT
    t.nome_time,
    g.nome as gerente,
    COUNT(DISTINCT ft.id_funcionario) as total_membros,
    ROUND(AVG(f.pontos_acumulados), 2) as media_pontos_time,
    SUM(f.pontos_acumulados) as pontos_totais_time
FROM time t
INNER JOIN gerente g ON t.id_gerente = g.id_gerente
LEFT JOIN funcionario_time ft ON t.id_time = ft.id_time
LEFT JOIN funcionario f ON ft.id_funcionario = f.id_funcionario
WHERE t.status = 'ATIVO' AND ft.status = 'ATIVO'
GROUP BY t.nome_time, g.nome
ORDER BY pontos_totais_time DESC;

-- 4.2 Composição dos times por nível
SELECT
    t.nome_time,
    COUNT(CASE WHEN f.nivel_atual = 'INICIANTE' THEN 1 END) as iniciantes,
    COUNT(CASE WHEN f.nivel_atual = 'INTERMEDIARIO' THEN 1 END) as intermediarios,
    COUNT(CASE WHEN f.nivel_atual = 'AVANCADO' THEN 1 END) as avancados,
    COUNT(CASE WHEN f.nivel_atual = 'EXPERT' THEN 1 END) as experts,
    COUNT(DISTINCT ft.id_funcionario) as total
FROM time t
LEFT JOIN funcionario_time ft ON t.id_time = ft.id_time
LEFT JOIN funcionario f ON ft.id_funcionario = f.id_funcionario
WHERE t.status = 'ATIVO' AND ft.status = 'ATIVO'
GROUP BY t.nome_time
ORDER BY total DESC;

-- ============================================================
-- 5. ANÁLISE DE CERTIFICADOS
-- ============================================================

-- 5.1 Certificados emitidos por mês
SELECT
    TO_CHAR(data_emissao, 'YYYY-MM') as mes_emissao,
    COUNT(*) as total_certificados,
    ROUND(AVG(nota_final), 2) as nota_media,
    SUM(carga_horaria) as total_horas_certificadas
FROM certificado
WHERE status = 'ATIVO'
GROUP BY TO_CHAR(data_emissao, 'YYYY-MM')
ORDER BY mes_emissao DESC;

-- 5.2 Funcionários com mais certificados
SELECT
    f.nome,
    f.cargo,
    f.nivel_atual,
    COUNT(cert.id_certificado) as total_certificados,
    ROUND(AVG(cert.nota_final), 2) as nota_media,
    SUM(cert.carga_horaria) as horas_certificadas
FROM funcionario f
INNER JOIN matricula m ON f.id_funcionario = m.id_funcionario
INNER JOIN certificado cert ON m.id_matricula = cert.id_matricula
WHERE cert.status = 'ATIVO'
GROUP BY f.nome, f.cargo, f.nivel_atual
ORDER BY total_certificados DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================
-- 6. ANÁLISE DE COMPETIÇÕES
-- ============================================================

-- 6.1 Competições e seus vencedores
SELECT
    comp.nome_competicao,
    comp.tipo_competicao,
    comp.data_inicio,
    comp.data_fim,
    comp.status,
    COUNT(p.id_premio) as total_premios,
    SUM(NVL(p.valor_premio, 0)) as valor_total_premios
FROM competicao comp
LEFT JOIN premio_competicao p ON comp.id_competicao = p.id_competicao
GROUP BY comp.nome_competicao, comp.tipo_competicao, comp.data_inicio, comp.data_fim, comp.status
ORDER BY comp.data_inicio DESC;

-- 6.2 Times com mais prêmios
SELECT
    t.nome_time,
    COUNT(p.id_premio) as total_premios,
    SUM(NVL(p.valor_premio, 0)) as valor_total,
    LISTAGG(comp.nome_competicao, ', ') WITHIN GROUP (ORDER BY p.data_distribuicao DESC) as competicoes_vencidas
FROM time t
INNER JOIN premio_competicao p ON t.id_time = p.id_time
INNER JOIN competicao comp ON p.id_competicao = comp.id_competicao
GROUP BY t.nome_time
ORDER BY total_premios DESC;

-- ============================================================
-- 7. ANÁLISE DE AUDITORIA
-- ============================================================

-- 7.1 Operações mais frequentes
SELECT
    tabela,
    operacao,
    COUNT(*) as total_operacoes,
    MIN(data_operacao) as primeira_operacao,
    MAX(data_operacao) as ultima_operacao
FROM auditoria
GROUP BY tabela, operacao
ORDER BY total_operacoes DESC;

-- 7.2 Atividade por usuário
SELECT
    usuario,
    COUNT(*) as total_operacoes,
    COUNT(DISTINCT tabela) as tabelas_afetadas,
    MIN(data_operacao) as primeira_atividade,
    MAX(data_operacao) as ultima_atividade
FROM auditoria
GROUP BY usuario
ORDER BY total_operacoes DESC;

-- 7.3 Últimas operações
SELECT
    id_auditoria,
    tabela,
    operacao,
    usuario,
    TO_CHAR(data_operacao, 'DD/MM/YYYY HH24:MI:SS') as data_hora,
    SUBSTR(dados_novos, 1, 100) as dados
FROM auditoria
ORDER BY data_operacao DESC
FETCH FIRST 20 ROWS ONLY;

-- ============================================================
-- 8. ESTATÍSTICAS GERAIS
-- ============================================================

-- 8.1 Resumo geral do sistema
SELECT
    'Total de Empresas' as metrica,
    TO_CHAR(COUNT(*)) as valor
FROM empresa WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Funcionários', TO_CHAR(COUNT(*))
FROM funcionario WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Cursos', TO_CHAR(COUNT(*))
FROM curso WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Matrículas', TO_CHAR(COUNT(*))
FROM matricula
UNION ALL
SELECT 'Cursos Concluídos', TO_CHAR(COUNT(*))
FROM matricula WHERE status = 'CONCLUIDO'
UNION ALL
SELECT 'Certificados Emitidos', TO_CHAR(COUNT(*))
FROM certificado WHERE status = 'ATIVO'
UNION ALL
SELECT 'Competências Cadastradas', TO_CHAR(COUNT(*))
FROM competencia WHERE status = 'ATIVO'
UNION ALL
SELECT 'Média de Pontos dos Funcionários', TO_CHAR(ROUND(AVG(pontos_acumulados), 2))
FROM funcionario WHERE status = 'ATIVO'
UNION ALL
SELECT 'Média de Notas Finais', TO_CHAR(ROUND(AVG(nota_final), 2))
FROM matricula WHERE nota_final IS NOT NULL
UNION ALL
SELECT 'Total de Operações Auditadas', TO_CHAR(COUNT(*))
FROM auditoria;

-- 8.2 Evolução mensal de matrículas
SELECT
    TO_CHAR(data_matricula, 'YYYY-MM') as mes,
    COUNT(*) as novas_matriculas,
    COUNT(CASE WHEN status = 'CONCLUIDO' THEN 1 END) as concluidas_no_mes
FROM matricula
GROUP BY TO_CHAR(data_matricula, 'YYYY-MM')
ORDER BY mes DESC;

-- ============================================================
-- 9. QUERIES AVANÇADAS COM FUNÇÕES DO SISTEMA
-- ============================================================

-- 9.1 Testar compatibilidade entre funcionário e curso
SELECT
    f.nome as funcionario,
    c.nome_curso,
    fn_calcular_compatibilidade_curso(f.id_funcionario, c.id_curso) as analise_compatibilidade
FROM funcionario f, curso c
WHERE f.id_funcionario = 1 AND c.id_curso IN (1, 5, 10)
ORDER BY c.id_curso;

-- 9.2 Validar dados cadastrais
SELECT
    'CPF: 123.456.789-01' as dado,
    fn_validar_dados_cadastrais('CPF', '123.456.789-01') as resultado_validacao
FROM DUAL
UNION ALL
SELECT 'Email: teste@empresa.com.br',
       fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br')
FROM DUAL
UNION ALL
SELECT 'CNPJ: 12.345.678/0001-90',
       fn_validar_dados_cadastrais('CNPJ', '12.345.678/0001-90')
FROM DUAL;

-- 9.3 Obter perfil JSON de funcionário
SELECT fn_gerar_perfil_funcionario_json(1) as perfil_json FROM DUAL;

-- 9.4 Obter ranking da empresa
SELECT pkg_analytics.obter_ranking_pontos_empresa(1, 10) as ranking_json FROM DUAL;

-- 9.5 Competências mais procuradas
SELECT pkg_analytics.obter_competencias_mais_procuradas() as competencias_json FROM DUAL;

-- ============================================================
-- FIM DAS QUERIES ÚTEIS
-- ============================================================
