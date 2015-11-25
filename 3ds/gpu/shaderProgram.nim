type
  float24Uniform_s* = object
    id*: u32
    data*: array[3, u32]


# this structure describes an instance of either a vertex or geometry shader

type
  shaderInstance_s* = object
    dvle*: ptr DVLE_s
    boolUniforms*: u16
    intUniforms*: array[4, u32]
    float24Uniforms*: ptr float24Uniform_s
    numFloat24Uniforms*: u8


# this structure describes an instance of a full shader program

type
  shaderProgram_s* = object
    vertexShader*: ptr shaderInstance_s
    geometryShader*: ptr shaderInstance_s
    geometryShaderInputStride*: u8


proc shaderInstanceInit*(si: ptr shaderInstance_s; dvle: ptr DVLE_s): Result
proc shaderInstanceFree*(si: ptr shaderInstance_s): Result
proc shaderInstanceSetBool*(si: ptr shaderInstance_s; id: cint; value: bool): Result
proc shaderInstanceGetBool*(si: ptr shaderInstance_s; id: cint; value: ptr bool): Result
proc shaderInstanceGetUniformLocation*(si: ptr shaderInstance_s; name: cstring): Result
proc shaderProgramInit*(sp: ptr shaderProgram_s): Result
proc shaderProgramFree*(sp: ptr shaderProgram_s): Result
proc shaderProgramSetVsh*(sp: ptr shaderProgram_s; dvle: ptr DVLE_s): Result
proc shaderProgramSetGsh*(sp: ptr shaderProgram_s; dvle: ptr DVLE_s; stride: u8): Result
proc shaderProgramUse*(sp: ptr shaderProgram_s): Result