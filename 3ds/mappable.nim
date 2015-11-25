# Functions for allocating/deallocating mappable memory

proc mappableAlloc*(size: csize): pointer
# returns a page-aligned address

proc mappableFree*(mem: pointer)
proc mappableSpaceFree*(): u32
# get free mappable space in bytes
