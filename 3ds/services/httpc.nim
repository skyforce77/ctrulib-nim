type
  httpcContext* = object
    servhandle*: Handle
    httphandle*: u32

  httpcReqStatus* = enum
    HTTPCREQSTAT_INPROGRESS_REQSENT = 0x00000005, HTTPCREQSTAT_DLREADY = 0x00000007


const
  HTTPC_RESULTCODE_DOWNLOADPENDING* = 0xD840A02B

proc httpcInit*(): Result
proc httpcExit*()
proc httpcOpenContext*(context: ptr httpcContext; url: cstring; use_defaultproxy: u32): Result
#use_defaultproxy should be non-zero normally, unless you don't want HTTPC_SetProxyDefault() to be used automatically.

proc httpcCloseContext*(context: ptr httpcContext): Result
proc httpcAddRequestHeaderField*(context: ptr httpcContext; name: cstring;
                                value: cstring): Result
proc httpcBeginRequest*(context: ptr httpcContext): Result
proc httpcReceiveData*(context: ptr httpcContext; buffer: ptr u8; size: u32): Result
proc httpcGetRequestState*(context: ptr httpcContext; `out`: ptr httpcReqStatus): Result
proc httpcGetDownloadSizeState*(context: ptr httpcContext; downloadedsize: ptr u32;
                               contentsize: ptr u32): Result
proc httpcGetResponseStatusCode*(context: ptr httpcContext; `out`: ptr u32; delay: u64): Result
#delay isn't used yet. This writes the HTTP status code from the server to out.

proc httpcGetResponseHeader*(context: ptr httpcContext; name: cstring; value: cstring;
                            valuebuf_maxsize: u32): Result
proc httpcDownloadData*(context: ptr httpcContext; buffer: ptr u8; size: u32;
                       downloadedsize: ptr u32): Result
#The *entire* content must be downloaded before using httpcCloseContext(), otherwise httpcCloseContext() will hang.
#Using the below functions directly is not recommended, use the above functions. See also the http example.

proc HTTPC_Initialize*(handle: Handle): Result
proc HTTPC_InitializeConnectionSession*(handle: Handle; contextHandle: Handle): Result
proc HTTPC_CreateContext*(handle: Handle; url: cstring; contextHandle: ptr Handle): Result
proc HTTPC_CloseContext*(handle: Handle; contextHandle: Handle): Result
proc HTTPC_SetProxyDefault*(handle: Handle; contextHandle: Handle): Result
proc HTTPC_AddRequestHeaderField*(handle: Handle; contextHandle: Handle;
                                 name: cstring; value: cstring): Result
proc HTTPC_BeginRequest*(handle: Handle; contextHandle: Handle): Result
proc HTTPC_ReceiveData*(handle: Handle; contextHandle: Handle; buffer: ptr u8; size: u32): Result
proc HTTPC_GetRequestState*(handle: Handle; contextHandle: Handle;
                           `out`: ptr httpcReqStatus): Result
proc HTTPC_GetDownloadSizeState*(handle: Handle; contextHandle: Handle;
                                downloadedsize: ptr u32; contentsize: ptr u32): Result
proc HTTPC_GetResponseHeader*(handle: Handle; contextHandle: Handle; name: cstring;
                             value: cstring; valuebuf_maxsize: u32): Result
proc HTTPC_GetResponseStatusCode*(handle: Handle; contextHandle: Handle;
                                 `out`: ptr u32): Result