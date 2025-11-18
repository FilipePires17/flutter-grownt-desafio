# 📱 Desafio Técnico — Flutter

Bem-vindo(a)! 👋  
Este é o desafio técnico para a vaga de **Desenvolvedor(a) Flutter Pleno**.

O objetivo é avaliar sua capacidade de:

- Criar uma aplicação Flutter estruturada e escalável  
- Consumir uma API pública real  
- Trabalhar com estado, camadas e organização do código  
- Construir telas com boa UX/UI  
- Tratar erros e edge cases  
- Persistir dados localmente  
- Escrever testes (unitários e/ou widget)  
- Documentar e versionar o projeto corretamente  

---

# 🎯 **Desafio: App de Listagem e Detalhes usando API Pública Real**

Você deve desenvolver um app Flutter que consome uma **API pública real** e implementa o seguinte fluxo:

1. **Listagem principal**
2. **Busca/filtro**
3. **Tela de detalhes**
4. **Favoritar/desfavoritar**
5. **Persistência local dos favoritos**
6. **Tratamento completo de estados: loading, error, empty**
7. **Testes obrigatórios**

---

# 🌐 **API Pública (obrigatória)**

Você deve integrar com **uma API pública real**, escolhendo **uma das opções abaixo**:

### 🔹 JSONPlaceholder  
https://jsonplaceholder.typicode.com/  
Sugerido: `/users`, `/posts`

### 🔹 GitHub Repositories  
https://api.github.com/users/{usuario}/repos  
Sugerido: listar repositórios de um usuário

### 🔹 Rick and Morty API (recomendado)  
https://rickandmortyapi.com/api  
Sugerido: personagens → paginação + busca + detalhes

### 🔹 PokeAPI  
https://pokeapi.co/  
Sugerido: lista + detalhes + tipos

### 🔹 Open-Meteo  
https://open-meteo.com/en/docs  
Sugerido: previsão do tempo por cidade

**Observação:**  
Independente da API escolhida, trate **timeout, erros de rede e estados vazios**.

---

# 🧩 **Requisitos Funcionais**

## 1️⃣ Tela de Lista
- Listar elementos vindos da API
- Mostrar:
  - Nome/título do item
  - Atributos principais (ex.: status, subtítulo, etc.)
- Ícone para marcar/desmarcar **favorito**
- Estados obrigatórios:
  - Carregando (`loading`)
  - Erro (com botão “tentar novamente”)
  - Lista vazia

## 2️⃣ Busca / Filtro
- Deve permitir filtrar itens (nome, título, etc.)
- Pode ser:
  - Em tempo real (digitou → filtrou)
  - Ou ao enviar o texto

## 3️⃣ Tela de Detalhes
- Mostrar todas as informações relevantes do item
- Layout organizado e responsivo

## 4️⃣ Favoritos
- O usuário deve poder favoritar/desfavoritar
- Exibir favoritos na lista com destaque visual
- Implementar uma **aba** ou **filtro** “Somente Favoritos”

## 5️⃣ Persistência Local
Os favoritos devem ser salvos localmente usando uma dessas libs:

- `shared_preferences`
- `hive`
- `get_storage`
- similar

Ao fechar e abrir o app, as informações devem permanecer.

---

# 🧱 **Requisitos Técnicos**

## 🔸 Gerenciamento de Estado
Você pode usar uma das abordagens abaixo:

- **Riverpod** (recomendado)
- Bloc / Cubit
- Provider
- MobX
- SetState com boa organização (não recomendado, mas aceito)

## 🔸 Organização do Projeto
Sugestão (não obrigatória):

