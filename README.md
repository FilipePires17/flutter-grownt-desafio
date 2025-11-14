# Desafio Flutter

Bem-vindo(a)! 👋  
Este é o desafio para a vaga de **Desenvolvedor(a) Flutter**.

O objetivo é avaliar sua capacidade de:
- Estruturar um projeto Flutter organizado
- Construir UI com boa usabilidade
- Consumir e tratar dados de uma API
- Gerenciar estado de forma consistente
- Escrever testes automatizados (unitários e/ou de widget)
- Versionar e documentar o código

---

## 📱 Desafio: App de Listagem e Detalhes de Projetos

Você deverá construir um app em Flutter que liste “projetos” (por exemplo, produtos digitais, tarefas, iniciativas) e permita:

1. **Listar projetos**
2. **Ver detalhes de um projeto**
3. **Filtrar/pesquisar projetos**
4. **Marcar projeto como favorito**
5. **Persistir favoritos localmente**

### Tema (exemplo)

Você é responsável por um app chamado **"ProjectHub"**, que mostra uma lista de projetos de uma empresa de tecnologia.  
Cada projeto deve conter pelo menos:

- ID
- Nome
- Descrição resumida
- Status (ex.: `Em andamento`, `Concluído`, `Pausado`)
- Responsável (nome da pessoa)
- Data de criação

Você pode adaptar o contexto se quiser, desde que mantenha as funcionalidades.

---

## 🔌 API / Fonte de Dados

Você pode escolher uma das opções abaixo:

1. **Mock local (recomendado para simplicidade no teste)**
   - Criar um arquivo JSON local e simular uma API com um pequeno atraso (ex.: 1–2 segundos).
   - Exemplo de estrutura:

     ```json
     [
       {
         "id": 1,
         "nome": "Plataforma GT - Nexus",
         "descricao": "Sistema de gestão de projetos e portfólio.",
         "status": "Em andamento",
         "responsavel": "Maria Souza",
         "dataCriacao": "2024-01-10"
       }
     ]
     ```

2. **API real (opcional)**
   - Você pode consumir uma API pública de sua preferência, desde que explique no README como configurá-la.

> Importante: independente da fonte, trate carregamento, erro e estados vazios.

---

## 🧩 Requisitos obrigatórios

### 1. Tela de lista de projetos

- Mostrar:
  - Nome do projeto
  - Status
  - Responsável
- Exibir indicador de **carregando** enquanto busca os dados
- Exibir uma mensagem amigável em caso de **erro** (e opção de tentar novamente)
- Exibir uma mensagem quando **não houver dados**

### 2. Filtro / Busca

- Campo de busca por nome do projeto **ou** responsável
- A busca pode ser:
  - Em tempo real (conforme digita), ou
  - Ao enviar (pressionar um botão de buscar)

### 3. Tela de detalhes

Ao tocar em um item da lista, exibir uma tela com:

- Nome
- Descrição
- Status
- Responsável
- Data de criação formatada (ex.: `10/01/2024`)

### 4. Favoritos

- Permitir marcar/desmarcar um projeto como **favorito**
- Na lista, indicar visualmente quais estão favoritos (ex. um ícone de estrela)
- Deve existir um filtro/aba simples para ver **apenas favoritos**

### 5. Persistência local

- Os favoritos devem ser persistidos localmente (por exemplo: `shared_preferences`, `hive` ou similar)
- Ao fechar e abrir o app, as informações de favorito devem ser mantidas

### 6. Gerenciamento de estado

- Utilizar alguma abordagem/biblioteca de gerenciamento de estado:
  - Pode ser **Riverpod**, **Bloc/Cubit**, **Provider**, **MobX**, etc.
- O importante é estar bem organizado e coerente com o tamanho do projeto

---

## 🧪 Testes

Inclua **ao menos**:

- 1 teste unitário (por exemplo, de uma classe de lógica, serviço, use case, etc.)
- 1 teste de widget (por exemplo, da lista de projetos ou da tela de detalhes)

Bônus se:

- Houver testes cobrindo estados de carregamento/erro
- Houver boa cobertura de lógica (filtro, favoritos)

---

## 🏗️ Organização do código

Sugerimos (não obrigatório) algo como:

```text
lib/
  core/
    models/
    services/
  features/
    projects/
      presentation/
        pages/
        widgets/
      domain/
        entities/
        usecases/
      data/
        datasources/
        repositories/
  main.dart
