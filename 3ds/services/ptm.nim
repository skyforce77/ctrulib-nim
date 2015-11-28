proc ptmInit*(): Result {.cdecl, importc: "ptmInit", header: "ptm.h".}
proc ptmExit*(): Result {.cdecl, importc: "ptmExit", header: "ptm.h".}
proc ptmSysmInit*(): Result {.cdecl, importc: "ptmSysmInit", header: "ptm.h".}
proc ptmSysmExit*(): Result {.cdecl, importc: "ptmSysmExit", header: "ptm.h".}
proc PTMU_GetShellState*(servhandle: ptr Handle; `out`: ptr u8): Result {.cdecl,
    importc: "PTMU_GetShellState", header: "ptm.h".}
proc PTMU_GetBatteryLevel*(servhandle: ptr Handle; `out`: ptr u8): Result {.cdecl,
    importc: "PTMU_GetBatteryLevel", header: "ptm.h".}
proc PTMU_GetBatteryChargeState*(servhandle: ptr Handle; `out`: ptr u8): Result {.cdecl,
    importc: "PTMU_GetBatteryChargeState", header: "ptm.h".}
proc PTMU_GetPedometerState*(servhandle: ptr Handle; `out`: ptr u8): Result {.cdecl,
    importc: "PTMU_GetPedometerState", header: "ptm.h".}
proc PTMU_GetTotalStepCount*(servhandle: ptr Handle; steps: ptr u32): Result {.cdecl,
    importc: "PTMU_GetTotalStepCount", header: "ptm.h".}
proc PTMSYSM_ConfigureNew3DSCPU*(value: u8): Result {.cdecl,
    importc: "PTMSYSM_ConfigureNew3DSCPU", header: "ptm.h".}