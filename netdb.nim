const
  HOST_NOT_FOUND* = 1
  NO_DATA* = 2
  NO_ADDRESS* = NO_DATA
  NO_RECOVERY* = 3
  TRY_AGAIN* = 4

type
  hostent* {.importc: "hostent", header: "netdb.h".} = object
    h_name* {.importc: "h_name".}: cstring
    h_aliases* {.importc: "h_aliases".}: cstringArray
    h_addrtype* {.importc: "h_addrtype".}: cint
    h_length* {.importc: "h_length".}: cint
    h_addr_list* {.importc: "h_addr_list".}: cstringArray
    h_addr* {.importc: "h_addr".}: cstring


var h_errno* {.importc: "h_errno", header: "netdb.h".}: cint

proc gethostbyname*(name: cstring): ptr hostent {.cdecl, importc: "gethostbyname",
    header: "netdb.h".}
proc gethostbyaddr*(`addr`: pointer; len: socklen_t; `type`: cint): ptr hostent {.cdecl,
    importc: "gethostbyaddr", header: "netdb.h".}
proc herror*(s: cstring) {.cdecl, importc: "herror", header: "netdb.h".}
proc hstrerror*(err: cint): cstring {.cdecl, importc: "hstrerror", header: "netdb.h".}