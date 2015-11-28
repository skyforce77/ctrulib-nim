#
# Requires access to "ns:s" service
#

proc nsInit*(): Result {.cdecl, importc: "nsInit", header: "ns.h".}
proc nsExit*(): Result {.cdecl, importc: "nsExit", header: "ns.h".}
# NS_LaunchTitle()
#  titleid			TitleId of title to launch, if 0, gamecard assumed
#  launch_flags		use if you know of any
#  procid			ptr to where the process id of the launched title will be written to, leave a NULL, if you don't care
#

proc NS_LaunchTitle*(titleid: u64; launch_flags: u32; procid: ptr u32): Result {.cdecl,
    importc: "NS_LaunchTitle", header: "ns.h".}
# NS_RebootToTitle()
#  mediatype			mediatype for title
#  titleid			TitleId of title to launch
#

proc NS_RebootToTitle*(mediatype: u8; titleid: u64): Result {.cdecl,
    importc: "NS_RebootToTitle", header: "ns.h".}