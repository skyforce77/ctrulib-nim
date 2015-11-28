proc select*(nfds: cint; readfds: ptr fd_set; writefds: ptr fd_set;
            exceptfds: ptr fd_set; timeout: ptr timeval): cint {.cdecl,
    importc: "select", header: "select.h".}