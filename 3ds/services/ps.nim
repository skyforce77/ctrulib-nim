type
  ps_aes_algo* {.size: sizeof(cint).} = enum
    ps_CBC_ENC, ps_CBC_DEC, ps_CTR_ENC, ps_CTR_DEC, ps_CCM_ENC, ps_CCM_DEC
  ps_aes_keytypes* {.size: sizeof(cint).} = enum
    ps_KEYSLOT_0D, ps_KEYSLOT_2D, ps_KEYSLOT_31, ps_KEYSLOT_38, ps_KEYSLOT_32,
    ps_KEYSLOT_39_DLP, ps_KEYSLOT_2E, ps_KEYSLOT_INVALID, ps_KEYSLOT_36,
    ps_KEYSLOT_39_NFC



#
# Requires access to "ps:ps" service
#

proc psInit*(): Result {.cdecl, importc: "psInit", header: "ps.h".}
proc psExit*(): Result {.cdecl, importc: "psExit", header: "ps.h".}
# PS_EncryptDecryptAes()
#About: Is an interface for the AES Engine, you can only use predetermined keyslots though.
#Note: Does not support AES CCM, see PS_EncryptSignDecryptVerifyAesCcm()
#
#  size			size of data
#  in			input buffer ptr
#  out			output buffer ptr
#  aes_algo		AES Algorithm to use, see ps_aes_algo
#  key_type		see ps_aes_keytypes
#  iv			ptr to the CTR/IV (This is updated before returning)
#

proc PS_EncryptDecryptAes*(size: u32; `in`: ptr u8; `out`: ptr u8; aes_algo: u32;
                          key_type: u32; iv: ptr u8): Result {.cdecl,
    importc: "PS_EncryptDecryptAes", header: "ps.h".}
# PS_EncryptSignDecryptVerifyAesCcm()
#About: Is an interface for the AES Engine (CCM Encrypt/Decrypt only), you can only use predetermined keyslots though.
#Note: When encrypting, the output buffer size must include the MAC size, when decrypting, the input buffer size must include MAC size.
#MAC: When decrypting, if the MAC is invalid, 0xC9010401 is returned. After encrypting the MAC is located at inputbufptr+(totalassocdata+totaldatasize)
#
#  in			input buffer ptr
#  in_size		size of input buffer
#  out			output buffer ptr
#  out_size		size of output buffer
#  data_len		length of data to be crypted
#  mac_data_len	length of data associated with MAC
#  mac_len		length of MAC
#  aes_algo		AES Algorithm to use, see ps_aes_algo
#  key_type		see ps_aes_keytypes
#  nonce			ptr to the nonce
#

proc PS_EncryptSignDecryptVerifyAesCcm*(`in`: ptr u8; in_size: u32; `out`: ptr u8;
                                       out_size: u32; data_len: u32;
                                       mac_data_len: u32; mac_len: u32;
                                       aes_algo: u32; key_type: u32; nonce: ptr u8): Result {.
    cdecl, importc: "PS_EncryptSignDecryptVerifyAesCcm", header: "ps.h".}
# PS_GetLocalFriendCodeSeed()
#About: Gets a 64bit console id, it's used for some key slot inits
#
#  seed			ptr to where the seed is written to
#

proc PS_GetLocalFriendCodeSeed*(seed: ptr u64): Result {.cdecl,
    importc: "PS_GetLocalFriendCodeSeed", header: "ps.h".}
# PS_GetDeviceId()
#About: Gets a 32bit device id, it's used for some key slot inits
#
#  device_id		ptr to where the device id is written to
#

proc PS_GetDeviceId*(device_id: ptr u32): Result {.cdecl, importc: "PS_GetDeviceId",
    header: "ps.h".}