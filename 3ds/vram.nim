# Functions for allocating/deallocating VRAM

proc vramAlloc*(size: csize): pointer {.cdecl, importc: "vramAlloc", header: "vram.h".}
# returns a 16-byte aligned address

proc vramMemAlign*(size: csize; alignment: csize): pointer {.cdecl,
    importc: "vramMemAlign", header: "vram.h".}
proc vramRealloc*(mem: pointer; size: csize): pointer {.cdecl, importc: "vramRealloc",
    header: "vram.h".}
# not implemented yet

proc vramFree*(mem: pointer) {.cdecl, importc: "vramFree", header: "vram.h".}
proc vramSpaceFree*(): u32 {.cdecl, importc: "vramSpaceFree", header: "vram.h".}
# get free VRAM space in bytes
