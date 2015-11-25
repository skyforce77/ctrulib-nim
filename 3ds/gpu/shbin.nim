type
  DVLE_type* = enum
    VERTEX_SHDR = GPU_VERTEX_SHADER, GEOMETRY_SHDR = GPU_GEOMETRY_SHADER
  DVLE_constantType* = enum
    DVLE_CONST_BOOL = 0x00000000, DVLE_CONST_u8 = 0x00000001,
    DVLE_CONST_FLOAT24 = 0x00000002
  DVLE_outputAttribute_t* = enum
    RESULT_POSITION = 0x00000000, RESULT_NORMALQUAT = 0x00000001,
    RESULT_COLOR = 0x00000002, RESULT_TEXCOORD0 = 0x00000003,
    RESULT_TEXCOORD0W = 0x00000004, RESULT_TEXCOORD1 = 0x00000005,
    RESULT_TEXCOORD2 = 0x00000006, RESULT_VIEW = 0x00000008
  DVLP_s* = object
    codeSize*: u32
    codeData*: ptr u32
    opdescSize*: u32
    opcdescData*: ptr u32

  DVLE_constEntry_s* = object
    `type`*: u16
    id*: u16
    data*: array[4, u32]

  DVLE_outEntry_s* = object
    `type`*: u16
    regID*: u16
    mask*: u8
    unk*: array[3, u8]

  DVLE_uniformEntry_s* = object
    symbolOffset*: u32
    startReg*: u16
    endReg*: u16

  DVLE_s* = object
    `type`*: DVLE_type
    dvlp*: ptr DVLP_s
    mainOffset*: u32
    endmainOffset*: u32
    constTableSize*: u32
    constTableData*: ptr DVLE_constEntry_s
    outTableSize*: u32
    outTableData*: ptr DVLE_outEntry_s
    uniformTableSize*: u32
    uniformTableData*: ptr DVLE_uniformEntry_s
    symbolTableData*: cstring
    outmapMask*: u8
    outmapData*: array[8, u32]

  DVLB_s* = object
    numDVLE*: u32
    DVLP*: DVLP_s
    DVLE*: ptr DVLE_s





proc DVLB_ParseFile*(shbinData: ptr u32; shbinSize: u32): ptr DVLB_s
proc DVLB_Free*(dvlb: ptr DVLB_s)
proc DVLE_GetUniformRegister*(dvle: ptr DVLE_s; name: cstring): s8
proc DVLE_GenerateOutmap*(dvle: ptr DVLE_s)