#    \brief 3ds stdio support.
#
#<div class="fileHeader">
#Provides stdio integration for printing to the 3DS screen as well as debug print
#functionality provided by stderr.
#
#General usage is to initialize the console by:
#consoleDemoInit()
#or to customize the console usage by:
#consoleInit()
#
#

type
  ConsolePrint* = proc (con: pointer; c: cint): bool

#! a font struct for the console.

type
  ConsoleFont* = object
    gfx*: ptr u8                #!< A pointer to the font graphics
    asciiOffset*: u16          #!<  Offset to the first valid character in the font table
    numChars*: u16             #!< Number of characters in the font graphics


#* \brief console structure used to store the state of a console render context.
#
#Default values from consoleGetDefault();
#<div class="fixedFont"><pre>
#PrintConsole defaultConsole =
#{
# //Font:
# {
#  (u8*)default_font_bin, //font gfx
#  0, //first ascii character in the set
#  128, //number of characters in the font set
# },
# 0,0, //cursorX cursorY
# 0,0, //prevcursorX prevcursorY
# 40, //console width
# 30, //console height
# 0,  //window x
# 0,  //window y
# 32, //window width
# 24, //window height
# 3, //tab size
# 0, //font character offset
# 0,  //print callback
# false //console initialized
#};
#</pre></div>
#

type
  PrintConsole* = object
    font*: ConsoleFont         #!< font of the console.
    frameBuffer*: ptr u16       #!< framebuffer address.
    cursorX*: cint             #!< Current X location of the cursor (as a tile offset by default)
    cursorY*: cint             #!< Current Y location of the cursor (as a tile offset by default)
    prevCursorX*: cint         #!< Internal state
    prevCursorY*: cint         #!< Internal state
    consoleWidth*: cint        #!< Width of the console hardware layer in characters
    consoleHeight*: cint       #!< Height of the console hardware layer in characters
    windowX*: cint             #!< Window X location in characters (not implemented)
    windowY*: cint             #!< Window Y location in characters (not implemented)
    windowWidth*: cint         #!< Window width in characters (not implemented)
    windowHeight*: cint        #!< Window height in characters (not implemented)
    tabSize*: cint             #!< Size of a tab
    fg*: cint                  #!< foreground color
    bg*: cint                  #!< background color
    flags*: cint               #!< reverse/bright flags
    PrintChar*: ConsolePrint #!< callback for printing a character. Should return true if it has handled rendering the graphics
                           #         (else the print engine will attempt to render via tiles)
    consoleInitialised*: bool  #!< True if the console is initialized


const
  CONSOLE_COLOR_BOLD* = (1 shl 0)
  CONSOLE_COLOR_FAINT* = (1 shl 1)
  CONSOLE_ITALIC* = (1 shl 2)
  CONSOLE_UNDERLINE* = (1 shl 3)
  CONSOLE_BLINK_SLOW* = (1 shl 4)
  CONSOLE_BLINK_FAST* = (1 shl 5)
  CONSOLE_COLOR_REVERSE* = (1 shl 6)
  CONSOLE_CONCEAL* = (1 shl 7)
  CONSOLE_CROSSED_OUT* = (1 shl 8)

#! Console debug devices supported by libnds.

type
  debugDevice* = enum
    debugDevice_NULL,         #!< swallows prints to stderr
    debugDevice_3DMOO,        #!< Directs stderr debug statements to 3dmoo
    debugDevice_CONSOLE       #!< Directs stderr debug statements to 3DS console window


#!	\brief Loads the font into the console
# \param console pointer to the console to update, if NULL it will update the current console
# \param font the font to load
#

proc consoleSetFont*(console: ptr PrintConsole; font: ptr ConsoleFont)
#!	\brief Sets the print window
# \param console console to set, if NULL it will set the current console window
# \param x x location of the window
# \param y y location of the window
# \param width width of the window
# \param height height of the window
#

proc consoleSetWindow*(console: ptr PrintConsole; x: cint; y: cint; width: cint;
                      height: cint)
#!	\brief Gets a pointer to the console with the default values
# this should only be used when using a single console or without changing the console that is returned, other wise use consoleInit()
# \return A pointer to the console with the default values
#

proc consoleGetDefault*(): ptr PrintConsole
#!	\brief Make the specified console the render target
# \param console A pointer to the console struct (must have been initialized with consoleInit(PrintConsole* console)
# \return a pointer to the previous console
#

proc consoleSelect*(console: ptr PrintConsole): ptr PrintConsole
#!	\brief Initialise the console.
# \param screen The screen to use for the console
# \param console A pointer to the console data to initialze (if it's NULL, the default console will be used)
# \return A pointer to the current console.
#

proc consoleInit*(screen: gfxScreen_t; console: ptr PrintConsole): ptr PrintConsole
#!	\brief Initializes debug console output on stderr to the specified device
# \param device The debug device (or devices) to output debug print statements to
#

proc consoleDebugInit*(device: debugDevice)
#! Clears the screan by using iprintf("\x1b[2J");

proc consoleClear*()
