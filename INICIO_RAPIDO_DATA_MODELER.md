# ⚡ INÍCIO RÁPIDO - DATA MODELER (5 MINUTOS)

## Versão Resumida para Criar os Diagramas Rapidamente

---

## 🎯 OBJETIVO

Criar 4 arquivos em 30 minutos:
1. Modelo_Logico.pdf
2. Modelo_Logico.jpg
3. Modelo_Fisico.pdf
4. Modelo_Fisico.jpg

---

## 📝 DADOS DA CONEXÃO (COPIE!)

```
Connection Name: FIAP_Oracle
Username: RM558935
Password: 310805
Hostname: oracle.fiap.com.br
Port: 1521
SID: ORCL
```

---

## 🚀 PASSO A PASSO RÁPIDO

### 1️⃣ ABRIR DATA MODELER (30 seg)

- Abra "Oracle SQL Developer Data Modeler"
- Feche janelas de boas-vindas
- Pronto!

---

### 2️⃣ CRIAR CONEXÃO (2 min)

```
1. Menu: View → Data Modeler → Browser
2. Aba "Data Dictionary"
3. Botão direito → New Connection
4. Preencher dados (copie acima)
5. Marcar ☑ "Save Password"
6. Test Connection → deve dar Success ✅
7. Connect
```

---

### 3️⃣ IMPORTAR TABELAS (3 min)

```
1. Menu: File → Import → Data Dictionary
2. Connection: FIAP_Oracle
3. Next
4. Expandir usuário: RM558935
5. Marcar APENAS estas 16 tabelas:
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

6. Marcar:
   ☑ Import Foreign Keys
   ☑ Import Indexes
   ☑ Import Constraints

7. Next/Finish
8. Aguardar (20-30 seg)
```

---

### 4️⃣ CRIAR MODELO LÓGICO (2 min)

```
1. Menu: Engineering → Engineer to Logical Model
2. Marcar todas tabelas (Ctrl+A)
3. ☑ Create New Logical Model
4. ☑ Include Foreign Keys
5. Engineer
6. Aguardar criação
```

---

### 5️⃣ CONFIGURAR NOTAÇÃO IE (1 min)

**Para MODELO LÓGICO**:
```
1. Abrir diagrama lógico (duplo clique em "Logical" no Browser)
2. Menu: Tools → Preferences
3. Diagram → Logical → Notation
4. Selecionar: "Information Engineering"
5. OK
```

**Para MODELO FÍSICO**:
```
1. Abrir diagrama físico/relacional (duplo clique em "Relational" no Browser)
2. Menu: Tools → Preferences
3. Diagram → Relational → Notation
4. Selecionar: "Information Engineering"
5. OK
```

---

### 6️⃣ ORGANIZAR DIAGRAMAS (1 min cada)

**Para cada diagrama**:
```
1. Menu: Diagram → Auto Layout
2. Escolher: "Hierarchical Layout"
3. Apply
4. Ajustar zoom: Ctrl + Scroll
```

---

### 7️⃣ EXPORTAR MODELO LÓGICO (2 min)

**PDF**:
```
1. Abrir diagrama lógico
2. File → Export → To PDF
3. Nome: Modelo_Logico_Plataforma_Cursos.pdf
4. Local: C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\
5. Orientação: Landscape
6. Save
```

**JPG**:
```
1. File → Export → To Image
2. Formato: JPG
3. Nome: Modelo_Logico_Plataforma_Cursos.jpg
4. Resolução: 300 DPI
5. Save
```

---

### 8️⃣ EXPORTAR MODELO FÍSICO (2 min)

**PDF**:
```
1. Abrir diagrama físico/relacional
2. File → Export → To PDF
3. Nome: Modelo_Fisico_Plataforma_Cursos.pdf
4. Local: C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\docs\
5. Orientação: Landscape
6. Save
```

**JPG**:
```
1. File → Export → To Image
2. Formato: JPG
3. Nome: Modelo_Fisico_Plataforma_Cursos.jpg
4. Resolução: 300 DPI
5. Save
```

---

## ✅ CHECKLIST FINAL

Você DEVE ter na pasta `docs/`:

```
✅ Modelo_Logico_Plataforma_Cursos.pdf
✅ Modelo_Logico_Plataforma_Cursos.jpg
✅ Modelo_Fisico_Plataforma_Cursos.pdf
✅ Modelo_Fisico_Plataforma_Cursos.jpg
```

---

## 🎯 VALIDAÇÃO RÁPIDA

Abra os PDFs e verifique:

**Modelo Lógico**:
- ✅ 16 entidades visíveis
- ✅ Relacionamentos com "pé de galinha" (notação IE)
- ✅ Cardinalidades (1:N, N:N)

**Modelo Físico**:
- ✅ 16 tabelas com tipos de dados
- ✅ PKs marcadas
- ✅ FKs marcadas
- ✅ Relacionamentos entre tabelas

---

## 🚨 SE DER ERRO

### Erro na conexão?
→ Verifique internet e dados da conexão

### Não aparece notação IE?
→ Feche e abra o diagrama novamente

### Diagrama muito pequeno?
→ Use tamanho A3 na exportação

### Muitas tabelas aparecem?
→ Selecione APENAS as 16 listadas

---

## ⏱️ TEMPO TOTAL

- Conexão: 2 min
- Importação: 3 min
- Modelo Lógico: 2 min
- Configurar IE: 2 min
- Organizar: 2 min
- Exportar: 4 min

**TOTAL: 15 minutos** (primeira vez)
**TOTAL: 10 minutos** (se já souber)

---

## 🎉 PRONTO!

Com isso você completa **100% DOS REQUISITOS** da Global Solution!

Agora pode:
1. ✅ Entregar o projeto
2. ✅ Gravar o vídeo (use ROTEIRO_VIDEO.md)
3. ✅ Apresentar com confiança

---

**BOA SORTE! 🚀**

**Qualquer dúvida, consulte: GUIA_DATA_MODELER.md (versão completa)**
