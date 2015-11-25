# TODO : find a better place to put this

const
  RUNFLAG_APTWORKAROUND* = (BIT(0))
  RUNFLAG_APTREINIT* = (BIT(1))

type
  NS_APPID* = enum
    APPID_HOMEMENU = 0x00000101, # Home Menu
    APPID_CAMERA = 0x00000110,  # Camera applet
    APPID_FRIENDS_LIST = 0x00000112, # Friends List applet
    APPID_GAME_NOTES = 0x00000113, # Game Notes applet
    APPID_WEB = 0x00000114,     # Internet Browser
    APPID_INSTRUCTION_MANUAL = 0x00000115, # Instruction Manual applet
    APPID_NOTIFICATIONS = 0x00000116, # Notifications applet
    APPID_MIIVERSE = 0x00000117, # Miiverse applet (olv)
    APPID_MIIVERSE_POSTING = 0x00000118, # Miiverse posting applet (solv3)
    APPID_AMIIBO_SETTINGS = 0x00000119, # Amiibo settings applet (cabinet)
    APPID_APPLICATION = 0x00000300, # Application
    APPID_ESHOP = 0x00000301,   # eShop (tiger)
    APPID_SOFTWARE_KEYBOARD = 0x00000401, # Software Keyboard
    APPID_APPLETED = 0x00000402, # appletEd
    APPID_PNOTE_AP = 0x00000404, # PNOTE_AP
    APPID_SNOTE_AP = 0x00000405, # SNOTE_AP
    APPID_ERROR = 0x00000406,   # error
    APPID_MINT = 0x00000407,    # mint
    APPID_EXTRAPAD = 0x00000408, # extrapad
    APPID_MEMOLIB = 0x00000409  # memolib


# cf http://3dbrew.org/wiki/NS_and_APT_Services#AppIDs

type
  APP_STATUS* = enum
    APP_NOTINITIALIZED, APP_RUNNING, APP_SUSPENDED, APP_EXITING, APP_SUSPENDING,
    APP_SLEEPMODE, APP_PREPARE_SLEEPMODE, APP_APPLETSTARTED, APP_APPLETCLOSED


const
  APTSIGNAL_HOMEBUTTON* = 1     # 2: sleep-mode related?
  APTSIGNAL_PREPARESLEEP* = 3   # 4: triggered when ptm:s GetShellStatus() returns 5.
  APTSIGNAL_ENTERSLEEP* = 5
  APTSIGNAL_WAKEUP* = 6
  APTSIGNAL_ENABLE* = 7
  APTSIGNAL_POWERBUTTON* = 8
  APTSIGNAL_UTILITY* = 9
  APTSIGNAL_SLEEPSYSTEM* = 10
  APTSIGNAL_ERROR* = 11

const
  APTHOOK_ONSUSPEND* = 0
  APTHOOK_ONRESTORE* = 1
  APTHOOK_ONSLEEP* = 2
  APTHOOK_ONWAKEUP* = 3
  APTHOOK_ONEXIT* = 4
  APTHOOK_COUNT* = 5

type
  aptHookFn* = proc (hook: cint; param: pointer)
  aptHookCookie* = object
    next*: ptr tag_aptHookCookie
    callback*: aptHookFn
    param*: pointer


var aptEvents*: array[3, Handle]

proc aptInit*(): Result
proc aptExit*()
proc aptOpenSession*()
proc aptCloseSession*()
proc aptSetStatus*(status: APP_STATUS)
proc aptGetStatus*(): APP_STATUS
proc aptGetStatusPower*(): u32
#This can be used when the status is APP_SUSPEND* to check how the return-to-menu was triggered: 0 = home-button, 1 = power-button.

proc aptSetStatusPower*(status: u32)
proc aptReturnToMenu*()
#This should be called by the user application when aptGetStatus() returns APP_SUSPENDING, not calling this will result in return-to-menu being disabled with the status left at APP_SUSPENDING. This function will not return until the system returns to the application, or when the status was changed to APP_EXITING.

proc aptWaitStatusEvent*()
proc aptSignalReadyForSleep*()
proc aptGetMenuAppID*(): NS_APPID
proc aptMainLoop*(): bool
# Use like this in your main(): while (aptMainLoop()) { your code here... }

proc aptHook*(cookie: ptr aptHookCookie; callback: aptHookFn; param: pointer)
proc aptUnhook*(cookie: ptr aptHookCookie)
proc APT_GetLockHandle*(handle: ptr Handle; flags: u16; lockHandle: ptr Handle): Result
proc APT_Initialize*(handle: ptr Handle; appId: NS_APPID; eventHandle1: ptr Handle;
                    eventHandle2: ptr Handle): Result
proc APT_Finalize*(handle: ptr Handle; appId: NS_APPID): Result
proc APT_HardwareResetAsync*(handle: ptr Handle): Result
proc APT_Enable*(handle: ptr Handle; a: u32): Result
proc APT_GetAppletManInfo*(handle: ptr Handle; inval: u8; outval8: ptr u8;
                          outval32: ptr u32; menu_appid: ptr NS_APPID;
                          active_appid: ptr NS_APPID): Result
proc APT_GetAppletInfo*(handle: ptr Handle; appID: NS_APPID; pProgramID: ptr u64;
                       pMediaType: ptr u8; pRegistered: ptr u8; pLoadState: ptr u8;
                       pAttributes: ptr u32): Result
proc APT_GetAppletProgramInfo*(handle: ptr Handle; id: u32; flags: u32;
                              titleversion: ptr u16): Result
proc APT_GetProgramID*(handle: ptr Handle; pProgramID: ptr u64): Result
proc APT_PrepareToJumpToHomeMenu*(handle: ptr Handle): Result
proc APT_JumpToHomeMenu*(handle: ptr Handle; a: u32; b: u32; c: u32): Result
proc APT_PrepareToJumpToApplication*(handle: ptr Handle; a: u32): Result
proc APT_JumpToApplication*(handle: ptr Handle; a: u32; b: u32; c: u32): Result
proc APT_IsRegistered*(handle: ptr Handle; appID: NS_APPID; `out`: ptr u8): Result
proc APT_InquireNotification*(handle: ptr Handle; appID: u32; signalType: ptr u8): Result
proc APT_NotifyToWait*(handle: ptr Handle; appID: NS_APPID): Result
proc APT_AppletUtility*(handle: ptr Handle; `out`: ptr u32; a: u32; size1: u32;
                       buf1: ptr u8; size2: u32; buf2: ptr u8): Result
proc APT_GlanceParameter*(handle: ptr Handle; appID: NS_APPID; bufferSize: u32;
                         buffer: ptr u32; actualSize: ptr u32; signalType: ptr u8): Result
proc APT_ReceiveParameter*(handle: ptr Handle; appID: NS_APPID; bufferSize: u32;
                          buffer: ptr u32; actualSize: ptr u32; signalType: ptr u8): Result
proc APT_SendParameter*(handle: ptr Handle; src_appID: NS_APPID; dst_appID: NS_APPID;
                       bufferSize: u32; buffer: ptr u32; paramhandle: Handle;
                       signalType: u8): Result
proc APT_SendCaptureBufferInfo*(handle: ptr Handle; bufferSize: u32; buffer: ptr u32): Result
proc APT_ReplySleepQuery*(handle: ptr Handle; appID: NS_APPID; a: u32): Result
proc APT_ReplySleepNotificationComplete*(handle: ptr Handle; appID: NS_APPID): Result
proc APT_PrepareToCloseApplication*(handle: ptr Handle; a: u8): Result
proc APT_CloseApplication*(handle: ptr Handle; a: u32; b: u32; c: u32): Result
proc APT_SetAppCpuTimeLimit*(handle: ptr Handle; percent: u32): Result
proc APT_GetAppCpuTimeLimit*(handle: ptr Handle; percent: ptr u32): Result
proc APT_CheckNew3DS_Application*(handle: ptr Handle; `out`: ptr u8): Result
# Note: this function is unreliable, see: http://3dbrew.org/wiki/APT:PrepareToStartApplication

proc APT_CheckNew3DS_System*(handle: ptr Handle; `out`: ptr u8): Result
proc APT_CheckNew3DS*(handle: ptr Handle; `out`: ptr u8): Result
proc APT_PrepareToDoAppJump*(handle: ptr Handle; flags: u8; programID: u64;
                            mediatype: u8): Result
proc APT_DoAppJump*(handle: ptr Handle; NSbuf0Size: u32; NSbuf1Size: u32;
                   NSbuf0Ptr: ptr u8; NSbuf1Ptr: ptr u8): Result
proc APT_PrepareToStartLibraryApplet*(handle: ptr Handle; appID: NS_APPID): Result
proc APT_StartLibraryApplet*(handle: ptr Handle; appID: NS_APPID; inhandle: Handle;
                            parambuf: ptr u32; parambufsize: u32): Result
proc APT_LaunchLibraryApplet*(appID: NS_APPID; inhandle: Handle; parambuf: ptr u32;
                             parambufsize: u32): Result
#This should be used for launching library applets, this uses the above APT_StartLibraryApplet/APT_PrepareToStartLibraryApplet funcs + apt*Session(). parambuf is used for APT params input, when the applet closes the output param block is copied here. This is not usable from the homebrew launcher. This is broken: when the applet does get launched at all, the applet process doesn't actually get terminated when the applet gets closed.

proc APT_PrepareToStartSystemApplet*(handle: ptr Handle; appID: NS_APPID): Result
proc APT_StartSystemApplet*(handle: ptr Handle; appID: NS_APPID; bufSize: u32;
                           applHandle: Handle; buf: ptr u8): Result