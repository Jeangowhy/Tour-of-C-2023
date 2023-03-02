#include <iostream>

using namespace std;

constexpr int Double(int x) {
    return 2 * x;
}

const char *g() { return "dynamic initialization"; }
constexpr const char *f(bool p) { return p ? "constant initializer" : g(); }
 
constinit const char *dc = f(true); // OK
// constinit const char *dd = f(false); // error


int main() {
    int const a[5]={1, 2, 3, 4, 5};
    const int b[5]={1, 2, 3, 4, 5};
    // a[0] = 1; read-only
    // b[0] = 1; read-only

    float c = 3.14;
    float * const d = &c;
    const float * const e = &c;
    *d = 6.28;
    // *e = 6.28; read-only

    constexpr int f = Double(4);

    cout << "const variable, pointer, array or elements" << endl << dc;
}