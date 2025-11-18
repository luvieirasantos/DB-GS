-- ============================================================
-- PACKAGE: PKG_ANALYTICS
-- Agrupa funções de análise, validação e exportação
-- ============================================================

-- ============================================================
-- ESPECIFICAÇÃO DO PACKAGE
-- ============================================================
CREATE OR REPLACE PACKAGE pkg_analytics AS
    -- Funções de Análise e Compatibilidade
    FUNCTION calcular_compatibilidade_curso (
        p_id_funcionario IN NUMBER,
        p_id_curso IN NUMBER,
        p_email_validacao IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    FUNCTION gerar_perfil_funcionario_json (
        p_id_funcionario IN NUMBER
    ) RETURN CLOB;

    FUNCTION validar_dados_cadastrais (
        p_tipo IN VARCHAR2,
        p_valor IN VARCHAR2
    ) RETURN VARCHAR2;

    -- Funções de Métricas
    FUNCTION calcular_taxa_conclusao_funcionario (
        p_id_funcionario IN NUMBER
    ) RETURN NUMBER;

    FUNCTION obter_ranking_pontos_empresa (
        p_id_empresa IN NUMBER,
        p_limite IN NUMBER DEFAULT 10
    ) RETURN CLOB;

    FUNCTION obter_competencias_mais_procuradas RETURN CLOB;

END pkg_analytics;
/

-- ============================================================
-- CORPO DO PACKAGE
-- ============================================================
CREATE OR REPLACE PACKAGE BODY pkg_analytics AS

    -- Implementação: Calcular Compatibilidade
    FUNCTION calcular_compatibilidade_curso (
        p_id_funcionario IN NUMBER,
        p_id_curso IN NUMBER,
        p_email_validacao IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS
    BEGIN
        RETURN fn_calcular_compatibilidade_curso(p_id_funcionario, p_id_curso, p_email_validacao);
    END calcular_compatibilidade_curso;

    -- Implementação: Gerar Perfil JSON
    FUNCTION gerar_perfil_funcionario_json (
        p_id_funcionario IN NUMBER
    ) RETURN CLOB IS
    BEGIN
        RETURN fn_gerar_perfil_funcionario_json(p_id_funcionario);
    END gerar_perfil_funcionario_json;

    -- Implementação: Validar Dados Cadastrais
    FUNCTION validar_dados_cadastrais (
        p_tipo IN VARCHAR2,
        p_valor IN VARCHAR2
    ) RETURN VARCHAR2 IS
    BEGIN
        RETURN fn_validar_dados_cadastrais(p_tipo, p_valor);
    END validar_dados_cadastrais;

    -- Implementação: Calcular Taxa de Conclusão
    FUNCTION calcular_taxa_conclusao_funcionario (
        p_id_funcionario IN NUMBER
    ) RETURN NUMBER IS
        v_total_matriculas NUMBER;
        v_total_concluidos NUMBER;
        v_taxa NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total_matriculas
        FROM matricula
        WHERE id_funcionario = p_id_funcionario;

        IF v_total_matriculas = 0 THEN
            RETURN 0;
        END IF;

        SELECT COUNT(*)
        INTO v_total_concluidos
        FROM matricula
        WHERE id_funcionario = p_id_funcionario
          AND status = 'CONCLUIDO';

        v_taxa := ROUND((v_total_concluidos / v_total_matriculas) * 100, 2);

        RETURN v_taxa;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calcular_taxa_conclusao_funcionario;

    -- Implementação: Obter Ranking de Pontos
    FUNCTION obter_ranking_pontos_empresa (
        p_id_empresa IN NUMBER,
        p_limite IN NUMBER DEFAULT 10
    ) RETURN CLOB IS
        v_json CLOB := '';
        v_primeiro BOOLEAN := TRUE;
        v_counter NUMBER := 0;

        CURSOR cur_ranking IS
            SELECT
                nome,
                cargo,
                nivel_atual,
                pontos_acumulados
            FROM funcionario
            WHERE id_empresa = p_id_empresa
              AND status = 'ATIVO'
            ORDER BY pontos_acumulados DESC
            FETCH FIRST p_limite ROWS ONLY;

        FUNCTION escape_str(p_str IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            IF p_str IS NULL THEN RETURN 'null'; END IF;
            RETURN '"' || REPLACE(REPLACE(p_str, '\', '\\'), '"', '\"') || '"';
        END;

    BEGIN
        v_json := '{' || CHR(10);
        v_json := v_json || '  "empresa_id": ' || p_id_empresa || ',' || CHR(10);
        v_json := v_json || '  "ranking": [' || CHR(10);

        FOR rec IN cur_ranking LOOP
            v_counter := v_counter + 1;

            IF NOT v_primeiro THEN
                v_json := v_json || ',' || CHR(10);
            END IF;

            v_json := v_json || '    {' || CHR(10);
            v_json := v_json || '      "posicao": ' || v_counter || ',' || CHR(10);
            v_json := v_json || '      "nome": ' || escape_str(rec.nome) || ',' || CHR(10);
            v_json := v_json || '      "cargo": ' || escape_str(rec.cargo) || ',' || CHR(10);
            v_json := v_json || '      "nivel": ' || escape_str(rec.nivel_atual) || ',' || CHR(10);
            v_json := v_json || '      "pontos": ' || rec.pontos_acumulados || CHR(10);
            v_json := v_json || '    }';

            v_primeiro := FALSE;
        END LOOP;

        v_json := v_json || CHR(10) || '  ],' || CHR(10);
        v_json := v_json || '  "total": ' || v_counter || CHR(10);
        v_json := v_json || '}';

        RETURN v_json;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '{"erro": "' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END obter_ranking_pontos_empresa;

    -- Implementação: Competências Mais Procuradas
    FUNCTION obter_competencias_mais_procuradas RETURN CLOB IS
        v_json CLOB := '';
        v_primeiro BOOLEAN := TRUE;

        CURSOR cur_competencias IS
            SELECT
                c.nome_competencia,
                c.categoria,
                c.nivel_mercado,
                COUNT(fc.id_funcionario) as total_funcionarios
            FROM competencia c
            LEFT JOIN funcionario_competencia fc ON c.id_competencia = fc.id_competencia
            WHERE c.status = 'ATIVO'
            GROUP BY c.nome_competencia, c.categoria, c.nivel_mercado
            ORDER BY total_funcionarios DESC, c.nome_competencia
            FETCH FIRST 15 ROWS ONLY;

        FUNCTION escape_str(p_str IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            IF p_str IS NULL THEN RETURN 'null'; END IF;
            RETURN '"' || REPLACE(REPLACE(p_str, '\', '\\'), '"', '\"') || '"';
        END;

    BEGIN
        v_json := '{' || CHR(10);
        v_json := v_json || '  "competencias_mais_procuradas": [' || CHR(10);

        FOR rec IN cur_competencias LOOP
            IF NOT v_primeiro THEN
                v_json := v_json || ',' || CHR(10);
            END IF;

            v_json := v_json || '    {' || CHR(10);
            v_json := v_json || '      "competencia": ' || escape_str(rec.nome_competencia) || ',' || CHR(10);
            v_json := v_json || '      "categoria": ' || escape_str(rec.categoria) || ',' || CHR(10);
            v_json := v_json || '      "nivel_mercado": ' || escape_str(rec.nivel_mercado) || ',' || CHR(10);
            v_json := v_json || '      "total_funcionarios": ' || rec.total_funcionarios || CHR(10);
            v_json := v_json || '    }';

            v_primeiro := FALSE;
        END LOOP;

        v_json := v_json || CHR(10) || '  ]' || CHR(10);
        v_json := v_json || '}';

        RETURN v_json;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '{"erro": "' || REPLACE(SQLERRM, '"', '\"') || '"}';
    END obter_competencias_mais_procuradas;

END pkg_analytics;
/

COMMIT;

-- ============================================================
-- FIM DO PACKAGE PKG_ANALYTICS
-- ============================================================
