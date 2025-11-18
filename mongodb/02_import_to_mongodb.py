#!/usr/bin/env python3
"""
Script de Importação de Dataset JSON para MongoDB
Plataforma de Cursos Corporativa - O Futuro do Trabalho
"""

import json
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure, OperationFailure
from datetime import datetime
import sys

class MongoDBImporter:
    def __init__(self, connection_string='mongodb://localhost:27017/', db_name='plataforma_cursos'):
        """
        Inicializa o importador MongoDB

        Args:
            connection_string: String de conexão MongoDB
            db_name: Nome do banco de dados
        """
        self.connection_string = connection_string
        self.db_name = db_name
        self.client = None
        self.db = None

    def connect(self):
        """Conecta ao MongoDB"""
        try:
            print(f"[{datetime.now()}] Conectando ao MongoDB...")
            self.client = MongoClient(self.connection_string, serverSelectionTimeoutMS=5000)
            # Testar conexão
            self.client.server_info()
            self.db = self.client[self.db_name]
            print(f"[{datetime.now()}] ✓ Conectado ao banco '{self.db_name}' com sucesso!")
            return True
        except ConnectionFailure as e:
            print(f"[{datetime.now()}] ✗ Erro ao conectar ao MongoDB: {e}")
            return False
        except Exception as e:
            print(f"[{datetime.now()}] ✗ Erro inesperado: {e}")
            return False

    def load_json_file(self, file_path='dataset_export.json'):
        """
        Carrega o arquivo JSON exportado do Oracle

        Args:
            file_path: Caminho do arquivo JSON

        Returns:
            dict: Dados carregados do JSON
        """
        try:
            print(f"\n[{datetime.now()}] Carregando arquivo '{file_path}'...")
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            print(f"[{datetime.now()}] ✓ Arquivo carregado com sucesso!")
            return data
        except FileNotFoundError:
            print(f"[{datetime.now()}] ✗ Arquivo não encontrado: {file_path}")
            return None
        except json.JSONDecodeError as e:
            print(f"[{datetime.now()}] ✗ Erro ao decodificar JSON: {e}")
            return None
        except Exception as e:
            print(f"[{datetime.now()}] ✗ Erro ao carregar arquivo: {e}")
            return None

    def clear_database(self):
        """Limpa todas as coleções existentes"""
        try:
            print(f"\n[{datetime.now()}] Limpando coleções existentes...")
            collections = self.db.list_collection_names()
            for collection in collections:
                self.db[collection].drop()
                print(f"  - Coleção '{collection}' removida")
            print(f"[{datetime.now()}] ✓ Database limpo!")
        except Exception as e:
            print(f"[{datetime.now()}] ✗ Erro ao limpar database: {e}")

    def import_collection(self, collection_name, documents):
        """
        Importa documentos para uma coleção

        Args:
            collection_name: Nome da coleção
            documents: Lista de documentos a inserir
        """
        if not documents:
            print(f"  ⚠ Nenhum documento para inserir em '{collection_name}'")
            return

        try:
            collection = self.db[collection_name]
            result = collection.insert_many(documents)
            print(f"  ✓ {len(result.inserted_ids)} documentos inseridos em '{collection_name}'")
        except Exception as e:
            print(f"  ✗ Erro ao inserir em '{collection_name}': {e}")

    def import_all_data(self, data):
        """
        Importa todos os dados para as respectivas coleções

        Args:
            data: Dicionário com todos os dados do JSON
        """
        print(f"\n[{datetime.now()}] Iniciando importação de dados...\n")

        # Mapear chaves do JSON para nomes de coleções
        mappings = {
            'empresas': 'empresas',
            'funcionarios': 'funcionarios',
            'cursos': 'cursos',
            'competencias': 'competencias',
            'matriculas': 'matriculas',
            'certificados': 'certificados'
        }

        total_documents = 0

        for json_key, collection_name in mappings.items():
            if json_key in data:
                documents = data[json_key]
                print(f"[{datetime.now()}] Importando coleção '{collection_name}'...")
                self.import_collection(collection_name, documents)
                total_documents += len(documents)
            else:
                print(f"  ⚠ Chave '{json_key}' não encontrada no JSON")

        # Importar estatísticas como um documento único
        if 'estatisticas' in data:
            print(f"[{datetime.now()}] Importando estatísticas...")
            stats_collection = self.db['estatisticas']
            stats_doc = data['estatisticas']
            stats_doc['_id'] = 'global_stats'
            stats_doc['ultima_atualizacao'] = datetime.now().isoformat()
            stats_collection.insert_one(stats_doc)
            print(f"  ✓ Estatísticas importadas")

        print(f"\n[{datetime.now()}] ✓ Importação concluída!")
        print(f"  Total de documentos importados: {total_documents}")

    def create_indexes(self):
        """Cria índices para otimizar consultas"""
        print(f"\n[{datetime.now()}] Criando índices...\n")

        try:
            # Índices para empresas
            self.db.empresas.create_index("cnpj", unique=True)
            self.db.empresas.create_index("email")
            print("  ✓ Índices criados para 'empresas'")

            # Índices para funcionarios
            self.db.funcionarios.create_index("email", unique=True)
            self.db.funcionarios.create_index("nivel_atual")
            self.db.funcionarios.create_index("pontos_acumulados")
            self.db.funcionarios.create_index([("pontos_acumulados", -1)])  # Decrescente
            print("  ✓ Índices criados para 'funcionarios'")

            # Índices para cursos
            self.db.cursos.create_index("categoria")
            self.db.cursos.create_index("nivel")
            self.db.cursos.create_index("nome")
            print("  ✓ Índices criados para 'cursos'")

            # Índices para competencias
            self.db.competencias.create_index("categoria")
            self.db.competencias.create_index("nivel_mercado")
            self.db.competencias.create_index("nome")
            print("  ✓ Índices criados para 'competencias'")

            # Índices para matriculas
            self.db.matriculas.create_index("funcionario")
            self.db.matriculas.create_index("curso")
            self.db.matriculas.create_index("status")
            self.db.matriculas.create_index([("funcionario", 1), ("curso", 1)])
            print("  ✓ Índices criados para 'matriculas'")

            # Índices para certificados
            self.db.certificados.create_index("codigo", unique=True)
            self.db.certificados.create_index("funcionario")
            print("  ✓ Índices criados para 'certificados'")

            print(f"\n[{datetime.now()}] ✓ Todos os índices criados com sucesso!")

        except Exception as e:
            print(f"[{datetime.now()}] ✗ Erro ao criar índices: {e}")

    def show_statistics(self):
        """Exibe estatísticas do banco de dados"""
        print(f"\n{'='*60}")
        print("ESTATÍSTICAS DO BANCO DE DADOS")
        print(f"{'='*60}\n")

        try:
            collections = ['empresas', 'funcionarios', 'cursos', 'competencias',
                          'matriculas', 'certificados']

            for collection_name in collections:
                count = self.db[collection_name].count_documents({})
                print(f"  {collection_name.ljust(25)}: {count:>6} documentos")

            print(f"\n{'='*60}")

            # Estatísticas adicionais
            print("\nESTATÍSTICAS ADICIONAIS:")

            # Funcionários por nível
            print("\nFuncionários por nível:")
            pipeline = [
                {
                    "$group": {
                        "_id": "$nivel_atual",
                        "total": {"$sum": 1}
                    }
                },
                {"$sort": {"total": -1}}
            ]
            for doc in self.db.funcionarios.aggregate(pipeline):
                print(f"  {doc['_id']}: {doc['total']}")

            # Top 5 cursos mais procurados
            print("\nTop 5 cursos mais procurados:")
            top_cursos = self.db.cursos.find().sort("total_matriculas", -1).limit(5)
            for idx, curso in enumerate(top_cursos, 1):
                print(f"  {idx}. {curso['nome']} - {curso['total_matriculas']} matrículas")

            # Competências em alta
            print("\nCompetências em alta no mercado:")
            comp_alta = self.db.competencias.count_documents({"nivel_mercado": "EM_ALTA"})
            print(f"  Total: {comp_alta} competências")

            print(f"\n{'='*60}\n")

        except Exception as e:
            print(f"[{datetime.now()}] ✗ Erro ao gerar estatísticas: {e}")

    def close(self):
        """Fecha a conexão com o MongoDB"""
        if self.client:
            self.client.close()
            print(f"[{datetime.now()}] Conexão fechada.")

def main():
    """Função principal"""
    print(f"\n{'='*60}")
    print("IMPORTADOR DE DATASET PARA MONGODB")
    print("Plataforma de Cursos Corporativa - O Futuro do Trabalho")
    print(f"{'='*60}\n")

    # Configurações
    MONGODB_URI = 'mongodb://localhost:27017/'
    DATABASE_NAME = 'plataforma_cursos'
    JSON_FILE = 'dataset_export.json'

    # Inicializar importador
    importer = MongoDBImporter(MONGODB_URI, DATABASE_NAME)

    # Conectar
    if not importer.connect():
        print("\n✗ Falha ao conectar. Verifique se o MongoDB está rodando.")
        sys.exit(1)

    # Carregar arquivo JSON
    data = importer.load_json_file(JSON_FILE)
    if not data:
        print("\n✗ Falha ao carregar o arquivo JSON.")
        importer.close()
        sys.exit(1)

    # Perguntar se deseja limpar o banco
    print(f"\n⚠ ATENÇÃO: Isso irá remover todas as coleções existentes no banco '{DATABASE_NAME}'!")
    response = input("Deseja continuar? (s/N): ").lower()

    if response == 's':
        # Limpar database
        importer.clear_database()

        # Importar dados
        importer.import_all_data(data)

        # Criar índices
        importer.create_indexes()

        # Mostrar estatísticas
        importer.show_statistics()

        print(f"\n[{datetime.now()}] ✓ Processo concluído com sucesso!")
    else:
        print("\n✗ Operação cancelada pelo usuário.")

    # Fechar conexão
    importer.close()

    print(f"\n{'='*60}\n")

if __name__ == "__main__":
    main()
