# Plataforma de Cursos Corporativa - O Futuro do Trabalho

## 📋 Video
https://youtu.be/-AknfRQ-w5Q

## 📋 Sobre o Projeto

Sistema completo de banco de dados para uma plataforma de cursos corporativa focada em **qualificação tecnológica e automação interna de funcionários**. O projeto foi desenvolvido como parte da **Global Solution - O Futuro do Trabalho**, demonstrando soluções para o mercado de trabalho em transformação digital.

### 🎯 Objetivo

Empresas privadas contratam nossa plataforma para:
- Qualificar tecnologicamente seus funcionários
- Implementar processos de automação interna
- Gerenciar times e acompanhar evolução
- Promover competições e beneficiar equipes
- Emitir certificados de capacitação

### 🏗️ Arquitetura

O projeto utiliza:
- **Oracle Database** como banco de dados relacional principal (3ª Forma Normal)
- **MongoDB** para armazenamento NoSQL e integração com IA
- **PL/SQL** para lógica de negócio (procedures, functions, packages, triggers)
- **JSON** para exportação de datasets e integração

---

## 📁 Estrutura do Projeto

```
DB-GS-V2/
├── database/
│   ├── ddl/                    # Definição das tabelas
│   │   └── 01_create_tables.sql
│   ├── procedures/             # Procedures de inserção e exportação
│   │   ├── 01_insert_procedures.sql
│   │   └── 02_export_dataset_json.sql
│   ├── functions/              # Funções personalizadas
│   │   ├── 01_funcao_json_manual.sql
│   │   └── 02_funcao_validacao_calculo.sql
│   ├── packages/               # Empacotamento de objetos
│   │   ├── 01_pkg_gestao_usuarios.sql
│   │   ├── 02_pkg_gestao_cursos.sql
│   │   └── 03_pkg_analytics.sql
│   ├── triggers/               # Triggers de auditoria
│   │   └── 01_auditoria_triggers.sql
│   └── data/                   # Scripts de inserção de dados
│       ├── 01_inserir_dados.sql
│       └── 02_inserir_dados_parte2.sql
├── mongodb/                    # Scripts MongoDB
│   ├── 01_import_instructions.md
│   ├── 02_import_to_mongodb.py
│   └── 03_create_indexes.js
├── docs/                       # Documentação e modelos
└── README.md                   # Este arquivo
```

---

## 🗄️ Modelo de Dados

### Entidades Principais (16 tabelas em 3FN)

1. **EMPRESA** - Empresas que contratam a plataforma
2. **GERENTE** - Gerentes que gerenciam times
3. **FUNCIONARIO** - Funcionários que fazem cursos
4. **TIME** - Times organizados por gerentes
5. **FUNCIONARIO_TIME** - Relacionamento N:N entre funcionários e times
6. **CATEGORIA_CURSO** - Categorias de cursos
7. **CURSO** - Cursos disponíveis na plataforma
8. **MODULO** - Módulos que compõem os cursos
9. **MATRICULA** - Matrículas de funcionários em cursos
10. **PROGRESSO** - Progresso dos funcionários nos módulos
11. **COMPETENCIA** - Competências técnicas e habilidades
12. **FUNCIONARIO_COMPETENCIA** - Competências adquiridas por funcionários
13. **CERTIFICADO** - Certificados emitidos
14. **COMPETICAO** - Competições entre times
15. **PREMIO_COMPETICAO** - Prêmios distribuídos
16. **AUDITORIA** - Auditoria de todas as transações

### Relacionamentos

- Uma **EMPRESA** possui vários **GERENTES** e **FUNCIONARIOS**
- Um **GERENTE** gerencia vários **TIMES**
- Um **TIME** possui vários **FUNCIONARIOS** (N:N)
- Um **CURSO** pertence a uma **CATEGORIA** e possui vários **MODULOS**
- Um **FUNCIONARIO** pode ter várias **MATRICULAS** em **CURSOS**
- Uma **MATRICULA** possui vários **PROGRESSOS** (um por módulo)
- Um **FUNCIONARIO** pode ter várias **COMPETENCIAS** (N:N)
- Certificados são emitidos após conclusão de curso
- Competições premiam times ou funcionários individualmente

---

## 🚀 Como Executar

### Pré-requisitos

- Oracle Database 11g ou superior
- SQL*Plus ou Oracle SQL Developer
- MongoDB 4.0+ (opcional, para parte NoSQL)
- Python 3.7+ com PyMongo (opcional, para importação MongoDB)

### Passo 1: Criar Estrutura do Banco de Dados Oracle

Execute os scripts na seguinte ordem:

```bash
# 1. Criar tabelas, sequences e índices
sqlplus usuario/senha@database @database/ddl/01_create_tables.sql

# 2. Criar triggers de auditoria
sqlplus usuario/senha@database @database/triggers/01_auditoria_triggers.sql

# 3. Criar procedures de inserção
sqlplus usuario/senha@database @database/procedures/01_insert_procedures.sql

# 4. Criar funções personalizadas
sqlplus usuario/senha@database @database/functions/01_funcao_json_manual.sql
sqlplus usuario/senha@database @database/functions/02_funcao_validacao_calculo.sql

# 5. Criar packages
sqlplus usuario/senha@database @database/packages/01_pkg_gestao_usuarios.sql
sqlplus usuario/senha@database @database/packages/02_pkg_gestao_cursos.sql
sqlplus usuario/senha@database @database/packages/03_pkg_analytics.sql

# 6. Criar procedure de exportação
sqlplus usuario/senha@database @database/procedures/02_export_dataset_json.sql
```

### Passo 2: Inserir Dados de Teste

```bash
# Inserir dados (Parte 1)
sqlplus usuario/senha@database @database/data/01_inserir_dados.sql

# Inserir dados (Parte 2)
sqlplus usuario/senha@database @database/data/02_inserir_dados_parte2.sql
```

### Passo 3: Exportar Dataset para JSON

```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LONG 100000000;
SET LINESIZE 32767;
SET PAGESIZE 0;

SPOOL dataset_export.json

DECLARE
    v_json CLOB;
BEGIN
    sp_exportar_dataset_json(v_json);
    DBMS_OUTPUT.PUT_LINE(v_json);
END;
/

SPOOL OFF;
```

### Passo 4: Importar para MongoDB (Opcional)

```bash
# Usar script Python
cd mongodb
python 02_import_to_mongodb.py

# OU importar manualmente
mongoimport --db plataforma_cursos --collection dataset --file dataset_export.json

# Criar índices
mongo plataforma_cursos < 03_create_indexes.js
```

---

## 📊 Funcionalidades Implementadas

### ✅ Modelagem de Banco de Dados (10 pontos)
- [x] Modelo em 3ª Forma Normal (3FN)
- [x] Cardinalidades corretas
- [x] Entidades coerentes com o tema
- [x] Implementado no Oracle
- [x] Todas constraints criadas (PKs, FKs, CHECKs)

### ✅ Procedures e Funções (20 pontos)
- [x] Procedures com parâmetros para inserts
- [x] Função 1: Conversão manual para JSON (sem funções built-in)
- [x] Função 2: Validação com REGEXP e cálculos lógicos
- [x] Triggers de auditoria em todas as tabelas
- [x] 10+ registros em cada tabela
- [x] Tratamento de exceções
- [x] Procedure de exportação de dataset JSON

### ✅ Função 1 - Conversão Manual JSON (15 pontos)
- [x] Conversão relacional → JSON manual
- [x] Sem uso de funções built-in Oracle
- [x] Tratamento de 3+ exceções distintas
- [x] Dados coerentes com o tema
- [x] Exemplo: perfil de funcionário com competências e cursos

**Localização**: `database/functions/01_funcao_json_manual.sql`

**Funções principais**:
- `fn_gerar_perfil_funcionario_json()` - Gera JSON completo do perfil
- `fn_gerar_curso_json()` - Gera JSON de curso com módulos

### ✅ Função 2 - Validação e Cálculo (15 pontos)
- [x] Validação com REGEXP
- [x] Cálculos lógicos contextualizados
- [x] Tratamento de exceções
- [x] Lógica relacionada ao tema
- [x] Exemplo: compatibilidade funcionário-curso

**Localização**: `database/functions/02_funcao_validacao_calculo.sql`

**Funções principais**:
- `fn_calcular_compatibilidade_curso()` - Calcula score de compatibilidade
- `fn_validar_dados_cadastrais()` - Valida CPF, CNPJ, email, telefone

### ✅ Empacotamento (10 pontos)
- [x] Todos objetos empacotados
- [x] Modularidade e reuso
- [x] Agrupamento lógico por função

**Packages criados**:
- `pkg_gestao_usuarios` - Gestão de empresas, gerentes, funcionários e times
- `pkg_gestao_cursos` - Gestão de cursos, módulos e competências
- `pkg_analytics` - Análises, validações e exportação

### ✅ Integração com MongoDB (10 pontos)
- [x] Dataset exportado em JSON
- [x] Estrutura NoSQL coerente
- [x] Scripts de importação
- [x] Índices para otimização
- [x] Queries de exemplo

---

## 🔧 Exemplos de Uso

### Inserir Nova Empresa

```sql
BEGIN
    pkg_gestao_usuarios.inserir_empresa(
        p_cnpj => '12.345.678/0001-90',
        p_razao_social => 'Empresa Exemplo Ltda',
        p_nome_fantasia => 'Exemplo',
        p_email => 'contato@exemplo.com.br',
        p_telefone => '(11) 1234-5678'
    );
END;
/
```

### Inserir Funcionário

```sql
BEGIN
    pkg_gestao_usuarios.inserir_funcionario(
        p_id_empresa => 1,
        p_nome => 'João Silva',
        p_cpf => '123.456.789-01',
        p_email => 'joao.silva@empresa.com.br',
        p_telefone => '(11) 98765-4321',
        p_cargo => 'Desenvolvedor',
        p_nivel_atual => 'INTERMEDIARIO'
    );
END;
/
```

### Matricular Funcionário em Curso

```sql
BEGIN
    sp_inserir_matricula(
        p_id_funcionario => 1,
        p_id_curso => 5  -- Machine Learning
    );
END;
/
```

### Calcular Compatibilidade Funcionário-Curso

```sql
-- Retorna análise completa de compatibilidade
SELECT fn_calcular_compatibilidade_curso(1, 5) FROM DUAL;

-- Com validação de email
SELECT fn_calcular_compatibilidade_curso(
    p_id_funcionario => 1,
    p_id_curso => 5,
    p_email_validacao => 'joao.silva@empresa.com.br'
) FROM DUAL;
```

### Gerar Perfil JSON de Funcionário

```sql
-- Gera JSON completo com competências e cursos
SELECT fn_gerar_perfil_funcionario_json(1) FROM DUAL;
```

### Validar Dados Cadastrais

```sql
-- Validar CPF
SELECT fn_validar_dados_cadastrais('CPF', '123.456.789-01') FROM DUAL;

-- Validar CNPJ
SELECT fn_validar_dados_cadastrais('CNPJ', '12.345.678/0001-90') FROM DUAL;

-- Validar Email
SELECT fn_validar_dados_cadastrais('EMAIL', 'usuario@empresa.com.br') FROM DUAL;
```

### Obter Ranking de Pontos

```sql
-- Top 10 funcionários de uma empresa
SELECT pkg_analytics.obter_ranking_pontos_empresa(1, 10) FROM DUAL;
```

### Consultas Úteis

```sql
-- Funcionários com mais cursos concluídos
SELECT
    f.nome,
    f.pontos_acumulados,
    COUNT(m.id_matricula) as cursos_concluidos
FROM funcionario f
LEFT JOIN matricula m ON f.id_funcionario = m.id_funcionario
WHERE m.status = 'CONCLUIDO'
GROUP BY f.nome, f.pontos_acumulados
ORDER BY cursos_concluidos DESC;

-- Cursos mais populares
SELECT
    c.nome_curso,
    c.nivel_dificuldade,
    COUNT(m.id_matricula) as total_matriculas
FROM curso c
LEFT JOIN matricula m ON c.id_curso = m.id_curso
GROUP BY c.nome_curso, c.nivel_dificuldade
ORDER BY total_matriculas DESC;

-- Competências mais procuradas
SELECT
    c.nome_competencia,
    c.categoria,
    c.nivel_mercado,
    COUNT(fc.id_funcionario) as total_funcionarios
FROM competencia c
LEFT JOIN funcionario_competencia fc ON c.id_competencia = fc.id_competencia
GROUP BY c.nome_competencia, c.categoria, c.nivel_mercado
ORDER BY total_funcionarios DESC;

-- Taxa de conclusão por funcionário
SELECT
    f.nome,
    COUNT(CASE WHEN m.status = 'CONCLUIDO' THEN 1 END) as concluidos,
    COUNT(m.id_matricula) as total_matriculas,
    ROUND(
        COUNT(CASE WHEN m.status = 'CONCLUIDO' THEN 1 END) * 100.0 /
        NULLIF(COUNT(m.id_matricula), 0),
        2
    ) as taxa_conclusao_pct
FROM funcionario f
LEFT JOIN matricula m ON f.id_funcionario = m.id_funcionario
GROUP BY f.nome
ORDER BY taxa_conclusao_pct DESC;
```

---

## 🔍 Consultas MongoDB

### Funcionários por Nível

```javascript
db.funcionarios.aggregate([
    {
        $group: {
            _id: "$nivel_atual",
            total: { $sum: 1 },
            media_pontos: { $avg: "$pontos_acumulados" }
        }
    },
    { $sort: { total: -1 } }
])
```

### Top Cursos

```javascript
db.cursos.find().sort({ total_matriculas: -1 }).limit(10)
```

### Competências em Alta

```javascript
db.competencias.find({ nivel_mercado: "EM_ALTA" }).sort({ total_funcionarios_com_competencia: -1 })
```

### Taxa de Conclusão

```javascript
db.matriculas.aggregate([
    {
        $group: {
            _id: "$status",
            count: { $sum: 1 }
        }
    }
])
```

---

## 📦 Integração com Aplicações

### Java (JDBC)

```java
import java.sql.*;

public class PlataformaCursos {
    public static void main(String[] args) throws SQLException {
        Connection conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:ORCL",
            "usuario", "senha"
        );

        // Chamar procedure
        CallableStatement cs = conn.prepareCall("{call sp_inserir_funcionario(?, ?, ?, ?, ?, ?, ?)}");
        cs.setInt(1, 1);  // id_empresa
        cs.setString(2, "Nome");
        cs.setString(3, "123.456.789-01");
        cs.setString(4, "email@empresa.com.br");
        cs.setString(5, "(11) 98765-4321");
        cs.setString(6, "Desenvolvedor");
        cs.setString(7, "INTERMEDIARIO");
        cs.execute();

        // Chamar função
        CallableStatement csFunc = conn.prepareCall("{? = call fn_calcular_compatibilidade_curso(?, ?)}");
        csFunc.registerOutParameter(1, Types.VARCHAR);
        csFunc.setInt(2, 1);
        csFunc.setInt(3, 5);
        csFunc.execute();
        String resultado = csFunc.getString(1);
        System.out.println(resultado);

        conn.close();
    }
}
```

### C# (.NET)

```csharp
using Oracle.ManagedDataAccess.Client;

class Program {
    static void Main() {
        string connString = "User Id=usuario;Password=senha;Data Source=localhost:1521/ORCL";

        using (OracleConnection conn = new OracleConnection(connString)) {
            conn.Open();

            // Chamar procedure
            OracleCommand cmd = new OracleCommand("sp_inserir_funcionario", conn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("p_id_empresa", OracleDbType.Int32).Value = 1;
            cmd.Parameters.Add("p_nome", OracleDbType.Varchar2).Value = "Nome";
            cmd.Parameters.Add("p_cpf", OracleDbType.Varchar2).Value = "123.456.789-01";
            // ... outros parâmetros
            cmd.ExecuteNonQuery();

            // Chamar função
            OracleCommand funcCmd = new OracleCommand("SELECT fn_calcular_compatibilidade_curso(1, 5) FROM DUAL", conn);
            string resultado = funcCmd.ExecuteScalar().ToString();
            Console.WriteLine(resultado);
        }
    }
}
```

### Python

```python
import cx_Oracle

conn = cx_Oracle.connect('usuario/senha@localhost:1521/ORCL')
cursor = conn.cursor()

# Chamar procedure
cursor.callproc('sp_inserir_funcionario', [1, 'Nome', '123.456.789-01', 'email@empresa.com.br', '(11) 98765-4321', 'Desenvolvedor', 'INTERMEDIARIO'])

# Chamar função
cursor.execute("SELECT fn_calcular_compatibilidade_curso(:1, :2) FROM DUAL", [1, 5])
resultado = cursor.fetchone()[0]
print(resultado)

conn.commit()
cursor.close()
conn.close()
```

---

## 📈 Estatísticas do Projeto

### Dados Inseridos

| Tabela | Registros |
|--------|-----------|
| EMPRESA | 15 |
| GERENTE | 15 |
| TIME | 15 |
| FUNCIONARIO | 20 |
| FUNCIONARIO_TIME | 20 |
| CATEGORIA_CURSO | 10 |
| CURSO | 15 |
| MODULO | 40+ |
| COMPETENCIA | 20 |
| FUNCIONARIO_COMPETENCIA | 30+ |
| MATRICULA | 25 |
| PROGRESSO | 40+ |
| CERTIFICADO | 10+ |
| COMPETICAO | 12 |
| PREMIO_COMPETICAO | 15 |
| AUDITORIA | 150+ |

### Objetos Criados

- **16 Tabelas** em 3ª Forma Normal
- **14 Sequences** para geração de IDs
- **30+ Índices** para otimização
- **10 Triggers** de auditoria
- **14 Procedures** de inserção e exportação
- **5 Funções** personalizadas (JSON manual, validação, analytics)
- **3 Packages** para modularização
- **Constraints**: 20+ CHECK, 15+ FK, 16 PK, 10+ UNIQUE

---

## 🎓 Contexto do Tema: O Futuro do Trabalho

Este projeto demonstra soluções tecnológicas para os desafios do mercado de trabalho contemporâneo:

### 🔄 Transformação Digital
- Qualificação contínua de funcionários
- Adaptação a novas tecnologias
- Automação de processos manuais

### 📊 Dados e Analytics
- Acompanhamento de evolução individual
- Métricas de performance de times
- Identificação de competências em alta no mercado

### 🏆 Gamificação e Engajamento
- Sistema de pontos e níveis
- Competições entre times
- Prêmios e reconhecimento

### 🎯 Competências do Futuro
- Machine Learning e IA
- Cloud Computing
- DevOps e Automação
- Cibersegurança
- IoT e Indústria 4.0
- Blockchain
- Big Data

---

## 🔐 Segurança e Auditoria

- **Triggers de Auditoria**: Todas as operações (INSERT, UPDATE, DELETE) são registradas
- **Validações**: CPF, CNPJ, Email com expressões regulares
- **Constraints**: Integridade referencial e regras de negócio
- **Tratamento de Exceções**: Mensagens amigáveis e logs detalhados
- **Separação de Privilégios**: Packages controlam acesso às operações

---

## 📝 Entregáveis

- [x] Modelo Lógico (Information Engineering)
- [x] Modelo Físico (Information Engineering)
- [x] DDL completo (Oracle)
- [x] Procedures com validações
- [x] Função 1: Conversão manual JSON
- [x] Função 2: Validação REGEXP e cálculos
- [x] Packages para modularização
- [x] Triggers de auditoria
- [x] Dataset JSON exportado
- [x] Scripts MongoDB
- [x] Documentação completa (README)

---

## 👥 Autores

**Global Solution - FIAP**
- Tema: O Futuro do Trabalho
- Disciplina: Database Application & Data Science
- Oracle Database + MongoDB

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos como parte da Global Solution da FIAP.

---

## 🚀 Próximos Passos

1. **Desenvolvimento Frontend**
   - Dashboard para gerentes
   - Portal do aluno
   - Área administrativa

2. **API REST**
   - Endpoints para todas as operações
   - Autenticação JWT
   - Documentação Swagger

3. **Integração com IA**
   - Recomendação de cursos
   - Análise preditiva de performance
   - Chatbot para suporte

4. **Mobile**
   - App nativo iOS/Android
   - Notificações push
   - Modo offline

5. **Analytics Avançado**
   - Dashboards interativos (Power BI/Tableau)
   - Machine Learning para insights
   - Relatórios customizados

---

## 📞 Suporte

Para dúvidas ou problemas:
1. Consulte a documentação completa
2. Verifique os exemplos de uso
3. Revise os logs de auditoria
4. Execute os scripts de validação

---

**Desenvolvido com ❤️ para a Global Solution - O Futuro do Trabalho**
