# 📘 Diagrama de Classes — Sistema "Economia com História"

---

## 🧱 Classes do Sistema

### 👤 User

* id: int
* nome: string
* email: string

---

### 🏷️ Tema

* id: int
* nome: string
* descricao: string

---

### 📚 Conteudo

* id: int
* titulo: string
* tipo: string (video, texto, podcast)

---

### 💬 Comentario

* id: int
* texto: string
* data: datetime

---

### 🧠 Quiz

* id: int
* titulo: string

---

### ❓ Pergunta

* id: int
* enunciado: string

---

### 🔘 Opcao

* id: int
* texto: string
* correta: bool

---

### 🎯 QuizAttempt

* id: int
* data_inicio: datetime
* data_fim: datetime

---

### 🧾 RespostaUser

* id: int
* correta: bool

---

### 🏆 Resultado

* pontuacao: int
* total_perguntas: int

---

### 🗣️ Topico

* id: int
* titulo: string
* descricao: string
* data: datetime

---

### 💬 RespostaTopico

* id: int
* texto: string
* data: datetime

---

## 🔗 Relacionamentos

### 📌 Tema

* Tema 1 → N Conteudo
* Tema 1 → N Quiz
* Tema 1 → N Pergunta
* Tema 1 → N Topico

---

### 👤 User

* User 1 → N Comentario
* User 1 → N Topico
* User 1 → N RespostaTopico
* User 1 → N QuizAttempt

---

### 📚 Conteudo

* Conteudo 1 → N Comentario

---

### 🧠 Quiz

* Quiz 1 → N Pergunta
* Pergunta 1 → N Opcao
* Quiz 1 → N QuizAttempt

---

### 🎯 Execução do Quiz

* QuizAttempt 1 → N RespostaUser
* Pergunta 1 → N RespostaUser
* Opcao 1 → N RespostaUser
* QuizAttempt 1 → 1 Resultado

---

### 🗣️ Fórum

* Topico 1 → N RespostaTopico

---

## 🧭 Estrutura Geral

```
User
 ├── Conteudo → Comentario
 ├── Quiz → Pergunta → Opcao → RespostaUser → Resultado
 ├── Forum → Topico → RespostaTopico
 └── Tema (organiza tudo)
```

---

## 🎯 Observações de Design

* O sistema é modular e escalável
* O Quiz é apenas um dos componentes
* A classe Tema organiza conteúdos, quizzes e discussões
* Não foi utilizada herança desnecessária (ex: Publicacao)

---

## 🔄 Relação entre Entidades

### 👤 User

* Um User pode escrever vários Comentario
* Um User pode criar vários Topico
* Um User pode responder vários RespostaTopico
* Um User pode realizar várias QuizAttempt

---

### 🏷️ Theme

* Um Theme pode categorizar vários Conteudo
* Um Theme pode organizar vários Quiz
* Um Theme pode agrupar vários Topico

---

### 📚 Conteudo

* Um Conteudo pertence a um Theme
* Um Conteudo pode ter vários Comentario

---

### 💬 Comentario

* Um Comentario é escrito por um User
* Um Comentario está associado a um Conteudo

---

### 🧠 Quiz

* Um Quiz pertence a um Theme
* Um Quiz contém uma ou mais Pergunta
* Um Quiz pode ter várias QuizAttempt

---

### ❓ Pergunta

* Uma Pergunta pertence a um Quiz
* Uma Pergunta tem duas ou mais Opcao
* Uma Pergunta pode aparecer em várias RespostaUser

---

### 🔘 Opcao

* Uma Opcao pertence a uma Pergunta
* Uma Opcao pode ser escolhida em várias RespostaUser

---

### 🎯 QuizAttempt

* Uma QuizAttempt é realizada por um User
* Uma QuizAttempt está associada a um Quiz
* Uma QuizAttempt regista uma ou mais RespostaUser
* Uma QuizAttempt produz exatamente um Resultado

---

### 🧾 RespostaUser

* Uma RespostaUser pertence a uma QuizAttempt
* Uma RespostaUser refere uma Pergunta
* Uma RespostaUser aponta para uma Opcao selecionada

---

### 🏆 Resultado

* Um Resultado pertence a uma única QuizAttempt

---

### 🗣️ Topico

* Um Topico pertence a um Theme
* Um Topico é criado por um User
* Um Topico pode ter várias RespostaTopico

---

### 💬 RespostaTopico

* Uma RespostaTopico pertence a um Topico
* Uma RespostaTopico é escrita por um User

---

## 🧭 Resumo Geral

* Theme organiza o conteúdo pedagógico
* User interage com conteúdo, quiz e fórum
* O fluxo do quiz é Quiz → Pergunta → Opcao → QuizAttempt → RespostaUser → Resultado