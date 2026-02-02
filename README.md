---

# amnezia-box

The universal proxy platform (fork of sing-box).

[![Packaging status](https://repology.org/badge/vertical-allrepos/sing-box.svg)](https://repology.org/project/sing-box/versions)

## 📚 Documentation

- **Official Documentation**: https://sing-box.sagernet.org
- **Architecture Guide**: [ARCHITECTURE.md](./ARCHITECTURE.md) - Детальное описание архитектуры и слоев
- **Project Map**: [PROJECT_MAP.md](./PROJECT_MAP.md) - Быстрая карта проекта для навигации

## 🏗️ Структура проекта

### Основные компоненты

- **`box.go`** - Главный координатор всех компонентов системы
- **`adapter/`** - Интерфейсы и абстракции (Inbound, Outbound, Router, Service)
- **`route/`** - Маршрутизация трафика и правила
- **`dns/`** - DNS резолвинг и маршрутизация
- **`protocol/`** - Реализации протоколов (Shadowsocks, VMess, VLESS, Trojan, Hysteria, WireGuard и др.)
- **`transport/`** - Транспортные механизмы (WebSocket, gRPC, QUIC, HTTP и др.)
- **`common/`** - Общие утилиты (dialer, TLS, certificate, process, sniff и др.)
- **`option/`** - Конфигурация и опции
- **`experimental/`** - Экспериментальные функции (ClashAPI, V2RayAPI, Libbox)

### Клиентские приложения

- **`clients/android/`** - Android приложение (Kotlin)
- **`clients/apple/`** - iOS/macOS приложения (Swift)

### Документация

- **`docs/`** - Полная документация по конфигурации, установке и использованию

## 🎯 Быстрый старт для разработчиков

1. **Изучите архитектуру**: Начните с [ARCHITECTURE.md](./ARCHITECTURE.md) для понимания структуры
2. **Используйте карту проекта**: [PROJECT_MAP.md](./PROJECT_MAP.md) для быстрой навигации
3. **Точка входа**: `box.go` - главный файл системы
4. **Маршрутизация**: `route/router.go` - логика маршрутизации соединений
5. **Протоколы**: `protocol/` - примеры реализации протоколов

## 📖 Для AI-ассистентов

Если вы AI-ассистент, работающий с этим проектом:

1. **Начните с [PROJECT_MAP.md](./PROJECT_MAP.md)** - быстрая навигация по структуре
2. **Изучите [ARCHITECTURE.md](./ARCHITECTURE.md)** - понимание архитектуры и взаимодействия компонентов
3. **Используйте `box.go`** как точку отсчета для понимания инициализации
4. **Интерфейсы в `adapter/`** определяют контракты между компонентами
5. **Примеры реализации** находятся в `protocol/` и `transport/`

## License

```
Copyright (C) 2022 by nekohasekai <contact-sagernet@sekai.icu>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

In addition, no derivative work may use the name or imply association
with this application without prior consent.
```