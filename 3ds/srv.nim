proc srvInit*(): Result {.cdecl, importc: "srvInit", header: "srv.h".}
proc srvExit*(): Result {.cdecl, importc: "srvExit", header: "srv.h".}
proc srvGetSessionHandle*(): ptr Handle {.cdecl, importc: "srvGetSessionHandle",
                                      header: "srv.h".}
proc srvRegisterClient*(): Result {.cdecl, importc: "srvRegisterClient",
                                 header: "srv.h".}
proc srvGetServiceHandle*(`out`: ptr Handle; name: cstring): Result {.cdecl,
    importc: "srvGetServiceHandle", header: "srv.h".}
proc srvRegisterService*(`out`: ptr Handle; name: cstring; maxSessions: cint): Result {.
    cdecl, importc: "srvRegisterService", header: "srv.h".}
proc srvUnregisterService*(name: cstring): Result {.cdecl,
    importc: "srvUnregisterService", header: "srv.h".}
proc srvPmInit*(): Result {.cdecl, importc: "srvPmInit", header: "srv.h".}
proc srvRegisterProcess*(procid: u32; count: u32; serviceaccesscontrol: pointer): Result {.
    cdecl, importc: "srvRegisterProcess", header: "srv.h".}
proc srvUnregisterProcess*(procid: u32): Result {.cdecl,
    importc: "srvUnregisterProcess", header: "srv.h".}