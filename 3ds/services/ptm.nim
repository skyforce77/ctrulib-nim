proc ptmInit*(): Result
proc ptmExit*(): Result
proc ptmSysmInit*(): Result
proc ptmSysmExit*(): Result
proc PTMU_GetShellState*(servhandle: ptr Handle; `out`: ptr u8): Result
proc PTMU_GetBatteryLevel*(servhandle: ptr Handle; `out`: ptr u8): Result
proc PTMU_GetBatteryChargeState*(servhandle: ptr Handle; `out`: ptr u8): Result
proc PTMU_GetPedometerState*(servhandle: ptr Handle; `out`: ptr u8): Result
proc PTMU_GetTotalStepCount*(servhandle: ptr Handle; steps: ptr u32): Result
proc PTMSYSM_ConfigureNew3DSCPU*(value: u8): Result