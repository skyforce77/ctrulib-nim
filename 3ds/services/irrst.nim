#See also: http://3dbrew.org/wiki/IR_Services http://3dbrew.org/wiki/IRRST_Shared_Memory

var irrstMemHandle*: Handle

var irrstSharedMem*: ptr vu32 = nil

proc irrstInit*(): Result = 0
proc irrstExit*() = discard void
proc irrstScanInput*() = discard void
proc irrstKeysHeld*(): u32 = 0
proc irrstCstickRead*(pos: ptr circlePosition) = discard void
proc irrstWaitForEvent*(nextEvent: bool) = discard void
const
  hidCstickRead* = irrstCstickRead

proc IRRST_GetHandles*(outMemHandle: ptr Handle; outEventHandle: ptr Handle): Result = 0
proc IRRST_Initialize*(unk1: u32; unk2: u8): Result = 0
proc IRRST_Shutdown*(): Result = 0
