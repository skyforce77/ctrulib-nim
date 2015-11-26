# Convert a UTF-8 sequence into a UTF-32 codepoint
#
#   @param[out] out Output codepoint
#   @param[in]  in  Input sequence
#
#   @returns number of input code units consumed
#   @returns -1 for error
#

proc decode_utf8*(`out`: ptr u32; `in`: ptr u8): int
#! Convert a UTF-16 sequence into a UTF-32 codepoint
#
#   @param[out] out Output codepoint
#   @param[in]  in  Input sequence
#
#   @returns number of input code units consumed
#   @returns -1 for error
#

proc decode_utf16*(`out`: ptr u32; `in`: ptr u16): int
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

proc encode_utf8*(`out`: ptr u8; `in`: u32): int
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

proc encode_utf16*(`out`: ptr u16; `in`: u32): int
#! Convert a UTF-8 sequence into a UTF-16 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf8_to_utf16*(`out`: ptr u16; `in`: ptr u8; len: csize): csize
#! Convert a UTF-8 sequence into a UTF-32 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf8_to_utf32*(`out`: ptr u32; `in`: ptr u8; len: csize): csize
#! Convert a UTF-16 sequence into a UTF-8 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf16_to_utf8*(`out`: ptr u8; `in`: ptr u16; len: csize): csize
#! Convert a UTF-16 sequence into a UTF-32 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf16_to_utf32*(`out`: ptr u32; `in`: ptr u16; len: csize): csize
#! Convert a UTF-32 sequence into a UTF-8 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf32_to_utf8*(`out`: ptr u8; `in`: ptr u32; len: csize): csize
#! Convert a UTF-32 sequence into a UTF-16 sequence
#
#   @param[out] out Output sequence
#   @param[in]  in  Input sequence
#
#   @returns number of output code units produced
#   @returns -1 for error
#

proc utf32_to_utf16*(`out`: ptr u16; `in`: ptr u32; len: csize): csize
