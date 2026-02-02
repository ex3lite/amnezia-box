# Server Module

Модуль для Server платформы (Ubuntu).

## Структура

- `cmd/` - точка входа для Server приложения
- `platform/` - Server специфичный код

## Сборка

```bash
make build-server
# или
cd module-server && go build -tags server ./cmd
```

## Зависимости

- `github.com/sagernet/amnezia-box-core` - общий модуль

## Build Tags

- `server` - для Server платформы
- `with_gvisor` - поддержка gvisor
- `with_quic` - поддержка QUIC
- `with_wireguard` - поддержка WireGuard
- `with_dhcp` - поддержка DHCP
- `with_clash_api` - поддержка Clash API
- `with_v2ray_api` - поддержка V2Ray API

## Docker

Модуль поддерживает сборку Docker образов:

```bash
docker build -t amnezia-box-server -f Dockerfile.server .
```
