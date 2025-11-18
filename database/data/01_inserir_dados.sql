-- ============================================================
-- INSERÇÃO DE DADOS USANDO PROCEDURES
-- Mínimo de 10 registros por tabela
-- Dados relacionados ao tema "O Futuro do Trabalho"
-- ============================================================

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INICIANDO INSERÇÃO DE DADOS ===');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================
-- INSERIR EMPRESAS (15 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Empresas ---');

    sp_inserir_empresa('12.345.678/0001-90', 'TechFuture Soluções Ltda', 'TechFuture', 'contato@techfuture.com.br', '(11) 3456-7890');
    sp_inserir_empresa('23.456.789/0001-01', 'AutomaTech Industria SA', 'AutomaTech', 'contato@automatech.com.br', '(11) 3567-8901');
    sp_inserir_empresa('34.567.890/0001-12', 'Digital Transform Consulting', 'DTC', 'contato@dtconsulting.com.br', '(21) 3678-9012');
    sp_inserir_empresa('45.678.901/0001-23', 'SmartFactory Industrial Ltda', 'SmartFactory', 'contato@smartfactory.com.br', '(11) 3789-0123');
    sp_inserir_empresa('56.789.012/0001-34', 'CloudFirst Technologies SA', 'CloudFirst', 'contato@cloudfirst.com.br', '(11) 3890-1234');
    sp_inserir_empresa('67.890.123/0001-45', 'AI Solutions Brasil Ltda', 'AI Solutions', 'contato@aisolutions.com.br', '(11) 3901-2345');
    sp_inserir_empresa('78.901.234/0001-56', 'RoboTech Automação SA', 'RoboTech', 'contato@robotech.com.br', '(41) 3012-3456');
    sp_inserir_empresa('89.012.345/0001-67', 'DataScience Corp Brasil', 'DataScience Corp', 'contato@datasciencecorp.com.br', '(11) 3123-4567');
    sp_inserir_empresa('90.123.456/0001-78', 'CyberSec Solutions Ltda', 'CyberSec', 'contato@cybersec.com.br', '(11) 3234-5678');
    sp_inserir_empresa('01.234.567/0001-89', 'IoT Industry Brasil SA', 'IoT Industry', 'contato@iotindustry.com.br', '(11) 3345-6789');
    sp_inserir_empresa('11.223.344/0001-55', 'DevOps Masters Ltda', 'DevOps Masters', 'contato@devopsmasters.com.br', '(11) 3456-7890');
    sp_inserir_empresa('22.334.455/0001-66', 'Blockchain Brasil SA', 'Blockchain BR', 'contato@blockchainbr.com.br', '(11) 3567-8901');
    sp_inserir_empresa('33.445.566/0001-77', 'FinTech Innovations Ltda', 'FinTech Inn', 'contato@fintechinnovations.com.br', '(11) 3678-9012');
    sp_inserir_empresa('44.556.677/0001-88', 'GreenTech Sustentavel SA', 'GreenTech', 'contato@greentech.com.br', '(41) 3789-0123');
    sp_inserir_empresa('55.667.788/0001-99', 'QuantumComp Brasil Ltda', 'QuantumComp', 'contato@quantumcomp.com.br', '(11) 3890-1234');

    DBMS_OUTPUT.PUT_LINE('15 empresas inseridas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir empresas: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR GERENTES (15 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Gerentes ---');

    sp_inserir_gerente(1, 'Carlos Silva', '123.456.789-01', 'carlos.silva@techfuture.com.br', '(11) 98765-4321', 'Gerente de TI');
    sp_inserir_gerente(2, 'Ana Santos', '234.567.890-12', 'ana.santos@automatech.com.br', '(11) 98876-5432', 'Gerente de Automação');
    sp_inserir_gerente(3, 'Pedro Oliveira', '345.678.901-23', 'pedro.oliveira@dtconsulting.com.br', '(21) 98987-6543', 'Gerente de Projetos');
    sp_inserir_gerente(4, 'Mariana Costa', '456.789.012-34', 'mariana.costa@smartfactory.com.br', '(11) 99098-7654', 'Gerente Industrial');
    sp_inserir_gerente(5, 'Roberto Alves', '567.890.123-45', 'roberto.alves@cloudfirst.com.br', '(11) 99109-8765', 'Gerente de Cloud');
    sp_inserir_gerente(6, 'Juliana Ferreira', '678.901.234-56', 'juliana.ferreira@aisolutions.com.br', '(11) 99210-9876', 'Gerente de IA');
    sp_inserir_gerente(7, 'Fernando Lima', '789.012.345-67', 'fernando.lima@robotech.com.br', '(41) 99321-0987', 'Gerente de Robótica');
    sp_inserir_gerente(8, 'Patrícia Souza', '890.123.456-78', 'patricia.souza@datasciencecorp.com.br', '(11) 99432-1098', 'Gerente de Data Science');
    sp_inserir_gerente(9, 'Ricardo Martins', '901.234.567-89', 'ricardo.martins@cybersec.com.br', '(11) 99543-2109', 'Gerente de Segurança');
    sp_inserir_gerente(10, 'Camila Rodrigues', '012.345.678-90', 'camila.rodrigues@iotindustry.com.br', '(11) 99654-3210', 'Gerente de IoT');
    sp_inserir_gerente(11, 'Lucas Pereira', '112.233.445-56', 'lucas.pereira@devopsmasters.com.br', '(11) 99765-4321', 'Gerente de DevOps');
    sp_inserir_gerente(12, 'Amanda Carvalho', '223.344.556-67', 'amanda.carvalho@blockchainbr.com.br', '(11) 99876-5432', 'Gerente de Blockchain');
    sp_inserir_gerente(13, 'Thiago Barbosa', '334.455.667-78', 'thiago.barbosa@fintechinnovations.com.br', '(11) 99987-6543', 'Gerente Financeiro');
    sp_inserir_gerente(14, 'Fernanda Gomes', '445.566.778-89', 'fernanda.gomes@greentech.com.br', '(41) 99098-7654', 'Gerente de Sustentabilidade');
    sp_inserir_gerente(15, 'Gabriel Ribeiro', '556.677.889-90', 'gabriel.ribeiro@quantumcomp.com.br', '(11) 99109-8765', 'Gerente de Pesquisa');

    DBMS_OUTPUT.PUT_LINE('15 gerentes inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir gerentes: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR TIMES (15 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Times ---');

    sp_inserir_time(1, 'Time DevOps', 'Equipe focada em CI/CD e automação de deploys');
    sp_inserir_time(1, 'Time Backend', 'Desenvolvimento de APIs e microserviços');
    sp_inserir_time(2, 'Time Automação Industrial', 'Automação de processos fabris');
    sp_inserir_time(3, 'Time Transformação Digital', 'Consultoria em transformação digital');
    sp_inserir_time(4, 'Time Manufatura 4.0', 'Implementação de indústria 4.0');
    sp_inserir_time(5, 'Time Cloud Native', 'Desenvolvimento cloud native');
    sp_inserir_time(6, 'Time Machine Learning', 'Desenvolvimento de modelos de ML');
    sp_inserir_time(7, 'Time Robótica Avançada', 'Desenvolvimento de robôs industriais');
    sp_inserir_time(8, 'Time Big Data', 'Engenharia de dados e analytics');
    sp_inserir_time(9, 'Time Cibersegurança', 'Segurança da informação e pentest');
    sp_inserir_time(10, 'Time IoT', 'Internet das Coisas e sensores');
    sp_inserir_time(11, 'Time SRE', 'Site Reliability Engineering');
    sp_inserir_time(12, 'Time Smart Contracts', 'Desenvolvimento de contratos inteligentes');
    sp_inserir_time(13, 'Time Pagamentos Digitais', 'Soluções de pagamento online');
    sp_inserir_time(14, 'Time Energia Renovável', 'Tecnologia para energia limpa');

    DBMS_OUTPUT.PUT_LINE('15 times inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir times: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR FUNCIONÁRIOS (20 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Funcionários ---');

    sp_inserir_funcionario(1, 'João Santos', '111.222.333-44', 'joao.santos@techfuture.com.br', '(11) 91111-2222', 'Desenvolvedor Backend', 'INTERMEDIARIO');
    sp_inserir_funcionario(1, 'Maria Oliveira', '222.333.444-55', 'maria.oliveira@techfuture.com.br', '(11) 92222-3333', 'Engenheira DevOps', 'AVANCADO');
    sp_inserir_funcionario(2, 'Paulo Mendes', '333.444.555-66', 'paulo.mendes@automatech.com.br', '(11) 93333-4444', 'Engenheiro de Automação', 'AVANCADO');
    sp_inserir_funcionario(2, 'Carla Dias', '444.555.666-77', 'carla.dias@automatech.com.br', '(11) 94444-5555', 'Técnica em Robótica', 'INTERMEDIARIO');
    sp_inserir_funcionario(3, 'Bruno Costa', '555.666.777-88', 'bruno.costa@dtconsulting.com.br', '(21) 95555-6666', 'Consultor Digital', 'AVANCADO');
    sp_inserir_funcionario(4, 'Luciana Ramos', '666.777.888-99', 'luciana.ramos@smartfactory.com.br', '(11) 96666-7777', 'Analista de Processos', 'INTERMEDIARIO');
    sp_inserir_funcionario(5, 'Rafael Torres', '777.888.999-00', 'rafael.torres@cloudfirst.com.br', '(11) 97777-8888', 'Arquiteto Cloud', 'EXPERT');
    sp_inserir_funcionario(5, 'Tatiana Lopes', '888.999.000-11', 'tatiana.lopes@cloudfirst.com.br', '(11) 98888-9999', 'Desenvolvedora Cloud', 'INTERMEDIARIO');
    sp_inserir_funcionario(6, 'André Silva', '999.000.111-22', 'andre.silva@aisolutions.com.br', '(11) 99999-0000', 'Cientista de Dados', 'AVANCADO');
    sp_inserir_funcionario(7, 'Beatriz Nunes', '000.111.222-33', 'beatriz.nunes@robotech.com.br', '(41) 90000-1111', 'Engenheira Robótica', 'AVANCADO');
    sp_inserir_funcionario(8, 'Felipe Souza', '111.222.333-45', 'felipe.souza@datasciencecorp.com.br', '(11) 91111-2223', 'Engenheiro de Dados', 'AVANCADO');
    sp_inserir_funcionario(8, 'Renata Castro', '222.333.444-56', 'renata.castro@datasciencecorp.com.br', '(11) 92222-3334', 'Analista de BI', 'INTERMEDIARIO');
    sp_inserir_funcionario(9, 'Gustavo Lima', '333.444.555-67', 'gustavo.lima@cybersec.com.br', '(11) 93333-4445', 'Especialista em Segurança', 'EXPERT');
    sp_inserir_funcionario(10, 'Isabela Moreira', '444.555.666-78', 'isabela.moreira@iotindustry.com.br', '(11) 94444-5556', 'Desenvolvedora IoT', 'AVANCADO');
    sp_inserir_funcionario(11, 'Marcelo Reis', '555.666.777-89', 'marcelo.reis@devopsmasters.com.br', '(11) 95555-6667', 'Engenheiro SRE', 'EXPERT');
    sp_inserir_funcionario(12, 'Daniela Araújo', '666.777.888-90', 'daniela.araujo@blockchainbr.com.br', '(11) 96666-7778', 'Desenvolvedora Blockchain', 'AVANCADO');
    sp_inserir_funcionario(13, 'Vinícius Pinto', '777.888.999-01', 'vinicius.pinto@fintechinnovations.com.br', '(11) 97777-8889', 'Desenvolvedor Full Stack', 'INTERMEDIARIO');
    sp_inserir_funcionario(14, 'Aline Cardoso', '888.999.000-12', 'aline.cardoso@greentech.com.br', '(41) 98888-9990', 'Engenheira Ambiental', 'INTERMEDIARIO');
    sp_inserir_funcionario(15, 'Diego Ferreira', '999.000.111-23', 'diego.ferreira@quantumcomp.com.br', '(11) 99999-0001', 'Pesquisador Quântico', 'EXPERT');
    sp_inserir_funcionario(1, 'Larissa Monteiro', '000.111.222-34', 'larissa.monteiro@techfuture.com.br', '(11) 90000-1112', 'QA Engineer', 'INICIANTE');

    DBMS_OUTPUT.PUT_LINE('20 funcionários inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir funcionários: ' || SQLERRM);
END;
/

-- ============================================================
-- ASSOCIAR FUNCIONÁRIOS AOS TIMES (20 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Associando Funcionários aos Times ---');

    sp_adicionar_funcionario_time(1, 2);   -- João -> Time Backend
    sp_adicionar_funcionario_time(2, 1);   -- Maria -> Time DevOps
    sp_adicionar_funcionario_time(3, 3);   -- Paulo -> Time Automação Industrial
    sp_adicionar_funcionario_time(4, 3);   -- Carla -> Time Automação Industrial
    sp_adicionar_funcionario_time(5, 4);   -- Bruno -> Time Transformação Digital
    sp_adicionar_funcionario_time(6, 5);   -- Luciana -> Time Manufatura 4.0
    sp_adicionar_funcionario_time(7, 6);   -- Rafael -> Time Cloud Native
    sp_adicionar_funcionario_time(8, 6);   -- Tatiana -> Time Cloud Native
    sp_adicionar_funcionario_time(9, 7);   -- André -> Time Machine Learning
    sp_adicionar_funcionario_time(10, 8);  -- Beatriz -> Time Robótica Avançada
    sp_adicionar_funcionario_time(11, 9);  -- Felipe -> Time Big Data
    sp_adicionar_funcionario_time(12, 9);  -- Renata -> Time Big Data
    sp_adicionar_funcionario_time(13, 10); -- Gustavo -> Time Cibersegurança
    sp_adicionar_funcionario_time(14, 11); -- Isabela -> Time IoT
    sp_adicionar_funcionario_time(15, 12); -- Marcelo -> Time SRE
    sp_adicionar_funcionario_time(16, 13); -- Daniela -> Time Smart Contracts
    sp_adicionar_funcionario_time(17, 14); -- Vinícius -> Time Pagamentos Digitais
    sp_adicionar_funcionario_time(18, 15); -- Aline -> Time Energia Renovável
    sp_adicionar_funcionario_time(19, 6);  -- Diego -> Time Cloud Native
    sp_adicionar_funcionario_time(20, 2);  -- Larissa -> Time Backend

    DBMS_OUTPUT.PUT_LINE('20 associações criadas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao associar funcionários aos times: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR CATEGORIAS DE CURSOS (10 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Categorias de Cursos ---');

    sp_inserir_categoria_curso('Desenvolvimento de Software', 'Cursos focados em programação e desenvolvimento');
    sp_inserir_categoria_curso('Cloud Computing', 'Computação em nuvem e arquitetura distribuída');
    sp_inserir_categoria_curso('Inteligência Artificial', 'Machine Learning, Deep Learning e IA');
    sp_inserir_categoria_curso('Automação Industrial', 'Automação de processos e indústria 4.0');
    sp_inserir_categoria_curso('Segurança da Informação', 'Cibersegurança e proteção de dados');
    sp_inserir_categoria_curso('Internet das Coisas', 'IoT, sensores e dispositivos conectados');
    sp_inserir_categoria_curso('DevOps e SRE', 'Práticas DevOps e engenharia de confiabilidade');
    sp_inserir_categoria_curso('Blockchain', 'Tecnologia blockchain e criptomoedas');
    sp_inserir_categoria_curso('Análise de Dados', 'Big Data, Analytics e Business Intelligence');
    sp_inserir_categoria_curso('Gestão de Projetos', 'Metodologias ágeis e gestão de equipes');

    DBMS_OUTPUT.PUT_LINE('10 categorias inseridas com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir categorias: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR CURSOS (15 registros)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Cursos ---');

    sp_inserir_curso(1, 'Python para Iniciantes', 'Fundamentos da linguagem Python aplicados ao mundo corporativo', 40, 'INICIANTE', 100);
    sp_inserir_curso(1, 'Java Avançado e Microserviços', 'Desenvolvimento de aplicações enterprise com Java', 80, 'AVANCADO', 200);
    sp_inserir_curso(2, 'AWS Cloud Practitioner', 'Fundamentos de computação em nuvem AWS', 30, 'INICIANTE', 150);
    sp_inserir_curso(2, 'Kubernetes para DevOps', 'Orquestração de containers com Kubernetes', 60, 'AVANCADO', 250);
    sp_inserir_curso(3, 'Machine Learning com Python', 'Criação de modelos de ML para problemas reais', 100, 'INTERMEDIARIO', 300);
    sp_inserir_curso(3, 'Deep Learning e Redes Neurais', 'Arquiteturas de redes neurais profundas', 120, 'AVANCADO', 350);
    sp_inserir_curso(4, 'Automação com RPA', 'Robotic Process Automation para empresas', 50, 'INTERMEDIARIO', 200);
    sp_inserir_curso(4, 'Indústria 4.0 na Prática', 'Implementação de conceitos de indústria 4.0', 70, 'AVANCADO', 280);
    sp_inserir_curso(5, 'Ethical Hacking Essentials', 'Fundamentos de testes de penetração', 90, 'INTERMEDIARIO', 250);
    sp_inserir_curso(6, 'IoT com Arduino e Raspberry Pi', 'Desenvolvimento de soluções IoT', 60, 'INTERMEDIARIO', 180);
    sp_inserir_curso(7, 'CI/CD com Jenkins e GitLab', 'Pipelines de integração contínua', 45, 'INTERMEDIARIO', 200);
    sp_inserir_curso(8, 'Smart Contracts com Solidity', 'Desenvolvimento de contratos inteligentes', 80, 'AVANCADO', 300);
    sp_inserir_curso(9, 'Big Data com Apache Spark', 'Processamento de grandes volumes de dados', 100, 'AVANCADO', 320);
    sp_inserir_curso(10, 'Scrum Master Certification', 'Gestão ágil de projetos com Scrum', 40, 'INICIANTE', 150);
    sp_inserir_curso(1, 'API REST com Node.js', 'Desenvolvimento de APIs RESTful', 50, 'INTERMEDIARIO', 180);

    DBMS_OUTPUT.PUT_LINE('15 cursos inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir cursos: ' || SQLERRM);
END;
/

-- ============================================================
-- INSERIR MÓDULOS (40+ registros - distribuídos entre cursos)
-- ============================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Inserindo Módulos ---');

    -- Módulos do Curso 1: Python para Iniciantes
    sp_inserir_modulo(1, 1, 'Introdução ao Python', 'Sintaxe básica e estrutura', 'Conteúdo sobre sintaxe Python', 120, 1);
    sp_inserir_modulo(1, 2, 'Estruturas de Dados', 'Listas, dicionários e tuplas', 'Conteúdo sobre estruturas de dados', 180, 2);
    sp_inserir_modulo(1, 3, 'Funções e Módulos', 'Criação e uso de funções', 'Conteúdo sobre funções', 150, 3);
    sp_inserir_modulo(1, 4, 'Programação Orientada a Objetos', 'POO em Python', 'Conteúdo sobre POO', 200, 4);

    -- Módulos do Curso 2: Java Avançado
    sp_inserir_modulo(2, 1, 'Spring Framework', 'Introdução ao Spring', 'Conteúdo sobre Spring', 300, 1);
    sp_inserir_modulo(2, 2, 'Microserviços com Spring Boot', 'Arquitetura de microserviços', 'Conteúdo sobre microserviços', 400, 2);
    sp_inserir_modulo(2, 3, 'APIs RESTful', 'Desenvolvimento de APIs REST', 'Conteúdo sobre REST', 350, 3);

    -- Módulos do Curso 3: AWS Cloud Practitioner
    sp_inserir_modulo(3, 1, 'Fundamentos de Cloud', 'Conceitos básicos de nuvem', 'Conteúdo sobre cloud', 180, 1);
    sp_inserir_modulo(3, 2, 'Serviços AWS', 'Principais serviços da AWS', 'Conteúdo sobre AWS', 240, 2);
    sp_inserir_modulo(3, 3, 'Segurança na AWS', 'Práticas de segurança', 'Conteúdo sobre segurança', 200, 3);

    -- Módulos do Curso 4: Kubernetes
    sp_inserir_modulo(4, 1, 'Conceitos de Containers', 'Docker e containers', 'Conteúdo sobre containers', 300, 1);
    sp_inserir_modulo(4, 2, 'Arquitetura Kubernetes', 'Componentes do K8s', 'Conteúdo sobre K8s', 400, 2);
    sp_inserir_modulo(4, 3, 'Deploy e Scaling', 'Deployment e escalabilidade', 'Conteúdo sobre deploy', 350, 3);
    sp_inserir_modulo(4, 4, 'Monitoramento e Logs', 'Observabilidade em K8s', 'Conteúdo sobre monitoring', 300, 4);

    -- Módulos do Curso 5: Machine Learning
    sp_inserir_modulo(5, 1, 'Fundamentos de ML', 'Conceitos básicos de ML', 'Conteúdo sobre ML', 400, 1);
    sp_inserir_modulo(5, 2, 'Regressão e Classificação', 'Algoritmos supervisionados', 'Conteúdo sobre algoritmos', 500, 2);
    sp_inserir_modulo(5, 3, 'Clustering', 'Algoritmos não supervisionados', 'Conteúdo sobre clustering', 450, 3);
    sp_inserir_modulo(5, 4, 'Avaliação de Modelos', 'Métricas e validação', 'Conteúdo sobre avaliação', 350, 4);

    -- Módulos do Curso 6: Deep Learning
    sp_inserir_modulo(6, 1, 'Redes Neurais Básicas', 'Fundamentos de redes neurais', 'Conteúdo sobre redes neurais', 500, 1);
    sp_inserir_modulo(6, 2, 'CNNs para Visão Computacional', 'Redes Convolucionais', 'Conteúdo sobre CNNs', 600, 2);
    sp_inserir_modulo(6, 3, 'RNNs e LSTM', 'Redes Recorrentes', 'Conteúdo sobre RNNs', 550, 3);
    sp_inserir_modulo(6, 4, 'Transfer Learning', 'Transferência de aprendizado', 'Conteúdo sobre transfer learning', 500, 4);

    -- Módulos do Curso 7: Automação com RPA
    sp_inserir_modulo(7, 1, 'Introdução ao RPA', 'Conceitos de RPA', 'Conteúdo sobre RPA', 250, 1);
    sp_inserir_modulo(7, 2, 'UiPath Studio', 'Desenvolvimento com UiPath', 'Conteúdo sobre UiPath', 400, 2);
    sp_inserir_modulo(7, 3, 'Automação de Processos', 'Cases práticos', 'Conteúdo sobre automação', 350, 3);

    -- Módulos do Curso 8: Indústria 4.0
    sp_inserir_modulo(8, 1, 'Conceitos de Indústria 4.0', 'Transformação digital', 'Conteúdo sobre indústria 4.0', 300, 1);
    sp_inserir_modulo(8, 2, 'IoT na Manufatura', 'Sensores e conectividade', 'Conteúdo sobre IoT industrial', 400, 2);
    sp_inserir_modulo(8, 3, 'Big Data na Indústria', 'Analytics para manufatura', 'Conteúdo sobre big data', 450, 3);

    -- Módulos do Curso 9: Ethical Hacking
    sp_inserir_modulo(9, 1, 'Fundamentos de Segurança', 'Conceitos básicos', 'Conteúdo sobre segurança', 350, 1);
    sp_inserir_modulo(9, 2, 'Técnicas de Pentest', 'Testes de penetração', 'Conteúdo sobre pentest', 500, 2);
    sp_inserir_modulo(9, 3, 'Exploração de Vulnerabilidades', 'OWASP Top 10', 'Conteúdo sobre vulnerabilidades', 450, 3);
    sp_inserir_modulo(9, 4, 'Relatórios de Segurança', 'Documentação técnica', 'Conteúdo sobre relatórios', 300, 4);

    -- Módulos do Curso 10: IoT com Arduino
    sp_inserir_modulo(10, 1, 'Introdução ao Arduino', 'Hardware e programação', 'Conteúdo sobre Arduino', 300, 1);
    sp_inserir_modulo(10, 2, 'Sensores e Atuadores', 'Componentes IoT', 'Conteúdo sobre sensores', 350, 2);
    sp_inserir_modulo(10, 3, 'Conectividade IoT', 'WiFi, Bluetooth e LoRa', 'Conteúdo sobre conectividade', 400, 3);

    -- Módulos dos demais cursos (11-15)
    sp_inserir_modulo(11, 1, 'Fundamentos de CI/CD', 'Conceitos de integração contínua', 'Conteúdo sobre CI/CD', 250, 1);
    sp_inserir_modulo(11, 2, 'Jenkins Pipelines', 'Criação de pipelines', 'Conteúdo sobre Jenkins', 400, 2);
    sp_inserir_modulo(11, 3, 'GitLab CI', 'CI/CD com GitLab', 'Conteúdo sobre GitLab', 350, 3);

    sp_inserir_modulo(12, 1, 'Blockchain Básico', 'Fundamentos de blockchain', 'Conteúdo sobre blockchain', 400, 1);
    sp_inserir_modulo(12, 2, 'Solidity Programming', 'Linguagem Solidity', 'Conteúdo sobre Solidity', 500, 2);
    sp_inserir_modulo(12, 3, 'Deploy de Contratos', 'Implantação na rede', 'Conteúdo sobre deploy', 450, 3);

    sp_inserir_modulo(13, 1, 'Apache Spark Core', 'Fundamentos do Spark', 'Conteúdo sobre Spark', 500, 1);
    sp_inserir_modulo(13, 2, 'Spark SQL', 'Processamento estruturado', 'Conteúdo sobre Spark SQL', 450, 2);
    sp_inserir_modulo(13, 3, 'Spark Streaming', 'Processamento em tempo real', 'Conteúdo sobre streaming', 500, 3);

    DBMS_OUTPUT.PUT_LINE('40+ módulos inseridos com sucesso!');
    DBMS_OUTPUT.PUT_LINE('');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir módulos: ' || SQLERRM);
END;
/

-- ============================================================
-- Continuar com matrículas, competências e outros dados...
-- (Parte 2 do script em arquivo separado devido ao tamanho)
-- ============================================================

COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PRIMEIRA PARTE DA INSERÇÃO CONCLUÍDA ===');
    DBMS_OUTPUT.PUT_LINE('Continue executando o arquivo 02_inserir_dados_parte2.sql');
END;
/
