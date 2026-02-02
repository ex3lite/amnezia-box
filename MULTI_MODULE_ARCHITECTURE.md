# Архитектура мульти-модульного проекта

## Обзор

Проект разделен на несколько модулей для разных платформ:
- **core** - общий код, используемый всеми платформами
- **module-ios** - iOS специфичный код
- **module-android** - Android специфичный код
- **module-windows** - Windows специфичный код
- **module-linux** - Linux специфичный код
- **module-server** - Server специфичный код (Ubuntu)

## Структура модулей

```
amnezia-box/
├── core/                    # Общий модуль
│   ├── go.mod
│   ├── adapter/            # Интерфейсы и абстракции
│   ├── protocol/           # Протоколы (Shadowsocks, VMess, etc.)
│   ├── transport/          # Транспорты (WebSocket, gRPC, etc.)
│   ├── route/              # Маршрутизация
│   ├── dns/                # DNS резолвинг
│   ├── common/             # Общие утилиты
│   ├── option/             # Конфигурация
│   ├── log/                # Логирование
│   ├── constant/           # Константы
│   └── box.go              # Главный координатор
│
├── module-ios/             # iOS модуль
│   ├── go.mod
│   ├── cmd/                # iOS команды
│   ├── platform/           # iOS специфичный код
│   └── experimental/libbox/ # iOS библиотека
│
├── module-android/         # Android модуль
│   ├── go.mod
│   ├── cmd/                # Android команды
│   ├── platform/           # Android специфичный код
│   └── experimental/libbox/ # Android библиотека
│
├── module-windows/          # Windows модуль
│   ├── go.mod
│   ├── cmd/                # Windows команды
│   └── platform/           # Windows специфичный код
│
├── module-linux/            # Linux модуль
│   ├── go.mod
│   ├── cmd/                # Linux команды
│   └── platform/           # Linux специфичный код
│
├── module-server/           # Server модуль (Ubuntu)
│   ├── go.mod
│   ├── cmd/                # Server команды
│   └── platform/           # Server специфичный код
│
├── go.work                  # Go workspace для всех модулей
├── Makefile                # Обновленный Makefile
└── clients/                # Клиентские приложения (без изменений)
    ├── android/
    └── apple/
```

## Зависимости модулей

```
core (базовый модуль)
  ↑
  ├── module-ios (зависит от core)
  ├── module-android (зависит от core)
  ├── module-windows (зависит от core)
  ├── module-linux (зависит от core)
  └── module-server (зависит от core)
```

## Что входит в core модуль

- Все протоколы (protocol/)
- Все транспорты (transport/)
- Маршрутизация (route/)
- DNS (dns/)
- Адаптеры (adapter/)
- Общие утилиты (common/)
- Конфигурация (option/)
- Логирование (log/)
- Константы (constant/)

## Что входит в платформенные модули

### module-ios
- iOS специфичные команды
- iOS платформенный интерфейс
- libbox для iOS
- Build tags для iOS

### module-android
- Android специфичные команды
- Android платформенный интерфейс
- libbox для Android
- Build tags для Android

### module-windows
- Windows специфичные команды
- Windows платформенный интерфейс
- Windows системные настройки

### module-linux
- Linux специфичные команды
- Linux платформенный интерфейс
- Systemd интеграция

### module-server
- Server специфичные команды
- Server конфигурация
- Docker поддержка
- Systemd сервисы

## Сборка модулей

Каждый модуль собирается независимо:

```bash
# Сборка core
cd core && go build

# Сборка iOS модуля
cd module-ios && go build -tags ios

# Сборка Android модуля
cd module-android && go build -tags android

# Сборка Windows модуля
cd module-windows && go build -tags windows

# Сборка Linux модуля
cd module-linux && go build -tags linux

# Сборка Server модуля
cd module-server && go build -tags server
```

## Go Workspace

Используется `go.work` для работы с несколькими модулями одновременно:

```go
go 1.24

use (
    ./core
    ./module-ios
    ./module-android
    ./module-windows
    ./module-linux
    ./module-server
)
```

## Миграция

1. Создать структуру директорий
2. Переместить общий код в core/
3. Создать платформенные модули
4. Настроить go.mod для каждого модуля
5. Создать go.work
6. Обновить Makefile
7. Обновить CI/CD
