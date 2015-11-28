type
  DVLE_type* {.size: sizeof(cint).} = enum
    VERTEX_SHDR = GPU_VERTEX_SHADER, GEOMETRY_SHDR = GPU_GEOMETRY_SHADER
  DVLE_constantType* {.size: sizeof(cint).} = enum
    DVLE_CONST_BOOL = 0x00000000, DVLE_CONST_u8 = 0x00000001,
    DVLE_CONST_FLOAT24 = 0x00000002
  DVLE_outputAttribute_t* {.size: sizeof(cint).} = enum
    RESULT_POSITION = 0x00000000, RESULT_NORMALQUAT = 0x00000001,
    RESULT_COLOR = 0x00000002, RESULT_TEXCOORD0 = 0x00000003,
    RESULT_TEXCOORD0W = 0x00000004, RESULT_TEXCOORD1 = 0x00000005,
    RESULT_TEXCOORD2 = 0x00000006, RESULT_VIEW = 0x00000008
  DVLP_s* {.importc: "DVLP_s", header: "3ds.h".} = object
    codeSize* {.importc: "codeSize".}: u32
    codeData* {.importc: "codeData".}: ptr u32
    opdescSize* {.importc: "opdescSize".}: u32
    opcdescData* {.importc: "opcdescData".}: ptr u32

  DVLE_constEntry_s* {.importc: "DVLE_constEntry_s", header: "3ds.h".} = object
    `type`* {.importc: "type".}: u16
    id* {.importc: "id".}: u16
    data* {.importc: "data".}: array[4, u32]

  DVLE_outEntry_s* {.importc: "DVLE_outEntry_s", header: "3ds.h".} = object
    `type`* {.importc: "type".}: u16
    regID* {.importc: "regID".}: u16
    mask* {.importc: "mask".}: u8
    unk* {.importc: "unk".}: array[3, u8]

  DVLE_uniformEntry_s* {.importc: "DVLE_uniformEntry_s", header: "3ds.h".} = object
    symbolOffset* {.importc: "symbolOffset".}: u32
    startReg* {.importc: "startReg".}: u16
    endReg* {.importc: "endReg".}: u16

  DVLE_s* {.importc: "DVLE_s", header: "3ds.h".} = object
    `type`* {.importc: "type".}: DVLE_type
    dvlp* {.importc: "dvlp".}: ptr DVLP_s
    mainOffset* {.importc: "mainOffset".}: u32
    endmainOffset* {.importc: "endmainOffset".}: u32
    constTableSize* {.importc: "constTableSize".}: u32
    constTableData* {.importc: "constTableData".}: ptr DVLE_constEntry_s
    outTableSize* {.importc: "outTableSize".}: u32
    outTableData* {.importc: "outTableData".}: ptr DVLE_outEntry_s
    uniformTableSize* {.importc: "uniformTableSize".}: u32
    uniformTableData* {.importc: "uniformTableData".}: ptr DVLE_uniformEntry_s
    symbolTableData* {.importc: "symbolTableData".}: cstring
    outmapMask* {.importc: "outmapMask".}: u8
    outmapData* {.importc: "outmapData".}: array[8, u32]

  DVLB_s* {.importc: "DVLB_s", header: "3ds.h".} = object
    numDVLE* {.importc: "numDVLE".}: u32
    DVLP* {.importc: "DVLP".}: DVLP_s
    DVLE* {.importc: "DVLE".}: ptr DVLE_s





proc DVLB_ParseFile*(shbinData: ptr u32; shbinSize: u32): ptr DVLB_s {.cdecl,
    importc: "DVLB_ParseFile", header: "3ds.h".}
proc DVLB_Free*(dvlb: ptr DVLB_s) {.cdecl, importc: "DVLB_Free", header: "3ds.h".}
proc DVLE_GetUniformRegister*(dvle: ptr DVLE_s; name: cstring): s8 {.cdecl,
    importc: "DVLE_GetUniformRegister", header: "3ds.h".}
proc DVLE_GenerateOutmap*(dvle: ptr DVLE_s) {.cdecl, importc: "DVLE_GenerateOutmap",
    header: "3ds.h".}