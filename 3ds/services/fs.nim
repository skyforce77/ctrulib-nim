#! @file FS.h
# 
#   Filesystem Services
# 
#! @defgroup fs_open_flags FS Open Flags
# 
#   @sa FSUSER_OpenFile
#   @sa FSUSER_OpenFileDirectly
# 
#   @{
# 
#! Open file for read. 

const
  FS_OPEN_READ* = (1 shl 0)

#! Open file for write. 

const
  FS_OPEN_WRITE* = (1 shl 1)

#! Create file if it doesn't exist. 

const
  FS_OPEN_CREATE* = (1 shl 2)

# @} 
#! @defgroup fs_create_attributes FS Create Attributes
# 
#   @sa FSUSER_OpenFile
#   @sa FSUSER_OpenFileDirectly
# 
#   @{
# 
#! No attributes. 

const
  FS_ATTRIBUTE_NONE* = (0x00000000)

#! Create with read-only attribute. 

const
  FS_ATTRIBUTE_READONLY* = (0x00000001)

#! Create with archive attribute. 

const
  FS_ATTRIBUTE_ARCHIVE* = (0x00000100)

#! Create with hidden attribute. 

const
  FS_ATTRIBUTE_HIDDEN* = (0x00010000)

#! Create with directory attribute. 

const
  FS_ATTRIBUTE_DIRECTORY* = (0x01000000)

#! @} 
#! @defgroup fs_write_flush_flags FS Flush Flags
# 
#   @sa FSFILE_Write
# 
#   @{
# 
#! Don't flush 

const
  FS_WRITE_NOFLUSH* = (0x00000000)

#! Flush 

const
  FS_WRITE_FLUSH* = (0x00010001)

# @} 
#! FS path type 

type
  FS_pathType* = enum
    PATH_INVALID = 0,           #!< Specifies an invalid path.
    PATH_EMPTY = 1,             #!< Specifies an empty path.
    PATH_BINARY = 2,            #!< Specifies a binary path, which is non-text based.
    PATH_CHAR = 3,              #!< Specifies a text based path with a 8-bit byte per character.
    PATH_WCHAR = 4              #!< Specifies a text based path with a 16-bit short per character.


#! FS archive ids 

type
  FS_archiveIds* = enum
    ARCH_ROMFS = 0x00000003, ARCH_SAVEDATA = 0x00000004, ARCH_EXTDATA = 0x00000006,
    ARCH_SHARED_EXTDATA = 0x00000007, ARCH_SYSTEM_SAVEDATA = 0x00000008,
    ARCH_SDMC = 0x00000009, ARCH_SDMC_WRITE_ONLY = 0x0000000A,
    ARCH_BOSS_EXTDATA = 0x12345678, ARCH_CARD_SPIFS = 0x12345679,
    ARCH_NAND_RW = 0x1234567D, ARCH_NAND_RO = 0x1234567E,
    ARCH_NAND_RO_WRITE_ACCESS = 0x1234567F


#! FS path 

type
  FS_path* = object
    `type`*: FS_pathType       #!< FS path type.
    size*: u32                 #!< FS path size.
    data*: ptr u8               #!< Pointer to FS path data.
  

#! FS archive 

type
  FS_archive* = object
    id*: u32                   #!< Archive ID.
    lowPath*: FS_path          #!< FS path.
    handleLow*: Handle         #!< High word of handle.
    handleHigh*: Handle        #!< Low word of handle.
  

#! Directory entry 

type
  FS_dirent* = object
    name*: array[0x00000106, u16] # 0x00
    #!< UTF-16 encoded name
    # 0x20C
    shortName*: array[0x00000009, u8] #!< 8.3 file name
                                   # 0x215
    unknown1*: u8              #!< ???
                # 0x216
    shortExt*: array[0x00000004, u8] #!< 8.3 file extension (set to spaces for directories)
                                  # 0x21A
    unknown2*: u8              #!< ???
                # 0x21B
    unknown3*: u8              #!< ???
                # 0x21C
    isDirectory*: u8           #!< directory bit
                   # 0x21D
    isHidden*: u8              #!< hidden bit
                # 0x21E
    isArchive*: u8             #!< archive bit
                 # 0x21F
    isReadOnly*: u8            #!< read-only bit
                  # 0x220
    fileSize*: u64             #!< file size
  

#! ProductInfo. These strings are not NULL-terminated. 

type
  FS_ProductInfo* = object
    product_code*: array[0x00000010, char]
    company_code*: array[0x00000002, char]
    remaster_version*: u16


proc fsInit*(): Result
proc fsExit*(): Result
proc fsGetSessionHandle*(): ptr Handle
proc FS_makePath*(`type`: FS_pathType; path: cstring): FS_path
proc FSUSER_Initialize*(handle: ptr Handle): Result
proc FSUSER_OpenArchive*(handle: ptr Handle; archive: ptr FS_archive): Result
proc FSUSER_OpenDirectory*(handle: ptr Handle; `out`: ptr Handle; archive: FS_archive;
                          dirLowPath: FS_path): Result
proc FSUSER_OpenFile*(handle: ptr Handle; `out`: ptr Handle; archive: FS_archive;
                     fileLowPath: FS_path; openflags: u32; attributes: u32): Result
proc FSUSER_OpenFileDirectly*(handle: ptr Handle; `out`: ptr Handle;
                             archive: FS_archive; fileLowPath: FS_path;
                             openflags: u32; attributes: u32): Result
proc FSUSER_CloseArchive*(handle: ptr Handle; archive: ptr FS_archive): Result
proc FSUSER_CreateFile*(handle: ptr Handle; archive: FS_archive; fileLowPath: FS_path;
                       fileSize: u32): Result
proc FSUSER_CreateDirectory*(handle: ptr Handle; archive: FS_archive;
                            dirLowPath: FS_path): Result
proc FSUSER_DeleteFile*(handle: ptr Handle; archive: FS_archive; fileLowPath: FS_path): Result
proc FSUSER_DeleteDirectory*(handle: ptr Handle; archive: FS_archive;
                            dirLowPath: FS_path): Result
proc FSUSER_DeleteDirectoryRecursively*(handle: ptr Handle; archive: FS_archive;
                                       dirLowPath: FS_path): Result
proc FSUSER_RenameFile*(handle: ptr Handle; srcArchive: FS_archive;
                       srcFileLowPath: FS_path; destArchive: FS_archive;
                       destFileLowPath: FS_path): Result
proc FSUSER_RenameDirectory*(handle: ptr Handle; srcArchive: FS_archive;
                            srcDirLowPath: FS_path; destArchive: FS_archive;
                            destDirLowPath: FS_path): Result
proc FSUSER_GetSdmcArchiveResource*(handle: ptr Handle; sectorSize: ptr u32;
                                   clusterSize: ptr u32; numClusters: ptr u32;
                                   freeClusters: ptr u32): Result
proc FSUSER_GetNandArchiveResource*(handle: ptr Handle; sectorSize: ptr u32;
                                   clusterSize: ptr u32; numClusters: ptr u32;
                                   freeClusters: ptr u32): Result
proc FSUSER_IsSdmcDetected*(handle: ptr Handle; detected: ptr u8): Result
proc FSUSER_IsSdmcWritable*(handle: ptr Handle; writable: ptr u8): Result
proc FSUSER_GetProductInfo*(handle: ptr Handle; processid: u32;
                           `out`: ptr FS_ProductInfo): Result
proc FSUSER_GetMediaType*(handle: ptr Handle; mediatype: ptr u8): Result
proc FSFILE_Close*(handle: Handle): Result
proc FSFILE_Read*(handle: Handle; bytesRead: ptr u32; offset: u64; buffer: pointer;
                 size: u32): Result
proc FSFILE_Write*(handle: Handle; bytesWritten: ptr u32; offset: u64; buffer: pointer;
                  size: u32; flushFlags: u32): Result
proc FSFILE_GetSize*(handle: Handle; size: ptr u64): Result
proc FSFILE_SetSize*(handle: Handle; size: u64): Result
proc FSFILE_GetAttributes*(handle: Handle; attributes: ptr u32): Result
proc FSFILE_SetAttributes*(handle: Handle; attributes: u32): Result
proc FSFILE_Flush*(handle: Handle): Result
proc FSDIR_Read*(handle: Handle; entriesRead: ptr u32; entrycount: u32;
                buffer: ptr FS_dirent): Result
proc FSDIR_Close*(handle: Handle): Result