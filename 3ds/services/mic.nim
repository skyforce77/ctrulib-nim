#See also: http://3dbrew.org/wiki/MIC_Services

proc MIC_Initialize*(sharedmem: ptr u32; sharedmem_size: u32; control: u8;
                    recording: u8; unk0: u8; unk1: u8; unk2: u8): Result
#sharedmem_size = audiodata size + 4, aligned to 0x1000-bytes. The sharedmem ptr must be 0x1000-bytes aligned. The offical 3ds-sound app uses the following values for unk0-unk2: 3, 1, and 1.

proc MIC_Shutdown*(): Result
proc MIC_GetSharedMemOffsetValue*(): u32
proc MIC_ReadAudioData*(outbuf: ptr u8; readsize: u32; waitforevent: u32): u32
#Reads MIC audio data. When waitforevent is non-zero, this clears the event, then waits for MIC-module to signal it again when audio data is written to shared-mem. The return value is the actual byte-size of the read data.

proc MIC_MapSharedMem*(handle: Handle; size: u32): Result
proc MIC_UnmapSharedMem*(): Result
proc MIC_cmd3_Initialize*(unk0: u8; unk1: u8; sharedmem_baseoffset: u32;
                         sharedmem_endoffset: u32; unk2: u8): Result
proc MIC_cmd5*(): Result
proc MIC_GetCNTBit15*(`out`: ptr u8): Result
proc MIC_GetEventHandle*(handle: ptr Handle): Result
proc MIC_SetControl*(value: u8): Result
#See here: http://3dbrew.org/wiki/MIC_Services

proc MIC_GetControl*(value: ptr u8): Result
proc MIC_SetRecording*(value: u8): Result
proc MIC_IsRecoding*(value: ptr u8): Result