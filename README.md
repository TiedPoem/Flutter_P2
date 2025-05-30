# Projeto API + Flutter

Este projeto consiste em uma aplicação que integra uma **API desenvolvida em Java com Spring Boot** e um **aplicativo desenvolvido em Flutter**.

A API é responsável pelo backend e o Flutter pela interface do usuário (**frontend**). Ambos os sistemas devem estar em execução simultaneamente para que a aplicação funcione corretamente.

---

##  Tecnologias Utilizadas

- **Backend:** Java 17+, Spring Boot, Maven ou Gradle
- **Frontend:** Flutter SDK

---

##  Requisitos

- Java **17 ou superior**
- Maven ou Gradle
- Flutter SDK instalado e configurado
- Android Studio ou emulador/dispositivo físico
- IntelliJ IDEA (ou outra IDE compatível com Java)

---

##  Como Executar o Projeto

### 1️ Iniciando a API (Backend)

1. Abra o projeto da API no **IntelliJ IDEA**.
2. Localize e execute a classe principal, geralmente chamada de `Application.java`.
3. A API ficará disponível localmente no endereço:http://localhost:8080.

> 🔧 *Caso necessário, ajuste a porta no arquivo `application.properties` ou `application.yml`.*

---

### 2️ Iniciando o Aplicativo Flutter (Frontend)

1. Abra o projeto Flutter no **Visual Studio Code** (ou sua IDE preferida).
2. No terminal, execute:

 bash
flutter pub get
flutter run

##  Observações Importantes

- O aplicativo **Flutter depende da API** para funcionar corretamente.
- Qualquer falha no backend **impedirá o funcionamento do frontend**.
- Caso necessário, o **endereço da API pode ser configurado no código** do aplicativo Flutter.

---

##  Requisitos do Ambiente

### Backend (API)
- Java **17 ou superior**
- Gerenciador de dependências: **Maven** ou **Gradle**

### Frontend (Flutter)
- **SDK do Flutter** instalado e corretamente configurado na máquina de desenvolvimento
