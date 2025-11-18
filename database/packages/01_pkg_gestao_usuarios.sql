-- ============================================================
-- PACKAGE: PKG_GESTAO_USUARIOS
-- Agrupa procedures e funções para gestão de usuários
-- (Empresas, Gerentes, Funcionários e Times)
-- ============================================================

-- ============================================================
-- ESPECIFICAÇÃO DO PACKAGE
-- ============================================================
CREATE OR REPLACE PACKAGE pkg_gestao_usuarios AS
    -- Procedures de Inserção
    PROCEDURE inserir_empresa (
        p_cnpj IN VARCHAR2,
        p_razao_social IN VARCHAR2,
        p_nome_fantasia IN VARCHAR2,
        p_email IN VARCHAR2,
        p_telefone IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE inserir_gerente (
        p_id_empresa IN NUMBER,
        p_nome IN VARCHAR2,
        p_cpf IN VARCHAR2,
        p_email IN VARCHAR2,
        p_telefone IN VARCHAR2 DEFAULT NULL,
        p_cargo IN VARCHAR2 DEFAULT 'GERENTE'
    );

    PROCEDURE inserir_funcionario (
        p_id_empresa IN NUMBER,
        p_nome IN VARCHAR2,
        p_cpf IN VARCHAR2,
        p_email IN VARCHAR2,
        p_telefone IN VARCHAR2 DEFAULT NULL,
        p_cargo IN VARCHAR2 DEFAULT NULL,
        p_nivel_atual IN VARCHAR2 DEFAULT 'INICIANTE'
    );

    PROCEDURE inserir_time (
        p_id_gerente IN NUMBER,
        p_nome_time IN VARCHAR2,
        p_descricao IN VARCHAR2 DEFAULT NULL
    );

    PROCEDURE adicionar_funcionario_time (
        p_id_funcionario IN NUMBER,
        p_id_time IN NUMBER
    );

    -- Funções de Consulta
    FUNCTION obter_total_funcionarios(p_id_empresa IN NUMBER) RETURN NUMBER;
    FUNCTION obter_total_times(p_id_gerente IN NUMBER) RETURN NUMBER;

    -- Procedures de Atualização
    PROCEDURE atualizar_pontos_funcionario (
        p_id_funcionario IN NUMBER,
        p_pontos_adicionar IN NUMBER
    );

    PROCEDURE atualizar_nivel_funcionario (
        p_id_funcionario IN NUMBER,
        p_novo_nivel IN VARCHAR2
    );

END pkg_gestao_usuarios;
/

-- ============================================================
-- CORPO DO PACKAGE
-- ============================================================
CREATE OR REPLACE PACKAGE BODY pkg_gestao_usuarios AS

    -- Implementação: Inserir Empresa
    PROCEDURE inserir_empresa (
        p_cnpj IN VARCHAR2,
        p_razao_social IN VARCHAR2,
        p_nome_fantasia IN VARCHAR2,
        p_email IN VARCHAR2,
        p_telefone IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        sp_inserir_empresa(p_cnpj, p_razao_social, p_nome_fantasia, p_email, p_telefone);
    END inserir_empresa;

    -- Implementação: Inserir Gerente
    PROCEDURE inserir_gerente (
        p_id_empresa IN NUMBER,
        p_nome IN VARCHAR2,
        p_cpf IN VARCHAR2,
        p_email IN VARCHAR2,
        p_telefone IN VARCHAR2 DEFAULT NULL,
        p_cargo IN VARCHAR2 DEFAULT 'GERENTE'
    ) IS
    BEGIN
        sp_inserir_gerente(p_id_empresa, p_nome, p_cpf, p_email, p_telefone, p_cargo);
    END inserir_gerente;

    -- Implementação: Inserir Funcionário
    PROCEDURE inserir_funcionario (
        p_id_empresa IN NUMBER,
        p_nome IN VARCHAR2,
        p_cpf IN VARCHAR2,
        p_email IN VARCHAR2,
        p_telefone IN VARCHAR2 DEFAULT NULL,
        p_cargo IN VARCHAR2 DEFAULT NULL,
        p_nivel_atual IN VARCHAR2 DEFAULT 'INICIANTE'
    ) IS
    BEGIN
        sp_inserir_funcionario(p_id_empresa, p_nome, p_cpf, p_email, p_telefone, p_cargo, p_nivel_atual);
    END inserir_funcionario;

    -- Implementação: Inserir Time
    PROCEDURE inserir_time (
        p_id_gerente IN NUMBER,
        p_nome_time IN VARCHAR2,
        p_descricao IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        sp_inserir_time(p_id_gerente, p_nome_time, p_descricao);
    END inserir_time;

    -- Implementação: Adicionar Funcionário ao Time
    PROCEDURE adicionar_funcionario_time (
        p_id_funcionario IN NUMBER,
        p_id_time IN NUMBER
    ) IS
    BEGIN
        sp_adicionar_funcionario_time(p_id_funcionario, p_id_time);
    END adicionar_funcionario_time;

    -- Implementação: Obter Total de Funcionários
    FUNCTION obter_total_funcionarios(p_id_empresa IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM funcionario
        WHERE id_empresa = p_id_empresa AND status = 'ATIVO';

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END obter_total_funcionarios;

    -- Implementação: Obter Total de Times
    FUNCTION obter_total_times(p_id_gerente IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM time
        WHERE id_gerente = p_id_gerente AND status = 'ATIVO';

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END obter_total_times;

    -- Implementação: Atualizar Pontos do Funcionário
    PROCEDURE atualizar_pontos_funcionario (
        p_id_funcionario IN NUMBER,
        p_pontos_adicionar IN NUMBER
    ) IS
    BEGIN
        UPDATE funcionario
        SET pontos_acumulados = pontos_acumulados + p_pontos_adicionar
        WHERE id_funcionario = p_id_funcionario;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Pontos atualizados com sucesso!');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END atualizar_pontos_funcionario;

    -- Implementação: Atualizar Nível do Funcionário
    PROCEDURE atualizar_nivel_funcionario (
        p_id_funcionario IN NUMBER,
        p_novo_nivel IN VARCHAR2
    ) IS
    BEGIN
        IF p_novo_nivel NOT IN ('INICIANTE', 'INTERMEDIARIO', 'AVANCADO', 'EXPERT') THEN
            RAISE_APPLICATION_ERROR(-20999, 'Nível inválido');
        END IF;

        UPDATE funcionario
        SET nivel_atual = p_novo_nivel
        WHERE id_funcionario = p_id_funcionario;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Nível atualizado com sucesso!');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END atualizar_nivel_funcionario;

END pkg_gestao_usuarios;
/
