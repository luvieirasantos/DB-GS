# 🚀 Guia Rápido de Execução

## Opção 1: Usando SQLcl (Linha de Comando)

### Passo 1: Localizar o SQLcl

O SQLcl geralmente está em:
- `C:\oracle\sqlcl\bin\sql.exe`
- `C:\app\sqlcl\bin\sql.exe`
- Ou onde você descompactou o SQLcl

### Passo 2: Adicionar ao PATH (Opcional)

```cmd
# Windows - adicionar ao PATH
setx PATH "%PATH%;C:\caminho\para\sqlcl\bin"
```

### Passo 3: Executar Script Automático

```cmd
cd C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2
executar_todos_scripts.bat
```

**OU manualmente:**

```cmd
cd C:\caminho\para\sqlcl\bin

# Testar conexão
sql rm558935/310805@oracle.fiap.com.br:1521/ORCL @C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\database\00_test_connection.sql

# Executar scripts na ordem
sql rm558935/310805@oracle.fiap.com.br:1521/ORCL @C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\database\ddl\01_create_tables.sql
sql rm558935/310805@oracle.fiap.com.br:1521/ORCL @C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\database\triggers\01_auditoria_triggers.sql
# ... e assim por diante
```

---

## Opção 2: Usando Oracle SQL Developer (Recomendado)

### Passo 1: Abrir SQL Developer

1. Baixe em: https://www.oracle.com/tools/downloads/sqldev-downloads.html
2. Descompacte e execute `sqldeveloper.exe`

### Passo 2: Criar Conexão

1. Clique em **+** (Nova Conexão)
2. Preencha:
   - **Nome da Conexão**: FIAP Oracle
   - **Nome do Usuário**: `rm558935`
   - **Senha**: `310805`
   - **Nome do Host**: `oracle.fiap.com.br`
   - **Porta**: `1521`
   - **SID**: `ORCL`
3. Clique em **Testar**
4. Se OK, clique em **Conectar**

### Passo 3: Executar Scripts na Ordem

#### 1. Teste de Conexão
```
File > Abrir > database\00_test_connection.sql
Pressione F5 ou clique no ícone "Run Script"
```

#### 2. Criar Estrutura
```
File > Abrir > database\ddl\01_create_tables.sql
Pressione F5
```

#### 3. Criar Triggers
```
File > Abrir > database\triggers\01_auditoria_triggers.sql
Pressione F5
```

#### 4. Criar Procedures
```
File > Abrir > database\procedures\01_insert_procedures.sql
Pressione F5
```

#### 5. Criar Função JSON Manual
```
File > Abrir > database\functions\01_funcao_json_manual.sql
Pressione F5
```

#### 6. Criar Função de Validação
```
File > Abrir > database\functions\02_funcao_validacao_calculo.sql
Pressione F5
```

#### 7. Criar Package Gestão Usuários
```
File > Abrir > database\packages\01_pkg_gestao_usuarios.sql
Pressione F5
```

#### 8. Criar Package Gestão Cursos
```
File > Abrir > database\packages\02_pkg_gestao_cursos.sql
Pressione F5
```

#### 9. Criar Package Analytics
```
File > Abrir > database\packages\03_pkg_analytics.sql
Pressione F5
```

#### 10. Criar Procedure de Exportação
```
File > Abrir > database\procedures\02_export_dataset_json.sql
Pressione F5
```

#### 11. Inserir Dados - Parte 1
```
File > Abrir > database\data\01_inserir_dados.sql
Pressione F5
```

#### 12. Inserir Dados - Parte 2
```
File > Abrir > database\data\02_inserir_dados_parte2.sql
Pressione F5
```

#### 13. Validar Instalação
```
File > Abrir > database\validate_installation.sql
Pressione F5
```

---

## Opção 3: Executar Online (Oracle Live SQL)

1. Acesse: https://livesql.oracle.com/
2. Faça login ou crie uma conta
3. Cole o conteúdo de cada arquivo `.sql`
4. Execute na ordem

**Nota**: Live SQL tem limitações de tamanho, então execute em partes.

---

## ✅ Validar Instalação

Após executar todos os scripts, execute:

```sql
-- Contar tabelas
SELECT COUNT(*) as total_tabelas FROM user_tables;
-- Deve retornar 16

-- Contar procedures
SELECT COUNT(*) FROM user_procedures WHERE object_type = 'PROCEDURE';
-- Deve retornar 14+

-- Contar packages
SELECT COUNT(*) FROM user_objects WHERE object_type = 'PACKAGE';
-- Deve retornar 3

-- Contar triggers
SELECT COUNT(*) FROM user_triggers;
-- Deve retornar 10+

-- Contar dados
SELECT 'EMPRESA' as tabela, COUNT(*) as registros FROM empresa
UNION ALL SELECT 'FUNCIONARIO', COUNT(*) FROM funcionario
UNION ALL SELECT 'CURSO', COUNT(*) FROM curso
UNION ALL SELECT 'AUDITORIA', COUNT(*) FROM auditoria;
-- Todas devem ter 10+ registros
```

---

## 🧪 Testar Funções

```sql
-- Teste 1: Função de compatibilidade
SELECT fn_calcular_compatibilidade_curso(1, 1) FROM DUAL;

-- Teste 2: Função JSON
SET LONG 100000;
SELECT fn_gerar_perfil_funcionario_json(1) FROM DUAL;

-- Teste 3: Validação de dados
SELECT fn_validar_dados_cadastrais('CPF', '123.456.789-01') FROM DUAL;
SELECT fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br') FROM DUAL;

-- Teste 4: Package
SELECT pkg_analytics.obter_ranking_pontos_empresa(1, 5) FROM DUAL;
```

---

## 📊 Consultas Úteis

```sql
-- Top 5 funcionários
SELECT nome, pontos_acumulados
FROM funcionario
WHERE status = 'ATIVO'
ORDER BY pontos_acumulados DESC
FETCH FIRST 5 ROWS ONLY;

-- Cursos mais populares
SELECT c.nome_curso, COUNT(m.id_matricula) as matriculas
FROM curso c
LEFT JOIN matricula m ON c.id_curso = m.id_curso
GROUP BY c.nome_curso
ORDER BY matriculas DESC;

-- Competências em alta
SELECT nome_competencia, categoria, nivel_mercado
FROM competencia
WHERE nivel_mercado = 'EM_ALTA'
ORDER BY nome_competencia;
```

---

## ❌ Troubleshooting

### Erro: "ORA-00942: table or view does not exist"
**Solução**: Execute primeiro `database\ddl\01_create_tables.sql`

### Erro: "ORA-00955: name is already used by an existing object"
**Solução**: Objeto já existe. Pode ignorar ou fazer DROP antes.

### Erro: "ORA-01031: insufficient privileges"
**Solução**: Usuário sem privilégios. Contate o DBA ou use outro usuário.

### Erro: "ORA-12541: TNS:no listener"
**Solução**: Verifique se o host/porta estão corretos: `oracle.fiap.com.br:1521/ORCL`

### Warnings PLS-00323
**Solução**: É normal. Alguns objetos referenciam outros que ainda serão criados.

---

## 📞 Precisa de Ajuda?

1. Verifique o **README.md** para documentação completa
2. Consulte o **INSTALL.md** para guia detalhado
3. Execute **database/validate_installation.sql** para diagnóstico

---

## ⏱️ Tempo Estimado

- Execução de todos os scripts: **10-15 minutos**
- Validação e testes: **5 minutos**
- **Total: 15-20 minutos**

---

**Boa sorte! 🚀**
