const
  INADDR_LOOPBACK* = 0x7F000001
  INADDR_ANY* = 0x00000000
  INADDR_BROADCAST* = 0xFFFFFFFF
  INADDR_NONE* = 0xFFFFFFFF
  INET_ADDRSTRLEN* = 16

#
#  Protocols (See RFC 1700 and the IANA)
# 

const
  IPPROTO_IP* = 0
  IPPROTO_UDP* = 17
  IPPROTO_TCP* = 6
  IP_TOS* = 7
  IP_TTL* = 8
  IP_MULTICAST_LOOP* = 9
  IP_MULTICAST_TTL* = 10
  IP_ADD_MEMBERSHIP* = 11
  IP_DROP_MEMBERSHIP* = 12

type
  in_port_t* = uint16_t
  in_addr_t* = uint32_t
  in_addr* = object
    s_addr*: in_addr_t

  sockaddr_in* = object
    sin_family*: sa_family_t
    sin_port*: in_port_t
    sin_addr*: in_addr
    sin_zero*: array[8, cuchar]


# Request struct for multicast socket ops 

type
  ip_mreq* = object
    imr_multiaddr*: in_addr    # IP multicast address of group 
    imr_interface*: in_addr    # local IP address of interface 
  
