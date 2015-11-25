proc htonl*(hostlong: uint32_t): uint32_t {.inline.} =
  return __builtin_bswap32(hostlong)

proc htons*(hostshort: uint16_t): uint16_t {.inline.} =
  return __builtin_bswap16(hostshort)

proc ntohl*(netlong: uint32_t): uint32_t {.inline.} =
  return __builtin_bswap32(netlong)

proc ntohs*(netshort: uint16_t): uint16_t {.inline.} =
  return __builtin_bswap16(netshort)

proc inet_addr*(cp: cstring): in_addr_t
proc inet_aton*(cp: cstring; inp: ptr in_addr): cint
proc inet_ntoa*(`in`: in_addr): cstring