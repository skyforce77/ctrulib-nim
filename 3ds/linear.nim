# Functions for allocating/deallocating memory from linear heap

proc linearAlloc*(size: csize): pointer {.cdecl, importc: "linearAlloc",
                                      header: "linear.h".}
# returns a 16-byte aligned address

proc linearMemAlign*(size: csize; alignment: csize): pointer {.cdecl,
    importc: "linearMemAlign", header: "linear.h".}
proc linearRealloc*(mem: pointer; size: csize): pointer {.cdecl,
    importc: "linearRealloc", header: "linear.h".}
# not implemented yet

proc linearFree*(mem: pointer) {.cdecl, importc: "linearFree", header: "linear.h".}
proc linearSpaceFree*(): u32 {.cdecl, importc: "linearSpaceFree", header: "linear.h".}
# get free linear space in bytes
