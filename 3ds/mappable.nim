# Functions for allocating/deallocating mappable memory

proc mappableAlloc*(size: csize): pointer {.cdecl, importc: "mappableAlloc",
                                        header: "3ds.h".}
# returns a page-aligned address

proc mappableFree*(mem: pointer) {.cdecl, importc: "mappableFree",
                                header: "3ds.h".}
proc mappableSpaceFree*(): u32 {.cdecl, importc: "mappableSpaceFree",
                              header: "3ds.h".}
# get free mappable space in bytes
