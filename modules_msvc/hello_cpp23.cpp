// requires /std:c++latest (Visual Studio 2022 17.5)

import std;
import std.compat;

int main()
{
    std::cout << "Import the STL library for best performance\n";
    std::vector<int> v{5, 5, 5};
    for (const auto& e : v)
    {
        std::cout << e;
    }
}