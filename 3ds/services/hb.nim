# WARNING ! THIS FILE PROVIDES AN INTERFACE TO A NON-OFFICIAL SERVICE PROVIDED BY NINJHAX
# BY USING COMMANDS FROM THIS SERVICE YOU WILL LIKELY MAKE YOUR APPLICATION INCOMPATIBLE WITH OTHER HOMEBREW LAUNCHING METHODS
# A GOOD WAY TO COPE WITH THIS IS TO CHECK THE OUTPUT OF initHb FOR ERRORS

proc hbInit*(): Result
proc hbExit*()
# flushes/invalidates entire data/instruction cache
# can be useful when writing code to executable pages

proc HB_FlushInvalidateCache*(): Result
# fetches the address for ninjhax bootloader addresses, useful for running 3dsx executables
# void (*callBootloader)(Handle hb, Handle file);
# void (*setArgs)(u32* src, u32 length);

proc HB_GetBootloaderAddresses*(load3dsx: ptr pointer; setArgv: ptr pointer): Result
# changes the permissions of a given number of pages at address addr to mode
# should it fail, the appropriate kernel error code will be returned and *reprotectedPages (if not NULL)
# will be set to the number of sequential pages which were successfully reprotected + 1

proc HB_ReprotectMemory*(`addr`: ptr u32; pages: u32; mode: u32;
                        reprotectedPages: ptr u32): Result