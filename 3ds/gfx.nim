#*
#  @file gfx.h
#  @brief LCD Screens manipulation
#
#  This header provides functions to configure and manipulate the two screens, including double buffering and 3D activation.
#  It is mainly an abstraction over the gsp service.
#

include "services/gsp"

template RGB565*(r, g, b: expr): expr =
  (((b) and 0x0000001F) or (((g) and 0x0000003F) shl 5) or
      (((r) and 0x0000001F) shl 11))

template RGB8_to_565*(r, g, b: expr): expr =
  (((b) shr 3) and 0x0000001F) or ((((g) shr 2) and 0x0000003F) shl 5) or
      ((((r) shr 3) and 0x0000001F) shl 11)

type
  gfxScreen_t* {.size: sizeof(cint).} = enum
    GFX_TOP = 0, GFX_BOTTOM = 1


#*
#  @brief Side of top screen framebuffer.
#
#  This is to be used only when the 3D is enabled.
#  Use only GFX_LEFT if this concerns the bottom screen or if 3D is disabled.
#

type
  gfx3dSide_t* {.size: sizeof(cint).} = enum
    GFX_LEFT = 0,               #/< Left eye framebuffer
    GFX_RIGHT = 1               #/< Right eye framebuffer
               # GFX_BOTTOM = 0


#/@name System related
#/@{
#*
#  @brief Initializes the LCD framebuffers with default parameters
#
#  By default ctrulib will configure the LCD framebuffers with the @ref GSP_BGR8_OES format in linear memory.
#  This is the same as calling : @code gfxInit(GSP_BGR8_OES,GSP_BGR8_OES,false); @endcode
#
#  @note You should always call @ref gfxExit once done to free the memory and services
#

proc gfxInitDefault*() {.cdecl, importc: "gfxInitDefault", header: "3ds.h".}
#*
#  @brief Initializes the LCD framebuffers
#  @brief topFormat The format of the top screen framebuffers
#  @brief bottomFormat The format of the bottom screen framebuffers
#
#  This function will allocate the memory for the framebuffers and open a gsp service session.
#  It will also bind the newly allocated framebuffers to the LCD screen and setup the VBlank event.
#
#  The 3D stereoscopic display is will be disabled.
#
#  @note Even if the double buffering is disabled, it will allocate two buffer per screen.
#  @note You should always call @ref gfxExit once done to free the memory and services
#

proc gfxInit*(topFormat: GSP_FramebufferFormats;
             bottomFormat: GSP_FramebufferFormats; vrambuffers: bool) {.cdecl,
    importc: "gfxInit", header: "3ds.h".}
#*
#  @brief Closes the gsp service and frees the framebuffers.
#
#  Just call it when you're done.
#

proc gfxExit*() {.cdecl, importc: "gfxExit", header: "3ds.h".}
#/@}
#/@name Control
#/@{
#*
#  @brief Enables the 3D stereoscopic effect.
#  @param enable Enables the 3D effect if true, disables it if false.
#

proc gfxSet3D*(enable: bool) {.cdecl, importc: "gfxSet3D", header: "3ds.h".}
#*
#  @brief Changes the color format of a screen
#  @param screen The screen of which format should be changed
#  @param format One of the gsp pixel formats.
#

proc gfxSetScreenFormat*(screen: gfxScreen_t; format: GSP_FramebufferFormats) {.
    cdecl, importc: "gfxSetScreenFormat", header: "3ds.h".}
#*
#  @brief Gets a screen pixel format.
#  @return the pixel format of the chosen screen set by ctrulib.
#

proc gfxGetScreenFormat*(screen: gfxScreen_t): GSP_FramebufferFormats {.cdecl,
    importc: "gfxGetScreenFormat", header: "3ds.h".}
#*
#  @brief Enables the ctrulib double buffering
#
#  ctrulib is by default using a double buffering scheme.
#  If you do not want to swap one of the screen framebuffers when @ref gfxSwapBuffers or @ref gfxSwapBuffers is called,
#  then you have to disable double buffering.
#
#  It is however recommended to call @ref gfxSwapBuffers even if double buffering is disabled
#  for both screens if you want to keep the gsp configuration up to date.
#

proc gfxSetDoubleBuffering*(screen: gfxScreen_t; doubleBuffering: bool) {.cdecl,
    importc: "gfxSetDoubleBuffering", header: "3ds.h".}
#*
#  @brief Flushes the current framebuffers
#
#  Use this if the data within your framebuffers changes a lot and that you want to make sure everything was updated correctly.
#  This shouldn't be needed and has a significant overhead.
#

proc gfxFlushBuffers*() {.cdecl, importc: "gfxFlushBuffers", header: "3ds.h".}
#*
#  @brief Swaps the buffers and sets the gsp state
#
#  This is to be called to update the gsp state and swap the framebuffers.
#  LCD rendering should start as soon as the gsp state is set.
#  When using the GPU, call @ref gfxSwapBuffers instead.
#

proc gfxSwapBuffers*() {.cdecl, importc: "gfxSwapBuffers", header: "3ds.h".}
#*
#  @brief Swaps the framebuffers
#
#  This is the version to be used with the GPU since the GPU will use the gsp shared memory,
#  so the gsp state mustn't be set directly by the user.
#

proc gfxSwapBuffersGpu*() {.cdecl, importc: "gfxSwapBuffersGpu", header: "3ds.h".}
#/@}
#/@name Helper
#/@{
#*
#  @brief Retrieves a framebuffer information
#  @param width Pointer that will hold the width of the framebuffer in pixels
#  @param height Pointer that will hold the height of the framebuffer in pixels
#  @return a pointer to the current framebuffer of the choosen screen
#
#  Please remember that the returned pointer will change after each call to gfxSwapBuffers if double buffering is enabled.
#

proc gfxGetFramebuffer*(screen: gfxScreen_t; side: gfx3dSide_t; width: ptr u16;
                       height: ptr u16): ptr u8 {.cdecl, importc: "gfxGetFramebuffer",
    header: "3ds.h".}
#/@}
#global variables

var gfxTopLeftFramebuffers* {.importc: "gfxTopLeftFramebuffers", header: "3ds.h".}: array[
    2, ptr u8]

var gfxTopRightFramebuffers* {.importc: "gfxTopRightFramebuffers", header: "3ds.h".}: array[
    2, ptr u8]

var gfxBottomFramebuffers* {.importc: "gfxBottomFramebuffers", header: "3ds.h".}: array[
    2, ptr u8]

var gxCmdBuf* {.importc: "gxCmdBuf", header: "3ds.h".}: ptr u32
