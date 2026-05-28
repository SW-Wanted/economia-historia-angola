# Mobile

Aplicação mobile da plataforma **Economia com História — Angola**, disponível para Android e iOS.

---

## Stack de Desenvolvimento

| Tecnologia | Versão | Uso |
|---|---|---|
| Flutter | 3.x | Framework mobile |
| Dart | 3.x | Linguagem |
| Riverpod | 2.x | Gestão de estado |
| Go Router | 13.x | Navegação |
| Dio | 5.x | Chamadas HTTP à API |
| Material 3 | — | Sistema de design |

---

## Estrutura de Pastas

```
mobile/
├── lib/
│   ├── features/
│   │   ├── explorar/
│   │   │   ├── data/
│   │   │   │   └── explorar_repository.dart
│   │   │   ├── domain/
│   │   │   │   └── conteudo_model.dart
│   │   │   └── presentation/
│   │   │       ├── explorar_screen.dart
│   │   │       └── conteudo_card.dart
│   │   ├── quiz/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── forum/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── perfil/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── core/
│   │   ├── api/
│   │   │   ├── api_client.dart     ← Dio configurado
│   │   │   └── endpoints.dart      ← URLs da API
│   │   ├── theme/
│   │   │   └── app_theme.dart      ← Material 3 theme
│   │   └── router/
│   │       └── app_router.dart     ← Go Router
│   └── main.dart
├── assets/
│   ├── images/
│   └── fonts/
├── test/
├── .env                            ← Variáveis de ambiente
├── .env.example                    ← Template
└── pubspec.yaml
```

### Arquitectura por feature (Clean Architecture)

Cada feature segue três camadas:

- `data/` — repositórios que chamam a API e devolvem modelos
- `domain/` — modelos de dados (classes Dart puras, sem dependências externas)
- `presentation/` — screens e widgets que o utilizador vê

---

## Variáveis de Ambiente

```env
API_BASE_URL=http://localhost:3001
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

---

## Instalação e Execução

### Pré-requisitos

- Flutter SDK 3.x instalado — [flutter.dev](https://flutter.dev/docs/get-started/install)
- Android Studio ou Xcode (para emulador)
- Dispositivo físico ou emulador configurado

### Comandos

```bash
# Verificar instalação do Flutter
flutter doctor

# Instalar dependências
flutter pub get

# Correr em modo de desenvolvimento
flutter run

# Correr num dispositivo específico
flutter run -d chrome        # Browser
flutter run -d emulator-5554 # Emulador Android
```

### Build

```bash
# APK para Android (instalação directa)
flutter build apk --release

# App Bundle para Play Store
flutter build appbundle

# iOS (requer Mac com Xcode)
flutter build ios --release
```

O APK gerado fica em `build/app/outputs/flutter-apk/app-release.apk`.

---

## Convenções de Código

- Ficheiros e pastas em `snake_case` — `explorar_screen.dart`
- Classes em `PascalCase` — `ConteudoCard`
- Variáveis e funções em `camelCase` — `fetchConteudos()`
- Cada screen tem o seu próprio ficheiro
- Widgets reutilizáveis ficam em `presentation/` da respectiva feature ou em `core/` se forem globais