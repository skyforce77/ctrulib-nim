const
  FIONBIO* = 1

proc ioctl*(fd: cint; request: cint): cint {.varargs.}