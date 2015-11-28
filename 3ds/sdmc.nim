proc sdmcInit*(): Result {.cdecl, importc: "sdmcInit", header: "sdmc.h".}
proc sdmcExit*(): Result {.cdecl, importc: "sdmcExit", header: "sdmc.h".}