# :rocket: Desafio
O desafio é capturar os dados que recebemos de peças e veículos compatives em diferentes formatos e armazená-los em um formato consistente para responder perguntas que ajudarão nosso time a ter uma melhor visão do que vendemos.

## Tarefas

**Sobre os dados**

Disponibilizamos para você os dados de produto e compatibilidade KarHub. São três conjuntos de arquivos diferentes

| Dataset | Descrição      |
| :---  | :---      |
|[**KarHub Alias**](./Karhub-alias.csv) | Mapa entre sinonimos e códigos reais do produto |
|[**Produtos KarHub**](./karhub_autoparts_1.xlsx) | Dados cadastrais do produto |
|**API de veículos compatíveis** | Dados de veículos que são compatíveis com o produto |

**1 - KarHub Alias**

Esse arquivo .csv contém um de/para entre o ID original do produto e os possiveís sinônimos (Alias)

| Campo | Descrição |
| :---  | :---      |
| **Fabricante**| Nome do fabricante |
| **Código Fabricante**| ID original do produto |
| **Alias**| Sinônimos dos IDs de produto |

**2 - Produtos KarHub**

Essa planilha em formato excel (.xlsx) contém os dados cadastrais do produto, com os seguintes campos:

| Campo | Descrição |
| :---  | :---      |
| **Nome SKU**| Nome do produto |
| **Fabricante**| Nome do fabricante |
| **Código**| ID do produto |
| **Composição**| Tipo de embalagem (Unitario, kit, etc.) |
| **Categoria**| Categoria do produto |
| **Nome Atributo**| Característica do produto (ex: peso, largura)|
| **Valor Atributo**| Valor da característica do produto |

OBS: o ID do produto dessa planilha é o Alias do csv [**KarHub Alias**](./Karhub-alias.csv)

* **2.1 - Precisamos transformar os atributos que estão em linhas em colunas**

Exemplo, **de**:

| Nome SKU | Fabricante | Código | Composição | Categoria | Nome Atributo | Valor Atributo |
| :---  | :--- | :--- | :--- | :--- | :--- | :--- |
| Mola da Suspensão Traseira | KarHub | fo0352 | UNITARY | Mola Helicoidal | Largura (cm) | 18.0 |
| Mola da Suspensão Traseira | KarHub | fo0352 | UNITARY | Mola Helicoidal | Altura (cm) | 9.0 |

**para:**
| Nome SKU | Fabricante | Código | Composição | Categoria | Largura (cm) | Altura (cm) |
| :---  | :--- | :--- | :--- | :--- | :--- | :--- |
| Mola da Suspensão Traseira | KarHub | fo0352 | UNITARY | Mola Helicoidal | 18.0 | 9.0 |

OBS: Existem alguns valores na planilha que estão com virgula (",") ao inves de ponto ("."), precisamos substituir esses casos para não dar erro no momento de inserir na base

**3 - API de veículos compatíveis**

A API devolve os dados de veículos compatíveis com os produtos recuperados na planilha [**Produtos KarHub**](./karhub_autoparts_1.xlsx)

* **3.1 - Cadastrar usuário para obter token de acesso da API :key:** 

**Request Address**: `https://api-data-engineer-test-3bqvkbbykq-uc.a.run.app/user/`

**Request Method** `POST`

**Request Parameters JSON**:
```
{
  "full_name": "string",
  "email": "user@example.com"
}
```

Preencha `full_name` com seu nome completo e `email` com seu email

**Curl**
```
curl -X 'POST' \
  'https://api-data-engineer-test-3bqvkbbykq-uc.a.run.app/user/' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "full_name": "Joao Henrique",
  "email": "joao@karhub.com.br"
}'
```
------
**Server response**

Code: **201**
Response Body: 
``` 
{
  "user": "joao@karhub.com.br",
  "API Token": "SEU_ACCESS_TOKEN"
}
```

* **3.2 - Consumir dados de veículos da API** 

Substituindo `access_token` pelo token obtido na etapa anterior, podemos chamar o endpoint `https://api-data-engineer-test-3bqvkbbykq-uc.a.run.app/token=access_token` que nos retorna dados de veículos compatíveis em formato **JSON**

Exemplo:
**Saída**
```
    {
        "Fabricante": "KarHub",
        "Código Fabricante": "FO0352",
        "Marca": "FORD",
        "Modelo": "FIESTA",
        "Ano": 1996,
        "Complemento": "1.0 MPI 8V CLASS 2P  | 1.0 MPI 8V - 4P  | 1.0 MPI 8V - 2P  | 1.3 MPI 8V CLX 4P  | 1.0 MPI 8V CLASS 4P  | 1.3 MPI 8V CLX 2P  | 1.4 MPI 16V CLX 4P  | 1.4 MPI 16V CLX 2P "
    }
```


| Campo | Descrição |
| :---  | :---      |
| **Nome SKU**| Nome do produto |
| **Fabricante**| Nome do fabricante |
| **Código Fabricante**| ID original do produto do produto (mesmo Código Fabricante do csv de alias) |
| **Marca**| Marca do carro |
| **Modelo**| Modelo do carro |
| **Ano**| Ano do veículo |
| **Complemento**| Atríbutos complementares do veiculo |

* **3.3 - Consumir dados de veículos da API** 

Os complementos que recuperamos da API estão separados pro pipe ("|") precisamos "explodi-los" em novas linhas no dataframe que criarmos.

Exemplo, **de**:
```
    {
        "Fabricante": "KarHub",
        "Código Fabricante": "FO0352",
        "Marca": "FORD",
        "Modelo": "FIESTA",
        "Ano": 1996,
        "Complemento": "1.0 MPI 8V CLASS 2P  | 1.0 MPI 8V - 4P  | 1.0 MPI 8V - 2P  | 1.3 MPI 8V CLX 4P  | 1.0 MPI 8V CLASS 4P  | 1.3 MPI 8V CLX 2P  | 1.4 MPI 16V CLX 4P  | 1.4 MPI 16V CLX 2P "
    }
```

**para:**

| Fabricante | Código Fabricante | Marca | Modelo | Ano | Complemento |
| :---  | :--- | :--- | :--- | :--- | :--- |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.0 MPI 8V CLASS 2P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.0 MPI 8V - 4P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.0 MPI 8V - 2P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.3 MPI 8V CLX 4P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.0 MPI 8V CLASS 4P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.3 MPI 8V CLX 2P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.4 MPI 16V CLX 4P |
| KarHub | FO0352 | FORD | FIESTA | 1996 | 1.4 MPI 16V CLX 2P |

### Transformar e tratar os dados em um dataframe com Python

**Regras de negócio**
* Precisamos juntar os dados de produtos e veículos compatíveis em um dataframe
* O arquivo excel (.xlsx) nos devolve o sinônimo do ID do produto e a API nos devolve o ID original do produto, precisamos usar o arquivo `Karhub-alias.csv` para fazer esse de/para entre esses dois campos antes de juntar
* Para ajudar a identificar registros mais atualizados e para nosso controle de auditoria, precisamos que o dataframe tenha as colunas `dt_insert` que contenha data/hora de inclusão do registro e `candidate_name` que contenha seu nome

### Inserir esse dataframe dentro de uma tabela no BigQuery
Deixamos os dados no jeitinho para que eles possam ser armazenados dentro de uma tabela na nossa base de dados.
Utilizando a **service account** enviada por email crie a tabela no banco de dados com a seguinte nomenclatura **karhub-data-engineer-test.cadastro_produto.kh_data_engineer_teste_seuNome**

* **project_id =** karhub-data-engineer-test
* **dataset_id =** cadastro_produto
* **table_id   =** kh_data_engineer_teste_seuNome

**Ponto de atenção**: *o BigQuery não aceita colunas com ponto ou caracter especial, precisaremos renomear as colunas que contenham alguns desses casos*

Leia sobre: [Nomes de coluna BigQuery](https://cloud.google.com/bigquery/docs/schemas#column_names) 

### Utilizando consultas SQL responda as perguntas ([Como executar consultas BigQuery com Python](https://cloud.google.com/bigquery/docs/pandas-gbq-migration#running_queries))

* Quantos **produtos únicos** temos na base?
* Quantos **veículos únicos** (mesma marca e modelo) temos na base por produto?
* Quantos **produtos únicos** temos na base por categoria ?

### O que esperamos:
* Seu projeto deve estar em um repositório **git** com o código em arquivo Python e/ou Jupyter Notebook e os arquivos de *queries* que você utilizou na construção das suas análises.
* Crie uma documentação que explique como fez para chegar nos resultados obtidos, contendo as instruções para reproduzirmos suas análises, pode ser no **README** do git.
* Sinta-se à vontade para usar qualquer framework, bibliotecas e ferramentas que se sentir à vontade a única restrição é a linguagem de programação que deve ser **Python**

***Todos os dados de usuário são ficticios gerados para efeito de teste/estudo**

**A má utilização dos dados aqui gerados é de total responsabilidade do usuário. Os dados são gerados de forma aleatória, respeitando as regras de criação de cada documento.**