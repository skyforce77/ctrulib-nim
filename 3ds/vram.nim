# Functions for allocating/deallocating VRAM

proc vramAlloc*(size: csize): pointer
# returns a 16-byte aligned address

proc vramMemAlign*(size: csize; alignment: csize): pointer
proc vramRealloc*(mem: pointer; size: csize): pointer
# not implemented yet

proc vramFree*(mem: pointer)
proc vramSpaceFree*(): u32
# get free VRAM space in bytes
