proc acInit*(): Result {.cdecl, importc: "acInit", header: "ac.h".}
proc acExit*(): Result {.cdecl, importc: "acExit", header: "ac.h".}
proc ACU_GetWifiStatus*(servhandle: ptr Handle; `out`: ptr u32): Result {.cdecl,
    importc: "ACU_GetWifiStatus", header: "ac.h".}
proc ACU_WaitInternetConnection*(): Result {.cdecl,
    importc: "ACU_WaitInternetConnection", header: "ac.h".}