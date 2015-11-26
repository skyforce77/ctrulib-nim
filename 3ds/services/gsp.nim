template GSP_REBASE_REG*(r: expr): expr =
  ((r) - 0x1EB00000)

type                          #See this for GSP_CaptureInfoEntry and GSP_CaptureInfo: http://3dbrew.org/wiki/GSPGPU:ImportDisplayCaptureInfo
  GSP_FramebufferInfo* = object
    active_framebuf*: u32      #"0=first, 1=second"
    framebuf0_vaddr*: ptr u32   #"Framebuffer virtual address, for the main screen this is the 3D left framebuffer"
    framebuf1_vaddr*: ptr u32   #"For the main screen: 3D right framebuffer address"
    framebuf_widthbytesize*: u32 #"Value for 0x1EF00X90, controls framebuffer width"
    format*: u32               #"Framebuffer format, this u16 is written to the low u16 for LCD register 0x1EF00X70."
    framebuf_dispselect*: u32  #"Value for 0x1EF00X78, controls which framebuffer is displayed"
    unk*: u32                  #"?"

  GSP_FramebufferFormats* = enum
    GSP_RGBA8_OES = 0,          #pixel_size = 4-bytes
    GSP_BGR8_OES = 1,           #pixel_size = 3-bytes
    GSP_RGB565_OES = 2,         #pixel_size = 2-bytes
    GSP_RGB5_A1_OES = 3,        #pixel_size = 2-bytes
    GSP_RGBA4_OES = 4
  GSP_CaptureInfoEntry* = object
    framebuf0_vaddr*: ptr u32
    framebuf1_vaddr*: ptr u32
    format*: u32
    framebuf_widthbytesize*: u32

  GSP_CaptureInfo* = object
    screencapture*: array[2, GSP_CaptureInfoEntry]

  GSP_Event* = enum
    GSPEVENT_PSC0 = 0,          # memory fill completed
    GSPEVENT_PSC1, GSPEVENT_VBlank0, GSPEVENT_VBlank1, GSPEVENT_PPF, # display transfer finished
    GSPEVENT_P3D,             # command list processing finished
    GSPEVENT_DMA, GSPEVENT_MAX # used to know how many events there are
  GSPLCD_Screens* = enum
    GSPLCD_TOP = BIT(0), GSPLCD_BOTTOM = BIT(1),
    GSPLCD_BOTH = BIT(0) or BIT(1)




proc gspInit*(): Result
proc gspExit*() = nil
proc gspLcdInit*(): Result
proc gspLcdExit*()
proc gspInitEventHandler*(gspEvent: Handle; gspSharedMem: ptr vu8; gspThreadId: u8): Result
proc gspExitEventHandler*()
proc gspWaitForEvent*(id: GSP_Event; nextEvent: bool)
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

proc GSPGPU_AcquireRight*(handle: ptr Handle; flags: u8): Result
proc GSPGPU_ReleaseRight*(handle: ptr Handle): Result
proc GSPGPU_ImportDisplayCaptureInfo*(handle: ptr Handle;
                                     captureinfo: ptr GSP_CaptureInfo): Result
proc GSPGPU_SaveVramSysArea*(handle: ptr Handle): Result
proc GSPGPU_RestoreVramSysArea*(handle: ptr Handle): Result
proc GSPGPU_SetLcdForceBlack*(handle: ptr Handle; flags: u8): Result
proc GSPGPU_SetBufferSwap*(handle: ptr Handle; screenid: u32;
                          framebufinfo: ptr GSP_FramebufferInfo): Result
proc GSPGPU_FlushDataCache*(handle: ptr Handle; adr: ptr u8; size: u32): Result
proc GSPGPU_InvalidateDataCache*(handle: ptr Handle; adr: ptr u8; size: u32): Result
proc GSPGPU_WriteHWRegs*(handle: ptr Handle; regAddr: u32; data: ptr u32; size: u8): Result
proc GSPGPU_WriteHWRegsWithMask*(handle: ptr Handle; regAddr: u32; data: ptr u32;
                                datasize: u8; maskdata: ptr u32; masksize: u8): Result
proc GSPGPU_ReadHWRegs*(handle: ptr Handle; regAddr: u32; data: ptr u32; size: u8): Result
proc GSPGPU_RegisterInterruptRelayQueue*(handle: ptr Handle; eventHandle: Handle;
                                        flags: u32; outMemHandle: ptr Handle;
                                        threadID: ptr u8): Result
proc GSPGPU_UnregisterInterruptRelayQueue*(handle: ptr Handle): Result
proc GSPGPU_TriggerCmdReqQueue*(handle: ptr Handle): Result
proc GSPGPU_SubmitGxCommand*(sharedGspCmdBuf: ptr u32;
                            gxCommand: array[0x00000008, u32]; handle: ptr Handle): Result
proc GSPLCD_PowerOffBacklight*(screen: GSPLCD_Screens): Result
proc GSPLCD_PowerOnBacklight*(screen: GSPLCD_Screens): Result
