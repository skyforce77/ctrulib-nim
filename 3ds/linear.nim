# Functions for allocating/deallocating memory from linear heap

proc linearAlloc*(size: csize): pointer {.cdecl, importc: "linearAlloc",
                                      header: "3ds.h".}
# returns a 16-byte aligned address

proc linearMemAlign*(size: csize; alignment: csize): pointer {.cdecl,
    importc: "linearMemAlign", header: "3ds.h".}
proc linearRealloc*(mem: pointer; size: csize): pointer {.cdecl,
    importc: "linearRealloc", header: "3ds.h".}
# not implemented yet

proc linearFree*(mem: pointer) {.cdecl, importc: "linearFree", header: "3ds.h".}
proc linearSpaceFree*(): u32 {.cdecl, importc: "linearSpaceFree", header: "3ds.h".}
# get free linear space in bytes
