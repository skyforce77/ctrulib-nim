#
#  types.h _ Various system types.
#

const
  U64_MAX* = UINT64_MAX

type
  mediatypes_enum* = enum
    mediatype_NAND, mediatype_SDMC, mediatype_GAMECARD
  u8* = uint8_t
  u16* = uint16_t
  u32* = uint32_t
  u64* = uint64_t
  s8* = int8_t
  s16* = int16_t
  s32* = int32_t
  s64* = int64_t
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
  ThreadFunc* = proc (a2: pointer)


template BIT*(n: expr): expr =
  (1 shl (n))

#! aligns a struct (and other types?) to m, making sure that the size of the struct is a multiple of m.

template ALIGN*(m: expr): expr =
  __attribute__((aligned(m)))

#! packs a struct (and other types?) so it won't include padding bytes.

const
  PACKED* = __attribute__((packed))
