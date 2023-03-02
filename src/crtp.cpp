#include <iostream>

using namespace std;

template<typename impl>
class base : public impl {
public:
    void show_type(){ impl::show_type(); }
};

struct Box {
    void show_type(){ std::cout << "Box" << endl; }
};

struct Cylinder {
    void show_type(){ std::cout << "Cylinder" << endl; }
};

// Why? error C2059: Syntax error:“)”
// base<Box>().show_type();

int main() {
    base<Box>().show_type();
    base<Cylinder>().show_type();
}