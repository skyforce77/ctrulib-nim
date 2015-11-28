proc CFGNOR_Initialize*(value: u8): Result {.cdecl, importc: "CFGNOR_Initialize",
    header: "cfgnor.h".}
proc CFGNOR_Shutdown*(): Result {.cdecl, importc: "CFGNOR_Shutdown",
                               header: "cfgnor.h".}
proc CFGNOR_ReadData*(offset: u32; buf: ptr u32; size: u32): Result {.cdecl,
    importc: "CFGNOR_ReadData", header: "cfgnor.h".}
proc CFGNOR_WriteData*(offset: u32; buf: ptr u32; size: u32): Result {.cdecl,
    importc: "CFGNOR_WriteData", header: "cfgnor.h".}
proc CFGNOR_DumpFlash*(buf: ptr u32; size: u32): Result {.cdecl,
    importc: "CFGNOR_DumpFlash", header: "cfgnor.h".}
proc CFGNOR_WriteFlash*(buf: ptr u32; size: u32): Result {.cdecl,
    importc: "CFGNOR_WriteFlash", header: "cfgnor.h".}