const
  SOL_TCP* = 6

const
  _CTRU_TCP_OPT* = 0x00002000   # Flag for tcp opt values 
  TCP_NODELAY* = 1 or _CTRU_TCP_OPT # Don't delay send to coalesce packets  
  TCP_MAXSEG* = 2 or _CTRU_TCP_OPT
