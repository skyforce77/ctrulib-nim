type
  httpcContext* {.importc: "httpcContext", header: "httpc.h".} = object
    servhandle* {.importc: "servhandle".}: Handle
    httphandle* {.importc: "httphandle".}: u32

  httpcReqStatus* {.size: sizeof(cint).} = enum
    HTTPCREQSTAT_INPROGRESS_REQSENT = 0x00000005, HTTPCREQSTAT_DLREADY = 0x00000007


const
  HTTPC_RESULTCODE_DOWNLOADPENDING* = 0xD840A02B

proc httpcInit*(): Result {.cdecl, importc: "httpcInit", header: "httpc.h".}
proc httpcExit*() {.cdecl, importc: "httpcExit", header: "httpc.h".}
proc httpcOpenContext*(context: ptr httpcContext; url: cstring; use_defaultproxy: u32): Result {.
    cdecl, importc: "httpcOpenContext", header: "httpc.h".}
#use_defaultproxy should be non-zero normally, unless you don't want HTTPC_SetProxyDefault() to be used automatically.

proc httpcCloseContext*(context: ptr httpcContext): Result {.cdecl,
    importc: "httpcCloseContext", header: "httpc.h".}
proc httpcAddRequestHeaderField*(context: ptr httpcContext; name: cstring;
                                value: cstring): Result {.cdecl,
    importc: "httpcAddRequestHeaderField", header: "httpc.h".}
proc httpcBeginRequest*(context: ptr httpcContext): Result {.cdecl,
    importc: "httpcBeginRequest", header: "httpc.h".}
proc httpcReceiveData*(context: ptr httpcContext; buffer: ptr u8; size: u32): Result {.
    cdecl, importc: "httpcReceiveData", header: "httpc.h".}
proc httpcGetRequestState*(context: ptr httpcContext; `out`: ptr httpcReqStatus): Result {.
    cdecl, importc: "httpcGetRequestState", header: "httpc.h".}
proc httpcGetDownloadSizeState*(context: ptr httpcContext; downloadedsize: ptr u32;
                               contentsize: ptr u32): Result {.cdecl,
    importc: "httpcGetDownloadSizeState", header: "httpc.h".}
proc httpcGetResponseStatusCode*(context: ptr httpcContext; `out`: ptr u32; delay: u64): Result {.
    cdecl, importc: "httpcGetResponseStatusCode", header: "httpc.h".}
#delay isn't used yet. This writes the HTTP status code from the server to out.

proc httpcGetResponseHeader*(context: ptr httpcContext; name: cstring; value: cstring;
                            valuebuf_maxsize: u32): Result {.cdecl,
    importc: "httpcGetResponseHeader", header: "httpc.h".}
proc httpcDownloadData*(context: ptr httpcContext; buffer: ptr u8; size: u32;
                       downloadedsize: ptr u32): Result {.cdecl,
    importc: "httpcDownloadData", header: "httpc.h".}
#The *entire* content must be downloaded before using httpcCloseContext(), otherwise httpcCloseContext() will hang.
#Using the below functions directly is not recommended, use the above functions. See also the http example.

proc HTTPC_Initialize*(handle: Handle): Result {.cdecl, importc: "HTTPC_Initialize",
    header: "httpc.h".}
proc HTTPC_InitializeConnectionSession*(handle: Handle; contextHandle: Handle): Result {.
    cdecl, importc: "HTTPC_InitializeConnectionSession", header: "httpc.h".}
proc HTTPC_CreateContext*(handle: Handle; url: cstring; contextHandle: ptr Handle): Result {.
    cdecl, importc: "HTTPC_CreateContext", header: "httpc.h".}
proc HTTPC_CloseContext*(handle: Handle; contextHandle: Handle): Result {.cdecl,
    importc: "HTTPC_CloseContext", header: "httpc.h".}
proc HTTPC_SetProxyDefault*(handle: Handle; contextHandle: Handle): Result {.cdecl,
    importc: "HTTPC_SetProxyDefault", header: "httpc.h".}
proc HTTPC_AddRequestHeaderField*(handle: Handle; contextHandle: Handle;
                                 name: cstring; value: cstring): Result {.cdecl,
    importc: "HTTPC_AddRequestHeaderField", header: "httpc.h".}
proc HTTPC_BeginRequest*(handle: Handle; contextHandle: Handle): Result {.cdecl,
    importc: "HTTPC_BeginRequest", header: "httpc.h".}
proc HTTPC_ReceiveData*(handle: Handle; contextHandle: Handle; buffer: ptr u8; size: u32): Result {.
    cdecl, importc: "HTTPC_ReceiveData", header: "httpc.h".}
proc HTTPC_GetRequestState*(handle: Handle; contextHandle: Handle;
                           `out`: ptr httpcReqStatus): Result {.cdecl,
    importc: "HTTPC_GetRequestState", header: "httpc.h".}
proc HTTPC_GetDownloadSizeState*(handle: Handle; contextHandle: Handle;
                                downloadedsize: ptr u32; contentsize: ptr u32): Result {.
    cdecl, importc: "HTTPC_GetDownloadSizeState", header: "httpc.h".}
proc HTTPC_GetResponseHeader*(handle: Handle; contextHandle: Handle; name: cstring;
                             value: cstring; valuebuf_maxsize: u32): Result {.cdecl,
    importc: "HTTPC_GetResponseHeader", header: "httpc.h".}
proc HTTPC_GetResponseStatusCode*(handle: Handle; contextHandle: Handle;
                                 `out`: ptr u32): Result {.cdecl,
    importc: "HTTPC_GetResponseStatusCode", header: "httpc.h".}