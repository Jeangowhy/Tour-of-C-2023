// world.cpp
module;
export module World;

#define ANSWER 23

namespace NS
{
    int f_internal(){ return ANSWER; }

    export int f() { return f_internal(); }
}