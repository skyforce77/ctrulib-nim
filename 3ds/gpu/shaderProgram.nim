type
  float24Uniform_s* {.importc: "float24Uniform_s", header: "3ds.h".} = object
    id* {.importc: "id".}: u32
    data* {.importc: "data".}: array[3, u32]


# this structure describes an instance of either a vertex or geometry shader

type
  shaderInstance_s* {.importc: "shaderInstance_s", header: "3ds.h".} = object
    dvle* {.importc: "dvle".}: ptr DVLE_s
    boolUniforms* {.importc: "boolUniforms".}: u16
    intUniforms* {.importc: "intUniforms".}: array[4, u32]
    float24Uniforms* {.importc: "float24Uniforms".}: ptr float24Uniform_s
    numFloat24Uniforms* {.importc: "numFloat24Uniforms".}: u8


# this structure describes an instance of a full shader program

type
  shaderProgram_s* {.importc: "shaderProgram_s", header: "3ds.h".} = object
    vertexShader* {.importc: "vertexShader".}: ptr shaderInstance_s
    geometryShader* {.importc: "geometryShader".}: ptr shaderInstance_s
    geometryShaderInputStride* {.importc: "geometryShaderInputStride".}: u8


proc shaderInstanceInit*(si: ptr shaderInstance_s; dvle: ptr DVLE_s): Result {.cdecl,
    importc: "shaderInstanceInit", header: "3ds.h".}
proc shaderInstanceFree*(si: ptr shaderInstance_s): Result {.cdecl,
    importc: "shaderInstanceFree", header: "3ds.h".}
proc shaderInstanceSetBool*(si: ptr shaderInstance_s; id: cint; value: bool): Result {.
    cdecl, importc: "shaderInstanceSetBool", header: "3ds.h".}
proc shaderInstanceGetBool*(si: ptr shaderInstance_s; id: cint; value: ptr bool): Result {.
    cdecl, importc: "shaderInstanceGetBool", header: "3ds.h".}
proc shaderInstanceGetUniformLocation*(si: ptr shaderInstance_s; name: cstring): Result {.
    cdecl, importc: "shaderInstanceGetUniformLocation", header: "3ds.h".}
proc shaderProgramInit*(sp: ptr shaderProgram_s): Result {.cdecl,
    importc: "shaderProgramInit", header: "3ds.h".}
proc shaderProgramFree*(sp: ptr shaderProgram_s): Result {.cdecl,
    importc: "shaderProgramFree", header: "3ds.h".}
proc shaderProgramSetVsh*(sp: ptr shaderProgram_s; dvle: ptr DVLE_s): Result {.cdecl,
    importc: "shaderProgramSetVsh", header: "3ds.h".}
proc shaderProgramSetGsh*(sp: ptr shaderProgram_s; dvle: ptr DVLE_s; stride: u8): Result {.
    cdecl, importc: "shaderProgramSetGsh", header: "3ds.h".}
proc shaderProgramUse*(sp: ptr shaderProgram_s): Result {.cdecl,
    importc: "shaderProgramUse", header: "3ds.h".}