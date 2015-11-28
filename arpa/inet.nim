proc htonl*(hostlong: uint32_t): uint32_t {.inline, cdecl.} =
  return __builtin_bswap32(hostlong)

proc htons*(hostshort: uint16_t): uint16_t {.inline, cdecl.} =
  return __builtin_bswap16(hostshort)

proc ntohl*(netlong: uint32_t): uint32_t {.inline, cdecl.} =
  return __builtin_bswap32(netlong)

proc ntohs*(netshort: uint16_t): uint16_t {.inline, cdecl.} =
  return __builtin_bswap16(netshort)

proc inet_addr*(cp: cstring): in_addr_t {.cdecl, importc: "inet_addr", header: "inet.h".}
proc inet_aton*(cp: cstring; inp: ptr in_addr): cint {.cdecl, importc: "inet_aton",
    header: "inet.h".}
proc inet_ntoa*(`in`: in_addr): cstring {.cdecl, importc: "inet_ntoa", header: "inet.h".}