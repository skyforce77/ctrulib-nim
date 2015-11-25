#See also: http://3dbrew.org/wiki/QTM_Services

type
  qtmHeadtrackingInfoCoord* = object
    x*: cfloat
    y*: cfloat

  qtmHeadtrackingInfo* = object
    flags*: array[5, u8]
    padding*: array[3, u8]
    floatdata_x08*: cfloat     #"not used by System_Settings."
    coords0*: array[4, qtmHeadtrackingInfoCoord]
    unk_x2c*: array[5, u32]     #"Not used by System_Settings."
  

proc qtmInit*(): Result
proc qtmExit*()
proc qtmCheckInitialized*(): bool
proc qtmGetHeadtrackingInfo*(val: u64; `out`: ptr qtmHeadtrackingInfo): Result
#val is normally 0.

proc qtmCheckHeadFullyDetected*(info: ptr qtmHeadtrackingInfo): bool
proc qtmConvertCoordToScreen*(coord: ptr qtmHeadtrackingInfoCoord;
                             screen_width: ptr cfloat; screen_height: ptr cfloat;
                             x: ptr u32; y: ptr u32): Result
#screen_* can be NULL to use the default values for the top-screen.
