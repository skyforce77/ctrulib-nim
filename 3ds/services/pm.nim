#
# Requires access to "pm:app" service
#

proc pmInit*(): Result {.cdecl, importc: "pmInit", header: "pm.h".}
proc pmExit*(): Result {.cdecl, importc: "pmExit", header: "pm.h".}
# PM_LaunchTitle()
#About: Launches a title
#
#  mediatype		mediatype of title
#  titleid		TitleId of title to launch
#  launch_flags	use if you know of any
#

proc PM_LaunchTitle*(mediatype: u8; titleid: u64; launch_flags: u32): Result {.cdecl,
    importc: "PM_LaunchTitle", header: "pm.h".}
# PM_GetTitleExheaderFlags()
#About: Writes to a buffer the launch flags (8 bytes) from a title exheader.
#
#  mediatype		mediatype of title
#  titleid		TitleId of title
#  out			ptr to where the flags should be written to
#

proc PM_GetTitleExheaderFlags*(mediatype: u8; titleid: u64; `out`: ptr u8): Result {.
    cdecl, importc: "PM_GetTitleExheaderFlags", header: "pm.h".}
# PM_SetFIRMLaunchParams()
#About: Sets the FIRM launch params from in
#
#  size			size of FIRM launch params
#  in			ptr to location of FIRM launch params
#

proc PM_SetFIRMLaunchParams*(size: u32; `in`: ptr u8): Result {.cdecl,
    importc: "PM_SetFIRMLaunchParams", header: "pm.h".}
# PM_GetFIRMLaunchParams()
#About: Sets the FIRM launch params from in
#
#  size			size of buffer to store FIRM launch params
#  out			ptr to location to write FIRM launch params
#

proc PM_GetFIRMLaunchParams*(size: u32; `out`: ptr u8): Result {.cdecl,
    importc: "PM_GetFIRMLaunchParams", header: "pm.h".}
# PM_SetFIRMLaunchParams()
#About: Same as PM_SetFIRMLaunchParams(), but also triggers a FIRM launch
#
#  firm_titleid_low	TitleID low of firm title to launch
#  size				size of FIRM launch params
#  in				ptr to location of FIRM launch params
#

proc PM_LaunchFIRMSetParams*(firm_titleid_low: u32; size: u32; `in`: ptr u8): Result {.
    cdecl, importc: "PM_LaunchFIRMSetParams", header: "pm.h".}