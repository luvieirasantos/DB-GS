-- ============================================================
-- FUNÇÃO 2: VALIDAÇÃO E CÁLCULO COM EXPRESSÕES REGULARES
-- Calcula compatibilidade entre funcionário e curso
-- Valida dados usando REGEXP e retorna análise completa
-- ============================================================

CREATE OR REPLACE FUNCTION fn_calcular_compatibilidade_curso (
    p_id_funcionario IN NUMBER,
    p_id_curso IN NUMBER,
    p_email_validacao IN VARCHAR2 DEFAULT NULL
) RETURN VARCHAR2
IS
    -- Variáveis para dados do funcionário
    v_nivel_funcionario funcionario.nivel_atual%TYPE;
    v_email_funcionario funcionario.email%TYPE;
    v_pontos_funcionario funcionario.pontos_acumulados%TYPE;
    v_qtd_cursos_concluidos NUMBER := 0;

    -- Variáveis para dados do curso
    v_nivel_curso curso.nivel_dificuldade%TYPE;
    v_nome_curso curso.nome_curso%TYPE;
    v_carga_horaria curso.carga_horaria%TYPE;

    -- Variáveis para cálculo
    v_score_nivel NUMBER := 0;
    v_score_experiencia NUMBER := 0;
    v_score_competencias NUMBER := 0;
    v_score_final NUMBER := 0;
    v_percentual_compatibilidade NUMBER := 0;
    v_recomendacao VARCHAR2(500);
    v_motivo VARCHAR2(1000);

    -- Contadores
    v_total_competencias_curso NUMBER := 0;
    v_competencias_atendidas NUMBER := 0;

    -- Exceções personalizadas
    ex_email_invalido EXCEPTION;
    ex_funcionario_nao_encontrado EXCEPTION;
    ex_curso_nao_encontrado EXCEPTION;
    ex_parametros_invalidos EXCEPTION;

    -- Função auxiliar para validar CPF usando REGEXP
    FUNCTION validar_cpf(p_cpf IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Validar formato XXX.XXX.XXX-XX
        IF NOT REGEXP_LIKE(p_cpf, '^\d{3}\.\d{3}\.\d{3}-\d{2}$') THEN
            RETURN FALSE;
        END IF;

        -- Validar se não são todos números iguais
        IF REGEXP_LIKE(p_cpf, '^(\d)\1{2}\.(\d)\2{2}\.(\d)\3{2}-(\d)\4{1}$') THEN
            RETURN FALSE;
        END IF;

        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END validar_cpf;

    -- Função auxiliar para validar email corporativo usando REGEXP
    FUNCTION validar_email_corporativo(p_email IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Validar formato básico de email
        IF NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            DBMS_OUTPUT.PUT_LINE('Email com formato inválido: ' || p_email);
            RETURN FALSE;
        END IF;

        -- Validar se é email corporativo (não pode ser gmail, hotmail, yahoo, outlook)
        IF REGEXP_LIKE(p_email, '@(gmail|hotmail|yahoo|outlook)\.(com|com\.br)$', 'i') THEN
            DBMS_OUTPUT.PUT_LINE('Email não é corporativo: ' || p_email);
            RETURN FALSE;
        END IF;

        -- Validar se domínio tem formato corporativo (pelo menos 3 caracteres antes do .com)
        IF NOT REGEXP_LIKE(p_email, '@[A-Za-z0-9-]{3,}\.(com|com\.br|net|org|edu|br)$', 'i') THEN
            DBMS_OUTPUT.PUT_LINE('Domínio corporativo inválido: ' || p_email);
            RETURN FALSE;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Email corporativo válido: ' || p_email);
        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao validar email: ' || SQLERRM);
            RETURN FALSE;
    END validar_email_corporativo;

    -- Função auxiliar para validar código de curso usando REGEXP
    FUNCTION validar_codigo_curso(p_codigo IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        -- Código deve ser: CUR-XXXX onde X é dígito
        RETURN REGEXP_LIKE(p_codigo, '^CUR-\d{4}$');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END validar_codigo_curso;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INICIANDO CÁLCULO DE COMPATIBILIDADE ===');
    DBMS_OUTPUT.PUT_LINE('Funcionário ID: ' || p_id_funcionario || ' | Curso ID: ' || p_id_curso);

    -- VALIDAÇÃO 1: Parâmetros obrigatórios
    IF p_id_funcionario IS NULL OR p_id_curso IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: Parâmetros inválidos - IDs não podem ser nulos');
        RAISE ex_parametros_invalidos;
    END IF;

    IF p_id_funcionario <= 0 OR p_id_curso <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: Parâmetros inválidos - IDs devem ser maiores que zero');
        RAISE ex_parametros_invalidos;
    END IF;

    -- Buscar dados do funcionário
    BEGIN
        SELECT
            nivel_atual,
            email,
            pontos_acumulados
        INTO
            v_nivel_funcionario,
            v_email_funcionario,
            v_pontos_funcionario
        FROM funcionario
        WHERE id_funcionario = p_id_funcionario
          AND status = 'ATIVO';

        DBMS_OUTPUT.PUT_LINE('Funcionário encontrado: Nível ' || v_nivel_funcionario ||
                           ', Pontos: ' || v_pontos_funcionario);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- EXCEÇÃO 1: Funcionário não encontrado
            DBMS_OUTPUT.PUT_LINE('ERRO: Funcionário com ID ' || p_id_funcionario || ' não encontrado ou inativo');
            RAISE ex_funcionario_nao_encontrado;
    END;

    -- VALIDAÇÃO 2: Email corporativo usando REGEXP
    IF p_email_validacao IS NOT NULL THEN
        IF NOT validar_email_corporativo(p_email_validacao) THEN
            DBMS_OUTPUT.PUT_LINE('ERRO: Email fornecido não é um email corporativo válido');
            RAISE ex_email_invalido;
        END IF;

        -- Verificar se email corresponde ao funcionário
        IF UPPER(v_email_funcionario) != UPPER(p_email_validacao) THEN
            DBMS_OUTPUT.PUT_LINE('AVISO: Email fornecido não corresponde ao cadastrado');
        END IF;
    ELSE
        -- Validar email cadastrado
        IF NOT validar_email_corporativo(v_email_funcionario) THEN
            DBMS_OUTPUT.PUT_LINE('AVISO: Email cadastrado não é corporativo válido: ' || v_email_funcionario);
        END IF;
    END IF;

    -- Buscar dados do curso
    BEGIN
        SELECT
            nivel_dificuldade,
            nome_curso,
            carga_horaria
        INTO
            v_nivel_curso,
            v_nome_curso,
            v_carga_horaria
        FROM curso
        WHERE id_curso = p_id_curso
          AND status = 'ATIVO';

        DBMS_OUTPUT.PUT_LINE('Curso encontrado: ' || v_nome_curso || ' - Nível ' || v_nivel_curso);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- EXCEÇÃO 2: Curso não encontrado
            DBMS_OUTPUT.PUT_LINE('ERRO: Curso com ID ' || p_id_curso || ' não encontrado ou inativo');
            RAISE ex_curso_nao_encontrado;
    END;

    -- CÁLCULO 1: Score de compatibilidade de nível (peso 40%)
    DBMS_OUTPUT.PUT_LINE('--- Calculando Score de Nível ---');

    IF v_nivel_funcionario = 'INICIANTE' THEN
        IF v_nivel_curso = 'INICIANTE' THEN
            v_score_nivel := 40;
            DBMS_OUTPUT.PUT_LINE('Funcionário INICIANTE - Curso INICIANTE: +40 pontos (match perfeito)');
        ELSIF v_nivel_curso = 'INTERMEDIARIO' THEN
            v_score_nivel := 20;
            DBMS_OUTPUT.PUT_LINE('Funcionário INICIANTE - Curso INTERMEDIARIO: +20 pontos (desafio moderado)');
        ELSE
            v_score_nivel := 5;
            DBMS_OUTPUT.PUT_LINE('Funcionário INICIANTE - Curso AVANCADO: +5 pontos (muito difícil)');
        END IF;

    ELSIF v_nivel_funcionario = 'INTERMEDIARIO' THEN
        IF v_nivel_curso = 'INICIANTE' THEN
            v_score_nivel := 25;
            DBMS_OUTPUT.PUT_LINE('Funcionário INTERMEDIARIO - Curso INICIANTE: +25 pontos (pode ser fácil)');
        ELSIF v_nivel_curso = 'INTERMEDIARIO' THEN
            v_score_nivel := 40;
            DBMS_OUTPUT.PUT_LINE('Funcionário INTERMEDIARIO - Curso INTERMEDIARIO: +40 pontos (match perfeito)');
        ELSE
            v_score_nivel := 30;
            DBMS_OUTPUT.PUT_LINE('Funcionário INTERMEDIARIO - Curso AVANCADO: +30 pontos (desafio bom)');
        END IF;

    ELSIF v_nivel_funcionario = 'AVANCADO' THEN
        IF v_nivel_curso = 'INICIANTE' THEN
            v_score_nivel := 15;
            DBMS_OUTPUT.PUT_LINE('Funcionário AVANCADO - Curso INICIANTE: +15 pontos (muito fácil)');
        ELSIF v_nivel_curso = 'INTERMEDIARIO' THEN
            v_score_nivel := 30;
            DBMS_OUTPUT.PUT_LINE('Funcionário AVANCADO - Curso INTERMEDIARIO: +30 pontos (pode ser fácil)');
        ELSE
            v_score_nivel := 40;
            DBMS_OUTPUT.PUT_LINE('Funcionário AVANCADO - Curso AVANCADO: +40 pontos (match perfeito)');
        END IF;

    ELSIF v_nivel_funcionario = 'EXPERT' THEN
        IF v_nivel_curso = 'AVANCADO' THEN
            v_score_nivel := 35;
            DBMS_OUTPUT.PUT_LINE('Funcionário EXPERT - Curso AVANCADO: +35 pontos (bom para atualização)');
        ELSE
            v_score_nivel := 20;
            DBMS_OUTPUT.PUT_LINE('Funcionário EXPERT - Curso básico: +20 pontos (abaixo do nível)');
        END IF;
    END IF;

    -- CÁLCULO 2: Score de experiência baseado em cursos concluídos (peso 30%)
    DBMS_OUTPUT.PUT_LINE('--- Calculando Score de Experiência ---');

    SELECT COUNT(*)
    INTO v_qtd_cursos_concluidos
    FROM matricula
    WHERE id_funcionario = p_id_funcionario
      AND status = 'CONCLUIDO';

    DBMS_OUTPUT.PUT_LINE('Cursos concluídos: ' || v_qtd_cursos_concluidos);

    IF v_qtd_cursos_concluidos = 0 THEN
        v_score_experiencia := 30; -- Primeiro curso, score máximo
        DBMS_OUTPUT.PUT_LINE('Primeiro curso: +30 pontos (incentivo iniciante)');
    ELSIF v_qtd_cursos_concluidos BETWEEN 1 AND 3 THEN
        v_score_experiencia := 25;
        DBMS_OUTPUT.PUT_LINE('1-3 cursos concluídos: +25 pontos');
    ELSIF v_qtd_cursos_concluidos BETWEEN 4 AND 7 THEN
        v_score_experiencia := 28;
        DBMS_OUTPUT.PUT_LINE('4-7 cursos concluídos: +28 pontos (experiência moderada)');
    ELSE
        v_score_experiencia := 30;
        DBMS_OUTPUT.PUT_LINE('8+ cursos concluídos: +30 pontos (experiência alta)');
    END IF;

    -- Bonus por pontos acumulados
    IF v_pontos_funcionario >= 1000 THEN
        v_score_experiencia := LEAST(v_score_experiencia + 5, 30);
        DBMS_OUTPUT.PUT_LINE('Bonus pontos 1000+: +5 pontos extras');
    END IF;

    -- CÁLCULO 3: Score de competências (peso 30%)
    DBMS_OUTPUT.PUT_LINE('--- Calculando Score de Competências ---');

    -- Contar competências do curso (via cursos similares ou categoria)
    SELECT COUNT(DISTINCT fc.id_competencia)
    INTO v_competencias_atendidas
    FROM funcionario_competencia fc
    WHERE fc.id_funcionario = p_id_funcionario
      AND EXISTS (
          SELECT 1
          FROM competencia c
          WHERE c.id_competencia = fc.id_competencia
            AND c.status = 'ATIVO'
            AND c.nivel_mercado = 'EM_ALTA'
      );

    DBMS_OUTPUT.PUT_LINE('Competências em alta do funcionário: ' || v_competencias_atendidas);

    -- Score baseado em competências
    IF v_competencias_atendidas = 0 THEN
        v_score_competencias := 10;
        DBMS_OUTPUT.PUT_LINE('Sem competências: +10 pontos (precisa desenvolver)');
    ELSIF v_competencias_atendidas BETWEEN 1 AND 2 THEN
        v_score_competencias := 20;
        DBMS_OUTPUT.PUT_LINE('1-2 competências: +20 pontos');
    ELSIF v_competencias_atendidas BETWEEN 3 AND 5 THEN
        v_score_competencias := 28;
        DBMS_OUTPUT.PUT_LINE('3-5 competências: +28 pontos (bom repertório)');
    ELSE
        v_score_competencias := 30;
        DBMS_OUTPUT.PUT_LINE('6+ competências: +30 pontos (excelente repertório)');
    END IF;

    -- CÁLCULO FINAL
    v_score_final := v_score_nivel + v_score_experiencia + v_score_competencias;
    v_percentual_compatibilidade := ROUND((v_score_final / 100) * 100, 2);

    DBMS_OUTPUT.PUT_LINE('--- RESULTADO FINAL ---');
    DBMS_OUTPUT.PUT_LINE('Score Nível: ' || v_score_nivel || '/40');
    DBMS_OUTPUT.PUT_LINE('Score Experiência: ' || v_score_experiencia || '/30');
    DBMS_OUTPUT.PUT_LINE('Score Competências: ' || v_score_competencias || '/30');
    DBMS_OUTPUT.PUT_LINE('Score Total: ' || v_score_final || '/100');
    DBMS_OUTPUT.PUT_LINE('Compatibilidade: ' || v_percentual_compatibilidade || '%');

    -- Gerar recomendação
    IF v_percentual_compatibilidade >= 85 THEN
        v_recomendacao := 'ALTAMENTE RECOMENDADO';
        v_motivo := 'Excelente compatibilidade entre perfil do funcionário e requisitos do curso. Grande chance de sucesso.';
    ELSIF v_percentual_compatibilidade >= 70 THEN
        v_recomendacao := 'RECOMENDADO';
        v_motivo := 'Boa compatibilidade. O funcionário possui base adequada para o curso.';
    ELSIF v_percentual_compatibilidade >= 50 THEN
        v_recomendacao := 'PARCIALMENTE RECOMENDADO';
        v_motivo := 'Compatibilidade moderada. Funcionário pode enfrentar desafios, mas consegue concluir com esforço.';
    ELSE
        v_recomendacao := 'NAO RECOMENDADO';
        v_motivo := 'Baixa compatibilidade. Recomenda-se fazer cursos preparatórios antes.';
    END IF;

    -- Retornar resultado em formato legível (tipo relatório)
    RETURN 'ANALISE DE COMPATIBILIDADE - O FUTURO DO TRABALHO' || CHR(10) ||
           '================================================' || CHR(10) ||
           'Curso: ' || v_nome_curso || CHR(10) ||
           'Nivel Curso: ' || v_nivel_curso || CHR(10) ||
           'Funcionario: ID ' || p_id_funcionario || CHR(10) ||
           'Nivel Funcionario: ' || v_nivel_funcionario || CHR(10) ||
           'Cursos Concluidos: ' || v_qtd_cursos_concluidos || CHR(10) ||
           'Competencias em Alta: ' || v_competencias_atendidas || CHR(10) ||
           '------------------------------------------------' || CHR(10) ||
           'Score Nivel: ' || v_score_nivel || '/40' || CHR(10) ||
           'Score Experiencia: ' || v_score_experiencia || '/30' || CHR(10) ||
           'Score Competencias: ' || v_score_competencias || '/30' || CHR(10) ||
           'SCORE TOTAL: ' || v_score_final || '/100' || CHR(10) ||
           'COMPATIBILIDADE: ' || v_percentual_compatibilidade || '%' || CHR(10) ||
           '------------------------------------------------' || CHR(10) ||
           'RECOMENDACAO: ' || v_recomendacao || CHR(10) ||
           'Motivo: ' || v_motivo || CHR(10) ||
           '================================================';

EXCEPTION
    WHEN ex_email_invalido THEN
        -- EXCEÇÃO 3: Email inválido
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Email corporativo inválido');
        RETURN 'ERRO: Email fornecido nao e um email corporativo valido. ' ||
               'Use o formato: usuario@empresa.com (nao use Gmail, Hotmail, Yahoo ou Outlook)';

    WHEN ex_funcionario_nao_encontrado THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Funcionário não encontrado');
        RETURN 'ERRO: Funcionario com ID ' || p_id_funcionario || ' nao encontrado ou inativo no sistema.';

    WHEN ex_curso_nao_encontrado THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Curso não encontrado');
        RETURN 'ERRO: Curso com ID ' || p_id_curso || ' nao encontrado ou inativo no sistema.';

    WHEN ex_parametros_invalidos THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Parâmetros inválidos');
        RETURN 'ERRO: Parametros invalidos. IDs de funcionario e curso devem ser numeros positivos.';

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO NÃO TRATADA: ' || SQLERRM);
        RETURN 'ERRO INESPERADO: ' || SQLERRM ||
               ' (ID Funcionario: ' || NVL(TO_CHAR(p_id_funcionario), 'NULL') ||
               ', ID Curso: ' || NVL(TO_CHAR(p_id_curso), 'NULL') || ')';
END fn_calcular_compatibilidade_curso;
/

-- ============================================================
-- FUNÇÃO AUXILIAR: Validar Dados Cadastrais
-- ============================================================

CREATE OR REPLACE FUNCTION fn_validar_dados_cadastrais (
    p_tipo IN VARCHAR2, -- 'CPF', 'CNPJ', 'EMAIL', 'TELEFONE'
    p_valor IN VARCHAR2
) RETURN VARCHAR2
IS
    v_resultado VARCHAR2(100);
BEGIN
    CASE UPPER(p_tipo)
        WHEN 'CPF' THEN
            IF REGEXP_LIKE(p_valor, '^\d{3}\.\d{3}\.\d{3}-\d{2}$') THEN
                v_resultado := 'VALIDO';
            ELSE
                v_resultado := 'INVALIDO - Use formato: XXX.XXX.XXX-XX';
            END IF;

        WHEN 'CNPJ' THEN
            IF REGEXP_LIKE(p_valor, '^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$') THEN
                v_resultado := 'VALIDO';
            ELSE
                v_resultado := 'INVALIDO - Use formato: XX.XXX.XXX/XXXX-XX';
            END IF;

        WHEN 'EMAIL' THEN
            IF REGEXP_LIKE(p_valor, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
                v_resultado := 'VALIDO';
            ELSE
                v_resultado := 'INVALIDO - Email mal formatado';
            END IF;

        WHEN 'TELEFONE' THEN
            IF REGEXP_LIKE(p_valor, '^\(?\d{2}\)?\s?\d{4,5}-?\d{4}$') THEN
                v_resultado := 'VALIDO';
            ELSE
                v_resultado := 'INVALIDO - Use formato: (XX) XXXXX-XXXX';
            END IF;

        ELSE
            v_resultado := 'TIPO INVALIDO - Use: CPF, CNPJ, EMAIL ou TELEFONE';
    END CASE;

    RETURN v_resultado;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERRO: ' || SQLERRM;
END fn_validar_dados_cadastrais;
/

COMMIT;

-- ============================================================
-- FIM DA FUNÇÃO 2 - VALIDAÇÃO E CÁLCULO
-- ============================================================
