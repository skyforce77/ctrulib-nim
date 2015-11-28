#See also: http://3dbrew.org/wiki/QTM_Services

type
  qtmHeadtrackingInfoCoord* {.importc: "qtmHeadtrackingInfoCoord", header: "qtm.h".} = object
    x* {.importc: "x".}: cfloat
    y* {.importc: "y".}: cfloat

  qtmHeadtrackingInfo* {.importc: "qtmHeadtrackingInfo", header: "qtm.h".} = object
    flags* {.importc: "flags".}: array[5, u8]
    padding* {.importc: "padding".}: array[3, u8]
    floatdata_x08* {.importc: "floatdata_x08".}: cfloat #"not used by System_Settings."
    coords0* {.importc: "coords0".}: array[4, qtmHeadtrackingInfoCoord]
    unk_x2c* {.importc: "unk_x2c".}: array[5, u32] #"Not used by System_Settings."
  

proc qtmInit*(): Result {.cdecl, importc: "qtmInit", header: "qtm.h".}
proc qtmExit*() {.cdecl, importc: "qtmExit", header: "qtm.h".}
proc qtmCheckInitialized*(): bool {.cdecl, importc: "qtmCheckInitialized",
                                 header: "qtm.h".}
proc qtmGetHeadtrackingInfo*(val: u64; `out`: ptr qtmHeadtrackingInfo): Result {.cdecl,
    importc: "qtmGetHeadtrackingInfo", header: "qtm.h".}
#val is normally 0.

proc qtmCheckHeadFullyDetected*(info: ptr qtmHeadtrackingInfo): bool {.cdecl,
    importc: "qtmCheckHeadFullyDetected", header: "qtm.h".}
proc qtmConvertCoordToScreen*(coord: ptr qtmHeadtrackingInfoCoord;
                             screen_width: ptr cfloat; screen_height: ptr cfloat;
                             x: ptr u32; y: ptr u32): Result {.cdecl,
    importc: "qtmConvertCoordToScreen", header: "qtm.h".}
#screen_* can be NULL to use the default values for the top-screen.
