/*****************************************************************************/
/* Copyright(C)   machine studio                                              */
/* Author:        donney                                                     */
/* Email:         donney_luck@sina.cn                                        */
/* Date:          2022-02-10                                                 */
/* Description:   crc32                                                      */
/* Modification:  no                                                         */
/*****************************************************************************/

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

uint32_t crc32_table[256];

static int
_make_crc32_table(lua_State *L) {
    uint32_t c;
    int i = 0;
    int bit = 0;

    for (i = 0; i < 256; ++i) {
        c = (uint32_t)i;

        for (bit = 0; bit < 8; bit++) {
            if(c & 1) {
                c = (c >> 1)^(0xEDB88320);
            }
            else {
                c = c >> 1;
            }
        }
        crc32_table[i] = c;
    }
    return 0;
}

static int
_make_crc(lua_State *L) {
    luaL_checktype(L, 1, LUA_TSTRING);
    size_t len;
    const char* ptr = lua_tolstring(L, 1, &len);
    uint32_t crc = 0xFFFFFFFF;
    while( len-- )
    crc = (crc >> 8)^(crc32_table[(crc ^ *ptr++) & 0xff]);
    lua_pushinteger(L, crc);
    return 1;
}

LUAMOD_API int
luaopen_crc32(lua_State *L) {
    luaL_Reg l[] = {
        {"make_crc32_table", _make_crc32_table},
        {"make_crc", _make_crc},
        {NULL, NULL},
    };
    luaL_checkversion(L);
    luaL_newlib(L,l);
    return 1;
}

