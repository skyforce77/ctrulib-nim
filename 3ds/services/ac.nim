proc acInit*(): Result
proc acExit*(): Result
proc ACU_GetWifiStatus*(servhandle: ptr Handle; `out`: ptr u32): Result
proc ACU_WaitInternetConnection*(): Result