#*
#  @file os.h
# 
#  OS related stuff.
# 

template SYSTEM_VERSION*(major, minor, revision: expr): expr =
  (((major) shl 24) or ((minor) shl 16) or ((revision) shl 8))

template GET_VERSION_MAJOR*(version: expr): expr =
  ((version) shr 24)

template GET_VERSION_MINOR*(version: expr): expr =
  (((version) shr 16) and 0x000000FF)

template GET_VERSION_REVISION*(version: expr): expr =
  (((version) shr 8) and 0x000000FF)

#! OS_VersionBin. Format of the system version: "<major>.<minor>.<build>-<nupver><region>" 

type
  OS_VersionBin* {.importc: "OS_VersionBin", header: "os.h".} = object
    build* {.importc: "build".}: u8
    minor* {.importc: "minor".}: u8
    mainver* {.importc: "mainver".}: u8 #"major" in CVER, NUP version in NVer.
    reserved_x3* {.importc: "reserved_x3".}: u8
    region* {.importc: "region".}: char #"ASCII character for the system version region"
    reserved_x5* {.importc: "reserved_x5".}: array[0x00000003, u8]


#*
#  Converts an address from virtual (process) memory to physical memory.
#  It is sometimes required by services or when using the GPU command buffer.
# 

proc osConvertVirtToPhys*(vaddr: u32): u32 {.cdecl, importc: "osConvertVirtToPhys",
    header: "os.h".}
#*
#  Converts 0x14* vmem to 0x30*.
#  @return The input address when it's already within the new vmem.
#  @return 0 when outside of either LINEAR mem areas.
# 

proc osConvertOldLINEARMemToNew*(`addr`: u32): u32 {.cdecl,
    importc: "osConvertOldLINEARMemToNew", header: "os.h".}
#*
#  @brief Basic information about a service error.
#  @return A string of the summary of an error.
# 
#  This can be used to get some details about an error returned by a service call.
# 

proc osStrError*(error: u32): cstring {.cdecl, importc: "osStrError", header: "os.h".}
#*
#  @return the Firm version
# 
#  This can be used to compare system versions easily with @ref SYSTEM_VERSION.
# 

proc osGetFirmVersion*(): u32 {.cdecl, importc: "osGetFirmVersion", header: "os.h".}
#*
#  @return the kernel version
# 
#  This can be used to compare system versions easily with @ref SYSTEM_VERSION.
# 
#  @code
#  if(osGetKernelVersion() > SYSTEM_VERSION(2,46,0)) printf("You are running 9.0 or higher\n");
#  @endcode
# 

proc osGetKernelVersion*(): u32 {.cdecl, importc: "osGetKernelVersion", header: "os.h".}
#*
#  @return number of milliseconds since 1st Jan 1900 00:00.
# 

proc osGetTime*(): u64 {.cdecl, importc: "osGetTime", header: "os.h".}
#*
#  @brief Returns the Wifi signal strength.
# 
#  Valid values are 0-3:
#  - 0 means the singal strength is terrible or the 3DS is disconnected from
#    all networks.
#  - 1 means the signal strength is bad.
#  - 2 means the signal strength is decent.
#  - 3 means the signal strength is good.
# 
#  Values outside the range of 0-3 should never be returned.
# 
#  These values correspond with the number of wifi bars displayed by Home Menu.
# 
#  @return the Wifi signal strength
# 

proc osGetWifiStrength*(): u8 {.cdecl, importc: "osGetWifiStrength", header: "os.h".}
#*
#  @brief Configures the New 3DS speedup.
#  @param enable Specifies whether to enable or disable the speedup.
# 

proc osSetSpeedupEnable*(enable: bool) {.cdecl, importc: "osSetSpeedupEnable",
                                      header: "os.h".}
#*
#  @brief Gets the NAND system-version stored in NVer/CVer.
#  The romfs device must not be already initialized(via romfsInit*()) at the time this function is called, since this code uses the romfs device.
#  @param nver_versionbin Output OS_VersionBin structure for the data read from NVer.
#  @param cver_versionbin Output OS_VersionBin structure for the data read from CVer.
#  @return The result-code. This value can be positive if opening "romfs:/version.bin" fails with stdio, since errno would be returned in that case. In some cases the error can be special negative values as well.
# 

proc osGetSystemVersionData*(nver_versionbin: ptr OS_VersionBin;
                            cver_versionbin: ptr OS_VersionBin): Result {.cdecl,
    importc: "osGetSystemVersionData", header: "os.h".}
#*
#  @brief This is a wrapper for osGetSystemVersionData.
#  @param nver_versionbin Optional output OS_VersionBin structure for the data read from NVer, can be NULL.
#  @param cver_versionbin Optional output OS_VersionBin structure for the data read from CVer, can be NULL.
#  @param sysverstr Output string where the printed system-version will be written, in the same format displayed by the System Settings title.
#  @param sysverstr_maxsize Max size of the above string buffer, *including* NULL-terminator.
#  @return See osGetSystemVersionData.
# 

proc osGetSystemVersionDataString*(nver_versionbin: ptr OS_VersionBin;
                                  cver_versionbin: ptr OS_VersionBin;
                                  sysverstr: cstring; sysverstr_maxsize: u32): Result {.
    cdecl, importc: "osGetSystemVersionDataString", header: "os.h".}