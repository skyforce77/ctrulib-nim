const
  CSND_NUM_CHANNELS* = 32

template CSND_TIMER*(n: expr): expr =
  (0x03FEC3FC div ((u32)(n)))

# Convert a vol-pan pair into a left/right volume pair used by the hardware

proc CSND_VOL*(vol: var cfloat; pan: cfloat): u32 {.inline, cdecl.} =
  if vol < 0.0: vol = 0.0
  elif vol > 1.0: vol = 1.0
  var rpan: cfloat = cfloat(pan + cfloat(1.0)) / cfloat(2.0)
  if rpan < 0.0: rpan = 0.0
  elif rpan > 1.0: rpan = 1.0
  var lvol: u32 = u32(vol * (1.0 - rpan)) * u32(0x00008000)
  var rvol: u32 = u32(vol * (rpan)) * u32(0x00008000)
  return lvol or (rvol shl u32(16.0))

const
  CSND_ENCODING_PCM8* = 0
  CSND_ENCODING_PCM16* = 1
  CSND_ENCODING_ADPCM* = 2      # IMA-ADPCM
  CSND_ENCODING_PSG* = 3        # Similar to DS?

const
  CSND_LOOPMODE_MANUAL* = 0
  CSND_LOOPMODE_NORMAL* = 1
  CSND_LOOPMODE_ONESHOT* = 2
  CSND_LOOPMODE_NORELOAD* = 3

template SOUND_CHANNEL*(n: expr): expr =
  ((u32)(n) and 0x0000001F)

template SOUND_FORMAT*(n: expr): expr =
  ((u32)(n) shl 12)

template SOUND_LOOPMODE*(n: expr): expr =
  ((u32)(n) shl 10)

const
  SOUND_LINEAR_INTERP* = BIT(6)
  SOUND_REPEAT* = SOUND_LOOPMODE(CSND_LOOPMODE_NORMAL)
  SOUND_ONE_SHOT* = SOUND_LOOPMODE(CSND_LOOPMODE_ONESHOT)
  SOUND_FORMAT_8BIT* = SOUND_FORMAT(CSND_ENCODING_PCM8)
  SOUND_FORMAT_16BIT* = SOUND_FORMAT(CSND_ENCODING_PCM16)
  SOUND_FORMAT_ADPCM* = SOUND_FORMAT(CSND_ENCODING_ADPCM)
  SOUND_FORMAT_PSG* = SOUND_FORMAT(CSND_ENCODING_PSG)
  SOUND_ENABLE* = BIT(14)

const
  CAPTURE_REPEAT* = 0
  CAPTURE_ONE_SHOT* = BIT(0)
  CAPTURE_FORMAT_16BIT* = 0
  CAPTURE_FORMAT_8BIT* = BIT(1)
  CAPTURE_ENABLE* = BIT(15)

# Duty cycles for a PSG channel

const
  DutyCycle_0* = 7              #!<  0.0% duty cycle
  DutyCycle_12* = 0             #!<  12.5% duty cycle
  DutyCycle_25* = 1             #!<  25.0% duty cycle
  DutyCycle_37* = 2             #!<  37.5% duty cycle
  DutyCycle_50* = 3             #!<  50.0% duty cycle
  DutyCycle_62* = 4             #!<  62.5% duty cycle
  DutyCycle_75* = 5             #!<  75.0% duty cycle
  DutyCycle_87* = 6

type
  INNER_C_STRUCT_9160523392117797416* {.importc: "no_name", header: "csnd.h".} = object
    active* {.importc: "active".}: u8
    pad1* {.importc: "_pad1".}: u8
    pad2* {.importc: "_pad2".}: u16
    adpcmSample* {.importc: "adpcmSample".}: s16
    adpcmIndex* {.importc: "adpcmIndex".}: u8
    pad3* {.importc: "_pad3".}: u8
    unknownZero* {.importc: "unknownZero".}: u32

  INNER_C_STRUCT_9486380960715914939* {.importc: "no_name", header: "csnd.h".} = object
    active* {.importc: "active".}: u8
    pad1* {.importc: "_pad1".}: u8
    pad2* {.importc: "_pad2".}: u16
    unknownZero* {.importc: "unknownZero".}: u32

  CSND_ChnInfo* {.importc: "CSND_ChnInfo", header: "csnd.h".} = object {.union.}
    value* {.importc: "value".}: array[3, u32]
    ano_9190728738556393646* {.importc: "ano_9190728738556393646".}: INNER_C_STRUCT_9160523392117797416

  CSND_CapInfo* {.importc: "CSND_CapInfo", header: "csnd.h".} = object {.union.}
    value* {.importc: "value".}: array[2, u32]
    ano_8769925387053353172* {.importc: "ano_8769925387053353172".}: INNER_C_STRUCT_9486380960715914939


# See here regarding CSND shared-mem commands, etc: http://3dbrew.org/wiki/CSND_Shared_Memory

var csndSharedMem* {.importc: "csndSharedMem", header: "csnd.h".}: ptr vu32

var csndSharedMemSize* {.importc: "csndSharedMemSize", header: "csnd.h".}: u32

var csndChannels* {.importc: "csndChannels", header: "csnd.h".}: u32

# Bitmask of channels that are allowed for usage

proc CSND_AcquireCapUnit*(capUnit: ptr u32): Result {.cdecl,
    importc: "CSND_AcquireCapUnit", header: "csnd.h".}
proc CSND_ReleaseCapUnit*(capUnit: u32): Result {.cdecl,
    importc: "CSND_ReleaseCapUnit", header: "csnd.h".}
proc CSND_Reset*(): Result {.cdecl, importc: "CSND_Reset", header: "csnd.h".}
# Currently breaks sound, don't use for now!

proc csndInit*(): Result {.cdecl, importc: "csndInit", header: "csnd.h".}
proc csndExit*(): Result {.cdecl, importc: "csndExit", header: "csnd.h".}
proc csndAddCmd*(cmdid: cint): ptr u32 {.cdecl, importc: "csndAddCmd", header: "csnd.h".}
# Adds a command to the list and returns the buffer to which write its arguments.

proc csndWriteCmd*(cmdid: cint; cmdparams: ptr u8) {.cdecl, importc: "csndWriteCmd",
    header: "csnd.h".}
# As above, but copies the arguments from an external buffer

proc csndExecCmds*(waitDone: bool): Result {.cdecl, importc: "csndExecCmds",
    header: "csnd.h".}
proc CSND_SetPlayStateR*(channel: u32; value: u32) {.cdecl,
    importc: "CSND_SetPlayStateR", header: "csnd.h".}
proc CSND_SetPlayState*(channel: u32; value: u32) {.cdecl,
    importc: "CSND_SetPlayState", header: "csnd.h".}
proc CSND_SetEncoding*(channel: u32; value: u32) {.cdecl, importc: "CSND_SetEncoding",
    header: "csnd.h".}
proc CSND_SetBlock*(channel: u32; `block`: cint; physaddr: u32; size: u32) {.cdecl,
    importc: "CSND_SetBlock", header: "csnd.h".}
proc CSND_SetLooping*(channel: u32; value: u32) {.cdecl, importc: "CSND_SetLooping",
    header: "csnd.h".}
proc CSND_SetBit7*(channel: u32; set: bool) {.cdecl, importc: "CSND_SetBit7",
    header: "csnd.h".}
proc CSND_SetInterp*(channel: u32; interp: bool) {.cdecl, importc: "CSND_SetInterp",
    header: "csnd.h".}
proc CSND_SetDuty*(channel: u32; duty: u32) {.cdecl, importc: "CSND_SetDuty",
    header: "csnd.h".}
proc CSND_SetTimer*(channel: u32; timer: u32) {.cdecl, importc: "CSND_SetTimer",
    header: "csnd.h".}
proc CSND_SetVol*(channel: u32; chnVolumes: u32; capVolumes: u32) {.cdecl,
    importc: "CSND_SetVol", header: "csnd.h".}
proc CSND_SetAdpcmState*(channel: u32; `block`: cint; sample: cint; index: cint) {.cdecl,
    importc: "CSND_SetAdpcmState", header: "csnd.h".}
proc CSND_SetAdpcmReload*(channel: u32; reload: bool) {.cdecl,
    importc: "CSND_SetAdpcmReload", header: "csnd.h".}
proc CSND_SetChnRegs*(flags: u32; physaddr0: u32; physaddr1: u32; totalbytesize: u32;
                     chnVolumes: u32; capVolumes: u32) {.cdecl,
    importc: "CSND_SetChnRegs", header: "csnd.h".}
proc CSND_SetChnRegsPSG*(flags: u32; chnVolumes: u32; capVolumes: u32; duty: u32) {.
    cdecl, importc: "CSND_SetChnRegsPSG", header: "csnd.h".}
proc CSND_SetChnRegsNoise*(flags: u32; chnVolumes: u32; capVolumes: u32) {.cdecl,
    importc: "CSND_SetChnRegsNoise", header: "csnd.h".}
proc CSND_CapEnable*(capUnit: u32; enable: bool) {.cdecl, importc: "CSND_CapEnable",
    header: "csnd.h".}
proc CSND_CapSetRepeat*(capUnit: u32; repeat: bool) {.cdecl,
    importc: "CSND_CapSetRepeat", header: "csnd.h".}
proc CSND_CapSetFormat*(capUnit: u32; eightbit: bool) {.cdecl,
    importc: "CSND_CapSetFormat", header: "csnd.h".}
proc CSND_CapSetBit2*(capUnit: u32; set: bool) {.cdecl, importc: "CSND_CapSetBit2",
    header: "csnd.h".}
proc CSND_CapSetTimer*(capUnit: u32; timer: u32) {.cdecl, importc: "CSND_CapSetTimer",
    header: "csnd.h".}
proc CSND_CapSetBuffer*(capUnit: u32; `addr`: u32; size: u32) {.cdecl,
    importc: "CSND_CapSetBuffer", header: "csnd.h".}
proc CSND_SetCapRegs*(capUnit: u32; flags: u32; `addr`: u32; size: u32) {.cdecl,
    importc: "CSND_SetCapRegs", header: "csnd.h".}
proc CSND_SetDspFlags*(waitDone: bool): Result {.cdecl, importc: "CSND_SetDspFlags",
    header: "csnd.h".}
proc CSND_UpdateInfo*(waitDone: bool): Result {.cdecl, importc: "CSND_UpdateInfo",
    header: "csnd.h".}
#*
#  @param vol The volume, ranges from 0.0 to 1.0 included
#  @param pan The pan, ranges from -1.0 to 1.0 included
#

proc csndPlaySound*(chn: cint; flags: u32; sampleRate: u32; vol: cfloat; pan: cfloat;
                   data0: pointer; data1: pointer; size: u32): Result {.cdecl,
    importc: "csndPlaySound", header: "csnd.h".}
proc csndGetDspFlags*(outSemFlags: ptr u32; outIrqFlags: ptr u32) {.cdecl,
    importc: "csndGetDspFlags", header: "csnd.h".}
# Requires previous CSND_UpdateInfo()

proc csndGetChnInfo*(channel: u32): ptr CSND_ChnInfo {.cdecl,
    importc: "csndGetChnInfo", header: "csnd.h".}
# Requires previous CSND_UpdateInfo()

proc csndGetCapInfo*(capUnit: u32): ptr CSND_CapInfo {.cdecl,
    importc: "csndGetCapInfo", header: "csnd.h".}
# Requires previous CSND_UpdateInfo()

proc csndGetState*(channel: u32; `out`: ptr CSND_ChnInfo): Result {.cdecl,
    importc: "csndGetState", header: "csnd.h".}
proc csndIsPlaying*(channel: u32; status: ptr u8): Result {.cdecl,
    importc: "csndIsPlaying", header: "csnd.h".}
