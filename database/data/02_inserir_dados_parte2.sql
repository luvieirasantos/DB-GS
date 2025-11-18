-- ============================================================
-- INSERÇÃO DE DADOS - PARTE 2
-- Matrículas, Progressos, Competências, Certificados e Competições
-- ============================================================

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== CONTINUANDO INSERÇÃO DE DADOS - PARTE 2 ===');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================
-- INSERIR COMPETÊNCIAS (20 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Competências ---');

    sp_inserir_competencia('Python Programming', 'Desenvolvimento em Python', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Java Enterprise', 'Desenvolvimento Java corporativo', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Cloud Computing AWS', 'Computação em nuvem AWS', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Kubernetes', 'Orquestração de containers', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Machine Learning', 'Aprendizado de máquina', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Deep Learning', 'Redes neurais profundas', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('RPA - Robotic Process Automation', 'Automação de processos', 'AUTOMACAO', 'EM_ALTA');
    sp_inserir_competencia('IoT Development', 'Internet das Coisas', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Cybersecurity', 'Segurança cibernética', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('DevOps', 'Práticas DevOps', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Blockchain Development', 'Desenvolvimento blockchain', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Big Data Analytics', 'Análise de grandes volumes', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Scrum Master', 'Gestão ágil Scrum', 'GESTAO', 'EM_ALTA');
    sp_inserir_competencia('CI/CD Pipelines', 'Integração e deploy contínuos', 'AUTOMACAO', 'EM_ALTA');
    sp_inserir_competencia('Microservices Architecture', 'Arquitetura de microserviços', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('API REST Development', 'Desenvolvimento de APIs', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Data Engineering', 'Engenharia de dados', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Smart Contracts', 'Contratos inteligentes', 'TECNOLOGIA', 'EM_ALTA');
    sp_inserir_competencia('Industrial Automation', 'Automação industrial', 'AUTOMACAO', 'EM_ALTA');
    sp_inserir_competencia('Leadership Digital', 'Liderança em transformação digital', 'SOFT_SKILLS', 'ESTAVEL');

    DBMS_OUTPUT.PUT_LINE('20 competências inseridas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir competências: ' || SQLERRM);
END;
/

-- ============================================================
-- ASSOCIAR COMPETÊNCIAS AOS FUNCIONÁRIOS (30 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Associando Competências aos Funcionários ---');

    -- João Santos (ID 1) - Backend Developer
    sp_associar_competencia_funcionario(1, 1, 'INTERMEDIARIO');  -- Python
    sp_associar_competencia_funcionario(1, 16, 'INTERMEDIARIO'); -- API REST

    -- Maria Oliveira (ID 2) - DevOps Engineer
    sp_associar_competencia_funcionario(2, 10, 'AVANCADO');      -- DevOps
    sp_associar_competencia_funcionario(2, 4, 'AVANCADO');       -- Kubernetes
    sp_associar_competencia_funcionario(2, 14, 'AVANCADO');      -- CI/CD

    -- Paulo Mendes (ID 3) - Automation Engineer
    sp_associar_competencia_funcionario(3, 7, 'AVANCADO');       -- RPA
    sp_associar_competencia_funcionario(3, 19, 'AVANCADO');      -- Industrial Automation

    -- Rafael Torres (ID 7) - Cloud Architect
    sp_associar_competencia_funcionario(7, 3, 'EXPERT');         -- AWS
    sp_associar_competencia_funcionario(7, 4, 'EXPERT');         -- Kubernetes
    sp_associar_competencia_funcionario(7, 15, 'EXPERT');        -- Microservices

    -- André Silva (ID 9) - Data Scientist
    sp_associar_competencia_funcionario(9, 5, 'AVANCADO');       -- ML
    sp_associar_competencia_funcionario(9, 6, 'AVANCADO');       -- Deep Learning
    sp_associar_competencia_funcionario(9, 1, 'AVANCADO');       -- Python

    -- Beatriz Nunes (ID 10) - Robotics Engineer
    sp_associar_competencia_funcionario(10, 19, 'AVANCADO');     -- Industrial Automation
    sp_associar_competencia_funcionario(10, 8, 'INTERMEDIARIO'); -- IoT

    -- Felipe Souza (ID 11) - Data Engineer
    sp_associar_competencia_funcionario(11, 17, 'AVANCADO');     -- Data Engineering
    sp_associar_competencia_funcionario(11, 12, 'AVANCADO');     -- Big Data
    sp_associar_competencia_funcionario(11, 1, 'INTERMEDIARIO'); -- Python

    -- Gustavo Lima (ID 13) - Security Specialist
    sp_associar_competencia_funcionario(13, 9, 'EXPERT');        -- Cybersecurity

    -- Isabela Moreira (ID 14) - IoT Developer
    sp_associar_competencia_funcionario(14, 8, 'AVANCADO');      -- IoT
    sp_associar_competencia_funcionario(14, 1, 'INTERMEDIARIO'); -- Python

    -- Marcelo Reis (ID 15) - SRE Engineer
    sp_associar_competencia_funcionario(15, 10, 'EXPERT');       -- DevOps
    sp_associar_competencia_funcionario(15, 4, 'EXPERT');        -- Kubernetes

    -- Daniela Araújo (ID 16) - Blockchain Developer
    sp_associar_competencia_funcionario(16, 11, 'AVANCADO');     -- Blockchain
    sp_associar_competencia_funcionario(16, 18, 'AVANCADO');     -- Smart Contracts

    -- Vinícius Pinto (ID 17) - Full Stack Developer
    sp_associar_competencia_funcionario(17, 2, 'INTERMEDIARIO'); -- Java
    sp_associar_competencia_funcionario(17, 16, 'INTERMEDIARIO'); -- API REST

    -- Diego Ferreira (ID 19) - Quantum Researcher
    sp_associar_competencia_funcionario(19, 5, 'EXPERT');        -- ML
    sp_associar_competencia_funcionario(19, 1, 'EXPERT');        -- Python

    DBMS_OUTPUT.PUT_LINE('30+ associações de competências criadas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao associar competências: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR MATRÍCULAS (25 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Matrículas ---');

    -- Funcionários se matriculando em cursos
    sp_inserir_matricula(1, 1);   -- João -> Python Iniciantes
    sp_inserir_matricula(1, 15);  -- João -> API REST Node.js
    sp_inserir_matricula(2, 4);   -- Maria -> Kubernetes
    sp_inserir_matricula(2, 11);  -- Maria -> CI/CD Jenkins
    sp_inserir_matricula(3, 7);   -- Paulo -> RPA
    sp_inserir_matricula(3, 8);   -- Paulo -> Indústria 4.0
    sp_inserir_matricula(4, 10);  -- Carla -> IoT Arduino
    sp_inserir_matricula(5, 14);  -- Bruno -> Scrum Master
    sp_inserir_matricula(6, 8);   -- Luciana -> Indústria 4.0
    sp_inserir_matricula(7, 3);   -- Rafael -> AWS Cloud
    sp_inserir_matricula(7, 4);   -- Rafael -> Kubernetes
    sp_inserir_matricula(8, 3);   -- Tatiana -> AWS Cloud
    sp_inserir_matricula(9, 5);   -- André -> Machine Learning
    sp_inserir_matricula(9, 6);   -- André -> Deep Learning
    sp_inserir_matricula(10, 7);  -- Beatriz -> RPA
    sp_inserir_matricula(11, 13); -- Felipe -> Big Data Spark
    sp_inserir_matricula(12, 13); -- Renata -> Big Data Spark
    sp_inserir_matricula(13, 9);  -- Gustavo -> Ethical Hacking
    sp_inserir_matricula(14, 10); -- Isabela -> IoT Arduino
    sp_inserir_matricula(15, 4);  -- Marcelo -> Kubernetes
    sp_inserir_matricula(16, 12); -- Daniela -> Smart Contracts
    sp_inserir_matricula(17, 2);  -- Vinícius -> Java Avançado
    sp_inserir_matricula(18, 14); -- Aline -> Scrum Master
    sp_inserir_matricula(19, 6);  -- Diego -> Deep Learning
    sp_inserir_matricula(20, 1);  -- Larissa -> Python Iniciantes

    DBMS_OUTPUT.PUT_LINE('25 matrículas inseridas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir matrículas: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR PROGRESSOS (40 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Progressos nos Módulos ---');

    -- João - Curso Python (Matrícula 1)
    sp_inserir_progresso(1, 1, 120, 9.0);  -- Módulo 1
    sp_inserir_progresso(1, 2, 180, 8.5);  -- Módulo 2
    sp_inserir_progresso(1, 3, 150, 9.5);  -- Módulo 3
    sp_inserir_progresso(1, 4, 200, 8.0);  -- Módulo 4

    -- Maria - Curso Kubernetes (Matrícula 3)
    sp_inserir_progresso(3, 11, 300, 9.5); -- Módulo 1
    sp_inserir_progresso(3, 12, 400, 9.0); -- Módulo 2
    sp_inserir_progresso(3, 13, 350, 8.5); -- Módulo 3
    sp_inserir_progresso(3, 14, 300, 9.0); -- Módulo 4

    -- Paulo - Curso RPA (Matrícula 5)
    sp_inserir_progresso(5, 22, 250, 8.0); -- Módulo 1
    sp_inserir_progresso(5, 23, 400, 8.5); -- Módulo 2
    sp_inserir_progresso(5, 24, 350, 9.0); -- Módulo 3

    -- Rafael - Curso AWS (Matrícula 10)
    sp_inserir_progresso(10, 8, 180, 10.0); -- Módulo 1
    sp_inserir_progresso(10, 9, 240, 9.5);  -- Módulo 2
    sp_inserir_progresso(10, 10, 200, 9.0); -- Módulo 3

    -- André - Curso ML (Matrícula 13)
    sp_inserir_progresso(13, 15, 400, 9.5); -- Módulo 1
    sp_inserir_progresso(13, 16, 500, 9.0); -- Módulo 2
    sp_inserir_progresso(13, 17, 450, 8.5); -- Módulo 3
    sp_inserir_progresso(13, 18, 350, 9.0); -- Módulo 4

    -- Felipe - Curso Big Data (Matrícula 16)
    sp_inserir_progresso(16, 39, 500, 8.5); -- Módulo 1
    sp_inserir_progresso(16, 40, 450, 9.0); -- Módulo 2
    sp_inserir_progresso(16, 41, 500, 8.0); -- Módulo 3

    -- Gustavo - Ethical Hacking (Matrícula 18)
    sp_inserir_progresso(18, 28, 350, 9.5); -- Módulo 1
    sp_inserir_progresso(18, 29, 500, 9.0); -- Módulo 2
    sp_inserir_progresso(18, 30, 450, 8.5); -- Módulo 3
    sp_inserir_progresso(18, 31, 300, 9.0); -- Módulo 4

    -- Isabela - IoT Arduino (Matrícula 19)
    sp_inserir_progresso(19, 32, 300, 8.5); -- Módulo 1
    sp_inserir_progresso(19, 33, 350, 9.0); -- Módulo 2
    sp_inserir_progresso(19, 34, 400, 8.0); -- Módulo 3

    -- Marcelo - Kubernetes (Matrícula 20)
    sp_inserir_progresso(20, 11, 300, 10.0); -- Módulo 1
    sp_inserir_progresso(20, 12, 400, 9.5);  -- Módulo 2
    sp_inserir_progresso(20, 13, 350, 9.0);  -- Módulo 3
    sp_inserir_progresso(20, 14, 300, 9.5);  -- Módulo 4

    -- Daniela - Smart Contracts (Matrícula 21)
    sp_inserir_progresso(21, 37, 400, 9.0); -- Módulo 1
    sp_inserir_progresso(21, 38, 500, 8.5); -- Módulo 2

    -- Larissa - Python Iniciantes (Matrícula 25)
    sp_inserir_progresso(25, 1, 120, 7.5); -- Módulo 1
    sp_inserir_progresso(25, 2, 180, 8.0); -- Módulo 2
    sp_inserir_progresso(25, 3, 150, 7.0); -- Módulo 3

    DBMS_OUTPUT.PUT_LINE('40+ progressos inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir progressos: ' || SQLERRM);
END;
/

-- ============================================================
-- ATUALIZAR MATRÍCULAS CONCLUÍDAS
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Atualizando Matrículas Concluídas ---');

    -- Marcar algumas matrículas como concluídas
    UPDATE matricula SET status = 'CONCLUIDO', data_conclusao = SYSDATE - 10,
                        percentual_conclusao = 100, nota_final = 9.0
    WHERE id_matricula IN (1, 3, 5, 10, 13);

    UPDATE matricula SET status = 'CONCLUIDO', data_conclusao = SYSDATE - 5,
                        percentual_conclusao = 100, nota_final = 9.5
    WHERE id_matricula IN (16, 18, 19, 20);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Matrículas concluídas atualizadas!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar matrículas: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- ATUALIZAR PROGRESSO DAS MATRÍCULAS CONCLUÍDAS
-- ============================================================
BEGIN
    UPDATE progresso SET status = 'CONCLUIDO', data_conclusao = SYSDATE - 10
    WHERE id_matricula IN (1, 3, 5, 10, 13, 16, 18, 19, 20);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Progressos atualizados!');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar progressos: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- INSERIR CERTIFICADOS (10 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Certificados ---');

    sp_inserir_certificado(1, 9.0, 40);   -- João - Python
    sp_inserir_certificado(3, 9.0, 60);   -- Maria - Kubernetes
    sp_inserir_certificado(5, 8.5, 50);   -- Paulo - RPA
    sp_inserir_certificado(10, 9.5, 30);  -- Rafael - AWS
    sp_inserir_certificado(13, 9.0, 100); -- André - ML
    sp_inserir_certificado(16, 8.5, 100); -- Felipe - Big Data
    sp_inserir_certificado(18, 9.0, 90);  -- Gustavo - Ethical Hacking
    sp_inserir_certificado(19, 8.5, 60);  -- Isabela - IoT
    sp_inserir_certificado(20, 9.5, 60);  -- Marcelo - Kubernetes

    DBMS_OUTPUT.PUT_LINE('9 certificados inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir certificados: ' || SQLERRM);
END;
/

-- ============================================================
-- ATUALIZAR PONTOS DOS FUNCIONÁRIOS
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Atualizando Pontos dos Funcionários ---');

    UPDATE funcionario SET pontos_acumulados = 100 WHERE id_funcionario = 1;  -- João
    UPDATE funcionario SET pontos_acumulados = 250 WHERE id_funcionario = 2;  -- Maria
    UPDATE funcionario SET pontos_acumulados = 200 WHERE id_funcionario = 3;  -- Paulo
    UPDATE funcionario SET pontos_acumulados = 150 WHERE id_funcionario = 7;  -- Rafael
    UPDATE funcionario SET pontos_acumulados = 300 WHERE id_funcionario = 9;  -- André
    UPDATE funcionario SET pontos_acumulados = 320 WHERE id_funcionario = 11; -- Felipe
    UPDATE funcionario SET pontos_acumulados = 250 WHERE id_funcionario = 13; -- Gustavo
    UPDATE funcionario SET pontos_acumulados = 180 WHERE id_funcionario = 14; -- Isabela
    UPDATE funcionario SET pontos_acumulados = 350 WHERE id_funcionario = 15; -- Marcelo
    UPDATE funcionario SET pontos_acumulados = 200 WHERE id_funcionario = 16; -- Daniela
    UPDATE funcionario SET pontos_acumulados = 50 WHERE id_funcionario = 20;  -- Larissa

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Pontos atualizados com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar pontos: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- INSERIR COMPETIÇÕES (12 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Competições ---');

    sp_inserir_competicao(1, 'Desafio DevOps Q1 2024', 'Competição de práticas DevOps',
                         SYSDATE - 60, SYSDATE - 30, 'PONTUACAO', 500);

    sp_inserir_competicao(2, 'Maratona de Automação', 'Maior número de processos automatizados',
                         SYSDATE - 45, SYSDATE - 15, 'CONCLUSAO_CURSOS', NULL);

    sp_inserir_competicao(3, 'Sprint de Cloud Computing', 'Certificações cloud conquistadas',
                         SYSDATE - 90, SYSDATE - 60, 'QUALIDADE', NULL);

    sp_inserir_competicao(5, 'Hackathon de IA', 'Desenvolvimento de soluções com IA',
                         SYSDATE - 30, SYSDATE - 1, 'PONTUACAO', 1000);

    sp_inserir_competicao(6, 'Desafio Machine Learning', 'Precisão de modelos de ML',
                         SYSDATE - 20, SYSDATE + 10, 'QUALIDADE', NULL);

    sp_inserir_competicao(8, 'Competição Data Science', 'Análise de dados corporativos',
                         SYSDATE - 15, SYSDATE + 15, 'PONTUACAO', 800);

    sp_inserir_competicao(9, 'CTF - Capture The Flag', 'Desafios de segurança',
                         SYSDATE - 7, SYSDATE + 7, 'PONTUACAO', 600);

    sp_inserir_competicao(10, 'IoT Innovation Challenge', 'Soluções inovadoras em IoT',
                         SYSDATE + 5, SYSDATE + 35, 'QUALIDADE', NULL);

    sp_inserir_competicao(11, 'DevOps Masters', 'Competição de SRE e DevOps',
                         SYSDATE + 10, SYSDATE + 40, 'PONTUACAO', 1200);

    sp_inserir_competicao(12, 'Blockchain Builders', 'Desenvolvimento de dApps',
                         SYSDATE + 15, SYSDATE + 45, 'QUALIDADE', NULL);

    sp_inserir_competicao(13, 'FinTech Innovation', 'Soluções financeiras digitais',
                         SYSDATE + 20, SYSDATE + 50, 'PONTUACAO', 900);

    sp_inserir_competicao(1, 'Code Quality Challenge', 'Melhor qualidade de código',
                         SYSDATE + 25, SYSDATE + 55, 'QUALIDADE', NULL);

    DBMS_OUTPUT.PUT_LINE('12 competições inseridas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir competições: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR PRÊMIOS DAS COMPETIÇÕES (15 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Prêmios das Competições ---');

    -- Competição 1 - Desafio DevOps
    sp_inserir_premio_competicao(1, 1, NULL, 'Troféu + Certificação AWS', 5000, 1);
    sp_inserir_premio_competicao(1, 2, NULL, 'Certificação Google Cloud', 3000, 2);
    sp_inserir_premio_competicao(1, NULL, 2, 'Voucher de curso', 1500, 3);

    -- Competição 2 - Maratona de Automação
    sp_inserir_premio_competicao(2, 3, NULL, 'Software de automação premium', 4000, 1);
    sp_inserir_premio_competicao(2, NULL, 3, 'Curso avançado de RPA', 2000, 2);

    -- Competição 3 - Sprint de Cloud
    sp_inserir_premio_competicao(3, 4, NULL, 'Certificação Azure + AWS', 6000, 1);
    sp_inserir_premio_competicao(3, NULL, 5, 'Curso Kubernetes avançado', 2500, 2);

    -- Competição 4 - Hackathon de IA
    sp_inserir_premio_competicao(4, 7, NULL, 'GPU para Deep Learning', 8000, 1);
    sp_inserir_premio_competicao(4, NULL, 9, 'Curso AI Stanford', 5000, 2);

    -- Competição 7 - CTF
    sp_inserir_premio_competicao(7, 10, NULL, 'Certificação CEH', 4500, 1);
    sp_inserir_premio_competicao(7, NULL, 13, 'Hardware hacking kit', 2000, 2);

    -- Competição 6 - Data Science
    sp_inserir_premio_competicao(6, 9, NULL, 'Licença Databricks', 7000, 1);
    sp_inserir_premio_competicao(6, NULL, 11, 'Curso advanced analytics', 3000, 2);

    -- Competição 9 - DevOps Masters
    sp_inserir_premio_competicao(9, 12, NULL, 'MacBook Pro', 12000, 1);

    -- Competição 10 - Blockchain Builders
    sp_inserir_premio_competicao(10, 13, NULL, 'Ethereum + cursos', 5000, 1);

    DBMS_OUTPUT.PUT_LINE('15 prêmios inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir prêmios: ' || SQLERRM);
END;
/

COMMIT;

-- ============================================================
-- RESUMO DOS DADOS INSERIDOS
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== RESUMO DA INSERÇÃO ===');
    DBMS_OUTPUT.PUT_LINE('');

    FOR rec IN (
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
        SELECT 'AUDITORIA', COUNT(*) FROM auditoria
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD(rec.tabela, 30, '.') || ' ' || LPAD(rec.total, 5, ' ') || ' registros');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== INSERÇÃO COMPLETA! ===');
END;
/
