# Convert a UTF-8 sequence into a UTF-32 codepoint
#
#   @param[out] out Output codepoint
#   @param[in]  in  Input sequence
#
#   @returns number of input code units consumed
#   @returns -1 for error
#

proc decode_utf8*(`out`: ptr uint32; `in`: ptr uint8): int {.cdecl,
    importc: "decode_utf8", header: "utf.h".}
#! Convert a UTF-16 sequence into a UTF-32 codepoint
#
#   @param[out] out Output codepoint
#   @param[in]  in  Input sequence
#
#   @returns number of input code units consumed
#   @returns -1 for error
#

proc decode_utf16*(`out`: ptr uint32; `in`: ptr uint16): int {.cdecl,
    importc: "decode_utf16", header: "utf.h".}
#! Convert a UTF-32 codepoint into a UTF-8 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input codepoint
#
#   @returns number of output code units produced
#   @returns -1 for error
#
#   @note \a out must be able to store 4 code units
#

proc encode_utf8*(`out`: ptr uint8; `in`: uint32): int {.cdecl,
    importc: "encode_utf8", header: "utf.h".}
#! Convert a UTF-32 codepoint into a UTF-16 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input codepoint
#
#   @returns number of output code units produced
#   @returns -1 for error
#
#   @note \a out must be able to store 2 code units
#

proc encode_utf16*(`out`: ptr uint16; `in`: uint32): int {.cdecl,
    importc: "encode_utf16", header: "utf.h".}
#! Convert a UTF-8 sequence into a UTF-16 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf8_to_utf16*(`out`: ptr uint16; `in`: ptr uint8; len: csize): csize {.cdecl,
    importc: "utf8_to_utf16", header: "utf.h".}
#! Convert a UTF-8 sequence into a UTF-32 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf8_to_utf32*(`out`: ptr uint32; `in`: ptr uint8; len: csize): csize {.cdecl,
    importc: "utf8_to_utf32", header: "utf.h".}
#! Convert a UTF-16 sequence into a UTF-8 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf16_to_utf8*(`out`: ptr uint8; `in`: ptr uint16; len: csize): csize {.cdecl,
    importc: "utf16_to_utf8", header: "utf.h".}
#! Convert a UTF-16 sequence into a UTF-32 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf16_to_utf32*(`out`: ptr uint32; `in`: ptr uint16; len: csize): csize {.cdecl,
    importc: "utf16_to_utf32", header: "utf.h".}
#! Convert a UTF-32 sequence into a UTF-8 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf32_to_utf8*(`out`: ptr uint8; `in`: ptr uint32; len: csize): csize {.cdecl,
    importc: "utf32_to_utf8", header: "utf.h".}
#! Convert a UTF-32 sequence into a UTF-16 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf32_to_utf16*(`out`: ptr uint16; `in`: ptr uint32; len: csize): csize {.cdecl,
    importc: "utf32_to_utf16", header: "utf.h".}
