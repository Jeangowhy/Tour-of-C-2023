// MyProgram.cpp
import Example;
// import std.core;   // require VS 2022
// import <iostream>; // require VS 2019
#include <iostream>   // this is alway ok

using namespace std;

int main()
{
   cout << "The result of f() is " << Example_NS::f() << endl; // 42
   // int i = Example_NS::f_internal(); // C2039
   // int j = ANSWER; //C2065
}