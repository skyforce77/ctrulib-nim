#*
#  @file svc.h
#  @brief Syscall wrappers.
#

#/@name Memory management
#/@{
#*
#  @brief @ref svcControlMemory operation flags
#
#  The lowest 8 bits are the operation
#

type
  MemOp* = enum
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
  MemState* = enum
    MEMSTATE_FREE = 0, MEMSTATE_RESERVED = 1, MEMSTATE_IO = 2, MEMSTATE_STATIC = 3,
    MEMSTATE_CODE = 4, MEMSTATE_PRIVATE = 5, MEMSTATE_SHARED = 6,
    MEMSTATE_CONTINUOUS = 7, MEMSTATE_ALIASED = 8, MEMSTATE_ALIAS = 9,
    MEMSTATE_ALIASCODE = 10, MEMSTATE_LOCKED = 11



#*
#  @brief Memory permission flags
#

type
  MemPerm* = enum
    MEMPERM_READ = 1, MEMPERM_WRITE = 2, MEMPERM_EXECUTE = 4,
    MEMPERM_DONTCARE = 0x10000000
  MemInfo* = object
    base_addr*: u32
    size*: u32
    perm*: u32                 #/< See @ref MemPerm
    state*: u32                #/< See @ref MemState

  PageInfo* = object
    flags*: u32

  ArbitrationType* = enum
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
  ThreadInfoType* = enum
    THREADINFO_TYPE_UNKNOWN


#/@}
#/@name Debugging
#/@{

type
  INNER_C_UNION_9879052047195322384* = object {.union.}
    process*: ProcessEvent
    create_thread*: CreateThreadEvent
    exit_thread*: ExitThreadEvent
    exit_process*: ExitProcessEvent
    exception*: ExceptionEvent # TODO: DLL_LOAD
                             # TODO: DLL_UNLOAD
    scheduler*: SchedulerInOutEvent
    syscall*: SyscallInOutEvent
    output_string*: OutputStringEvent
    map*: MapEvent

  ProcessEventReason* = enum
    REASON_CREATE = 1, REASON_ATTACH = 2
  ProcessEvent* = object
    program_id*: u64
    process_name*: array[8, u8]
    process_id*: u32
    reason*: u32               #/< See @ref ProcessEventReason

  ExitProcessEventReason* = enum
    EXITPROCESS_EVENT_NONE = 0, EXITPROCESS_EVENT_TERMINATE = 1,
    EXITPROCESS_EVENT_UNHANDLED_EXCEPTION = 2
  ExitProcessEvent* = object
    reason*: u32               #/< See @ref ExitProcessEventReason

  CreateThreadEvent* = object
    creator_thread_id*: u32
    base_addr*: u32
    entry_point*: u32

  ExitThreadEventReason* = enum
    EXITTHREAD_EVENT_NONE = 0, EXITTHREAD_EVENT_TERMINATE = 1,
    EXITTHREAD_EVENT_UNHANDLED_EXC = 2, EXITTHREAD_EVENT_TERMINATE_PROCESS = 3
  ExitThreadEvent* = object
    reason*: u32               #/< See @ref ExitThreadEventReason

  UserBreakType* = enum
    USERBREAK_PANIC = 0, USERBREAK_ASSERT = 1, USERBREAK_USER = 2
  ExceptionEventType* = enum
    EXC_EVENT_UNDEFINED_INSTRUCTION = 0, #/< arg: (None)
    EXC_EVENT_UNKNOWN1 = 1,     #/< arg: (None)
    EXC_EVENT_UNKNOWN2 = 2,     #/< arg: address
    EXC_EVENT_UNKNOWN3 = 3,     #/< arg: address
    EXC_EVENT_ATTACH_BREAK = 4, #/< arg: (None)
    EXC_EVENT_BREAKPOINT = 5,   #/< arg: (None)
    EXC_EVENT_USER_BREAK = 6,   #/< arg: @ref UserBreakType
    EXC_EVENT_DEBUGGER_BREAK = 7, #/< arg: (None)
    EXC_EVENT_UNDEFINED_SYSCALL = 8
  ExceptionEvent* = object
    `type`*: u32               #/< See @ref ExceptionEventType
    address*: u32
    argument*: u32             #/< See @ref ExceptionEventType

  SchedulerInOutEvent* = object
    clock_tick*: u64

  SyscallInOutEvent* = object
    clock_tick*: u64
    syscall*: u32

  OutputStringEvent* = object
    string_addr*: u32
    string_size*: u32

  MapEvent* = object
    mapped_addr*: u32
    mapped_size*: u32
    memperm*: u32
    memstate*: u32

  DebugEventType* = enum
    DBG_EVENT_PROCESS = 0, DBG_EVENT_CREATE_THREAD = 1, DBG_EVENT_EXIT_THREAD = 2,
    DBG_EVENT_EXIT_PROCESS = 3, DBG_EVENT_EXCEPTION = 4, DBG_EVENT_DLL_LOAD = 5,
    DBG_EVENT_DLL_UNLOAD = 6, DBG_EVENT_SCHEDULE_IN = 7, DBG_EVENT_SCHEDULE_OUT = 8,
    DBG_EVENT_SYSCALL_IN = 9, DBG_EVENT_SYSCALL_OUT = 10,
    DBG_EVENT_OUTPUT_STRING = 11, DBG_EVENT_MAP = 12
  DebugEventInfo* = object
    `type`*: u32               #/< See @ref DebugEventType
    thread_id*: u32
    unknown*: array[2, u32]
    ano_5195434559754685796*: INNER_C_UNION_9879052047195322384








#/@}
#static inline void* getThreadLocalStorage(void)
#{
# void* ret;
# __asm__ ("mrc p15, 0, %[data], c13, c0, 3" : [data] "=r" (ret));
# return ret;
#}

#TODO
#proc getThreadLocalStorage*(): ptr u32 {.inline.} =
#  var ret: pointer
#  asm """mrc p15, 0, %[data], c13, c0, 3" : [data] "=r" (ret)"""
#  return cast[ptr u32](u32(getThreadLocalStorage()) + u32(0x00000080))
#
#proc getThreadCommandBuffer*(): ptr u32 {.inline.} =
#  return cast[ptr u32](u32(getThreadLocalStorage()) + u32(0x00000080))

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
                      perm: MemPerm): Result
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
                             `type`: u32; perm: u32): Result
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
                          my_perm: MemPerm; other_perm: MemPerm): Result
proc svcMapMemoryBlock*(memblock: Handle; `addr`: u32; my_perm: MemPerm;
                       other_perm: MemPerm): Result
proc svcMapProcessMemory*(process: Handle; startAddr: u32; endAddr: u32): Result
proc svcUnmapProcessMemory*(process: Handle; startAddr: u32; endAddr: u32): Result
proc svcUnmapMemoryBlock*(memblock: Handle; `addr`: u32): Result
proc svcStartInterProcessDma*(dma: ptr Handle; dstProcess: Handle; dst: pointer;
                             srcProcess: Handle; src: pointer; size: u32;
                             dmaConfig: pointer): Result
proc svcStopDma*(dma: Handle): Result
proc svcGetDmaState*(dmaState: pointer; dma: Handle): Result
#*
#  @brief Memory information query
#  @param addr Virtual memory address
#

proc svcQueryMemory*(info: ptr MemInfo; `out`: ptr PageInfo; `addr`: u32): Result
proc svcQueryProcessMemory*(info: ptr MemInfo; `out`: ptr PageInfo; process: Handle;
                           `addr`: u32): Result
proc svcInvalidateProcessDataCache*(process: Handle; `addr`: pointer; size: u32): Result = 0
proc svcFlushProcessDataCache*(process: Handle; `addr`: pointer; size: u32): Result = 0
proc svcReadProcessMemory*(buffer: pointer; debug: Handle; `addr`: u32; size: u32): Result
proc svcWriteProcessMemory*(debug: Handle; buffer: pointer; `addr`: u32; size: u32): Result
#/@}
#/@name Process management
#/@{
#*
#  @brief Gets the handle of a process.
#  @param[out] process   The handle of the process
#  @param      processId The ID of the process to open
#

proc svcOpenProcess*(process: ptr Handle; processId: u32): Result
proc svcExitProcess*()
proc svcTerminateProcess*(process: Handle): Result
proc svcGetProcessInfo*(`out`: ptr s64; process: Handle; `type`: u32): Result = 0
proc svcGetProcessId*(`out`: ptr u32; handle: Handle): Result
proc svcGetProcessList*(processCount: ptr s32; processIds: ptr u32;
                       processIdMaxCount: s32): Result
proc svcCreatePort*(portServer: ptr Handle; portClient: ptr Handle; name: cstring;
                   maxSessions: s32): Result
proc svcConnectToPort*(`out`: ptr Handle; portName: cstring): Result
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
                     stack_top: ptr u32; thread_priority: s32; processor_id: s32): Result
#*
#  @brief Gets the handle of a thread.
#  @param[out] thread  The handle of the thread
#  @param      process The ID of the process linked to the thread
#

proc svcOpenThread*(thread: ptr Handle; process: Handle; threadId: u32): Result
#*
#  @brief Exits the current thread.
#
#  This will trigger a state change and hence release all @ref svcWaitSynchronization operations.
#  It means that you can join a thread by calling @code svcWaitSynchronization(threadHandle,yourtimeout); @endcode
#

proc svcExitThread*()
#*
#  @brief Puts the current thread to sleep.
#  @param ns The minimum number of nanoseconds to sleep for.
#

proc svcSleepThread*(ns: s64)
#*
#  @brief Retrieves the priority of a thread.
#

proc svcGetThreadPriority*(`out`: ptr s32; handle: Handle): Result
#*
#  @brief Changes the priority of a thread
#  @param prio For userland apps, this has to be within the range [0x18;0x3F]
#
#  Low values gives the thread higher priority.
#

proc svcSetThreadPriority*(thread: Handle; prio: s32): Result = 0
proc svcGetThreadAffinityMask*(affinitymask: ptr u8; thread: Handle;
                              processorcount: s32): Result
proc svcSetThreadAffinityMask*(thread: Handle; affinitymask: ptr u8;
                              processorcount: s32): Result
proc svcGetThreadIdealProcessor*(processorid: ptr s32; thread: Handle): Result
proc svcSetThreadIdealProcessor*(thread: Handle; processorid: s32): Result
#*
#  @brief Returns the ID of the processor the current thread is running on.
#  @sa svcCreateThread
#

proc svcGetProcessorID*(): s32
#*
#  @param out The thread ID of the thread @p handle.
#

proc svcGetThreadId*(`out`: ptr u32; handle: Handle): Result
#*
#  @param out The process ID of the thread @p handle.
#  @sa svcOpenProcess
#

proc svcGetProcessIdOfThread*(`out`: ptr u32; handle: Handle): Result
#*
#  @brief Checks if a thread handle is valid.
#  This requests always return an error when called, it only checks if the handle is a thread or not.
#  @return 0xD8E007ED (BAD_ENUM) if the Handle is a Thread Handle
#  @return 0xD8E007F7 (BAD_HANDLE) if it isn't.
#

proc svcGetThreadInfo*(`out`: ptr s64; thread: Handle; `type`: ThreadInfoType): Result
#/@}
#/@name Synchronization
#/@{

proc svcCreateMutex*(mutex: ptr Handle; initially_locked: bool): Result
proc svcReleaseMutex*(handle: Handle): Result
proc svcCreateSemaphore*(semaphore: ptr Handle; initial_count: s32; max_count: s32): Result
proc svcReleaseSemaphore*(count: ptr s32; semaphore: Handle; release_count: s32): Result
proc svcCreateEvent*(event: ptr Handle; reset_type: u8): Result
proc svcSignalEvent*(handle: Handle): Result
proc svcClearEvent*(handle: Handle): Result
proc svcWaitSynchronization*(handle: Handle; nanoseconds: s64): Result
proc svcWaitSynchronizationN*(`out`: ptr s32; handles: ptr Handle; handles_num: s32;
                             wait_all: bool; nanoseconds: s64): Result
#*
#  @brief Creates an address arbiter
#  @sa svcArbitrateAddress
#

proc svcCreateAddressArbiter*(arbiter: ptr Handle): Result
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
                         value: s32; nanoseconds: s64): Result
proc svcSendSyncRequest*(session: Handle): Result
proc svcAcceptSession*(session: ptr Handle; port: Handle): Result
proc svcReplyAndReceive*(index: ptr s32; handles: ptr Handle; handleCount: s32;
                        replyTarget: Handle): Result
#/@}
#/@name Time
#/@{

proc svcCreateTimer*(timer: ptr Handle; reset_type: u8): Result
proc svcSetTimer*(timer: Handle; initial: s64; interval: s64): Result
proc svcCancelTimer*(timer: Handle): Result
proc svcClearTimer*(timer: Handle): Result
proc svcGetSystemTick*(): u64
#/@}
#/@name System
#/@{

proc svcCloseHandle*(handle: Handle): Result
proc svcDuplicateHandle*(`out`: ptr Handle; original: Handle): Result
proc svcGetSystemInfo*(`out`: ptr s64; `type`: u32; param: s32): Result
proc svcKernelSetState*(`type`: u32; param0: u32; param1: u32; param2: u32): Result
#/@}
#/@name Debugging
#/@{

proc svcBreak*(breakReason: UserBreakType)
proc svcOutputDebugString*(str: cstring; length: cint): Result
proc svcDebugActiveProcess*(debug: ptr Handle; processId: u32): Result
proc svcBreakDebugProcess*(debug: Handle): Result
proc svcTerminateDebugProcess*(debug: Handle): Result
proc svcGetProcessDebugEvent*(info: ptr DebugEventInfo; debug: Handle): Result
proc svcContinueDebugEvent*(debug: Handle; flags: u32): Result
#/@}

proc svcBackdoor*(callback: proc (): s32): Result
