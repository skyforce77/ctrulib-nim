type
  mediatypes_enum* {.size: sizeof(cint).} = enum
    mediatype_NAND, mediatype_SDMC, mediatype_GAMECARD
  u8* = uint8
  u16* = uint16
  u32* = uint32
  u64* = uint64
  s8* = int8
  s16* = int16
  s32* = int32
  s64* = int64
  vu8* = u8
  vu16* = u16
  vu32* = u32
  vu64* = u64
  vs8* = s8
  vs16* = s16
  vs32* = s32
  vs64* = s64
  Handle* = u32
  Result* = s32
  ThreadFunc* = proc (a2: pointer) {.cdecl.}

template BIT*(n: expr): expr =
  (1 shl n)
