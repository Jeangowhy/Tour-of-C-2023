// import Hello;
import World;
#include <iostream>
// #include <format>

// Build gcm first before import standard library:
// g++-12 -std=c++20 -fmodules-ts -xc++-system-header iostream  -xc++-system-header format
// import <iostream>;

// Use {fmt} for gcc
// import <format>;
// g++-12 -std=c++20 -fmodules-ts -xc++-user-header fmt.h
// import "fmt.h";
// #include "fmt.h"

using namespace std;

int main() {
    // cout << format("Hello c++{}!", 20);
    cout << "Hello? c++" << NS::f() << endl;
}
