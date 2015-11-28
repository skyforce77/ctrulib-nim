import
  "3ds/gpu/registers"

#GPU

proc GPU_Init*(gsphandle: ptr Handle) {.cdecl, importc: "GPU_Init", header: "3ds.h".}
proc GPU_Reset*(gxbuf: ptr u32; gpuBuf: ptr u32; gpuBufSize: u32) {.cdecl,
    importc: "GPU_Reset", header: "3ds.h".}
#GPUCMD

template GPUCMD_HEADER*(incremental, mask, reg: expr): expr =
  (((incremental) shl 31) or (((mask) and 0x0000000F) shl 16) or ((reg) and 0x000003FF))

proc GPUCMD_SetBuffer*(adr: ptr u32; size: u32; offset: u32) {.cdecl,
    importc: "GPUCMD_SetBuffer", header: "3ds.h".}
proc GPUCMD_SetBufferOffset*(offset: u32) {.cdecl,
    importc: "GPUCMD_SetBufferOffset", header: "3ds.h".}
proc GPUCMD_GetBuffer*(adr: ptr ptr u32; size: ptr u32; offset: ptr u32) {.cdecl,
    importc: "GPUCMD_GetBuffer", header: "3ds.h".}
proc GPUCMD_AddRawCommands*(cmd: ptr u32; size: u32) {.cdecl,
    importc: "GPUCMD_AddRawCommands", header: "3ds.h".}
proc GPUCMD_Run*(gxbuf: ptr u32) {.cdecl, importc: "GPUCMD_Run", header: "3ds.h".}
proc GPUCMD_FlushAndRun*(gxbuf: ptr u32) {.cdecl, importc: "GPUCMD_FlushAndRun",
                                       header: "3ds.h".}
proc GPUCMD_Add*(header: u32; param: ptr u32; paramlength: u32) {.cdecl,
    importc: "GPUCMD_Add", header: "3ds.h".}
proc GPUCMD_Finalize*() {.cdecl, importc: "GPUCMD_Finalize", header: "3ds.h".}
template GPUCMD_AddMaskedWrite*(reg, mask, val: expr): expr =
  GPUCMD_AddSingleParam(GPUCMD_HEADER(0, (mask), (reg)), (val))

template GPUCMD_AddWrite*(reg, val: expr): expr =
  GPUCMD_AddMaskedWrite((reg), 0x0000000F, (val))

template GPUCMD_AddMaskedWrites*(reg, mask, vals, num: expr): expr =
  GPUCMD_Add(GPUCMD_HEADER(0, (mask), (reg)), (vals), (num))

template GPUCMD_AddWrites*(reg, vals, num: expr): expr =
  GPUCMD_AddMaskedWrites((reg), 0x0000000F, (vals), (num))

template GPUCMD_AddMaskedIncrementalWrites*(reg, mask, vals, num: expr): expr =
  GPUCMD_Add(GPUCMD_HEADER(1, (mask), (reg)), (vals), (num))

template GPUCMD_AddIncrementalWrites*(reg, vals, num: expr): expr =
  GPUCMD_AddMaskedIncrementalWrites((reg), 0x0000000F, (vals), (num))

#tex param

template GPU_TEXTURE_MAG_FILTER*(v: expr): expr =
  (((v) and 0x00000001) shl 1)    #takes a GPU_TEXTURE_FILTER_PARAM

template GPU_TEXTURE_MIN_FILTER*(v: expr): expr =
  (((v) and 0x00000001) shl 2)    #takes a GPU_TEXTURE_FILTER_PARAM

template GPU_TEXTURE_WRAP_S*(v: expr): expr =
  (((v) and 0x00000003) shl 12)   #takes a GPU_TEXTURE_WRAP_PARAM

template GPU_TEXTURE_WRAP_T*(v: expr): expr =
  (((v) and 0x00000003) shl 8)    #takes a GPU_TEXTURE_WRAP_PARAM

# Combiner buffer write config

template GPU_TEV_BUFFER_WRITE_CONFIG*(stage0, stage1, stage2, stage3: expr): expr =
  (stage0 or (stage1 shl 1) or (stage2 shl 2) or (stage3 shl 3))

type
  GPU_TEXTURE_FILTER_PARAM* {.size: sizeof(cint).} = enum
    GPU_NEAREST = 0x00000000, GPU_LINEAR = 0x00000001
  GPU_TEXTURE_WRAP_PARAM* {.size: sizeof(cint).} = enum
    GPU_CLAMP_TO_EDGE = 0x00000000, GPU_CLAMP_TO_BORDER = 0x00000001,
    GPU_REPEAT = 0x00000002, GPU_MIRRORED_REPEAT = 0x00000003
  GPU_TEXUNIT* {.size: sizeof(cint).} = enum
    GPU_TEXUNIT0 = 0x00000001, GPU_TEXUNIT1 = 0x00000002, GPU_TEXUNIT2 = 0x00000004
  GPU_TEXCOLOR* {.size: sizeof(cint).} = enum
    GPU_RGBA8 = 0x00000000, GPU_RGB8 = 0x00000001, GPU_RGBA5551 = 0x00000002,
    GPU_RGB565 = 0x00000003, GPU_RGBA4 = 0x00000004, GPU_LA8 = 0x00000005,
    GPU_HILO8 = 0x00000006, GPU_L8 = 0x00000007, GPU_A8 = 0x00000008,
    GPU_LA4 = 0x00000009, GPU_L4 = 0x0000000A, GPU_ETC1 = 0x0000000B,
    GPU_ETC1A4 = 0x0000000C
  GPU_TESTFUNC* {.size: sizeof(cint).} = enum
    GPU_NEVER = 0, GPU_ALWAYS = 1, GPU_EQUAL = 2, GPU_NOTEQUAL = 3, GPU_LESS = 4,
    GPU_LEQUAL = 5, GPU_GREATER = 6, GPU_GEQUAL = 7
  GPU_SCISSORMODE* {.size: sizeof(cint).} = enum
    GPU_SCISSOR_DISABLE = 0,    # disable scissor test
    GPU_SCISSOR_INVERT = 1,     # exclude pixels inside the scissor box
                         # 2 is the same as 0
    GPU_SCISSOR_NORMAL = 3      # exclude pixels outside of the scissor box
  GPU_STENCILOP* {.size: sizeof(cint).} = enum
    GPU_STENCIL_KEEP = 0,       # old_stencil
    GPU_STENCIL_ZERO = 1,       # 0
    GPU_STENCIL_REPLACE = 2,    # ref
    GPU_STENCIL_INCR = 3,       # old_stencil + 1 saturated to [0, 255]
    GPU_STENCIL_DECR = 4,       # old_stencil - 1 saturated to [0, 255]
    GPU_STENCIL_INVERT = 5,     # ~old_stencil
    GPU_STENCIL_INCR_WRAP = 6,  # old_stencil + 1
    GPU_STENCIL_DECR_WRAP = 7
  GPU_WRITEMASK* {.size: sizeof(cint).} = enum
    GPU_WRITE_RED = 0x00000001, GPU_WRITE_GREEN = 0x00000002,
    GPU_WRITE_BLUE = 0x00000004, GPU_WRITE_ALPHA = 0x00000008,
    GPU_WRITE_COLOR = 0x0000000F, GPU_WRITE_DEPTH = 0x00000010,
    GPU_WRITE_ALL = 0x0000001F
  GPU_BLENDEQUATION* {.size: sizeof(cint).} = enum
    GPU_BLEND_ADD = 0, GPU_BLEND_SUBTRACT = 1, GPU_BLEND_REVERSE_SUBTRACT = 2,
    GPU_BLEND_MIN = 3, GPU_BLEND_MAX = 4
  GPU_BLENDFACTOR* {.size: sizeof(cint).} = enum
    GPU_ZERO = 0, GPU_ONE = 1, GPU_SRC_COLOR = 2, GPU_ONE_MINUS_SRC_COLOR = 3,
    GPU_DST_COLOR = 4, GPU_ONE_MINUS_DST_COLOR = 5, GPU_SRC_ALPHA = 6,
    GPU_ONE_MINUS_SRC_ALPHA = 7, GPU_DST_ALPHA = 8, GPU_ONE_MINUS_DST_ALPHA = 9,
    GPU_CONSTANT_COLOR = 10, GPU_ONE_MINUS_CONSTANT_COLOR = 11,
    GPU_CONSTANT_ALPHA = 12, GPU_ONE_MINUS_CONSTANT_ALPHA = 13,
    GPU_SRC_ALPHA_SATURATE = 14
  GPU_LOGICOP* {.size: sizeof(cint).} = enum
    GPU_LOGICOP_CLEAR = 0, GPU_LOGICOP_AND = 1, GPU_LOGICOP_AND_REVERSE = 2,
    GPU_LOGICOP_COPY = 3, GPU_LOGICOP_SET = 4, GPU_LOGICOP_COPY_INVERTED = 5,
    GPU_LOGICOP_NOOP = 6, GPU_LOGICOP_INVERT = 7, GPU_LOGICOP_NAND = 8,
    GPU_LOGICOP_OR = 9, GPU_LOGICOP_NOR = 10, GPU_LOGICOP_XOR = 11,
    GPU_LOGICOP_EQUIV = 12, GPU_LOGICOP_AND_INVERTED = 13,
    GPU_LOGICOP_OR_REVERSE = 14, GPU_LOGICOP_OR_INVERTED = 15
  GPU_FORMATS* {.size: sizeof(cint).} = enum
    GPU_BYTE = 0, GPU_UNSIGNED_BYTE = 1, GPU_SHORT = 2, GPU_FLOAT = 3













#defines for CW ?

type
  GPU_CULLMODE* {.size: sizeof(cint).} = enum
    GPU_CULL_NONE = 0, GPU_CULL_FRONT_CCW = 1, GPU_CULL_BACK_CCW = 2


template GPU_ATTRIBFMT*(i, n, f: expr): expr =
  (((((n) - 1) shl 2) or ((f) and 3)) shl ((i) * 4))

#*
# Texture combiners sources
#

type
  GPU_TEVSRC* {.size: sizeof(cint).} = enum
    GPU_PRIMARY_COLOR = 0x00000000, GPU_TEXTURE0 = 0x00000003,
    GPU_TEXTURE1 = 0x00000004, GPU_TEXTURE2 = 0x00000005, GPU_TEXTURE3 = 0x00000006,
    GPU_PREVIOUS_BUFFER = 0x0000000D, GPU_CONSTANT = 0x0000000E,
    GPU_PREVIOUS = 0x0000000F


#*
# Texture RGB combiners operands
#

type
  GPU_TEVOP_RGB* {.size: sizeof(cint).} = enum
    GPU_TEVOP_RGB_SRC_COLOR = 0x00000000,
    GPU_TEVOP_RGB_ONE_MINUS_SRC_COLOR = 0x00000001,
    GPU_TEVOP_RGB_SRC_ALPHA = 0x00000002,
    GPU_TEVOP_RGB_ONE_MINUS_SRC_ALPHA = 0x00000003,
    GPU_TEVOP_RGB_SRC0_RGB = 0x00000004, GPU_TEVOP_RGB_0x05 = 0x00000005,
    GPU_TEVOP_RGB_0x06 = 0x00000006, GPU_TEVOP_RGB_0x07 = 0x00000007,
    GPU_TEVOP_RGB_SRC1_RGB = 0x00000008, GPU_TEVOP_RGB_0x09 = 0x00000009,
    GPU_TEVOP_RGB_0x0A = 0x0000000A, GPU_TEVOP_RGB_0x0B = 0x0000000B,
    GPU_TEVOP_RGB_SRC2_RGB = 0x0000000C, GPU_TEVOP_RGB_0x0D = 0x0000000D,
    GPU_TEVOP_RGB_0x0E = 0x0000000E, GPU_TEVOP_RGB_0x0F = 0x0000000F


#*
# Texture ALPHA combiners operands
#

type
  GPU_TEVOP_A* {.size: sizeof(cint).} = enum
    GPU_TEVOP_A_SRC_ALPHA = 0x00000000,
    GPU_TEVOP_A_ONE_MINUS_SRC_ALPHA = 0x00000001,
    GPU_TEVOP_A_SRC0_RGB = 0x00000002, GPU_TEVOP_A_SRC1_RGB = 0x00000004,
    GPU_TEVOP_A_SRC2_RGB = 0x00000006


#*
# Texture combiner functions
#

type
  GPU_COMBINEFUNC* {.size: sizeof(cint).} = enum
    GPU_REPLACE = 0x00000000, GPU_MODULATE = 0x00000001, GPU_ADD = 0x00000002,
    GPU_ADD_SIGNED = 0x00000003, GPU_INTERPOLATE = 0x00000004,
    GPU_SUBTRACT = 0x00000005, GPU_DOT3_RGB = 0x00000006


template GPU_TEVSOURCES*(a, b, c: expr): expr =
  (((a)) or ((b) shl 4) or ((c) shl 8))

template GPU_TEVOPERANDS*(a, b, c: expr): expr =
  (((a)) or ((b) shl 4) or ((c) shl 8))

type
  GPU_Primitive_t* {.size: sizeof(cint).} = enum
    GPU_TRIANGLES = 0x00000000, GPU_TRIANGLE_STRIP = 0x00000100,
    GPU_TRIANGLE_FAN = 0x00000200, GPU_UNKPRIM = 0x00000300
  GPU_SHADER_TYPE* {.size: sizeof(cint).} = enum
    GPU_VERTEX_SHADER = 0x00000000, GPU_GEOMETRY_SHADER = 0x00000001



proc GPU_SetFloatUniform*(`type`: GPU_SHADER_TYPE; startreg: u32; data: ptr u32;
                         numreg: u32) {.cdecl, importc: "GPU_SetFloatUniform",
                                      header: "3ds.h".}
proc GPU_SetViewport*(depthBuffer: ptr u32; colorBuffer: ptr u32; x: u32; y: u32; w: u32;
                     h: u32) {.cdecl, importc: "GPU_SetViewport", header: "3ds.h".}
proc GPU_SetScissorTest*(mode: GPU_SCISSORMODE; x: u32; y: u32; w: u32; h: u32) {.cdecl,
    importc: "GPU_SetScissorTest", header: "3ds.h".}
proc GPU_DepthMap*(zScale: cfloat; zOffset: cfloat) {.cdecl, importc: "GPU_DepthMap",
    header: "3ds.h".}
proc GPU_SetAlphaTest*(enable: bool; function: GPU_TESTFUNC; `ref`: u8) {.cdecl,
    importc: "GPU_SetAlphaTest", header: "3ds.h".}
proc GPU_SetDepthTestAndWriteMask*(enable: bool; function: GPU_TESTFUNC;
                                  writemask: GPU_WRITEMASK) {.cdecl,
    importc: "GPU_SetDepthTestAndWriteMask", header: "3ds.h".}
# GPU_WRITEMASK values can be ORed together

proc GPU_SetStencilTest*(enable: bool; function: GPU_TESTFUNC; `ref`: u8;
                        input_mask: u8; write_mask: u8) {.cdecl,
    importc: "GPU_SetStencilTest", header: "3ds.h".}
proc GPU_SetStencilOp*(sfail: GPU_STENCILOP; dfail: GPU_STENCILOP;
                      pass: GPU_STENCILOP) {.cdecl, importc: "GPU_SetStencilOp",
    header: "3ds.h".}
proc GPU_SetFaceCulling*(mode: GPU_CULLMODE) {.cdecl, importc: "GPU_SetFaceCulling",
    header: "3ds.h".}
# Only the first four tev stages can write to the combiner buffer, use GPU_TEV_BUFFER_WRITE_CONFIG to build the parameters

proc GPU_SetCombinerBufferWrite*(rgb_config: u8; alpha_config: u8) {.cdecl,
    importc: "GPU_SetCombinerBufferWrite", header: "3ds.h".}
# these two can't be used together

proc GPU_SetAlphaBlending*(colorEquation: GPU_BLENDEQUATION;
                          alphaEquation: GPU_BLENDEQUATION;
                          colorSrc: GPU_BLENDFACTOR; colorDst: GPU_BLENDFACTOR;
                          alphaSrc: GPU_BLENDFACTOR; alphaDst: GPU_BLENDFACTOR) {.
    cdecl, importc: "GPU_SetAlphaBlending", header: "3ds.h".}
proc GPU_SetColorLogicOp*(op: GPU_LOGICOP) {.cdecl, importc: "GPU_SetColorLogicOp",
    header: "3ds.h".}
proc GPU_SetBlendingColor*(r: u8; g: u8; b: u8; a: u8) {.cdecl,
    importc: "GPU_SetBlendingColor", header: "3ds.h".}
proc GPU_SetAttributeBuffers*(totalAttributes: u8; baseAddress: ptr u32;
                             attributeFormats: u64; attributeMask: u16;
                             attributePermutation: u64; numBuffers: u8;
                             bufferOffsets: ptr u32; bufferPermutations: ptr u64;
                             bufferNumAttributes: ptr u8) {.cdecl,
    importc: "GPU_SetAttributeBuffers", header: "3ds.h".}
proc GPU_SetTextureEnable*(units: GPU_TEXUNIT) {.cdecl,
    importc: "GPU_SetTextureEnable", header: "3ds.h".}
# GPU_TEXUNITx values can be ORed together to enable multiple texture units

proc GPU_SetTexture*(unit: GPU_TEXUNIT; data: ptr u32; width: u16; height: u16;
                    param: u32; colorType: GPU_TEXCOLOR) {.cdecl,
    importc: "GPU_SetTexture", header: "3ds.h".}
#*
#  @param borderColor The color used for the border when using the @ref GPU_CLAMP_TO_BORDER wrap mode
#

proc GPU_SetTextureBorderColor*(unit: GPU_TEXUNIT; borderColor: u32) {.cdecl,
    importc: "GPU_SetTextureBorderColor", header: "3ds.h".}
proc GPU_SetTexEnv*(id: u8; rgbSources: u16; alphaSources: u16; rgbOperands: u16;
                   alphaOperands: u16; rgbCombine: GPU_COMBINEFUNC;
                   alphaCombine: GPU_COMBINEFUNC; constantColor: u32) {.cdecl,
    importc: "GPU_SetTexEnv", header: "3ds.h".}
proc GPU_DrawArray*(primitive: GPU_Primitive_t; first: u32; count: u32) {.cdecl,
    importc: "GPU_DrawArray", header: "3ds.h".}
proc GPU_DrawElements*(primitive: GPU_Primitive_t; indexArray: ptr u32; n: u32) {.cdecl,
    importc: "GPU_DrawElements", header: "3ds.h".}
proc GPU_FinishDrawing*() {.cdecl, importc: "GPU_FinishDrawing", header: "3ds.h".}
proc GPU_SetShaderOutmap*(outmapData: array[8, u32]) {.cdecl,
    importc: "GPU_SetShaderOutmap", header: "3ds.h".}
proc GPU_SendShaderCode*(`type`: GPU_SHADER_TYPE; data: ptr u32; offset: u16;
                        length: u16) {.cdecl, importc: "GPU_SendShaderCode",
                                     header: "3ds.h".}
proc GPU_SendOperandDescriptors*(`type`: GPU_SHADER_TYPE; data: ptr u32; offset: u16;
                                length: u16) {.cdecl,
    importc: "GPU_SendOperandDescriptors", header: "3ds.h".}
