// ============================================================
// SCRIPT DE CRIAÇÃO DE ÍNDICES MONGODB
// Otimização de consultas para a Plataforma de Cursos
// ============================================================

print("\n==========================================================");
print("CRIANDO ÍNDICES PARA OTIMIZAÇÃO DE CONSULTAS");
print("==========================================================\n");

// Usar o banco de dados
db = db.getSiblingDB('plataforma_cursos');

// ============================================================
// ÍNDICES PARA EMPRESAS
// ============================================================
print("Criando índices para 'empresas'...");

db.empresas.createIndex({ "cnpj": 1 }, { unique: true, name: "idx_empresas_cnpj" });
db.empresas.createIndex({ "email": 1 }, { name: "idx_empresas_email" });
db.empresas.createIndex({ "razao_social": 1 }, { name: "idx_empresas_razao_social" });
db.empresas.createIndex({ "data_cadastro": -1 }, { name: "idx_empresas_data_cadastro" });

print("✓ Índices criados para 'empresas'\n");

// ============================================================
// ÍNDICES PARA FUNCIONARIOS
// ============================================================
print("Criando índices para 'funcionarios'...");

db.funcionarios.createIndex({ "email": 1 }, { unique: true, name: "idx_funcionarios_email" });
db.funcionarios.createIndex({ "nivel_atual": 1 }, { name: "idx_funcionarios_nivel" });
db.funcionarios.createIndex({ "pontos_acumulados": -1 }, { name: "idx_funcionarios_pontos_desc" });
db.funcionarios.createIndex({ "empresa": 1 }, { name: "idx_funcionarios_empresa" });
db.funcionarios.createIndex({ "cargo": 1 }, { name: "idx_funcionarios_cargo" });
db.funcionarios.createIndex(
    { "nivel_atual": 1, "pontos_acumulados": -1 },
    { name: "idx_funcionarios_nivel_pontos" }
);

print("✓ Índices criados para 'funcionarios'\n");

// ============================================================
// ÍNDICES PARA CURSOS
// ============================================================
print("Criando índices para 'cursos'...");

db.cursos.createIndex({ "categoria": 1 }, { name: "idx_cursos_categoria" });
db.cursos.createIndex({ "nivel": 1 }, { name: "idx_cursos_nivel" });
db.cursos.createIndex({ "nome": 1 }, { name: "idx_cursos_nome" });
db.cursos.createIndex({ "total_matriculas": -1 }, { name: "idx_cursos_matriculas_desc" });
db.cursos.createIndex({ "pontos": -1 }, { name: "idx_cursos_pontos_desc" });
db.cursos.createIndex(
    { "categoria": 1, "nivel": 1 },
    { name: "idx_cursos_categoria_nivel" }
);

// Índice de texto para busca full-text
db.cursos.createIndex(
    { "nome": "text", "descricao": "text" },
    { name: "idx_cursos_text_search" }
);

print("✓ Índices criados para 'cursos'\n");

// ============================================================
// ÍNDICES PARA COMPETENCIAS
// ============================================================
print("Criando índices para 'competencias'...");

db.competencias.createIndex({ "nome": 1 }, { unique: true, name: "idx_competencias_nome" });
db.competencias.createIndex({ "categoria": 1 }, { name: "idx_competencias_categoria" });
db.competencias.createIndex({ "nivel_mercado": 1 }, { name: "idx_competencias_nivel_mercado" });
db.competencias.createIndex(
    { "total_funcionarios_com_competencia": -1 },
    { name: "idx_competencias_popularidade" }
);
db.competencias.createIndex(
    { "categoria": 1, "nivel_mercado": 1 },
    { name: "idx_competencias_cat_mercado" }
);

// Índice de texto para busca
db.competencias.createIndex(
    { "nome": "text", "descricao": "text" },
    { name: "idx_competencias_text_search" }
);

print("✓ Índices criados para 'competencias'\n");

// ============================================================
// ÍNDICES PARA MATRICULAS
// ============================================================
print("Criando índices para 'matriculas'...");

db.matriculas.createIndex({ "funcionario": 1 }, { name: "idx_matriculas_funcionario" });
db.matriculas.createIndex({ "curso": 1 }, { name: "idx_matriculas_curso" });
db.matriculas.createIndex({ "status": 1 }, { name: "idx_matriculas_status" });
db.matriculas.createIndex({ "data_matricula": -1 }, { name: "idx_matriculas_data_desc" });
db.matriculas.createIndex({ "percentual_conclusao": -1 }, { name: "idx_matriculas_percentual" });
db.matriculas.createIndex({ "nota_final": -1 }, { name: "idx_matriculas_nota" });

// Índices compostos
db.matriculas.createIndex(
    { "funcionario": 1, "curso": 1 },
    { name: "idx_matriculas_func_curso" }
);
db.matriculas.createIndex(
    { "status": 1, "data_matricula": -1 },
    { name: "idx_matriculas_status_data" }
);
db.matriculas.createIndex(
    { "funcionario": 1, "status": 1 },
    { name: "idx_matriculas_func_status" }
);

print("✓ Índices criados para 'matriculas'\n");

// ============================================================
// ÍNDICES PARA CERTIFICADOS
// ============================================================
print("Criando índices para 'certificados'...");

db.certificados.createIndex({ "codigo": 1 }, { unique: true, name: "idx_certificados_codigo" });
db.certificados.createIndex({ "funcionario": 1 }, { name: "idx_certificados_funcionario" });
db.certificados.createIndex({ "curso": 1 }, { name: "idx_certificados_curso" });
db.certificados.createIndex({ "data_emissao": -1 }, { name: "idx_certificados_data_desc" });
db.certificados.createIndex({ "nota_final": -1 }, { name: "idx_certificados_nota" });

print("✓ Índices criados para 'certificados'\n");

// ============================================================
// VALIDAÇÃO DOS ÍNDICES
// ============================================================
print("==========================================================");
print("VALIDAÇÃO DOS ÍNDICES CRIADOS");
print("==========================================================\n");

var collections = ['empresas', 'funcionarios', 'cursos', 'competencias', 'matriculas', 'certificados'];

collections.forEach(function(collectionName) {
    var indexes = db[collectionName].getIndexes();
    print("Coleção: " + collectionName);
    print("  Total de índices: " + indexes.length);

    indexes.forEach(function(index) {
        print("  - " + index.name + " | Chaves: " + JSON.stringify(index.key));
    });

    print("");
});

// ============================================================
// ESTATÍSTICAS DE ARMAZENAMENTO
// ============================================================
print("==========================================================");
print("ESTATÍSTICAS DE ARMAZENAMENTO");
print("==========================================================\n");

var dbStats = db.stats();
print("Banco de dados: " + dbStats.db);
print("Coleções: " + dbStats.collections);
print("Tamanho dos dados: " + (dbStats.dataSize / 1024 / 1024).toFixed(2) + " MB");
print("Tamanho dos índices: " + (dbStats.indexSize / 1024 / 1024).toFixed(2) + " MB");
print("Tamanho total: " + (dbStats.storageSize / 1024 / 1024).toFixed(2) + " MB");
print("");

collections.forEach(function(collectionName) {
    var count = db[collectionName].count();
    var stats = db[collectionName].stats();

    print(collectionName + ":");
    print("  Documentos: " + count);
    print("  Tamanho médio: " + (stats.avgObjSize / 1024).toFixed(2) + " KB");
    print("");
});

// ============================================================
// QUERIES DE EXEMPLO OTIMIZADAS
// ============================================================
print("==========================================================");
print("EXEMPLOS DE QUERIES OTIMIZADAS");
print("==========================================================\n");

print("1. Top 5 funcionários com mais pontos:");
db.funcionarios.find(
    {},
    { nome: 1, cargo: 1, pontos_acumulados: 1, _id: 0 }
).sort({ pontos_acumulados: -1 }).limit(5).forEach(printjson);

print("\n2. Cursos em alta (mais matrículas):");
db.cursos.find(
    {},
    { nome: 1, categoria: 1, total_matriculas: 1, _id: 0 }
).sort({ total_matriculas: -1 }).limit(3).forEach(printjson);

print("\n3. Competências em alta no mercado:");
db.competencias.find(
    { nivel_mercado: "EM_ALTA" },
    { nome: 1, categoria: 1, total_funcionarios_com_competencia: 1, _id: 0 }
).sort({ total_funcionarios_com_competencia: -1 }).limit(3).forEach(printjson);

print("\n==========================================================");
print("✓ ÍNDICES CRIADOS E VALIDADOS COM SUCESSO!");
print("==========================================================\n");
