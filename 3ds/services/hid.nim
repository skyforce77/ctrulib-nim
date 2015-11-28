#See also: http://3dbrew.org/wiki/HID_Services http://3dbrew.org/wiki/HID_Shared_Memory

import "3ds/types"

  # Generic catch-all directions
let KEY_RIGHT* = BIT(4) or BIT(28)
let KEY_LEFT* = BIT(5) or BIT(29)
let KEY_UP* = BIT(6) or BIT(30)
let KEY_DOWN* = BIT(7) or BIT(31)
let KEY_A* = BIT(0)
let KEY_B* = BIT(1)
let KEY_SELECT* = BIT(2)
let KEY_START* = BIT(3)
let KEY_DRIGHT* = BIT(4)
let KEY_DLEFT* = BIT(5)
let KEY_DUP* = BIT(6)
let KEY_DDOWN* = BIT(7)
let KEY_R* = BIT(8)
let KEY_L* = BIT(9)
let KEY_X* = BIT(10)
let KEY_Y* = BIT(11)
let KEY_ZL* = BIT(14) # (new 3DS only)
let KEY_ZR* = BIT(15)           # (new 3DS only)
let KEY_TOUCH* = BIT(20)        # Not actually provided by HID
let KEY_CSTICK_RIGHT* = BIT(24) # c-stick (new 3DS only)
let KEY_CSTICK_LEFT* = BIT(25)  # c-stick (new 3DS only)
let KEY_CSTICK_UP* = BIT(26)   # c-stick (new 3DS only)
let KEY_CSTICK_DOWN* = BIT(27)  # c-stick (new 3DS only)
let KEY_CPAD_RIGHT* = BIT(28)   # circle pad
let KEY_CPAD_LEFT* = BIT(29)    # circle pad
let KEY_CPAD_UP* = BIT(30)     # circle pad
let KEY_CPAD_DOWN* = BIT(31)    # circle pad

type
  touchPosition* {.importc: "touchPosition", header: "3ds.h".} = object
    px* {.importc: "px".}: u16
    py* {.importc: "py".}: u16

  circlePosition* {.importc: "circlePosition", header: "3ds.h".} = object
    dx* {.importc: "dx".}: s16
    dy* {.importc: "dy".}: s16

  accelVector* {.importc: "accelVector", header: "3ds.h".} = object
    x* {.importc: "x".}: s16
    y* {.importc: "y".}: s16
    z* {.importc: "z".}: s16

  angularRate* {.importc: "angularRate", header: "3ds.h".} = object
    x* {.importc: "x".}: s16     #roll
    z* {.importc: "z".}: s16     #yaw
    y* {.importc: "y".}: s16     #pitch

  HID_Event* {.size: sizeof(cint).} = enum
    HIDEVENT_PAD0 = 0,          #"Event signaled by HID-module, when the sharedmem+0(PAD/circle-pad)/+0xA8(touch-screen) region was updated."
    HIDEVENT_PAD1,            #"Event signaled by HID-module, when the sharedmem+0(PAD/circle-pad)/+0xA8(touch-screen) region was updated."
    HIDEVENT_Accel,           #"Event signaled by HID-module, when the sharedmem accelerometer state was updated."
    HIDEVENT_Gyro,            #"Event signaled by HID-module, when the sharedmem gyroscope state was updated."
    HIDEVENT_DebugPad,        #"Event signaled by HID-module, when the sharedmem DebugPad state was updated."
    HIDEVENT_MAX              # used to know how many events there are



var hidMemHandle* {.importc: "hidMemHandle", header: "3ds.h".}: Handle

var hidSharedMem* {.importc: "hidSharedMem", header: "3ds.h".}: ptr vu32

proc hidInit*(): Result {.cdecl, importc: "hidInit", header: "3ds.h".}
proc hidExit*() {.cdecl, importc: "hidExit", header: "3ds.h".}
proc hidScanInput*() {.cdecl, importc: "hidScanInput", header: "3ds.h".}
proc hidKeysHeld*(): u32 {.cdecl, importc: "hidKeysHeld", header: "3ds.h".}
proc hidKeysDown*(): u32 {.cdecl, importc: "hidKeysDown", header: "3ds.h".}
proc hidKeysUp*(): u32 {.cdecl, importc: "hidKeysUp", header: "3ds.h".}
proc hidTouchRead*(pos: ptr touchPosition) {.cdecl, importc: "hidTouchRead",
    header: "3ds.h".}
proc hidCircleRead*(pos: ptr circlePosition) {.cdecl, importc: "hidCircleRead",
    header: "3ds.h".}
proc hidAccelRead*(vector: ptr accelVector) {.cdecl, importc: "hidAccelRead",
    header: "3ds.h".}
proc hidGyroRead*(rate: ptr angularRate) {.cdecl, importc: "hidGyroRead",
                                       header: "3ds.h".}
proc hidWaitForEvent*(id: HID_Event; nextEvent: bool) {.cdecl,
    importc: "hidWaitForEvent", header: "3ds.h".}
# libnds compatibility defines

const
  scanKeys* = hidScanInput
  keysHeld* = hidKeysHeld
  keysDown* = hidKeysDown
  keysUp* = hidKeysUp
  touchRead* = hidTouchRead
  circleRead* = hidCircleRead

proc HIDUSER_GetHandles*(outMemHandle: ptr Handle; eventpad0: ptr Handle;
                        eventpad1: ptr Handle; eventaccel: ptr Handle;
                        eventgyro: ptr Handle; eventdebugpad: ptr Handle): Result {.
    cdecl, importc: "HIDUSER_GetHandles", header: "3ds.h".}
proc HIDUSER_EnableAccelerometer*(): Result {.cdecl,
    importc: "HIDUSER_EnableAccelerometer", header: "3ds.h".}
proc HIDUSER_DisableAccelerometer*(): Result {.cdecl,
    importc: "HIDUSER_DisableAccelerometer", header: "3ds.h".}
proc HIDUSER_EnableGyroscope*(): Result {.cdecl, importc: "HIDUSER_EnableGyroscope",
                                       header: "3ds.h".}
proc HIDUSER_DisableGyroscope*(): Result {.cdecl,
                                        importc: "HIDUSER_DisableGyroscope",
                                        header: "3ds.h".}
proc HIDUSER_GetGyroscopeRawToDpsCoefficient*(coeff: ptr cfloat): Result {.cdecl,
    importc: "HIDUSER_GetGyroscopeRawToDpsCoefficient", header: "3ds.h".}
proc HIDUSER_GetSoundVolume*(volume: ptr u8): Result {.cdecl,
    importc: "HIDUSER_GetSoundVolume", header: "3ds.h".}
#Return the volume slider value (0-63)
