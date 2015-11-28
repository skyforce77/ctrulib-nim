#*
#  @file svc.h
#  @brief Syscall wrappers.
#

import "3ds/types"

#/@name Memory management
#/@{
#*
#  @brief @ref svcControlMemory operation flags
#
#  The lowest 8 bits are the operation
#

type
  MemOp* {.size: sizeof(cint).} = enum
    MEMOP_FREE = 1,             #/< Memory un-mapping
    MEMOP_RESERVE = 2,          #/< Reserve memory
    MEMOP_ALLOC = 3,            #/< Memory mapping
    MEMOP_MAP = 4,              #/< Mirror mapping
    MEMOP_UNMAP = 5,            #/< Mirror unmapping
    MEMOP_PROT = 6,             #/< Change protection
    MEMOP_OP_MASK = 0x000000FF, MEMOP_REGION_APP = 0x00000100,
    MEMOP_REGION_SYSTEM = 0x00000200, MEMOP_REGION_BASE = 0x00000300,
    MEMOP_REGION_MASK = 0x00000F00, MEMOP_LINEAR_FLAG = 0x00010000, #/< Flag for linear memory operations
    MEMOP_ALLOC_LINEAR = 0x00010000 or 3
  MemState* {.size: sizeof(cint).} = enum
    MEMSTATE_FREE = 0, MEMSTATE_RESERVED = 1, MEMSTATE_IO = 2, MEMSTATE_STATIC = 3,
    MEMSTATE_CODE = 4, MEMSTATE_PRIVATE = 5, MEMSTATE_SHARED = 6,
    MEMSTATE_CONTINUOUS = 7, MEMSTATE_ALIASED = 8, MEMSTATE_ALIAS = 9,
    MEMSTATE_ALIASCODE = 10, MEMSTATE_LOCKED = 11



#*
#  @brief Memory permission flags
#

type
  MemPerm* {.size: sizeof(cint).} = enum
    MEMPERM_READ = 1, MEMPERM_WRITE = 2, MEMPERM_EXECUTE = 4,
    MEMPERM_DONTCARE = 0x10000000
  MemInfo* {.importc: "MemInfo", header: "svc.h".} = object
    base_addr* {.importc: "base_addr".}: u32
    size* {.importc: "size".}: u32
    perm* {.importc: "perm".}: u32 #/< See @ref MemPerm
    state* {.importc: "state".}: u32 #/< See @ref MemState

  PageInfo* {.importc: "PageInfo", header: "svc.h".} = object
    flags* {.importc: "flags".}: u32

  ArbitrationType* {.size: sizeof(cint).} = enum
    ARBITRATION_SIGNAL = 0,     #/< Signal #value threads for wake-up.
    ARBITRATION_WAIT_IF_LESS_THAN = 1, #/< If the memory at the address is strictly lower than #value, then wait for signal.
    ARBITRATION_DECREMENT_AND_WAIT_IF_LESS_THAN = 2, #/< If the memory at the address is strictly lower than #value, then decrement it and wait for signal.
    ARBITRATION_WAIT_IF_LESS_THAN_TIMEOUT = 3, #/< If the memory at the address is strictly lower than #value, then wait for signal or timeout.
    ARBITRATION_DECREMENT_AND_WAIT_IF_LESS_THAN_TIMEOUT = 4 #/< If the memory at the address is strictly lower than #value, then decrement it and wait for signal or timeout.



#/ Special value to signal all the threads

const
  ARBITRATION_SIGNAL_ALL* = (- 1)

#/@}
#/@name Multithreading
#/@{

type
  ThreadInfoType* {.size: sizeof(cint).} = enum
    THREADINFO_TYPE_UNKNOWN


#/@}
#/@name Debugging
#/@{

type
  INNER_C_UNION_9879052047195322384* {.importc: "no_name", header: "svc.h".} = object {.
      union.}
    process* {.importc: "process".}: ProcessEvent
    create_thread* {.importc: "create_thread".}: CreateThreadEvent
    exit_thread* {.importc: "exit_thread".}: ExitThreadEvent
    exit_process* {.importc: "exit_process".}: ExitProcessEvent
    exception* {.importc: "exception".}: ExceptionEvent # TODO: DLL_LOAD
                                                    # TODO: DLL_UNLOAD
    scheduler* {.importc: "scheduler".}: SchedulerInOutEvent
    syscall* {.importc: "syscall".}: SyscallInOutEvent
    output_string* {.importc: "output_string".}: OutputStringEvent
    map* {.importc: "map".}: MapEvent

  ProcessEventReason* {.size: sizeof(cint).} = enum
    REASON_CREATE = 1, REASON_ATTACH = 2
  ProcessEvent* {.importc: "ProcessEvent", header: "svc.h".} = object
    program_id* {.importc: "program_id".}: u64
    process_name* {.importc: "process_name".}: array[8, u8]
    process_id* {.importc: "process_id".}: u32
    reason* {.importc: "reason".}: u32 #/< See @ref ProcessEventReason

  ExitProcessEventReason* {.size: sizeof(cint).} = enum
    EXITPROCESS_EVENT_NONE = 0, EXITPROCESS_EVENT_TERMINATE = 1,
    EXITPROCESS_EVENT_UNHANDLED_EXCEPTION = 2
  ExitProcessEvent* {.importc: "ExitProcessEvent", header: "svc.h".} = object
    reason* {.importc: "reason".}: u32 #/< See @ref ExitProcessEventReason

  CreateThreadEvent* {.importc: "CreateThreadEvent", header: "svc.h".} = object
    creator_thread_id* {.importc: "creator_thread_id".}: u32
    base_addr* {.importc: "base_addr".}: u32
    entry_point* {.importc: "entry_point".}: u32

  ExitThreadEventReason* {.size: sizeof(cint).} = enum
    EXITTHREAD_EVENT_NONE = 0, EXITTHREAD_EVENT_TERMINATE = 1,
    EXITTHREAD_EVENT_UNHANDLED_EXC = 2, EXITTHREAD_EVENT_TERMINATE_PROCESS = 3
  ExitThreadEvent* {.importc: "ExitThreadEvent", header: "svc.h".} = object
    reason* {.importc: "reason".}: u32 #/< See @ref ExitThreadEventReason

  UserBreakType* {.size: sizeof(cint).} = enum
    USERBREAK_PANIC = 0, USERBREAK_ASSERT = 1, USERBREAK_USER = 2
  ExceptionEventType* {.size: sizeof(cint).} = enum
    EXC_EVENT_UNDEFINED_INSTRUCTION = 0, #/< arg: (None)
    EXC_EVENT_UNKNOWN1 = 1,     #/< arg: (None)
    EXC_EVENT_UNKNOWN2 = 2,     #/< arg: address
    EXC_EVENT_UNKNOWN3 = 3,     #/< arg: address
    EXC_EVENT_ATTACH_BREAK = 4, #/< arg: (None)
    EXC_EVENT_BREAKPOINT = 5,   #/< arg: (None)
    EXC_EVENT_USER_BREAK = 6,   #/< arg: @ref UserBreakType
    EXC_EVENT_DEBUGGER_BREAK = 7, #/< arg: (None)
    EXC_EVENT_UNDEFINED_SYSCALL = 8
  ExceptionEvent* {.importc: "ExceptionEvent", header: "svc.h".} = object
    `type`* {.importc: "type".}: u32 #/< See @ref ExceptionEventType
    address* {.importc: "address".}: u32
    argument* {.importc: "argument".}: u32 #/< See @ref ExceptionEventType

  SchedulerInOutEvent* {.importc: "SchedulerInOutEvent", header: "svc.h".} = object
    clock_tick* {.importc: "clock_tick".}: u64

  SyscallInOutEvent* {.importc: "SyscallInOutEvent", header: "svc.h".} = object
    clock_tick* {.importc: "clock_tick".}: u64
    syscall* {.importc: "syscall".}: u32

  OutputStringEvent* {.importc: "OutputStringEvent", header: "svc.h".} = object
    string_addr* {.importc: "string_addr".}: u32
    string_size* {.importc: "string_size".}: u32

  MapEvent* {.importc: "MapEvent", header: "svc.h".} = object
    mapped_addr* {.importc: "mapped_addr".}: u32
    mapped_size* {.importc: "mapped_size".}: u32
    memperm* {.importc: "memperm".}: u32
    memstate* {.importc: "memstate".}: u32

  DebugEventType* {.size: sizeof(cint).} = enum
    DBG_EVENT_PROCESS = 0, DBG_EVENT_CREATE_THREAD = 1, DBG_EVENT_EXIT_THREAD = 2,
    DBG_EVENT_EXIT_PROCESS = 3, DBG_EVENT_EXCEPTION = 4, DBG_EVENT_DLL_LOAD = 5,
    DBG_EVENT_DLL_UNLOAD = 6, DBG_EVENT_SCHEDULE_IN = 7, DBG_EVENT_SCHEDULE_OUT = 8,
    DBG_EVENT_SYSCALL_IN = 9, DBG_EVENT_SYSCALL_OUT = 10,
    DBG_EVENT_OUTPUT_STRING = 11, DBG_EVENT_MAP = 12
  DebugEventInfo* {.importc: "DebugEventInfo", header: "svc.h".} = object
    `type`* {.importc: "type".}: u32 #/< See @ref DebugEventType
    thread_id* {.importc: "thread_id".}: u32
    unknown* {.importc: "unknown".}: array[2, u32]
    ano_5195434559754685796* {.importc: "ano_5195434559754685796".}: INNER_C_UNION_9879052047195322384








#/@}
#
#static inline void* getThreadLocalStorage(void)
#{
# void* ret;
# __asm__ ("mrc p15, 0, %[data], c13, c0, 3" : [data] "=r" (ret));
# return ret;
#}
#

#//TODO Fix asm
#proc getThreadLocalStorage*(): ptr u32 {.inline.} =
#  var ret: pointer
#  asm "mrc p15, 0, %[data], c13, c0, 3\" : [data] \"=r\" (ret)"
#  return cast[ptr u32](cast[u32](getThreadLocalStorage()) + u32(0x00000080))

#proc getThreadCommandBuffer*(): ptr u32 {.inline, cdecl.} =
#  return cast[ptr u32](cast[u8](getThreadLocalStorage()) + 0x00000080)

#/@name Memory management
#/@{
#*
#  @brief Controls memory mapping
#  @param[out] addr_out The virtual address resulting from the operation. Usually the same as addr0.
#  @param addr0    The virtual address to be used for the operation.
#  @param addr1    The virtual address to be (un)mirrored by @p addr0 when using @ref MEMOP_MAP or @ref MEMOP_UNMAP.
#                  It has to be pointing to a RW memory.
#                  Use NULL if the operation is @ref MEMOP_FREE or @ref MEMOP_ALLOC.
#  @param size     The requested size for @ref MEMOP_ALLOC and @ref MEMOP_ALLOC_LINEAR.
#  @param op       Operation flags. See @ref MemOp.
#  @param perm     A combination of @ref MEMPERM_READ and @ref MEMPERM_WRITE. Using MEMPERM_EXECUTE will return an error.
#  			       Value 0 is used when unmapping memory.
#
#  If a memory is mapped for two or more addresses, you have to use MEMOP_UNMAP before being able to MEMOP_FREE it.
#  MEMOP_MAP will fail if @p addr1 was already mapped to another address.
#
#  More information is available at http://3dbrew.org/wiki/SVC#Memory_Mapping.
#
#  @sa svcControlProcessMemory
#

proc svcControlMemory*(addr_out: ptr u32; addr0: u32; addr1: u32; size: u32; op: MemOp;
                      perm: MemPerm): Result {.cdecl, importc: "svcControlMemory",
    header: "svc.h".}
#*
#  @brief Controls the memory mapping of a process
#  @param addr0 The virtual address to map
#  @param addr1 The virtual address to be mapped by @p addr0
#  @param type Only operations @ref MEMOP_MAP, @ref MEMOP_UNMAP and @ref MEMOP_PROT are allowed.
#
#  This is the only SVC which allows mapping executable memory.
#  Using @ref MEMOP_PROT will change the memory permissions of an already mapped memory.
#
#  @note The pseudo handle for the current process is not supported by this service call.
#  @sa svcControlProcess
#

proc svcControlProcessMemory*(process: Handle; addr0: u32; addr1: u32; size: u32;
                             `type`: u32; perm: u32): Result {.cdecl,
    importc: "svcControlProcessMemory", header: "svc.h".}
#*
#  @brief Creates a block of shared memory
#  @param memblock Pointer to store the handle of the block
#  @param addr Address of the memory to map, page-aligned. So its alignment must be 0x1000.
#  @param size Size of the memory to map, a multiple of 0x1000.
#  @param my_perm Memory permissions for the current process
#  @param my_perm Memory permissions for the other processes
#
#  @note The shared memory block, and its rights, are destroyed when the handle is closed.
#

proc svcCreateMemoryBlock*(memblock: ptr Handle; `addr`: u32; size: u32;
                          my_perm: MemPerm; other_perm: MemPerm): Result {.cdecl,
    importc: "svcCreateMemoryBlock", header: "svc.h".}
proc svcMapMemoryBlock*(memblock: Handle; `addr`: u32; my_perm: MemPerm;
                       other_perm: MemPerm): Result {.cdecl,
    importc: "svcMapMemoryBlock", header: "svc.h".}
proc svcMapProcessMemory*(process: Handle; startAddr: u32; endAddr: u32): Result {.
    cdecl, importc: "svcMapProcessMemory", header: "svc.h".}
proc svcUnmapProcessMemory*(process: Handle; startAddr: u32; endAddr: u32): Result {.
    cdecl, importc: "svcUnmapProcessMemory", header: "svc.h".}
proc svcUnmapMemoryBlock*(memblock: Handle; `addr`: u32): Result {.cdecl,
    importc: "svcUnmapMemoryBlock", header: "svc.h".}
proc svcStartInterProcessDma*(dma: ptr Handle; dstProcess: Handle; dst: pointer;
                             srcProcess: Handle; src: pointer; size: u32;
                             dmaConfig: pointer): Result {.cdecl,
    importc: "svcStartInterProcessDma", header: "svc.h".}
proc svcStopDma*(dma: Handle): Result {.cdecl, importc: "svcStopDma", header: "svc.h".}
proc svcGetDmaState*(dmaState: pointer; dma: Handle): Result {.cdecl,
    importc: "svcGetDmaState", header: "svc.h".}
#*
#  @brief Memory information query
#  @param addr Virtual memory address
#

proc svcQueryMemory*(info: ptr MemInfo; `out`: ptr PageInfo; `addr`: u32): Result {.cdecl,
    importc: "svcQueryMemory", header: "svc.h".}
proc svcQueryProcessMemory*(info: ptr MemInfo; `out`: ptr PageInfo; process: Handle;
                           `addr`: u32): Result {.cdecl,
    importc: "svcQueryProcessMemory", header: "svc.h".}
proc svcInvalidateProcessDataCache*(process: Handle; `addr`: pointer; size: u32): Result {.
    cdecl, importc: "svcInvalidateProcessDataCache", header: "svc.h".}
proc svcFlushProcessDataCache*(process: Handle; `addr`: pointer; size: u32): Result {.
    cdecl, importc: "svcFlushProcessDataCache", header: "svc.h".}
proc svcReadProcessMemory*(buffer: pointer; debug: Handle; `addr`: u32; size: u32): Result {.
    cdecl, importc: "svcReadProcessMemory", header: "svc.h".}
proc svcWriteProcessMemory*(debug: Handle; buffer: pointer; `addr`: u32; size: u32): Result {.
    cdecl, importc: "svcWriteProcessMemory", header: "svc.h".}
#/@}
#/@name Process management
#/@{
#*
#  @brief Gets the handle of a process.
#  @param[out] process   The handle of the process
#  @param      processId The ID of the process to open
#

proc svcOpenProcess*(process: ptr Handle; processId: u32): Result {.cdecl,
    importc: "svcOpenProcess", header: "svc.h".}
proc svcExitProcess*() {.cdecl, importc: "svcExitProcess", header: "svc.h".}
proc svcTerminateProcess*(process: Handle): Result {.cdecl,
    importc: "svcTerminateProcess", header: "svc.h".}
proc svcGetProcessInfo*(`out`: ptr s64; process: Handle; `type`: u32): Result {.cdecl,
    importc: "svcGetProcessInfo", header: "svc.h".}
proc svcGetProcessId*(`out`: ptr u32; handle: Handle): Result {.cdecl,
    importc: "svcGetProcessId", header: "svc.h".}
proc svcGetProcessList*(processCount: ptr s32; processIds: ptr u32;
                       processIdMaxCount: s32): Result {.cdecl,
    importc: "svcGetProcessList", header: "svc.h".}
proc svcCreatePort*(portServer: ptr Handle; portClient: ptr Handle; name: cstring;
                   maxSessions: s32): Result {.cdecl, importc: "svcCreatePort",
    header: "svc.h".}
proc svcConnectToPort*(`out`: ptr Handle; portName: cstring): Result {.cdecl,
    importc: "svcConnectToPort", header: "svc.h".}
#/@}
#/@name Multithreading
#/@{
#*
#  @brief Creates a new thread.
#  @param[out] thread     The thread handle
#  @param entrypoint      The function that will be called first upon thread creation
#  @param arg             The argument passed to @p entrypoint
#  @param stack_top       The top of the thread's stack. Must be 0x8 bytes mem-aligned.
#  @param thread_priority Low values gives the thread higher priority.
#                         For userland apps, this has to be within the range [0x18;0x3F]
#  @param processor_id    The id of the processor the thread should be ran on. Those are labelled starting from 0.
#                         For old 3ds it has to be <2, and for new 3DS <4.
#                         Value -1 means all CPUs and -2 read from the Exheader.
#
#  The processor with ID 1 is the system processor.
#  To enable multi-threading on this core you need to call APT_SetAppCpuTimeLimit at least once with a non-zero value.
#
#  Since a thread is considered as a waitable object, you can use @ref svcWaitSynchronization
#  and @ref svcWaitSynchronizationN to join with it.
#
#  @note The kernel will clear the @p stack_top's address low 3 bits to make sure it is 0x8-bytes aligned.
#

proc svcCreateThread*(thread: ptr Handle; entrypoint: ThreadFunc; arg: u32;
                     stack_top: ptr u32; thread_priority: s32; processor_id: s32): Result {.
    cdecl, importc: "svcCreateThread", header: "svc.h".}
#*
#  @brief Gets the handle of a thread.
#  @param[out] thread  The handle of the thread
#  @param      process The ID of the process linked to the thread
#

proc svcOpenThread*(thread: ptr Handle; process: Handle; threadId: u32): Result {.cdecl,
    importc: "svcOpenThread", header: "svc.h".}
#*
#  @brief Exits the current thread.
#
#  This will trigger a state change and hence release all @ref svcWaitSynchronization operations.
#  It means that you can join a thread by calling @code svcWaitSynchronization(threadHandle,yourtimeout); @endcode
#

proc svcExitThread*() {.cdecl, importc: "svcExitThread", header: "svc.h".}
#*
#  @brief Puts the current thread to sleep.
#  @param ns The minimum number of nanoseconds to sleep for.
#

proc svcSleepThread*(ns: s64) {.cdecl, importc: "svcSleepThread", header: "svc.h".}
#*
#  @brief Retrieves the priority of a thread.
#

proc svcGetThreadPriority*(`out`: ptr s32; handle: Handle): Result {.cdecl,
    importc: "svcGetThreadPriority", header: "svc.h".}
#*
#  @brief Changes the priority of a thread
#  @param prio For userland apps, this has to be within the range [0x18;0x3F]
#
#  Low values gives the thread higher priority.
#

proc svcSetThreadPriority*(thread: Handle; prio: s32): Result {.cdecl,
    importc: "svcSetThreadPriority", header: "svc.h".}
proc svcGetThreadAffinityMask*(affinitymask: ptr u8; thread: Handle;
                              processorcount: s32): Result {.cdecl,
    importc: "svcGetThreadAffinityMask", header: "svc.h".}
proc svcSetThreadAffinityMask*(thread: Handle; affinitymask: ptr u8;
                              processorcount: s32): Result {.cdecl,
    importc: "svcSetThreadAffinityMask", header: "svc.h".}
proc svcGetThreadIdealProcessor*(processorid: ptr s32; thread: Handle): Result {.cdecl,
    importc: "svcGetThreadIdealProcessor", header: "svc.h".}
proc svcSetThreadIdealProcessor*(thread: Handle; processorid: s32): Result {.cdecl,
    importc: "svcSetThreadIdealProcessor", header: "svc.h".}
#*
#  @brief Returns the ID of the processor the current thread is running on.
#  @sa svcCreateThread
#

proc svcGetProcessorID*(): s32 {.cdecl, importc: "svcGetProcessorID", header: "svc.h".}
#*
#  @param out The thread ID of the thread @p handle.
#

proc svcGetThreadId*(`out`: ptr u32; handle: Handle): Result {.cdecl,
    importc: "svcGetThreadId", header: "svc.h".}
#*
#  @param out The process ID of the thread @p handle.
#  @sa svcOpenProcess
#

proc svcGetProcessIdOfThread*(`out`: ptr u32; handle: Handle): Result {.cdecl,
    importc: "svcGetProcessIdOfThread", header: "svc.h".}
#*
#  @brief Checks if a thread handle is valid.
#  This requests always return an error when called, it only checks if the handle is a thread or not.
#  @return 0xD8E007ED (BAD_ENUM) if the Handle is a Thread Handle
#  @return 0xD8E007F7 (BAD_HANDLE) if it isn't.
#

proc svcGetThreadInfo*(`out`: ptr s64; thread: Handle; `type`: ThreadInfoType): Result {.
    cdecl, importc: "svcGetThreadInfo", header: "svc.h".}
#/@}
#/@name Synchronization
#/@{

proc svcCreateMutex*(mutex: ptr Handle; initially_locked: bool): Result {.cdecl,
    importc: "svcCreateMutex", header: "svc.h".}
proc svcReleaseMutex*(handle: Handle): Result {.cdecl, importc: "svcReleaseMutex",
    header: "svc.h".}
proc svcCreateSemaphore*(semaphore: ptr Handle; initial_count: s32; max_count: s32): Result {.
    cdecl, importc: "svcCreateSemaphore", header: "svc.h".}
proc svcReleaseSemaphore*(count: ptr s32; semaphore: Handle; release_count: s32): Result {.
    cdecl, importc: "svcReleaseSemaphore", header: "svc.h".}
proc svcCreateEvent*(event: ptr Handle; reset_type: u8): Result {.cdecl,
    importc: "svcCreateEvent", header: "svc.h".}
proc svcSignalEvent*(handle: Handle): Result {.cdecl, importc: "svcSignalEvent",
    header: "svc.h".}
proc svcClearEvent*(handle: Handle): Result {.cdecl, importc: "svcClearEvent",
    header: "svc.h".}
proc svcWaitSynchronization*(handle: Handle; nanoseconds: s64): Result {.cdecl,
    importc: "svcWaitSynchronization", header: "svc.h".}
proc svcWaitSynchronizationN*(`out`: ptr s32; handles: ptr Handle; handles_num: s32;
                             wait_all: bool; nanoseconds: s64): Result {.cdecl,
    importc: "svcWaitSynchronizationN", header: "svc.h".}
#*
#  @brief Creates an address arbiter
#  @sa svcArbitrateAddress
#

proc svcCreateAddressArbiter*(arbiter: ptr Handle): Result {.cdecl,
    importc: "svcCreateAddressArbiter", header: "svc.h".}
#*
#  @brief Arbitrate an address, can be used for synchronization
#  @param arbiter Handle of the arbiter
#  @param addr A pointer to a s32 value.
#  @param type Type of action to be performed by the arbiter
#  @param value Number of threads to signal if using @ref ARBITRATION_SIGNAL, or the value used for comparison.
#
#  This will perform an arbitration based on #type. The comparisons are done between #value and the value at the address #addr.
#
#  @code
#  s32 val=0;
#  // Does *nothing* since val >= 0
#  svcCreateAddressArbiter(arbiter,&val,ARBITRATION_WAIT_IF_LESS_THAN,0,0);
#  // Thread will wait for a signal or wake up after 10000000 nanoseconds because val < 1.
#  svcCreateAddressArbiter(arbiter,&val,ARBITRATION_WAIT_IF_LESS_THAN_TIMEOUT,1,10000000ULL);
#  @endcode
#

proc svcArbitrateAddress*(arbiter: Handle; `addr`: u32; `type`: ArbitrationType;
                         value: s32; nanoseconds: s64): Result {.cdecl,
    importc: "svcArbitrateAddress", header: "svc.h".}
proc svcSendSyncRequest*(session: Handle): Result {.cdecl,
    importc: "svcSendSyncRequest", header: "svc.h".}
proc svcAcceptSession*(session: ptr Handle; port: Handle): Result {.cdecl,
    importc: "svcAcceptSession", header: "svc.h".}
proc svcReplyAndReceive*(index: ptr s32; handles: ptr Handle; handleCount: s32;
                        replyTarget: Handle): Result {.cdecl,
    importc: "svcReplyAndReceive", header: "svc.h".}
#/@}
#/@name Time
#/@{

proc svcCreateTimer*(timer: ptr Handle; reset_type: u8): Result {.cdecl,
    importc: "svcCreateTimer", header: "svc.h".}
proc svcSetTimer*(timer: Handle; initial: s64; interval: s64): Result {.cdecl,
    importc: "svcSetTimer", header: "svc.h".}
proc svcCancelTimer*(timer: Handle): Result {.cdecl, importc: "svcCancelTimer",
    header: "svc.h".}
proc svcClearTimer*(timer: Handle): Result {.cdecl, importc: "svcClearTimer",
    header: "svc.h".}
proc svcGetSystemTick*(): u64 {.cdecl, importc: "svcGetSystemTick", header: "svc.h".}
#/@}
#/@name System
#/@{

proc svcCloseHandle*(handle: Handle): Result {.cdecl, importc: "svcCloseHandle",
    header: "svc.h".}
proc svcDuplicateHandle*(`out`: ptr Handle; original: Handle): Result {.cdecl,
    importc: "svcDuplicateHandle", header: "svc.h".}
proc svcGetSystemInfo*(`out`: ptr s64; `type`: u32; param: s32): Result {.cdecl,
    importc: "svcGetSystemInfo", header: "svc.h".}
proc svcKernelSetState*(`type`: u32; param0: u32; param1: u32; param2: u32): Result {.
    cdecl, importc: "svcKernelSetState", header: "svc.h".}
#/@}
#/@name Debugging
#/@{

proc svcBreak*(breakReason: UserBreakType) {.cdecl, importc: "svcBreak",
    header: "svc.h".}
proc svcOutputDebugString*(str: cstring; length: cint): Result {.cdecl,
    importc: "svcOutputDebugString", header: "svc.h".}
proc svcDebugActiveProcess*(debug: ptr Handle; processId: u32): Result {.cdecl,
    importc: "svcDebugActiveProcess", header: "svc.h".}
proc svcBreakDebugProcess*(debug: Handle): Result {.cdecl,
    importc: "svcBreakDebugProcess", header: "svc.h".}
proc svcTerminateDebugProcess*(debug: Handle): Result {.cdecl,
    importc: "svcTerminateDebugProcess", header: "svc.h".}
proc svcGetProcessDebugEvent*(info: ptr DebugEventInfo; debug: Handle): Result {.cdecl,
    importc: "svcGetProcessDebugEvent", header: "svc.h".}
proc svcContinueDebugEvent*(debug: Handle; flags: u32): Result {.cdecl,
    importc: "svcContinueDebugEvent", header: "svc.h".}
#/@}

proc svcBackdoor*(callback: proc (): s32 {.cdecl.}): Result {.cdecl,
    importc: "svcBackdoor", header: "svc.h".}
