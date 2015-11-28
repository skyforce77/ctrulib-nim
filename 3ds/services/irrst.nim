#See also: http://3dbrew.org/wiki/IR_Services http://3dbrew.org/wiki/IRRST_Shared_Memory

import
  "3ds/services/hid"

var irrstMemHandle* {.importc: "irrstMemHandle", header: "irrst.h".}: Handle

var irrstSharedMem* {.importc: "irrstSharedMem", header: "irrst.h".}: ptr vu32

proc irrstInit*(): Result {.cdecl, importc: "irrstInit", header: "irrst.h".}
proc irrstExit*() {.cdecl, importc: "irrstExit", header: "irrst.h".}
proc irrstScanInput*() {.cdecl, importc: "irrstScanInput", header: "irrst.h".}
proc irrstKeysHeld*(): u32 {.cdecl, importc: "irrstKeysHeld", header: "irrst.h".}
proc irrstCstickRead*(pos: ptr circlePosition) {.cdecl, importc: "irrstCstickRead",
    header: "irrst.h".}
proc irrstWaitForEvent*(nextEvent: bool) {.cdecl, importc: "irrstWaitForEvent",
                                        header: "irrst.h".}
const
  hidCstickRead* = irrstCstickRead

proc IRRST_GetHandles*(outMemHandle: ptr Handle; outEventHandle: ptr Handle): Result {.
    cdecl, importc: "IRRST_GetHandles", header: "irrst.h".}
proc IRRST_Initialize*(unk1: u32; unk2: u8): Result {.cdecl,
    importc: "IRRST_Initialize", header: "irrst.h".}
proc IRRST_Shutdown*(): Result {.cdecl, importc: "IRRST_Shutdown", header: "irrst.h".}
