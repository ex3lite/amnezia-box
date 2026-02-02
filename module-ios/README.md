# iOS Module

Модуль для iOS платформы.

## Структура

- `cmd/` - точка входа для iOS приложения
- `platform/` - iOS специфичный код

## Сборка

```bash
make build-ios
# или
cd module-ios && go build -tags ios ./cmd
```

## Зависимости

- `github.com/sagernet/amnezia-box-core` - общий модуль

## Build Tags

- `ios` - для iOS платформы
- `with_gvisor` - поддержка gvisor
- `with_quic` - поддержка QUIC
- `with_wireguard` - поддержка WireGuard
