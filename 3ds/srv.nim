proc srvInit*(): Result
proc srvExit*(): Result
proc srvGetSessionHandle*(): ptr Handle
proc srvRegisterClient*(): Result
proc srvGetServiceHandle*(`out`: ptr Handle; name: cstring): Result
proc srvRegisterService*(`out`: ptr Handle; name: cstring; maxSessions: cint): Result
proc srvUnregisterService*(name: cstring): Result
proc srvPmInit*(): Result
proc srvRegisterProcess*(procid: u32; count: u32; serviceaccesscontrol: pointer): Result
proc srvUnregisterProcess*(procid: u32): Result