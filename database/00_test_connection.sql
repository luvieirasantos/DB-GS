-- ============================================================
-- SCRIPT DE TESTE DE CONEXÃO
-- Execute este script primeiro para validar a conexão
-- ============================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 100;

PROMPT
PROMPT ============================================================
PROMPT TESTE DE CONEXÃO E PRIVILÉGIOS
PROMPT ============================================================
PROMPT

-- Testar conexão
SELECT 'Conexao estabelecida com sucesso!' as status FROM DUAL;

-- Informações do usuário
SELECT
    USER as usuario_conectado,
    TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') as data_hora_servidor
FROM DUAL;

PROMPT
PROMPT Verificando privilegios do usuario...
PROMPT

-- Verificar privilégios
SELECT privilege FROM user_sys_privs ORDER BY privilege;

PROMPT
PROMPT Verificando tablespaces disponiveis...
PROMPT

-- Verificar tablespace
SELECT
    tablespace_name,
    ROUND(bytes/1024/1024, 2) as size_mb
FROM user_ts_quotas;

PROMPT
PROMPT Verificando objetos existentes...
PROMPT

-- Contar objetos existentes
SELECT
    object_type,
    COUNT(*) as total
FROM user_objects
GROUP BY object_type
ORDER BY object_type;

PROMPT
PROMPT ============================================================
PROMPT TESTE CONCLUIDO
PROMPT ============================================================
PROMPT
PROMPT Se voce viu as informacoes acima, a conexao esta funcionando!
PROMPT
PROMPT Proximos passos:
PROMPT   1. Execute executar_todos_scripts.bat (Windows)
PROMPT   OU
PROMPT   2. Execute os scripts manualmente na ordem do INSTALL.md
PROMPT
