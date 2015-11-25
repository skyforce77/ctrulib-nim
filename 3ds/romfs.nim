type
  romfs_header* = object
    headerSize*: u32
    dirHashTableOff*: u32
    dirHashTableSize*: u32
    dirTableOff*: u32
    dirTableSize*: u32
    fileHashTableOff*: u32
    fileHashTableSize*: u32
    fileTableOff*: u32
    fileTableSize*: u32
    fileDataOff*: u32

  romfs_dir* = object
    parent*: u32
    sibling*: u32
    childDir*: u32
    childFile*: u32
    nextHash*: u32
    nameLen*: u32
    name*: ptr u16

  romfs_file* = object
    parent*: u32
    sibling*: u32
    dataOff*: u64
    dataSize*: u64
    nextHash*: u32
    nameLen*: u32
    name*: ptr u16


proc romfsInit*(): Result
proc romfsInitFromFile*(file: Handle; offset: u32): Result
proc romfsExit*(): Result