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
  sockaddr* = object
    sa_family*: sa_family_t
    sa_data*: ptr char

  sockaddr_storage* = object
    ss_family*: sa_family_t
    __ss_padding*: array[14, char]

  linger* = object
    l_onoff*: cint
    l_linger*: cint


proc accept*(sockfd: cint; `addr`: ptr sockaddr; addrlen: ptr socklen_t): cint
proc `bind`*(sockfd: cint; `addr`: ptr sockaddr; addrlen: socklen_t): cint
proc closesocket*(sockfd: cint): cint
proc connect*(sockfd: cint; `addr`: ptr sockaddr; addrlen: socklen_t): cint
proc getpeername*(sockfd: cint; `addr`: ptr sockaddr; addrlen: ptr socklen_t): cint
proc getsockname*(sockfd: cint; `addr`: ptr sockaddr; addrlen: ptr socklen_t): cint
proc getsockopt*(sockfd: cint; level: cint; optname: cint; optval: pointer;
                optlen: ptr socklen_t): cint
proc listen*(sockfd: cint; backlog: cint): cint
proc recv*(sockfd: cint; buf: pointer; len: csize; flags: cint): ssize_t
proc recvfrom*(sockfd: cint; buf: pointer; len: csize; flags: cint;
              src_addr: ptr sockaddr; addrlen: ptr socklen_t): ssize_t
proc send*(sockfd: cint; buf: pointer; len: csize; flags: cint): ssize_t
proc sendto*(sockfd: cint; buf: pointer; len: csize; flags: cint;
            dest_addr: ptr sockaddr; addrlen: socklen_t): ssize_t
proc setsockopt*(sockfd: cint; level: cint; optname: cint; optval: pointer;
                optlen: socklen_t): cint
proc shutdown*(sockfd: cint; how: cint): cint
proc socket*(domain: cint; `type`: cint; protocol: cint): cint
proc sockatmark*(sockfd: cint): cint