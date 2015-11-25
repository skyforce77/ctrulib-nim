proc IRU_Initialize*(sharedmem_addr: ptr u32; sharedmem_size: u32): Result
#The permissions for the specified memory is set to RO. This memory must be already mapped.

proc IRU_Shutdown*(): Result
proc IRU_GetServHandle*(): Handle
proc IRU_SendData*(buf: ptr u8; size: u32; wait: u32): Result
proc IRU_RecvData*(buf: ptr u8; size: u32; flag: u8; transfercount: ptr u32; wait: u32): Result
proc IRU_SetBitRate*(value: u8): Result
proc IRU_GetBitRate*(`out`: ptr u8): Result
proc IRU_SetIRLEDState*(value: u32): Result
proc IRU_GetIRLEDRecvState*(`out`: ptr u32): Result