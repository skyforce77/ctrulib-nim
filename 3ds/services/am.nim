#
# Requires access to "am:net" or "am:u" service
#

type
  TitleList* = object
    titleID*: u64
    size*: u64
    titleVersion*: u16
    unknown2*: array[6, u8]


proc amInit*(): Result
proc amExit*(): Result
proc amGetSessionHandle*(): ptr Handle = nil
# AM_GetTitleCount()
#About: Gets the number of titles for a given mediatype
#
#  mediatype		mediatype to get titles from
#  count			ptr to store title count
#

proc AM_GetTitleCount*(mediatype: u8; count: ptr u32): Result
# AM_GetTitleList()
#About: Writes a titleid list for a mediatype to a buffer
#
#  mediatype		mediatype to get list from
#  count			number of titleids to get
#  titleIDs	buffer to write titleids to
#

proc AM_GetTitleIdList*(mediatype: u8; count: u32; titleIDs: ptr u64): Result
# AM_GetDeviceId()
#About: Gets a 32bit device id, it's used for some key slot inits
#
#  device_id		ptr to where the device id is written to
#

proc AM_GetDeviceId*(deviceID: ptr u32): Result
# AM_ListTitles()
#About: Get a list with details about the installed titles
#
#  mediatype    mediatype of title
#  titleCount   number of titles to list
# titleIdList  pointer to a title ID list
# titleList    pointer for the output TitleList array
#

proc AM_ListTitles*(mediatype: u8; titleCount: u32; titleIdList: ptr u64;
                   titleList: ptr TitleList): Result
#*** Title Install Methods ***
# AM_StartCiaInstall()
#About: Inits CIA install process, the returned ciahandle is where the data for CIA should be written to
#
#  mediatype		mediatype to install CIA to
#  ciahandle		ptr to where the handle should be written to
#

proc AM_StartCiaInstall*(mediatype: u8; ciaHandle: ptr Handle): Result
# AM_StartDlpChildCiaInstall()
#About: Inits CIA install process, the returned ciahandle is where the data for CIA should be written to
#Note: This is for installing DLP CIAs only, mediatype is hardcoded to be NAND
#
#  ciahandle		ptr to where the handle should be written to
#

proc AM_StartDlpChildCiaInstall*(ciaHandle: ptr Handle): Result
# AM_CancelCIAInstall()
#About: Abort CIA install process
#
#  ciahandle		ptr to cia Handle provided by AM
#

proc AM_CancelCIAInstall*(ciaHandle: ptr Handle): Result
# AM_FinishCiaInstall()
#About: Once all data is written to the cia handle, this command signals AM to proceed with CIA install.
#Note: AM closes the cia handle provided here
#
#  mediatype		same mediatype specified ciahandle was obtained
#  ciahandle		ptr to cia Handle provided by AM
#

proc AM_FinishCiaInstall*(mediatype: u8; ciaHandle: ptr Handle): Result
#*** Title Delete Methods ***
# AM_DeleteTitle()
#About: Deletes any title on NAND/SDMC
#Note: AM closes the cia handle provided here
#
#  mediatype		mediatype of title
#  titleid		title id of title
#

proc AM_DeleteTitle*(mediatype: u8; titleID: u64): Result
# AM_DeleteAppTitle()
#About: Deletes any title on NAND/SDMC
#Note: If the title has the system category bit set, this will fail
#
#  mediatype		mediatype of title
#  titleid		title id of title
#

proc AM_DeleteAppTitle*(mediatype: u8; titleID: u64): Result
# AM_InstallNativeFirm()
#About: Installs NATIVE_FIRM to NAND (firm0:/ & firm1:/) from a CXI
#

proc AM_InstallNativeFirm*(): Result
# AM_GetTitleProductCode()
#About: Gets the product code of a title based on its title id.
#
#  mediatype		mediatype of title
#  titleid		title id of title
#  productcode           buffer to output the product code to (should have a length of 16)
#

proc AM_GetTitleProductCode*(mediatype: u8; titleID: u64; productCode: cstring): Result
# AM_GetCiaFileInfo()
#About: Reads a CIA file and returns a TitleList entry for it.
#
#  mediatype		destination mediatype
#  titleEntry		ptr to a TitleList entry
#  fileHandle		a fs:USER file handle for a CIA file
#

proc AM_GetCiaFileInfo*(mediatype: u8; titleEntry: ptr TitleList; fileHandle: Handle): Result
