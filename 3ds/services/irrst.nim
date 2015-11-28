#See also: http://3dbrew.org/wiki/IR_Services http://3dbrew.org/wiki/IRRST_Shared_Memory

import
  "3ds/services/hid"

var irrstMemHandle* {.importc: "irrstMemHandle", header: "3ds.h".}: Handle

var irrstSharedMem* {.importc: "irrstSharedMem", header: "3ds.h".}: ptr vu32

proc irrstInit*(): Result {.cdecl, importc: "irrstInit", header: "3ds.h".}
proc irrstExit*() {.cdecl, importc: "irrstExit", header: "3ds.h".}
proc irrstScanInput*() {.cdecl, importc: "irrstScanInput", header: "3ds.h".}
proc irrstKeysHeld*(): u32 {.cdecl, importc: "irrstKeysHeld", header: "3ds.h".}
proc irrstCstickRead*(pos: ptr circlePosition) {.cdecl, importc: "irrstCstickRead",
    header: "3ds.h".}
proc irrstWaitForEvent*(nextEvent: bool) {.cdecl, importc: "irrstWaitForEvent",
                                        header: "3ds.h".}
const
  hidCstickRead* = irrstCstickRead

proc IRRST_GetHandles*(outMemHandle: ptr Handle; outEventHandle: ptr Handle): Result {.
    cdecl, importc: "IRRST_GetHandles", header: "3ds.h".}
proc IRRST_Initialize*(unk1: u32; unk2: u8): Result {.cdecl,
    importc: "IRRST_Initialize", header: "3ds.h".}
proc IRRST_Shutdown*(): Result {.cdecl, importc: "IRRST_Shutdown", header: "3ds.h".}
