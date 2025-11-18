-- ============================================================
-- FUNÇÃO 1: CONVERSÃO MANUAL PARA JSON
-- Gera JSON manualmente usando apenas concatenação de strings
-- SEM USO DE FUNÇÕES BUILT-IN DO ORACLE
-- ============================================================

CREATE OR REPLACE FUNCTION fn_gerar_perfil_funcionario_json (
    p_id_funcionario IN NUMBER
) RETURN CLOB
IS
    -- Variáveis para armazenar dados do funcionário
    v_nome funcionario.nome%TYPE;
    v_email funcionario.email%TYPE;
    v_cargo funcionario.cargo%TYPE;
    v_nivel funcionario.nivel_atual%TYPE;
    v_pontos funcionario.pontos_acumulados%TYPE;
    v_status funcionario.status%TYPE;
    v_data_cadastro funcionario.data_cadastro%TYPE;

    -- Variáveis para construção do JSON
    v_json CLOB := '';
    v_competencias_json CLOB := '';
    v_cursos_json CLOB := '';
    v_primeiro_registro BOOLEAN;
    v_count NUMBER := 0;

    -- Cursores para percorrer competências e cursos
    CURSOR cur_competencias IS
        SELECT
            c.nome_competencia,
            c.categoria,
            fc.nivel_proficiencia,
            fc.data_aquisicao
        FROM funcionario_competencia fc
        INNER JOIN competencia c ON fc.id_competencia = c.id_competencia
        WHERE fc.id_funcionario = p_id_funcionario
        ORDER BY fc.data_aquisicao DESC;

    CURSOR cur_cursos IS
        SELECT
            cu.nome_curso,
            cu.nivel_dificuldade,
            m.status,
            m.percentual_conclusao,
            m.nota_final,
            m.data_matricula,
            m.data_conclusao
        FROM matricula m
        INNER JOIN curso cu ON m.id_curso = cu.id_curso
        WHERE m.id_funcionario = p_id_funcionario
        ORDER BY m.data_matricula DESC;

    -- Exceções personalizadas
    ex_funcionario_nao_encontrado EXCEPTION;
    ex_dados_invalidos EXCEPTION;
    ex_erro_construcao_json EXCEPTION;

    -- Função auxiliar para escapar strings JSON
    FUNCTION escape_json_string(p_string IN VARCHAR2) RETURN VARCHAR2 IS
        v_result VARCHAR2(4000);
    BEGIN
        IF p_string IS NULL THEN
            RETURN 'null';
        END IF;

        v_result := p_string;
        -- Escapar caracteres especiais
        v_result := REPLACE(v_result, '\', '\\');
        v_result := REPLACE(v_result, '"', '\"');
        v_result := REPLACE(v_result, CHR(10), '\n');
        v_result := REPLACE(v_result, CHR(13), '\r');
        v_result := REPLACE(v_result, CHR(9), '\t');

        RETURN '"' || v_result || '"';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '"erro_escape"';
    END escape_json_string;

    -- Função auxiliar para formatar data como string JSON
    FUNCTION format_json_date(p_date IN DATE) RETURN VARCHAR2 IS
    BEGIN
        IF p_date IS NULL THEN
            RETURN 'null';
        END IF;
        RETURN '"' || TO_CHAR(p_date, 'YYYY-MM-DD"T"HH24:MI:SS') || '"';
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'null';
    END format_json_date;

    -- Função auxiliar para formatar número como string JSON
    FUNCTION format_json_number(p_number IN NUMBER) RETURN VARCHAR2 IS
    BEGIN
        IF p_number IS NULL THEN
            RETURN 'null';
        END IF;
        RETURN TO_CHAR(p_number);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'null';
    END format_json_number;

BEGIN
    -- Log de início
    DBMS_OUTPUT.PUT_LINE('Iniciando geração de JSON para funcionário ID: ' || p_id_funcionario);

    -- EXCEÇÃO 1: Validar se ID do funcionário foi informado
    IF p_id_funcionario IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ID do funcionário não informado');
        RAISE ex_dados_invalidos;
    END IF;

    -- Buscar dados do funcionário
    BEGIN
        SELECT
            nome, email, cargo, nivel_atual,
            pontos_acumulados, status, data_cadastro
        INTO
            v_nome, v_email, v_cargo, v_nivel,
            v_pontos, v_status, v_data_cadastro
        FROM funcionario
        WHERE id_funcionario = p_id_funcionario;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- EXCEÇÃO 2: Funcionário não encontrado
            DBMS_OUTPUT.PUT_LINE('ERRO: Funcionário com ID ' || p_id_funcionario || ' não encontrado no banco de dados');
            RAISE ex_funcionario_nao_encontrado;
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('ERRO: Múltiplos registros encontrados para o ID ' || p_id_funcionario);
            RAISE ex_dados_invalidos;
    END;

    -- Construir início do JSON principal
    v_json := '{' || CHR(10);
    v_json := v_json || '  "funcionario": {' || CHR(10);
    v_json := v_json || '    "id": ' || format_json_number(p_id_funcionario) || ',' || CHR(10);
    v_json := v_json || '    "nome": ' || escape_json_string(v_nome) || ',' || CHR(10);
    v_json := v_json || '    "email": ' || escape_json_string(v_email) || ',' || CHR(10);
    v_json := v_json || '    "cargo": ' || escape_json_string(v_cargo) || ',' || CHR(10);
    v_json := v_json || '    "nivel_atual": ' || escape_json_string(v_nivel) || ',' || CHR(10);
    v_json := v_json || '    "pontos_acumulados": ' || format_json_number(v_pontos) || ',' || CHR(10);
    v_json := v_json || '    "status": ' || escape_json_string(v_status) || ',' || CHR(10);
    v_json := v_json || '    "data_cadastro": ' || format_json_date(v_data_cadastro) || CHR(10);
    v_json := v_json || '  },' || CHR(10);

    -- Construir array de competências
    v_json := v_json || '  "competencias": [' || CHR(10);
    v_primeiro_registro := TRUE;
    v_count := 0;

    FOR rec IN cur_competencias LOOP
        v_count := v_count + 1;

        -- Adicionar vírgula se não for o primeiro registro
        IF NOT v_primeiro_registro THEN
            v_competencias_json := v_competencias_json || ',' || CHR(10);
        END IF;

        -- Construir objeto de competência
        v_competencias_json := v_competencias_json || '    {' || CHR(10);
        v_competencias_json := v_competencias_json || '      "nome": ' || escape_json_string(rec.nome_competencia) || ',' || CHR(10);
        v_competencias_json := v_competencias_json || '      "categoria": ' || escape_json_string(rec.categoria) || ',' || CHR(10);
        v_competencias_json := v_competencias_json || '      "nivel_proficiencia": ' || escape_json_string(rec.nivel_proficiencia) || ',' || CHR(10);
        v_competencias_json := v_competencias_json || '      "data_aquisicao": ' || format_json_date(rec.data_aquisicao) || CHR(10);
        v_competencias_json := v_competencias_json || '    }';

        v_primeiro_registro := FALSE;
    END LOOP;

    v_json := v_json || v_competencias_json || CHR(10);
    v_json := v_json || '  ],' || CHR(10);

    DBMS_OUTPUT.PUT_LINE('Total de competências processadas: ' || v_count);

    -- Construir array de cursos
    v_json := v_json || '  "cursos": [' || CHR(10);
    v_primeiro_registro := TRUE;
    v_count := 0;

    FOR rec IN cur_cursos LOOP
        v_count := v_count + 1;

        -- Adicionar vírgula se não for o primeiro registro
        IF NOT v_primeiro_registro THEN
            v_cursos_json := v_cursos_json || ',' || CHR(10);
        END IF;

        -- Construir objeto de curso
        v_cursos_json := v_cursos_json || '    {' || CHR(10);
        v_cursos_json := v_cursos_json || '      "nome_curso": ' || escape_json_string(rec.nome_curso) || ',' || CHR(10);
        v_cursos_json := v_cursos_json || '      "nivel_dificuldade": ' || escape_json_string(rec.nivel_dificuldade) || ',' || CHR(10);
        v_cursos_json := v_cursos_json || '      "status": ' || escape_json_string(rec.status) || ',' || CHR(10);
        v_cursos_json := v_cursos_json || '      "percentual_conclusao": ' || format_json_number(rec.percentual_conclusao) || ',' || CHR(10);
        v_cursos_json := v_cursos_json || '      "nota_final": ' || format_json_number(rec.nota_final) || ',' || CHR(10);
        v_cursos_json := v_cursos_json || '      "data_matricula": ' || format_json_date(rec.data_matricula) || ',' || CHR(10);
        v_cursos_json := v_cursos_json || '      "data_conclusao": ' || format_json_date(rec.data_conclusao) || CHR(10);
        v_cursos_json := v_cursos_json || '    }';

        v_primeiro_registro := FALSE;
    END LOOP;

    v_json := v_json || v_cursos_json || CHR(10);
    v_json := v_json || '  ],' || CHR(10);

    DBMS_OUTPUT.PUT_LINE('Total de cursos processados: ' || v_count);

    -- Adicionar metadados
    v_json := v_json || '  "metadata": {' || CHR(10);
    v_json := v_json || '    "data_geracao": ' || format_json_date(SYSDATE) || ',' || CHR(10);
    v_json := v_json || '    "versao_api": "1.0",' || CHR(10);
    v_json := v_json || '    "sistema": "Plataforma de Cursos Corporativa",' || CHR(10);
    v_json := v_json || '    "tema": "O Futuro do Trabalho - Qualificacao Tecnologica"' || CHR(10);
    v_json := v_json || '  }' || CHR(10);

    -- Fechar JSON
    v_json := v_json || '}';

    -- EXCEÇÃO 3: Validar se JSON foi construído corretamente
    IF v_json IS NULL OR LENGTH(v_json) < 50 THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: JSON construído está vazio ou inválido');
        RAISE ex_erro_construcao_json;
    END IF;

    DBMS_OUTPUT.PUT_LINE('JSON gerado com sucesso! Tamanho: ' || LENGTH(v_json) || ' caracteres');

    RETURN v_json;

EXCEPTION
    WHEN ex_funcionario_nao_encontrado THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Funcionário não encontrado');
        RETURN '{"erro": "Funcionario nao encontrado", "id_funcionario": ' || p_id_funcionario || ', "timestamp": "' ||
               TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS') || '"}';

    WHEN ex_dados_invalidos THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Dados inválidos fornecidos');
        RETURN '{"erro": "Dados invalidos fornecidos", "id_funcionario": ' || NVL(TO_CHAR(p_id_funcionario), 'null') ||
               ', "timestamp": "' || TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS') || '"}';

    WHEN ex_erro_construcao_json THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO TRATADA: Erro durante construção do JSON');
        RETURN '{"erro": "Erro ao construir JSON", "id_funcionario": ' || p_id_funcionario ||
               ', "timestamp": "' || TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS') || '"}';

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXCEÇÃO NÃO TRATADA: ' || SQLERRM);
        RETURN '{"erro": "Erro inesperado", "mensagem": "' || REPLACE(SQLERRM, '"', '\"') ||
               '", "id_funcionario": ' || NVL(TO_CHAR(p_id_funcionario), 'null') ||
               ', "timestamp": "' || TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS') || '"}';
END fn_gerar_perfil_funcionario_json;
/

-- ============================================================
-- FUNÇÃO AUXILIAR: Gerar JSON de Curso Completo
-- ============================================================

CREATE OR REPLACE FUNCTION fn_gerar_curso_json (
    p_id_curso IN NUMBER
) RETURN CLOB
IS
    -- Variáveis para dados do curso
    v_nome_curso curso.nome_curso%TYPE;
    v_descricao curso.descricao%TYPE;
    v_carga_horaria curso.carga_horaria%TYPE;
    v_nivel curso.nivel_dificuldade%TYPE;
    v_pontos curso.pontos_conclusao%TYPE;
    v_categoria_nome categoria_curso.nome_categoria%TYPE;

    v_json CLOB := '';
    v_modulos_json CLOB := '';
    v_primeiro BOOLEAN := TRUE;
    v_count NUMBER := 0;

    CURSOR cur_modulos IS
        SELECT
            numero_modulo,
            titulo,
            descricao,
            duracao_minutos,
            ordem
        FROM modulo
        WHERE id_curso = p_id_curso
        ORDER BY ordem;

    ex_curso_nao_encontrado EXCEPTION;
    ex_id_invalido EXCEPTION;

    FUNCTION escape_str(p_str IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF p_str IS NULL THEN RETURN 'null'; END IF;
        RETURN '"' || REPLACE(REPLACE(REPLACE(p_str, '\', '\\'), '"', '\"'), CHR(10), '\n') || '"';
    END;

BEGIN
    -- Validação
    IF p_id_curso IS NULL OR p_id_curso <= 0 THEN
        RAISE ex_id_invalido;
    END IF;

    -- Buscar dados do curso
    BEGIN
        SELECT
            c.nome_curso, c.descricao, c.carga_horaria,
            c.nivel_dificuldade, c.pontos_conclusao,
            cat.nome_categoria
        INTO
            v_nome_curso, v_descricao, v_carga_horaria,
            v_nivel, v_pontos, v_categoria_nome
        FROM curso c
        INNER JOIN categoria_curso cat ON c.id_categoria = cat.id_categoria
        WHERE c.id_curso = p_id_curso;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE ex_curso_nao_encontrado;
    END;

    -- Construir JSON
    v_json := '{' || CHR(10);
    v_json := v_json || '  "curso": {' || CHR(10);
    v_json := v_json || '    "id": ' || p_id_curso || ',' || CHR(10);
    v_json := v_json || '    "nome": ' || escape_str(v_nome_curso) || ',' || CHR(10);
    v_json := v_json || '    "descricao": ' || escape_str(v_descricao) || ',' || CHR(10);
    v_json := v_json || '    "categoria": ' || escape_str(v_categoria_nome) || ',' || CHR(10);
    v_json := v_json || '    "carga_horaria": ' || v_carga_horaria || ',' || CHR(10);
    v_json := v_json || '    "nivel_dificuldade": ' || escape_str(v_nivel) || ',' || CHR(10);
    v_json := v_json || '    "pontos_conclusao": ' || v_pontos || CHR(10);
    v_json := v_json || '  },' || CHR(10);
    v_json := v_json || '  "modulos": [' || CHR(10);

    -- Módulos
    FOR rec IN cur_modulos LOOP
        v_count := v_count + 1;
        IF NOT v_primeiro THEN
            v_modulos_json := v_modulos_json || ',' || CHR(10);
        END IF;

        v_modulos_json := v_modulos_json || '    {' || CHR(10);
        v_modulos_json := v_modulos_json || '      "numero": ' || rec.numero_modulo || ',' || CHR(10);
        v_modulos_json := v_modulos_json || '      "titulo": ' || escape_str(rec.titulo) || ',' || CHR(10);
        v_modulos_json := v_modulos_json || '      "descricao": ' || escape_str(rec.descricao) || ',' || CHR(10);
        v_modulos_json := v_modulos_json || '      "duracao_minutos": ' || rec.duracao_minutos || CHR(10);
        v_modulos_json := v_modulos_json || '    }';

        v_primeiro := FALSE;
    END LOOP;

    v_json := v_json || v_modulos_json || CHR(10);
    v_json := v_json || '  ],' || CHR(10);
    v_json := v_json || '  "total_modulos": ' || v_count || CHR(10);
    v_json := v_json || '}';

    RETURN v_json;

EXCEPTION
    WHEN ex_curso_nao_encontrado THEN
        RETURN '{"erro": "Curso nao encontrado", "id_curso": ' || p_id_curso || '}';
    WHEN ex_id_invalido THEN
        RETURN '{"erro": "ID de curso invalido"}';
    WHEN OTHERS THEN
        RETURN '{"erro": "' || REPLACE(SQLERRM, '"', '\"') || '"}';
END fn_gerar_curso_json;
/

COMMIT;

-- ============================================================
-- FIM DA FUNÇÃO 1 - CONVERSÃO MANUAL PARA JSON
-- ============================================================
