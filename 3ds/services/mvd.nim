#New3DS-only, see also: http://3dbrew.org/wiki/MVD_Services

type
  mvdstdMode* = enum
    MVDMODE_COLORFORMATCONV, MVDMODE_VIDEOPROCESSING
  mvdstdTypeInput* = enum
    MVDTYPEIN_YUYV422 = 0x00010001, MVDTYPEIN_H264 = 0x00020001
  mvdstdTypeOutput* = enum
    MVDTYPEOUT_RGB565 = 0x00040002
  mvdstdConfig* = object
    input_type*: mvdstdTypeInput
    unk_x04*: u32
    unk_x08*: u32
    inwidth*: u32
    inheight*: u32
    physaddr_colorconv_indata*: u32
    unk_x18*: array[0x00000028 shr 2, u32]
    flag_x40*: u32             #0x0 for colorconv, 0x1 for H.264
    unk_x44*: u32
    unk_x48*: u32
    outheight0*: u32
    outwidth0*: u32            #Only set for H.264.
    unk_x54*: u32
    output_type*: mvdstdTypeOutput
    outwidth1*: u32
    outheight1*: u32
    physaddr_outdata0*: u32
    physaddr_outdata1_colorconv*: u32
    unk_x6c*: array[0x000000B0 shr 2, u32]





proc mvdstdGenerateDefaultConfig*(config: ptr mvdstdConfig; input_width: u32;
                                 input_height: u32; output_width: u32;
                                 output_height: u32;
                                 vaddr_colorconv_indata: ptr u32;
                                 vaddr_outdata0: ptr u32;
                                 vaddr_outdata1_colorconv: ptr u32)
proc mvdstdInit*(mode: mvdstdMode; input_type: mvdstdTypeInput;
                output_type: mvdstdTypeOutput; size: u32): Result
#The input size isn't used when type==MVDTYPE_COLORFORMATCONV. Video processing / H.264 isn't supported currently.

proc mvdstdShutdown*(): Result
proc mvdstdSetConfig*(config: ptr mvdstdConfig): Result
proc mvdstdProcessFrame*(config: ptr mvdstdConfig; h264_vaddr_inframe: ptr u32;
                        h264_inframesize: u32; h264_frameid: u32): Result