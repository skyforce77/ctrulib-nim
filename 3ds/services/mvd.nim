#New3DS-only, see also: http://3dbrew.org/wiki/MVD_Services

type
  mvdstdMode* {.size: sizeof(cint).} = enum
    MVDMODE_COLORFORMATCONV, MVDMODE_VIDEOPROCESSING
  mvdstdTypeInput* {.size: sizeof(cint).} = enum
    MVDTYPEIN_YUYV422 = 0x00010001, MVDTYPEIN_H264 = 0x00020001
  mvdstdTypeOutput* {.size: sizeof(cint).} = enum
    MVDTYPEOUT_RGB565 = 0x00040002
  mvdstdConfig* {.importc: "mvdstdConfig", header: "mvd.h".} = object
    input_type* {.importc: "input_type".}: mvdstdTypeInput
    unk_x04* {.importc: "unk_x04".}: u32
    unk_x08* {.importc: "unk_x08".}: u32
    inwidth* {.importc: "inwidth".}: u32
    inheight* {.importc: "inheight".}: u32
    physaddr_colorconv_indata* {.importc: "physaddr_colorconv_indata".}: u32
    unk_x18* {.importc: "unk_x18".}: array[0x00000028 shr 2, u32]
    flag_x40* {.importc: "flag_x40".}: u32 #0x0 for colorconv, 0x1 for H.264
    unk_x44* {.importc: "unk_x44".}: u32
    unk_x48* {.importc: "unk_x48".}: u32
    outheight0* {.importc: "outheight0".}: u32
    outwidth0* {.importc: "outwidth0".}: u32 #Only set for H.264.
    unk_x54* {.importc: "unk_x54".}: u32
    output_type* {.importc: "output_type".}: mvdstdTypeOutput
    outwidth1* {.importc: "outwidth1".}: u32
    outheight1* {.importc: "outheight1".}: u32
    physaddr_outdata0* {.importc: "physaddr_outdata0".}: u32
    physaddr_outdata1_colorconv* {.importc: "physaddr_outdata1_colorconv".}: u32
    unk_x6c* {.importc: "unk_x6c".}: array[0x000000B0 shr 2, u32]





proc mvdstdGenerateDefaultConfig*(config: ptr mvdstdConfig; input_width: u32;
                                 input_height: u32; output_width: u32;
                                 output_height: u32;
                                 vaddr_colorconv_indata: ptr u32;
                                 vaddr_outdata0: ptr u32;
                                 vaddr_outdata1_colorconv: ptr u32) {.cdecl,
    importc: "mvdstdGenerateDefaultConfig", header: "mvd.h".}
proc mvdstdInit*(mode: mvdstdMode; input_type: mvdstdTypeInput;
                output_type: mvdstdTypeOutput; size: u32): Result {.cdecl,
    importc: "mvdstdInit", header: "mvd.h".}
#The input size isn't used when type==MVDTYPE_COLORFORMATCONV. Video processing / H.264 isn't supported currently.

proc mvdstdShutdown*(): Result {.cdecl, importc: "mvdstdShutdown", header: "mvd.h".}
proc mvdstdSetConfig*(config: ptr mvdstdConfig): Result {.cdecl,
    importc: "mvdstdSetConfig", header: "mvd.h".}
proc mvdstdProcessFrame*(config: ptr mvdstdConfig; h264_vaddr_inframe: ptr u32;
                        h264_inframesize: u32; h264_frameid: u32): Result {.cdecl,
    importc: "mvdstdProcessFrame", header: "mvd.h".}