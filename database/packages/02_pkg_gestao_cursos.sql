-- ============================================================
-- PACKAGE: PKG_GESTAO_CURSOS
-- Agrupa procedures e funções para gestão de cursos
-- (Categorias, Cursos, Módulos, Competências)
-- ============================================================

-- ============================================================
-- ESPECIFICAÇÃO DO PACKAGE
-- ============================================================
CREATE OR REPLACE PACKAGE pkg_gestao_cursos AS
    -- Procedures de Inserção
    PROCEDURE inserir_categoria_curso (
        p_nome_categoria IN VARCHAR2,
        p_descricao IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE inserir_curso (
        p_id_categoria IN NUMBER,
        p_nome_curso IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_carga_horaria IN NUMBER,
        p_nivel_dificuldade IN VARCHAR2,
        p_pontos_conclusao IN NUMBER DEFAULT 100
    );

    PROCEDURE inserir_modulo (
        p_id_curso IN NUMBER,
        p_numero_modulo IN NUMBER,
        p_titulo IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_conteudo IN CLOB,
        p_duracao_minutos IN NUMBER,
        p_ordem IN NUMBER
    );

    PROCEDURE inserir_competencia (
        p_nome_competencia IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_categoria IN VARCHAR2,
        p_nivel_mercado IN VARCHAR2 DEFAULT 'EM_ALTA'
    );

    PROCEDURE associar_competencia_funcionario (
        p_id_funcionario IN NUMBER,
        p_id_competencia IN NUMBER,
        p_nivel_proficiencia IN VARCHAR2
    );

    -- Funções de Consulta
    FUNCTION obter_total_cursos_categoria(p_id_categoria IN NUMBER) RETURN NUMBER;
    FUNCTION obter_carga_horaria_total_curso(p_id_curso IN NUMBER) RETURN NUMBER;
    FUNCTION gerar_curso_json(p_id_curso IN NUMBER) RETURN CLOB;

END pkg_gestao_cursos;
/

-- ============================================================
-- CORPO DO PACKAGE
-- ============================================================
CREATE OR REPLACE PACKAGE BODY pkg_gestao_cursos AS

    -- Implementação: Inserir Categoria de Curso
    PROCEDURE inserir_categoria_curso (
        p_nome_categoria IN VARCHAR2,
        p_descricao IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        sp_inserir_categoria_curso(p_nome_categoria, p_descricao);
    END inserir_categoria_curso;

    -- Implementação: Inserir Curso
    PROCEDURE inserir_curso (
        p_id_categoria IN NUMBER,
        p_nome_curso IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_carga_horaria IN NUMBER,
        p_nivel_dificuldade IN VARCHAR2,
        p_pontos_conclusao IN NUMBER DEFAULT 100
    ) IS
    BEGIN
        sp_inserir_curso(p_id_categoria, p_nome_curso, p_descricao,
                        p_carga_horaria, p_nivel_dificuldade, p_pontos_conclusao);
    END inserir_curso;

    -- Implementação: Inserir Módulo
    PROCEDURE inserir_modulo (
        p_id_curso IN NUMBER,
        p_numero_modulo IN NUMBER,
        p_titulo IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_conteudo IN CLOB,
        p_duracao_minutos IN NUMBER,
        p_ordem IN NUMBER
    ) IS
    BEGIN
        sp_inserir_modulo(p_id_curso, p_numero_modulo, p_titulo,
                         p_descricao, p_conteudo, p_duracao_minutos, p_ordem);
    END inserir_modulo;

    -- Implementação: Inserir Competência
    PROCEDURE inserir_competencia (
        p_nome_competencia IN VARCHAR2,
        p_descricao IN VARCHAR2,
        p_categoria IN VARCHAR2,
        p_nivel_mercado IN VARCHAR2 DEFAULT 'EM_ALTA'
    ) IS
    BEGIN
        sp_inserir_competencia(p_nome_competencia, p_descricao,
                              p_categoria, p_nivel_mercado);
    END inserir_competencia;

    -- Implementação: Associar Competência ao Funcionário
    PROCEDURE associar_competencia_funcionario (
        p_id_funcionario IN NUMBER,
        p_id_competencia IN NUMBER,
        p_nivel_proficiencia IN VARCHAR2
    ) IS
    BEGIN
        sp_associar_competencia_funcionario(p_id_funcionario, p_id_competencia,
                                           p_nivel_proficiencia);
    END associar_competencia_funcionario;

    -- Implementação: Obter Total de Cursos por Categoria
    FUNCTION obter_total_cursos_categoria(p_id_categoria IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM curso
        WHERE id_categoria = p_id_categoria AND status = 'ATIVO';

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END obter_total_cursos_categoria;

    -- Implementação: Obter Carga Horária Total do Curso
    FUNCTION obter_carga_horaria_total_curso(p_id_curso IN NUMBER) RETURN NUMBER IS
        v_total_minutos NUMBER;
    BEGIN
        SELECT SUM(duracao_minutos)
        INTO v_total_minutos
        FROM modulo
        WHERE id_curso = p_id_curso AND status = 'ATIVO';

        RETURN NVL(v_total_minutos, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END obter_carga_horaria_total_curso;

    -- Implementação: Gerar JSON do Curso
    FUNCTION gerar_curso_json(p_id_curso IN NUMBER) RETURN CLOB IS
    BEGIN
        RETURN fn_gerar_curso_json(p_id_curso);
    END gerar_curso_json;

END pkg_gestao_cursos;
/
