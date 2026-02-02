# Руководство по миграции на мульти-модульную архитектуру

## Шаг 1: Создание структуры

Структура модулей уже создана. Теперь нужно переместить код.

## Шаг 2: Перемещение общего кода в core/

Следующие директории и файлы должны быть перемещены в `core/`:

```bash
# Основные директории
mv adapter core/
mv protocol core/
mv transport core/
mv route core/
mv dns core/
mv common core/
mv option core/
mv log core/
mv constant core/
mv include core/
mv service core/

# Основные файлы
mv box.go core/
mv ARCHITECTURE.md core/
mv PROJECT_MAP.md core/
```

## Шаг 3: Создание платформенных модулей

### module-ios
```bash
mkdir -p module-ios/cmd module-ios/platform
# Переместить iOS специфичный код из experimental/libbox
# Создать cmd/main.go для iOS
```

### module-android
```bash
mkdir -p module-android/cmd module-android/platform
# Переместить Android специфичный код из experimental/libbox
# Создать cmd/main.go для Android
```

### module-windows
```bash
mkdir -p module-windows/cmd module-windows/platform
# Создать Windows специфичный код
# Создать cmd/main.go для Windows
```

### module-linux
```bash
mkdir -p module-linux/cmd module-linux/platform
# Создать Linux специфичный код
# Создать cmd/main.go для Linux
```

### module-server
```bash
mkdir -p module-server/cmd module-server/platform
# Создать Server специфичный код
# Создать cmd/main.go для Server
```

## Шаг 4: Обновление импортов

Все импорты должны быть обновлены:

**Было:**
```go
import "github.com/sagernet/sing-box/adapter"
```

**Стало:**
```go
import "github.com/sagernet/amnezia-box-core/adapter"
```

## Шаг 5: Обновление Makefile

Добавить команды для сборки каждого модуля:

```makefile
build-core:
	cd core && go build

build-ios:
	cd module-ios && go build -tags ios

build-android:
	cd module-android && go build -tags android

build-windows:
	cd module-windows && go build -tags windows

build-linux:
	cd module-linux && go build -tags linux

build-server:
	cd module-server && go build -tags server
```

## Шаг 6: Обновление CI/CD

Обновить GitHub Actions для сборки каждого модуля отдельно.

## Автоматизация миграции

Можно использовать скрипт для автоматической миграции (см. `scripts/migrate-to-multi-module.sh`)
