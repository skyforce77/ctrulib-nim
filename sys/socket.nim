const
  SOL_SOCKET* = 0x0000FFFF
  PF_UNSPEC* = 0
  PF_INET* = 2
  PF_INET6* = 10
  AF_UNSPEC* = PF_UNSPEC
  AF_INET* = PF_INET
  AF_INET6* = PF_INET6
  SOCK_STREAM* = 1
  SOCK_DGRAM* = 2
  MSG_CTRUNC* = 0x01000000
  MSG_DONTROUTE* = 0x02000000
  MSG_EOR* = 0x04000000
  MSG_OOB* = 0x08000000
  MSG_PEEK* = 0x10000000
  MSG_TRUNC* = 0x20000000
  MSG_WAITALL* = 0x40000000
  SHUT_RD* = 0
  SHUT_WR* = 1
  SHUT_RDWR* = 2

##define SO_DEBUG      0x0001   // not working
##define SO_ACCEPTCONN 0x0002   // not working

const
  SO_REUSEADDR* = 0x00000004

##define SO_KEEPALIVE  0x0008   // not working
##define SO_DONTROUTE  0x0010   // not working
##define SO_BROADCAST  0x0020   // not working

const
  SO_USELOOPBACK* = 0x00000040
  SO_LINGER* = 0x00000080
  SO_OOBINLINE* = 0x00000100

##define SO_REUSEPORT  0x0200   // not working
#
#  Additional options, not kept in so_options.
# 

const
  SO_SNDBUF* = 0x00001001
  SO_RCVBUF* = 0x00001002
  SO_SNDLOWAT* = 0x00001003
  SO_RCVLOWAT* = 0x00001004

##define SO_SNDTIMEO   0x1005      /* send timeout */     // not working
##define SO_RCVTIMEO   0x1006      /* receive timeout */  // not working

const
  SO_TYPE* = 0x00001008
  SO_ERROR* = 0x00001009

type
  socklen_t* = uint32_t
  sa_family_t* = uint16_t
  sockaddr* {.importc: "sockaddr", header: "socket.h".} = object
    sa_family* {.importc: "sa_family".}: sa_family_t
    sa_data* {.importc: "sa_data".}: ptr char

  sockaddr_storage* {.importc: "sockaddr_storage", header: "socket.h".} = object
    ss_family* {.importc: "ss_family".}: sa_family_t
    __ss_padding* {.importc: "__ss_padding".}: array[14, char]

  linger* {.importc: "linger", header: "socket.h".} = object
    l_onoff* {.importc: "l_onoff".}: cint
    l_linger* {.importc: "l_linger".}: cint


proc accept*(sockfd: cint; `addr`: ptr sockaddr; addrlen: ptr socklen_t): cint {.cdecl,
    importc: "accept", header: "socket.h".}
proc `bind`*(sockfd: cint; `addr`: ptr sockaddr; addrlen: socklen_t): cint {.cdecl,
    importc: "bind", header: "socket.h".}
proc closesocket*(sockfd: cint): cint {.cdecl, importc: "closesocket",
                                    header: "socket.h".}
proc connect*(sockfd: cint; `addr`: ptr sockaddr; addrlen: socklen_t): cint {.cdecl,
    importc: "connect", header: "socket.h".}
proc getpeername*(sockfd: cint; `addr`: ptr sockaddr; addrlen: ptr socklen_t): cint {.
    cdecl, importc: "getpeername", header: "socket.h".}
proc getsockname*(sockfd: cint; `addr`: ptr sockaddr; addrlen: ptr socklen_t): cint {.
    cdecl, importc: "getsockname", header: "socket.h".}
proc getsockopt*(sockfd: cint; level: cint; optname: cint; optval: pointer;
                optlen: ptr socklen_t): cint {.cdecl, importc: "getsockopt",
    header: "socket.h".}
proc listen*(sockfd: cint; backlog: cint): cint {.cdecl, importc: "listen",
    header: "socket.h".}
proc recv*(sockfd: cint; buf: pointer; len: csize; flags: cint): ssize_t {.cdecl,
    importc: "recv", header: "socket.h".}
proc recvfrom*(sockfd: cint; buf: pointer; len: csize; flags: cint;
              src_addr: ptr sockaddr; addrlen: ptr socklen_t): ssize_t {.cdecl,
    importc: "recvfrom", header: "socket.h".}
proc send*(sockfd: cint; buf: pointer; len: csize; flags: cint): ssize_t {.cdecl,
    importc: "send", header: "socket.h".}
proc sendto*(sockfd: cint; buf: pointer; len: csize; flags: cint;
            dest_addr: ptr sockaddr; addrlen: socklen_t): ssize_t {.cdecl,
    importc: "sendto", header: "socket.h".}
proc setsockopt*(sockfd: cint; level: cint; optname: cint; optval: pointer;
                optlen: socklen_t): cint {.cdecl, importc: "setsockopt",
                                        header: "socket.h".}
proc shutdown*(sockfd: cint; how: cint): cint {.cdecl, importc: "shutdown",
    header: "socket.h".}
proc socket*(domain: cint; `type`: cint; protocol: cint): cint {.cdecl,
    importc: "socket", header: "socket.h".}
proc sockatmark*(sockfd: cint): cint {.cdecl, importc: "sockatmark", header: "socket.h".}