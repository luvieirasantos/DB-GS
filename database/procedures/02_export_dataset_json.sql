-- ============================================================
-- PROCEDURE DE EXPORTAÇÃO DE DATASET COMPLETO PARA JSON
-- Para alimentar aplicações de IA ou integração com MongoDB
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_exportar_dataset_json (
    p_output OUT CLOB
) IS
    v_json CLOB := '';
    v_primeiro BOOLEAN;
    v_total_registros NUMBER := 0;

    -- Função auxiliar para escapar strings
    FUNCTION escape_json(p_str IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF p_str IS NULL THEN RETURN 'null'; END IF;
        RETURN '"' || REPLACE(REPLACE(REPLACE(p_str, '\', '\\'), '"', '\"'), CHR(10), '\n') || '"';
    END;

    -- Função auxiliar para formatar data
    FUNCTION format_date(p_date IN DATE) RETURN VARCHAR2 IS
    BEGIN
        IF p_date IS NULL THEN RETURN 'null'; END IF;
        RETURN '"' || TO_CHAR(p_date, 'YYYY-MM-DD"T"HH24:MI:SS') || '"';
    END;

    -- Função auxiliar para formatar número
    FUNCTION format_number(p_num IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF p_num IS NULL THEN RETURN 'null'; END IF;
        RETURN TO_CHAR(p_num);
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INICIANDO EXPORTAÇÃO DE DATASET ===');

    -- Iniciar JSON
    v_json := '{' || CHR(10);
    v_json := v_json || '  "dataset": "Plataforma de Cursos Corporativa - O Futuro do Trabalho",' || CHR(10);
    v_json := v_json || '  "versao": "1.0",' || CHR(10);
    v_json := v_json || '  "data_exportacao": ' || format_date(SYSDATE) || ',' || CHR(10);
    v_json := v_json || '  "proposito": "Dataset para treinamento de IA e analytics",' || CHR(10);

    -- ========================================
    -- EXPORTAR EMPRESAS
    -- ========================================
    v_json := v_json || '  "empresas": [' || CHR(10);
    v_primeiro := TRUE;
    v_total_registros := 0;

    FOR rec IN (SELECT * FROM empresa WHERE status = 'ATIVO' ORDER BY id_empresa) LOOP
        v_total_registros := v_total_registros + 1;
        IF NOT v_primeiro THEN v_json := v_json || ',' || CHR(10); END IF;

        v_json := v_json || '    {' || CHR(10);
        v_json := v_json || '      "id": ' || rec.id_empresa || ',' || CHR(10);
        v_json := v_json || '      "cnpj": ' || escape_json(rec.cnpj) || ',' || CHR(10);
        v_json := v_json || '      "razao_social": ' || escape_json(rec.razao_social) || ',' || CHR(10);
        v_json := v_json || '      "nome_fantasia": ' || escape_json(rec.nome_fantasia) || ',' || CHR(10);
        v_json := v_json || '      "email": ' || escape_json(rec.email_corporativo) || ',' || CHR(10);
        v_json := v_json || '      "data_cadastro": ' || format_date(rec.data_cadastro) || CHR(10);
        v_json := v_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || CHR(10) || '  ],' || CHR(10);
    DBMS_OUTPUT.PUT_LINE('Empresas exportadas: ' || v_total_registros);

    -- ========================================
    -- EXPORTAR FUNCIONÁRIOS COM DETALHES
    -- ========================================
    v_json := v_json || '  "funcionarios": [' || CHR(10);
    v_primeiro := TRUE;
    v_total_registros := 0;

    FOR rec IN (
        SELECT
            f.id_funcionario,
            f.nome,
            f.email,
            f.cargo,
            f.nivel_atual,
            f.pontos_acumulados,
            f.status,
            e.nome_fantasia as empresa_nome,
            (SELECT COUNT(*) FROM matricula m WHERE m.id_funcionario = f.id_funcionario AND m.status = 'CONCLUIDO') as cursos_concluidos,
            (SELECT COUNT(*) FROM funcionario_competencia fc WHERE fc.id_funcionario = f.id_funcionario) as total_competencias
        FROM funcionario f
        INNER JOIN empresa e ON f.id_empresa = e.id_empresa
        WHERE f.status = 'ATIVO'
        ORDER BY f.id_funcionario
    ) LOOP
        v_total_registros := v_total_registros + 1;
        IF NOT v_primeiro THEN v_json := v_json || ',' || CHR(10); END IF;

        v_json := v_json || '    {' || CHR(10);
        v_json := v_json || '      "id": ' || rec.id_funcionario || ',' || CHR(10);
        v_json := v_json || '      "nome": ' || escape_json(rec.nome) || ',' || CHR(10);
        v_json := v_json || '      "email": ' || escape_json(rec.email) || ',' || CHR(10);
        v_json := v_json || '      "cargo": ' || escape_json(rec.cargo) || ',' || CHR(10);
        v_json := v_json || '      "nivel_atual": ' || escape_json(rec.nivel_atual) || ',' || CHR(10);
        v_json := v_json || '      "pontos_acumulados": ' || rec.pontos_acumulados || ',' || CHR(10);
        v_json := v_json || '      "empresa": ' || escape_json(rec.empresa_nome) || ',' || CHR(10);
        v_json := v_json || '      "cursos_concluidos": ' || rec.cursos_concluidos || ',' || CHR(10);
        v_json := v_json || '      "total_competencias": ' || rec.total_competencias || CHR(10);
        v_json := v_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || CHR(10) || '  ],' || CHR(10);
    DBMS_OUTPUT.PUT_LINE('Funcionários exportados: ' || v_total_registros);

    -- ========================================
    -- EXPORTAR CURSOS
    -- ========================================
    v_json := v_json || '  "cursos": [' || CHR(10);
    v_primeiro := TRUE;
    v_total_registros := 0;

    FOR rec IN (
        SELECT
            c.id_curso,
            c.nome_curso,
            c.descricao,
            c.carga_horaria,
            c.nivel_dificuldade,
            c.pontos_conclusao,
            cat.nome_categoria,
            (SELECT COUNT(*) FROM modulo m WHERE m.id_curso = c.id_curso) as total_modulos,
            (SELECT COUNT(*) FROM matricula m WHERE m.id_curso = c.id_curso) as total_matriculas
        FROM curso c
        INNER JOIN categoria_curso cat ON c.id_categoria = cat.id_categoria
        WHERE c.status = 'ATIVO'
        ORDER BY c.id_curso
    ) LOOP
        v_total_registros := v_total_registros + 1;
        IF NOT v_primeiro THEN v_json := v_json || ',' || CHR(10); END IF;

        v_json := v_json || '    {' || CHR(10);
        v_json := v_json || '      "id": ' || rec.id_curso || ',' || CHR(10);
        v_json := v_json || '      "nome": ' || escape_json(rec.nome_curso) || ',' || CHR(10);
        v_json := v_json || '      "descricao": ' || escape_json(rec.descricao) || ',' || CHR(10);
        v_json := v_json || '      "categoria": ' || escape_json(rec.nome_categoria) || ',' || CHR(10);
        v_json := v_json || '      "carga_horaria": ' || rec.carga_horaria || ',' || CHR(10);
        v_json := v_json || '      "nivel": ' || escape_json(rec.nivel_dificuldade) || ',' || CHR(10);
        v_json := v_json || '      "pontos": ' || rec.pontos_conclusao || ',' || CHR(10);
        v_json := v_json || '      "total_modulos": ' || rec.total_modulos || ',' || CHR(10);
        v_json := v_json || '      "total_matriculas": ' || rec.total_matriculas || CHR(10);
        v_json := v_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || CHR(10) || '  ],' || CHR(10);
    DBMS_OUTPUT.PUT_LINE('Cursos exportados: ' || v_total_registros);

    -- ========================================
    -- EXPORTAR COMPETÊNCIAS
    -- ========================================
    v_json := v_json || '  "competencias": [' || CHR(10);
    v_primeiro := TRUE;
    v_total_registros := 0;

    FOR rec IN (
        SELECT
            c.id_competencia,
            c.nome_competencia,
            c.descricao,
            c.categoria,
            c.nivel_mercado,
            (SELECT COUNT(*) FROM funcionario_competencia fc WHERE fc.id_competencia = c.id_competencia) as total_funcionarios
        FROM competencia c
        WHERE c.status = 'ATIVO'
        ORDER BY c.id_competencia
    ) LOOP
        v_total_registros := v_total_registros + 1;
        IF NOT v_primeiro THEN v_json := v_json || ',' || CHR(10); END IF;

        v_json := v_json || '    {' || CHR(10);
        v_json := v_json || '      "id": ' || rec.id_competencia || ',' || CHR(10);
        v_json := v_json || '      "nome": ' || escape_json(rec.nome_competencia) || ',' || CHR(10);
        v_json := v_json || '      "descricao": ' || escape_json(rec.descricao) || ',' || CHR(10);
        v_json := v_json || '      "categoria": ' || escape_json(rec.categoria) || ',' || CHR(10);
        v_json := v_json || '      "nivel_mercado": ' || escape_json(rec.nivel_mercado) || ',' || CHR(10);
        v_json := v_json || '      "total_funcionarios_com_competencia": ' || rec.total_funcionarios || CHR(10);
        v_json := v_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || CHR(10) || '  ],' || CHR(10);
    DBMS_OUTPUT.PUT_LINE('Competências exportadas: ' || v_total_registros);

    -- ========================================
    -- EXPORTAR MATRÍCULAS E PERFORMANCE
    -- ========================================
    v_json := v_json || '  "matriculas": [' || CHR(10);
    v_primeiro := TRUE;
    v_total_registros := 0;

    FOR rec IN (
        SELECT
            m.id_matricula,
            f.nome as funcionario_nome,
            c.nome_curso,
            m.data_matricula,
            m.data_conclusao,
            m.status,
            m.percentual_conclusao,
            m.nota_final,
            (SELECT COUNT(*) FROM progresso p WHERE p.id_matricula = m.id_matricula AND p.status = 'CONCLUIDO') as modulos_concluidos
        FROM matricula m
        INNER JOIN funcionario f ON m.id_funcionario = f.id_funcionario
        INNER JOIN curso c ON m.id_curso = c.id_curso
        ORDER BY m.id_matricula
    ) LOOP
        v_total_registros := v_total_registros + 1;
        IF NOT v_primeiro THEN v_json := v_json || ',' || CHR(10); END IF;

        v_json := v_json || '    {' || CHR(10);
        v_json := v_json || '      "id": ' || rec.id_matricula || ',' || CHR(10);
        v_json := v_json || '      "funcionario": ' || escape_json(rec.funcionario_nome) || ',' || CHR(10);
        v_json := v_json || '      "curso": ' || escape_json(rec.nome_curso) || ',' || CHR(10);
        v_json := v_json || '      "data_matricula": ' || format_date(rec.data_matricula) || ',' || CHR(10);
        v_json := v_json || '      "data_conclusao": ' || format_date(rec.data_conclusao) || ',' || CHR(10);
        v_json := v_json || '      "status": ' || escape_json(rec.status) || ',' || CHR(10);
        v_json := v_json || '      "percentual_conclusao": ' || format_number(rec.percentual_conclusao) || ',' || CHR(10);
        v_json := v_json || '      "nota_final": ' || format_number(rec.nota_final) || ',' || CHR(10);
        v_json := v_json || '      "modulos_concluidos": ' || rec.modulos_concluidos || CHR(10);
        v_json := v_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || CHR(10) || '  ],' || CHR(10);
    DBMS_OUTPUT.PUT_LINE('Matrículas exportadas: ' || v_total_registros);

    -- ========================================
    -- EXPORTAR CERTIFICADOS
    -- ========================================
    v_json := v_json || '  "certificados": [' || CHR(10);
    v_primeiro := TRUE;
    v_total_registros := 0;

    FOR rec IN (
        SELECT
            cert.id_certificado,
            cert.codigo_certificado,
            f.nome as funcionario_nome,
            c.nome_curso,
            cert.data_emissao,
            cert.nota_final,
            cert.carga_horaria
        FROM certificado cert
        INNER JOIN matricula m ON cert.id_matricula = m.id_matricula
        INNER JOIN funcionario f ON m.id_funcionario = f.id_funcionario
        INNER JOIN curso c ON m.id_curso = c.id_curso
        WHERE cert.status = 'ATIVO'
        ORDER BY cert.id_certificado
    ) LOOP
        v_total_registros := v_total_registros + 1;
        IF NOT v_primeiro THEN v_json := v_json || ',' || CHR(10); END IF;

        v_json := v_json || '    {' || CHR(10);
        v_json := v_json || '      "codigo": ' || escape_json(rec.codigo_certificado) || ',' || CHR(10);
        v_json := v_json || '      "funcionario": ' || escape_json(rec.funcionario_nome) || ',' || CHR(10);
        v_json := v_json || '      "curso": ' || escape_json(rec.nome_curso) || ',' || CHR(10);
        v_json := v_json || '      "data_emissao": ' || format_date(rec.data_emissao) || ',' || CHR(10);
        v_json := v_json || '      "nota_final": ' || rec.nota_final || ',' || CHR(10);
        v_json := v_json || '      "carga_horaria": ' || rec.carga_horaria || CHR(10);
        v_json := v_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || CHR(10) || '  ],' || CHR(10);
    DBMS_OUTPUT.PUT_LINE('Certificados exportados: ' || v_total_registros);

    -- ========================================
    -- EXPORTAR ESTATÍSTICAS GERAIS
    -- ========================================
    v_json := v_json || '  "estatisticas": {' || CHR(10);

    FOR rec IN (
        SELECT
            (SELECT COUNT(*) FROM empresa WHERE status = 'ATIVO') as total_empresas,
            (SELECT COUNT(*) FROM funcionario WHERE status = 'ATIVO') as total_funcionarios,
            (SELECT COUNT(*) FROM curso WHERE status = 'ATIVO') as total_cursos,
            (SELECT COUNT(*) FROM matricula) as total_matriculas,
            (SELECT COUNT(*) FROM matricula WHERE status = 'CONCLUIDO') as matriculas_concluidas,
            (SELECT COUNT(*) FROM certificado WHERE status = 'ATIVO') as certificados_emitidos,
            (SELECT COUNT(*) FROM competencia WHERE status = 'ATIVO') as total_competencias,
            (SELECT AVG(nota_final) FROM matricula WHERE nota_final IS NOT NULL) as media_notas,
            (SELECT AVG(pontos_acumulados) FROM funcionario WHERE status = 'ATIVO') as media_pontos
        FROM DUAL
    ) LOOP
        v_json := v_json || '    "total_empresas": ' || rec.total_empresas || ',' || CHR(10);
        v_json := v_json || '    "total_funcionarios": ' || rec.total_funcionarios || ',' || CHR(10);
        v_json := v_json || '    "total_cursos": ' || rec.total_cursos || ',' || CHR(10);
        v_json := v_json || '    "total_matriculas": ' || rec.total_matriculas || ',' || CHR(10);
        v_json := v_json || '    "matriculas_concluidas": ' || rec.matriculas_concluidas || ',' || CHR(10);
        v_json := v_json || '    "certificados_emitidos": ' || rec.certificados_emitidos || ',' || CHR(10);
        v_json := v_json || '    "total_competencias": ' || rec.total_competencias || ',' || CHR(10);
        v_json := v_json || '    "media_notas": ' || ROUND(rec.media_notas, 2) || ',' || CHR(10);
        v_json := v_json || '    "media_pontos_funcionarios": ' || ROUND(rec.media_pontos, 2) || CHR(10);
    END LOOP;

    v_json := v_json || '  }' || CHR(10);

    -- Fechar JSON
    v_json := v_json || '}';

    -- Retornar resultado
    p_output := v_json;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== EXPORTAÇÃO CONCLUÍDA ===');
    DBMS_OUTPUT.PUT_LINE('Tamanho do JSON: ' || LENGTH(v_json) || ' caracteres');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO na exportação: ' || SQLERRM);
        RAISE;
END sp_exportar_dataset_json;
/

-- ============================================================
-- SCRIPT PARA EXECUTAR E SALVAR O JSON
-- ============================================================

-- Exemplo de uso:
/*
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LONG 100000000;
SET LONGCHUNKSIZE 100000000;
SET LINESIZE 32767;
SET PAGESIZE 0;
SET FEEDBACK OFF;
SET HEADING OFF;

SPOOL C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\mongodb\dataset_export.json

DECLARE
    v_json CLOB;
BEGIN
    sp_exportar_dataset_json(v_json);
    DBMS_OUTPUT.PUT_LINE(v_json);
END;
/

SPOOL OFF;
*/

COMMIT;

-- ============================================================
-- FIM DA PROCEDURE DE EXPORTAÇÃO
-- ============================================================
