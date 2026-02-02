# Android Module

Модуль для Android платформы.

## Структура

- `cmd/` - точка входа для Android приложения
- `platform/` - Android специфичный код

## Сборка

```bash
make build-android
# или
cd module-android && go build -tags android ./cmd
```

## Зависимости

- `github.com/sagernet/amnezia-box-core` - общий модуль

## Build Tags

- `android` - для Android платформы
- `with_gvisor` - поддержка gvisor
- `with_quic` - поддержка QUIC
- `with_wireguard` - поддержка WireGuard
