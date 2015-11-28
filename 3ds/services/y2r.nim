#*
#  @file y2r.h
#  @brief Y2R service for hardware YUV->RGB conversions
#

#*
#  @brief Input color formats
#
#  For the 16-bit per component formats, bits 15-8 are padding and 7-0 contains the value.
#

type
  Y2R_InputFormat* {.size: sizeof(cint).} = enum
    INPUT_YUV422_INDIV_8 = 0x00000000, #/<  8-bit per component, planar YUV 4:2:2, 16bpp, (1 Cr & Cb sample per 2x1 Y samples).\n Usually named YUV422P.
    INPUT_YUV420_INDIV_8 = 0x00000001, #/<  8-bit per component, planar YUV 4:2:0, 12bpp, (1 Cr & Cb sample per 2x2 Y samples).\n Usually named YUV420P.
    INPUT_YUV422_INDIV_16 = 0x00000002, #/< 16-bit per component, planar YUV 4:2:2, 32bpp, (1 Cr & Cb sample per 2x1 Y samples).\n Usually named YUV422P16.
    INPUT_YUV420_INDIV_16 = 0x00000003, #/< 16-bit per component, planar YUV 4:2:0, 24bpp, (1 Cr & Cb sample per 2x2 Y samples).\n Usually named YUV420P16.
    INPUT_YUV422_BATCH = 0x00000004 #/<  8-bit per component, packed YUV 4:2:2, 16bpp, (Y0 Cb Y1 Cr).\n Usually named YUYV422.


#*
#  @brief Output color formats
#
#  Those are the same as the framebuffer and GPU texture formats.
#

type
  Y2R_OutputFormat* {.size: sizeof(cint).} = enum
    OUTPUT_RGB_32 = 0x00000000, #/< The alpha component is the 8-bit value set by @ref Y2RU_SetAlpha
    OUTPUT_RGB_24 = 0x00000001, OUTPUT_RGB_16_555 = 0x00000002, #/< The alpha bit is the 7th bit of the alpha value set by @ref Y2RU_SetAlpha
    OUTPUT_RGB_16_565 = 0x00000003


#*
#  @brief Rotation to be applied to the output
#

type
  Y2R_Rotation* {.size: sizeof(cint).} = enum
    ROTATION_NONE = 0x00000000, ROTATION_CLOCKWISE_90 = 0x00000001,
    ROTATION_CLOCKWISE_180 = 0x00000002, ROTATION_CLOCKWISE_270 = 0x00000003


#*
#  @brief Block alignment of output
#
#  Defines the way the output will be laid out in memory.
#

type
  Y2R_BlockAlignment* {.size: sizeof(cint).} = enum
    BLOCK_LINE = 0x00000000,    #/< The result buffer will be laid out in linear format, the usual way.
    BLOCK_8_BY_8 = 0x00000001   #/< The result will be stored as 8x8 blocks in Z-order.\n Useful for textures since it is the format used by the PICA200.


#*
#  @brief Coefficients of the YUV->RGB conversion formula.
#
#  A set of coefficients configuring the RGB to YUV conversion. Coefficients 0-4 are unsigned 2.8
#  fixed pointer numbers representing entries on the conversion matrix, while coefficient 5-7 are
#  signed 11.5 fixed point numbers added as offsets to the RGB result.
#
#  The overall conversion process formula is:
#  @code
#  R = trunc((rgb_Y * Y           + r_V * V) + 0.75 + r_offset)
#  G = trunc((rgb_Y * Y - g_U * U - g_V * V) + 0.75 + g_offset)
#  B = trunc((rgb_Y * Y + b_U * U          ) + 0.75 + b_offset)
#  @endcode
#

type
  Y2R_ColorCoefficients* {.importc: "Y2R_ColorCoefficients", header: "y2r.h".} = object
    rgb_Y* {.importc: "rgb_Y".}: u16
    r_V* {.importc: "r_V".}: u16
    g_V* {.importc: "g_V".}: u16
    g_U* {.importc: "g_U".}: u16
    b_U* {.importc: "b_U".}: u16
    r_offset* {.importc: "r_offset".}: u16
    g_offset* {.importc: "g_offset".}: u16
    b_offset* {.importc: "b_offset".}: u16


#*
#  @brief Preset conversion coefficients based on ITU standards for the YUV->RGB formula.
#
#  For more details refer to @ref Y2R_ColorCoefficients
#

type
  Y2R_StandardCoefficient* {.size: sizeof(cint).} = enum
    COEFFICIENT_ITU_R_BT_601 = 0x00000000, #/< Coefficients from the ITU-R BT.601 standard with PC ranges.
    COEFFICIENT_ITU_R_BT_709 = 0x00000001, #/< Coefficients from the ITU-R BT.709 standard with PC ranges.
    COEFFICIENT_ITU_R_BT_601_SCALING = 0x00000002, #/< Coefficients from the ITU-R BT.601 standard with TV ranges.
    COEFFICIENT_ITU_R_BT_709_SCALING = 0x00000003 #/< Coefficients from the ITU-R BT.709 standard with TV ranges.


#*
#  @brief Structure used to configure all parameters at once.
#
#  You can send a batch of configuration parameters using this structure and @ref Y2RU_SetConversionParams.
#
#

type
  Y2R_ConversionParams* {.importc: "Y2R_ConversionParams", header: "y2r.h".} = object
    input_format* {.importc: "input_format",bitsize: 8.}: Y2R_InputFormat #/< Value passed to @ref Y2RU_SetInputFormat
    output_format* {.importc: "output_format",bitsize: 8.}: Y2R_OutputFormat #/< Value passed to @ref Y2RU_SetOutputFormat
    rotation* {.importc: "rotation",bitsize: 8.}: Y2R_Rotation #/< Value passed to @ref Y2RU_SetRotation
    block_alignment* {.importc: "block_alignment",bitsize: 8.}: Y2R_BlockAlignment #/< Value passed to @ref Y2RU_SetBlockAlignment
    input_line_width* {.importc: "input_line_width".}: s16 #/< Value passed to @ref Y2RU_SetInputLineWidth
    input_lines* {.importc: "input_lines".}: s16 #/< Value passed to @ref Y2RU_SetInputLines
    standard_coefficient* {.importc: "standard_coefficient",bitsize: 8.}: Y2R_StandardCoefficient #/< Value passed to @ref Y2RU_SetStandardCoefficient
    unused* {.importc: "unused".}: u8
    alpha* {.importc: "alpha".}: u16 #/< Value passed to @ref Y2RU_SetAlpha


#*
#  @brief Initializes the y2r service.
#
#  This will internally get the handle of the service, and on success call Y2RU_DriverInitialize.
#

proc y2rInit*(): Result {.cdecl, importc: "y2rInit", header: "y2r.h".}
#*
#  @brief Closes the y2r service.
#
#  This will internally call Y2RU_DriverFinalize and close the handle of the service.
#

proc y2rExit*(): Result {.cdecl, importc: "y2rExit", header: "y2r.h".}
#*
#  @brief Used to configure the input format.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetInputFormat*(format: Y2R_InputFormat): Result {.cdecl,
    importc: "Y2RU_SetInputFormat", header: "y2r.h".}
#*
#  @brief Used to configure the output format.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetOutputFormat*(format: Y2R_OutputFormat): Result {.cdecl,
    importc: "Y2RU_SetOutputFormat", header: "y2r.h".}
#*
#  @brief Used to configure the rotation of the output.
#
#  It seems to apply the rotation per batch of 8 lines, so the output will be (height/8) images of size 8 x width.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetRotation*(rotation: Y2R_Rotation): Result {.cdecl,
    importc: "Y2RU_SetRotation", header: "y2r.h".}
#*
#  @brief Used to configure the alignment of the output buffer.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetBlockAlignment*(alignment: Y2R_BlockAlignment): Result {.cdecl,
    importc: "Y2RU_SetBlockAlignment", header: "y2r.h".}
#*
#  @brief Used to configure the width of the image.
#  @param line_width Width of the image in pixels. Must be a multiple of 8, up to 1024.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetInputLineWidth*(line_width: u16): Result {.cdecl,
    importc: "Y2RU_SetInputLineWidth", header: "y2r.h".}
#*
#  @brief Used to configure the height of the image.
#  @param num_lines Number of lines to be converted.
#
#  A multiple of 8 seems to be preferred.
#  If using the @ref BLOCK_8_BY_8 mode, it must be a multiple of 8.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetInputLines*(num_lines: u16): Result {.cdecl,
    importc: "Y2RU_SetInputLines", header: "y2r.h".}
#*
#  @brief Used to configure the color conversion formula.
#
#  See @ref Y2R_ColorCoefficients for more information about the coefficients.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetCoefficients*(coefficients: ptr Y2R_ColorCoefficients): Result {.cdecl,
    importc: "Y2RU_SetCoefficients", header: "y2r.h".}
#*
#  @brief Used to configure the color conversion formula with ITU stantards coefficients.
#
#  See @ref Y2R_ColorCoefficients for more information about the coefficients.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetStandardCoefficient*(coefficient: Y2R_StandardCoefficient): Result {.
    cdecl, importc: "Y2RU_SetStandardCoefficient", header: "y2r.h".}
#*
#  @brief Used to configure the alpha value of the output.
#  @param alpha 8-bit value to be used for the output when the format requires it.
#
#  @note Prefer using @ref Y2RU_SetConversionParams if you have to set multiple parameters.
#

proc Y2RU_SetAlpha*(alpha: u16): Result {.cdecl, importc: "Y2RU_SetAlpha",
                                      header: "y2r.h".}
#*
#  @brief Used to enable the end of conversion interrupt.
#  @param should_interrupt Enables the interrupt if true, disable it if false.
#
#  It is possible to fire an interrupt when the conversion is finished, and that the DMA is done copying the data.
#  This interrupt will then be used to fire an event. See @ref Y2RU_GetTransferEndEvent.
#  By default the interrupt is enabled.
#
#  @note It seems that the event can be fired too soon in some cases, depending the transfer_unit size.\n Please see the note at @ref Y2RU_SetReceiving
#

proc Y2RU_SetTransferEndInterrupt*(should_interrupt: bool): Result {.cdecl,
    importc: "Y2RU_SetTransferEndInterrupt", header: "y2r.h".}
#*
#  @brief Gets an handle to the end of conversion event.
#  @param end_event Pointer to the event handle to be set to the end of conversion event. It isn't necessary to create or close this handle.
#
#  To enable this event you have to use @code{C} Y2RU_SetTransferEndInterrupt(true);@endcode
#  The event will be triggered when the corresponding interrupt is fired.
#
#  @note It is recommended to use a timeout when waiting on this event, as it sometimes (but rarely) isn't triggered.
#

proc Y2RU_GetTransferEndEvent*(end_event: ptr Handle): Result {.cdecl,
    importc: "Y2RU_GetTransferEndEvent", header: "y2r.h".}
#*
#  @brief Configures the Y plane buffer.
#  @param src_buf A pointer to the beginning of your Y data buffer.
#  @param image_size The total size of the data buffer.
#  @param transfer_unit Specifies the size of 1 DMA transfer. Usually set to 1 line. This has to be a divisor of image_size.
#  @param transfer_gap Specifies the gap (offset) to be added after each transfer. Can be used to convert images with stride or only a part of it.
#
#  @warning transfer_unit+transfer_gap must be less than 32768 (0x8000)
#
#  This specifies the Y data buffer for the planar input formats (INPUT_YUV42*_INDIV_*).
#  The actual transfer will only happen after calling @ref Y2RU_StartConversion.
#

proc Y2RU_SetSendingY*(src_buf: pointer; image_size: u32; transfer_unit: s16;
                      transfer_gap: s16): Result {.cdecl,
    importc: "Y2RU_SetSendingY", header: "y2r.h".}
#*
#  @brief Configures the U plane buffer.
#  @param src_buf A pointer to the beginning of your Y data buffer.
#  @param image_size The total size of the data buffer.
#  @param transfer_unit Specifies the size of 1 DMA transfer. Usually set to 1 line. This has to be a divisor of image_size.
#  @param transfer_gap Specifies the gap (offset) to be added after each transfer. Can be used to convert images with stride or only a part of it.
#
#  @warning transfer_unit+transfer_gap must be less than 32768 (0x8000)
#
#  This specifies the U data buffer for the planar input formats (INPUT_YUV42*_INDIV_*).
#  The actual transfer will only happen after calling @ref Y2RU_StartConversion.
#

proc Y2RU_SetSendingU*(src_buf: pointer; image_size: u32; transfer_unit: s16;
                      transfer_gap: s16): Result {.cdecl,
    importc: "Y2RU_SetSendingU", header: "y2r.h".}
#*
#  @brief Configures the V plane buffer.
#  @param src_buf A pointer to the beginning of your Y data buffer.
#  @param image_size The total size of the data buffer.
#  @param transfer_unit Specifies the size of 1 DMA transfer. Usually set to 1 line. This has to be a divisor of image_size.
#  @param transfer_gap Specifies the gap (offset) to be added after each transfer. Can be used to convert images with stride or only a part of it.
#
#  @warning transfer_unit+transfer_gap must be less than 32768 (0x8000)
#
#  This specifies the V data buffer for the planar input formats (INPUT_YUV42*_INDIV_*).
#  The actual transfer will only happen after calling @ref Y2RU_StartConversion.
#

proc Y2RU_SetSendingV*(src_buf: pointer; image_size: u32; transfer_unit: s16;
                      transfer_gap: s16): Result {.cdecl,
    importc: "Y2RU_SetSendingV", header: "y2r.h".}
#*
#  @brief Configures the YUYV source buffer.
#  @param src_buf A pointer to the beginning of your Y data buffer.
#  @param image_size The total size of the data buffer.
#  @param transfer_unit Specifies the size of 1 DMA transfer. Usually set to 1 line. This has to be a divisor of image_size.
#  @param transfer_gap Specifies the gap (offset) to be added after each transfer. Can be used to convert images with stride or only a part of it.
#
#  @warning transfer_unit+transfer_gap must be less than 32768 (0x8000)
#
#  This specifies the YUYV data buffer for the packed input format @ref INPUT_YUV422_BATCH.
#  The actual transfer will only happen after calling @ref Y2RU_StartConversion.
#

proc Y2RU_SetSendingYUYV*(src_buf: pointer; image_size: u32; transfer_unit: s16;
                         transfer_gap: s16): Result {.cdecl,
    importc: "Y2RU_SetSendingYUYV", header: "y2r.h".}
#*
#  @brief Configures the destination buffer.
#  @param src_buf A pointer to the beginning of your destination buffer in FCRAM
#  @param image_size The total size of the data buffer.
#  @param transfer_unit Specifies the size of 1 DMA transfer. Usually set to 1 line. This has to be a divisor of image_size.
#  @param transfer_gap Specifies the gap (offset) to be added after each transfer. Can be used to convert images with stride or only a part of it.
#
#  This specifies the destination buffer of the conversion.
#  The actual transfer will only happen after calling @ref Y2RU_StartConversion.
#  The buffer does NOT need to be allocated in the linear heap.
#
#  @warning transfer_unit+transfer_gap must be less than 32768 (0x8000)
#
#  @note
#       It seems that depending on the size of the image and of the transfer unit,\n
#       it is possible for the end of conversion interrupt to be triggered right after the conversion began.\n
#       One line as transfer_unit seems to trigger this issue for 400x240, setting to 2/4/8 lines fixes it.
#
#  @note Setting a transfer_unit of 4 or 8 lines seems to bring the best results in terms of speed for a 400x240 image.
#

proc Y2RU_SetReceiving*(dst_buf: pointer; image_size: u32; transfer_unit: s16;
                       transfer_gap: s16): Result {.cdecl,
    importc: "Y2RU_SetReceiving", header: "y2r.h".}
#*
#  @brief Checks if the DMA has finished sending the Y buffer.
#  @param is_done pointer to the boolean that will hold the result
#
#  True if the DMA has finished transferring the Y plane, false otherwise. To be used with @ref Y2RU_SetSendingY.
#

proc Y2RU_IsDoneSendingY*(is_done: ptr bool): Result {.cdecl,
    importc: "Y2RU_IsDoneSendingY", header: "y2r.h".}
#*
#  @brief Checks if the DMA has finished sending the U buffer.
#  @param is_done pointer to the boolean that will hold the result
#
#  True if the DMA has finished transferring the U plane, false otherwise. To be used with @ref Y2RU_SetSendingU.
#

proc Y2RU_IsDoneSendingU*(is_done: ptr bool): Result {.cdecl,
    importc: "Y2RU_IsDoneSendingU", header: "y2r.h".}
#*
#  @brief Checks if the DMA has finished sending the V buffer.
#  @param is_done pointer to the boolean that will hold the result
#
#  True if the DMA has finished transferring the V plane, false otherwise. To be used with @ref Y2RU_SetSendingV.
#

proc Y2RU_IsDoneSendingV*(is_done: ptr bool): Result {.cdecl,
    importc: "Y2RU_IsDoneSendingV", header: "y2r.h".}
#*
#  @brief Checks if the DMA has finished sending the YUYV buffer.
#  @param is_done pointer to the boolean that will hold the result
#
#  True if the DMA has finished transferring the YUYV buffer, false otherwise. To be used with @ref Y2RU_SetSendingYUYV.
#

proc Y2RU_IsDoneSendingYUYV*(is_done: ptr bool): Result {.cdecl,
    importc: "Y2RU_IsDoneSendingYUYV", header: "y2r.h".}
#*
#  @brief Checks if the DMA has finished sending the converted result.
#  @param is_done pointer to the boolean that will hold the result
#
#  True if the DMA has finished transferring data to your destination buffer, false otherwise.
#

proc Y2RU_IsDoneReceiving*(is_done: ptr bool): Result {.cdecl,
    importc: "Y2RU_IsDoneReceiving", header: "y2r.h".}
proc Y2RU_SetUnknownParams*(params: array[16, u16]): Result {.cdecl,
    importc: "Y2RU_SetUnknownParams", header: "y2r.h".}
#*
#  @brief Sets all the parameters of Y2R_ConversionParams at once.
#
#  Faster than calling the individual value through Y2R_Set* because only one system call is made.
#

proc Y2RU_SetConversionParams*(params: ptr Y2R_ConversionParams): Result {.cdecl,
    importc: "Y2RU_SetConversionParams", header: "y2r.h".}
#*
#  @brief Starts the conversion process
#

proc Y2RU_StartConversion*(): Result {.cdecl, importc: "Y2RU_StartConversion",
                                    header: "y2r.h".}
#*
#  @brief Cancels the conversion
#

proc Y2RU_StopConversion*(): Result {.cdecl, importc: "Y2RU_StopConversion",
                                   header: "y2r.h".}
#*
#  @brief Check if the conversion and DMA transfer are finished
#
#  This can have the same problems as the event and interrupt. See @ref Y2RU_SetTransferEndInterrupt.
#

proc Y2RU_IsBusyConversion*(is_busy: ptr bool): Result {.cdecl,
    importc: "Y2RU_IsBusyConversion", header: "y2r.h".}
# Seems to check whether y2r is ready to be used

proc Y2RU_PingProcess*(ping: ptr u8): Result {.cdecl, importc: "Y2RU_PingProcess",
    header: "y2r.h".}
proc Y2RU_DriverInitialize*(): Result {.cdecl, importc: "Y2RU_DriverInitialize",
                                     header: "y2r.h".}
proc Y2RU_DriverFinalize*(): Result {.cdecl, importc: "Y2RU_DriverFinalize",
                                   header: "y2r.h".}
