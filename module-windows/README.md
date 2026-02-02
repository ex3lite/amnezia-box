# Windows Module

Модуль для Windows платформы.

## Структура

- `cmd/` - точка входа для Windows приложения
- `platform/` - Windows специфичный код

## Сборка

```bash
make build-windows
# или
cd module-windows && go build -tags windows ./cmd
```

## Зависимости

- `github.com/sagernet/amnezia-box-core` - общий модуль

## Build Tags

- `windows` - для Windows платформы
- `with_gvisor` - поддержка gvisor
- `with_quic` - поддержка QUIC
- `with_wireguard` - поддержка WireGuard
