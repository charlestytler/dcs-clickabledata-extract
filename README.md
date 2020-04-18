# dcs-clickabledata-extract
A tool for extracting clickabledata elements from installed DCS World modules.

## Instructions for use

### Download files
Download the files by cloning this repository via the green "Clone or download" button to the top-right or downloading the zip from the "Releases" tab.

### Extract clickabledata to csv
 - Open the file `extract_module_main.lua` and specify the DCS Install Path and Module name to query.
 - Double-click `LuaRunScript.exe` to run the lua scripts and create a CSV file in the same directory.

*Example: Running with `A-10C` specified as the module will generate a file: `A-10C_clickabledata.csv`*

### (Optional) Run interactive Lua Console
If you'd like to open an interactive Lua console you can double-click the `LuaConsole.exe` executable.
You can then include the functions used for extraction with the following line:
```
dofile("extract_functions.lua")
```

You can then interactively call the functions instead of `extract_module_main.lua` calling them.

## Building from source

### Lua scripts
The lua scripts can be modified and run without compiling as it is a scripting language.

### LuaConsole and LuaRunScript
These are C++ functions that can be built using the Visual Studio solution within `LuaConsole\`
 - LuaConsole - is simply a compiled executable of the `lua-5.1.5` package for Win32.
 - LuaRunScript - also compiles `lua-5.1.5`, but adds a `main.cpp` file which calls the `extract_module_main.lua` script instead of opening an interactive console.