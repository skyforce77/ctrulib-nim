const
  CSND_NUM_CHANNELS* = 32

template CSND_TIMER*(n: expr): expr =
  (0x03FEC3FC div ((u32)(n)))

# Convert a vol-pan pair into a left/right volume pair used by the hardware

proc CSND_VOL*(vol: cfloat; pan: cfloat): u32 {.inline.} =
  if vol < 0.0: vol = 0.0
  elif vol > 1.0: vol = 1.0
  var rpan: cfloat = (pan + 1) div 2
  if rpan < 0.0: rpan = 0.0
  elif rpan > 1.0: rpan = 1.0
  var lvol: u32 = vol * (1 - rpan) * 0x00008000
  var rvol: u32 = vol * rpan * 0x00008000
  return lvol or (rvol shl 16)

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
  INNER_C_STRUCT_9160523392117797416* = object
    active*: u8
    _pad1*: u8
    _pad2*: u16
    adpcmSample*: s16
    adpcmIndex*: u8
    _pad3*: u8
    unknownZero*: u32

  INNER_C_STRUCT_9486380960715914939* = object
    active*: u8
    _pad1*: u8
    _pad2*: u16
    unknownZero*: u32

  CSND_ChnInfo* = object {.union.}
    value*: array[3, u32]
    ano_9190728738556393646*: INNER_C_STRUCT_9160523392117797416

  CSND_CapInfo* = object {.union.}
    value*: array[2, u32]
    ano_8769925387053353172*: INNER_C_STRUCT_9486380960715914939


# See here regarding CSND shared-mem commands, etc: http://3dbrew.org/wiki/CSND_Shared_Memory

var csndSharedMem*: ptr vu32

var csndSharedMemSize*: u32

var csndChannels*: u32

# Bitmask of channels that are allowed for usage

proc CSND_AcquireCapUnit*(capUnit: ptr u32): Result
proc CSND_ReleaseCapUnit*(capUnit: u32): Result
proc CSND_Reset*(): Result
# Currently breaks sound, don't use for now!

proc csndInit*(): Result
proc csndExit*(): Result
proc csndAddCmd*(cmdid: cint): ptr u32
# Adds a command to the list and returns the buffer to which write its arguments.

proc csndWriteCmd*(cmdid: cint; cmdparams: ptr u8)
# As above, but copies the arguments from an external buffer

proc csndExecCmds*(waitDone: bool): Result
proc CSND_SetPlayStateR*(channel: u32; value: u32)
proc CSND_SetPlayState*(channel: u32; value: u32)
proc CSND_SetEncoding*(channel: u32; value: u32)
proc CSND_SetBlock*(channel: u32; `block`: cint; physaddr: u32; size: u32)
proc CSND_SetLooping*(channel: u32; value: u32)
proc CSND_SetBit7*(channel: u32; set: bool)
proc CSND_SetInterp*(channel: u32; interp: bool)
proc CSND_SetDuty*(channel: u32; duty: u32)
proc CSND_SetTimer*(channel: u32; timer: u32)
proc CSND_SetVol*(channel: u32; chnVolumes: u32; capVolumes: u32)
proc CSND_SetAdpcmState*(channel: u32; `block`: cint; sample: cint; index: cint)
proc CSND_SetAdpcmReload*(channel: u32; reload: bool)
proc CSND_SetChnRegs*(flags: u32; physaddr0: u32; physaddr1: u32; totalbytesize: u32;
                     chnVolumes: u32; capVolumes: u32)
proc CSND_SetChnRegsPSG*(flags: u32; chnVolumes: u32; capVolumes: u32; duty: u32)
proc CSND_SetChnRegsNoise*(flags: u32; chnVolumes: u32; capVolumes: u32)
proc CSND_CapEnable*(capUnit: u32; enable: bool)
proc CSND_CapSetRepeat*(capUnit: u32; repeat: bool)
proc CSND_CapSetFormat*(capUnit: u32; eightbit: bool)
proc CSND_CapSetBit2*(capUnit: u32; set: bool)
proc CSND_CapSetTimer*(capUnit: u32; timer: u32)
proc CSND_CapSetBuffer*(capUnit: u32; `addr`: u32; size: u32)
proc CSND_SetCapRegs*(capUnit: u32; flags: u32; `addr`: u32; size: u32)
proc CSND_SetDspFlags*(waitDone: bool): Result
proc CSND_UpdateInfo*(waitDone: bool): Result
#*
#  @param vol The volume, ranges from 0.0 to 1.0 included
#  @param pan The pan, ranges from -1.0 to 1.0 included
# 

proc csndPlaySound*(chn: cint; flags: u32; sampleRate: u32; vol: cfloat; pan: cfloat;
                   data0: pointer; data1: pointer; size: u32): Result
proc csndGetDspFlags*(outSemFlags: ptr u32; outIrqFlags: ptr u32)
# Requires previous CSND_UpdateInfo()

proc csndGetChnInfo*(channel: u32): ptr CSND_ChnInfo
# Requires previous CSND_UpdateInfo()

proc csndGetCapInfo*(capUnit: u32): ptr CSND_CapInfo
# Requires previous CSND_UpdateInfo()

proc csndGetState*(channel: u32; `out`: ptr CSND_ChnInfo): Result
proc csndIsPlaying*(channel: u32; status: ptr u8): Result