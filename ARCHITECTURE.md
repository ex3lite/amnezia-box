# Архитектура amnezia-box

## Обзор

**amnezia-box** — это универсальная прокси-платформа, форк sing-box, построенная на модульной архитектуре с четким разделением слоев. Проект написан на Go и поддерживает множество протоколов и транспортных механизмов.

## Архитектурные слои

```
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                        │
│  (clients/android, clients/apple, cmd/sing-box)            │
└─────────────────────────────────────────────────────────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                      Box Core                                │
│  (box.go - главный координатор)                            │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼────────┐  ┌───────▼────────┐  ┌───────▼────────┐
│   Adapter      │  │    Route        │  │      DNS       │
│    Layer       │  │    Layer        │  │     Layer      │
└───────┬────────┘  └───────┬────────┘  └───────┬────────┘
        │                   │                   │
┌───────▼───────────────────────────────────────▼────────┐
│              Protocol Layer                             │
│  (shadowsocks, vmess, vless, trojan, etc.)             │
└───────┬─────────────────────────────────────────────────┘
        │
┌───────▼─────────────────────────────────────────────────┐
│            Transport Layer                               │
│  (websocket, grpc, quic, http, etc.)                  │
└───────┬─────────────────────────────────────────────────┘
        │
┌───────▼─────────────────────────────────────────────────┐
│            Common Utilities                              │
│  (dialer, tls, certificate, process, etc.)               │
└──────────────────────────────────────────────────────────┘
```

## Детальное описание слоев

### 1. Box Core (`box.go`)

**Назначение**: Главный координатор всех компонентов системы.

**Основные компоненты**:
- `Box` - центральная структура, управляющая жизненным циклом
- Инициализация всех менеджеров
- Координация запуска и остановки компонентов

**Зависимости**:
- Все менеджеры (Inbound, Outbound, Endpoint, DNS, Router, Network, Service)
- Логирование
- Контекст приложения

**Жизненный цикл**:
1. `New()` - создание и инициализация
2. `PreStart()` - предварительная инициализация
3. `Start()` - запуск всех компонентов
4. `Close()` - корректное завершение

### 2. Adapter Layer (`adapter/`)

**Назначение**: Определяет интерфейсы и абстракции для всех компонентов.

#### 2.1 Inbound (`adapter/inbound.go`)
- **Inbound** - интерфейс входящих соединений
- **InboundManager** - управление входящими соединениями
- **InboundContext** - контекст входящего соединения (метаданные, протокол, домен, и т.д.)

**Типы**:
- TCPInjectableInbound - для TCP соединений
- UDPInjectableInbound - для UDP пакетов

#### 2.2 Outbound (`adapter/outbound.go`)
- **Outbound** - интерфейс исходящих соединений
- **OutboundManager** - управление исходящими соединениями
- Реализует `N.Dialer` для установки соединений

#### 2.3 Endpoint (`adapter/endpoint.go`)
- **Endpoint** - комбинация Inbound и Outbound
- Используется для специальных точек подключения (например, WireGuard endpoint)

#### 2.4 Router (`adapter/router.go`)
- **Router** - маршрутизация соединений
- **ConnectionRouter** - маршрутизация TCP/UDP соединений
- **RuleSet** - наборы правил маршрутизации
- **ConnectionTracker** - отслеживание соединений

#### 2.5 Service (`adapter/service.go`)
- **Service** - фоновые сервисы
- **ServiceManager** - управление сервисами

### 3. Route Layer (`route/`)

**Назначение**: Маршрутизация трафика на основе правил.

#### 3.1 Router (`route/router.go`)
- Основной роутер для маршрутизации соединений
- Управление правилами и наборами правил
- Интеграция с процесс-секером для определения приложений
- Поддержка WiFi состояния

#### 3.2 Rules (`route/rule/`)
**Типы правил**:
- **Domain** - по домену
- **DomainKeyword** - по ключевому слову в домене
- **DomainRegex** - по регулярному выражению домена
- **IPCIDR** - по IP/CIDR
- **Port** - по порту
- **PortRange** - по диапазону портов
- **Network** - по типу сети (TCP/UDP)
- **Protocol** - по протоколу
- **ProcessName** - по имени процесса
- **ProcessPath** - по пути процесса
- **PackageName** - по имени пакета (Android)
- **WIFISSID** - по SSID WiFi
- **WIFIBSSID** - по BSSID WiFi
- **Inbound** - по входящему соединению
- **Outbound** - по исходящему соединению
- **User** - по пользователю
- **Client** - по клиенту
- **RuleSet** - ссылка на набор правил

**Действия правил**:
- `Block` - блокировка
- `Direct` - прямое соединение
- `Proxy` - проксирование через outbound
- `DNSRoute` - маршрутизация DNS

#### 3.3 RuleSet (`route/rule/rule_set.go`)
- Локальные наборы правил
- Удаленные наборы правил (загрузка из URL)
- Поддержка обновлений

#### 3.4 Network Manager (`route/network.go`)
- Управление сетевыми интерфейсами
- TUN/TAP интерфейсы
- Маршрутизация на уровне ОС
- DHCP сервер

#### 3.5 Connection Manager (`route/conn.go`)
- Управление активными соединениями
- Отслеживание статистики

### 4. DNS Layer (`dns/`)

**Назначение**: DNS резолвинг и маршрутизация.

#### 4.1 DNS Router (`dns/router.go`)
- Маршрутизация DNS запросов
- Применение DNS правил
- Кэширование результатов
- Обратное отображение IP -> домен

#### 4.2 DNS Client (`dns/client.go`)
- Клиент для DNS запросов
- Кэширование
- Поддержка различных стратегий (IPv4/IPv6/IPv4+IPv6)

#### 4.3 DNS Transport (`dns/transport/`)
**Типы транспортов**:
- `local` - локальный DNS
- `tcp` - DNS over TCP
- `udp` - DNS over UDP
- `tls` - DNS over TLS (DoT)
- `https` - DNS over HTTPS (DoH)
- `quic` - DNS over QUIC (DoQ)
- `h3` - DNS over HTTP/3
- `fakeip` - Fake IP для обхода DNS

### 5. Protocol Layer (`protocol/`)

**Назначение**: Реализация протоколов проксирования.

**Поддерживаемые протоколы**:

#### 5.1 Shadowsocks (`protocol/shadowsocks/`)
- Shadowsocks (SS)
- Shadowsocks Relay
- Multi-user Shadowsocks

#### 5.2 VMess (`protocol/vmess/`)
- VMess протокол (V2Ray)

#### 5.3 VLESS (`protocol/vless/`)
- VLESS протокол (V2Ray)

#### 5.4 Trojan (`protocol/trojan/`)
- Trojan протокол

#### 5.5 Hysteria (`protocol/hysteria/`, `protocol/hysteria2/`)
- Hysteria и Hysteria2 протоколы

#### 5.6 TUIC (`protocol/tuic/`)
- TUIC протокол

#### 5.7 WireGuard (`protocol/wireguard/`)
- WireGuard VPN

#### 5.8 Tailscale (`protocol/tailscale/`)
- Tailscale VPN

#### 5.9 Другие протоколы:
- `direct` - прямое соединение
- `block` - блокировка
- `socks` - SOCKS5
- `http` - HTTP прокси
- `naive` - Naive протокол
- `shadowtls` - ShadowTLS
- `ssh` - SSH туннель
- `tor` - Tor
- `tun` - TUN интерфейс
- `mixed` - смешанный протокол (SOCKS + HTTP)
- `redirect` - редирект
- `tproxy` - TPROXY
- `group` - группа outbound'ов (selector, urltest)

### 6. Transport Layer (`transport/`)

**Назначение**: Транспортные механизмы для протоколов.

**Типы транспортов**:

#### 6.1 WebSocket (`transport/v2raywebsocket/`)
- WebSocket транспорт для V2Ray протоколов

#### 6.2 gRPC (`transport/v2raygrpc/`, `transport/v2raygrpclite/`)
- gRPC транспорт
- gRPC Lite (упрощенная версия)

#### 6.3 HTTP (`transport/v2rayhttp/`, `transport/v2rayhttpupgrade/`)
- HTTP транспорт
- HTTP Upgrade транспорт

#### 6.4 QUIC (`transport/v2rayquic/`)
- QUIC транспорт для V2Ray

#### 6.5 Trojan (`transport/trojan/`)
- Специальный транспорт для Trojan

#### 6.6 WireGuard (`transport/wireguard/`)
- WireGuard транспорт и устройство

#### 6.7 AWG (`transport/awg/`)
- Amnezia WireGuard транспорт

#### 6.8 SIP003 (`transport/sip003/`)
- Плагины SIP003 для Shadowsocks

#### 6.9 Simple-Obfs (`transport/simple-obfs/`)
- Simple-obfs обфускация

### 7. Common Utilities (`common/`)

**Назначение**: Общие утилиты и вспомогательные функции.

#### 7.1 Dialer (`common/dialer/`)
- Создание сетевых соединений
- Поддержка различных типов dialer'ов
- TFO (TCP Fast Open)

#### 7.2 TLS (`common/tls/`)
- Управление TLS соединениями
- Сертификаты
- TLS фрагментация

#### 7.3 Certificate (`common/certificate/`)
- Управление сертификатами
- Хранилища сертификатов

#### 7.4 Process (`common/process/`)
- Определение процессов
- Поиск процесса по порту/сокету

#### 7.5 Sniff (`common/sniff/`)
- Определение протокола (protocol sniffing)
- Определение домена из трафика

#### 7.6 GeoIP (`common/geoip/`)
- GeoIP база данных
- Определение страны по IP

#### 7.7 Geosite (`common/geosite/`)
- База данных сайтов по категориям
- Используется для правил маршрутизации

#### 7.8 Listener (`common/listener/`)
- Сетевые слушатели
- Поддержка различных типов слушателей

#### 7.9 Redir (`common/redir/`)
- Транспарентный прокси
- Редирект трафика

#### 7.10 Другие утилиты:
- `badtls` - обход проверки TLS
- `badvversion` - обход проверки версии
- `conntrack` - отслеживание соединений
- `convertor` - конвертеры
- `interrupt` - обработка прерываний
- `ja3` - JA3 fingerprinting
- `mux` - мультиплексирование
- `pipelistener` - pipeline listener
- `settings` - настройки
- `srs` - SRS (Source Routing)
- `taskmonitor` - мониторинг задач
- `tlsfragment` - фрагментация TLS
- `uot` - UDP over TCP
- `urltest` - тестирование URL

### 8. Experimental (`experimental/`)

**Назначение**: Экспериментальные функции.

#### 8.1 ClashAPI (`experimental/clashapi/`)
- REST API совместимый с Clash
- Управление через HTTP API

#### 8.2 V2RayAPI (`experimental/v2rayapi/`)
- gRPC API совместимый с V2Ray
- Управление через gRPC

#### 8.3 Libbox (`experimental/libbox/`)
- Библиотека для мобильных приложений
- Платформо-специфичные интерфейсы

#### 8.4 CacheFile (`experimental/cachefile/`)
- Кэширование данных на диск
- Сохранение состояния

### 9. Option Layer (`option/`)

**Назначение**: Конфигурация и опции для всех компонентов.

- Определение структур конфигурации
- Валидация опций
- Регистры опций для каждого типа компонента

### 10. Constant (`constant/`)

**Назначение**: Константы и перечисления.

- Типы протоколов
- Типы транспортов
- Типы правил
- Коды ошибок
- Таймауты
- Версии

## Поток данных

### Входящее соединение (Inbound)

```
1. Клиент → Inbound (protocol/*/inbound.go)
   ↓
2. Inbound создает InboundContext с метаданными
   ↓
3. Router.RouteConnection() (route/router.go)
   ↓
4. Применение правил (route/rule/)
   ↓
5. Выбор Outbound
   ↓
6. Outbound.DialContext() (protocol/*/outbound.go)
   ↓
7. Transport (transport/*)
   ↓
8. Удаленный сервер
```

### DNS запрос

```
1. DNS запрос → DNS Router (dns/router.go)
   ↓
2. Применение DNS правил (route/rule/rule_dns.go)
   ↓
3. Выбор DNS Transport (dns/transport/)
   ↓
4. DNS Transport отправляет запрос
   ↓
5. Ответ кэшируется
   ↓
6. Возврат результата
```

### Исходящее соединение (Outbound)

```
1. Приложение → Outbound.DialContext()
   ↓
2. Outbound (protocol/*/outbound.go)
   ↓
3. Transport (transport/*)
   ↓
4. Удаленный сервер
```

## Менеджеры и их взаимодействие

### InboundManager
- Управляет всеми входящими соединениями
- Создает и удаляет inbound'ы
- Регистрирует обработчики соединений

### OutboundManager
- Управляет всеми исходящими соединениями
- Создает и удаляет outbound'ы
- Предоставляет доступ к outbound'ам по тегу

### EndpointManager
- Управляет endpoint'ами
- Используется для специальных точек подключения

### Router
- Маршрутизирует соединения
- Применяет правила
- Управляет наборами правил

### DNSRouter
- Маршрутизирует DNS запросы
- Применяет DNS правила
- Управляет DNS транспортами

### DNSTransportManager
- Управляет DNS транспортами
- Создает и удаляет транспорты

### NetworkManager
- Управляет сетевыми интерфейсами
- TUN/TAP интерфейсы
- Маршрутизация на уровне ОС

### ConnectionManager
- Отслеживает активные соединения
- Собирает статистику

### ServiceManager
- Управляет фоновыми сервисами
- Запускает и останавливает сервисы

## Регистры (Registries)

Регистры используются для динамического создания компонентов:

- **InboundRegistry** - регистр типов inbound'ов
- **OutboundRegistry** - регистр типов outbound'ов
- **EndpointRegistry** - регистр типов endpoint'ов
- **DNSTransportRegistry** - регистр типов DNS транспортов
- **ServiceRegistry** - регистр типов сервисов

Каждый протокол/транспорт регистрирует себя в соответствующем регистре при инициализации.

## Жизненный цикл компонентов

Все компоненты реализуют интерфейс `Lifecycle`:

```go
type Lifecycle interface {
    Start(stage StartStage) error
    Close() error
}
```

**Этапы запуска**:
1. `StartStateInitialize` - инициализация
2. `StartStateStart` - запуск
3. `StartStatePostStart` - пост-запуск
4. `StartStateStarted` - полностью запущен

## Контекст и зависимости

Проект использует контекст Go для передачи зависимостей:

- `service.Context` - базовый контекст с регистрами сервисов
- `adapter.WithContext()` - добавление InboundContext
- Все менеджеры доступны через `service.FromContext[T](ctx)`

## Платформо-специфичный код

- **Android**: `clients/android/`, `constant/goos/android/`
- **iOS/macOS**: `clients/apple/`, `constant/goos/darwin/`
- **Linux**: `constant/goos/linux/`
- **Windows**: `constant/goos/windows/`

## Клиенты

- **Android**: Kotlin приложение в `clients/android/`
- **Apple**: Swift приложения в `clients/apple/` (iOS, macOS)

## Тестирование

Тесты находятся в `test/`:
- Unit тесты
- Интеграционные тесты
- Конфигурационные файлы для тестов

## Документация

Документация в `docs/`:
- Конфигурация
- Установка
- Руководства
- Миграция
