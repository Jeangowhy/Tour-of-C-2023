import hello;
import world;
// #include <format>
#include <iostream>
// import <iostream>;
// import <format>;

using namespace std;

int main() {
    // cout << format("Hello c++{}!", 20);
    cout << "Hello " << NS::world() << endl;
    cout << "Hello C++" << NS::f() << endl;
}
