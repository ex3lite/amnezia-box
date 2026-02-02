#!/bin/bash

# Скрипт миграции на мульти-модульную архитектуру
# ВНИМАНИЕ: Этот скрипт перемещает файлы. Создайте резервную копию перед запуском!

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "🚀 Начало миграции на мульти-модульную архитектуру..."

# Проверка наличия резервной копии
if [ ! -d ".backup" ]; then
    echo "⚠️  Создание резервной копии..."
    mkdir -p .backup
    cp -r adapter protocol transport route dns common option log constant include service box.go .backup/ 2>/dev/null || true
fi

# Перемещение общего кода в core/
echo "📦 Перемещение общего кода в core/..."

DIRS_TO_MOVE=("adapter" "protocol" "transport" "route" "dns" "common" "option" "log" "constant" "include" "service")
for dir in "${DIRS_TO_MOVE[@]}"; do
    if [ -d "$dir" ]; then
        echo "  → Перемещение $dir/"
        mv "$dir" core/
    fi
done

# Перемещение основных файлов
if [ -f "box.go" ]; then
    echo "  → Перемещение box.go"
    mv box.go core/
fi

# Создание структуры для платформенных модулей
echo "📱 Создание структуры платформенных модулей..."

for module in ios android windows linux server; do
    mkdir -p "module-$module/cmd"
    mkdir -p "module-$module/platform"
    echo "  ✓ Создана структура для module-$module"
done

# Создание базовых main.go для каждого модуля
echo "📝 Создание базовых main.go файлов..."

cat > module-ios/cmd/main.go << 'EOF'
//go:build ios

package main

import (
	"github.com/sagernet/amnezia-box-core/log"
	"github.com/sagernet/amnezia-box-ios/platform"
)

func main() {
	log.Info("iOS модуль запущен")
	platform.Initialize()
}
EOF

cat > module-android/cmd/main.go << 'EOF'
//go:build android

package main

import (
	"github.com/sagernet/amnezia-box-core/log"
	"github.com/sagernet/amnezia-box-android/platform"
)

func main() {
	log.Info("Android модуль запущен")
	platform.Initialize()
}
EOF

cat > module-windows/cmd/main.go << 'EOF'
//go:build windows

package main

import (
	"github.com/sagernet/amnezia-box-core/log"
	"github.com/sagernet/amnezia-box-windows/platform"
)

func main() {
	log.Info("Windows модуль запущен")
	platform.Initialize()
}
EOF

cat > module-linux/cmd/main.go << 'EOF'
//go:build linux

package main

import (
	"github.com/sagernet/amnezia-box-core/log"
	"github.com/sagernet/amnezia-box-linux/platform"
)

func main() {
	log.Info("Linux модуль запущен")
	platform.Initialize()
}
EOF

cat > module-server/cmd/main.go << 'EOF'
//go:build server

package main

import (
	"github.com/sagernet/amnezia-box-core/log"
	"github.com/sagernet/amnezia-box-server/platform"
)

func main() {
	log.Info("Server модуль запущен")
	platform.Initialize()
}
EOF

echo "✅ Миграция завершена!"
echo ""
echo "Следующие шаги:"
echo "1. Обновите импорты в core/ (замените github.com/sagernet/sing-box на github.com/sagernet/amnezia-box-core)"
echo "2. Создайте platform/ пакеты для каждого модуля"
echo "3. Обновите Makefile для сборки каждого модуля"
echo "4. Запустите 'go work sync' для синхронизации workspace"
