#pragma once
#define FMT_HEADER_ONLY
#include "fmt/format.h"
namespace std
{
    using fmt::format;
    using fmt::format_error;
    using fmt::formatter;
}