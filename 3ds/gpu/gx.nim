#*
#  @file gx.h
# 

template GX_BUFFER_DIM*(w, h: expr): expr =
  (((h) shl 16) or ((w) and 0x0000FFFF))

#*
#  @brief Pixel formats
#  @sa GSP_FramebufferFormats
# 

type
  GX_TRANSFER_FORMAT* {.size: sizeof(cint).} = enum
    GX_TRANSFER_FMT_RGBA8 = 0, GX_TRANSFER_FMT_RGB8 = 1, GX_TRANSFER_FMT_RGB565 = 2,
    GX_TRANSFER_FMT_RGB5A1 = 3, GX_TRANSFER_FMT_RGBA4 = 4


#*
#  @brief Anti-aliasing modes
# 
#  Please remember that the framebuffer is sideways.
#  Hence if you activate 2x1 anti-aliasing the destination dimensions are w = 240*2 and h = 400
# 

type
  GX_TRANSFER_SCALE* {.size: sizeof(cint).} = enum
    GX_TRANSFER_SCALE_NO = 0,   #/< No anti-aliasing
    GX_TRANSFER_SCALE_X = 1,    #/< 2x1 anti-aliasing
    GX_TRANSFER_SCALE_XY = 2    #/< 2x2 anti-aliasing


#*
#  @brief GX transfer control flags
# 

type
  GX_FILL_CONTROL* {.size: sizeof(cint).} = enum
    GX_FILL_16BIT_DEPTH = 0x00000000, #/< The buffer has a 16 bit per pixel depth
    GX_FILL_TRIGGER = 0x00000001, #/< Trigger the PPF event
    GX_FILL_FINISHED = 0x00000002, #/< Indicates if the memory fill is complete. You should not use it when requesting a transfer.
    GX_FILL_24BIT_DEPTH = 0x00000100, #/< The buffer has a 24 bit per pixel depth
    GX_FILL_32BIT_DEPTH = 0x00000200 #/< The buffer has a 32 bit per pixel depth


template GX_TRANSFER_FLIP_VERT*(x: expr): expr =
  ((x) shl 0)

template GX_TRANSFER_OUT_TILED*(x: expr): expr =
  ((x) shl 1)

template GX_TRANSFER_RAW_COPY*(x: expr): expr =
  ((x) shl 3)

template GX_TRANSFER_IN_FORMAT*(x: expr): expr =
  ((x) shl 8)

template GX_TRANSFER_OUT_FORMAT*(x: expr): expr =
  ((x) shl 12)

template GX_TRANSFER_SCALING*(x: expr): expr =
  ((x) shl 24)

proc GX_RequestDma*(gxbuf: ptr u32; src: ptr u32; dst: ptr u32; length: u32): Result {.cdecl,
    importc: "GX_RequestDma", header: "3ds.h".}
proc GX_SetCommandList_Last*(gxbuf: ptr u32; buf0a: ptr u32; buf0s: u32; flags: u8): Result {.
    cdecl, importc: "GX_SetCommandList_Last", header: "3ds.h".}
proc GX_SetMemoryFill*(gxbuf: ptr u32; buf0a: ptr u32; buf0v: u32; buf0e: ptr u32;
                      control0: u16; buf1a: ptr u32; buf1v: u32; buf1e: ptr u32;
                      control1: u16): Result {.cdecl, importc: "GX_SetMemoryFill",
    header: "3ds.h".}
proc GX_SetDisplayTransfer*(gxbuf: ptr u32; inadr: ptr u32; indim: u32; outadr: ptr u32;
                           outdim: u32; flags: u32): Result {.cdecl,
    importc: "GX_SetDisplayTransfer", header: "3ds.h".}
proc GX_SetTextureCopy*(gxbuf: ptr u32; inadr: ptr u32; indim: u32; outadr: ptr u32;
                       outdim: u32; size: u32; flags: u32): Result {.cdecl,
    importc: "GX_SetTextureCopy", header: "3ds.h".}
proc GX_SetCommandList_First*(gxbuf: ptr u32; buf0a: ptr u32; buf0s: u32; buf1a: ptr u32;
                             buf1s: u32; buf2a: ptr u32; buf2s: u32): Result {.cdecl,
    importc: "GX_SetCommandList_First", header: "3ds.h".}