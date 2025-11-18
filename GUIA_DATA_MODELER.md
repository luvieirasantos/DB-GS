# 📐 GUIA COMPLETO - ORACLE DATA MODELER

## Passo a Passo para Criar Modelos Lógico e Físico

**Tempo Estimado**: 30-45 minutos
**Objetivo**: Gerar Modelo Lógico e Físico em PDF e JPG (Notação Information Engineering)

---

## 📋 PREPARAÇÃO

### Informações da Conexão (ANOTE!)
```
Host: oracle.fiap.com.br
Porta: 1521
SID: ORCL
Usuário: RM558935
Senha: 310805
```

### O que você vai criar:
1. ✅ Modelo Lógico PDF (Information Engineering)
2. ✅ Modelo Lógico JPG (Information Engineering)
3. ✅ Modelo Físico PDF (Information Engineering)
4. ✅ Modelo Físico JPG (Information Engineering)

---

## 🚀 PARTE 1: ABRIR E CONFIGURAR DATA MODELER

### Passo 1: Abrir Oracle Data Modeler

1. **Abrir o programa**:
   - Procure por "Oracle SQL Developer Data Modeler" no menu Iniciar
   - OU navegue até a pasta de instalação e execute `datamodeler.exe`
   - Aguarde o programa carregar (pode demorar 30-60 segundos)

2. **Primeira tela**:
   - Se aparecer tela de boas-vindas/tutorial: clique em **"Close"** ou **"X"**
   - Você verá a interface principal vazia

---

### Passo 2: Criar Conexão com o Banco Oracle

**ATENÇÃO**: Esta é a parte mais importante!

1. **Abrir janela de conexões**:
   - Vá no menu superior: **View** → **Data Modeler** → **Browser**
   - OU clique no ícone de "Browser" na barra de ferramentas
   - Uma janela lateral "Browser" aparecerá

2. **Criar nova conexão**:
   - Na janela "Browser", procure a aba **"Data Dictionary"**
   - Clique com botão direito em qualquer lugar vazio
   - Selecione: **"New Connection"** ou **"Add Connection"**

3. **Preencher dados da conexão**:
   ```
   Connection Name: FIAP_Oracle
   Username: RM558935
   Password: 310805

   ☐ Save Password (MARCAR esta caixa!)

   Connection Type: Basic
   Hostname: oracle.fiap.com.br
   Port: 1521
   SID: ORCL
   ```

4. **Testar conexão**:
   - Clique no botão **"Test Connection"**
   - Deve aparecer: **"Status: Success"** ✅
   - Se der erro, verifique:
     - Todos os dados estão corretos?
     - Você está conectado à internet?
     - Firewall não está bloqueando?

5. **Salvar conexão**:
   - Clique em **"Connect"** ou **"OK"**
   - A conexão aparecerá na lista

---

## 🔄 PARTE 2: ENGENHARIA REVERSA (IMPORTAR TABELAS)

### Passo 3: Iniciar Engenharia Reversa

1. **Abrir wizard de importação**:
   - Menu superior: **File** → **Import** → **Data Dictionary**
   - OU: **Engineering** → **Engineer to Relational Model**
   - Uma janela "Import from Data Dictionary" abrirá

2. **Selecionar conexão**:
   - Na janela que abriu, procure: **"Connection:"**
   - No dropdown, selecione: **FIAP_Oracle** (a conexão que você criou)
   - Clique em **"Next"** ou **"Avançar"**

---

### Passo 4: Selecionar Objetos para Importar

**ATENÇÃO**: Aqui você escolhe quais tabelas importar!

1. **Tela de seleção**:
   - Você verá uma lista de schemas/usuários
   - Procure e expanda: **RM558935** (seu usuário)

2. **Selecionar TODAS as tabelas do projeto**:

   **Marque SOMENTE estas 16 tabelas** (use Ctrl+Click para seleção múltipla):
   ```
   ☑ AUDITORIA
   ☑ CATEGORIA_CURSO
   ☑ CERTIFICADO
   ☑ COMPETENCIA
   ☑ COMPETICAO
   ☑ CURSO
   ☑ EMPRESA
   ☑ FUNCIONARIO
   ☑ FUNCIONARIO_COMPETENCIA
   ☑ FUNCIONARIO_TIME
   ☑ GERENTE
   ☑ MATRICULA
   ☑ MODULO
   ☑ PREMIO_COMPETICAO
   ☑ PROGRESSO
   ☑ TIME
   ```

3. **IMPORTANTE - Importar relacionamentos**:
   - Procure opção: **"Import Foreign Keys"** → ✅ MARCAR
   - Procure opção: **"Import Indexes"** → ✅ MARCAR
   - Procure opção: **"Import Constraints"** → ✅ MARCAR

4. **Avançar**:
   - Clique em **"Next"** ou **"Finish"**
   - Aguarde a importação (pode demorar 10-30 segundos)

---

### Passo 5: Verificar Importação

1. **Verificar se tabelas foram importadas**:
   - Na janela "Browser" (lado esquerdo), expanda:
     - **Relational Models**
     - Verá um modelo com nome automático (ex: "Model_1")
   - Expanda o modelo
   - Deve ver as 16 tabelas listadas ✅

2. **Se não aparecer diagrama**:
   - Clique duplo no nome do modelo
   - OU clique direito → **"Show"**
   - O diagrama deve aparecer na área central

---

## 📊 PARTE 3: CRIAR MODELO LÓGICO

### Passo 6: Gerar Modelo Lógico

1. **Converter para Modelo Lógico**:
   - Menu superior: **Engineering** → **Engineer to Logical Model**
   - OU: Botão direito no modelo relacional → **"Engineer to Logical Model"**

2. **Wizard de conversão**:
   - Marque TODAS as tabelas (Ctrl+A)
   - Opções:
     - ✅ Create New Logical Model
     - ✅ Include Foreign Keys
     - ✅ Include Constraints
   - Clique em **"Engineer"** ou **"OK"**

3. **Modelo Lógico criado**:
   - Na janela "Browser", expanda: **Logical Models**
   - Verá "Logical_1" ou similar
   - Clique duplo para visualizar

---

### Passo 7: Organizar Diagrama Lógico

**IMPORTANTE**: O diagrama pode estar desorganizado!

1. **Auto-organizar diagrama**:
   - Com o diagrama aberto, clique no menu:
     - **Diagram** → **Auto Layout**
     - OU clique no ícone de "Auto Layout" (ícone de árvore)

2. **Escolher layout**:
   - Selecione: **"Hierarchical Layout"** (melhor para ER)
   - OU: **"Orthogonal Layout"**
   - Clique em **"Apply"**

3. **Ajustes manuais** (opcional):
   - Arraste entidades para melhor posição
   - Zoom: Ctrl + Scroll do mouse
   - Ajuste para caber na página

---

### Passo 8: Configurar Notação Information Engineering

**CRUCIAL**: Requisito pede notação IE!

1. **Configurar notação do modelo**:
   - Com diagrama lógico aberto
   - Menu: **Tools** → **Preferences**
   - OU: **Edit** → **Preferences**

2. **Na janela Preferences**:
   - No menu à esquerda, expanda: **Diagram** → **Logical**
   - Clique em: **"Notation"**

3. **Selecionar Information Engineering**:
   - No dropdown "Notation:", selecione: **"Information Engineering"** ou **"IE Notation"**
   - Clique em **"OK"**

4. **Verificar mudança**:
   - O diagrama deve mudar para notação IE (pé de galinha nos relacionamentos)
   - Se não mudou, clique direito no diagrama → **"Notation"** → **"Information Engineering"**

---

### Passo 9: Exportar Modelo Lógico (PDF e JPG)

#### Exportar PDF:

1. **Exportar para PDF**:
   - Com diagrama lógico aberto
   - Menu: **File** → **Export** → **To PDF**
   - OU: **File** → **Print Diagram** → **PDF**

2. **Configurar PDF**:
   - Nome do arquivo: `Modelo_Logico_Plataforma_Cursos.pdf`
   - Local: `C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\`
   - Opções:
     - ✅ Fit to Page (ajustar à página)
     - Orientação: **Landscape** (paisagem)
     - Tamanho: **A3** ou **A4** (se couber)
   - Clique em **"Save"** ou **"Export"**

#### Exportar JPG:

1. **Exportar para imagem**:
   - Menu: **File** → **Export** → **To Image**

2. **Configurar imagem**:
   - Formato: **JPG** ou **PNG**
   - Nome: `Modelo_Logico_Plataforma_Cursos.jpg`
   - Local: `C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\`
   - Resolução: **300 DPI** (alta qualidade)
   - Clique em **"Save"**

---

## 🗄️ PARTE 4: CRIAR MODELO FÍSICO

### Passo 10: Verificar Modelo Físico (Relacional)

**BOA NOTÍCIA**: O modelo físico JÁ FOI CRIADO na engenharia reversa!

1. **Localizar modelo físico**:
   - Na janela "Browser", expanda: **Relational Models**
   - Você verá o modelo criado na importação
   - Este É o modelo físico! ✅

2. **Abrir diagrama físico**:
   - Clique duplo no modelo relacional
   - OU clique direito → **"Show"**

---

### Passo 11: Configurar Notação IE no Modelo Físico

**REPETIR configuração de notação**:

1. **Configurar para IE**:
   - Com diagrama físico/relacional aberto
   - Menu: **Tools** → **Preferences** → **Diagram** → **Relational** → **Notation**
   - Selecione: **"Information Engineering"**
   - Clique em **"OK"**

2. **Auto-organizar** (se necessário):
   - **Diagram** → **Auto Layout** → **Hierarchical Layout**

---

### Passo 12: Exportar Modelo Físico (PDF e JPG)

#### Exportar PDF:

1. **Exportar para PDF**:
   - Com diagrama físico aberto
   - Menu: **File** → **Export** → **To PDF**

2. **Configurar**:
   - Nome: `Modelo_Fisico_Plataforma_Cursos.pdf`
   - Local: `C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\`
   - Orientação: **Landscape**
   - Tamanho: **A3** ou **A4**
   - Clique em **"Save"**

#### Exportar JPG:

1. **Exportar imagem**:
   - Menu: **File** → **Export** → **To Image**

2. **Configurar**:
   - Formato: **JPG**
   - Nome: `Modelo_Fisico_Plataforma_Cursos.jpg`
   - Local: `C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\`
   - Resolução: **300 DPI**
   - Clique em **"Save"**

---

## ✅ PARTE 5: VALIDAÇÃO FINAL

### Passo 13: Verificar Arquivos Criados

Navegue até: `C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\`

Você DEVE ter 4 arquivos:

```
✅ Modelo_Logico_Plataforma_Cursos.pdf
✅ Modelo_Logico_Plataforma_Cursos.jpg
✅ Modelo_Fisico_Plataforma_Cursos.pdf
✅ Modelo_Fisico_Plataforma_Cursos.jpg
```

---

### Passo 14: Validar Conteúdo dos Arquivos

#### Modelo Lógico deve ter:
- ✅ Entidades (retângulos)
- ✅ Atributos listados dentro das entidades
- ✅ Relacionamentos com notação "pé de galinha" (IE)
- ✅ Cardinalidades visíveis (1:N, N:N)
- ✅ Nomes das entidades claros

#### Modelo Físico deve ter:
- ✅ Tabelas (com nome exato do banco)
- ✅ Colunas com tipos de dados (VARCHAR2, NUMBER, DATE)
- ✅ PKs marcadas (geralmente em negrito ou com ícone de chave)
- ✅ FKs marcadas
- ✅ Relacionamentos entre tabelas

---

## 🎨 DICAS DE MELHORIAS (OPCIONAL)

### Se quiser melhorar a aparência:

1. **Adicionar título ao diagrama**:
   - Clique em **Insert** → **Text Box**
   - Digite: "Modelo Lógico - Plataforma de Cursos Corporativa"
   - Posicione no topo do diagrama

2. **Adicionar legendas**:
   - Adicione caixa de texto explicando:
     - Notação: Information Engineering
     - Data: 18/11/2025
     - Projeto: Global Solution - O Futuro do Trabalho

3. **Cores** (opcional):
   - Clique direito em uma entidade → **Format**
   - Escolha cores suaves para diferenciar grupos
   - Ex: Azul para entidades de usuários, Verde para cursos

4. **Ajustar zoom para impressão**:
   - **View** → **Zoom to Fit**
   - Garante que tudo apareça no PDF

---

## 📤 PARTE 6: ORGANIZAR ENTREGÁVEIS

### Passo 15: Criar Pasta de Documentação

1. **Criar pasta** (se não existe):
   ```
   C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\
   ```

2. **Mover arquivos para lá**:
   - Modelo_Logico_Plataforma_Cursos.pdf
   - Modelo_Logico_Plataforma_Cursos.jpg
   - Modelo_Fisico_Plataforma_Cursos.pdf
   - Modelo_Fisico_Plataforma_Cursos.jpg

3. **Criar README na pasta docs** (opcional):
   ```markdown
   # Documentação - Diagramas

   ## Modelos de Dados

   - **Modelo Lógico**: Representa entidades e relacionamentos de forma conceitual
   - **Modelo Físico**: Representa a implementação real no Oracle Database
   - **Notação**: Information Engineering (IE)

   ### Arquivos:
   1. Modelo_Logico_Plataforma_Cursos.pdf
   2. Modelo_Logico_Plataforma_Cursos.jpg
   3. Modelo_Fisico_Plataforma_Cursos.pdf
   4. Modelo_Fisico_Plataforma_Cursos.jpg
   ```

---

## 🎯 CHECKLIST FINAL

Antes de entregar, verifique:

### Arquivos Criados:
- [ ] Modelo_Logico_Plataforma_Cursos.pdf
- [ ] Modelo_Logico_Plataforma_Cursos.jpg
- [ ] Modelo_Fisico_Plataforma_Cursos.pdf
- [ ] Modelo_Fisico_Plataforma_Cursos.jpg

### Conteúdo dos Modelos:
- [ ] 16 tabelas/entidades presentes
- [ ] Notação Information Engineering (IE) aplicada
- [ ] Relacionamentos visíveis com cardinalidades
- [ ] PKs e FKs marcadas (modelo físico)
- [ ] Atributos/colunas listados
- [ ] Diagramas legíveis (não muito pequenos)
- [ ] Qualidade de imagem boa (300 DPI no JPG)

### Validação Técnica:
- [ ] Modelo Lógico mostra conceito (entidades, relacionamentos)
- [ ] Modelo Físico mostra implementação (tabelas, tipos, constraints)
- [ ] Ambos estão em notação IE
- [ ] Todos relacionamentos corretos (1:N, N:N)

---

## 🚨 TROUBLESHOOTING

### Problema: Não consigo conectar ao banco
**Solução**:
1. Verifique se está conectado à internet
2. Teste conexão usando SQLcl primeiro
3. Verifique firewall
4. Tente porta 1521 ou 1522

---

### Problema: Diagrama muito pequeno/ilegível
**Solução**:
1. Use **View** → **Zoom to Fit**
2. Exporte em tamanho A3 em vez de A4
3. Aumente DPI da imagem para 600
4. Divida em múltiplas páginas se necessário

---

### Problema: Notação não muda para IE
**Solução**:
1. Vá em **Tools** → **Preferences** → **Diagram** → **Relational/Logical**
2. Procure "Notation" no menu à esquerda
3. Selecione "Information Engineering"
4. Reinicie o diagrama (feche e abra novamente)

---

### Problema: Faltam relacionamentos
**Solução**:
1. Na importação, certifique-se de marcar "Import Foreign Keys"
2. Reimporte do banco
3. OU adicione manualmente: clique direito → **New Relationship**

---

### Problema: Exportação PDF não funciona
**Solução**:
1. Tente **File** → **Print Diagram** → **Print to PDF**
2. OU use ferramenta de captura de tela
3. OU exporte como PNG/JPG e converta para PDF online

---

### Problema: Muitas tabelas de outros projetos aparecem
**Solução**:
1. Na importação, selecione APENAS as 16 tabelas do projeto
2. Use Ctrl+Click para seleção múltipla
3. Desmarque "Select All"

---

## 📝 OBSERVAÇÕES IMPORTANTES

### Diferença entre Modelo Lógico e Físico:

**Modelo Lógico**:
- Mostra ENTIDADES (conceitos)
- Relacionamentos mais abstratos
- Foco em REGRAS DE NEGÓCIO
- Exemplo: "FUNCIONARIO" relaciona-se com "EMPRESA"

**Modelo Físico**:
- Mostra TABELAS (implementação)
- Tipos de dados específicos (VARCHAR2, NUMBER)
- Constraints implementadas (PKs, FKs, CHECKs)
- Exemplo: "FUNCIONARIO.ID_EMPRESA (NUMBER) → EMPRESA.ID_EMPRESA (NUMBER)"

---

### Notação Information Engineering (IE):

Características:
- ✅ Relacionamentos em "pé de galinha" (crow's foot)
- ✅ Cardinalidade clara (1, N, 0..1, 0..N)
- ✅ PKs em negrito ou com ícone de chave
- ✅ FKs marcadas com seta

Exemplo visual:
```
EMPRESA ----< FUNCIONARIO
(Um)         (Muitos)
```

---

## 🎓 RESUMO DO QUE VOCÊ FEZ

1. ✅ Conectou ao Oracle Database da FIAP
2. ✅ Importou 16 tabelas via engenharia reversa
3. ✅ Gerou Modelo Lógico automaticamente
4. ✅ Configurou notação IE em ambos modelos
5. ✅ Organizou diagramas automaticamente
6. ✅ Exportou 4 arquivos (2 PDFs + 2 JPGs)
7. ✅ Validou conformidade com requisitos

---

## 🎉 PARABÉNS!

Você completou **100% DOS REQUISITOS** da Global Solution!

### Entregáveis Finais:
- ✅ Modelo Lógico PDF ✅
- ✅ Modelo Lógico JPG ✅
- ✅ Modelo Físico PDF ✅
- ✅ Modelo Físico JPG ✅
- ✅ Código SQL completo ✅
- ✅ Procedures e Functions ✅
- ✅ MongoDB integrado ✅
- ✅ Documentação completa ✅
- ✅ Testes validados (77/77) ✅

---

## 📞 PRECISA DE AJUDA?

Se tiver qualquer problema, consulte:
1. Este guia novamente (releia a seção específica)
2. Documentação Oracle Data Modeler
3. Vídeos no YouTube: "Oracle Data Modeler Tutorial"

---

**PROJETO 100% COMPLETO! 🚀**

**Boa sorte na entrega e na apresentação!**
