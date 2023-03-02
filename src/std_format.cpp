// import std;
// import std.compat;
#include <format>
#include <iostream>

enum class Color { R, G, B};

template <>
struct std::formatter<Color> : std::formatter<const char*> 
{
  static constexpr const char* colors[] = { "red", "green", "blue" };

  auto format(Color c, auto& ctx) const -> decltype(ctx.out())
  {
    using base = formatter<const char*>;
    return base::format(colors[static_cast<int>(c)], ctx);
  }
};

int main()
{
  std::cout << std::format("Hello {} in C++{}", "std::format", 20) << std::endl;
  std::cout<< std::format("{:#<9}\n{:#^9}\n{:#>9}\n", Color::R, Color::G, Color::B);

  // to output the result to an arbitrary output iterator,
  std::format_to(std::ostream_iterator<char>(std::cout, ""),
      "Hello {} in C++{}\n", "std::format", 20);

  // to determine the output size, len = 27
  std::cout << std::formatted_size("Hello {} in C++{}\n", "std::format", 20);

  // // or limit the size of the output. got: "Hello std"
  // std::format_to(std::ostream_iterator<char>(std::cout, ""),
  //     11, "Hello {} in C++{}\n", "std::format", 20);

  // std::format is specified to produce a compilation error, 
  // which is implemented in the library itself using C++20 consteval functions.
  // std::cout << std::format("{0:#08B}, {0:#08o}, {0:08}, {0:#08X}", "15");
}