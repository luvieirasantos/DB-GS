-- ============================================================
-- TRIGGERS DE AUDITORIA
-- Registram todas as operações INSERT, UPDATE e DELETE
-- ============================================================

-- ============================================================
-- TRIGGER: EMPRESA
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_empresa
AFTER INSERT OR UPDATE OR DELETE ON empresa
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    -- Determinar tipo de operação
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_empresa || '|CNPJ:' || :NEW.cnpj ||
                         '|Razão:' || :NEW.razao_social || '|Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_empresa || '|CNPJ:' || :OLD.cnpj ||
                           '|Razão:' || :OLD.razao_social || '|Status:' || :OLD.status;
        v_dados_novos := 'ID:' || :NEW.id_empresa || '|CNPJ:' || :NEW.cnpj ||
                         '|Razão:' || :NEW.razao_social || '|Status:' || :NEW.status;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_empresa || '|CNPJ:' || :OLD.cnpj ||
                           '|Razão:' || :OLD.razao_social || '|Status:' || :OLD.status;
    END IF;

    -- Inserir registro de auditoria
    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'EMPRESA', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: GERENTE
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_gerente
AFTER INSERT OR UPDATE OR DELETE ON gerente
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_gerente || '|Nome:' || :NEW.nome ||
                         '|CPF:' || :NEW.cpf || '|Email:' || :NEW.email || '|Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_gerente || '|Nome:' || :OLD.nome ||
                           '|CPF:' || :OLD.cpf || '|Email:' || :OLD.email || '|Status:' || :OLD.status;
        v_dados_novos := 'ID:' || :NEW.id_gerente || '|Nome:' || :NEW.nome ||
                         '|CPF:' || :NEW.cpf || '|Email:' || :NEW.email || '|Status:' || :NEW.status;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_gerente || '|Nome:' || :OLD.nome ||
                           '|CPF:' || :OLD.cpf || '|Email:' || :OLD.email || '|Status:' || :OLD.status;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'GERENTE', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: FUNCIONARIO
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_funcionario
AFTER INSERT OR UPDATE OR DELETE ON funcionario
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_funcionario || '|Nome:' || :NEW.nome ||
                         '|CPF:' || :NEW.cpf || '|Email:' || :NEW.email ||
                         '|Nível:' || :NEW.nivel_atual || '|Pontos:' || :NEW.pontos_acumulados;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_funcionario || '|Nome:' || :OLD.nome ||
                           '|CPF:' || :OLD.cpf || '|Nível:' || :OLD.nivel_atual ||
                           '|Pontos:' || :OLD.pontos_acumulados;
        v_dados_novos := 'ID:' || :NEW.id_funcionario || '|Nome:' || :NEW.nome ||
                         '|CPF:' || :NEW.cpf || '|Nível:' || :NEW.nivel_atual ||
                         '|Pontos:' || :NEW.pontos_acumulados;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_funcionario || '|Nome:' || :OLD.nome ||
                           '|CPF:' || :OLD.cpf || '|Pontos:' || :OLD.pontos_acumulados;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'FUNCIONARIO', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: TIME
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_time
AFTER INSERT OR UPDATE OR DELETE ON time
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_time || '|Nome:' || :NEW.nome_time ||
                         '|Gerente:' || :NEW.id_gerente || '|Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_time || '|Nome:' || :OLD.nome_time ||
                           '|Status:' || :OLD.status;
        v_dados_novos := 'ID:' || :NEW.id_time || '|Nome:' || :NEW.nome_time ||
                         '|Status:' || :NEW.status;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_time || '|Nome:' || :OLD.nome_time;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'TIME', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: CURSO
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_curso
AFTER INSERT OR UPDATE OR DELETE ON curso
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_curso || '|Nome:' || :NEW.nome_curso ||
                         '|Nível:' || :NEW.nivel_dificuldade || '|Pontos:' || :NEW.pontos_conclusao;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_curso || '|Nome:' || :OLD.nome_curso ||
                           '|Pontos:' || :OLD.pontos_conclusao;
        v_dados_novos := 'ID:' || :NEW.id_curso || '|Nome:' || :NEW.nome_curso ||
                         '|Pontos:' || :NEW.pontos_conclusao;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_curso || '|Nome:' || :OLD.nome_curso;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'CURSO', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: MATRICULA
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_matricula
AFTER INSERT OR UPDATE OR DELETE ON matricula
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_matricula || '|Funcionário:' || :NEW.id_funcionario ||
                         '|Curso:' || :NEW.id_curso || '|Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_matricula || '|Status:' || :OLD.status ||
                           '|Percentual:' || :OLD.percentual_conclusao || '|Nota:' || :OLD.nota_final;
        v_dados_novos := 'ID:' || :NEW.id_matricula || '|Status:' || :NEW.status ||
                         '|Percentual:' || :NEW.percentual_conclusao || '|Nota:' || :NEW.nota_final;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_matricula || '|Funcionário:' || :OLD.id_funcionario ||
                           '|Curso:' || :OLD.id_curso;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'MATRICULA', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: PROGRESSO
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_progresso
AFTER INSERT OR UPDATE OR DELETE ON progresso
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_progresso || '|Matrícula:' || :NEW.id_matricula ||
                         '|Módulo:' || :NEW.id_modulo || '|Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_progresso || '|Status:' || :OLD.status ||
                           '|Tempo:' || :OLD.tempo_gasto_minutos || '|Nota:' || :OLD.nota;
        v_dados_novos := 'ID:' || :NEW.id_progresso || '|Status:' || :NEW.status ||
                         '|Tempo:' || :NEW.tempo_gasto_minutos || '|Nota:' || :NEW.nota;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_progresso || '|Matrícula:' || :OLD.id_matricula;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'PROGRESSO', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: CERTIFICADO
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_certificado
AFTER INSERT OR UPDATE OR DELETE ON certificado
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_certificado || '|Código:' || :NEW.codigo_certificado ||
                         '|Matrícula:' || :NEW.id_matricula || '|Nota:' || :NEW.nota_final;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_certificado || '|Status:' || :OLD.status;
        v_dados_novos := 'ID:' || :NEW.id_certificado || '|Status:' || :NEW.status;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_certificado || '|Código:' || :OLD.codigo_certificado;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'CERTIFICADO', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: COMPETICAO
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_competicao
AFTER INSERT OR UPDATE OR DELETE ON competicao
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_competicao || '|Nome:' || :NEW.nome_competicao ||
                         '|Tipo:' || :NEW.tipo_competicao || '|Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_competicao || '|Status:' || :OLD.status;
        v_dados_novos := 'ID:' || :NEW.id_competicao || '|Status:' || :NEW.status;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_competicao || '|Nome:' || :OLD.nome_competicao;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'COMPETICAO', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

-- ============================================================
-- TRIGGER: COMPETENCIA
-- ============================================================
CREATE OR REPLACE TRIGGER trg_audit_competencia
AFTER INSERT OR UPDATE OR DELETE ON competencia
FOR EACH ROW
DECLARE
    v_operacao VARCHAR2(10);
    v_dados_antigos CLOB;
    v_dados_novos CLOB;
BEGIN
    IF INSERTING THEN
        v_operacao := 'INSERT';
        v_dados_novos := 'ID:' || :NEW.id_competencia || '|Nome:' || :NEW.nome_competencia ||
                         '|Categoria:' || :NEW.categoria || '|Mercado:' || :NEW.nivel_mercado;
    ELSIF UPDATING THEN
        v_operacao := 'UPDATE';
        v_dados_antigos := 'ID:' || :OLD.id_competencia || '|Mercado:' || :OLD.nivel_mercado;
        v_dados_novos := 'ID:' || :NEW.id_competencia || '|Mercado:' || :NEW.nivel_mercado;
    ELSIF DELETING THEN
        v_operacao := 'DELETE';
        v_dados_antigos := 'ID:' || :OLD.id_competencia || '|Nome:' || :OLD.nome_competencia;
    END IF;

    INSERT INTO auditoria (
        id_auditoria, tabela, operacao, usuario, data_operacao,
        dados_antigos, dados_novos, ip_usuario
    ) VALUES (
        seq_auditoria.NEXTVAL, 'COMPETENCIA', v_operacao, USER, SYSDATE,
        v_dados_antigos, v_dados_novos, SYS_CONTEXT('USERENV', 'IP_ADDRESS')
    );
END;
/

COMMIT;

-- ============================================================
-- FIM DOS TRIGGERS DE AUDITORIA
-- ============================================================
