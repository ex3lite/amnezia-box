# Настройка мульти-модульного проекта

## ✅ Что уже сделано

1. ✅ Создана структура директорий для всех модулей
2. ✅ Созданы `go.mod` файлы для каждого модуля
3. ✅ Создан `go.work` для работы с несколькими модулями
4. ✅ Создан `Makefile.multi-module` для сборки модулей
5. ✅ Созданы базовые `platform.go` файлы для каждого модуля
6. ✅ Создан скрипт миграции `scripts/migrate-to-multi-module.sh`

## 📋 Следующие шаги

### Шаг 1: Перемещение кода в core/

Выполните скрипт миграции (создайте резервную копию перед запуском!):

```bash
# Создайте резервную копию
git add -A
git commit -m "Backup before migration"

# Запустите скрипт миграции
./scripts/migrate-to-multi-module.sh
```

Или вручную переместите файлы:

```bash
# Перемещение общего кода в core/
mv adapter protocol transport route dns common option log constant include service core/
mv box.go core/
```

### Шаг 2: Обновление импортов в core/

Все импорты в `core/` должны быть обновлены:

**Было:**
```go
import "github.com/sagernet/sing-box/adapter"
```

**Стало:**
```go
import "github.com/sagernet/amnezia-box-core/adapter"
```

Можно использовать автоматическую замену:

```bash
cd core
find . -type f -name "*.go" -exec sed -i '' 's|github.com/sagernet/sing-box|github.com/sagernet/amnezia-box-core|g' {} +
```

### Шаг 3: Синхронизация зависимостей

```bash
# Синхронизация workspace
go work sync

# Установка зависимостей для каждого модуля
cd core && go mod tidy
cd ../module-ios && go mod tidy
cd ../module-android && go mod tidy
cd ../module-windows && go mod tidy
cd ../module-linux && go mod tidy
cd ../module-server && go mod tidy
```

### Шаг 4: Создание платформенных команд

Для каждого модуля создайте полноценный `cmd/main.go` на основе `cmd/sing-box/main.go`, адаптированный под платформу.

### Шаг 5: Обновление Makefile

Замените текущий `Makefile` на `Makefile.multi-module` или интегрируйте команды из него.

### Шаг 6: Тестирование сборки

```bash
# Сборка core
make build-core

# Сборка iOS модуля
make build-ios

# Сборка Android модуля
make build-android

# Сборка Windows модуля
make build-windows

# Сборка Linux модуля
make build-linux

# Сборка Server модуля
make build-server

# Сборка всех модулей
make build-all
```

## 📁 Структура проекта

```
amnezia-box/
├── core/                    # ✅ Создан
│   ├── go.mod              # ✅ Создан
│   ├── README.md           # ✅ Создан
│   └── [код будет перемещен сюда]
│
├── module-ios/              # ✅ Создан
│   ├── go.mod              # ✅ Создан
│   ├── README.md           # ✅ Создан
│   ├── cmd/                # ✅ Создан
│   └── platform/           # ✅ Создан
│       └── platform.go      # ✅ Создан
│
├── module-android/          # ✅ Создан
│   ├── go.mod              # ✅ Создан
│   ├── README.md           # ✅ Создан
│   ├── cmd/                # ✅ Создан
│   └── platform/           # ✅ Создан
│       └── platform.go     # ✅ Создан
│
├── module-windows/          # ✅ Создан
│   ├── go.mod              # ✅ Создан
│   ├── README.md           # ✅ Создан
│   ├── cmd/                # ✅ Создан
│   └── platform/           # ✅ Создан
│       └── platform.go     # ✅ Создан
│
├── module-linux/            # ✅ Создан
│   ├── go.mod              # ✅ Создан
│   ├── README.md           # ✅ Создан
│   ├── cmd/                # ✅ Создан
│   └── platform/           # ✅ Создан
│       └── platform.go     # ✅ Создан
│
├── module-server/           # ✅ Создан
│   ├── go.mod              # ✅ Создан
│   ├── README.md           # ✅ Создан
│   ├── cmd/                # ✅ Создан
│   └── platform/           # ✅ Создан
│       └── platform.go     # ✅ Создан
│
├── go.work                  # ✅ Создан
├── Makefile.multi-module    # ✅ Создан
├── MULTI_MODULE_ARCHITECTURE.md  # ✅ Создан
├── MIGRATION_GUIDE.md       # ✅ Создан
└── scripts/
    └── migrate-to-multi-module.sh  # ✅ Создан
```

## 🔧 Настройка IDE

### VS Code / GoLand

1. Откройте проект как workspace: `File > Open Workspace > go.work`
2. IDE автоматически распознает все модули

### GoLand

1. `File > Open > go.work`
2. GoLand автоматически настроит все модули

## 📝 Примечания

- **Не удаляйте** текущий код до завершения миграции
- **Создайте резервную копию** перед запуском скрипта миграции
- **Тестируйте** каждый модуль после перемещения кода
- **Обновляйте** импорты постепенно, модуль за модулем

## 🚀 Быстрый старт

```bash
# 1. Синхронизация workspace
go work sync

# 2. Установка зависимостей
make deps

# 3. Тестовая сборка core
make build-core

# 4. Тестовая сборка всех модулей
make build-all
```

## 📚 Дополнительная документация

- `MULTI_MODULE_ARCHITECTURE.md` - детальная архитектура
- `MIGRATION_GUIDE.md` - руководство по миграции
- `core/README.md` - документация core модуля
- `module-*/README.md` - документация каждого модуля
