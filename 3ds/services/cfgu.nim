type
  CFG_Region* = enum
    CFG_REGION_JPN = 0, CFG_REGION_USA = 1, CFG_REGION_EUR = 2, CFG_REGION_AUS = 3,
    CFG_REGION_CHN = 4, CFG_REGION_KOR = 5, CFG_REGION_TWN = 6
  CFG_Langage* = enum
    CFG_LANGUAGE_JP = 0, CFG_LANGUAGE_EN = 1, CFG_LANGUAGE_FR = 2, CFG_LANGUAGE_DE = 3,
    CFG_LANGUAGE_IT = 4, CFG_LANGUAGE_ES = 5, CFG_LANGUAGE_ZH = 6, CFG_LANGUAGE_KO = 7,
    CFG_LANGUAGE_NL = 8, CFG_LANGUAGE_PT = 9, CFG_LANGUAGE_RU = 10, CFG_LANGUAGE_TW = 11



proc initCfgu*(): Result
proc exitCfgu*(): Result
proc CFGU_SecureInfoGetRegion*(region: ptr u8): Result
proc CFGU_GenHashConsoleUnique*(appIDSalt: u32; hash: ptr u64): Result
proc CFGU_GetRegionCanadaUSA*(value: ptr u8): Result
proc CFGU_GetSystemModel*(model: ptr u8): Result
proc CFGU_GetModelNintendo2DS*(value: ptr u8): Result
proc CFGU_GetCountryCodeString*(code: u16; string: ptr u16): Result
proc CFGU_GetCountryCodeID*(string: u16; code: ptr u16): Result
proc CFGU_GetConfigInfoBlk2*(size: u32; blkID: u32; outData: ptr u8): Result
proc CFGU_GetSystemLanguage*(language: ptr u8): Result