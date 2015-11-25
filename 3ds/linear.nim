# Functions for allocating/deallocating memory from linear heap

proc linearAlloc*(size: csize): pointer
# returns a 16-byte aligned address

proc linearMemAlign*(size: csize; alignment: csize): pointer
proc linearRealloc*(mem: pointer; size: csize): pointer
# not implemented yet

proc linearFree*(mem: pointer)
proc linearSpaceFree*(): u32
# get free linear space in bytes
