#See also: http://3dbrew.org/wiki/HID_Services http://3dbrew.org/wiki/HID_Shared_Memory

type
  PAD_KEY* = enum
    KEY_A = BIT(0), KEY_B = BIT(1), KEY_SELECT = BIT(2), KEY_START = BIT(3),
    KEY_DRIGHT = BIT(4), KEY_DLEFT = BIT(5), KEY_DUP = BIT(6), KEY_DDOWN = BIT(7),
    KEY_R = BIT(8), KEY_L = BIT(9), KEY_X = BIT(10), KEY_Y = BIT(11), KEY_ZL = BIT(14), # (new 3DS only)
    KEY_ZR = BIT(15),           # (new 3DS only)
    KEY_TOUCH = BIT(20),        # Not actually provided by HID
    KEY_CSTICK_RIGHT = BIT(24), # c-stick (new 3DS only)
    KEY_CSTICK_LEFT = BIT(25),  # c-stick (new 3DS only)
    KEY_CSTICK_UP = BIT(26),    # c-stick (new 3DS only)
    KEY_CSTICK_DOWN = BIT(27),  # c-stick (new 3DS only)
    KEY_CPAD_RIGHT = BIT(28),   # circle pad
    KEY_CPAD_LEFT = BIT(29),    # circle pad
    KEY_CPAD_UP = BIT(30),      # circle pad
    KEY_CPAD_DOWN = BIT(31),    # circle pad
                          # Generic catch-all directions
    KEY_UP = KEY_DUP or KEY_CPAD_UP, KEY_DOWN = KEY_DDOWN or KEY_CPAD_DOWN,
    KEY_LEFT = KEY_DLEFT or KEY_CPAD_LEFT, KEY_RIGHT = KEY_DRIGHT or KEY_CPAD_RIGHT
  touchPosition* = object
    px*: u16
    py*: u16

  circlePosition* = object
    dx*: s16
    dy*: s16

  accelVector* = object
    x*: s16
    y*: s16
    z*: s16

  angularRate* = object
    x*: s16                    #roll
    z*: s16                    #yaw
    y*: s16                    #pitch
  
  HID_Event* = enum
    HIDEVENT_PAD0 = 0,          #"Event signaled by HID-module, when the sharedmem+0(PAD/circle-pad)/+0xA8(touch-screen) region was updated."
    HIDEVENT_PAD1,            #"Event signaled by HID-module, when the sharedmem+0(PAD/circle-pad)/+0xA8(touch-screen) region was updated."
    HIDEVENT_Accel,           #"Event signaled by HID-module, when the sharedmem accelerometer state was updated."
    HIDEVENT_Gyro,            #"Event signaled by HID-module, when the sharedmem gyroscope state was updated."
    HIDEVENT_DebugPad,        #"Event signaled by HID-module, when the sharedmem DebugPad state was updated."
    HIDEVENT_MAX              # used to know how many events there are



var hidMemHandle*: Handle

var hidSharedMem*: ptr vu32

proc hidInit*(): Result
proc hidExit*()
proc hidScanInput*()
proc hidKeysHeld*(): u32
proc hidKeysDown*(): u32
proc hidKeysUp*(): u32
proc hidTouchRead*(pos: ptr touchPosition)
proc hidCircleRead*(pos: ptr circlePosition)
proc hidAccelRead*(vector: ptr accelVector)
proc hidGyroRead*(rate: ptr angularRate)
proc hidWaitForEvent*(id: HID_Event; nextEvent: bool)
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
                        eventgyro: ptr Handle; eventdebugpad: ptr Handle): Result
proc HIDUSER_EnableAccelerometer*(): Result
proc HIDUSER_DisableAccelerometer*(): Result
proc HIDUSER_EnableGyroscope*(): Result
proc HIDUSER_DisableGyroscope*(): Result
proc HIDUSER_GetGyroscopeRawToDpsCoefficient*(coeff: ptr cfloat): Result
proc HIDUSER_GetSoundVolume*(volume: ptr u8): Result
#Return the volume slider value (0-63)
