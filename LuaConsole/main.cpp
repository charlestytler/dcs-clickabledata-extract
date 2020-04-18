#include "../lua-5.1.5/etc/lua.hpp"

#include <iostream>
#include <string>

int main() {
    const char *lua_script = "extract_module_main.lua";

    // create new Lua state
    lua_State *lua_state;
    lua_state = luaL_newstate();

    // load Lua libraries
    luaL_openlibs(lua_state);

    // Run the lua script file, expecting multiple return values.
    const int lua_stack_size = lua_gettop(lua_state);
    const int file_status = luaL_loadfile(lua_state, lua_script);
    if (file_status != 0) {
        lua_close(lua_state);
        std::cerr << "Lua file load error: " + std::to_string(file_status) << std::endl;
        return file_status;
    }
    const int script_status = lua_pcall(lua_state, 0, LUA_MULTRET, 0);
    if (script_status != 0) {
        lua_close(lua_state);
        std::cerr << "Lua script runtime error: " + std::to_string(script_status) << std::endl;
        return script_status;
    }

    //*********Uncomment this section if you'd like to access return values in C++ ************//
    // // Handle each of the return values one at a time.
    // std::vector<std::string> returned_vals{};
    // while ((lua_gettop(lua_state) - lua_stack_size) > 0) {
    //     returned_vals.push_back(lua_tostring(lua_state, lua_gettop(lua_state)));
    //     lua_pop(lua_state, 1);
    // }

    // close the Lua state
    lua_close(lua_state);

    return 0;
}