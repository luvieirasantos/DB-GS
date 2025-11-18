-- ============================================================
-- SCRIPT DE VALIDAÇÃO DA INSTALAÇÃO
-- Verifica se todos os objetos foram criados corretamente
-- ============================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;
SET PAGESIZE 1000;

DECLARE
    v_count NUMBER;
    v_total_errors NUMBER := 0;
    v_total_checks NUMBER := 0;

    PROCEDURE check_object(p_type VARCHAR2, p_name VARCHAR2, p_expected_count NUMBER) IS
        v_actual_count NUMBER;
        v_status VARCHAR2(10);
    BEGIN
        v_total_checks := v_total_checks + 1;

        IF p_type = 'TABLE' THEN
            SELECT COUNT(*) INTO v_actual_count FROM user_tables WHERE table_name = UPPER(p_name);
        ELSIF p_type = 'PROCEDURE' THEN
            SELECT COUNT(*) INTO v_actual_count FROM user_procedures
            WHERE object_name = UPPER(p_name) AND object_type = 'PROCEDURE';
        ELSIF p_type = 'FUNCTION' THEN
            SELECT COUNT(*) INTO v_actual_count FROM user_procedures
            WHERE object_name = UPPER(p_name) AND object_type = 'FUNCTION';
        ELSIF p_type = 'PACKAGE' THEN
            SELECT COUNT(*) INTO v_actual_count FROM user_objects
            WHERE object_name = UPPER(p_name) AND object_type = 'PACKAGE';
        ELSIF p_type = 'TRIGGER' THEN
            SELECT COUNT(*) INTO v_actual_count FROM user_triggers
            WHERE trigger_name = UPPER(p_name);
        ELSIF p_type = 'SEQUENCE' THEN
            SELECT COUNT(*) INTO v_actual_count FROM user_sequences
            WHERE sequence_name = UPPER(p_name);
        END IF;

        IF v_actual_count >= p_expected_count THEN
            v_status := '✓';
        ELSE
            v_status := '✗';
            v_total_errors := v_total_errors + 1;
        END IF;

        DBMS_OUTPUT.PUT_LINE('  ' || v_status || ' ' || RPAD(p_type, 12) ||
                           RPAD(p_name, 40) || ' (encontrado: ' || v_actual_count || ')');
    END;

    PROCEDURE check_data(p_table VARCHAR2, p_min_records NUMBER) IS
        v_actual_count NUMBER;
        v_status VARCHAR2(10);
    BEGIN
        v_total_checks := v_total_checks + 1;

        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || p_table INTO v_actual_count;

        IF v_actual_count >= p_min_records THEN
            v_status := '✓';
        ELSE
            v_status := '✗';
            v_total_errors := v_total_errors + 1;
        END IF;

        DBMS_OUTPUT.PUT_LINE('  ' || v_status || ' ' || RPAD(p_table, 30) ||
                           ' esperado: ' || RPAD(TO_CHAR(p_min_records) || '+', 8) ||
                           ' encontrado: ' || v_actual_count);
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('VALIDAÇÃO DA INSTALAÇÃO - PLATAFORMA DE CURSOS CORPORATIVA');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR TABELAS
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('1. VERIFICANDO TABELAS (16 esperadas)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_object('TABLE', 'EMPRESA', 1);
    check_object('TABLE', 'GERENTE', 1);
    check_object('TABLE', 'TIME', 1);
    check_object('TABLE', 'FUNCIONARIO', 1);
    check_object('TABLE', 'FUNCIONARIO_TIME', 1);
    check_object('TABLE', 'CATEGORIA_CURSO', 1);
    check_object('TABLE', 'CURSO', 1);
    check_object('TABLE', 'MODULO', 1);
    check_object('TABLE', 'MATRICULA', 1);
    check_object('TABLE', 'PROGRESSO', 1);
    check_object('TABLE', 'COMPETENCIA', 1);
    check_object('TABLE', 'FUNCIONARIO_COMPETENCIA', 1);
    check_object('TABLE', 'CERTIFICADO', 1);
    check_object('TABLE', 'COMPETICAO', 1);
    check_object('TABLE', 'PREMIO_COMPETICAO', 1);
    check_object('TABLE', 'AUDITORIA', 1);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR SEQUENCES
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('2. VERIFICANDO SEQUENCES (14 esperadas)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_object('SEQUENCE', 'SEQ_EMPRESA', 1);
    check_object('SEQUENCE', 'SEQ_GERENTE', 1);
    check_object('SEQUENCE', 'SEQ_FUNCIONARIO', 1);
    check_object('SEQUENCE', 'SEQ_TIME', 1);
    check_object('SEQUENCE', 'SEQ_CATEGORIA_CURSO', 1);
    check_object('SEQUENCE', 'SEQ_CURSO', 1);
    check_object('SEQUENCE', 'SEQ_MODULO', 1);
    check_object('SEQUENCE', 'SEQ_MATRICULA', 1);
    check_object('SEQUENCE', 'SEQ_PROGRESSO', 1);
    check_object('SEQUENCE', 'SEQ_COMPETENCIA', 1);
    check_object('SEQUENCE', 'SEQ_CERTIFICADO', 1);
    check_object('SEQUENCE', 'SEQ_COMPETICAO', 1);
    check_object('SEQUENCE', 'SEQ_PREMIO', 1);
    check_object('SEQUENCE', 'SEQ_AUDITORIA', 1);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR TRIGGERS
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('3. VERIFICANDO TRIGGERS DE AUDITORIA (10 esperados)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_object('TRIGGER', 'TRG_AUDIT_EMPRESA', 1);
    check_object('TRIGGER', 'TRG_AUDIT_GERENTE', 1);
    check_object('TRIGGER', 'TRG_AUDIT_FUNCIONARIO', 1);
    check_object('TRIGGER', 'TRG_AUDIT_TIME', 1);
    check_object('TRIGGER', 'TRG_AUDIT_CURSO', 1);
    check_object('TRIGGER', 'TRG_AUDIT_MATRICULA', 1);
    check_object('TRIGGER', 'TRG_AUDIT_PROGRESSO', 1);
    check_object('TRIGGER', 'TRG_AUDIT_CERTIFICADO', 1);
    check_object('TRIGGER', 'TRG_AUDIT_COMPETICAO', 1);
    check_object('TRIGGER', 'TRG_AUDIT_COMPETENCIA', 1);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR PROCEDURES
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('4. VERIFICANDO PROCEDURES (14 esperadas)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_object('PROCEDURE', 'SP_INSERIR_EMPRESA', 1);
    check_object('PROCEDURE', 'SP_INSERIR_GERENTE', 1);
    check_object('PROCEDURE', 'SP_INSERIR_FUNCIONARIO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_TIME', 1);
    check_object('PROCEDURE', 'SP_ADICIONAR_FUNCIONARIO_TIME', 1);
    check_object('PROCEDURE', 'SP_INSERIR_CATEGORIA_CURSO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_CURSO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_MODULO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_MATRICULA', 1);
    check_object('PROCEDURE', 'SP_INSERIR_PROGRESSO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_COMPETENCIA', 1);
    check_object('PROCEDURE', 'SP_ASSOCIAR_COMPETENCIA_FUNCIONARIO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_CERTIFICADO', 1);
    check_object('PROCEDURE', 'SP_INSERIR_COMPETICAO', 1);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR FUNÇÕES
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('5. VERIFICANDO FUNÇÕES (5+ esperadas)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_object('FUNCTION', 'FN_GERAR_PERFIL_FUNCIONARIO_JSON', 1);
    check_object('FUNCTION', 'FN_GERAR_CURSO_JSON', 1);
    check_object('FUNCTION', 'FN_CALCULAR_COMPATIBILIDADE_CURSO', 1);
    check_object('FUNCTION', 'FN_VALIDAR_DADOS_CADASTRAIS', 1);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR PACKAGES
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('6. VERIFICANDO PACKAGES (3 esperados)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_object('PACKAGE', 'PKG_GESTAO_USUARIOS', 1);
    check_object('PACKAGE', 'PKG_GESTAO_CURSOS', 1);
    check_object('PACKAGE', 'PKG_ANALYTICS', 1);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- VERIFICAR DADOS INSERIDOS
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('7. VERIFICANDO DADOS INSERIDOS (10+ registros por tabela)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    check_data('EMPRESA', 10);
    check_data('GERENTE', 10);
    check_data('TIME', 10);
    check_data('FUNCIONARIO', 10);
    check_data('FUNCIONARIO_TIME', 10);
    check_data('CATEGORIA_CURSO', 10);
    check_data('CURSO', 10);
    check_data('MODULO', 10);
    check_data('COMPETENCIA', 10);
    check_data('FUNCIONARIO_COMPETENCIA', 10);
    check_data('MATRICULA', 10);
    check_data('PROGRESSO', 10);
    check_data('CERTIFICADO', 5);
    check_data('COMPETICAO', 10);
    check_data('PREMIO_COMPETICAO', 10);
    check_data('AUDITORIA', 50);

    DBMS_OUTPUT.PUT_LINE('');

    -- ========================================
    -- RESUMO FINAL
    -- ========================================
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('RESUMO DA VALIDAÇÃO');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Total de verificações: ' || v_total_checks);
    DBMS_OUTPUT.PUT_LINE('Verificações com sucesso: ' || (v_total_checks - v_total_errors));
    DBMS_OUTPUT.PUT_LINE('Verificações com erro: ' || v_total_errors);
    DBMS_OUTPUT.PUT_LINE('');

    IF v_total_errors = 0 THEN
        DBMS_OUTPUT.PUT_LINE('✓✓✓ INSTALAÇÃO COMPLETA E VALIDADA COM SUCESSO! ✓✓✓');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Próximos passos:');
        DBMS_OUTPUT.PUT_LINE('  1. Teste as funções: SELECT fn_calcular_compatibilidade_curso(1, 1) FROM DUAL;');
        DBMS_OUTPUT.PUT_LINE('  2. Consulte os dados: SELECT * FROM funcionario ORDER BY pontos_acumulados DESC;');
        DBMS_OUTPUT.PUT_LINE('  3. Exporte para JSON: Execute sp_exportar_dataset_json');
        DBMS_OUTPUT.PUT_LINE('  4. Integre com sua aplicação Java/C#/Mobile');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗✗✗ INSTALAÇÃO INCOMPLETA - ' || v_total_errors || ' ERROS ENCONTRADOS ✗✗✗');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Ações recomendadas:');
        DBMS_OUTPUT.PUT_LINE('  1. Revise os scripts que falharam (marcados com ✗)');
        DBMS_OUTPUT.PUT_LINE('  2. Verifique os logs de erro do Oracle');
        DBMS_OUTPUT.PUT_LINE('  3. Execute os scripts na ordem correta (veja INSTALL.md)');
        DBMS_OUTPUT.PUT_LINE('  4. Verifique privilégios do usuário');
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('');

END;
/

-- ============================================================
-- ESTATÍSTICAS ADICIONAIS
-- ============================================================

PROMPT
PROMPT ============================================================
PROMPT ESTATÍSTICAS DO BANCO DE DADOS
PROMPT ============================================================
PROMPT

SELECT
    'Empresas' as categoria,
    COUNT(*) as total
FROM empresa
UNION ALL
SELECT 'Gerentes', COUNT(*) FROM gerente
UNION ALL
SELECT 'Times', COUNT(*) FROM time
UNION ALL
SELECT 'Funcionários', COUNT(*) FROM funcionario
UNION ALL
SELECT 'Cursos', COUNT(*) FROM curso
UNION ALL
SELECT 'Módulos', COUNT(*) FROM modulo
UNION ALL
SELECT 'Matrículas', COUNT(*) FROM matricula
UNION ALL
SELECT 'Certificados', COUNT(*) FROM certificado
UNION ALL
SELECT 'Competências', COUNT(*) FROM competencia
UNION ALL
SELECT 'Competições', COUNT(*) FROM competicao
UNION ALL
SELECT 'Registros de Auditoria', COUNT(*) FROM auditoria;

PROMPT
PROMPT ============================================================
PROMPT TOP 5 FUNCIONÁRIOS COM MAIS PONTOS
PROMPT ============================================================
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

PROMPT
PROMPT ============================================================
PROMPT CURSOS MAIS PROCURADOS
PROMPT ============================================================
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

PROMPT
PROMPT ============================================================
PROMPT FIM DA VALIDAÇÃO
PROMPT ============================================================
