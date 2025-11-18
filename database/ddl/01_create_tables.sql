-- ============================================================
-- Global Solution - Plataforma de Cursos Corporativa
-- O Futuro do Trabalho - Qualificação Tecnológica
-- ============================================================
-- Modelo de Dados em 3ª Forma Normal (3FN)
-- Banco de Dados: Oracle
-- ============================================================

-- Limpar objetos existentes (caso seja necessário recriar)
BEGIN
    FOR t IN (SELECT table_name FROM user_tables WHERE table_name IN (
        'AUDITORIA', 'PREMIO_COMPETICAO', 'COMPETICAO', 'CERTIFICADO',
        'FUNCIONARIO_COMPETENCIA', 'COMPETENCIA', 'PROGRESSO', 'MATRICULA',
        'MODULO', 'CURSO', 'CATEGORIA_CURSO', 'FUNCIONARIO_TIME', 'TIME',
        'FUNCIONARIO', 'GERENTE', 'EMPRESA'
    )) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- Limpar sequences existentes
BEGIN
    FOR s IN (SELECT sequence_name FROM user_sequences WHERE sequence_name LIKE 'SEQ_%') LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

-- ============================================================
-- SEQUENCES
-- ============================================================

CREATE SEQUENCE seq_empresa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_gerente START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_funcionario START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_time START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_categoria_curso START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_curso START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_modulo START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_matricula START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_progresso START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_competencia START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_certificado START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_competicao START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_premio START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1;

-- ============================================================
-- TABELA: EMPRESA
-- Armazena informações das empresas que contratam a plataforma
-- ============================================================
CREATE TABLE empresa (
    id_empresa NUMBER PRIMARY KEY,
    cnpj VARCHAR2(18) NOT NULL UNIQUE,
    razao_social VARCHAR2(200) NOT NULL,
    nome_fantasia VARCHAR2(200),
    email_corporativo VARCHAR2(100) NOT NULL,
    telefone VARCHAR2(20),
    data_cadastro DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT chk_empresa_status CHECK (status IN ('ATIVO', 'INATIVO', 'SUSPENSO')),
    CONSTRAINT chk_empresa_cnpj CHECK (REGEXP_LIKE(cnpj, '^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$'))
);

-- ============================================================
-- TABELA: GERENTE
-- Gerentes responsáveis por gerenciar times
-- ============================================================
CREATE TABLE gerente (
    id_gerente NUMBER PRIMARY KEY,
    id_empresa NUMBER NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    cpf VARCHAR2(14) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    telefone VARCHAR2(20),
    cargo VARCHAR2(100),
    data_cadastro DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT fk_gerente_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT chk_gerente_status CHECK (status IN ('ATIVO', 'INATIVO')),
    CONSTRAINT chk_gerente_cpf CHECK (REGEXP_LIKE(cpf, '^\d{3}\.\d{3}\.\d{3}-\d{2}$'))
);

-- ============================================================
-- TABELA: TIME
-- Times organizados pelos gerentes
-- ============================================================
CREATE TABLE time (
    id_time NUMBER PRIMARY KEY,
    id_gerente NUMBER NOT NULL,
    nome_time VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(500),
    data_criacao DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT fk_time_gerente FOREIGN KEY (id_gerente) REFERENCES gerente(id_gerente),
    CONSTRAINT chk_time_status CHECK (status IN ('ATIVO', 'INATIVO'))
);

-- ============================================================
-- TABELA: FUNCIONARIO
-- Funcionários que realizam os cursos
-- ============================================================
CREATE TABLE funcionario (
    id_funcionario NUMBER PRIMARY KEY,
    id_empresa NUMBER NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    cpf VARCHAR2(14) NOT NULL UNIQUE,
    email VARCHAR2(100) NOT NULL UNIQUE,
    telefone VARCHAR2(20),
    cargo VARCHAR2(100),
    nivel_atual VARCHAR2(50) DEFAULT 'INICIANTE',
    pontos_acumulados NUMBER DEFAULT 0,
    data_cadastro DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT fk_funcionario_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT chk_funcionario_status CHECK (status IN ('ATIVO', 'INATIVO', 'AFASTADO')),
    CONSTRAINT chk_funcionario_cpf CHECK (REGEXP_LIKE(cpf, '^\d{3}\.\d{3}\.\d{3}-\d{2}$')),
    CONSTRAINT chk_funcionario_nivel CHECK (nivel_atual IN ('INICIANTE', 'INTERMEDIARIO', 'AVANCADO', 'EXPERT')),
    CONSTRAINT chk_funcionario_pontos CHECK (pontos_acumulados >= 0)
);

-- ============================================================
-- TABELA: FUNCIONARIO_TIME
-- Relacionamento N:N entre Funcionário e Time
-- ============================================================
CREATE TABLE funcionario_time (
    id_funcionario NUMBER NOT NULL,
    id_time NUMBER NOT NULL,
    data_entrada DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT pk_funcionario_time PRIMARY KEY (id_funcionario, id_time),
    CONSTRAINT fk_funct_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
    CONSTRAINT fk_funct_time FOREIGN KEY (id_time) REFERENCES time(id_time),
    CONSTRAINT chk_funct_status CHECK (status IN ('ATIVO', 'INATIVO'))
);

-- ============================================================
-- TABELA: CATEGORIA_CURSO
-- Categorias dos cursos (Tecnologia, Automação, etc)
-- ============================================================
CREATE TABLE categoria_curso (
    id_categoria NUMBER PRIMARY KEY,
    nome_categoria VARCHAR2(100) NOT NULL UNIQUE,
    descricao VARCHAR2(500),
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT chk_categoria_status CHECK (status IN ('ATIVO', 'INATIVO'))
);

-- ============================================================
-- TABELA: CURSO
-- Cursos disponíveis na plataforma
-- ============================================================
CREATE TABLE curso (
    id_curso NUMBER PRIMARY KEY,
    id_categoria NUMBER NOT NULL,
    nome_curso VARCHAR2(200) NOT NULL,
    descricao VARCHAR2(1000),
    carga_horaria NUMBER NOT NULL,
    nivel_dificuldade VARCHAR2(50) NOT NULL,
    pontos_conclusao NUMBER DEFAULT 100,
    data_criacao DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT fk_curso_categoria FOREIGN KEY (id_categoria) REFERENCES categoria_curso(id_categoria),
    CONSTRAINT chk_curso_status CHECK (status IN ('ATIVO', 'INATIVO', 'EM_DESENVOLVIMENTO')),
    CONSTRAINT chk_curso_nivel CHECK (nivel_dificuldade IN ('INICIANTE', 'INTERMEDIARIO', 'AVANCADO')),
    CONSTRAINT chk_curso_carga CHECK (carga_horaria > 0),
    CONSTRAINT chk_curso_pontos CHECK (pontos_conclusao > 0)
);

-- ============================================================
-- TABELA: MODULO
-- Módulos que compõem os cursos
-- ============================================================
CREATE TABLE modulo (
    id_modulo NUMBER PRIMARY KEY,
    id_curso NUMBER NOT NULL,
    numero_modulo NUMBER NOT NULL,
    titulo VARCHAR2(200) NOT NULL,
    descricao VARCHAR2(1000),
    conteudo CLOB,
    duracao_minutos NUMBER NOT NULL,
    ordem NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT fk_modulo_curso FOREIGN KEY (id_curso) REFERENCES curso(id_curso),
    CONSTRAINT chk_modulo_status CHECK (status IN ('ATIVO', 'INATIVO')),
    CONSTRAINT chk_modulo_duracao CHECK (duracao_minutos > 0),
    CONSTRAINT uk_modulo_curso_numero UNIQUE (id_curso, numero_modulo)
);

-- ============================================================
-- TABELA: MATRICULA
-- Matrículas de funcionários em cursos
-- ============================================================
CREATE TABLE matricula (
    id_matricula NUMBER PRIMARY KEY,
    id_funcionario NUMBER NOT NULL,
    id_curso NUMBER NOT NULL,
    data_matricula DATE DEFAULT SYSDATE NOT NULL,
    data_inicio DATE,
    data_conclusao DATE,
    status VARCHAR2(20) DEFAULT 'EM_ANDAMENTO' NOT NULL,
    percentual_conclusao NUMBER DEFAULT 0,
    nota_final NUMBER,
    CONSTRAINT fk_matricula_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
    CONSTRAINT fk_matricula_curso FOREIGN KEY (id_curso) REFERENCES curso(id_curso),
    CONSTRAINT chk_matricula_status CHECK (status IN ('EM_ANDAMENTO', 'CONCLUIDO', 'CANCELADO', 'TRANCADO')),
    CONSTRAINT chk_matricula_percentual CHECK (percentual_conclusao BETWEEN 0 AND 100),
    CONSTRAINT chk_matricula_nota CHECK (nota_final IS NULL OR nota_final BETWEEN 0 AND 10),
    CONSTRAINT uk_matricula_func_curso UNIQUE (id_funcionario, id_curso)
);

-- ============================================================
-- TABELA: PROGRESSO
-- Progresso dos funcionários nos módulos
-- ============================================================
CREATE TABLE progresso (
    id_progresso NUMBER PRIMARY KEY,
    id_matricula NUMBER NOT NULL,
    id_modulo NUMBER NOT NULL,
    data_inicio DATE DEFAULT SYSDATE NOT NULL,
    data_conclusao DATE,
    tempo_gasto_minutos NUMBER DEFAULT 0,
    status VARCHAR2(20) DEFAULT 'EM_ANDAMENTO' NOT NULL,
    nota NUMBER,
    CONSTRAINT fk_progresso_matricula FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula),
    CONSTRAINT fk_progresso_modulo FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo),
    CONSTRAINT chk_progresso_status CHECK (status IN ('NAO_INICIADO', 'EM_ANDAMENTO', 'CONCLUIDO')),
    CONSTRAINT chk_progresso_tempo CHECK (tempo_gasto_minutos >= 0),
    CONSTRAINT chk_progresso_nota CHECK (nota IS NULL OR nota BETWEEN 0 AND 10),
    CONSTRAINT uk_progresso_matr_mod UNIQUE (id_matricula, id_modulo)
);

-- ============================================================
-- TABELA: COMPETENCIA
-- Competências técnicas e habilidades
-- ============================================================
CREATE TABLE competencia (
    id_competencia NUMBER PRIMARY KEY,
    nome_competencia VARCHAR2(100) NOT NULL UNIQUE,
    descricao VARCHAR2(500),
    categoria VARCHAR2(50) NOT NULL,
    nivel_mercado VARCHAR2(50) DEFAULT 'EM_ALTA',
    data_cadastro DATE DEFAULT SYSDATE NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT chk_competencia_status CHECK (status IN ('ATIVO', 'INATIVO')),
    CONSTRAINT chk_competencia_categoria CHECK (categoria IN ('TECNOLOGIA', 'AUTOMACAO', 'GESTAO', 'SOFT_SKILLS')),
    CONSTRAINT chk_competencia_mercado CHECK (nivel_mercado IN ('EM_ALTA', 'ESTAVEL', 'EM_BAIXA'))
);

-- ============================================================
-- TABELA: FUNCIONARIO_COMPETENCIA
-- Competências adquiridas pelos funcionários
-- ============================================================
CREATE TABLE funcionario_competencia (
    id_funcionario NUMBER NOT NULL,
    id_competencia NUMBER NOT NULL,
    nivel_proficiencia VARCHAR2(50) NOT NULL,
    data_aquisicao DATE DEFAULT SYSDATE NOT NULL,
    data_validacao DATE,
    CONSTRAINT pk_func_competencia PRIMARY KEY (id_funcionario, id_competencia),
    CONSTRAINT fk_funcomp_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
    CONSTRAINT fk_funcomp_competencia FOREIGN KEY (id_competencia) REFERENCES competencia(id_competencia),
    CONSTRAINT chk_funcomp_nivel CHECK (nivel_proficiencia IN ('BASICO', 'INTERMEDIARIO', 'AVANCADO', 'EXPERT'))
);

-- ============================================================
-- TABELA: CERTIFICADO
-- Certificados emitidos aos funcionários
-- ============================================================
CREATE TABLE certificado (
    id_certificado NUMBER PRIMARY KEY,
    id_matricula NUMBER NOT NULL,
    codigo_certificado VARCHAR2(50) NOT NULL UNIQUE,
    data_emissao DATE DEFAULT SYSDATE NOT NULL,
    data_validade DATE,
    nota_final NUMBER NOT NULL,
    carga_horaria NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'ATIVO' NOT NULL,
    CONSTRAINT fk_certificado_matricula FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula),
    CONSTRAINT chk_certificado_status CHECK (status IN ('ATIVO', 'REVOGADO', 'EXPIRADO')),
    CONSTRAINT chk_certificado_nota CHECK (nota_final BETWEEN 0 AND 10)
);

-- ============================================================
-- TABELA: COMPETICAO
-- Competições entre times
-- ============================================================
CREATE TABLE competicao (
    id_competicao NUMBER PRIMARY KEY,
    id_empresa NUMBER NOT NULL,
    nome_competicao VARCHAR2(200) NOT NULL,
    descricao VARCHAR2(1000),
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    tipo_competicao VARCHAR2(50) NOT NULL,
    meta_pontos NUMBER,
    status VARCHAR2(20) DEFAULT 'ATIVA' NOT NULL,
    CONSTRAINT fk_competicao_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa),
    CONSTRAINT chk_competicao_status CHECK (status IN ('PLANEJADA', 'ATIVA', 'FINALIZADA', 'CANCELADA')),
    CONSTRAINT chk_competicao_tipo CHECK (tipo_competicao IN ('PONTUACAO', 'CONCLUSAO_CURSOS', 'VELOCIDADE', 'QUALIDADE')),
    CONSTRAINT chk_competicao_datas CHECK (data_fim > data_inicio)
);

-- ============================================================
-- TABELA: PREMIO_COMPETICAO
-- Prêmios distribuídos nas competições
-- ============================================================
CREATE TABLE premio_competicao (
    id_premio NUMBER PRIMARY KEY,
    id_competicao NUMBER NOT NULL,
    id_time NUMBER,
    id_funcionario NUMBER,
    descricao_premio VARCHAR2(500) NOT NULL,
    valor_premio NUMBER,
    posicao NUMBER NOT NULL,
    data_distribuicao DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_premio_competicao FOREIGN KEY (id_competicao) REFERENCES competicao(id_competicao),
    CONSTRAINT fk_premio_time FOREIGN KEY (id_time) REFERENCES time(id_time),
    CONSTRAINT fk_premio_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
    CONSTRAINT chk_premio_posicao CHECK (posicao > 0),
    CONSTRAINT chk_premio_time_ou_func CHECK (
        (id_time IS NOT NULL AND id_funcionario IS NULL) OR
        (id_time IS NULL AND id_funcionario IS NOT NULL)
    )
);

-- ============================================================
-- TABELA: AUDITORIA
-- Tabela para registrar todas as operações (INSERT, UPDATE, DELETE)
-- ============================================================
CREATE TABLE auditoria (
    id_auditoria NUMBER PRIMARY KEY,
    tabela VARCHAR2(50) NOT NULL,
    operacao VARCHAR2(10) NOT NULL,
    usuario VARCHAR2(50) NOT NULL,
    data_operacao DATE DEFAULT SYSDATE NOT NULL,
    dados_antigos CLOB,
    dados_novos CLOB,
    ip_usuario VARCHAR2(50),
    CONSTRAINT chk_auditoria_operacao CHECK (operacao IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- ============================================================
-- ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS
-- ============================================================

-- Índices para melhorar performance de JOINs e consultas frequentes
CREATE INDEX idx_gerente_empresa ON gerente(id_empresa);
CREATE INDEX idx_time_gerente ON time(id_gerente);
CREATE INDEX idx_funcionario_empresa ON funcionario(id_empresa);
CREATE INDEX idx_funct_funcionario ON funcionario_time(id_funcionario);
CREATE INDEX idx_funct_time ON funcionario_time(id_time);
CREATE INDEX idx_curso_categoria ON curso(id_categoria);
CREATE INDEX idx_modulo_curso ON modulo(id_curso);
CREATE INDEX idx_matricula_funcionario ON matricula(id_funcionario);
CREATE INDEX idx_matricula_curso ON matricula(id_curso);
CREATE INDEX idx_progresso_matricula ON progresso(id_matricula);
CREATE INDEX idx_progresso_modulo ON progresso(id_modulo);
CREATE INDEX idx_funcomp_funcionario ON funcionario_competencia(id_funcionario);
CREATE INDEX idx_funcomp_competencia ON funcionario_competencia(id_competencia);
CREATE INDEX idx_certificado_matricula ON certificado(id_matricula);
CREATE INDEX idx_competicao_empresa ON competicao(id_empresa);
CREATE INDEX idx_premio_competicao ON premio_competicao(id_competicao);
CREATE INDEX idx_auditoria_tabela ON auditoria(tabela);
CREATE INDEX idx_auditoria_data ON auditoria(data_operacao);

-- Índices para campos de email (consultas frequentes)
CREATE INDEX idx_gerente_email ON gerente(email);
CREATE INDEX idx_funcionario_email ON funcionario(email);

-- Índices para status (filtros frequentes)
CREATE INDEX idx_empresa_status ON empresa(status);
CREATE INDEX idx_funcionario_status ON funcionario(status);
CREATE INDEX idx_matricula_status ON matricula(status);
CREATE INDEX idx_competicao_status ON competicao(status);

COMMIT;

-- ============================================================
-- FIM DO SCRIPT DE CRIAÇÃO DE TABELAS
-- ============================================================
