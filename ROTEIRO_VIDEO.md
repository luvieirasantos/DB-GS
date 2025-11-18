# 🎬 Roteiro para Vídeo - Plataforma de Cursos Corporativa

## Duração Estimada: 5-7 minutos

---

## 📋 ESTRUTURA DO VÍDEO

### 1. INTRODUÇÃO (30 segundos)
**[TELA: Você falando para a câmera]**

**FALA:**
> "Olá! Neste vídeo vou apresentar meu projeto de banco de dados para a Global Solution da FIAP com o tema 'O Futuro do Trabalho'. Desenvolvi uma Plataforma de Cursos Corporativa completa usando Oracle Database e PL/SQL, com mais de 80 objetos criados. Vamos ver como funciona!"

**TEXTO NA TELA:**
- Global Solution - O Futuro do Trabalho
- Plataforma de Cursos Corporativa
- Oracle Database + PL/SQL

---

### 2. VISÃO GERAL DO PROJETO (30 segundos)
**[TELA: Mostrar pasta do projeto no Windows Explorer]**

**FALA:**
> "O projeto está completamente organizado com documentação, scripts DDL, procedures, functions, packages, triggers e dados de teste. Vou mostrar a estrutura:"

**AÇÕES:**
1. Abrir pasta `DB-GS-V2`
2. Mostrar rapidamente as pastas:
   - `database/` (apontar com mouse)
   - `mongodb/` (apontar)
   - `docs/` (apontar)
3. Abrir `database/` e mostrar subpastas:
   - `ddl/`, `triggers/`, `procedures/`, `functions/`, `packages/`, `data/`

**FALA (continuação):**
> "Temos DDL para criar tabelas, triggers para auditoria, procedures para inserção, functions personalizadas e packages para organização modular."

---

### 3. MODELO DE DADOS (40 segundos)
**[TELA: Abrir README.md ou mostrar diagrama se tiver]**

**FALA:**
> "O modelo de dados está em 3ª Forma Normal com 16 tabelas relacionadas. A plataforma permite que empresas contratem o serviço para capacitar seus funcionários em tecnologias do futuro."

**AÇÕES:**
1. Scroll pelo README.md mostrando:
   - Seção "Modelo de Dados"
   - Lista das 16 tabelas
   - Relacionamentos

**FALA (continuação):**
> "Temos empresas com gerentes e funcionários organizados em times, cursos divididos em módulos, sistema de competências, matrículas, certificados, competições e um sistema completo de auditoria."

---

### 4. EXECUTANDO A INSTALAÇÃO (1 minuto)
**[TELA: Terminal/SQLcl]**

**FALA:**
> "Vou agora conectar no banco Oracle da FIAP e executar a validação para mostrar que está tudo instalado."

**AÇÕES:**
1. Abrir terminal
2. Executar:
```bash
cd C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\database
sql rm558935/310805@//oracle.fiap.com.br:1521/ORCL
```

3. Aguardar conexão aparecer

**FALA:**
> "Conectado! Agora vou executar o script de validação que verifica todos os objetos criados."

4. Executar:
```sql
@validate_installation.sql
```

**AÇÕES (durante execução):**
- Deixar rolar e ir comentando:

**FALA:**
> "Vejam: está validando as 16 tabelas... os 14 sequences... os 10 triggers de auditoria... as procedures... as functions... os 3 packages... e os dados inseridos. Todas as verificações estão passando com sucesso!"

5. Quando aparecer o resultado final, dar um zoom:

**FALA:**
> "77 verificações realizadas, 77 com sucesso, 0 erros! Instalação 100% validada!"

---

### 5. DEMONSTRAÇÃO DAS FUNCIONALIDADES (2 minutos)

#### 5.1 Validação de Dados (20 segundos)
**[TELA: SQLcl]**

**FALA:**
> "Primeira funcionalidade: validação de dados cadastrais usando expressões regulares."

**AÇÕES:**
1. Executar:
```sql
SELECT fn_validar_dados_cadastrais('CPF', '123.456.789-01') FROM DUAL;
```

**FALA:**
> "Validando um CPF... VÁLIDO!"

2. Executar:
```sql
SELECT fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br') FROM DUAL;
```

**FALA:**
> "Email... VÁLIDO! A função valida também CNPJ e telefone."

---

#### 5.2 Compatibilidade Funcionário-Curso (30 segundos)
**[TELA: SQLcl]**

**FALA:**
> "Segunda funcionalidade: cálculo inteligente de compatibilidade entre funcionário e curso. Essa função analisa o nível do funcionário, sua experiência e competências."

**AÇÕES:**
1. Executar:
```sql
SELECT fn_calcular_compatibilidade_curso(1, 1) FROM DUAL;
```

**FALA (enquanto executa):**
> "Calculando compatibilidade do funcionário 1 com o curso 1..."

2. Quando aparecer o resultado, apontar para as partes importantes:

**FALA:**
> "Vejam! A função retorna uma análise completa: score de nível, score de experiência, score de competências... Score total de 70 pontos sobre 100, compatibilidade de 70%, e a recomendação é RECOMENDADO. Tudo calculado automaticamente!"

---

#### 5.3 Ranking e Estatísticas (30 segundos)
**[TELA: SQLcl]**

**FALA:**
> "Agora vou mostrar o ranking de funcionários com mais pontos."

**AÇÕES:**
1. Executar:
```sql
SELECT ROWNUM as pos, nome, cargo, nivel_atual, pontos_acumulados
FROM (SELECT * FROM funcionario WHERE status = 'ATIVO' ORDER BY pontos_acumulados DESC)
WHERE ROWNUM <= 5;
```

**FALA:**
> "Temos o Marcelo Reis em primeiro lugar com 350 pontos, Felipe Souza em segundo com 320... O sistema gamifica o aprendizado!"

---

#### 5.4 Geração de JSON Manual (30 segundos)
**[TELA: SQLcl]**

**FALA:**
> "Uma das funcionalidades mais importantes: geração de JSON completamente manual, sem usar nenhuma função built-in do Oracle. Isso foi um requisito do projeto."

**AÇÕES:**
1. Executar:
```sql
SET LONG 100000
SELECT fn_gerar_perfil_funcionario_json(1) FROM DUAL;
```

**FALA (enquanto aparece o JSON):**
> "Vejam! A função gera um JSON completo do perfil do funcionário com todas suas informações, competências e cursos. Tudo feito manualmente concatenando strings!"

---

#### 5.5 Sistema de Auditoria (20 segundos)
**[TELA: SQLcl]**

**FALA:**
> "O sistema possui auditoria completa. Todas as operações são registradas automaticamente por triggers."

**AÇÕES:**
1. Executar:
```sql
SELECT tabela, operacao, COUNT(*) as total
FROM auditoria
GROUP BY tabela, operacao
ORDER BY total DESC
FETCH FIRST 5 ROWS ONLY;
```

**FALA:**
> "Vejam: 235 operações auditadas automaticamente! Toda modificação no banco é registrada com usuário, data e hora."

---

### 6. ARQUITETURA E PACKAGES (40 segundos)
**[TELA: SQL Developer ou mostrar código no VS Code]**

**FALA:**
> "O código está organizado em 3 packages para facilitar manutenção e reuso."

**AÇÕES:**
1. Mostrar lista de packages no SQL Developer ou abrir arquivo de package

**FALA:**
> "Package 1: Gestão de Usuários - gerencia empresas, gerentes, funcionários e times. Package 2: Gestão de Cursos - gerencia cursos, módulos e competências. Package 3: Analytics - fornece análises, relatórios e exportação de dados."

2. Se possível, abrir um package e mostrar rapidamente a estrutura:

**FALA:**
> "Cada package tem sua especificação e body, seguindo as melhores práticas de desenvolvimento PL/SQL."

---

### 7. DADOS E RELATÓRIOS (30 segundos)
**[TELA: SQLcl]**

**FALA:**
> "Vou mostrar alguns dados interessantes do sistema."

**AÇÕES:**
1. Executar:
```sql
SELECT
    'Empresas' as metrica, COUNT(*) as total FROM empresa WHERE status = 'ATIVO'
UNION ALL SELECT 'Funcionários', COUNT(*) FROM funcionario WHERE status = 'ATIVO'
UNION ALL SELECT 'Cursos', COUNT(*) FROM curso WHERE status = 'ATIVO'
UNION ALL SELECT 'Matrículas', COUNT(*) FROM matricula
UNION ALL SELECT 'Certificados', COUNT(*) FROM certificado WHERE status = 'ATIVO';
```

**FALA:**
> "15 empresas cadastradas, 20 funcionários ativos, 15 cursos disponíveis, 25 matrículas realizadas e 9 certificados já emitidos. O sistema está completamente populado e funcional!"

---

### 8. INTEGRAÇÃO COM MONGODB (30 segundos - OPCIONAL)
**[TELA: Mostrar pasta mongodb/]**

**FALA:**
> "O projeto também possui integração com MongoDB. Criei uma procedure que exporta todo o dataset em JSON e scripts Python para importar no MongoDB."

**AÇÕES:**
1. Mostrar arquivos na pasta `mongodb/`:
   - `02_import_to_mongodb.py`
   - `03_create_indexes.js`

**FALA:**
> "Isso permite usar o Oracle como banco transacional e o MongoDB para analytics e integração com sistemas de IA."

---

### 9. DOCUMENTAÇÃO (20 segundos)
**[TELA: Mostrar arquivos README, INSTALL, etc]**

**FALA:**
> "Todo o projeto está completamente documentado."

**AÇÕES:**
1. Mostrar arquivos:
   - README.md (abrir rapidamente e scrollar)
   - INSTALL.md
   - GUIA_RAPIDO_EXECUCAO.md
   - RELATORIO_TESTES.md

**FALA:**
> "Tenho README completo explicando o projeto, guia de instalação passo a passo, guia rápido de execução e relatório completo de testes com 77 validações."

---

### 10. CONCLUSÃO (30 segundos)
**[TELA: Você falando para câmera]**

**FALA:**
> "Resumindo: criei uma Plataforma de Cursos Corporativa completa com 16 tabelas em 3FN, 15 procedures, 4 functions incluindo validação com REGEXP e geração de JSON manual, 3 packages modulares, 10 triggers de auditoria, sistema de certificação, gamificação com pontos e competições, e integração com MongoDB. Tudo funcionando, testado e documentado!"

**TEXTO NA TELA (aparecer enquanto fala):**
```
✅ 16 Tabelas em 3FN
✅ 15 Procedures + 4 Functions
✅ 3 Packages Modulares
✅ 10 Triggers de Auditoria
✅ JSON Manual (sem built-in)
✅ Validação com REGEXP
✅ Sistema de Certificação
✅ Integração MongoDB
✅ 77/77 Testes Aprovados
✅ 100% Documentado
```

**FALA (final):**
> "Obrigado por assistir! Todo o código está disponível e pronto para uso. Este projeto demonstra como a tecnologia pode transformar o futuro do trabalho através da capacitação contínua!"

---

## 🎥 DICAS DE GRAVAÇÃO

### Preparação Antes de Gravar:
1. ✅ Feche todas as abas e janelas desnecessárias
2. ✅ Aumente o zoom do terminal (Ctrl + scroll ou ajustar fonte para 16-18pt)
3. ✅ Deixe os arquivos preparados em abas/janelas separadas
4. ✅ Teste sua conexão com o banco antes
5. ✅ Limpe o histórico do terminal (cls/clear)
6. ✅ Configure gravação de tela + webcam (lado a lado ou picture-in-picture)

### Durante a Gravação:
1. ✅ Fale de forma clara e pausada
2. ✅ Use o mouse para apontar coisas importantes na tela
3. ✅ Faça pausas de 1-2 segundos ao trocar de tela
4. ✅ Se errar, não tem problema! Continue ou recomece aquela seção
5. ✅ Sorria e demonstre entusiasmo pelo projeto

### Ferramentas Sugeridas:
- **Gravação**: OBS Studio (gratuito), Camtasia, ou Loom
- **Edição**: DaVinci Resolve (gratuito), Camtasia, ou CapCut
- **Resolução**: 1920x1080 (Full HD)
- **FPS**: 30fps é suficiente
- **Audio**: Use fone com microfone ou microfone USB

### Edição Pós-Produção:
1. ✅ Adicione intro com título do projeto (5 segundos)
2. ✅ Adicione música de fundo suave (baixo volume)
3. ✅ Acelere partes onde está esperando comando executar (1.5x-2x)
4. ✅ Adicione zoom em textos pequenos
5. ✅ Adicione legendas/textos destacando pontos importantes
6. ✅ Adicione outro final com seus dados (nome, RM, turma)

---

## 📊 CHECKLIST PRÉ-GRAVAÇÃO

- [ ] Conexão com banco Oracle funcionando
- [ ] Todos os objetos instalados (rodar validate_installation.sql)
- [ ] Terminal configurado com fonte grande
- [ ] Arquivos abertos e organizados
- [ ] Software de gravação testado
- [ ] Microfone testado
- [ ] Iluminação adequada (se aparecer no vídeo)
- [ ] Roteiro impresso ou em tela secundária
- [ ] Água por perto (para não ficar com boca seca)

---

## ⏱️ CRONOGRAMA DETALHADO

| Seção | Tempo | Acumulado |
|-------|-------|-----------|
| 1. Introdução | 0:30 | 0:30 |
| 2. Visão Geral | 0:30 | 1:00 |
| 3. Modelo de Dados | 0:40 | 1:40 |
| 4. Instalação/Validação | 1:00 | 2:40 |
| 5.1 Validação Dados | 0:20 | 3:00 |
| 5.2 Compatibilidade | 0:30 | 3:30 |
| 5.3 Ranking | 0:30 | 4:00 |
| 5.4 JSON Manual | 0:30 | 4:30 |
| 5.5 Auditoria | 0:20 | 4:50 |
| 6. Packages | 0:40 | 5:30 |
| 7. Dados/Relatórios | 0:30 | 6:00 |
| 8. MongoDB (opcional) | 0:30 | 6:30 |
| 9. Documentação | 0:20 | 6:50 |
| 10. Conclusão | 0:30 | 7:20 |

**Tempo Total: 6-7 minutos** (sem MongoDB: 5-6 minutos)

---

## 🎬 COMANDOS PRONTOS PARA COPIAR/COLAR

### Conexão:
```bash
cd C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\database
sql rm558935/310805@//oracle.fiap.com.br:1521/ORCL
```

### Validação:
```sql
@validate_installation.sql
```

### Testes:
```sql
-- Validação CPF
SELECT fn_validar_dados_cadastrais('CPF', '123.456.789-01') FROM DUAL;

-- Validação Email
SELECT fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br') FROM DUAL;

-- Compatibilidade
SELECT fn_calcular_compatibilidade_curso(1, 1) FROM DUAL;

-- Ranking
SELECT ROWNUM as pos, nome, cargo, nivel_atual, pontos_acumulados
FROM (SELECT * FROM funcionario WHERE status = 'ATIVO' ORDER BY pontos_acumulados DESC)
WHERE ROWNUM <= 5;

-- JSON
SET LONG 100000
SELECT fn_gerar_perfil_funcionario_json(1) FROM DUAL;

-- Auditoria
SELECT tabela, operacao, COUNT(*) as total
FROM auditoria
GROUP BY tabela, operacao
ORDER BY total DESC
FETCH FIRST 5 ROWS ONLY;

-- Estatísticas
SELECT 'Empresas' as metrica, COUNT(*) as total FROM empresa WHERE status = 'ATIVO'
UNION ALL SELECT 'Funcionários', COUNT(*) FROM funcionario WHERE status = 'ATIVO'
UNION ALL SELECT 'Cursos', COUNT(*) FROM curso WHERE status = 'ATIVO'
UNION ALL SELECT 'Matrículas', COUNT(*) FROM matricula
UNION ALL SELECT 'Certificados', COUNT(*) FROM certificado WHERE status = 'ATIVO';
```

---

## 💡 DICAS EXTRAS

### Se o vídeo estiver ficando longo:
- Remova a seção MongoDB (opcional)
- Combine seções 5.3 e 5.4
- Acelere a edição nas partes de execução de scripts

### Se quiser adicionar impacto:
- Adicione transições suaves entre seções
- Use música de fundo épica na conclusão
- Adicione efeitos de "check" ✅ quando mostrar validações

### Para YouTube:
- **Título**: "Plataforma de Cursos Corporativa - Oracle Database + PL/SQL | Global Solution FIAP"
- **Descrição**: Incluir link do GitHub (se publicar), tecnologias usadas, e resumo do projeto
- **Tags**: Oracle, PL/SQL, Database, FIAP, Global Solution, SQL, Banco de Dados

---

**BOA SORTE COM A GRAVAÇÃO! 🎬🚀**
