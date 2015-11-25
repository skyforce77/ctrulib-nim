#See also: http://3dbrew.org/wiki/IR_Services http://3dbrew.org/wiki/IRRST_Shared_Memory

import
  3ds/services/hid

var irrstMemHandle*: Handle

var irrstSharedMem*: ptr vu32

proc irrstInit*(): Result
proc irrstExit*()
proc irrstScanInput*()
proc irrstKeysHeld*(): u32
proc irrstCstickRead*(pos: ptr circlePosition)
proc irrstWaitForEvent*(nextEvent: bool)
const
  hidCstickRead* = irrstCstickRead

proc IRRST_GetHandles*(outMemHandle: ptr Handle; outEventHandle: ptr Handle): Result
proc IRRST_Initialize*(unk1: u32; unk2: u8): Result
proc IRRST_Shutdown*(): Result