proc IRU_Initialize*(sharedmem_addr: ptr u32; sharedmem_size: u32): Result {.cdecl,
    importc: "IRU_Initialize", header: "ir.h".}
#The permissions for the specified memory is set to RO. This memory must be already mapped.

proc IRU_Shutdown*(): Result {.cdecl, importc: "IRU_Shutdown", header: "ir.h".}
proc IRU_GetServHandle*(): Handle {.cdecl, importc: "IRU_GetServHandle",
                                 header: "ir.h".}
proc IRU_SendData*(buf: ptr u8; size: u32; wait: u32): Result {.cdecl,
    importc: "IRU_SendData", header: "ir.h".}
proc IRU_RecvData*(buf: ptr u8; size: u32; flag: u8; transfercount: ptr u32; wait: u32): Result {.
    cdecl, importc: "IRU_RecvData", header: "ir.h".}
proc IRU_SetBitRate*(value: u8): Result {.cdecl, importc: "IRU_SetBitRate",
                                      header: "ir.h".}
proc IRU_GetBitRate*(`out`: ptr u8): Result {.cdecl, importc: "IRU_GetBitRate",
    header: "ir.h".}
proc IRU_SetIRLEDState*(value: u32): Result {.cdecl, importc: "IRU_SetIRLEDState",
    header: "ir.h".}
proc IRU_GetIRLEDRecvState*(`out`: ptr u32): Result {.cdecl,
    importc: "IRU_GetIRLEDRecvState", header: "ir.h".}