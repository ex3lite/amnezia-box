# Core Module

Общий модуль, используемый всеми платформенными модулями.

## Структура

- `adapter/` - Интерфейсы и абстракции
- `protocol/` - Реализации протоколов (Shadowsocks, VMess, VLESS, Trojan, etc.)
- `transport/` - Транспортные механизмы (WebSocket, gRPC, QUIC, etc.)
- `route/` - Маршрутизация трафика и правила
- `dns/` - DNS резолвинг и маршрутизация
- `common/` - Общие утилиты
- `option/` - Конфигурация и опции
- `log/` - Система логирования
- `constant/` - Константы
- `include/` - Регистрация компонентов
- `service/` - Сервисы
- `box.go` - Главный координатор

## Использование

Этот модуль импортируется всеми платформенными модулями:

```go
import "github.com/sagernet/amnezia-box-core/box"
import "github.com/sagernet/amnezia-box-core/adapter"
import "github.com/sagernet/amnezia-box-core/protocol/shadowsocks"
```

## Сборка

```bash
make build-core
# или
cd core && go build
```
