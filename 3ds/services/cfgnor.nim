proc CFGNOR_Initialize*(value: u8): Result
proc CFGNOR_Shutdown*(): Result
proc CFGNOR_ReadData*(offset: u32; buf: ptr u32; size: u32): Result
proc CFGNOR_WriteData*(offset: u32; buf: ptr u32; size: u32): Result
proc CFGNOR_DumpFlash*(buf: ptr u32; size: u32): Result
proc CFGNOR_WriteFlash*(buf: ptr u32; size: u32): Result