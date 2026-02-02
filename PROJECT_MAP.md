# Карта проекта amnezia-box

Быстрая навигация по структуре проекта для разработчиков и AI-ассистентов.

## 🗂️ Структура директорий

### 📦 Корневые файлы
- `box.go` - **Главный файл**, координатор всех компонентов
- `go.mod` - Зависимости проекта
- `README.md` - Основная документация
- `ARCHITECTURE.md` - Детальная архитектура (см. этот файл)
- `PROJECT_MAP.md` - Этот файл, быстрая карта

### 🔌 Adapter Layer (`adapter/`)
**Интерфейсы и абстракции**

| Файл | Назначение |
|------|-----------|
| `inbound.go` | Интерфейсы входящих соединений |
| `outbound.go` | Интерфейсы исходящих соединений |
| `endpoint.go` | Интерфейсы endpoint'ов |
| `router.go` | Интерфейсы маршрутизации |
| `service.go` | Интерфейсы сервисов |
| `rule.go` | Интерфейсы правил |
| `lifecycle.go` | Жизненный цикл компонентов |
| `handler.go` | Обработчики соединений |
| `inbound/manager.go` | Менеджер inbound'ов |
| `outbound/manager.go` | Менеджер outbound'ов |
| `endpoint/manager.go` | Менеджер endpoint'ов |
| `service/manager.go` | Менеджер сервисов |

### 🛣️ Route Layer (`route/`)
**Маршрутизация и правила**

| Файл/Директория | Назначение |
|----------------|-----------|
| `router.go` | Основной роутер |
| `route.go` | Логика маршрутизации |
| `network.go` | Управление сетью (TUN/TAP) |
| `conn.go` | Управление соединениями |
| `dns.go` | DNS маршрутизация |
| `rule/` | **Все правила маршрутизации** |
| `rule/rule_*.go` | Конкретные типы правил |
| `rule/rule_set.go` | Наборы правил |
| `rule/rule_action.go` | Действия правил |

### 🌐 DNS Layer (`dns/`)
**DNS резолвинг**

| Файл/Директория | Назначение |
|----------------|-----------|
| `router.go` | DNS роутер |
| `client.go` | DNS клиент |
| `transport/` | **DNS транспорты** |
| `transport/tcp.go` | DNS over TCP |
| `transport/tls.go` | DNS over TLS |
| `transport/https.go` | DNS over HTTPS |
| `transport/quic.go` | DNS over QUIC |
| `transport/fakeip.go` | Fake IP |

### 🔐 Protocol Layer (`protocol/`)
**Реализации протоколов**

| Директория | Протокол | Где работает | Файлы |
|-----------|----------|--------------|-------|
| `shadowsocks/` | Shadowsocks | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `vmess/` | VMess | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `vless/` | VLESS | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `trojan/` | Trojan | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `hysteria/` | Hysteria | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `hysteria2/` | Hysteria2 | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `tuic/` | TUIC | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `naive/` | Naive | **Inbound** | `inbound.go`, `inbound_conn.go` |
| `shadowtls/` | ShadowTLS | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `anytls/` | AnyTLS | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `wireguard/` | WireGuard | **Outbound**, **Endpoint** | `outbound.go`, `endpoint.go` |
| `tailscale/` | Tailscale | **Endpoint** | `endpoint.go`, `dns_transport.go` |
| `awg/` | AWG (Amnezia WireGuard) | **Endpoint** | `endpoint.go` |
| `direct/` | Прямое соединение | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `block/` | Блокировка | **Outbound** | `outbound.go` |
| `dns/` | DNS | **Outbound** | `outbound.go`, `handle.go` |
| `socks/` | SOCKS5 | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `http/` | HTTP прокси | **Inbound**, **Outbound** | `inbound.go`, `outbound.go` |
| `mixed/` | Mixed (SOCKS+HTTP) | **Inbound** | `inbound.go` |
| `tun/` | TUN интерфейс | **Inbound** | `inbound.go`, `hook.go` |
| `redirect/` | Redirect | **Inbound** | `redirect.go`, `tproxy.go` |
| `tor/` | Tor | **Outbound** | `outbound.go`, `proxy.go` |
| `ssh/` | SSH | **Outbound** | `outbound.go` |
| `group/` | Группы | **Outbound** | `selector.go`, `urltest.go` |

### 🚀 Transport Layer (`transport/`)
**Транспортные механизмы**

| Директория | Транспорт | Назначение |
|-----------|----------|-----------|
| `v2raywebsocket/` | WebSocket | WebSocket для V2Ray |
| `v2raygrpc/` | gRPC | gRPC для V2Ray |
| `v2raygrpclite/` | gRPC Lite | Упрощенный gRPC |
| `v2rayhttp/` | HTTP | HTTP для V2Ray |
| `v2rayquic/` | QUIC | QUIC для V2Ray |
| `trojan/` | Trojan Transport | Транспорт для Trojan |
| `wireguard/` | WireGuard | WireGuard устройство |
| `awg/` | AWG | Amnezia WireGuard |
| `sip003/` | SIP003 | Плагины для SS |
| `simple-obfs/` | Simple-Obfs | Обфускация |

### 🛠️ Common Utilities (`common/`)
**Общие утилиты**

| Директория | Назначение |
|-----------|-----------|
| `dialer/` | Создание соединений |
| `tls/` | TLS утилиты |
| `certificate/` | Управление сертификатами |
| `process/` | Определение процессов |
| `sniff/` | Определение протокола |
| `geoip/` | GeoIP база |
| `geosite/` | База сайтов |
| `listener/` | Сетевые слушатели |
| `redir/` | Транспарентный прокси |
| `mux/` | Мультиплексирование |
| `uot/` | UDP over TCP |
| `urltest/` | Тестирование URL |

### 🧪 Experimental (`experimental/`)
**Экспериментальные функции**

| Директория | Назначение |
|-----------|-----------|
| `clashapi/` | Clash REST API |
| `v2rayapi/` | V2Ray gRPC API |
| `libbox/` | Библиотека для мобильных |
| `cachefile/` | Кэширование на диск |

### ⚙️ Option Layer (`option/`)
**Конфигурация**

| Файл | Назначение |
|------|-----------|
| `options.go` | Основные опции |
| `inbound.go` | Опции inbound'ов |
| `outbound.go` | Опции outbound'ов |
| `route.go` | Опции маршрутизации |
| `dns.go` | Опции DNS |
| `rule.go` | Опции правил |
| `*.go` | Опции для каждого протокола |

### 📱 Clients (`clients/`)
**Клиентские приложения**

| Директория | Платформа | Язык |
|-----------|----------|------|
| `android/` | Android | Kotlin |
| `apple/` | iOS/macOS | Swift |

### 📖 Documentation (`docs/`)
**Документация**

| Директория | Содержание |
|-----------|-----------|
| `configuration/` | Конфигурация протоколов |
| `installation/` | Установка |
| `manual/` | Руководства |
| `clients/` | Документация клиентов |

## 🔍 Быстрый поиск

### Где найти реализацию протокола X?
→ `protocol/X/` (inbound.go, outbound.go)

### Где найти транспорт Y?
→ `transport/Y/`

### Где находятся правила маршрутизации?
→ `route/rule/`

### Где находится DNS логика?
→ `dns/router.go`, `dns/client.go`

### Где находится главная логика?
→ `box.go` - координатор
→ `route/router.go` - маршрутизация

### Где находятся интерфейсы?
→ `adapter/*.go`

### Где находится конфигурация?
→ `option/*.go`

## 📊 Иерархия зависимостей

```
box.go
  ├── adapter/ (интерфейсы)
  ├── route/ (маршрутизация)
  │   └── rule/ (правила)
  ├── dns/ (DNS)
  ├── protocol/ (протоколы)
  │   └── transport/ (транспорты)
  ├── common/ (утилиты)
  └── option/ (конфигурация)
```

## 🎯 Типичные задачи

### Добавить новый протокол
1. Создать `protocol/newprotocol/inbound.go` и `outbound.go`
2. Зарегистрировать в `protocol/newprotocol/registry.go`
3. Добавить опции в `option/newprotocol.go`
4. Обновить документацию в `docs/configuration/`

### Добавить новое правило
1. Создать `route/rule/rule_item_new.go`
2. Добавить в `route/rule/rule_abstract.go`
3. Добавить опции в `option/rule.go`

### Добавить новый транспорт
1. Создать `transport/newtransport/`
2. Реализовать интерфейс транспорта
3. Интегрировать с протоколом

### Изменить логику маршрутизации
1. `route/router.go` - основная логика
2. `route/route.go` - вспомогательные функции
3. `route/rule/` - правила

### Изменить DNS логику
1. `dns/router.go` - DNS роутер
2. `dns/client.go` - DNS клиент
3. `dns/transport/` - транспорты

## 🔗 Ключевые файлы для понимания

1. **`box.go`** - точка входа, инициализация
2. **`route/router.go`** - маршрутизация соединений
3. **`adapter/router.go`** - интерфейсы маршрутизации
4. **`adapter/inbound.go`** - интерфейсы входящих соединений
5. **`adapter/outbound.go`** - интерфейсы исходящих соединений
6. **`dns/router.go`** - DNS маршрутизация
7. **`route/rule/rule_abstract.go`** - базовая логика правил

## 📝 Конвенции именования

- **Интерфейсы**: `Inbound`, `Outbound`, `Router`
- **Реализации**: `Manager`, `Router`, `Client`
- **Опции**: `InboundOptions`, `OutboundOptions`
- **Протоколы**: директория с именем протокола
- **Транспорты**: директория с именем транспорта

## 🚀 Точки входа

- **CLI**: `cmd/sing-box/` - командная строка
- **Library**: `box.go` - New() функция
- **Android**: `clients/android/`
- **iOS/macOS**: `clients/apple/`

## 🔄 Поток данных

```
Inbound → Router → Rules → Outbound → Transport → Server
         ↓
      DNS Router → DNS Rules → DNS Transport
```

## 💡 Советы для AI-ассистентов

1. **Начинайте с `box.go`** - понимание общей структуры
2. **Изучите `adapter/`** - интерфейсы определяют контракты
3. **Смотрите примеры в `protocol/`** - как реализованы протоколы
4. **Правила в `route/rule/`** - много похожих файлов, используйте grep
5. **Конфигурация в `option/`** - структуры опций
6. **Тесты в `test/`** - примеры использования

## 🐛 Отладка

- **Логи**: `log/` - система логирования
- **Debug**: `debug.go`, `debug_*.go` - отладочные функции
- **Тесты**: `test/` - тестовые конфигурации
