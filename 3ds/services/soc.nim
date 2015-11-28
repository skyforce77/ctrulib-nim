#*
#  @file soc.h
#  @brief SOC service for sockets communications
# 
#  After initializing this service you will be able to use system calls from netdb.h, sys/socket.h etc.
# 

#*
#  @brief Initializes the SOC service.
#  @param context_addr Address of a page-aligned (0x1000) buffer to be used.
#  @param context_size Size of the buffer, a multiple of 0x1000.
#  @note The specified context buffer can no longer be accessed by the process which called this function, since the userland permissions for this block are set to no-access.
# 

proc SOC_Initialize*(context_addr: ptr u32; context_size: u32): Result {.cdecl,
    importc: "SOC_Initialize", header: "soc.h".}
#*
#  @brief Closes the soc service.
#  @note You need to call this in order to be able to use the buffer again.
# 

proc SOC_Shutdown*(): Result {.cdecl, importc: "SOC_Shutdown", header: "soc.h".}
# this is supposed to be in unistd.h but newlib only puts it for cygwin 

proc gethostid*(): clong {.cdecl, importc: "gethostid", header: "soc.h".}