template GSP_REBASE_REG*(r: expr): expr =
  ((r) - 0x1EB00000)

type                          #See this for GSP_CaptureInfoEntry and GSP_CaptureInfo: http://3dbrew.org/wiki/GSPGPU:ImportDisplayCaptureInfo
  GSP_FramebufferInfo* {.importc: "GSP_FramebufferInfo", header: "gsp.h".} = object
    active_framebuf* {.importc: "active_framebuf".}: u32 #"0=first, 1=second"
    framebuf0_vaddr* {.importc: "framebuf0_vaddr".}: ptr u32 #"Framebuffer virtual address, for the main screen this is the 3D left framebuffer"
    framebuf1_vaddr* {.importc: "framebuf1_vaddr".}: ptr u32 #"For the main screen: 3D right framebuffer address"
    framebuf_widthbytesize* {.importc: "framebuf_widthbytesize".}: u32 #"Value for 0x1EF00X90, controls framebuffer width"
    format* {.importc: "format".}: u32 #"Framebuffer format, this u16 is written to the low u16 for LCD register 0x1EF00X70."
    framebuf_dispselect* {.importc: "framebuf_dispselect".}: u32 #"Value for 0x1EF00X78, controls which framebuffer is displayed"
    unk* {.importc: "unk".}: u32 #"?"

  GSP_FramebufferFormats* {.size: sizeof(cint).} = enum
    GSP_RGBA8_OES = 0,          #pixel_size = 4-bytes
    GSP_BGR8_OES = 1,           #pixel_size = 3-bytes
    GSP_RGB565_OES = 2,         #pixel_size = 2-bytes
    GSP_RGB5_A1_OES = 3,        #pixel_size = 2-bytes
    GSP_RGBA4_OES = 4
  GSP_CaptureInfoEntry* {.importc: "GSP_CaptureInfoEntry", header: "gsp.h".} = object
    framebuf0_vaddr* {.importc: "framebuf0_vaddr".}: ptr u32
    framebuf1_vaddr* {.importc: "framebuf1_vaddr".}: ptr u32
    format* {.importc: "format".}: u32
    framebuf_widthbytesize* {.importc: "framebuf_widthbytesize".}: u32

  GSP_CaptureInfo* {.importc: "GSP_CaptureInfo", header: "gsp.h".} = object
    screencapture* {.importc: "screencapture".}: array[2, GSP_CaptureInfoEntry]

  GSP_Event* {.size: sizeof(cint).} = enum
    GSPEVENT_PSC0 = 0,          # memory fill completed
    GSPEVENT_PSC1, GSPEVENT_VBlank0, GSPEVENT_VBlank1, GSPEVENT_PPF, # display transfer finished
    GSPEVENT_P3D,             # command list processing finished
    GSPEVENT_DMA, GSPEVENT_MAX # used to know how many events there are
  GSPLCD_Screens* {.size: sizeof(cint).} = enum
    GSPLCD_TOP = BIT(0), GSPLCD_BOTTOM = BIT(1),
    GSPLCD_BOTH = BIT(0) or BIT(1)




proc gspInit*(): Result {.cdecl, importc: "gspInit", header: "gsp.h".}
proc gspExit*() {.cdecl, importc: "gspExit", header: "gsp.h".}
proc gspLcdInit*(): Result {.cdecl, importc: "gspLcdInit", header: "gsp.h".}
proc gspLcdExit*() {.cdecl, importc: "gspLcdExit", header: "gsp.h".}
proc gspInitEventHandler*(gspEvent: Handle; gspSharedMem: ptr vu8; gspThreadId: u8): Result {.
    cdecl, importc: "gspInitEventHandler", header: "gsp.h".}
proc gspExitEventHandler*() {.cdecl, importc: "gspExitEventHandler", header: "gsp.h".}
proc gspWaitForEvent*(id: GSP_Event; nextEvent: bool) {.cdecl,
    importc: "gspWaitForEvent", header: "gsp.h".}
template gspWaitForPSC0*(): expr =
  gspWaitForEvent(GSPEVENT_PSC0, false)

template gspWaitForPSC1*(): expr =
  gspWaitForEvent(GSPEVENT_PSC1, false)

template gspWaitForVBlank*(): expr =
  gspWaitForVBlank0()

template gspWaitForVBlank0*(): expr =
  gspWaitForEvent(GSPEVENT_VBlank0, true)

template gspWaitForVBlank1*(): expr =
  gspWaitForEvent(GSPEVENT_VBlank1, true)

template gspWaitForPPF*(): expr =
  gspWaitForEvent(GSPEVENT_PPF, false)

template gspWaitForP3D*(): expr =
  gspWaitForEvent(GSPEVENT_P3D, false)

template gspWaitForDMA*(): expr =
  gspWaitForEvent(GSPEVENT_DMA, false)

proc GSPGPU_AcquireRight*(handle: ptr Handle; flags: u8): Result {.cdecl,
    importc: "GSPGPU_AcquireRight", header: "gsp.h".}
proc GSPGPU_ReleaseRight*(handle: ptr Handle): Result {.cdecl,
    importc: "GSPGPU_ReleaseRight", header: "gsp.h".}
proc GSPGPU_ImportDisplayCaptureInfo*(handle: ptr Handle;
                                     captureinfo: ptr GSP_CaptureInfo): Result {.
    cdecl, importc: "GSPGPU_ImportDisplayCaptureInfo", header: "gsp.h".}
proc GSPGPU_SaveVramSysArea*(handle: ptr Handle): Result {.cdecl,
    importc: "GSPGPU_SaveVramSysArea", header: "gsp.h".}
proc GSPGPU_RestoreVramSysArea*(handle: ptr Handle): Result {.cdecl,
    importc: "GSPGPU_RestoreVramSysArea", header: "gsp.h".}
proc GSPGPU_SetLcdForceBlack*(handle: ptr Handle; flags: u8): Result {.cdecl,
    importc: "GSPGPU_SetLcdForceBlack", header: "gsp.h".}
proc GSPGPU_SetBufferSwap*(handle: ptr Handle; screenid: u32;
                          framebufinfo: ptr GSP_FramebufferInfo): Result {.cdecl,
    importc: "GSPGPU_SetBufferSwap", header: "gsp.h".}
proc GSPGPU_FlushDataCache*(handle: ptr Handle; adr: ptr u8; size: u32): Result {.cdecl,
    importc: "GSPGPU_FlushDataCache", header: "gsp.h".}
proc GSPGPU_InvalidateDataCache*(handle: ptr Handle; adr: ptr u8; size: u32): Result {.
    cdecl, importc: "GSPGPU_InvalidateDataCache", header: "gsp.h".}
proc GSPGPU_WriteHWRegs*(handle: ptr Handle; regAddr: u32; data: ptr u32; size: u8): Result {.
    cdecl, importc: "GSPGPU_WriteHWRegs", header: "gsp.h".}
proc GSPGPU_WriteHWRegsWithMask*(handle: ptr Handle; regAddr: u32; data: ptr u32;
                                datasize: u8; maskdata: ptr u32; masksize: u8): Result {.
    cdecl, importc: "GSPGPU_WriteHWRegsWithMask", header: "gsp.h".}
proc GSPGPU_ReadHWRegs*(handle: ptr Handle; regAddr: u32; data: ptr u32; size: u8): Result {.
    cdecl, importc: "GSPGPU_ReadHWRegs", header: "gsp.h".}
proc GSPGPU_RegisterInterruptRelayQueue*(handle: ptr Handle; eventHandle: Handle;
                                        flags: u32; outMemHandle: ptr Handle;
                                        threadID: ptr u8): Result {.cdecl,
    importc: "GSPGPU_RegisterInterruptRelayQueue", header: "gsp.h".}
proc GSPGPU_UnregisterInterruptRelayQueue*(handle: ptr Handle): Result {.cdecl,
    importc: "GSPGPU_UnregisterInterruptRelayQueue", header: "gsp.h".}
proc GSPGPU_TriggerCmdReqQueue*(handle: ptr Handle): Result {.cdecl,
    importc: "GSPGPU_TriggerCmdReqQueue", header: "gsp.h".}
proc GSPGPU_SubmitGxCommand*(sharedGspCmdBuf: ptr u32;
                            gxCommand: array[0x00000008, u32]; handle: ptr Handle): Result {.
    cdecl, importc: "GSPGPU_SubmitGxCommand", header: "gsp.h".}
proc GSPLCD_PowerOffBacklight*(screen: GSPLCD_Screens): Result {.cdecl,
    importc: "GSPLCD_PowerOffBacklight", header: "gsp.h".}
proc GSPLCD_PowerOnBacklight*(screen: GSPLCD_Screens): Result {.cdecl,
    importc: "GSPLCD_PowerOnBacklight", header: "gsp.h".}
