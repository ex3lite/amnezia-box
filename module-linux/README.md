# Linux Module

Модуль для Linux платформы.

## Структура

- `cmd/` - точка входа для Linux приложения
- `platform/` - Linux специфичный код

## Сборка

```bash
make build-linux
# или
cd module-linux && go build -tags linux ./cmd
```

## Зависимости

- `github.com/sagernet/amnezia-box-core` - общий модуль

## Build Tags

- `linux` - для Linux платформы
- `with_gvisor` - поддержка gvisor
- `with_quic` - поддержка QUIC
- `with_wireguard` - поддержка WireGuard
- `with_dhcp` - поддержка DHCP
