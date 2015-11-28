#*
#  @file cam.h
#  @brief CAM service for using the 3DS's front and back cameras.
#

#*
#  @brief Camera connection target ports.
#

include "y2r"

type
  CAMU_Port* {.size: sizeof(cint).} = enum
    PORT_NONE = 0x00000000, PORT_CAM1 = BIT(0), PORT_CAM2 = BIT(1), # Port combinations.
    PORT_BOTH = BIT(0) or BIT(1)


#*
#  @brief Camera combinations.
#

type
  CAMU_CameraSelect* {.size: sizeof(cint).} = enum
    SELECT_NONE = 0x00000000,
        SELECT_OUT1 = BIT(0),
        SELECT_IN1 = BIT(1),
        SELECT_IN1_OUT1 = BIT(0) or BIT(1),
        SELECT_OUT1_OUT2 = BIT(0) or BIT(2),                   # Camera combinations
        SELECT_IN1_OUT2 = BIT(1) or BIT(2),
        SELECT_ALL = BIT(0) or BIT(1) or BIT(2)
        # TODO SELECT_OUT2 = BIT(2) because invalid order in enum 'SELECT_OUT2'


#*
#  @brief Camera contexts.
#

type
  CAMU_Context* {.size: sizeof(cint).} = enum
    CONTEXT_NONE = 0x00000000, CONTEXT_A = BIT(0), CONTEXT_B = BIT(1), # Context combinations.
    CONTEXT_BOTH = BIT(0) or BIT(1)


#*
#  @brief Ways to flip the camera image.
#

type
  CAMU_Flip* {.size: sizeof(cint).} = enum
    FLIP_NONE = 0x00000000, FLIP_HORIZONTAL = 0x00000001, FLIP_VERTICAL = 0x00000002,
    FLIP_REVERSE = 0x00000003


#*
#  @brief Camera image resolutions.
#

type
  CAMU_Size* {.size: sizeof(cint).} = enum
    SIZE_VGA = 0x00000000, SIZE_QVGA = 0x00000001, SIZE_QQVGA = 0x00000002,
    SIZE_CIF = 0x00000003, SIZE_QCIF = 0x00000004, SIZE_DS_LCD = 0x00000005,
    SIZE_DS_LCDx4 = 0x00000006, SIZE_CTR_TOP_LCD = 0x00000007 # Alias for bottom screen to match top screen naming.

const
  SIZE_CTR_BOTTOM_LCD = SIZE_QVGA

#*
#  @brief Camera capture frame rates.
#

type
  CAMU_FrameRate* {.size: sizeof(cint).} = enum
    FRAME_RATE_15 = 0x00000000, FRAME_RATE_15_TO_5 = 0x00000001,
    FRAME_RATE_15_TO_2 = 0x00000002, FRAME_RATE_10 = 0x00000003,
    FRAME_RATE_8_5 = 0x00000004, FRAME_RATE_5 = 0x00000005,
    FRAME_RATE_20 = 0x00000006, FRAME_RATE_20_TO_5 = 0x00000007,
    FRAME_RATE_30 = 0x00000008, FRAME_RATE_30_TO_5 = 0x00000009,
    FRAME_RATE_15_TO_10 = 0x0000000A, FRAME_RATE_20_TO_10 = 0x0000000B,
    FRAME_RATE_30_TO_10 = 0x0000000C


#*
#  @brief Camera white balance modes.
#

type
  CAMU_WhiteBalance* {.size: sizeof(cint).} = enum
    WHITE_BALANCE_AUTO = 0x00000000, WHITE_BALANCE_3200K = 0x00000001,
    WHITE_BALANCE_4150K = 0x00000002, WHITE_BALANCE_5200K = 0x00000003,
    WHITE_BALANCE_6000K = 0x00000004, WHITE_BALANCE_7000K = 0x00000005, WHITE_BALANCE_MAX = 0x00000006 #
                                                                                              # White
                                                                                              # balance
                                                                                              # aliases.

const
  WHITE_BALANCE_NORMAL = WHITE_BALANCE_AUTO
  WHITE_BALANCE_TUNGSTEN = WHITE_BALANCE_3200K
  WHITE_BALANCE_WHITE_FLUORESCENT_LIGHT = WHITE_BALANCE_4150K
  WHITE_BALANCE_DAYLIGHT = WHITE_BALANCE_5200K
  WHITE_BALANCE_CLOUDY = WHITE_BALANCE_6000K
  WHITE_BALANCE_HORIZON = WHITE_BALANCE_6000K
  WHITE_BALANCE_SHADE = WHITE_BALANCE_7000K

#*
#  @brief Camera photo modes.
#

type
  CAMU_PhotoMode* {.size: sizeof(cint).} = enum
    PHOTO_MODE_NORMAL = 0x00000000, PHOTO_MODE_PORTRAIT = 0x00000001,
    PHOTO_MODE_LANDSCAPE = 0x00000002, PHOTO_MODE_NIGHTVIEW = 0x00000003,
    PHOTO_MODE_LETTER = 0x00000004


#*
#  @brief Camera special effects.
#

type
  CAMU_Effect* {.size: sizeof(cint).} = enum
    EFFECT_NONE = 0x00000000, EFFECT_MONO = 0x00000001, EFFECT_SEPIA = 0x00000002,
    EFFECT_NEGATIVE = 0x00000003, EFFECT_NEGAFILM = 0x00000004,
    EFFECT_SEPIA01 = 0x00000005


#*
#  @brief Camera contrast patterns.
#

type
  CAMU_Contrast* {.size: sizeof(cint).} = enum
    CONTRAST_PATTERN_01 = 0x00000000, CONTRAST_PATTERN_02 = 0x00000001,
    CONTRAST_PATTERN_03 = 0x00000002, CONTRAST_PATTERN_04 = 0x00000003,
    CONTRAST_PATTERN_05 = 0x00000004, CONTRAST_PATTERN_06 = 0x00000005,
    CONTRAST_PATTERN_07 = 0x00000006, CONTRAST_PATTERN_08 = 0x00000007,
    CONTRAST_PATTERN_09 = 0x00000008, CONTRAST_PATTERN_10 = 0x00000009, CONTRAST_PATTERN_11 = 0x0000000A #
                                                                                                # Contrast
                                                                                                # aliases.

const
  CONTRAST_LOW = CONTRAST_PATTERN_05
  CONTRAST_NORMAL = CONTRAST_PATTERN_06
  CONTRAST_HIGH = CONTRAST_PATTERN_07

#*
#  @brief Camera lens correction modes.
#

type
  CAMU_LensCorrection* {.size: sizeof(cint).} = enum
    LENS_CORRECTION_OFF = 0x00000000, LENS_CORRECTION_ON_70 = 0x00000001, LENS_CORRECTION_ON_90 = 0x00000002 #
                                                                                                    # Lens
                                                                                                    # correction
                                                                                                    # aliases.

const
  LENS_CORRECTION_DARK = LENS_CORRECTION_OFF
  LENS_CORRECTION_NORMAL = LENS_CORRECTION_ON_70
  LENS_CORRECTION_BRIGHT = LENS_CORRECTION_ON_90

#*
#  @brief Camera image output formats.
#

type
  CAMU_OutputFormat* {.size: sizeof(cint).} = enum
    OUTPUT_YUV_422 = 0x00000000, OUTPUT_RGB_565 = 0x00000001


#*
#  @brief Camera shutter sounds.
#

type
  CAMU_ShutterSoundType* {.size: sizeof(cint).} = enum
    SHUTTER_SOUND_TYPE_NORMAL = 0x00000000, SHUTTER_SOUND_TYPE_MOVIE = 0x00000001,
    SHUTTER_SOUND_TYPE_MOVIE_END = 0x00000002


#*
#  @brief Image quality calibration data.
#

type
  CAMU_ImageQualityCalibrationData* {.importc: "CAMU_ImageQualityCalibrationData",
                                     header: "cam.h".} = object
    aeBaseTarget* {.importc: "aeBaseTarget".}: s16 #/< Auto exposure base target brightness.
    kRL* {.importc: "kRL".}: s16 #/< Left color correction matrix red normalization coefficient.
    kGL* {.importc: "kGL".}: s16 #/< Left color correction matrix green normalization coefficient.
    kBL* {.importc: "kBL".}: s16 #/< Left color correction matrix blue normalization coefficient.
    ccmPosition* {.importc: "ccmPosition".}: s16 #/< Color correction matrix position.
    awbCcmL9Right* {.importc: "awbCcmL9Right".}: u16 #/< Right camera, left color correction matrix red/green gain.
    awbCcmL9Left* {.importc: "awbCcmL9Left".}: u16 #/< Left camera, left color correction matrix red/green gain.
    awbCcmL10Right* {.importc: "awbCcmL10Right".}: u16 #/< Right camera, left color correction matrix blue/green gain.
    awbCcmL10Left* {.importc: "awbCcmL10Left".}: u16 #/< Left camera, left color correction matrix blue/green gain.
    awbX0Right* {.importc: "awbX0Right".}: u16 #/< Right camera, color correction matrix position threshold.
    awbX0Left* {.importc: "awbX0Left".}: u16 #/< Left camera, color correction matrix position threshold.


#*
#  @brief Stereo camera calibration data.
#

type
  CAMU_StereoCameraCalibrationData* {.importc: "CAMU_StereoCameraCalibrationData",
                                     header: "cam.h".} = object
    isValidRotationXY* {.importc: "isValidRotationXY".}: u8 #/< #bool Whether the X and Y rotation data is valid.
    padding* {.importc: "padding".}: array[3, u8] #/< Padding. (Aligns isValidRotationXY to 4 bytes)
    scale* {.importc: "scale".}: cfloat #/< Scale to match the left camera image with the right.
    rotationZ* {.importc: "rotationZ".}: cfloat #/< Z axis rotation to match the left camera image with the right.
    translationX* {.importc: "translationX".}: cfloat #/< X axis translation to match the left camera image with the right.
    translationY* {.importc: "translationY".}: cfloat #/< Y axis translation to match the left camera image with the right.
    rotationX* {.importc: "rotationX".}: cfloat #/< X axis rotation to match the left camera image with the right.
    rotationY* {.importc: "rotationY".}: cfloat #/< Y axis rotation to match the left camera image with the right.
    angleOfViewRight* {.importc: "angleOfViewRight".}: cfloat #/< Right camera angle of view.
    angleOfViewLeft* {.importc: "angleOfViewLeft".}: cfloat #/< Left camera angle of view.
    distanceToChart* {.importc: "distanceToChart".}: cfloat #/< Distance between cameras and measurement chart.
    distanceCameras* {.importc: "distanceCameras".}: cfloat #/< Distance between left and right cameras.
    imageWidth* {.importc: "imageWidth".}: s16 #/< Image width.
    imageHeight* {.importc: "imageHeight".}: s16 #/< Image height.
    reserved* {.importc: "reserved".}: array[16, u8] #/< Reserved for future use. (unused)


#*
#  @brief Batch camera configuration for use without a context.
#

type
  CAMU_PackageParameterCameraSelect* {.importc: "CAMU_PackageParameterCameraSelect",
                                      header: "cam.h".} = object
    camera* {.importc: "camera".}: u8 #/< #CAMU_CameraSelect Selected camera.
    exposure* {.importc: "exposure".}: s8 #/< Camera exposure.
    whiteBalance* {.importc: "whiteBalance".}: u8 #/< #CAMU_WhiteBalance Camera white balance.
    sharpness* {.importc: "sharpness".}: s8 #/< Camera sharpness.
    autoExposureOn* {.importc: "autoExposureOn".}: u8 #/< #bool Whether to automatically determine the proper exposure.
    autoWhiteBalanceOn* {.importc: "autoWhiteBalanceOn".}: u8 #/< #bool Whether to automatically determine the white balance mode.
    frameRate* {.importc: "frameRate".}: u8 #/< #CAMU_FrameRate Camera frame rate.
    photoMode* {.importc: "photoMode".}: u8 #/< #CAMU_PhotoMode Camera photo mode.
    contrast* {.importc: "contrast".}: u8 #/< #CAMU_Contrast Camera contrast.
    lensCorrection* {.importc: "lensCorrection".}: u8 #/< #CAMU_LensCorrection Camera lens correction.
    noiseFilterOn* {.importc: "noiseFilterOn".}: u8 #/< #bool Whether to enable the camera's noise filter.
    padding* {.importc: "padding".}: u8 #/< Padding. (Aligns last 3 fields to 4 bytes)
    autoExposureWindowX* {.importc: "autoExposureWindowX".}: s16 #/< X of the region to use for auto exposure.
    autoExposureWindowY* {.importc: "autoExposureWindowY".}: s16 #/< Y of the region to use for auto exposure.
    autoExposureWindowWidth* {.importc: "autoExposureWindowWidth".}: s16 #/< Width of the region to use for auto exposure.
    autoExposureWindowHeight* {.importc: "autoExposureWindowHeight".}: s16 #/< Height of the region to use for auto exposure.
    autoWhiteBalanceWindowX* {.importc: "autoWhiteBalanceWindowX".}: s16 #/< X of the region to use for auto white balance.
    autoWhiteBalanceWindowY* {.importc: "autoWhiteBalanceWindowY".}: s16 #/< Y of the region to use for auto white balance.
    autoWhiteBalanceWindowWidth* {.importc: "autoWhiteBalanceWindowWidth".}: s16 #/< Width of the region to use for auto white balance.
    autoWhiteBalanceWindowHeight* {.importc: "autoWhiteBalanceWindowHeight".}: s16 #/< Height of the region to use for auto white balance.


#*
#  @brief Batch camera configuration for use with a context.
#

type
  CAMU_PackageParameterContext* {.importc: "CAMU_PackageParameterContext",
                                 header: "cam.h".} = object
    camera* {.importc: "camera".}: u8 #/< #CAMU_CameraSelect Selected camera.
    context* {.importc: "context".}: u8 #/< #CAMU_Context Selected context.
    flip* {.importc: "flip".}: u8 #/< #CAMU_Flip Camera image flip mode.
    effect* {.importc: "effect".}: u8 #/< #CAMU_Effect Camera image special effects.
    size* {.importc: "size".}: u8 #/< #CAMU_Size Camera image resolution.


#*
#  @brief Batch camera configuration for use with a context and with detailed size information.
#

type
  CAMU_PackageParameterContextDetail* {.importc: "CAMU_PackageParameterContextDetail",
                                       header: "cam.h".} = object
    camera* {.importc: "camera".}: u8 #/< #CAMU_CameraSelect Selected camera.
    context* {.importc: "context".}: u8 #/< #CAMU_Context Selected context.
    flip* {.importc: "flip".}: u8 #/< #CAMU_Flip Camera image flip mode.
    effect* {.importc: "effect".}: u8 #/< #CAMU_Effect Camera image special effects.
    width* {.importc: "width".}: s16 #/< Image width.
    height* {.importc: "height".}: s16 #/< Image height.
    cropX0* {.importc: "cropX0".}: s16 #/< First crop point X.
    cropY0* {.importc: "cropY0".}: s16 #/< First crop point Y.
    cropX1* {.importc: "cropX1".}: s16 #/< Second crop point X.
    cropY1* {.importc: "cropY1".}: s16 #/< Second crop point Y.


#*
#  @brief Initializes the cam service.
#
#  This will internally get the handle of the service, and on success call CAMU_DriverInitialize.
#

proc camInit*(): Result {.cdecl, importc: "camInit", header: "cam.h".}
#*
#  @brief Closes the cam service.
#
#  This will internally call CAMU_DriverFinalize and close the handle of the service.
#

proc camExit*(): Result {.cdecl, importc: "camExit", header: "cam.h".}
#/ Begins capture on the specified camera port.

proc CAMU_StartCapture*(port: CAMU_Port): Result {.cdecl,
    importc: "CAMU_StartCapture", header: "cam.h".}
#/Terminates capture on the specified camera port.

proc CAMU_StopCapture*(port: CAMU_Port): Result {.cdecl, importc: "CAMU_StopCapture",
    header: "cam.h".}
#*
#  @brief Gets whether the specified camera port is busy.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_IsBusy*(busy: ptr bool; port: CAMU_Port): Result {.cdecl,
    importc: "CAMU_IsBusy", header: "cam.h".}
#/Clears the buffer and error flags of the specified camera port.

proc CAMU_ClearBuffer*(port: CAMU_Port): Result {.cdecl, importc: "CAMU_ClearBuffer",
    header: "cam.h".}
#*
#  @brief Gets a handle to the event signaled on vsync interrupts.
#
#  Writes the event handle to the provided output pointer.
#

proc CAMU_GetVsyncInterruptEvent*(event: ptr Handle; port: CAMU_Port): Result {.cdecl,
    importc: "CAMU_GetVsyncInterruptEvent", header: "cam.h".}
#*
#  @brief Gets a handle to the event signaled on camera buffer errors.
#
#  Writes the event handle to the provided output pointer.
#

proc CAMU_GetBufferErrorInterruptEvent*(event: ptr Handle; port: CAMU_Port): Result {.
    cdecl, importc: "CAMU_GetBufferErrorInterruptEvent", header: "cam.h".}
#*
#  @brief Initiates the process of receiving a camera frame.
#
#  Writes a completion event handle to the provided pointer and writes image data to the provided buffer.
#

proc CAMU_SetReceiving*(event: ptr Handle; dst: pointer; port: CAMU_Port;
                       imageSize: u32; transferUnit: s16): Result {.cdecl,
    importc: "CAMU_SetReceiving", header: "cam.h".}
#*
#  @brief Gets whether the specified camera port has finished receiving image data.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_IsFinishedReceiving*(finishedReceiving: ptr bool; port: CAMU_Port): Result {.
    cdecl, importc: "CAMU_IsFinishedReceiving", header: "cam.h".}
#/Sets the number of lines to transfer into an image buffer.

proc CAMU_SetTransferLines*(port: CAMU_Port; lines: s16; width: s16; height: s16): Result {.
    cdecl, importc: "CAMU_SetTransferLines", header: "cam.h".}
#*
#  @brief Gets the maximum number of lines that can be saved to an image buffer.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetMaxLines*(maxLines: ptr s16; width: s16; height: s16): Result {.cdecl,
    importc: "CAMU_GetMaxLines", header: "cam.h".}
#/Sets the number of bytes to transfer into an image buffer.

proc CAMU_SetTransferBytes*(port: CAMU_Port; bytes: u32; width: s16; height: s16): Result {.
    cdecl, importc: "CAMU_SetTransferBytes", header: "cam.h".}
#*
#  @brief Gets the number of bytes to transfer into an image buffer.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetTransferBytes*(transferBytes: ptr u32; port: CAMU_Port): Result {.cdecl,
    importc: "CAMU_GetTransferBytes", header: "cam.h".}
#*
#  @brief Gets the maximum number of bytes that can be saved to an image buffer.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetMaxBytes*(maxBytes: ptr u32; width: s16; height: s16): Result {.cdecl,
    importc: "CAMU_GetMaxBytes", header: "cam.h".}
#/Sets whether image trimming is enabled.

proc CAMU_SetTrimming*(port: CAMU_Port; trimming: bool): Result {.cdecl,
    importc: "CAMU_SetTrimming", header: "cam.h".}
#*
#  @brief Gets whether image trimming is enabled.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_IsTrimming*(trimming: ptr bool; port: CAMU_Port): Result {.cdecl,
    importc: "CAMU_IsTrimming", header: "cam.h".}
#/Sets the parameters used for trimming images.

proc CAMU_SetTrimmingParams*(port: CAMU_Port; xStart: s16; yStart: s16; xEnd: s16;
                            yEnd: s16): Result {.cdecl,
    importc: "CAMU_SetTrimmingParams", header: "cam.h".}
#*
#  @brief Gets the parameters used for trimming images.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetTrimmingParams*(xStart: ptr s16; yStart: ptr s16; xEnd: ptr s16;
                            yEnd: ptr s16; port: CAMU_Port): Result {.cdecl,
    importc: "CAMU_GetTrimmingParams", header: "cam.h".}
#/Sets the parameters used for trimming images, relative to the center of the image.

proc CAMU_SetTrimmingParamsCenter*(port: CAMU_Port; trimWidth: s16; trimHeight: s16;
                                  camWidth: s16; camHeight: s16): Result {.cdecl,
    importc: "CAMU_SetTrimmingParamsCenter", header: "cam.h".}
#/Activates the specified camera.

proc CAMU_Activate*(select: CAMU_CameraSelect): Result {.cdecl,
    importc: "CAMU_Activate", header: "cam.h".}
#/Switches the specified camera's active context.

proc CAMU_SwitchContext*(select: CAMU_CameraSelect; context: CAMU_Context): Result {.
    cdecl, importc: "CAMU_SwitchContext", header: "cam.h".}
#/Sets the exposure value of the specified camera.

proc CAMU_SetExposure*(select: CAMU_CameraSelect; exposure: s8): Result {.cdecl,
    importc: "CAMU_SetExposure", header: "cam.h".}
#/Sets the white balance mode of the specified camera.

proc CAMU_SetWhiteBalance*(select: CAMU_CameraSelect;
                          whiteBalance: CAMU_WhiteBalance): Result {.cdecl,
    importc: "CAMU_SetWhiteBalance", header: "cam.h".}
#*
#  @brief Sets the white balance mode of the specified camera.
#
#  TODO: Explain "without base up"?
#

proc CAMU_SetWhiteBalanceWithoutBaseUp*(select: CAMU_CameraSelect;
                                       whiteBalance: CAMU_WhiteBalance): Result {.
    cdecl, importc: "CAMU_SetWhiteBalanceWithoutBaseUp", header: "cam.h".}
#/Sets the sharpness of the specified camera.

proc CAMU_SetSharpness*(select: CAMU_CameraSelect; sharpness: s8): Result {.cdecl,
    importc: "CAMU_SetSharpness", header: "cam.h".}
#/Sets whether auto exposure is enabled on the specified camera.

proc CAMU_SetAutoExposure*(select: CAMU_CameraSelect; autoExposure: bool): Result {.
    cdecl, importc: "CAMU_SetAutoExposure", header: "cam.h".}
#*
#  @brief Gets whether auto exposure is enabled on the specified camera.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_IsAutoExposure*(autoExposure: ptr bool; select: CAMU_CameraSelect): Result {.
    cdecl, importc: "CAMU_IsAutoExposure", header: "cam.h".}
#/Sets whether auto white balance is enabled on the specified camera.

proc CAMU_SetAutoWhiteBalance*(select: CAMU_CameraSelect; autoWhiteBalance: bool): Result {.
    cdecl, importc: "CAMU_SetAutoWhiteBalance", header: "cam.h".}
#*
#  @brief Gets whether auto white balance is enabled on the specified camera.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_IsAutoWhiteBalance*(autoWhiteBalance: ptr bool; select: CAMU_CameraSelect): Result {.
    cdecl, importc: "CAMU_IsAutoWhiteBalance", header: "cam.h".}
#/Flips the image of the specified camera in the specified context.

proc CAMU_FlipImage*(select: CAMU_CameraSelect; flip: CAMU_Flip;
                    context: CAMU_Context): Result {.cdecl,
    importc: "CAMU_FlipImage", header: "cam.h".}
#/Sets the image resolution of the given camera in the given context, in detail.

proc CAMU_SetDetailSize*(select: CAMU_CameraSelect; width: s16; height: s16;
                        cropX0: s16; cropY0: s16; cropX1: s16; cropY1: s16;
                        context: CAMU_Context): Result {.cdecl,
    importc: "CAMU_SetDetailSize", header: "cam.h".}
#/Sets the image resolution of the given camera in the given context.

proc CAMU_SetSize*(select: CAMU_CameraSelect; size: CAMU_Size; context: CAMU_Context): Result {.
    cdecl, importc: "CAMU_SetSize", header: "cam.h".}
#/Sets the frame rate of the given camera.

proc CAMU_SetFrameRate*(select: CAMU_CameraSelect; frameRate: CAMU_FrameRate): Result {.
    cdecl, importc: "CAMU_SetFrameRate", header: "cam.h".}
#/Sets the photo mode of the given camera.

proc CAMU_SetPhotoMode*(select: CAMU_CameraSelect; photoMode: CAMU_PhotoMode): Result {.
    cdecl, importc: "CAMU_SetPhotoMode", header: "cam.h".}
#/Sets the special effects of the given camera in the given context.

proc CAMU_SetEffect*(select: CAMU_CameraSelect; effect: CAMU_Effect;
                    context: CAMU_Context): Result {.cdecl,
    importc: "CAMU_SetEffect", header: "cam.h".}
#/Sets the contrast mode of the given camera.

proc CAMU_SetContrast*(select: CAMU_CameraSelect; contrast: CAMU_Contrast): Result {.
    cdecl, importc: "CAMU_SetContrast", header: "cam.h".}
#/Sets the lens correction mode of the given camera.

proc CAMU_SetLensCorrection*(select: CAMU_CameraSelect;
                            lensCorrection: CAMU_LensCorrection): Result {.cdecl,
    importc: "CAMU_SetLensCorrection", header: "cam.h".}
#/Sets the output format of the given camera in the given context.

proc CAMU_SetOutputFormat*(select: CAMU_CameraSelect; format: CAMU_OutputFormat;
                          context: CAMU_Context): Result {.cdecl,
    importc: "CAMU_SetOutputFormat", header: "cam.h".}
#/Sets the region to base auto exposure off of for the specified camera.

proc CAMU_SetAutoExposureWindow*(select: CAMU_CameraSelect; x: s16; y: s16; width: s16;
                                height: s16): Result {.cdecl,
    importc: "CAMU_SetAutoExposureWindow", header: "cam.h".}
#/Sets the region to base auto white balance off of for the specified camera.

proc CAMU_SetAutoWhiteBalanceWindow*(select: CAMU_CameraSelect; x: s16; y: s16;
                                    width: s16; height: s16): Result {.cdecl,
    importc: "CAMU_SetAutoWhiteBalanceWindow", header: "cam.h".}
#/Sets whether the specified camera's noise filter is enabled.

proc CAMU_SetNoiseFilter*(select: CAMU_CameraSelect; noiseFilter: bool): Result {.
    cdecl, importc: "CAMU_SetNoiseFilter", header: "cam.h".}
#/Synchronizes the specified cameras' vsync timing.

proc CAMU_SynchronizeVsyncTiming*(select1: CAMU_CameraSelect;
                                 select2: CAMU_CameraSelect): Result {.cdecl,
    importc: "CAMU_SynchronizeVsyncTiming", header: "cam.h".}
#*
#  @brief Gets the vsync timing record of the specified camera for the specified number of signals.
#
#  Writes the result to the provided output pointer, which should be of size "past * sizeof(s64)".
#

proc CAMU_GetLatestVsyncTiming*(timing: ptr s64; port: CAMU_Port; past: u32): Result {.
    cdecl, importc: "CAMU_GetLatestVsyncTiming", header: "cam.h".}
#*
#  @brief Gets the specified camera's stereo camera calibration data.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetStereoCameraCalibrationData*(
    data: ptr CAMU_StereoCameraCalibrationData): Result {.cdecl,
    importc: "CAMU_GetStereoCameraCalibrationData", header: "cam.h".}
#/Sets the specified camera's stereo camera calibration data.

proc CAMU_SetStereoCameraCalibrationData*(data: CAMU_StereoCameraCalibrationData): Result {.
    cdecl, importc: "CAMU_SetStereoCameraCalibrationData", header: "cam.h".}
#*
#  @brief Writes to the specified I2C register of the specified camera.
#
#  Use with caution.
#

proc CAMU_WriteRegisterI2c*(select: CAMU_CameraSelect; `addr`: u16; data: u16): Result {.
    cdecl, importc: "CAMU_WriteRegisterI2c", header: "cam.h".}
#*
#  @brief Writes to the specified MCU variable of the specified camera.
#
#  Use with caution.
#

proc CAMU_WriteMcuVariableI2c*(select: CAMU_CameraSelect; `addr`: u16; data: u16): Result {.
    cdecl, importc: "CAMU_WriteMcuVariableI2c", header: "cam.h".}
#*
#  @brief Reads the specified I2C register of the specified camera.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_ReadRegisterI2cExclusive*(data: ptr u16; select: CAMU_CameraSelect;
                                   `addr`: u16): Result {.cdecl,
    importc: "CAMU_ReadRegisterI2cExclusive", header: "cam.h".}
#*
#  @brief Reads the specified MCU variable of the specified camera.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_ReadMcuVariableI2cExclusive*(data: ptr u16; select: CAMU_CameraSelect;
                                      `addr`: u16): Result {.cdecl,
    importc: "CAMU_ReadMcuVariableI2cExclusive", header: "cam.h".}
#*
#  @brief Sets the specified camera's image quality calibration data.
#

proc CAMU_SetImageQualityCalibrationData*(data: CAMU_ImageQualityCalibrationData): Result {.
    cdecl, importc: "CAMU_SetImageQualityCalibrationData", header: "cam.h".}
#*
#  @brief Gets the specified camera's image quality calibration data.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetImageQualityCalibrationData*(
    data: ptr CAMU_ImageQualityCalibrationData): Result {.cdecl,
    importc: "CAMU_GetImageQualityCalibrationData", header: "cam.h".}
#/Configures a camera with pre-packaged configuration data without a context.

proc CAMU_SetPackageParameterWithoutContext*(
    param: CAMU_PackageParameterCameraSelect): Result {.cdecl,
    importc: "CAMU_SetPackageParameterWithoutContext", header: "cam.h".}
#/Configures a camera with pre-packaged configuration data with a context.

proc CAMU_SetPackageParameterWithContext*(param: CAMU_PackageParameterContext): Result {.
    cdecl, importc: "CAMU_SetPackageParameterWithContext", header: "cam.h".}
#/Configures a camera with pre-packaged configuration data without a context and extra resolution details.

proc CAMU_SetPackageParameterWithContextDetail*(
    param: CAMU_PackageParameterContextDetail): Result {.cdecl,
    importc: "CAMU_SetPackageParameterWithContextDetail", header: "cam.h".}
#/Gets the Y2R coefficient applied to image data by the camera.

proc CAMU_GetSuitableY2rStandardCoefficient*(
    coefficient: ptr Y2R_StandardCoefficient): Result {.cdecl,
    importc: "CAMU_GetSuitableY2rStandardCoefficient", header: "cam.h".}
#/Plays the specified shutter sound.

proc CAMU_PlayShutterSound*(sound: CAMU_ShutterSoundType): Result {.cdecl,
    importc: "CAMU_PlayShutterSound", header: "cam.h".}
#/Initializes the camera driver.

proc CAMU_DriverInitialize*(): Result {.cdecl, importc: "CAMU_DriverInitialize",
                                     header: "cam.h".}
#/Finalizes the camera driver.

proc CAMU_DriverFinalize*(): Result {.cdecl, importc: "CAMU_DriverFinalize",
                                   header: "cam.h".}
#*
#  @brief Gets the current activated camera.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetActivatedCamera*(select: ptr CAMU_CameraSelect): Result {.cdecl,
    importc: "CAMU_GetActivatedCamera", header: "cam.h".}
#*
#  @brief Gets the current sleep camera.
#
#  Writes the result to the provided output pointer.
#

proc CAMU_GetSleepCamera*(select: ptr CAMU_CameraSelect): Result {.cdecl,
    importc: "CAMU_GetSleepCamera", header: "cam.h".}
#/Sets the current sleep camera.

proc CAMU_SetSleepCamera*(select: CAMU_CameraSelect): Result {.cdecl,
    importc: "CAMU_SetSleepCamera", header: "cam.h".}
#/Sets whether to enable synchronization of left and right camera brightnesses.

proc CAMU_SetBrightnessSynchronization*(brightnessSynchronization: bool): Result {.
    cdecl, importc: "CAMU_SetBrightnessSynchronization", header: "cam.h".}
