# Functions for allocating/deallocating mappable memory

proc mappableAlloc*(size: csize): pointer {.cdecl, importc: "mappableAlloc",
                                        header: "mappable.h".}
# returns a page-aligned address

proc mappableFree*(mem: pointer) {.cdecl, importc: "mappableFree",
                                header: "mappable.h".}
proc mappableSpaceFree*(): u32 {.cdecl, importc: "mappableSpaceFree",
                              header: "mappable.h".}
# get free mappable space in bytes
