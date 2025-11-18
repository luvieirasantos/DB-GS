# 🚀 Guia de Instalação e Execução

## Instruções Passo a Passo para Executar o Projeto Completo

---

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [ ] Oracle Database 11g ou superior
- [ ] SQL*Plus ou Oracle SQL Developer
- [ ] Python 3.7+ (opcional, para MongoDB)
- [ ] MongoDB 4.0+ (opcional, para parte NoSQL)

---

## 🔧 Passo 1: Preparar o Ambiente Oracle

### 1.1 Conectar ao Oracle

```bash
# Via SQL*Plus
sqlplus usuario/senha@localhost:1521/ORCL

# OU via SQL Developer
# Abrir SQL Developer e criar conexão
```

### 1.2 Verificar Privilégios

```sql
-- Verificar se usuário tem privilégios necessários
SELECT * FROM user_sys_privs;
SELECT * FROM user_tab_privs;

-- Privilégios recomendados:
-- CREATE TABLE, CREATE PROCEDURE, CREATE TRIGGER, CREATE SEQUENCE
```

---

## 📦 Passo 2: Executar Scripts na Ordem Correta

### 2.1 Criar Estrutura de Tabelas (OBRIGATÓRIO)

```bash
# Via SQL*Plus (substitua usuario/senha)
cd database/ddl
sqlplus usuario/senha@localhost:1521/ORCL @01_create_tables.sql
```

**O que este script faz:**
- Cria 16 tabelas em 3FN
- Cria 14 sequences para IDs automáticos
- Cria constraints (PKs, FKs, CHECKs, UNIQUEs)
- Cria índices para otimização

**Tempo estimado:** 2-3 minutos

---

### 2.2 Criar Triggers de Auditoria (OBRIGATÓRIO)

```bash
cd ../triggers
sqlplus usuario/senha@localhost:1521/ORCL @01_auditoria_triggers.sql
```

**O que este script faz:**
- Cria 10 triggers que registram todas operações (INSERT, UPDATE, DELETE)
- Alimenta tabela AUDITORIA automaticamente

**Tempo estimado:** 1-2 minutos

---

### 2.3 Criar Procedures de Inserção (OBRIGATÓRIO)

```bash
cd ../procedures
sqlplus usuario/senha@localhost:1521/ORCL @01_insert_procedures.sql
```

**O que este script faz:**
- Cria 14 procedures com validações
- Permite inserção segura de dados
- Valida CPF, CNPJ, Email com REGEXP

**Tempo estimado:** 2-3 minutos

---

### 2.4 Criar Funções Personalizadas (OBRIGATÓRIO)

```bash
cd ../functions

# Função 1: Conversão manual para JSON
sqlplus usuario/senha@localhost:1521/ORCL @01_funcao_json_manual.sql

# Função 2: Validação e cálculo
sqlplus usuario/senha@localhost:1521/ORCL @02_funcao_validacao_calculo.sql
```

**O que estes scripts fazem:**
- **Função 1**: Converte dados relacionais em JSON SEM usar funções built-in
- **Função 2**: Calcula compatibilidade funcionário-curso com REGEXP

**Tempo estimado:** 2-3 minutos

---

### 2.5 Criar Packages (OBRIGATÓRIO)

```bash
cd ../packages

# Package 1: Gestão de Usuários
sqlplus usuario/senha@localhost:1521/ORCL @01_pkg_gestao_usuarios.sql

# Package 2: Gestão de Cursos
sqlplus usuario/senha@localhost:1521/ORCL @02_pkg_gestao_cursos.sql

# Package 3: Analytics
sqlplus usuario/senha@localhost:1521/ORCL @03_pkg_analytics.sql
```

**O que estes scripts fazem:**
- Empacotam procedures e funções
- Organizam código de forma modular
- Facilitam reuso e manutenção

**Tempo estimado:** 2-3 minutos

---

### 2.6 Criar Procedure de Exportação JSON (OBRIGATÓRIO)

```bash
cd ../procedures
sqlplus usuario/senha@localhost:1521/ORCL @02_export_dataset_json.sql
```

**O que este script faz:**
- Cria procedure para exportar dataset completo em JSON
- Usado para integração com MongoDB

**Tempo estimado:** 1 minuto

---

### 2.7 Inserir Dados de Teste (OBRIGATÓRIO)

```bash
cd ../data

# Parte 1: Empresas, Gerentes, Times, Funcionários, Cursos, Módulos
sqlplus usuario/senha@localhost:1521/ORCL @01_inserir_dados.sql

# Parte 2: Competências, Matrículas, Progressos, Certificados, Competições
sqlplus usuario/senha@localhost:1521/ORCL @02_inserir_dados_parte2.sql
```

**O que estes scripts fazem:**
- Inserem 10+ registros em CADA tabela usando procedures
- Criam dados realistas sobre "O Futuro do Trabalho"
- Populam todas as 16 tabelas

**Tempo estimado:** 5-10 minutos

**IMPORTANTE:** Execute os scripts NA ORDEM! O script parte 2 depende do parte 1.

---

## ✅ Passo 3: Validar a Instalação

### 3.1 Verificar Objetos Criados

```sql
-- Conectar ao Oracle
sqlplus usuario/senha@localhost:1521/ORCL

-- Verificar tabelas
SELECT table_name FROM user_tables ORDER BY table_name;
-- Deve retornar 16 tabelas

-- Verificar procedures
SELECT object_name FROM user_procedures WHERE object_type = 'PROCEDURE' ORDER BY object_name;

-- Verificar funções
SELECT object_name FROM user_procedures WHERE object_type = 'FUNCTION' ORDER BY object_name;

-- Verificar packages
SELECT object_name FROM user_objects WHERE object_type = 'PACKAGE' ORDER BY object_name;
-- Deve retornar 3 packages

-- Verificar triggers
SELECT trigger_name FROM user_triggers ORDER BY trigger_name;
-- Deve retornar 10+ triggers
```

### 3.2 Verificar Dados Inseridos

```sql
-- Contar registros em cada tabela
SELECT 'EMPRESA' as tabela, COUNT(*) as total FROM empresa
UNION ALL
SELECT 'GERENTE', COUNT(*) FROM gerente
UNION ALL
SELECT 'TIME', COUNT(*) FROM time
UNION ALL
SELECT 'FUNCIONARIO', COUNT(*) FROM funcionario
UNION ALL
SELECT 'FUNCIONARIO_TIME', COUNT(*) FROM funcionario_time
UNION ALL
SELECT 'CATEGORIA_CURSO', COUNT(*) FROM categoria_curso
UNION ALL
SELECT 'CURSO', COUNT(*) FROM curso
UNION ALL
SELECT 'MODULO', COUNT(*) FROM modulo
UNION ALL
SELECT 'COMPETENCIA', COUNT(*) FROM competencia
UNION ALL
SELECT 'FUNCIONARIO_COMPETENCIA', COUNT(*) FROM funcionario_competencia
UNION ALL
SELECT 'MATRICULA', COUNT(*) FROM matricula
UNION ALL
SELECT 'PROGRESSO', COUNT(*) FROM progresso
UNION ALL
SELECT 'CERTIFICADO', COUNT(*) FROM certificado
UNION ALL
SELECT 'COMPETICAO', COUNT(*) FROM competicao
UNION ALL
SELECT 'PREMIO_COMPETICAO', COUNT(*) FROM premio_competicao
UNION ALL
SELECT 'AUDITORIA', COUNT(*) FROM auditoria;
```

**Resultado esperado:**
- Todas as tabelas devem ter 10 ou mais registros
- AUDITORIA deve ter 100+ registros (gerados automaticamente pelos triggers)

---

## 🧪 Passo 4: Testar as Funções

### 4.1 Testar Função de JSON Manual

```sql
SET SERVEROUTPUT ON;
SET LONG 100000;
SET LINESIZE 200;

-- Gerar JSON do perfil de um funcionário
SELECT fn_gerar_perfil_funcionario_json(1) FROM DUAL;

-- Deve retornar JSON completo com competências e cursos
```

### 4.2 Testar Função de Compatibilidade

```sql
SET SERVEROUTPUT ON;

-- Calcular compatibilidade funcionário-curso
SELECT fn_calcular_compatibilidade_curso(1, 1) FROM DUAL;

-- Deve retornar relatório com score e recomendação
```

### 4.3 Testar Validação de Dados

```sql
-- Validar CPF
SELECT fn_validar_dados_cadastrais('CPF', '123.456.789-01') FROM DUAL;

-- Validar Email
SELECT fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br') FROM DUAL;
```

### 4.4 Testar Packages

```sql
-- Usar package de gestão de usuários
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total de funcionários na empresa 1: ' ||
                        pkg_gestao_usuarios.obter_total_funcionarios(1));
END;
/

-- Usar package de analytics
DECLARE
    v_json CLOB;
BEGIN
    v_json := pkg_analytics.obter_ranking_pontos_empresa(1, 5);
    DBMS_OUTPUT.PUT_LINE(v_json);
END;
/
```

---

## 📤 Passo 5: Exportar Dataset para JSON (Opcional)

### 5.1 Exportar JSON

```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LONG 100000000;
SET LONGCHUNKSIZE 100000000;
SET LINESIZE 32767;
SET PAGESIZE 0;
SET FEEDBACK OFF;
SET HEADING OFF;

-- Definir onde salvar (ajuste o caminho)
SPOOL C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\mongodb\dataset_export.json

DECLARE
    v_json CLOB;
BEGIN
    sp_exportar_dataset_json(v_json);
    DBMS_OUTPUT.PUT_LINE(v_json);
END;
/

SPOOL OFF;
```

**Resultado:** Arquivo `dataset_export.json` criado com todo o dataset.

---

## 🍃 Passo 6: Importar para MongoDB (Opcional)

### 6.1 Verificar MongoDB Rodando

```bash
# Windows
net start MongoDB

# Linux/Mac
sudo service mongod start

# Verificar status
mongo --eval "db.adminCommand('ping')"
```

### 6.2 Executar Script Python de Importação

```bash
cd mongodb
pip install pymongo

# Executar importador
python 02_import_to_mongodb.py
```

**O que o script faz:**
- Conecta ao MongoDB local
- Cria banco `plataforma_cursos`
- Importa dados do JSON para coleções separadas
- Cria índices automaticamente
- Exibe estatísticas

### 6.3 Criar Índices Manualmente (Alternativa)

```bash
# Se preferir criar índices manualmente
mongo plataforma_cursos < 03_create_indexes.js
```

### 6.4 Verificar Importação

```bash
mongo plataforma_cursos

# No shell do MongoDB:
db.empresas.count()
db.funcionarios.count()
db.cursos.count()

# Consulta de exemplo
db.funcionarios.find().sort({ pontos_acumulados: -1 }).limit(5)
```

---

## 🎯 Resumo dos Comandos (Quick Start)

```bash
# 1. Criar estrutura
cd database/ddl && sqlplus usuario/senha@db @01_create_tables.sql

# 2. Criar triggers
cd ../triggers && sqlplus usuario/senha@db @01_auditoria_triggers.sql

# 3. Criar procedures
cd ../procedures && sqlplus usuario/senha@db @01_insert_procedures.sql

# 4. Criar funções
cd ../functions
sqlplus usuario/senha@db @01_funcao_json_manual.sql
sqlplus usuario/senha@db @02_funcao_validacao_calculo.sql

# 5. Criar packages
cd ../packages
sqlplus usuario/senha@db @01_pkg_gestao_usuarios.sql
sqlplus usuario/senha@db @02_pkg_gestao_cursos.sql
sqlplus usuario/senha@db @03_pkg_analytics.sql

# 6. Criar exportação
cd ../procedures && sqlplus usuario/senha@db @02_export_dataset_json.sql

# 7. Inserir dados
cd ../data
sqlplus usuario/senha@db @01_inserir_dados.sql
sqlplus usuario/senha@db @02_inserir_dados_parte2.sql

# 8. MongoDB (opcional)
cd ../../mongodb && python 02_import_to_mongodb.py
```

---

## ⚠️ Troubleshooting

### Erro: "Table or view does not exist"
- **Causa:** Executou scripts fora de ordem
- **Solução:** Execute `01_create_tables.sql` primeiro

### Erro: "Insufficient privileges"
- **Causa:** Usuário sem permissões
- **Solução:** Execute como SYSTEM ou peça privilégios ao DBA

### Erro: "Object already exists"
- **Causa:** Executou script duas vezes
- **Solução:** Use DROP ou execute o cleanup no início de `01_create_tables.sql`

### Erro: "Invalid identifier"
- **Causa:** Tabela não existe ou nome errado
- **Solução:** Verifique se `01_create_tables.sql` foi executado

### Warnings PLS-00323
- **Causa:** Procedure/função referencia objeto que será criado depois
- **Solução:** É normal, ignore ou recompile depois

### MongoDB: "Connection refused"
- **Causa:** MongoDB não está rodando
- **Solução:** `sudo service mongod start` ou `net start MongoDB`

---

## ✅ Checklist Final

Após executar tudo, você deve ter:

- [x] 16 tabelas criadas
- [x] 14 sequences criadas
- [x] 10 triggers de auditoria
- [x] 14 procedures de inserção
- [x] 5 funções (2 principais + 3 auxiliares)
- [x] 3 packages
- [x] 10+ registros em CADA tabela
- [x] 100+ registros na tabela AUDITORIA
- [x] Arquivo JSON exportado (opcional)
- [x] Dados no MongoDB (opcional)

---

## 🎓 Próximos Passos

1. Explore os dados:
   ```sql
   SELECT * FROM funcionario ORDER BY pontos_acumulados DESC;
   SELECT * FROM curso ORDER BY id_curso;
   ```

2. Teste as funções e procedures

3. Analise a auditoria:
   ```sql
   SELECT * FROM auditoria ORDER BY data_operacao DESC;
   ```

4. Integre com sua aplicação Java/C#/Mobile

5. Crie dashboards e visualizações

---

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs de erros do Oracle
2. Consulte o README.md principal
3. Revise a ordem de execução dos scripts
4. Verifique privilégios do usuário

---

**Boa sorte com o projeto! 🚀**
