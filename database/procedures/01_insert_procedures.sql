-- ============================================================
-- PROCEDURES DE INSERÇÃO COM PARÂMETROS E VALIDAÇÕES
-- ============================================================

-- ============================================================
-- PROCEDURE: Inserir Empresa
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_empresa (
    p_cnpj IN VARCHAR2,
    p_razao_social IN VARCHAR2,
    p_nome_fantasia IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefone IN VARCHAR2 DEFAULT NULL
) IS
    v_count NUMBER;
BEGIN
    -- Validar se CNPJ já existe
    SELECT COUNT(*) INTO v_count FROM empresa WHERE cnpj = p_cnpj;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'CNPJ já cadastrado no sistema.');
    END IF;

    -- Validar formato de CNPJ
    IF NOT REGEXP_LIKE(p_cnpj, '^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$') THEN
        RAISE_APPLICATION_ERROR(-20002, 'Formato de CNPJ inválido. Use: XX.XXX.XXX/XXXX-XX');
    END IF;

    -- Validar email
    IF NOT REGEXP_LIKE(p_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        RAISE_APPLICATION_ERROR(-20003, 'Formato de email inválido.');
    END IF;

    -- Inserir empresa
    INSERT INTO empresa (
        id_empresa, cnpj, razao_social, nome_fantasia,
        email_corporativo, telefone, data_cadastro, status
    ) VALUES (
        seq_empresa.NEXTVAL, p_cnpj, p_razao_social, p_nome_fantasia,
        p_email, p_telefone, SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Empresa cadastrada com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar empresa: ' || SQLERRM);
        RAISE;
END sp_inserir_empresa;
/

-- ============================================================
-- PROCEDURE: Inserir Gerente
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_gerente (
    p_id_empresa IN NUMBER,
    p_nome IN VARCHAR2,
    p_cpf IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefone IN VARCHAR2 DEFAULT NULL,
    p_cargo IN VARCHAR2 DEFAULT 'GERENTE'
) IS
    v_count NUMBER;
BEGIN
    -- Validar se empresa existe
    SELECT COUNT(*) INTO v_count FROM empresa WHERE id_empresa = p_id_empresa;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Empresa não encontrada.');
    END IF;

    -- Validar CPF único
    SELECT COUNT(*) INTO v_count FROM gerente WHERE cpf = p_cpf;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'CPF já cadastrado.');
    END IF;

    -- Validar formato CPF
    IF NOT REGEXP_LIKE(p_cpf, '^\d{3}\.\d{3}\.\d{3}-\d{2}$') THEN
        RAISE_APPLICATION_ERROR(-20012, 'Formato de CPF inválido. Use: XXX.XXX.XXX-XX');
    END IF;

    -- Validar email único
    SELECT COUNT(*) INTO v_count FROM gerente WHERE email = p_email;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Email já cadastrado.');
    END IF;

    -- Inserir gerente
    INSERT INTO gerente (
        id_gerente, id_empresa, nome, cpf, email,
        telefone, cargo, data_cadastro, status
    ) VALUES (
        seq_gerente.NEXTVAL, p_id_empresa, p_nome, p_cpf, p_email,
        p_telefone, p_cargo, SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Gerente cadastrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar gerente: ' || SQLERRM);
        RAISE;
END sp_inserir_gerente;
/

-- ============================================================
-- PROCEDURE: Inserir Funcionário
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_funcionario (
    p_id_empresa IN NUMBER,
    p_nome IN VARCHAR2,
    p_cpf IN VARCHAR2,
    p_email IN VARCHAR2,
    p_telefone IN VARCHAR2 DEFAULT NULL,
    p_cargo IN VARCHAR2 DEFAULT NULL,
    p_nivel_atual IN VARCHAR2 DEFAULT 'INICIANTE'
) IS
    v_count NUMBER;
BEGIN
    -- Validar empresa
    SELECT COUNT(*) INTO v_count FROM empresa WHERE id_empresa = p_id_empresa;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20020, 'Empresa não encontrada.');
    END IF;

    -- Validar CPF único
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE cpf = p_cpf;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20021, 'CPF já cadastrado.');
    END IF;

    -- Validar formato CPF
    IF NOT REGEXP_LIKE(p_cpf, '^\d{3}\.\d{3}\.\d{3}-\d{2}$') THEN
        RAISE_APPLICATION_ERROR(-20022, 'Formato de CPF inválido.');
    END IF;

    -- Validar email único
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE email = p_email;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20023, 'Email já cadastrado.');
    END IF;

    -- Validar nível
    IF p_nivel_atual NOT IN ('INICIANTE', 'INTERMEDIARIO', 'AVANCADO', 'EXPERT') THEN
        RAISE_APPLICATION_ERROR(-20024, 'Nível inválido. Use: INICIANTE, INTERMEDIARIO, AVANCADO ou EXPERT');
    END IF;

    -- Inserir funcionário
    INSERT INTO funcionario (
        id_funcionario, id_empresa, nome, cpf, email,
        telefone, cargo, nivel_atual, pontos_acumulados,
        data_cadastro, status
    ) VALUES (
        seq_funcionario.NEXTVAL, p_id_empresa, p_nome, p_cpf, p_email,
        p_telefone, p_cargo, p_nivel_atual, 0,
        SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Funcionário cadastrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar funcionário: ' || SQLERRM);
        RAISE;
END sp_inserir_funcionario;
/

-- ============================================================
-- PROCEDURE: Inserir Time
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_time (
    p_id_gerente IN NUMBER,
    p_nome_time IN VARCHAR2,
    p_descricao IN VARCHAR2 DEFAULT NULL
) IS
    v_count NUMBER;
BEGIN
    -- Validar gerente
    SELECT COUNT(*) INTO v_count FROM gerente WHERE id_gerente = p_id_gerente AND status = 'ATIVO';
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'Gerente não encontrado ou inativo.');
    END IF;

    -- Inserir time
    INSERT INTO time (
        id_time, id_gerente, nome_time, descricao,
        data_criacao, status
    ) VALUES (
        seq_time.NEXTVAL, p_id_gerente, p_nome_time, p_descricao,
        SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Time cadastrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar time: ' || SQLERRM);
        RAISE;
END sp_inserir_time;
/

-- ============================================================
-- PROCEDURE: Adicionar Funcionário ao Time
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_adicionar_funcionario_time (
    p_id_funcionario IN NUMBER,
    p_id_time IN NUMBER
) IS
    v_count NUMBER;
    v_id_empresa_func NUMBER;
    v_id_empresa_time NUMBER;
BEGIN
    -- Validar funcionário
    SELECT COUNT(*), MAX(id_empresa)
    INTO v_count, v_id_empresa_func
    FROM funcionario
    WHERE id_funcionario = p_id_funcionario AND status = 'ATIVO';

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20040, 'Funcionário não encontrado ou inativo.');
    END IF;

    -- Validar time e obter empresa do gerente
    SELECT COUNT(*), MAX(g.id_empresa)
    INTO v_count, v_id_empresa_time
    FROM time t
    INNER JOIN gerente g ON t.id_gerente = g.id_gerente
    WHERE t.id_time = p_id_time AND t.status = 'ATIVO';

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20041, 'Time não encontrado ou inativo.');
    END IF;

    -- Validar se funcionário e time são da mesma empresa
    IF v_id_empresa_func != v_id_empresa_time THEN
        RAISE_APPLICATION_ERROR(-20042, 'Funcionário e Time devem pertencer à mesma empresa.');
    END IF;

    -- Verificar se já está no time
    SELECT COUNT(*) INTO v_count
    FROM funcionario_time
    WHERE id_funcionario = p_id_funcionario AND id_time = p_id_time;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20043, 'Funcionário já está cadastrado neste time.');
    END IF;

    -- Inserir relacionamento
    INSERT INTO funcionario_time (
        id_funcionario, id_time, data_entrada, status
    ) VALUES (
        p_id_funcionario, p_id_time, SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Funcionário adicionado ao time com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao adicionar funcionário ao time: ' || SQLERRM);
        RAISE;
END sp_adicionar_funcionario_time;
/

-- ============================================================
-- PROCEDURE: Inserir Categoria de Curso
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_categoria_curso (
    p_nome_categoria IN VARCHAR2,
    p_descricao IN VARCHAR2 DEFAULT NULL
) IS
    v_count NUMBER;
BEGIN
    -- Validar se categoria já existe
    SELECT COUNT(*) INTO v_count FROM categoria_curso WHERE nome_categoria = p_nome_categoria;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20050, 'Categoria já cadastrada.');
    END IF;

    -- Inserir categoria
    INSERT INTO categoria_curso (
        id_categoria, nome_categoria, descricao, status
    ) VALUES (
        seq_categoria_curso.NEXTVAL, p_nome_categoria, p_descricao, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Categoria cadastrada com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar categoria: ' || SQLERRM);
        RAISE;
END sp_inserir_categoria_curso;
/

-- ============================================================
-- PROCEDURE: Inserir Curso
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_curso (
    p_id_categoria IN NUMBER,
    p_nome_curso IN VARCHAR2,
    p_descricao IN VARCHAR2,
    p_carga_horaria IN NUMBER,
    p_nivel_dificuldade IN VARCHAR2,
    p_pontos_conclusao IN NUMBER DEFAULT 100
) IS
    v_count NUMBER;
BEGIN
    -- Validar categoria
    SELECT COUNT(*) INTO v_count FROM categoria_curso WHERE id_categoria = p_id_categoria;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20060, 'Categoria não encontrada.');
    END IF;

    -- Validar nível
    IF p_nivel_dificuldade NOT IN ('INICIANTE', 'INTERMEDIARIO', 'AVANCADO') THEN
        RAISE_APPLICATION_ERROR(-20061, 'Nível inválido. Use: INICIANTE, INTERMEDIARIO ou AVANCADO');
    END IF;

    -- Validar carga horária
    IF p_carga_horaria <= 0 THEN
        RAISE_APPLICATION_ERROR(-20062, 'Carga horária deve ser maior que zero.');
    END IF;

    -- Inserir curso
    INSERT INTO curso (
        id_curso, id_categoria, nome_curso, descricao,
        carga_horaria, nivel_dificuldade, pontos_conclusao,
        data_criacao, status
    ) VALUES (
        seq_curso.NEXTVAL, p_id_categoria, p_nome_curso, p_descricao,
        p_carga_horaria, p_nivel_dificuldade, p_pontos_conclusao,
        SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Curso cadastrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar curso: ' || SQLERRM);
        RAISE;
END sp_inserir_curso;
/

-- ============================================================
-- PROCEDURE: Inserir Módulo
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_modulo (
    p_id_curso IN NUMBER,
    p_numero_modulo IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descricao IN VARCHAR2,
    p_conteudo IN CLOB,
    p_duracao_minutos IN NUMBER,
    p_ordem IN NUMBER
) IS
    v_count NUMBER;
BEGIN
    -- Validar curso
    SELECT COUNT(*) INTO v_count FROM curso WHERE id_curso = p_id_curso;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20070, 'Curso não encontrado.');
    END IF;

    -- Validar duração
    IF p_duracao_minutos <= 0 THEN
        RAISE_APPLICATION_ERROR(-20071, 'Duração deve ser maior que zero.');
    END IF;

    -- Inserir módulo
    INSERT INTO modulo (
        id_modulo, id_curso, numero_modulo, titulo,
        descricao, conteudo, duracao_minutos, ordem, status
    ) VALUES (
        seq_modulo.NEXTVAL, p_id_curso, p_numero_modulo, p_titulo,
        p_descricao, p_conteudo, p_duracao_minutos, p_ordem, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Módulo cadastrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar módulo: ' || SQLERRM);
        RAISE;
END sp_inserir_modulo;
/

-- ============================================================
-- PROCEDURE: Inserir Matrícula
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_matricula (
    p_id_funcionario IN NUMBER,
    p_id_curso IN NUMBER
) IS
    v_count NUMBER;
BEGIN
    -- Validar funcionário
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE id_funcionario = p_id_funcionario AND status = 'ATIVO';
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20080, 'Funcionário não encontrado ou inativo.');
    END IF;

    -- Validar curso
    SELECT COUNT(*) INTO v_count FROM curso WHERE id_curso = p_id_curso AND status = 'ATIVO';
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20081, 'Curso não encontrado ou inativo.');
    END IF;

    -- Verificar se já está matriculado
    SELECT COUNT(*) INTO v_count
    FROM matricula
    WHERE id_funcionario = p_id_funcionario AND id_curso = p_id_curso;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20082, 'Funcionário já está matriculado neste curso.');
    END IF;

    -- Inserir matrícula
    INSERT INTO matricula (
        id_matricula, id_funcionario, id_curso, data_matricula,
        data_inicio, status, percentual_conclusao
    ) VALUES (
        seq_matricula.NEXTVAL, p_id_funcionario, p_id_curso, SYSDATE,
        SYSDATE, 'EM_ANDAMENTO', 0
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Matrícula realizada com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao realizar matrícula: ' || SQLERRM);
        RAISE;
END sp_inserir_matricula;
/

-- ============================================================
-- PROCEDURE: Inserir Progresso
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_progresso (
    p_id_matricula IN NUMBER,
    p_id_modulo IN NUMBER,
    p_tempo_gasto_minutos IN NUMBER DEFAULT 0,
    p_nota IN NUMBER DEFAULT NULL
) IS
    v_count NUMBER;
BEGIN
    -- Validar matrícula
    SELECT COUNT(*) INTO v_count FROM matricula WHERE id_matricula = p_id_matricula;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20090, 'Matrícula não encontrada.');
    END IF;

    -- Validar módulo
    SELECT COUNT(*) INTO v_count FROM modulo WHERE id_modulo = p_id_modulo;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20091, 'Módulo não encontrado.');
    END IF;

    -- Inserir progresso
    INSERT INTO progresso (
        id_progresso, id_matricula, id_modulo, data_inicio,
        tempo_gasto_minutos, status, nota
    ) VALUES (
        seq_progresso.NEXTVAL, p_id_matricula, p_id_modulo, SYSDATE,
        p_tempo_gasto_minutos, 'EM_ANDAMENTO', p_nota
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Progresso registrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao registrar progresso: ' || SQLERRM);
        RAISE;
END sp_inserir_progresso;
/

-- ============================================================
-- PROCEDURE: Inserir Competência
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_competencia (
    p_nome_competencia IN VARCHAR2,
    p_descricao IN VARCHAR2,
    p_categoria IN VARCHAR2,
    p_nivel_mercado IN VARCHAR2 DEFAULT 'EM_ALTA'
) IS
    v_count NUMBER;
BEGIN
    -- Validar se já existe
    SELECT COUNT(*) INTO v_count FROM competencia WHERE nome_competencia = p_nome_competencia;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20100, 'Competência já cadastrada.');
    END IF;

    -- Validar categoria
    IF p_categoria NOT IN ('TECNOLOGIA', 'AUTOMACAO', 'GESTAO', 'SOFT_SKILLS') THEN
        RAISE_APPLICATION_ERROR(-20101, 'Categoria inválida. Use: TECNOLOGIA, AUTOMACAO, GESTAO ou SOFT_SKILLS');
    END IF;

    -- Inserir competência
    INSERT INTO competencia (
        id_competencia, nome_competencia, descricao,
        categoria, nivel_mercado, data_cadastro, status
    ) VALUES (
        seq_competencia.NEXTVAL, p_nome_competencia, p_descricao,
        p_categoria, p_nivel_mercado, SYSDATE, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Competência cadastrada com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar competência: ' || SQLERRM);
        RAISE;
END sp_inserir_competencia;
/

-- ============================================================
-- PROCEDURE: Associar Competência ao Funcionário
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_associar_competencia_funcionario (
    p_id_funcionario IN NUMBER,
    p_id_competencia IN NUMBER,
    p_nivel_proficiencia IN VARCHAR2
) IS
    v_count NUMBER;
BEGIN
    -- Validar funcionário
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE id_funcionario = p_id_funcionario;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20110, 'Funcionário não encontrado.');
    END IF;

    -- Validar competência
    SELECT COUNT(*) INTO v_count FROM competencia WHERE id_competencia = p_id_competencia;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20111, 'Competência não encontrada.');
    END IF;

    -- Validar nível
    IF p_nivel_proficiencia NOT IN ('BASICO', 'INTERMEDIARIO', 'AVANCADO', 'EXPERT') THEN
        RAISE_APPLICATION_ERROR(-20112, 'Nível inválido. Use: BASICO, INTERMEDIARIO, AVANCADO ou EXPERT');
    END IF;

    -- Verificar se já existe
    SELECT COUNT(*) INTO v_count
    FROM funcionario_competencia
    WHERE id_funcionario = p_id_funcionario AND id_competencia = p_id_competencia;

    IF v_count > 0 THEN
        -- Atualizar nível
        UPDATE funcionario_competencia
        SET nivel_proficiencia = p_nivel_proficiencia, data_validacao = SYSDATE
        WHERE id_funcionario = p_id_funcionario AND id_competencia = p_id_competencia;
    ELSE
        -- Inserir nova associação
        INSERT INTO funcionario_competencia (
            id_funcionario, id_competencia, nivel_proficiencia,
            data_aquisicao, data_validacao
        ) VALUES (
            p_id_funcionario, p_id_competencia, p_nivel_proficiencia,
            SYSDATE, SYSDATE
        );
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Competência associada ao funcionário com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao associar competência: ' || SQLERRM);
        RAISE;
END sp_associar_competencia_funcionario;
/

-- ============================================================
-- PROCEDURE: Inserir Certificado
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_certificado (
    p_id_matricula IN NUMBER,
    p_nota_final IN NUMBER,
    p_carga_horaria IN NUMBER
) IS
    v_count NUMBER;
    v_codigo_certificado VARCHAR2(50);
    v_id_funcionario NUMBER;
    v_id_curso NUMBER;
BEGIN
    -- Validar matrícula
    SELECT COUNT(*), MAX(id_funcionario), MAX(id_curso)
    INTO v_count, v_id_funcionario, v_id_curso
    FROM matricula
    WHERE id_matricula = p_id_matricula AND status = 'CONCLUIDO';

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20120, 'Matrícula não encontrada ou curso não concluído.');
    END IF;

    -- Validar nota
    IF p_nota_final < 0 OR p_nota_final > 10 THEN
        RAISE_APPLICATION_ERROR(-20121, 'Nota deve estar entre 0 e 10.');
    END IF;

    -- Gerar código único do certificado
    v_codigo_certificado := 'CERT-' || v_id_funcionario || '-' || v_id_curso || '-' ||
                           TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS');

    -- Inserir certificado
    INSERT INTO certificado (
        id_certificado, id_matricula, codigo_certificado,
        data_emissao, data_validade, nota_final,
        carga_horaria, status
    ) VALUES (
        seq_certificado.NEXTVAL, p_id_matricula, v_codigo_certificado,
        SYSDATE, ADD_MONTHS(SYSDATE, 24), p_nota_final,
        p_carga_horaria, 'ATIVO'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Certificado emitido com sucesso! Código: ' || v_codigo_certificado);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao emitir certificado: ' || SQLERRM);
        RAISE;
END sp_inserir_certificado;
/

-- ============================================================
-- PROCEDURE: Inserir Competição
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_competicao (
    p_id_empresa IN NUMBER,
    p_nome_competicao IN VARCHAR2,
    p_descricao IN VARCHAR2,
    p_data_inicio IN DATE,
    p_data_fim IN DATE,
    p_tipo_competicao IN VARCHAR2,
    p_meta_pontos IN NUMBER DEFAULT NULL
) IS
    v_count NUMBER;
BEGIN
    -- Validar empresa
    SELECT COUNT(*) INTO v_count FROM empresa WHERE id_empresa = p_id_empresa;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20130, 'Empresa não encontrada.');
    END IF;

    -- Validar datas
    IF p_data_fim <= p_data_inicio THEN
        RAISE_APPLICATION_ERROR(-20131, 'Data de fim deve ser posterior à data de início.');
    END IF;

    -- Validar tipo
    IF p_tipo_competicao NOT IN ('PONTUACAO', 'CONCLUSAO_CURSOS', 'VELOCIDADE', 'QUALIDADE') THEN
        RAISE_APPLICATION_ERROR(-20132, 'Tipo de competição inválido.');
    END IF;

    -- Inserir competição
    INSERT INTO competicao (
        id_competicao, id_empresa, nome_competicao, descricao,
        data_inicio, data_fim, tipo_competicao, meta_pontos, status
    ) VALUES (
        seq_competicao.NEXTVAL, p_id_empresa, p_nome_competicao, p_descricao,
        p_data_inicio, p_data_fim, p_tipo_competicao, p_meta_pontos, 'PLANEJADA'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Competição cadastrada com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao cadastrar competição: ' || SQLERRM);
        RAISE;
END sp_inserir_competicao;
/

-- ============================================================
-- PROCEDURE: Inserir Prêmio de Competição
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_inserir_premio_competicao (
    p_id_competicao IN NUMBER,
    p_id_time IN NUMBER DEFAULT NULL,
    p_id_funcionario IN NUMBER DEFAULT NULL,
    p_descricao_premio IN VARCHAR2,
    p_valor_premio IN NUMBER DEFAULT NULL,
    p_posicao IN NUMBER
) IS
    v_count NUMBER;
BEGIN
    -- Validar competição
    SELECT COUNT(*) INTO v_count FROM competicao WHERE id_competicao = p_id_competicao;
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20140, 'Competição não encontrada.');
    END IF;

    -- Validar que foi informado time OU funcionário (mas não ambos)
    IF (p_id_time IS NULL AND p_id_funcionario IS NULL) OR
       (p_id_time IS NOT NULL AND p_id_funcionario IS NOT NULL) THEN
        RAISE_APPLICATION_ERROR(-20141, 'Informe apenas ID do time OU ID do funcionário.');
    END IF;

    -- Validar posição
    IF p_posicao <= 0 THEN
        RAISE_APPLICATION_ERROR(-20142, 'Posição deve ser maior que zero.');
    END IF;

    -- Inserir prêmio
    INSERT INTO premio_competicao (
        id_premio, id_competicao, id_time, id_funcionario,
        descricao_premio, valor_premio, posicao, data_distribuicao
    ) VALUES (
        seq_premio.NEXTVAL, p_id_competicao, p_id_time, p_id_funcionario,
        p_descricao_premio, p_valor_premio, p_posicao, SYSDATE
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Prêmio registrado com sucesso!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao registrar prêmio: ' || SQLERRM);
        RAISE;
END sp_inserir_premio_competicao;
/

COMMIT;

-- ============================================================
-- FIM DAS PROCEDURES DE INSERÇÃO
-- ============================================================
