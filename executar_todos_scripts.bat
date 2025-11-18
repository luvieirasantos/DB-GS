@echo off
REM ============================================================
REM SCRIPT PARA EXECUTAR TODOS OS SCRIPTS DO PROJETO
REM Banco de Dados: Oracle FIAP
REM ============================================================

echo ============================================================
echo EXECUTANDO SCRIPTS DA PLATAFORMA DE CURSOS CORPORATIVA
echo ============================================================
echo.

SET ORACLE_USER=rm558935
SET ORACLE_PASS=310805
SET ORACLE_HOST=oracle.fiap.com.br:1521/ORCL

echo Conectando como %ORACLE_USER%@%ORACLE_HOST%
echo.

REM Verificar se SQLcl está disponível
where sql >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] SQLcl nao encontrado no PATH!
    echo.
    echo Por favor, adicione o SQLcl ao PATH ou execute manualmente:
    echo   cd [CAMINHO_SQLCL]\bin
    echo   sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST%
    echo.
    echo Ou use Oracle SQL Developer para executar os scripts na ordem:
    echo   1. database\ddl\01_create_tables.sql
    echo   2. database\triggers\01_auditoria_triggers.sql
    echo   3. database\procedures\01_insert_procedures.sql
    echo   4. database\functions\01_funcao_json_manual.sql
    echo   5. database\functions\02_funcao_validacao_calculo.sql
    echo   6. database\packages\01_pkg_gestao_usuarios.sql
    echo   7. database\packages\02_pkg_gestao_cursos.sql
    echo   8. database\packages\03_pkg_analytics.sql
    echo   9. database\procedures\02_export_dataset_json.sql
    echo  10. database\data\01_inserir_dados.sql
    echo  11. database\data\02_inserir_dados_parte2.sql
    echo  12. database\validate_installation.sql
    echo.
    pause
    exit /b 1
)

echo [1/12] Criando tabelas, sequences e indices...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\ddl\01_create_tables.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar tabelas!
    pause
    exit /b 1
)
echo [OK] Tabelas criadas com sucesso!
echo.

echo [2/12] Criando triggers de auditoria...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\triggers\01_auditoria_triggers.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar triggers!
    pause
    exit /b 1
)
echo [OK] Triggers criados com sucesso!
echo.

echo [3/12] Criando procedures de insercao...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\procedures\01_insert_procedures.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar procedures!
    pause
    exit /b 1
)
echo [OK] Procedures criadas com sucesso!
echo.

echo [4/12] Criando funcao de conversao JSON manual...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\functions\01_funcao_json_manual.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar funcao JSON!
    pause
    exit /b 1
)
echo [OK] Funcao JSON criada com sucesso!
echo.

echo [5/12] Criando funcao de validacao e calculo...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\functions\02_funcao_validacao_calculo.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar funcao de validacao!
    pause
    exit /b 1
)
echo [OK] Funcao de validacao criada com sucesso!
echo.

echo [6/12] Criando package de gestao de usuarios...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\packages\01_pkg_gestao_usuarios.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar package de usuarios!
    pause
    exit /b 1
)
echo [OK] Package de usuarios criado com sucesso!
echo.

echo [7/12] Criando package de gestao de cursos...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\packages\02_pkg_gestao_cursos.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar package de cursos!
    pause
    exit /b 1
)
echo [OK] Package de cursos criado com sucesso!
echo.

echo [8/12] Criando package de analytics...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\packages\03_pkg_analytics.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar package de analytics!
    pause
    exit /b 1
)
echo [OK] Package de analytics criado com sucesso!
echo.

echo [9/12] Criando procedure de exportacao JSON...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\procedures\02_export_dataset_json.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar procedure de exportacao!
    pause
    exit /b 1
)
echo [OK] Procedure de exportacao criada com sucesso!
echo.

echo [10/12] Inserindo dados de teste (Parte 1)...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\data\01_inserir_dados.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao inserir dados parte 1!
    pause
    exit /b 1
)
echo [OK] Dados parte 1 inseridos com sucesso!
echo.

echo [11/12] Inserindo dados de teste (Parte 2)...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\data\02_inserir_dados_parte2.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao inserir dados parte 2!
    pause
    exit /b 1
)
echo [OK] Dados parte 2 inseridos com sucesso!
echo.

echo [12/12] Validando instalacao...
sql %ORACLE_USER%/%ORACLE_PASS%@%ORACLE_HOST% @database\validate_installation.sql
echo.

echo ============================================================
echo EXECUCAO COMPLETA!
echo ============================================================
echo.
echo Todos os scripts foram executados.
echo Verifique os resultados acima.
echo.
pause
