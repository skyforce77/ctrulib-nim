type
  romfs_header* {.importc: "romfs_header", header: "romfs.h".} = object
    headerSize* {.importc: "headerSize".}: u32
    dirHashTableOff* {.importc: "dirHashTableOff".}: u32
    dirHashTableSize* {.importc: "dirHashTableSize".}: u32
    dirTableOff* {.importc: "dirTableOff".}: u32
    dirTableSize* {.importc: "dirTableSize".}: u32
    fileHashTableOff* {.importc: "fileHashTableOff".}: u32
    fileHashTableSize* {.importc: "fileHashTableSize".}: u32
    fileTableOff* {.importc: "fileTableOff".}: u32
    fileTableSize* {.importc: "fileTableSize".}: u32
    fileDataOff* {.importc: "fileDataOff".}: u32

  romfs_dir* {.importc: "romfs_dir", header: "romfs.h".} = object
    parent* {.importc: "parent".}: u32
    sibling* {.importc: "sibling".}: u32
    childDir* {.importc: "childDir".}: u32
    childFile* {.importc: "childFile".}: u32
    nextHash* {.importc: "nextHash".}: u32
    nameLen* {.importc: "nameLen".}: u32
    name* {.importc: "name".}: ptr u16

  romfs_file* {.importc: "romfs_file", header: "romfs.h".} = object
    parent* {.importc: "parent".}: u32
    sibling* {.importc: "sibling".}: u32
    dataOff* {.importc: "dataOff".}: u64
    dataSize* {.importc: "dataSize".}: u64
    nextHash* {.importc: "nextHash".}: u32
    nameLen* {.importc: "nameLen".}: u32
    name* {.importc: "name".}: ptr u16


proc romfsInit*(): Result {.cdecl, importc: "romfsInit", header: "romfs.h".}
proc romfsInitFromFile*(file: Handle; offset: u32): Result {.cdecl,
    importc: "romfsInitFromFile", header: "romfs.h".}
proc romfsExit*(): Result {.cdecl, importc: "romfsExit", header: "romfs.h".}