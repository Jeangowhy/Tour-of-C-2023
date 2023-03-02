// hello.cc
module;
export module Hello;

#define ANSWER 20

namespace NS
{
   int f_internal() {
      return ANSWER;
   }

   export int f() {
      return f_internal();
   }
}

