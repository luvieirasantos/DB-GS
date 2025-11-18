-- ============================================================
-- SCRIPT DE TESTE DAS FUNCIONALIDADES PRINCIPAIS
-- ============================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;
SET LONG 100000;

PROMPT
PROMPT ============================================================
PROMPT TESTANDO FUNCIONALIDADES DO SISTEMA
PROMPT ============================================================
PROMPT

-- ============================================================
-- 1. TESTAR FUNÇÃO DE VALIDAÇÃO DE DADOS
-- ============================================================
PROMPT
PROMPT 1. TESTANDO VALIDAÇÃO DE DADOS CADASTRAIS
PROMPT ------------------------------------------------------------
PROMPT

-- Validar CPF
SELECT 'Validação CPF' as teste, fn_validar_dados_cadastrais('CPF', '123.456.789-01') as resultado FROM DUAL;

-- Validar Email
SELECT 'Validação Email' as teste, fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br') as resultado FROM DUAL;

-- Validar CNPJ
SELECT 'Validação CNPJ' as teste, fn_validar_dados_cadastrais('CNPJ', '12.345.678/0001-90') as resultado FROM DUAL;

-- ============================================================
-- 2. TESTAR FUNÇÃO DE COMPATIBILIDADE
-- ============================================================
PROMPT
PROMPT 2. TESTANDO COMPATIBILIDADE FUNCIONÁRIO-CURSO
PROMPT ------------------------------------------------------------
PROMPT

-- Calcular compatibilidade entre funcionário 1 e curso 1
SELECT fn_calcular_compatibilidade_curso(1, 1) as compatibilidade FROM DUAL;

PROMPT

-- ============================================================
-- 3. TESTAR RANKING DE PONTOS
-- ============================================================
PROMPT
PROMPT 3. TOP 5 FUNCIONÁRIOS COM MAIS PONTOS
PROMPT ------------------------------------------------------------
PROMPT

SELECT
    ROWNUM as posicao,
    nome,
    cargo,
    nivel_atual,
    pontos_acumulados
FROM (
    SELECT nome, cargo, nivel_atual, pontos_acumulados
    FROM funcionario
    WHERE status = 'ATIVO'
    ORDER BY pontos_acumulados DESC
)
WHERE ROWNUM <= 5;

-- ============================================================
-- 4. TESTAR CURSOS MAIS PROCURADOS
-- ============================================================
PROMPT
PROMPT 4. CURSOS MAIS PROCURADOS
PROMPT ------------------------------------------------------------
PROMPT

SELECT
    ROWNUM as posicao,
    nome_curso,
    nivel_dificuldade,
    total_matriculas
FROM (
    SELECT
        c.nome_curso,
        c.nivel_dificuldade,
        COUNT(m.id_matricula) as total_matriculas
    FROM curso c
    LEFT JOIN matricula m ON c.id_curso = m.id_curso
    GROUP BY c.nome_curso, c.nivel_dificuldade
    ORDER BY total_matriculas DESC
)
WHERE ROWNUM <= 5;

-- ============================================================
-- 5. TESTAR COMPETÊNCIAS EM ALTA
-- ============================================================
PROMPT
PROMPT 5. COMPETÊNCIAS EM ALTA NO MERCADO
PROMPT ------------------------------------------------------------
PROMPT

SELECT
    nome_competencia,
    categoria,
    nivel_mercado,
    COUNT(fc.id_funcionario) as total_funcionarios
FROM competencia c
LEFT JOIN funcionario_competencia fc ON c.id_competencia = fc.id_competencia
WHERE c.nivel_mercado = 'EM_ALTA'
GROUP BY c.nome_competencia, c.categoria, c.nivel_mercado
ORDER BY total_funcionarios DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================
-- 6. TESTAR CERTIFICADOS EMITIDOS
-- ============================================================
PROMPT
PROMPT 6. CERTIFICADOS EMITIDOS
PROMPT ------------------------------------------------------------
PROMPT

SELECT
    f.nome as funcionario,
    c.nome_curso,
    cert.codigo_certificado,
    TO_CHAR(cert.data_emissao, 'DD/MM/YYYY') as data_emissao,
    cert.nota_final
FROM certificado cert
INNER JOIN matricula m ON cert.id_matricula = m.id_matricula
INNER JOIN funcionario f ON m.id_funcionario = f.id_funcionario
INNER JOIN curso c ON m.id_curso = c.id_curso
WHERE cert.status = 'ATIVO'
ORDER BY cert.data_emissao DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================
-- 7. TESTAR AUDITORIA
-- ============================================================
PROMPT
PROMPT 7. ÚLTIMAS OPERAÇÕES AUDITADAS
PROMPT ------------------------------------------------------------
PROMPT

SELECT
    tabela,
    operacao,
    usuario,
    TO_CHAR(data_operacao, 'DD/MM/YYYY HH24:MI:SS') as data_hora
FROM auditoria
ORDER BY data_operacao DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================
-- 8. ESTATÍSTICAS GERAIS
-- ============================================================
PROMPT
PROMPT 8. ESTATÍSTICAS GERAIS DO SISTEMA
PROMPT ------------------------------------------------------------
PROMPT

SELECT
    'Total de Empresas Ativas' as metrica,
    COUNT(*) as valor
FROM empresa WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Funcionários Ativos', COUNT(*)
FROM funcionario WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Cursos Ativos', COUNT(*)
FROM curso WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Matrículas', COUNT(*)
FROM matricula
UNION ALL
SELECT 'Cursos Concluídos', COUNT(*)
FROM matricula WHERE status = 'CONCLUIDO'
UNION ALL
SELECT 'Certificados Emitidos', COUNT(*)
FROM certificado WHERE status = 'ATIVO'
UNION ALL
SELECT 'Total de Competências', COUNT(*)
FROM competencia WHERE status = 'ATIVO'
UNION ALL
SELECT 'Registros de Auditoria', COUNT(*)
FROM auditoria;

PROMPT
PROMPT ============================================================
PROMPT TESTES CONCLUÍDOS COM SUCESSO!
PROMPT ============================================================
PROMPT
