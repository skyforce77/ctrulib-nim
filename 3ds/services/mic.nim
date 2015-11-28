#See also: http://3dbrew.org/wiki/MIC_Services

proc MIC_Initialize*(sharedmem: ptr u32; sharedmem_size: u32; control: u8;
                    recording: u8; unk0: u8; unk1: u8; unk2: u8): Result {.cdecl,
    importc: "MIC_Initialize", header: "mic.h".}
#sharedmem_size = audiodata size + 4, aligned to 0x1000-bytes. The sharedmem ptr must be 0x1000-bytes aligned. The offical 3ds-sound app uses the following values for unk0-unk2: 3, 1, and 1.

proc MIC_Shutdown*(): Result {.cdecl, importc: "MIC_Shutdown", header: "mic.h".}
proc MIC_GetSharedMemOffsetValue*(): u32 {.cdecl,
                                        importc: "MIC_GetSharedMemOffsetValue",
                                        header: "mic.h".}
proc MIC_ReadAudioData*(outbuf: ptr u8; readsize: u32; waitforevent: u32): u32 {.cdecl,
    importc: "MIC_ReadAudioData", header: "mic.h".}
#Reads MIC audio data. When waitforevent is non-zero, this clears the event, then waits for MIC-module to signal it again when audio data is written to shared-mem. The return value is the actual byte-size of the read data.

proc MIC_MapSharedMem*(handle: Handle; size: u32): Result {.cdecl,
    importc: "MIC_MapSharedMem", header: "mic.h".}
proc MIC_UnmapSharedMem*(): Result {.cdecl, importc: "MIC_UnmapSharedMem",
                                  header: "mic.h".}
proc MIC_cmd3_Initialize*(unk0: u8; unk1: u8; sharedmem_baseoffset: u32;
                         sharedmem_endoffset: u32; unk2: u8): Result {.cdecl,
    importc: "MIC_cmd3_Initialize", header: "mic.h".}
proc MIC_cmd5*(): Result {.cdecl, importc: "MIC_cmd5", header: "mic.h".}
proc MIC_GetCNTBit15*(`out`: ptr u8): Result {.cdecl, importc: "MIC_GetCNTBit15",
    header: "mic.h".}
proc MIC_GetEventHandle*(handle: ptr Handle): Result {.cdecl,
    importc: "MIC_GetEventHandle", header: "mic.h".}
proc MIC_SetControl*(value: u8): Result {.cdecl, importc: "MIC_SetControl",
                                      header: "mic.h".}
#See here: http://3dbrew.org/wiki/MIC_Services

proc MIC_GetControl*(value: ptr u8): Result {.cdecl, importc: "MIC_GetControl",
    header: "mic.h".}
proc MIC_SetRecording*(value: u8): Result {.cdecl, importc: "MIC_SetRecording",
                                        header: "mic.h".}
proc MIC_IsRecoding*(value: ptr u8): Result {.cdecl, importc: "MIC_IsRecoding",
    header: "mic.h".}