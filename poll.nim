const
  POLLIN* = 0x00000001
  POLLPRI* = 0x00000002
  POLLHUP* = 0x00000004
  POLLERR* = 0x00000008
  POLLOUT* = 0x00000010
  POLLNVAL* = 0x00000020

type
  nfds_t* = u32
  pollfd* = object
    fd*: cint
    events*: cint
    revents*: cint


proc poll*(fds: ptr pollfd; nfsd: nfds_t; timeout: cint): cint