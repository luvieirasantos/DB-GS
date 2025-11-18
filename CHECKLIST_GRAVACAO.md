# ✅ CHECKLIST PARA GRAVAÇÃO DO VÍDEO

## 📋 ANTES DE COMEÇAR A GRAVAR

### Preparação do Ambiente
- [ ] Fechar TODAS as abas/janelas desnecessárias do navegador
- [ ] Fechar mensageiros (WhatsApp, Telegram, Discord)
- [ ] Desativar notificações do Windows (Foco Assistido)
- [ ] Limpar área de trabalho (deixar só ícones essenciais)
- [ ] Colocar celular no silencioso
- [ ] Avisar pessoas ao redor que vai gravar

### Configuração de Display
- [ ] Ajustar resolução para 1920x1080 (Full HD)
- [ ] Aumentar zoom do terminal/SQLcl (fonte 16-18pt)
- [ ] Aumentar zoom do navegador/editor de texto (Ctrl + +)
- [ ] Configurar cores do terminal (fundo escuro, texto claro)
- [ ] Esconder barra de tarefas (se possível)

### Arquivos e Janelas
- [ ] Abrir pasta do projeto: `DB-GS-V2`
- [ ] Abrir `README.md` em uma aba
- [ ] Abrir `COMANDOS_VIDEO.txt` em outra aba/monitor
- [ ] Abrir `FALAS_VIDEO.txt` em outra aba/monitor
- [ ] Abrir terminal na pasta `database/`
- [ ] Testar conexão com banco ANTES de gravar

### Teste de Conexão
- [ ] Executar: `sql rm558935/310805@//oracle.fiap.com.br:1521/ORCL`
- [ ] Verificar se conecta sem erros
- [ ] Executar `@00_test_connection.sql`
- [ ] Se tudo OK, digitar `exit` e fechar
- [ ] Limpar histórico: `cls` ou `clear`

### Software de Gravação
- [ ] OBS Studio ou software de gravação aberto e configurado
- [ ] Testar gravação de 10 segundos
- [ ] Verificar se está gravando ÁUDIO
- [ ] Verificar se está gravando TELA
- [ ] Verificar se está gravando WEBCAM (se quiser aparecer)
- [ ] Verificar espaço em disco (mínimo 5GB livre)

### Áudio
- [ ] Microfone conectado e funcionando
- [ ] Fazer teste de som (gravar e ouvir)
- [ ] Ajustar ganho/volume do microfone
- [ ] Eliminar ruídos de fundo (fechar janelas, desligar ventilador)
- [ ] Copo de água por perto

### Iluminação (se aparecer no vídeo)
- [ ] Luz frontal adequada (não deixar sombras no rosto)
- [ ] Evitar janelas atrás (fica escuro)
- [ ] Fundo limpo e organizado

---

## 🎬 DURANTE A GRAVAÇÃO

### Postura e Apresentação
- [ ] Sentar com postura ereta
- [ ] Sorrir e demonstrar entusiasmo
- [ ] Olhar para câmera ao falar (não para tela)
- [ ] Gesticular naturalmente
- [ ] Falar pausadamente e com clareza

### Técnica
- [ ] Pausar 2 segundos antes de começar a falar
- [ ] Fazer pausas de 1 segundo entre frases
- [ ] Usar mouse para apontar itens importantes
- [ ] Deixar comandos executarem completamente antes de continuar
- [ ] Pausar 2 segundos depois de resultados importantes aparecerem

### Erros e Problemas
- [ ] Se errar uma palavra: respire e continue
- [ ] Se errar muito: pause, respire, recomece daquela parte
- [ ] Se erro técnico: pausar gravação, consertar, retomar
- [ ] Se esquecer o que falar: consultar FALAS_VIDEO.txt
- [ ] Manter calma e profissionalismo sempre

---

## 🎯 SEQUÊNCIA DE GRAVAÇÃO

### Setup Inicial (não gravar ainda)
1. [ ] Abrir OBS/software de gravação
2. [ ] Posicionar câmera/enquadramento
3. [ ] Testar áudio final
4. [ ] Respirar fundo 3x
5. [ ] Colocar sorriso no rosto

### Começar Gravação
6. [ ] Apertar botão GRAVAR
7. [ ] Contar mentalmente 1... 2... 3...
8. [ ] Começar: "Olá! Neste vídeo..."

### Durante o Vídeo
9. [ ] Seguir roteiro do arquivo `ROTEIRO_VIDEO.md`
10. [ ] Copiar comandos de `COMANDOS_VIDEO.txt`
11. [ ] Consultar falas em `FALAS_VIDEO.txt` se necessário
12. [ ] Manter energia e entusiasmo
13. [ ] Apontar itens importantes com mouse

### Finalização
14. [ ] Fazer conclusão completa
15. [ ] Sorrir e acenar (se aparecer no vídeo)
16. [ ] Manter pose por 3 segundos
17. [ ] Parar gravação
18. [ ] Salvar arquivo imediatamente

---

## 📝 PONTA PÉ INICIAL - COMANDOS EM ORDEM

```
1. cd C:\Users\gldsa\OneDrive\Desktop\DB-GS-V2\database
2. sql rm558935/310805@//oracle.fiap.com.br:1521/ORCL
3. @validate_installation.sql
4. SELECT fn_validar_dados_cadastrais('CPF', '123.456.789-01') FROM DUAL;
5. SELECT fn_validar_dados_cadastrais('EMAIL', 'teste@empresa.com.br') FROM DUAL;
6. SELECT fn_calcular_compatibilidade_curso(1, 1) FROM DUAL;
7. (continuar conforme COMANDOS_VIDEO.txt)
```

---

## 🎞️ PÓS-GRAVAÇÃO

### Imediatamente Após
- [ ] Salvar arquivo de vídeo
- [ ] Fazer backup em outro local
- [ ] Assistir vídeo completo
- [ ] Anotar pontos que precisam edição
- [ ] Decidir se precisa regravar algo

### Edição
- [ ] Cortar intro (primeiros 2-3 segundos de silêncio)
- [ ] Cortar outros (últimos 2-3 segundos de silêncio)
- [ ] Acelerar partes onde aguarda comando executar (1.5x-2x)
- [ ] Adicionar intro com título (5 segundos)
- [ ] Adicionar música de fundo suave
- [ ] Adicionar textos/legendas destacando pontos importantes
- [ ] Adicionar zoom em textos pequenos
- [ ] Adicionar outro final com seus dados

### Elementos Gráficos para Adicionar (opcional)
- [ ] Intro: "Plataforma de Cursos Corporativa - Global Solution FIAP"
- [ ] Textos: Lista de funcionalidades na conclusão
- [ ] Ícones: ✅ nas validações bem-sucedidas
- [ ] Lower third: Seu nome e RM (canto inferior)
- [ ] Outro: Seus dados + agradecimento

### Exportação Final
- [ ] Exportar em Full HD (1920x1080)
- [ ] 30fps
- [ ] Formato MP4 (H.264)
- [ ] Bitrate: 8-10 Mbps
- [ ] Assistir vídeo final completo
- [ ] Verificar áudio sincronizado
- [ ] Verificar qualidade visual

---

## 📤 PUBLICAÇÃO (OPCIONAL)

### YouTube
- [ ] **Título**: "Plataforma de Cursos Corporativa - Oracle Database + PL/SQL | Global Solution FIAP"
- [ ] **Descrição**: Incluir resumo, tecnologias, links
- [ ] **Tags**: Oracle, PL/SQL, Database, FIAP, Global Solution, SQL
- [ ] **Thumbnail**: Criar imagem atrativa com título
- [ ] **Visibilidade**: Não listado ou Público

### Entrega do Projeto
- [ ] Incluir link do vídeo no README.md
- [ ] Incluir no relatório final
- [ ] Verificar se vídeo está acessível
- [ ] Fazer download local do vídeo (backup)

---

## 🚨 TROUBLESHOOTING

### Se esquecer a fala:
→ Pause, respire, consulte FALAS_VIDEO.txt, continue

### Se comando não funcionar:
→ Pause gravação, conserte, limpe tela, retome gravação

### Se nervoso:
→ Respire fundo 5x, beba água, lembre que pode editar depois

### Se erro de áudio:
→ Pare IMEDIATAMENTE, não continue, conserte primeiro

### Se erro de conexão banco:
→ Pause gravação, reconecte, teste, continue

---

## 💪 MENSAGEM MOTIVACIONAL

Você preparou um projeto EXCELENTE!

✅ 16 tabelas em 3FN
✅ 15 procedures + 4 functions
✅ 3 packages modulares
✅ 10 triggers de auditoria
✅ 77/77 testes aprovados
✅ 100% documentado

**Você domina este conteúdo!**
**Respire, sorria e mostre seu trabalho com ORGULHO!**

Mesmo se cometer pequenos erros durante a gravação, seu projeto
é SÓLIDO e isso é o que importa.

**VOCÊ CONSEGUE! 🚀🎬**

---

## ⏰ TEMPO ESTIMADO

- **Preparação**: 20-30 minutos
- **Gravação**: 10-15 minutos (com erros e retakes)
- **Edição básica**: 30-60 minutos
- **Total**: 1h30min a 2h00min

Reserve uma manhã ou tarde inteira para fazer com calma!

---

## 📞 CONTATOS DE EMERGÊNCIA

Se tiver problemas técnicos:
- Grupo da turma
- Professor/Monitor
- Fórum da disciplina

**NÃO DEIXE PARA ÚLTIMA HORA!**

Grave com pelo menos 2-3 dias de antecedência da entrega.

---

**BOA SORTE! VOCÊ VAI ARRASAR! 🌟**
