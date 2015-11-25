const
  HOST_NOT_FOUND* = 1
  NO_DATA* = 2
  NO_ADDRESS* = NO_DATA
  NO_RECOVERY* = 3
  TRY_AGAIN* = 4

type
  hostent* = object
    h_name*: cstring
    h_aliases*: cstringArray
    h_addrtype*: cint
    h_length*: cint
    h_addr_list*: cstringArray
    h_addr*: cstring


var h_errno*: cint

proc gethostbyname*(name: cstring): ptr hostent
proc gethostbyaddr*(`addr`: pointer; len: socklen_t; `type`: cint): ptr hostent
proc herror*(s: cstring)
proc hstrerror*(err: cint): cstring