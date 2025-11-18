# Importação de Dados para MongoDB

## Pré-requisitos
- MongoDB instalado (versão 4.0 ou superior)
- MongoDB Compass (opcional, para visualização gráfica)
- Arquivo `dataset_export.json` gerado pelo Oracle

## Passo 1: Gerar o Dataset JSON no Oracle

Execute no Oracle SQL Developer ou SQL*Plus:

```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LONG 100000000;
SET LONGCHUNKSIZE 100000000;
SET LINESIZE 32767;
SET PAGESIZE 0;
SET FEEDBACK OFF;
SET HEADING OFF;

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

Isso irá gerar o arquivo `dataset_export.json` com todo o dataset.

## Passo 2: Criar o Banco de Dados MongoDB

```bash
# Conectar ao MongoDB
mongo

# Criar banco de dados
use plataforma_cursos

# Verificar conexão
db.stats()
```

## Passo 3: Importar o Dataset

### Opção A: Importar como um único documento

```bash
mongoimport --db plataforma_cursos --collection dataset --file dataset_export.json --jsonArray
```

### Opção B: Separar em coleções individuais (Recomendado)

Use o script Python fornecido em `02_import_to_mongodb.py`:

```bash
python 02_import_to_mongodb.py
```

## Passo 4: Criar Índices para Performance

Execute o script `03_create_indexes.js`:

```bash
mongo plataforma_cursos < 03_create_indexes.js
```

## Passo 5: Verificar a Importação

```bash
mongo plataforma_cursos

# Contar documentos em cada coleção
db.empresas.count()
db.funcionarios.count()
db.cursos.count()
db.competencias.count()
db.matriculas.count()
db.certificados.count()
```

## Estrutura de Coleções MongoDB

### Coleção: `empresas`
- Empresas cadastradas na plataforma
- Índice: `cnpj`, `email`

### Coleção: `funcionarios`
- Funcionários das empresas
- Índice: `email`, `nivel_atual`, `pontos_acumulados`

### Coleção: `cursos`
- Cursos disponíveis
- Índice: `categoria`, `nivel`, `nome`

### Coleção: `competencias`
- Competências técnicas
- Índice: `categoria`, `nivel_mercado`

### Coleção: `matriculas`
- Matrículas e performance dos funcionários
- Índice: `funcionario`, `curso`, `status`

### Coleção: `certificados`
- Certificados emitidos
- Índice: `codigo`, `funcionario`

## Consultas de Exemplo

### 1. Listar funcionários com mais pontos

```javascript
db.funcionarios.find().sort({ pontos_acumulados: -1 }).limit(10)
```

### 2. Cursos mais populares

```javascript
db.cursos.find().sort({ total_matriculas: -1 }).limit(5)
```

### 3. Competências em alta no mercado

```javascript
db.competencias.find({ nivel_mercado: "EM_ALTA" })
```

### 4. Taxa de conclusão de cursos

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

### 5. Funcionários por nível

```javascript
db.funcionarios.aggregate([
  {
    $group: {
      _id: "$nivel_atual",
      total: { $sum: 1 },
      media_pontos: { $avg: "$pontos_acumulados" }
    }
  }
])
```

## Backup MongoDB

### Criar backup

```bash
mongodump --db plataforma_cursos --out ./backup
```

### Restaurar backup

```bash
mongorestore --db plataforma_cursos ./backup/plataforma_cursos
```

## Integração com Aplicações

### Python (PyMongo)

```python
from pymongo import MongoClient

client = MongoClient('mongodb://localhost:27017/')
db = client['plataforma_cursos']

# Buscar funcionários
funcionarios = db.funcionarios.find({ "nivel_atual": "EXPERT" })
for func in funcionarios:
    print(func['nome'], func['pontos_acumulados'])
```

### Node.js (MongoDB Driver)

```javascript
const { MongoClient } = require('mongodb');

async function main() {
  const client = new MongoClient('mongodb://localhost:27017');
  await client.connect();

  const db = client.db('plataforma_cursos');
  const funcionarios = await db.collection('funcionarios')
    .find({ nivel_atual: 'EXPERT' })
    .toArray();

  console.log(funcionarios);
  await client.close();
}

main();
```

### Java (MongoDB Driver)

```java
import com.mongodb.client.*;
import org.bson.Document;

public class MongoDBConnection {
    public static void main(String[] args) {
        MongoClient client = MongoClients.create("mongodb://localhost:27017");
        MongoDatabase db = client.getDatabase("plataforma_cursos");
        MongoCollection<Document> collection = db.getCollection("funcionarios");

        for (Document doc : collection.find(new Document("nivel_atual", "EXPERT"))) {
            System.out.println(doc.toJson());
        }

        client.close();
    }
}
```

## Troubleshooting

### Erro: "JSON parse error"
- Verifique se o arquivo JSON está bem formatado
- Certifique-se de que não há caracteres especiais não escapados

### Erro: "Connection refused"
- Verifique se o MongoDB está em execução: `sudo service mongod status`
- Inicie o serviço: `sudo service mongod start`

### Performance lenta
- Crie índices nas coleções (veja `03_create_indexes.js`)
- Considere usar agregações para consultas complexas
- Monitore com: `db.currentOp()` e `db.serverStatus()`

## Próximos Passos

1. Explore os dados usando MongoDB Compass
2. Crie visualizações com agregações
3. Integre com sua aplicação Java/C#/Mobile
4. Configure autenticação e segurança
5. Implemente replicação para alta disponibilidade
