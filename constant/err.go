package constant

import E "github.com/sagernet/sing/common/exceptions"

var ErrTLSRequired = E.New("Требуется TLS")

var ErrQUICNotIncluded = E.New(`QUIC не включен в эту сборку, пересоберите с -tags with_quic`)
