# =🚩 Hello World from C to C++20
- http://www.cplusplus.com/reference/cstdio/
- http://www.cplusplus.com/reference/iostream/cout/
- [MSYS2](https://www.msys2.org/docs/what-is-msys2/)
- [Pacman Wiki](https://wiki.archlinux.org/title/Pacman)
- [Pacman Base Packages](https://packages.msys2.org/base)
- [Installing GCC](https://gcc.gnu.org/install/index.html)
- [MinGW-w64](https://www.mingw-w64.org/downloads/)
- [LLVM Project](https://github.com/llvm/llvm-project/releases)

Hello World! for C

    #include <stdio.h>

    int main(int argv, char **args)
    {
        printf("Hello World!");
        return 0;
    }

Hello World! for C++

    #include <iostream>
    #include <cstdio>  // C++ style for stdio.h

    using namespace std;

    int main(int argv, char **args)
    {
        cout << "Hello World!" << endl;
        return 0;
    }

模块化是 C++20 最重要的两个特性之一，另一个是协程 (Coroutine)。模块化引入可以解决从 C 语言中
继承下来的 include 机制存在的问题：

- 模糊的模块边界；
- 循环处理导致编译效率低下；
- 宏展开会导致符号污染，也就是命令空间污染问题；

Hello World! for C++20

    // MyProgram.cpp
    ///////////////////////////////////////////////////////////////////////////
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

    // Example.ixx
    ///////////////////////////////////////////////////////////////////////////
    export module Example;

    #define ANSWER 42

    namespace Example_NS
    {
       int f_internal() {
            return ANSWER;
          }

       export int f() {
          return f_internal();
       }
    }

从 C 开始，标准库头文件就使用 .h 文件，但是在 C++ 引入 Standard Library 并不需要指定扩展名。
比如 <iostream> 以及其它标准库，都定义在 std namespace 或者子命名空间内。

但是，C++ 依然为 C 标准库保留了两种形式，

- 首先，是推荐使用的无扩展名的版本，如 <cstdio>，所有这些标准库都定义在 std 命名空间中。
- 其次，是旧版本，像 C 语言中一样使用 .h 后缀扩展名，它们没有定义命名空间。

比如，引入 <stdio.h> 这个标准库，它就是不使用 namespaces 特性的库。

需要注意的是，C++20 的模块方式下，所有 C 标准库不保证可以通过 import 导入，为了安全起见，应该
使用 include 导入指令，而不是 import 导入。


要编译使用了 modules 特性的 C++ Hello World 是相当有门槛的，至少在目前阶段来说，大部分编译器
没都没支持到模块化，即使用是最新的编译器，对 C++ 模块化支持也是部分功能的支持。

GCC 12.2 和 Clang 13.0.0 都不支持 std::format 模块功能。或者更确切地说，他们的标准库实现
不支持它。Clang 14.0.0 的 libc++ 或者 GCC 13 libstdc++ 支持，但仍标记为不完整的功能。

目前标准库还未曾实现模块化，也就不能使用 import 导入标准库，否则报错：

    cannot be imported because it is not known to be a header unit

Standard Library Header Units 即标准库的标头单元，标头单元是头文件和 C++ 20 模块中间步骤。

标头单元和头文件之间的一个重要区别是，标头单元不受标头单元之外的宏定义的影响。 也就是说，不能定义
导致标头单元行为不同的预处理器符号，避免宏定义产生符号污染。导入标头单元时，就已经编译了标头单元。
这与处理文件的方式 #include 不同。 包含的文件可能会受到头文件外部的宏定义的影响，因为在编译包含
它的源文件时，头文件会经过预处理器。

必须将头文件转换为标头单元，才能导入该头文件。GCC 使用 -x c++-system-header 参数生成标头单元，
生成文件在 gcm.cache 目录下。模块引入要严格遵守 modules 之间的依赖关系，被依赖的一定要放在前面。

但是，只要编译器还不支持 std::format()，就可以使用免费提供的 {fmt} 库作为替换。下载到 {fmt}
库文件，将其中的 include/fmt 和 src 目录复制为项目中的 fmt 和 src 子目录。然后，根据需要
引入 `fmt/core.h`, `fmt/format.h`, `fmt/format-inl.h`, `src/format.cc` 等等文件。

- https://fmt.dev/ 
- https://github.com/fmtlib/fmt
- [C++ iostream 的用途与局限](https://www.cnblogs.com/Solstice/archive/2011/07/17/2108715.html)

> C++ iostream 的主要作用是让初学者有一个方便的命令行输入输出试验环境，在真实的项目中很少用到 
> iostream，因此不必把精力花在深究 iostream 的格式化与 manipulator。iostream 的设计初衷
> 是提供一个可扩展的类型安全的 IO 机制，但是后来莫名其妙地加入了 locale 和 facet 等累赘。
> 其整个设计复杂不堪，多重+虚拟继承的结构也很巴洛克，性能方面几无亮点。iostream 在实际项目中的
> 用处非常有限，为此投入过多学习精力实在不值。

C 语言的 stdio 库函数安全性问题比较严重，C99 增加了 snprintf() 等能够指定输出缓冲区大小的函数，
输出方面的安全性问题已经得到解决；输入方面似乎没有太大进展，还要靠程序员自己动手。另外，扩展性不够，
因为直接使用 FILE* 输入输出数据流，用户数据类型需要额外的处理。

C++ 设计 iostream 的初衷包括克服 C stdio 的缺点，提供一个高效的可扩展的类型安全的 I/O 机制。
“可扩展”有两层意思，一是可以扩展到用户自定义类型，而是通过继承 iostream 来定义自己的 stream，
“类型可扩展”和“类型安全”都是通过函数重载来实现的，也解决了旧有的安全性(security)方面的问题。

但是，C++ 添加了太多额外的功能，总想着考虑周全，这使得它变得非常沉重。其中一就是本地化功能，
The Standard C++ Locale by Nathan C. Myers，所以在需要 I/O 性能优化的应用中慎用。

参考第三 key-value db：

- [Google leveldb](http://code.google.com/p/leveldb)
- [Kyoto Cabinet](http://fallabs.com/kyotocabinet/)



## ==⚡ GCC Clang & C++20
- [Bjarne Cxx HOPL4 paper - C++20：方向之争](https://github.com/Cpp-Club/Cxx_HOPL4_zh/blob/main/09.md)
- [P1103R3 Merging Modules](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2019/p1103r3.pdf)
- [探索c++底层编译原理](https://www.cnblogs.com/zhangshinan/p/12971792.html)
- [C/C++编译构建相关问题](https://www.cnblogs.com/hongyugao/p/15499494.html)
- [Support for C++20 Modules](https://www.jetbrains.com/help/clion/support-for-c-20-modules.html)
- [C++ 20 协程 concept ranges modules](https://www.bilibili.com/video/BV1kV411h78u/)
- [C++20 modules with GCC11](https://blog.feabhas.com/2021/08/c20-modules-with-gcc11/)
- [C++20 新特性: modules 及实现现状](https://zhuanlan.zhihu.com/p/350136757)
- [Invoking GCC - 3.23 C++ Modules](https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Modules.html)
- [LLVM Project](https://github.com/llvm/llvm-project/releases)
- [C Support in Clang](https://clang.llvm.org/c_status.html)
- [C++ Support in Clang](https://clang.llvm.org/cxx_status.html)
- [Clang 17 - Modules](https://clang.llvm.org/docs/Modules.html)
- [Clang 17 - Standard C++ Modules](https://clang.llvm.org/docs/StandardCPlusPlusModules.html)
- [Clang CLI reference](https://clang.llvm.org/docs/ClangCommandLineReference.html)
- [Modules in C++20 and CMake](https://www.steinzone.de/wordpress/modules-in-c20-and-cmake/)
- [CMake Tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
- [import CMake; C++20 Modules](https://www.kitware.com/import-cmake-c20-modules/)

C++ 作为向后兼容 C 语言的一种系统底层高级编程语言，它的编译流程也基本和 C 语言的编译流程一致。
C 语言在贝尔实验室刚诞生时，由于当时的计算机资源相当有限，其内存无法完全表示大型源文件的语法树。
所以，为了能够编译大型项目，Dennis Ritchie 采用了分开编译源文件，最后链接形成可执行文件的
编译单元化思想，让大文件的编译成为可能。

是从编译器角度来看编译单元，translation unit 或者 compilation unit，这是非常重要的一个概念，
即一个源文件经过预处理后，再经过编译后产生的一个目标文件，将 .cpp 编译成 .o 文件，编译单元中定义
的符号与其它编译单元之间具有一种连接属性。长期以来，internal linkage 和 external linkage 是
两种基本的连接属性，C++11 又引入了线程本地存储连接，C++20 则是引入了模块连接。


早期的 C 语言编译器也并不像现代的编译器做一个单独的可执行程序，Dennis Ritchie 为 PDP-11
编写的 C 语言编译器由七个可执行文件组成：cc/cpp/as/ld/c0/c1/c2。编译的步骤为:

01. 预编译：cpp 预处理器首先处理 #define，#Include 等指令，以及展开宏定义；
02. 编译：cc c0 c1 c2 编译器将源代码转化汇编代码；
03. 汇编：as 汇编程序将汇编代码转化为目标文件，并生成符号表，包括无定义的符号；
04. 链接：ld 连接器将多个源文件链接成可执行文件，处理上一步留下的无定义符号链接问题；

现在的编译器也很多是由单独功能的程序模块组成的编译工具链，如 GCC 编译器编译 C++ 程序分步骤流程：

- 预处理： gcc -E
- 编译： gcc -S
- 汇编： gcc -c 
- 链接： gcc -o 指定输出

预处理程序 preprocessor 是 C++ 编程中相当重要的一个阶段，它相当于是一个代码生成器，通过宏定义
的展开，可以实现复杂的程序结构。C++20 从头文件引用转换到模块引用，其中一个问题就是头文件的预处理。

- [Advanced C and C++ Compiling' by Milan Stevanovic](https://github.com/jerryhjc/C-linking)
- [Advanced C and C++ Compiling Codes](https://github.com/apress/adv-c-cpp-compiling)

当下，Clang 作为一个优秀的编译器前端与 LLVM 编译器架构一起发扬光大，无论是对 C/C++ 规范的支持
，编译速度，还是错误信息的友好度都是业界领先。无论是在工程，还是平时使用，Clang 都是一个可以作为
第一选择的编译器。

C/C++ Support in Clang

|     Language Standard     |    Flag    |   Available in Clang?   |
|---------------------------|------------|-------------------------|
| C89                       | -std=c89   | Yes                     |
| C99                       | -std=c99   | Almost certainly        |
| C11                       | -std=c11   | Probably                |
| C17                       | -std=c17   | Maybe?                  |
| C2x                       | -std=c2x   | Partial                 |
| C++98 / C++03             | -std=c++98 | Yes (other than export) |
| C++11                     | -std=c++11 | Clang 3.3               |
| C++14                     | -std=c++14 | Clang 3.4               |
| C++17                     | -std=c++17 | Clang 5                 |
| C++20                     | -std=c++20 | Partial                 |
| C++2b (tentatively C++23) | -std=c++2b | Partial                 |

C++20 是有史以来最大的 C++ 版本更新，但是不知什么原因它又没有完全完工，是疫情版完成了后续的工作，
C++23 “Pandemic Edition” is complete。要使用最新的功能，需要 GCC 11 或 CLang 12 版本。
GCC 10.9 开始基础运行库命名为 libc++，早期的版本则默认为 libstdc，可以按需要安装指定版本。

虽然 C++20 开始引入模块化概念，但目前来说仍然不成熟，它需要解决的问题包含：

01. **Rewrite the world’s code**: 不向后兼容（历史包袱）扔掉头文件就需要重写整个工业基础库。
02. **Versioning**: 模块没有版本概念，开发者必须依赖语言底层的版本控制机制。
03. **Namespaces**: 与某些语言不同，模块并不暗示任何命名空间的概念，不同模块存在同名冲突。
04. **Binary distribution of modules**: 头文件，特别是 C++ 的头文件暴露了语言的全部复杂性。
    在体系结构、编译器版本和供应商之间，在技术上保持稳定的二进制模块格式不可行。

C++20 Modules 编译器支持度：

|           C++20 feature           |     GCC      |    Clang    |
|-----------------------------------|--------------|-------------|
| Modules  P1103R3                  | 11 (partial) | 8 (partial) |
| Standard Library Modules  P2465R3 | -            | -            |

或者使用 VS 2022，当然，VS 2019（MSVC 16.8）已经开始支持模块，安装“用于 v142 生成工具的
 C++ 模块（实验性）”，即可以获得模块化的标准库。

标头单元是头文件的二进制表示形式，各家编译器使用不同扩展名。标头单元文件是预编译内容的缓存文件，
相当于编译出来的 object，链接的时候直接可用，比起头文件的嵌套处理快速多了。
[P1838R0: Modules User-Facing Lexicon and File Extension](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p1838r0.pdf)

| Compilers  | HeaderUnits |              Notes              |     Module File Extension      |
|------------|-------------|---------------------------------|--------------------------------|
| Clang/LLvm | .pcm        | BMI - Binary Module Interface   | .cppm                          |
| GCC        | .gcm        | CMI - Compiled Module Interface | .pcm .gcm .gcmu .gcms          |
| MSVC       | .ifc        | IFC                             | .cpp .cppm .ixx .mpp .mxx .cmi |

暂且将有点软的格式词库 Industry Foundation Class（IFC），其格式规范旨在定义一种用于在
高抽象级别上描述 C++ 程序或程序片段语义的二进制格式，然后降为机器代码或类似代码。

格式化工具库的支持目前只有 MSVC 16.10 完全支持，Clang 14 使用 -stdlib=libc++ 支持，相对
落后一点的 GCC 12.2 还不支持：

|                     C++20 feature                      | GCC |      Clang       |
|--------------------------------------------------------|-----|------------------|
| P2418R2 DR: non-const-formattable types to std::format |  13 | 15               |
| P2216R3 DR: std::format() improvements                 |  13 | 14* (partial) 15 |
| P0645R10 Text formatting                               |  13 | 14*              |

- [Text formatting in C++ using libc++](https://blog.llvm.org/posts/2022-08-14-libc++-format/)
- https://gcc.gnu.org/onlinedocs/libstdc++/manual/status.html#status.iso.2020
- https://libcxx.llvm.org/Status/Cxx20.html
- https://github.com/fmtlib/fmt

而标准库模块化方面，GCC 和 Clang 都没有提供，VS 2019 16.10 版本以上则可以支持。

Clang 15 支持规范标准：

|          Flag          |                   Language Standard                    |
|------------------------|--------------------------------------------------------|
| 'c++98' or 'c++03'     | ISO C++ 1998 with amendments                           |
| 'gnu++98' or 'gnu++03' | ISO C++ 1998 with amendments and GNU extensions        |
| 'c++11'                | ISO C++ 2011 with amendments                           |
| 'gnu++11'              | ISO C++ 2011 with amendments and GNU extensions        |
| 'c++14'                | ISO C++ 2014 with amendments                           |
| 'gnu++14'              | ISO C++ 2014 with amendments and GNU extensions        |
| 'c++17'                | ISO C++ 2017 with amendments                           |
| 'gnu++17'              | ISO C++ 2017 with amendments and GNU extensions        |
| 'c++20'                | ISO C++ 2020 DIS                                       |
| 'gnu++20'              | ISO C++ 2020 DIS with GNU extensions                   |
| 'c++2b'                | Working draft for ISO C++ 2023 DIS                     |
| 'gnu++2b'              | Working draft for ISO C++ 2023 DIS with GNU extensions |

另外，Clang LSP 语言服务默认没有启用 C++20 规范，可以通过以下方式启用以识别新的关键字：

    For compile_flags.txt only -std=c++20 seems to work.

    For .clangd it seems it should be:

    CompileFlags:
      Add: [-std=c++20, -xc++]

0. [Clangd Configuration](https://clangd.llvm.org/config.html)
0. [How to setup clangd for C++ 20?](https://neovim.discourse.group/t/how-to-setup-clangd-for-c-20/1744)
1. [聊聊 C++20 核心语言特性之 modules](https://www.bilibili.com/video/BV1PD4y1x7kd)
2. [C++20 modules with GCC11](https://blog.feabhas.com/2021/08/c20-modules-with-gcc11/)
3. [C++20 modules with GCC11 Codes](https://github.com/feabhas/Cpp20-Modules-getting-started)
4. [GCC Wiki CXX Modules](https://gcc.gnu.org/wiki/cxx-modules)
5. [Understanding C++ Modules: Part 1: Hello Modules, and Module Units](https://vector-of-bool.github.io/2019/03/10/modules-1.html)
6. [Understanding C++ Modules: Part 2: export, import, visible, and reachable](https://vector-of-bool.github.io/2019/03/31/modules-2.html)
7. [Understanding C++ Modules: Part 3: Linkage and Fragments](https://vector-of-bool.github.io/2019/10/07/modules-3.html)


新规范的 import 关键字用法有多种形式：

```C++
    import <iostream>; // import header unit
    import "module.h"; // import header file
    import module;     // import module unit
    import module.submodule;
    import module:partition;
    import :partiion;
```

注意，第二种，导入头文件和 include 功能非常类似，都可以实现插入代码到当前编译单元。但是，不同的
是，如果在一个模块中使用 `import "module.h";`，那么这个头文件不可以访问到当前模块中定义的宏。
模块中还可以使用 `module :private;` 进行私有化控制，避免外部访问私有区块。

模块定义关键字 `module` 及 `export` 的用法，默认情况下模块及实现可以在同一代码文件中定义，也
可以像传统 C/C++ 代码那样，声明与实现分离在 .h 和 .cpp 文件中，以加速编译流程。

    and you want to import; you first need to compile it, e.g.

    $ g++ -c -std=c++20 -fmodule-header header.h 
    This generates a header.h.gcm file. The header can now be imported using the directive

    import "header.h";

与模块相关的每个文件称为模块单元，Module Unit，可以分离接口与实现，分别在两个单元中编写。主模块
使用 export module 声明导出的模块名，而实现模块中则不使用 export：

```C++
    // 01. A Primary Module Interface Unit (PMIU)
    module;                   // global module fragment [optional]
    #include <xtensor.hpp>
    export module my_module;  // module declartion 

    // 02. A Module Implementation Unit
    // An implementation unit contains the line:
    module my_module;

    export :my_partition;
    module :private; // Private Module Partition (optional)
```

全局模块片段（Global module fragments）用来处理 C++20 规范之前那些不支持模块的代码、头文件，
这些代码实际被隐式的当作全局模块片段处理，在全局模块片段声明后 include 这些头文件。

子模块 submodule 并不是命名空间上的划分，而只是名称上分类管理，也就是将“模块”的边界自由度交给
开发者进行管理。同义为同一模块的不同文件，会作为一个模块编译。

Clang 解析模块名使用的正则表达式是 `[a-zA-Z_][a-zA-Z_0-9\.]*`，即模块名中的点其实就是名称
的一部分，只是看着像子模块而已。Clang 文档中将模块分成 4 种形式：

01. Primary module interface unit `export module module_name;`
02. Module implementation unit `module module_name;`
03. Module interface partition unit `export module module_name:partition_name;`
04. Internal module partition unit `module module_name:partition_name;`

模块分块单元则是 import module:partition; 这样的格式定义。模块分区可以精细地控制模块定义中要
导出的部分，方便将大模块拆解成小的分区，如 `export :partition;`。

从实践角度看，namespace 语义并没什么改变，导出模块中的符号定义在什么命名空间下，使用时，就需要
通过相应的命名空间来访问导出的符号。使用 export 导出符号有以下方式：

01. 可以分为单符号导出： export function, variable ...
02. 可以导出类型定义： export class { ... }。
03. 或者花括号代码块导出，方便导出代码块内的所有符号定义： export {...}
04. 可以导出整个命名空间，和导出代码块类似： export namespace { ... }

使用 import 和 export 的约束：

1. `export module` must appear once per module
2. `export import` is only allowed for interface partitions
3. `export` is not allowed in implementation units
4. `import` 是一个特殊关键字，在其它语句前使用就是导入模块，否则它就是一个标识符。

以下使用 Homebrew 安装的 clang version 15.0.7，以及 GCC 12.2.0。

Clang 模块的一些定义规则：

- 模块文件使用 .cppm 扩展名，不像 GCC 可以使用支持的多个扩展名；
- 模块代码中以 `module;` 打头，但是 `export module` 语句要在 include 指令后面；
- 使用 --precompile 指令预编译模块时，输出名称要和源文件名一致；

Clang 模块文件一般要保存为 .cppm 文件，根据模块文件的用途选择：

- Importable module unit: .cppm, .ccm, .cxxm, .c++m 
- Implementation unit: .cpp, .cc, .cxx, .c++

如果使用 GCC 编译，则宽松很多，保存为 .cc 或 .cxx .cpp 都可以，并且也不要求导出模块名称与
文件名一致。不过，为了一致，还是保持一致的模块名与文件名为好，最好连命名空间也保持一致。否则就是
Module implementation units are spooky beasts！不要人为模糊导入、导出，使模块边界模糊化。

Clang 作为和 GCC 兼容的编译器，它也可以通过 -c 指令来指示编译使用什么语言规范来解析输入的文件。
但是，使用非规范文件扩展名并编译模块 BMI 文件时，像在 GCC 中那样指定 -xc++ 并不起作用，而需要
指定 `-xc++-module` 才能让 Clang 编译生成 BMI。
[Clang 17.0.0 Docs Index](https://clang.llvm.org/docs/genindex.html)
[Clang 15.0.0 documentation](https://releases.llvm.org/15.0.0/tools/clang/docs/index.html)

Clang 模块定义语法参考：

    [export] module module_name[:partition_name];


模块定义以及测试参考如下：

```C++,ignore
    // hello.cppm
    module;
    export module hello;

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

    // hello.cpp
    import hello;
    #include <iostream>

    using namespace std;

    int main() {
        cout << "Hello c++" << NS::f() << endl;
    }
```

Clang 文档中给出了传统编译模式与模块化模式的编译流程图，可以清晰地了解模块化背后的编译工序：

```sh
    # The traditional compilation processes for headers are like:
    src1.cpp -+> clang++ src1.cpp --> src1.o ---,
    hdr1.h  --'                                 +-> clang++ src1.o src2.o ->  executable
    hdr2.h  --,                                 |
    src2.cpp -+> clang++ src2.cpp --> src2.o ---'

    # And the compilation process for module units are like:
                  src1.cpp ----------------------------------------+> clang++ src1.cpp -------> src1.o -,
    (header unit) hdr1.h    -> clang++ hdr1.h ...    -> hdr1.pcm --'                                    +-> clang++ src1.o mod1.o src2.o ->  executable
                  mod1.cppm -> clang++ mod1.cppm ... -> mod1.pcm --,--> clang++ mod1.pcm ... -> mod1.o -+
                  src2.cpp ----------------------------------------+> clang++ src2.cpp -------> src2.o -'
```

Clang 编译命令参考，编译标头单元文件需要 Clang 15：

```sh
clang++ -std=c++20 --precompile ../mod.cppm -o mod.pcm
clang++ -std=c++20 -fprebuilt-module-path=. mod.pcm ../hello.cpp -o Hello; ./Hello

clang++ -std=c++20 -stdlib=libc++ -fprebuilt-module-path="." mod.pcm ../hello.cpp
clang++ -std=c++20 -stdlib=libc++ -fexperimental-library hello.cpp

clang++ -std=c++20 -xc++-user-header --precompile mod.cppm -o mod.pcm
clang++ -std=c++20 -xc++-system-header --precompile iostream -o iostream.pcm

clang++ -std=c++20 -fmodule-header foo.h -o foo.pcm
clang++ -std=c++20 -fmodule-file=foo.pcm use.cpp

clang++ -std=c++20 -fmodule-header=system -xc++-header iostream -o iostream.pcm
clang++ -std=c++20 -fmodule-file=iostream.pcm use.cpp
```

因为当前 GCC 或 Clang 还未提供标准库模块化支持，导入标准库时，就需要手动编译标头单元文件。
与用户定义的命名模块类似，使用 --precompile 编译标头单元文件生成 BMI，但是还需要额外指令，
以下任选一种：

- 通过 -xc++-system-header 或 -xc++-user-header 指定输入文件是头文件。
- 通过 -fmodule-header={user,system} 选项为 .h 或 .hh 文件生成 BMI。

默认值为 -fmodule-header=user，即相当于 MSVC 中使用 /headerUnit:quote 类似，按用户搜索
路径定位标头文件。可以多次使用 -fmodule-file 以指定多个 BMI 文件。
https://clang.llvm.org/docs/ClangCommandLineReference.html#cmdoption-clang-fmodule-file

有三种方法可以指定 BMIs 文件路径，-fmodule-file 还可以映射模块名到 BMI：

    -fprebuilt-module-path=<path/to/direcotry>.
    -fmodule-file=<path/to/BMI>.
    -fmodule-file=<module-name>=<path/to/BMI>.

当导入 M 模块就会在指定目录下查找 M.pcm 文件，导入分区模块 M:P 就会查找 M-P.pcm 文件。除非
使用 -fmodule-file 进行映射，这种方式节省了文件查找的时间。注意，模块之间的依赖对应的是 .pcm
文件的依赖。

使用分离式模块文件组织方式时，export 的用法在不同编译器之间有差异，模块中不能使用多条相同的 
export module 语句，会导致模块初始化多重执行。
<!-- 而 Clang 则相反，需要在模块的声明文件、实现 文件上同时使用 export module。 -->

Clang 对模块分区文件名称有要求，假设模块接口单元 BMI 文件名为 module_name.pcm，那么对应的
模块分区 BMI 文件名就应该是 module_name-partition_name.pcm，注意后缀 `partition_name`。

    multiple definition of `initializer for module mod';

```C++
    // interface unit mod.ixx
    export module mod;

    // implementation unit mod.cpp
    export module mod; // Clang
    module mod; // GCC or MSVC
```

    clang++ -std=c++20 M.cppm --precompile -fmodule-file=M-interface_part.pcm -fmodule-file=M-impl_part.pcm -o M.pcm

    clang++ -std=c++20 -xc++-module ..\mod-math1.cppm --precompile
    clang++ -std=c++20 -xc++-module ..\mod-math2.cppm --precompile
    clang++ -std=c++20 -xc++-module ..\mod.cppm -fprebuilt-module-path=".\" --precompile
    clang++ -std=c++20 mod-math2.pcm mod-math1.pcm mod.pcm ..\app.cpp

    clang++ -std=c++20 -xc++-module ..\mod.math1.ixx --precompile
    clang++ -std=c++20 -xc++-module ..\mod.math2.ixx --precompile
    clang++ -std=c++20 -xc++-module ..\mod.ixx -fprebuilt-module-path=".\" --precompile
    clang++ -std=c++20 mod.math2.pcm mod.math1.pcm mod.pcm ..\app.cpp

    clang++ -std=c++20 -xc++-module ..\mod.ixx --precompile -fmodule-file="mod-math1.pcm" -fmodule-file="mod-math2.pcm" -o mod.pcm

    clang++ -std=c++20 M.cppm --precompile -fmodule-file=M-interface_part.pcm -fmodule-file=M-impl_part.pcm -o M.pcm


GCC 在文件扩展名上的设计选择是，不支持新的拓展名，只支持原有的 .cc, .cxx, .cpp 等等拓展名。
gcc 和 g++ 命令分别处理 C 语言和 C++ 语言，它们会根据输入文件的扩展名确定编译使用的语言规范，
但是 GCC 提供了一个语言选项，在使用“特殊”扩展名时，用来指定什么什么语言规范解析文件内容：

> g++ ..\xoption.xpp
..\xoption.xpp: file not recognized: file format not recognized
collect2: error: ld returned 1 exit status
> g++ -x c++ ..\xoption.xpp; .\a.exe
Test gcc -x c++

[Overall Options (Using the GCC)](https://gcc.gnu.org/onlinedocs/gcc/Overall-Options.html)

    -x language
    Specify explicitly the language for the following input files 
    (rather than letting the compiler choose a default based on the file name suffix).
    This option applies to all following input files until the next -x option. 
    Possible values for language are:

    c  c-header  cpp-output
    c++  c++-header  c++-system-header c++-user-header c++-cpp-output
    objective-c  objective-c-header  objective-c-cpp-output
    objective-c++ objective-c++-header objective-c++-cpp-output
    assembler  assembler-with-cpp
    ada
    d
    f77  f77-cpp-input f95  f95-cpp-input
    go

    -x none
    Turn off any specification of a language, so that subsequent files are 
    handled according to their file name suffixes 
    (as they are if -x has not been used at all).


GCC 编译命令参考如下，使用 PowerShell。GCC 可以一条命令中编译模块、主程序代码文件，自动生成 GCM
文件并保存到 gcm.cache 目录下。也可以分部操作，先编译模块得到 object 文件，最后一起链接，这种
方式通常用于大型项目，避免那些不需要更新的模块被重复编译，以节点编译时间：

```sh
    # GCC 12.2.0
    $cclv = "C:\mingw-w64\llvm-mingw-20220906-msvcrt-x86_64\bin\aarch64-w64-mingw32-g++.exe"
    $cclu = "C:\mingw-w64\llvm-mingw-20220906-ucrt-x86_64\bin\aarch64-w64-mingw32-g++.exe"
    $ccv = "C:\mingw-w64\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\bin\g++.exe"
    $ccu = "C:\mingw-w64\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\bin\g++.exe"
    $env:Path = ";C:\mingw-w64\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\bin;"+$env:Path

    &$ccu -std=c++20 -fmodules-ts -xc++-user-header -Ipath/to/search hello.h
    &$ccu -std=c++20 -fmodules-ts -xc++-system-header iostream  -xc++-system-header vector
    &$ccu -std=c++20 -fmodules-ts ../hello.cc ../hello.cpp -o hello ; ./hello
    g++-12 -std=c++20 -fmodules-ts ../hello.cc ../hello.cpp -o hello ; ./hello
    
    # GCC 11 surport to generates a gcm from header
    # then you can use: import "header.h";
    g++-12 -c -std=c++20 -fmodule-header header.h 

    g++ -c -xc++ -std=c++20 -fmodules-ts modules_ixx/*.ixx
    g++ -c -xc++ -std=c++20 -fmodules-ts modules_ixx/hello.ixx
    g++ -c -xc++ -std=c++20 -fmodules-ts modules_ixx/world.ixx
    g++ -c -std=c++20 -fmodules-ts modules_ixx/app.cpp 
    g++ app.o hello.o world.o -o App
```

Windows 系统上，可以安装最新版本 MinGW-w64 编译工具以使用 GCC 12.2。Windows WSL 系统下
可以使用 Homebrew 管理工具安装最新的 GCC 12。

    $ which g++-12
    ~/homebrew/bin/g++-12

    $ strings /lib/x86_64-linux-gnu/libc.so.6 | grep GLIBC
    ...
    GLIBC_2.30
    GLIBC_PRIVATE
    GNU C Library (Ubuntu GLIBC 2.31-0ubuntu9.9) stable release version 2.31.

但是，这个版本的 Link Time Optimization (LTO) 插件依赖更新的 GLIBC 2.33，没有更新到位
就会导致链接失败。libLTO 插件作为 LLVM 的一部分，也是模块间优化 intermodular optimization， 
一种用于代码链接阶段的优化技术。LTO 是优化代码的一系列编译器优化技术的集合，不同于其他的优化技术，
LTO 聚焦于分析整个程序代码。

    ~/homebrew/Cellar/gcc/12.2.0/libexec/gcc/x86_64-pc-linux-gnu/12/liblto_plugin.so: 
    error loading plugin: 
        /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.33' not found
        (required by liblto_plugin.so)

另外，新 DWARF 5 调试数据格式于 2017 年发布，以取代已有十年历史的 DWARF 4。DWARF 5 支持
更好的数据压缩、各种性能改进、围绕优化代码的更好的调试处理，以及对 DWARF4 的其他增强。DWARF 5
本身已经开发了五年，详细信息请参见 DWARFstd.org。但是新的技术就需要新的运行库依赖，这可能导致
编译器工作失败的原因。

GCC 支持 -gdwarf-5 开关来生成与 DWARF5 兼容的调试信息，但默认值仍然是 DWARF4，新的版本是
“仅实验性的”。使用 readelf -w 可以查询文件中的所有 DWARF 信息区段。

- [Introduction to the DWARF Debugging Format](https://dwarfstd.org/doc/Debugging%20using%20DWARF-2012.pdf)
- [DWARF Debugging Information Format Version 5](https://dwarfstd.org/doc/DWARF5.pdf)

WSL 软件仓库没有提供最新版，只好从源代码构建，根据网络速度选择下载 gz 或更大压缩率的 xz：

    wget http://ftp.gnu.org/gnu/libc/glibc-2.33.tar.gz
    wget http://ftp.gnu.org/gnu/libc/glibc-2.33.tar.xz
    tar -vxzf glibc-2.33.tar.gz

    mkdir ~/glibc-2.33-install
    mkdir build 
    cd build
    ~/glibc-2.33/configure --prefix=~/glibc-2.33-install
    make
    make install

Linux 系统安装软件的基本流程是：configure → make → make install。配置文件是一个可执行脚本，
其中 -–prefix 选项是配置安装的路径，如果不配置该选项，默认安装行为如下：

- 可执行文件放在 /usr/local/bin
- 库文件放在 /usr/local/lib
- 配置文件默认放在 /usr/local/etc
- 其它的资源文件放在 /usr/local/share

通过指定配置 -–prefix，可以把所有资源文件放在指定路径下，统一管理，此选项方便卸载软件或移植软件。

- [LLVM Link Time Optimization: Design and Implementation](https://www.llvm.org/docs/LinkTimeOptimization.html)
- [The GNU C Library (glibc)](https://www.gnu.org/software/libc/)

GCC 上不能使用 fromat 标准库，可以使用 {fmt} 库，Professional C++ 5th 的入门教程中提供了
一个头文件参考，只是引入了 {fmt} 的格式化函数、错误对象，以及格式化扩展接口。fmtlib 源代码中，
src 目录包含的 fmt.cc 是一个全局模块，它引用了 C++ 标准库，也引用 {fmt} 库。

全局模块片段 global module fragment 用来解决 import 头文件时无法和传统头文件引入效果的问题。
通过在 fmt.cc 模块内 include 标准库头文件，就可以和传统的引入标准库一样的效果。


```C++
#pragma once
#define FMT_HEADER_ONLY
#include "fmt/format.h"
namespace std
{
    using fmt::format;
    using fmt::format_error;
    using fmt::formatter;
}
```

可以按前面提到的方法，将此头文件编译成标头单元，这样就只可以使用 import "fmt.h" 这样的方式使用。
引入外部依赖时，需要乃至三个 GCC 参数，-I -L -l 分别添加头文件、库文件搜索目录，以及库文件引用。

    g++ ../hello.cpp -Ipath/to/3rd/fmtlib/include
    g++ -c -std=c++20 -fmodules-ts -fmodule-header ../fmt.h -I/fmtlib/include

<!--
    &$ccu -c -std=c++20 -fmodule-header -IC:\download\demo\3rd\fmtlib\include -IC:\download\demo\3rd\fmtlib\src C:\download\demo\3rd\fmtlib\src\fmt.cc 

    g++ -std=c++20 -fmodules-ts -xc++-user-header -Ipath/to/search hello.h

    $ccv = "C:\mingw-w64\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\bin\g++.exe"
    $ccu = "C:\mingw-w64\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\bin\g++.exe"
    &$ccu -std=c++20 -fmodules-ts -Ic:/download/demo/3rd/fmtlib/include  (dir C:\download\demo\3rd\fmtlib\src\*.cc) ../hello.cpp 
 -->

目前 GCC 12.2 还没有提供 <format> 标准库，使用 {fmt} 库替代。

[{fmt} Format String Syntax 格式字符串语法参考](https://fmt.dev/latest/syntax.html)
[{fmt} Formatting & Printing Library](https://hackingcpp.com/cpp/libs/fmt.html)

    replacement_field ::=  "{" [arg_id] [":" (format_spec | chrono_format_spec)] "}"
    arg_id            ::=  integer | identifier
    integer           ::=  digit+
    digit             ::=  "0"..."9"
    identifier        ::=  id_start id_continue*
    id_start          ::=  "a"..."z" | "A"..."Z" | "_"
    id_continue       ::=  id_start | digit

    format_spec ::=  [[fill]align][sign]["#"]["0"][width]["." precision]["L"][type]
    fill        ::=  <a character other than '{' or '}'>
    align       ::=  "<" | ">" | "^"
    sign        ::=  "+" | "-" | " "
    width       ::=  integer | "{" [arg_id] "}"
    precision   ::=  integer | "{" [arg_id] "}"
    type        ::=  "a" | "A" | "b" | "B" | "c" | "d" | "e" | "E" | "f" | "F" | "g" | "G" |
                     "o" | "p" | "s" | "x" | "X"

    chrono_format_spec ::=  [[fill]align][width]["." precision][chrono_specs]
    chrono_specs       ::=  [chrono_specs] conversion_spec | chrono_specs literal_char
    conversion_spec    ::=  "%" [modifier] chrono_type
    literal_char       ::=  <a character other than '{', '}' or '%'>
    modifier           ::=  "E" | "O"
    chrono_type        ::=  "a" | "A" | "b" | "B" | "c" | "C" | "d" | "D" | "e" | "F" |
                            "g" | "G" | "h" | "H" | "I" | "j" | "m" | "M" | "n" | "p" |
                            "q" | "Q" | "r" | "R" | "S" | "t" | "T" | "u" | "U" | "V" |
                            "w" | "W" | "x" | "X" | "y" | "Y" | "z" | "Z" | "%"

std::format 格式化参考：

```C++,ignore
    std::format("Hello {} in C++{}", "std::format", 20);
    // Hello std::format in C++20
    std::format("{0:#08b}, {0:#08o}, {0:08}, {0:#08x}", 16);
    // lower: 0b010000, 00000020, 00000016, 0x000010
    std::format("{0:#08B}, {0:#08o}, {0:08}, {0:#08X}", 15);
    // upper: 0B001111, 00000017, 00000015, 0X00000F
    std::format("{:#<8} {:*>8} {:-^5}", "Hello", "world", '!');
    // Align: Hello### ***world --!--

    // to output the result to an arbitrary output iterator,
    std::format_to(std::ostream_iterator<char>(std::cout, ""),
        "Hello {} in C++{}\n", "std::format", 20);

    // to determine the output size, len = 27
    std::cout << std::formatted_size("Hello {} in C++{}\n", "std::format", 20);

    // or limit the size of the output. got: "Hello std"
    std::format_to(std::ostream_iterator<char>(std::cout, ""),
        11, "Hello {} in C++{}\n", "std::format", 20);

    // std::format is specified to produce a compilation error, 
    // which is implemented in the library itself using C++20 consteval functions.
    std::cout << std::format("{0:#08B}, {0:#08o}, {0:08}, {0:#08X}", "15");
```

扩展格式化接口，实现自定义类型格式化输出：

```C++,ignore
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
    }
```

LLVM 子项目 libc++ 目前只支持类 Linux 平台，Windows 平台上只能借用 MSVC 或者 MingGW 提供
的 C++ 运行库。官方文档表示 Clang 不是 MSVC 的替代品，而是补充。通过 -fuse-ld=<linker name>
可以指定以下任何一种支持的链接程序：

01. GNU ld
02. GNU gold
03. LLVM’s lld
04. MSVC’s link.exe

Link-time optimization 原生支持持链接期优化，使用 gold 时通过链接程序插件支持。

Clang 支持以下两种 C++ standard library 实现，使用 -stdlib 参数的设置：

01. LLVM’s libc++，此库旨在成为从 C++11 开始的 C++ 标准完整实现，-stdlib=libc++ 。
02. GCC’s libstdc++，Clang 支持 libstdc++4.8.3 及更高版本，-stdlib=libstdc++。

另外，Clang 版本需要和 Visual Sutio 版本匹配，版本不匹配会出现编译或链接问题。Visual Studio
2022 安装包本身也提供了 Clang 15 编译器。如果已经手动下载安装了 LLVM Clang 14 则可以搭配
VS 2019 使用，注意 x86 或者 x86_64 也对应，两者版本不匹配就会出现编译问题。

    STL1000, "Unexpected compiler version, expected Clang 15.0.0 or newer."

另外，-fprebuilt-module-path 目录设置为 . 可能引起无法打开当前目录的问题，需要指定绝对路径：

    LINK : fatal error LNK1104: 无法打开文件“.”

在 Windows 下使用 Powershell 执行编译命令时，可以会出现 clang 找不到基础运行库的问题。需要
使用 Visual Studio 提供的运行时，使用 VC 环境脚本可以提供环境配置。需要注意，PowerShell 没有
@call 这个指令。使用 cmd /k 调用脚本后，不会保留环境配置信息。只能进入 cmd 环境下执行编译命令。

当然，可以使用 cmd /c 执行环境配置脚本后，将配置信息通过 SET 指令打印出来，再使用 PowerShell
进行二次处理，也可以实现一定的自动配置功能，但这已经失去了方便使用的的原则。

这就需要使用开发环境提供的一个专用模块 “Microsoft.VisualStudio.DevShell.dll”，用它来初始化
PowerShell VC 编译环境。可以安装 Windows Terminal 终端工具，方便运行编译环境。

```sh
    # fatal error: 'iostream' file not found

    # cmd /c vcvars32.bat > null 2>&1 && SET
    
    # Developer Command Prompt for VS 2019
    cmd.exe /k "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\VsDevCmd.bat" -arch=x64 -host_arch=x64
    # Developer PowerShell for VS 2019
    powershell.exe -NoExit -Command "&{Import-Module """C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell 40c012a9 -SkipAutomaticLocation -DevCmdArguments """-arch=x64 -host_arch=x64"""}"
    powershell.exe -noe -c "&{Import-Module """C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell 40c012a9}"

    # Developer Command Prompt for VS 2019
    %comspec% /k "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"
    # Developer PowerShell for VS 2022
    powershell.exe -noe -c "&{Import-Module """C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell d11e5b8c}"
```

命令行直接以新进程方式运行，如果要在 PowerShell 执行，就需要使用反引号对参数中的双引号进行转义。

    powershell.exe -c "&{Import-Module `"`"`"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll`"`"`"; Enter-VsDevShell d11e5b8c}"



## ==⚡ Cmake vs. Xmake who is Ninja


CMake 3.23 更新功能 FILE_SET 可以使用 CXX_MODULES 支持 C++20 的模块。
CMake 对 C++20 模块这个不成熟的方案支持度还不够高，可用 add_custom_target 来编译模块。
Ninja 1.10.2 在编译时，即使用 GCC 生成的 GCM 文件也会报错。

Xmake 则称支持 C++20 模块，这是一个基于 lua 脚本语言开发的构建工具。现在 Xmake 支持远程编译，
分布式编译，内置本地缓存，远程缓存。Xmake 的设计模式是直接构建，不依赖 makefile 和 make 工具，
自动处理头文件依赖，并且默认开启多任务来加速构建，构建、打包、安装流程化处理。

Xmake 是个人维护的一个开源项目，主程序用 C 语言开发，基于 Luajit 二次开发。源代码目录结构：

- core/src 即为主程序的源代码，包管理工具 tbox，包仓库 xrepo，依赖 lua，luajit。
- xmake 目录即为构建工具的框架代码，也就是用户使用的 xmake 构建工具实现逻辑。
- tests 目录包含一些测试、示范工程。

可以使用多种脚本方式安装，或者手动下载：

```sh
    # https://github.com/xmake-io/xmake
    # * 官方自建仓库 [xmake-repo](https://github.com/xmake-io/xmake-repo) (tbox >1.6.1)
    # * 官方包管理器 [Xrepo](https://github.com/xmake-io/xrepo)
    curl -fsSL https://xmake.io/shget.text | bash
    wget https://xmake.io/shget.text -O - | bash
    Invoke-Expression (Invoke-Webrequest 'https://xmake.io/psget.text' -UseBasicParsing).Content
```

可以简单理解 xmake 为下面的综合体

    Xmake ~= Make/Ninja + CMake/Meson + Vcpkg/Conan + distcc + ccache

- [Ninjia: inputs may not also have inputs](https://github.com/ninja-build/ninja/issues/1962)
- [Bug 105467 - Dependency file produced by C++ modules causes Ninja errors](https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105467)
- [xmake](https://xmake.io/#/getting_started)
- [Xmake C++20 Module](https://xmake.io/#/guide/project_examples?id=c20-module)
- [xmake v2.3.2 发布, 带来和ninja一样快的构建速度](https://codeantenna.com/a/8WLxrtmOMk)

```sh
# https://xmake.io/#/guide/quickstart
# https://github.com/xmake-io/xrepo
# https://github.com/xmake-io/xmake-docs
# https://github.com/xmake-io/xrepo-docs
# And xmake will generate some files for c language project:
# hello
# ├── src
# │   └── main.c
# └── xmake.lua
$ xmake create -l c -P ./hello
$ cd hello
$ xmake
$ xmake run hello
```

xmake 会自动探测当前主机平台，默认自动生成对应的目标程序。Xmake 支持 Wasm (WebAssembly) 和
Mysys2、MinGW 等等平台。编译 WebAssembly 程序（内部会使用emcc工具链），在切换此平台之前，
需要先进入 Emscripten 工具链环境，确保 emcc 等编译器可用。

xmake 除了支持 Msys2/MingW, MingW for macOS/linux 之外，还支持 llvm-mingw 工具链，
可以切换 arm/arm64 架构来编译。注意配合 --sdk 来指定编译器工具的所在。

自动选择或指定编译器或链接程序，手动指定编译及相关参数示范如下：

```sh
$ xmake f -p linux [-a i386|x86_64]
$ xmake f -p linux --sdk=/user/toolsdk --cc=armv7-linux-clang --cxx=armv7-linux-clang++
$ xmake f -p linux --sdk=/user/toolsdk --ld=armv7-linux-clang++ --sh=armv7-linux-clang++ --ar=armv7-linux-ar
$ xmake f --cxx=clang++@/home/xxx/c++mips.exe
$ xmake f -p linux --sdk=/usr/toolsdk --includedirs=/usr/toolsdk/xxx/include --linkdirs=/usr/toolsdk/xxx/lib --links=pthread
$ xmake f -p linux --sdk=/usr/toolsdk --cflags="-DTEST -I/xxx/xxx" --ldflags="-lpthread"

$ xmake f -p wasm
$ xmake f -p mingw --sdk=/usr/local/i386-mingw32-4.3.0/ [-a i386|x86_64|arm|arm64]
$ xmake f -p mingw -m debug --debugger=gdb --sdk=C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2

$ xmake f --toolchain=llvm -m debug --debugger=gdb --sdk=c:\llvm
$ xmake -r --verbose
$ xmake run -d hello
```

当然，可以指定编译器全路径。

    --cc    用于指定 c 编译器，
    --cxx   用于指定 c++ 编译器
    --ld    指定可执行程序链接器
    --sh    指定共享库程序链接器
    --ar    指定生成静态库的归档器。

注：如果存在 CC/CXX 环境变量的话，会优先使用当前环境变量中指定的值。
注：如果存在 LD/SH/AR 环境变量的话，会优先使用当前环境变量中指定的值。

如果指定的编译器名不是那些 xmake 内置可识别的名字（带有gcc, clang等字样），那么编译器工具检测
就会失败。这个时候就可以通过配置命令指定，如示例，在指定编译器为 c++mips.exe 的同时，告诉 xmake，
它跟 clang++ 用法和参数选项基本相同。

如果 sdk 里面还有额外的其他 include/lib 目录不在标准的结构中，导致交叉编译找不到库和头文件，
那么通过 --includedirs 和 --linkdirs 追加搜索路径，然后通过 --links 添加额外的链接库。

注：如果要指定多个搜索目录，使用 : 或者 ; 来分割，也就是不同主机平台的路径分隔符，linux/macos 
和 Windows 两类系统分别使用 : 和 ;。

设置编译和链接选项  --cflags, --cxxflags，--ldflags，--shflags和--arflags额外配置一些编译和链接选项。

    --cflags    指定 c 编译参数
    --cxxflags  指定 c++ 编译参数
    --cxflags   指定 c/c++ 编译参数
    --asflags   指定汇编器编译参数
    --ldflags   指定可执行程序链接参数
    --shflags   指定动态库程序链接参数
    --arflags   指定静态库的生成参数

- [Configuration](https://xmake.io/#/guide/configuration)
- [xmake 从入门到精通10：多个子工程目标的依赖配置](https://tboox.org/cn/2019/12/13/quickstart-10-target-deps/)
- [xmake 从入门到精通11：如何组织构建大型工程](https://tboox.org/cn/2020/04/11/quickstart-11-subprojects/)
- [xmake v2.2.2, 让C/C++拥有包依赖自动构建](https://tboox.org/cn/2018/10/13/xmake-update-v2.2.2-package-deps/)
- [Project target](https://xmake.io/#/manual/project_target)
- [Global Interfaces](https://xmake.io/#/manual/global_interfaces)
- [Proejct examples](https://xmake.io/#/zh-cn/guide/project_examples)
- xmake\tests\projects\c++\modules\packages\xmake.lua


xmake 使用 `.mpp` 文件作为默认的 C++20 模块，也支持 `.ixx`, `.cppm`, `.mxx` 。
虽然 xmake 文档说 C++20 Modules 已经完全支持 gcc11/clang/msvc 等编译器，并会对模块依赖
进行分析以实现最大化的并行编译。

```py
set_languages("c++20")
target("class")
    set_kind("binary")
    add_files("src/*.cpp", "src/*.mpp")

add_rules("mode.debug", "mode.release")

target("test")
    set_kind("binary")
    add_files("src/*.cpp")
    set_languages("c++20")
    set_policy("build.c++.modules", true)
```

使用 GCC 编译时，会用到 -fmodule-mapper，这是 CMI 文件映射服务，用于帮助编译器确实 CMI 
文件与模块之间的影射关系，也用于按需求生成 CMI。映射功能处于起步阶段，旨在进行构建系统交互的实验。
但是在 MinGW 平台上，会出现 error: failed reading mapper。
https://github.com/xmake-io/xmake/issues/3185
https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Module-Mapper.html

一个临时办法就是使用 os 对象直接调用 GCC 编译器，os shell 调用方法有两组：

- **os.exe()** 或 **os.exec()** 打印命令输出内容；
- **os.run()** 或 **os.runv()** 只打印命令输出报错信息；

```lua
add_rules("mode.debug", "mode.release")
set_languages("c++20")

target("modules-ixx")
    set_kind("binary")
    -- add_files("*.cpp", "*.ixx")
    add_files("*.cpp")
    add_linkdirs("$(buildir)")
    set_targetdir("$(buildir)")

    if (is_plat("mingw")) then
        add_cxxflags("-fmodules-ts")
        add_ldflags("$(buildir)/hello.o", {force = true})
        add_ldflags("$(buildir)/world.o", {force = true})
    else
        -- Unworking in MinGW GCC
        -- add_cxxflags("-fmodules-ts", { tools = "gcc" })
        -- add_cxxflags("-o modules-ixx", { tools = "gcc" })
        set_policy("build.c++.modules", true)
    end

    -- $env:Path = ";C:\mingw-w64\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\bin;"+$env:Path
    -- g++ -c -xc++ -std=c++20 -fmodules-ts modules_ixx/*.ixx
    -- g++ -c -xc++ -std=c++20 -fmodules-ts modules_ixx/hello.ixx
    -- g++ -c -xc++ -std=c++20 -fmodules-ts modules_ixx/world.ixx
    -- g++ -c -std=c++20 -fmodules-ts modules_ixx/app.cpp 
    -- g++ app.o hello.o world.o -o App

    before_build(function (target, opt)
        if (not is_plat("mingw")) then
            return
        end
        -- os.cd("$(buildir)")
        os.exec("g++ --version")
        local opts = {stdout = "build/here.log", stderr="build/herr.log"}
        local args = {"-c", "-xc++", "-std=c++20", "-fmodules-ts", "../modules_ixx/*.ixx"}
        local a, b, c = os.execv("g++", args)
        os.mv("*.o", "build/")
        print("==> before build:", target:name())
    end)

    after_build(function (target, opt)
        print("==>", "xmake run "..target._NAME)
        -- xmake\xmake\core\base\os.lua
        -- os.runv("xmake run ".. target._NAME)
        os.exec("xmake run ".. target:name())
    end)
```

虽然代码文档中显示可以使用以下 add_cxxflags() 可以将参数只绑定到指定的编译器上，但是 MinGW 
GCC 上并没有效果，另外，添加指定参数也不会覆盖默认参数设置。

还有，不能同时指定多个模块文件，因为 xmake 使用 -o 指定输出。
也并无提供 remove flags api，倒是 target:remove_files 这样的方法提供了。

    -- @see https://github.com/xmake-io/xmake/issues/3022
    --
    -- e.g.
    -- for all: add_cxxflags("-g")
    -- only for clang: add_cxxflags("clang::-stdlib=libc++")
    -- only for clang and multiple flags: add_cxxflags("-stdlib=libc++", "-DFOO", {tools = "clang"})

私认为，一个持续了 7 年的项目不应该如此，尽管是个人在维护的项目，这可能与开发环境或测试只使用了 
Linux 类系统有关。如果我要开发一个类似的项目，大概会叫做 compiler configuration wizard
CCW “逆时针”构建工具。


xmake 的 taget 概念定义等价一个子工程，每个子工程对应只能生成一个唯一的目标文件：可执行程序、
静态库或者动态库等。

- 目标通用配置：全局块配置
- 目标间的依赖设置：add_links("foo") 或者 
- 级联依赖继承 

配置移到 target 域的外面，也就是根作用域中去设置，这样对当前 xmake.lua 以及所有子 xmake.lua
中的 target 都会生效。

```lua
add_links("tbox")
add_linkdirs("lib")
add_includedirs("include")
add_defines("FOOBAR")
add_deps("dep1", "dep2", {inherit = false})

-- includes("subdirs")
includes("subdirs/xmake.lua")
includes("test/*/xmake.lua")
includes("test/**/xmake.lua")

target("test1")
    set_kind("binary")
    -- set_kind("static") static library
    -- set_kind("shared") dynamic library
    add_files("src/test1/*.c")
    add_includedirs("inc") -- 默认私有头文件目录不会被继承
    add_includedirs("inc1", {public = true}) -- 此处的头文件相关目录也会被继承
    
target("test2")
    set_kind("binary")
    add_files("src/test2/*.c")    
```

以上这两 target 都需要链接 tbox 库，放置在外层根域设置，test1 和 test2 都能加上对应 links。
那如果某个 target 依赖另外一个 tatget 生成的静态库，或者依赖彼此的配置内容，设置方法如下：

- add_linkdirs 和 add_links 指定为对应 target 的输出目录，然后链接上。
- add_deps 依赖指定 target 的配置，继承设置：linkdirs, links, includedirs 以及 defines
- 继承关系是支持级联的，target 默认自动导出设置，可以禁用默认的继承行为：{inherit = false}。

上述配置中，test1 和 test2 都会用到 lib 目录下的 tbox，并且需要获取到库的头文件路径，库路径
和链接。test1 目标和另外两个库目标之间是有编译顺序依赖的，如果 test1 先编译就会提示链接库找不到。
并且，现在有了依赖关系，xmake 在编译的时候，会自动处理这些 target 之间的编译顺序，保证不会出现
链接的时候，依赖库还没有生成的问题。

通过 add_deps() 可以关联上指定的目标，并不要求有目录层级关系约束。使用 includes 来加载文件路径
层级关系，所有跟路径相关的配置接口，比如 add_files, add_includedirs 等都是相对于当前子工程
xmake.lua 脚本所在的目录。所以只要添加的文件不跨模块，那么设置起来只需要考虑当前的相对路径就行了。

注意：includes 这个接口属于全局接口，不隶属于任何 target，所以请不要在 target 内部调用。支持
模式匹配进行批量导入。


目前对于 target 的编译链接 flags 相关接口设置，都是支持继承属性的，可以人为控制是否需要导出
给其他 target 来依赖继承，目前支持的属性有：

|    属性   |                            描述                            |
|-----------|------------------------------------------------------------|
| private   | 作为当前 target 的私有配置，不会被依赖的其他 target 所继承 |
| public    | 当前 target 和子 target 都会被设置                         |
| interface | 仅被依赖的子 target 所继承设置，当前 target 不参与             |

借鉴了 cmake，目前 xmake 只要跟 target 相关的所有编译链接设置接口，都是支持可见性导出的，
例如：add_includedirs, add_defines, add_cflags 等等。



```lua
target("test")
    -- Add source files in the project source directory
    add_files("$(projectdir)/src/*.c")

    -- Add a header file search path under the build directory
    add_includedirs("$(buildir)/inc")

    on_run(function (target)
        -- Copy the header file in the current script directory to the output directory
        os.cp("$(scriptdir)/xxx.h", "$(buildir)/inc")
    end)

target("user_var")
    -- xmake f --var=val
    add_defines("-DTEST=$(var)")
```

工程示范，hello-xmake 工程依赖子项目：hello 和 world，前者是静态库，后者是动态库：

    hello-xmake
    │     xmake.lua
    ├─hello
    │  │  xmake.lua
    │  └─src
    │          main.c
    ├─src
    │      main.c
    └─world
        │  xmake.lua
        └─src
                main.c

    xmake f -p mingw -m debug --debugger=gdb --sdk=C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2
    xmake f -p mingw -m debug --debugger=gdb --sdk=C:\\mingw
    xmake -r
    xmake run hello-xmake

    xmake f --toolchain=llvm -m debug --debugger=gdb --sdk=c:\llvm
    xmake -r
    xmake run hello-xmake

为简化文件的输出路径，使用内置变量 $(projectdir) ，它表示项目全局根目录，或者以下两个方法：

- set_objectdir Set output directories for object files
- set_targetdir Set output directories for target files

```lua
-- base xmake.lua
add_rules("mode.debug", "mode.release")

includes("hello/xmake.lua")
includes("world/xmake.lua")

target("hello-xmake")
    set_kind("binary")
    add_files("src/*.c")
    add_links("hello")
    add_links("world")
    add_linkdirs("$(buildir)")

-- world xmake.lua
target("world") -- target("hello-xmake")
    set_kind("shared")
    add_files("src/*.c")
    set_targetdir("$(buildir)")

-- world xmake.lua
target("hello")
    set_kind("static")
    add_files("src/*.c")
    set_targetdir("$(buildir)")
```

动态库和静态库在不同平台下的几点差别：
[A.1 — Static and dynamic libraries](https://www.learncpp.com/cpp-tutorial/a1-static-and-dynamic-libraries/)
[Dynamic linking best practices(https://begriffs.com/posts/2021-07-04-shared-libraries.html)
[LLVM Command Guide](https://llvm.org/docs/CommandGuide/index.html)
[Building a Dynamic Library](https://mottosso.gitbooks.io/clang/content/building_a_dynamic_library.html)

- static library 也称 archive，Linux 和 Windows 系统分别使用 .a 和 .lib 文件。
- dynamic library 也称为 shared library，Linux 和 Windows 系统上分别为 .so 和 .dll 文件；
- 因为动态库需要在编译期向程序导入符号信息，又需要一个导入库 import library：
    - Windows 的导入库使用一个小型静态库 (.lib)记录这些信息。
    - Linux 系统上，动态库和导入库都是 .so 文件。

Windows 系统上编写 DLL，其导出符号有两种定义方式，DEF 文件导出和 `_declspec` 导出。动态库代码
参考写法，这需要使用 clang++ 编译，如果使用 clang 将其作为 C 语言编译，可能不会生成 .lib 文件：

```C++
#ifdef __cplusplus
extern "C" {
#endif
    
    __declspec(dllexport)
    const char* world()
    {
        return "world!\n";
    }
    
#ifdef __cplusplus
}
#endif
```

其中 `extern "C"` 是 C++ 中用来定义一个 external linkage，同时避免导出符号因 C++ 方式
重载机制进行 Name mangling。Clang 编译器可能要求比 GCC 较严格，即没有导出标记，GCC 也能导出。
但是，Clang 不能，有可能是 xmake 的问题，手动执行命令可以正常导出，但在 xmake.lua 脚本不行。

    clang -c -Qunused-arguments -m64 -g -O0 -fexceptions -fcxx-exceptions -o world\src\main.c.obj world\src\main.c
    llvm-ar cr build\world.lib world\src\main.c.obj

    clang++ -o build\world.dll world\src\main.c -shared -m64 -g

链接需要这个导入库，可以使用 llvm-lib 工具生成导入库。这是一个 Library Manager (LIB.exe) 
兼容的工具 https://msdn.microsoft.com/en-us/library/7ykb2k5f 

使用 dumpbin 工具可以查看 dll 文件中导出的函数符号：

> dumpbin.exe /exports .\build\world.dll

Rule 是和文件类型关联的一套规则，rule() 方法定义一套规则，在内部用 `set_extensions` 方法
将此规则与指定文件类型关联。所有 `add_files` 添加到 Target 中的文件都会受到规则的影响。Xmake
内部定义了一系列规则，用户也可以创建自己的规则以实现特定的编译流程。但是，一旦使用 `add_rules`
将规则附加到 Target，其默认的编译流程就会受到影响，所以需要明显自定义规则意味什么。

xmake.lua 文件相当于一个 Project 对象，内部可以定义 Targets 或者 Rules，API 参考：

    print("is_os windows:", is_os("windows"))
    print("is_kind binary:",is_plat("binary"))
    print("is_arch x64:",   is_arch("x86_64"))
    print("is_mode debug:", is_mode("debug"))
    print("is_plat mingw:", is_plat("mingw"))
    print("is_config runtime or luajit:", is_config("runtime", "luajit"))
    print("get_config debugger:", get_config("debugger"))

- **target:compiler("cxx")** 获取文件类型对应的编译器对象，但却不能荻是什么编译器。
- **target:linker()** 获取的链接程序也类似，只是不用传入参数。
- **target:platform()** 获取平台对象，提供 name() 或 arch() 等信息。
- **target:toolchain()** 平台与工具链关联，例如 :toolchain("llvm") 获取工具链，如果存在。
- **target:toolchains()** Target 可以获取工具链集合。
- **target:tool(toolkind)** 获取工具对象，对应 toolchain.tool() 方法。
- **target:has_tool(toolkind, ...)** 判断是否存在指定语言的“工具们”。

这个 has_tool 方法就和上面的注解一样古怪，它需要指定一个语言类型，然后再指定编译工具。

Platform 是一个混乱的信息集合，不仅仅是关于操作系统、CPU 的信息，还会和编译器相关，如 mingw。
工具链可以获取 name() 和 sdkdir() 信息，以及具体的工具类型信息 toolkind，如 cc、cxx、cpp、
ld、sh、ar、as 等等。参考 toolchain.tool(toolchains, toolkind, opt)

以下脚本，通过 before_build 逻辑的重写，克服了前面 Clang 不会生成 .lib 导入库的问题。

```lua
target("world")
    set_kind("shared")
    -- set_kind("binary")
    -- add_cxflags("-xc++")
    -- add_files("src/*.c")
    add_files("src/*.cpp")
    set_targetdir("$(buildir)")
    -- add_rules("cppfront")

    -- xmake\core\src\demo\xmake.lua:51
    -- copy target to the build directory
    after_build(function (target, opt)
        if not os.isfile(target:targetfile()) then
            print("=== Not a file ", target:targetfile())
            return
        end
        local extension = is_plat("windows", "llvm","mingw") and ".exe" or ""
        print("==> after build", target._NAME, target:targetfile(), extension)
        os.cp(target:targetfile(), "$(buildir)/"..target:targetfile().. extension)
    end)

    before_build(function (target, opt)
        local pt = target:platform()
        local tc = target:toolchain("llvm")
        print({
            platform = pt:name(), architecture = pt:arch(),
            toolchain = tc and tc:name(),
            sdkdir = tc and tc:sdkdir(),
            cpp = tc and tc:tool("cpp"),
            cxx = tc and tc:tool("cxx"),
            has_cc_lang = target:has_tool("cc", "clang"),
            has_cc_gcc = target:has_tool("cc", "gcc"),
        })
        if not target:has_tool("cc", "clang") then
            print("== Is not LLVM", plat)
            return
        end
        print("==> before_build", target._NAME, "$(platform)")
        os.exec("clang++ -o build\\world.dll ${scriptdir}\\src\\main.cpp -shared -m64 -g ")
        -- os.run("touch here")
    end)
```

- [Custom build rule](https://xmake.io/#/manual/custom_rule)
- xmake-docs\manual\custom_rule.md
- https://tboox.org/cn/2017/09/28/xmake-sourcecode-arch/
- xmake\xmake\core\base\interpreter.lua@api_define
- xmake\xmake\core\project\project.lua
- xmake\xmake\core\project\target.lua@apis
- xmake\xmake\core\project\rule.lua@apis
- xmake\xmake\core\platform\platform.lua
- xmake\xmake\core\tool\toolchain.lua
- xmake\xmake\core\tool\compiler.lua
- xmake\xmake\core\tool\linker.lua
- xmake\xmake\actions\build\kinds\object.lua
- xmake\xmake\actions\build\build.lua
- xmake\xmake\rules\c++\modules\xmake.lua

当一般的配置设置不能满足需要时，可以使用 lua 脚本对自定义规则和 Target 进行深度定制，它们包含
以下这些基本的事件流程，参考源代码中的定义，API 分为多种，其中脚本事件相关部分参考如下：

    on_load -> after_load -> on_config -> before_build -> on_build -> after_build

Xmake 2.1.5 版本后，可以在第一个参数设置平台过滤，只有匹配的平台才会执行相应的脚本方法。

        -- rule.on_xxx                      -- target.on_xxx
        "rule.on_run"                       "target.on_run"
        ,   "rule.on_load"                  ,   "target.on_load"
        ,   "rule.on_config"                ,   "target.on_config"
        ,   "rule.on_link"                  ,   "target.on_link"
        ,   "rule.on_build"                 ,   "target.on_build"
        ,   "rule.on_build_file"            ,   "target.on_build_file"
        ,   "rule.on_build_files"           ,   "target.on_build_files"
        ,   "rule.on_clean"                 ,   "target.on_clean"
        ,   "rule.on_package"               ,   "target.on_package"
        ,   "rule.on_install"               ,   "target.on_install"
        ,   "rule.on_uninstall"             ,   "target.on_uninstall"
        ,   "rule.on_linkcmd"               -- target.before_xxx
        ,   "rule.on_buildcmd"              ,   "target.before_run"
        ,   "rule.on_buildcmd_file"         ,   "target.before_link"
        ,   "rule.on_buildcmd_files"        ,   "target.before_build"
        -- rule.before_xxx                  ,   "target.before_build_file"
        ,   "rule.before_run"               ,   "target.before_build_files"
        ,   "rule.before_load"              ,   "target.before_clean"
        ,   "rule.before_link"              ,   "target.before_package"
        ,   "rule.before_build"             ,   "target.before_install"
        ,   "rule.before_build_file"        ,   "target.before_uninstall"
        ,   "rule.before_build_files"       -- target.after_xxx
        ,   "rule.before_clean"             ,   "target.after_run"
        ,   "rule.before_package"           ,   "target.after_load"
        ,   "rule.before_install"           ,   "target.after_link"
        ,   "rule.before_uninstall"         ,   "target.after_build"
        ,   "rule.before_linkcmd"           ,   "target.after_build_file"
        ,   "rule.before_buildcmd"          ,   "target.after_build_files"
        ,   "rule.before_buildcmd_file"     ,   "target.after_clean"
        ,   "rule.before_buildcmd_files"    ,   "target.after_package"
        -- rule.after_xxx                   ,   "target.after_install"
        ,   "rule.after_run"                ,   "target.after_uninstall"
        ,   "rule.after_load"
        ,   "rule.after_link"
        ,   "rule.after_build"
        ,   "rule.after_build_file"
        ,   "rule.after_build_files"
        ,   "rule.after_clean"
        ,   "rule.after_package"
        ,   "rule.after_install"
        ,   "rule.after_uninstall"
        ,   "rule.after_linkcmd"
        ,   "rule.after_buildcmd"
        ,   "rule.after_buildcmd_file"
        ,   "rule.after_buildcmd_files"

命名规范参考手册说明 xmake-docs\manual\specification.md
Target API 参考手册 xmake-docs\manual\target_instance.md
条件判断 xmake-docs\manual\conditions.md

|   Interfaces  |                  Description                  | version  |
|---------------|-----------------------------------------------|----------|
| [is_os]       | windows linux android macosx ios              | >= 2.0.1 |
| [is_arch]     | x86_64 i386 armv7 arm64 armv7s ...            | >= 2.0.1 |
| [is_plat]     | windows linux macosx android iphoneos watchos | >= 2.0.1 |
| [is_host]     | windows linux macosx                          | >= 2.1.4 |
| [is_subhost]  | msys cygwin                                   | >= 2.1.4 |
| [is_mode]     | debug release profile ...                     | >= 2.0.1 |
| [is_kind]     | static shared binary                          | >= 2.0.1 |
| [is_config]   | Is the given config values?                   | >= 2.2.2 |
| [has_config]  | Is the given configs enabled?                 | >= 2.2.2 |
| [has_package] | Is the given dependent package enabled?       | >= 2.2.3 |


用户变量可以使用 xmake f --var=val 进行配置，脚本中直接可使用变量 "$(var)"，内建变量如下：
xmake-docs\manual\builtin_variables.md

|   Interface   |                Description                 | Versions |
|---------------|--------------------------------------------|----------|
| $(os)         | Get the OS of the current build platform   | >= 2.0.1 |
| $(host)       | Get native OS                              | >= 2.0.1 |
| $(tmpdir)     | Get Temporary Directory                    | >= 2.0.1 |
| $(curdir)     | Get current directory                      | >= 2.0.1 |
| $(buildir)    | Get the build output directory             | >= 2.0.1 |
| $(scriptdir)  | Get Project Description Script Directory   | >= 2.1.1 |
| $(globaldir)  | Get Global Configuration Directory         | >= 2.0.1 |
| $(configdir)  | Get Local Project Configuration Directory  | >= 2.0.1 |
| $(programdir) | xmake installation script directory        | >= 2.1.5 |
| $(projectdir) | Get the project root directory             | >= 2.0.1 |
| $(shell)      | Execute external shell command             | >= 2.0.1 |
| $(env)        | Get external environment variables         | >= 2.1.5 |
| $(reg)        | Get the value of the Windows registry item | >= 2.1.5 |

内置模块及 OS 操作参考 

- xmake-docs\manual\builtin_modules.md
- xmake\xmake\core\base\os.lua

命令行界面输出可以使用 dark 主题，输出内容彩色显示，可以设置为 plain 去掉控制台的颜色属性。

    xmake g --theme=plain
    xmake g --theme=emoji
    xmake g --clean


各家编译器会使用不同的预定义符号，通过这些特殊符号可以区别代码当前处理什么编译环境之下：

- [Pre-defined Compiler Macros Wiki](https://sourceforge.net/p/predef/wiki/Compilers/)
- [Guide to predefined macros in C++ compilers (gcc, clang, msvc etc.)](https://blog.kowalczyk.info/article/j/guide-to-predefined-macros-in-c-compilers-gcc-clang-msvc-etc..html)

CMake 构建工具生成的测试程序 CMakeCXXCompilerId.cpp 也会包含这些特殊宏定义，测试程序使用它们
来对当前系统的编译环境进行检测，里面包含了各种系统的检测。

```C++
    #if defined (_MSC_VER)
    // code specific to Visual Studio compiler
    #endif

    #if defined(__GNUC__) && (__GNUC___ > 5 || (__GNUC__ == 5 && __GNUC_MINOR__ >= 1))
    // this is gcc 5.1 or greater
    #endif

    // clang
    // __clang_major__ __clang_minor__ __clang_patchlevel__

    // Checking for OS (platform)
    // 
    // Linux and Linux-derived           __linux__
    // Android                           __ANDROID__ (implies __linux__)
    // Linux (non-Android)               __linux__ && !__ANDROID__
    // Darwin (Mac OS X and iOS)         __APPLE__
    // Akaros (http://akaros.org)        __ros__
    // Windows                           _WIN32
    // Windows 64 bit                    _WIN64 (implies _WIN32)
    // NaCL                              __native_client__
    // AsmJS                             __asmjs__
    // Fuschia                           __Fuchsia__

    // Checking the compiler:
    // 
    // Visual Studio       _MSC_VER
    // gcc                 __GNUC__
    // clang               __clang__
    // emscripten          __EMSCRIPTEN__ (for asm.js and webassembly)
    // MinGW 32            __MINGW32__
    // MinGW-w64 32bit     __MINGW32__
    // MinGW-w64 64bit     __MINGW64__
```

Sublime 工程文件中配置构建工具可以很方便地调用 Clang/GCC/MSVC 编译 C++20 程序，配置参考如下。
以下是 Windows 系统，Visual Studio 2019 社区版，MinGW-w64 GCC 12.2 以及 LLVM Clang 14，
等三大编译器的 Sublime 构建配置参考。需要注意，Clang 中没有专门处理模块的依赖关系，所以这种情况下，
编译可能不通过：

```json
{
    "folders":
    [
        {"path": ".", },
    ],
    "settings":
    {
        "LSP": { "clangd": {"enabled": true, }, },
    },
    "build_systems":
    [
        {
            "name":"GCC & Clang",
            "env": {
                "PATH": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\\bin;%PATH%",
                "VS2019": "\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\Tools\\VsDevCmd.bat\" -arch=x64 -host_arch=x64",
                "ccv": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\\bin\\g++.exe",
                "ccu": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\\bin\\g++.exe",
                "fmtlib": "/3rd/fmtlib/include",
            },
            "shell_cmd": "\"%ccv%\" --help || \"%ccu\" --help",
            "file_regex": "^\\.?\\.?/?(.*?):([0-9]*):([0-9]*): (.+)",
            // "working_dir": "${project_path:${folder}}",
            "working_dir": "${file_path}",
            "selector": "source.c++, source.c",
            "encoding":"GBK",
            "quiet": true,
            "variants":[
                { "name":"Clean build", "shell_cmd": "del /q /s build\\*.*", },
                {
                    "name":"G++ (-std=c++20) Active File",
                    "shell_cmd":"mkdir build & cd build && %ccu% -g -x c++ -std=c++20 -I\"${project_path}%fmtlib%\" -fmodules-ts \"$file\" -o $file_base_name && ${file_base_name} && Echo done ",
                },
                {
                    "name":"G++ (-std=c++20) Active Modules (.cc .cxx)",
                    "shell_cmd":"mkdir build & cd build && %ccu% -g -x c++ -std=c++20 -I\"${project_path}%fmtlib%\" -fmodules-ts ../*.cpp ../*.ixx ../*.cc ../*.cxx -o $file_base_name && ${file_base_name} && Echo done ",
                },
                {
                    "name":"G++ (-std=c++20) Active Modules (.ixx)",
                    "shell_cmd":"mkdir build & cd build && %ccu% -g -x c++ -std=c++20 -I\"${project_path}%fmtlib%\" -fmodules-ts ../*.cpp ../*.ixx -o $file_base_name && ${file_base_name} && Echo done ",
                },
                {
                    "name":"Clang++ (-std=c++20) Active File",
                    "shell_cmd":"cmd /c \"%VS2019% && mkdir build & cd build && clang++ -I\"${project_path}%fmtlib%\" -g -std=c++20 \"$file\" -o $file_base_name.exe && ${file_base_name} && Echo done \" ",
                },
                {
                    "name":"Clang++ (-std=c++20) Active Modules (.cppm)",
                    "shell_cmd":"cmd /c \"%VS2019% && mkdir build & cd build && powershell /c \"clang++ -std=c++20 --precompile (dir ../*.cppm) ; echo ===== ; clang++ -g -std=c++20 -I\"${project_path}%fmtlib%\" -fprebuilt-module-path=\"$file_path/build\" (dir *.pcm) (dir ../*.cpp) -o $file_base_name.exe \" && ${file_base_name} && Echo done \" ",
                },
                {
                    "name":"Clang++ (-std=c++20) Active Modules (.ixx)",
                    "shell_cmd":"cmd /c \"%VS2019% && mkdir build & cd build && powershell /c \"clang++ -xc++-module -std=c++20 --precompile (dir ../*.ixx) ; echo ===== ; clang++ -g -std=c++20 -I\"${project_path}%fmtlib%\" -fprebuilt-module-path=\"$file_path/build\"  (dir *.pcm) (dir ../*.cpp) -o $file_base_name.exe \" && ${file_base_name} && Echo done \" ",
                },
            ],
        },
        {
            "name":"Xmake",
            "env": {
                "PATH": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\\bin;%PATH%",
                "VS2019": "\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\Tools\\VsDevCmd.bat\" -arch=x64 -host_arch=x64",
                "CCU": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2",
                "CLANG": "C:\\LLVM",
                "fmtlib": "/3rd/fmtlib/include",
                "plain": "xmake g --theme=plain",
                "emoji": "xmake g --theme=emoji",
            },
            "shell_cmd": "xmake --help",
            "file_regex": "^\\.?\\.?/?(.*?):([0-9]*):([0-9]*): (.+)",
            "working_dir": "${project_path:${folder}}",
            "selector": "source.lua",
            "encoding":"GBK",
            "quiet": true,
            "variants":[
                {   "name": "Theme: dark", "shell_cmd": "xmake g --theme=dark"},
                {   "name": "Theme: default", "shell_cmd": "xmake g --theme=default"},
                {   "name": "Theme: emoji", "shell_cmd": "xmake g --theme=emoji"},
                { 
                    "name":"Clean & set plain text", 
                    "shell_cmd": "del /q /s build\\*.* & del /q /s .xmake\\*.*", 
                },
                {
                    "name":"Use GCC",
                    "shell_cmd":"%plain% && xmake f -y -m debug -p mingw --sdk=%CCU% --debugger=gdb & xmake -b -v",
                },
                {
                    "name":"Use Clang",
                    "shell_cmd":"%plain% && xmake f -y -m debug --toolchain=llvm --sdk=%CLANG% --debugger=gdb & xmake -b -v",
                },
                {
                    "name":"Use MSVC",
                    "shell_cmd":"%plain% && xmake f -y -m debug -p windows --debugger=gdb & xmake -b -v ",
                },
            ],
        },
        {
            "name":"MSVC Compiler",
            "env": {
                "msvc19":"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\Tools\\VsDevCmd.bat",
                "msvc22":"C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat",
                "VCToolsInstallDir": "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.35.32215\\",
                "cc20":"cl /std:c++20 /EHsc /MTd",
                "ccla":"cl /std:c++latest /W4 /EHsc /MTd",
            },
            "shell_cmd": "cmd /c \"\"%msvc19%\" && \"%msvc22%\"\"",
            "file_regex": "^\\.?\\.?\\\\?(.*?)\\(([0-9]+)\\): (.*)",
            "working_dir": "${file_path}",
            "selector": "source.c++, source.c, source.ixx",
            "encoding":"GBK",
            "quiet": true,
            "variants":[
                { "name":"Visual Studio 2019", "shell_cmd": "cmd /c \"\"%msvc19%\" && cl /help\"", },
                { "name":"Visual Studio 2022", "shell_cmd": "cmd /c \"\"%msvc22%\" && cl /help\"", },
                {
                    "name":"MSVC v16.x (/std:c++20) ACTIVE FILE",
                    "shell_cmd": "cmd /c \"\"%msvc19%\" && mkdir build & cd build && %cc20% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} ",
                },
                {
                    "name":"MSVC v16.x (/std:c++latest) ACTIVE FILE",
                    "shell_cmd": "cmd /c \"\"%msvc19%\" && mkdir build & cd build && %ccla% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} ",
                },
                {
                    "name":"MSVC v16.x (/std:c++20)",
                    "shell_cmd": "cmd /c \"\"%msvc19%\" && mkdir build & cd build && %cc20% ..\\*.ixx ..\\*.cpp /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} ",
                },
                {
                    "name":"MSVC v17.x (/std:c++20) ACTIVE FILE",
                    "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build & cd build && %cc20% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} ",
                },
                {
                    "name":"MSVC v17.x (/std:c++latest) ACTIVE FILE",
                    "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build & cd build && %ccla% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} ",
                },
                {
                    "name":"MSVC v17.x (/std:c++latest)",
                    "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build & cd build && %ccla% ..\\*.ixx ..\\*.cpp /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} ",
                },
                {
                    "name":"MSVC v17.x (build named module: std & std.compat)",
                    "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build & cd build && %ccla% /c \"%VCToolsInstallDir%\\modules\\std.ixx\" \"%VCToolsInstallDir%\\modules\\std.compat.ixx\"\" && echo Done",
                },
            ],
        },
    ],
}
```

## ==⚡ MSVC & C++20

Visual Studio 2019 默认没有支持 C++20，也未完全支持模块。编写和使用自己的模块通常效果很好，
但导入标准库标头就不能做到开箱即用。VS 2019 16.8 版本才开始支持 P1103R3 Modules。

首先，需要修改项目配置，启用 C++20 规范或草案，使用右键菜单设置项目属性：

- C/C++ ➪ Language ➪ C++ Language Standard 
    - ISO C++20 Standard (/std:c++20) 
    - Preview - Features from the Latest C++ Working Draft (/std:c++latest)

为了实现标准库可以作为模块导入，需要做一点标头单元的处理工作，将需要引用的标准库统一放置在一个
全局头文件中，比如 HeaderUnits.h，它包含所有标准库的导入：

```C++
    // HeaderUnits.h
    #pragma once
    import <iostream>;
    import <format>;
    import <vector>;
    import <optional>;
    import <utility>;
    // ...
```

Visual Studio 2019 项目的解决方案浏览器中，执行以下操作，通过右键设置 HeaderUnits.h 属性，
在 Configuration Properties 面板中按以下步骤设置：

- General ➪ Item Type  ➪  C/C++ Compiler 设置好并应用设置；
- C/C++ ➪ Advanced ➪
    - Compile as C++ Header Unit (/exportHeader)
    - Compile as C++ Module Internal Partition (/internalPartition)

经过以上设置，MSBuild 工程文件中会有相应更新：

```xml
  <ItemGroup>
    <ClCompile Include="../modules/HeaderUnits.h">
      <CompileAs Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">CompileAsHeaderUnit</CompileAs>
      <CompileAs Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">CompileAsHeaderUnit</CompileAs>
    </ClCompile>
    <ClCompile Include="../modules/hello.cpp" />
  </ItemGroup>
```

如果没出现相应的 C++ Header Unit 高级主编译选项，那么就需要更新到最新版本。标头单元编译功能需要
Visual Studio 2019 version 16.10 以上版本支持，MSVC 编译器版本号为 19.29。

然后，重新编译项目，/exportHeader (Create header units) 选项会让编译器生成标头单元文件。
编译器会为标头单元生成相应的 IFC (.ifc) 文件，这里生成的是 HeaderUnits.h.ifc。

标头单元**header unit**是头文件的二进制表示，MSVC 使用 .ifc 扩展名表示标头单元文件，以及
编译好的命名模块 (.ixx, .cppm, .h, .hpp)。

如果使用模块实现分区，也称为内部分区 Internal Partition，可以设置 /internalPartition。

编译生成成标头单元文件后，使用 /headerUnit 来引用它，将标头单元文件与头文件关联起来：

> **`/headerUnit`** *`header-filename`*=*`ifc-filename`*\
> **`/headerUnit:quote`** \[*`header-filename`*=*`ifc-filename`*\]\
> **`/headerUnit:angle`** \[*`header-filename`*=*`ifc-filename`*\]

> **`/sourceDependencies-`**\
> **`/sourceDependencies`** *filename*\
> **`/sourceDependencies`** *directory*

后缀 quote 和 angle 分别表示查找已编译的标头单元文件的两种规则，分别是按 `#include "file"`
和 `#include <file>` 一样的规则查找。没有后缀则在当前目录下，或者按指定的 ifc 文件路径查找。

MSVC 提供多个标头单元编译方法：

01. Build a shared header unit project，使用一个静态库工程引用需要使用的标头单元，
    这种方法可以更精细控制导入库的标头单元。
    https://learn.microsoft.com/en-us/cpp/build/walkthrough-import-stl-header-units?view=msvc-160
02. 将单个头文件编译为标头单元，即上面介绍的操作方法，适用于少量头文件的处理。
    https://learn.microsoft.com/en-us/cpp/build/walkthrough-header-units?view=msvc-160#approach1
03. Automatically scan for and build header units. 自动扫描头文件并编译标头单元，需要
    对项目源代码做描述。项目需要做如下配置：
    - All Configurations → C/C++ → General
    - → Scan Sources for Module Dependencies (YES)
    - → Translate Includes to Imports (/translateInclude)
    https://learn.microsoft.com/en-us/cpp/build/walkthrough-header-units?view=msvc-160#approach2
04. VS 2019 16.11 版本支持使用 /std:c++20 直接将 include 的头文件编译为标头单元而无需改动源代码。

标头单元配置文件 header-units.json 有两个目的：

- 在指定 /translateInclude 编译选项时用来确定那些头文件需要转译成标头单元。
- 最小化复制符号以提高编译命令生成的吞吐量。


为了查看 Visual Studio 编译过程的细节信息，可以打开选项设置为诊断输出模式：

- Tools ➪ Options... ➪ Projects and Solutions ➪ Build And Run ➪ 
    - MSBuild project build output verbosity ➪ Diagnostic

或者使用 msbuild 命令进行构建，：

    msbuild ..\msvc\demo.vcxproj -t:Rebuild -property:platform=x86

编译标头单元的 MSVC 命令行就如以下那样使用了非常复杂的、繁多的参数，但是构建一个标头单元配置文件
需要使用 /sourceDependencies:directives 编译指令，此指令需要在标头单元文件 .ifc 文件生成
之前使用。

然后，再使用一个名称类似的指令 /sourceDependencies，它会根据源代码级别依赖，将标准库头文件
编译为标头单元，同时生成依赖信息文件，.ifc.d.json。

得到标头单元文件后，再使用 /headerUnit 指令将其与源头文件或标准库文件关联起来，最后与程序源代码
编译生成可执行程序。

```sh
    # VCToolsInstallDir
    $VCDIR = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133"
    $iostream = $VCDIR+"\include\iostream"
    $format = $VCDIR+"\include\format"

    # gen header-units.json
    CL.exe /nologo /c /std:c++20 /translateInclude /sourceDependencies:directives "Debug" /exportHeader ./HeaderUnits.h

    CL.exe /nologo /c /EHsc /MDd /std:c++20 /sourceDependencies:directives "Debug\iostream.module.json" /exportHeader "$iostream"

    CL.exe /nologo /c /EHsc /MDd /std:c++20 /sourceDependencies:directives "Debug\format.module.json" /exportHeader "$format"


    # gen header units ifc files
    CL.exe /nologo /c /EHsc /MDd /std:c++20 /ifcOutput "Debug\iostream.ifc" /sourceDependencies "Debug\iostream.ifc.d.json" /Fo"Debug\iostream.obj" /exportHeader "$iostream"

    CL.exe /nologo /c /EHsc /MDd /std:c++20 /ifcOutput "Debug\format.ifc" /sourceDependencies "Debug\format.ifc.d.json" /Fo"Debug\format.obj" /exportHeader "$format"

    CL.exe /nologo /c /headerUnit "$($VCDIR)\include\iostream=Debug\iostream.ifc" /headerUnit "$($VCDIR)\include\format=Debug\format.ifc" /EHsc /MDd /std:c++20 /ifcOutput "Debug\HeaderUnits.h.ifc" /Fo"Debug\HeaderUnits.h.obj" /sourceDependencies "Debug\HeaderUnits.h.ifc.d.json" /exportHeader  HeaderUnits.h

    # Compile app and Link
    CL.exe /nologo /headerUnit HeaderUnits.h=msvc\Debug\HeaderUnits.h.ifc /headerUnit "$($VCDIR)\include\iostream=Debug\iostream.ifc" /headerUnit "$($VCDIR)\include\format=Debug\format.ifc" /EHsc /MDd /std:c++20 ../modules/hello.cpp /Fo:"Debug\\"

    # Or
    CL.exe /nologo /c /headerUnit HeaderUnits.h=msvc\Debug\HeaderUnits.h.ifc /headerUnit "$($VCDIR)\include\iostream=Debug\iostream.ifc" /headerUnit "$($VCDIR)\include\format=Debug\format.ifc" /EHsc /MDd /std:c++20 ../modules/hello.cpp /Fo:"Debug\hello.obj"

    link.exe /nologo /ERRORREPORT:QUEUE /OUT:"Debug\demo.exe" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /SUBSYSTEM:CONSOLE Debug\hello.obj
```

很遗憾的是，按编译流程日志执行，最后链接时会出现 LNK2019 外部符号无定义的问题，即导入库失败：

    std::char_traits<char> >::sentry::sentry()
    std::char_traits<char> >::sentry::~sentry(void)
    std::basic_ostream<char,struct std::char_traits<char> >::sentry::operator bool(void)
    std::_Container_base12::_Orphan_all(void)
    std::_Adjust_manually_vector_aligned()
    std::vformat()
    std::_Format_arg_index()
    std::_Format_arg_index::_Type()

用户模块的编译和导入就没那么复杂了，因为不需要处理标准库的细节关联：

    cl.exe /std:c++latest /EHsc /MD /experimental:module /c math1.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module /c math2.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module /c mod.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module app.cpp math1.obj math2.obj mod.obj

虽然，MSVC 也不像 Clang 那样要求模块文件名与模块名保持一致，但保持一致的名称直的是个好习惯。
生成的 .ifc 会随模块名称命名，而不是模块的文件名：

```C++,ignore
    // Module mod.ixx
    export module mod;

    export import mod.math1;
    export import mod.math2;

    // Submodule mod.math1
    // math1.ixx
    export module mod.math1; 

    export int add(int fir, int sec) {
        return fir + sec;
    }

    // Submodule mod.math2
    // math2.ixx
    export module mod.math2;

    export {
        int mul(int fir, int sec) {
            return fir * sec;
        }
    }
     
    // app.cpp
    import std.core;
    import mod;

    int main() 
    {
        std::cout << std::endl;
        std::cout << "add(1, 2): " << add(1, 2) << std::endl;
        std::cout << "mul(3, 4): " << mul(3, 4) << std::endl;
    }
```

接口与实现分离式的模块如下，处理方式基本一致：

    cl.exe /std:c++latest /EHsc /MD /experimental:module /c mod.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module /c mod.cpp
    cl.exe /std:c++latest /EHsc /MD /experimental:module app.cpp mod.obj

```C++,ignore
    // interface unit mod.ixx
    module;
    export module mod;

    export namespace mod 
    {
        const char* helloworld();
    }

    // implementation unit mod.cpp
    module mod;

    namespace mod 
    {
        const char* helloworld()
        {
            return "Hello World!";
        }
    }

    // app.cpp
    #include <iostream>
    import mod;

    int main() {
        std::cout << mod::helloworld() << std::endl;
    }
```

对于模块分区，Module partitions，就需要在接口单元中导出分区 `export import :partition;`。
而分区单元中，就需要 `export module interface:partition` 标记为上级模块的子分区。 

    cl.exe /std:c++latest /EHsc /MD /experimental:module /c ..\math1.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module /c ..\math2.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module /c ..\mod.ixx
    cl.exe /std:c++latest /EHsc /MD /experimental:module mod.obj ..\app.cpp

```C++,ignore
    // Module mod.ixx
    export module mod;

    export import :math1;
    export import :math2;

    // math1.ixx partition mod:math1
    export module mod:math1;

    export int add(int fir, int sec) {
        return fir + sec;
    }

    // math2.ixx partition mod:math2
    export module mod:math2;

    export {
        int mul(int fir, int sec) {
            return fir * sec;
        }
    }

    // app.cpp
    import mod;
    #include <iostream>

    int main() 
    {
        std::cout << std::endl;
        std::cout << "add(1, 2): " << add(1, 2) << std::endl;
        std::cout << "mul(3, 4): " << mul(3, 4) << std::endl;
    }
```

C++23 标准库引入了两个命名模块 std 和 std.compat：

01. `std` 导出 C++ standard library 命令空间，包含 std::vector、std::sort 等等，
    同时也包含 C 语言的 <cstdio> 或 <cstdlib> 等标准库，提供 std::printf() 等全局空间函数，
    此外，还支持 stdio.h 这样的头文件包含的 C 全局命名空间的函数；
02. `std.compat` 导出导出 std 中的所有内容，并添加 C 运行时的全局名称空间对应项，例如 
    :printf, ::fopen, ::size_t, ::strlen 等等。此模块引用 C 运行时全局名称空间中的函数、
    类型的代码库更加容易。


Visual Studio 2022 17.5 开始，可以通过 import std 或 std.compat 导入 C++23 标准库，
命令参考如下，先编译命名模块等到标头单元文件，然后在程序代码中导入并使用标准库：

    cl /std:c++latest /EHsc /nologo /W4 /MTd /c "$($env:VCToolsInstallDir)\modules\std.ixx" "$($env:VCToolsInstallDir)\modules\std.compat.ixx"
    cl /std:c++latest /EHsc /nologo /W4 /MTd importExample.cpp std.obj

```C++
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
```

MSVC 编译工具参考说明，/EHsc 和 /MTd 这两个很重要，它们决定了会链接什么动态运行库：

|     Switch     |                        Meaning                        |
|----------------|-------------------------------------------------------|
| /std:c++latest | latest C++ language standard and library.             |
| /std:c++20     | C++20 language standard and library.                  |
| /EHsc          | 使用 C++ 异常处理，除了 extern "C" 标记以外。               |
| /MTd           | Use the static multithreaded debug run-time library.  |
| /MDd           | Use the dynamic multithreaded debug run-time library. |
| /c             | Compile without linking.                              |
| /link          | 给 LINK.EXE 传递参数                                    |
| /translateInclude | Translate Includes to Imports                      |
| /scanDependencies | List module dependencies in standard form          |
| /sourceDependencies | List all source-level dependencies               |
| /sourceDependencies:directives | List module and header unit dependencies |

Module grammar 参考：

    module-name:
        module-name-qualifier-seqopt identifier

    module-name-qualifier-seq:
        identifier .
        module-name-qualifier-seq identifier .

    module-partition:
        : module-name

    module-declaration:
        exportopt module module-name module-partitionopt attribute-specifier-seqopt ;

    module-import-declaration:
        exportopt import module-name attribute-specifier-seqopt ;
        exportopt import module-partition attribute-specifier-seqopt ;
        exportopt import header-name attribute-specifier-seqopt ;

01. https://learn.microsoft.com/en-us/cpp/build/walkthrough-header-units
02. https://learn.microsoft.com/en-us/cpp/cpp/tutorial-import-stl-named-module
03. https://learn.microsoft.com/en-us/cpp/cpp/tutorial-named-modules-cpp
04. https://learn.microsoft.com/en-us/cpp/preprocessor/predefined-macros
05. https://docs.microsoft.com/en-us/cpp/overview/visual-cpp-language-conformance
06. https://learn.microsoft.com/en-us/visualstudio/releases/2019/release-notes
07. [/exportHeader](https://learn.microsoft.com/en-us/cpp/build/reference/module-exportheader)
08. [/headerUnit](https://learn.microsoft.com/en-us/cpp/build/reference/headerunit)
09. [/headerName](https://learn.microsoft.com/en-us/cpp/build/reference/headername)
10. [Overview of modules in C++](https://learn.microsoft.com/en-us/cpp/cpp/modules-cpp)
11. [Visual C++ 中生成和导入标头单元](https://learn.microsoft.com/zh-cn/cpp/build/walkthrough-header-units)
12. [Microsoft C++ Docs](https://github.com/MicrosoftDocs/cpp-docs/)
13. [WSL](https://github.com/Microsoft/WSL/)
14. [Windows Console](https://github.com/Microsoft/Terminal/)
15. [Hyper-V](https://github.com/MicrosoftDocs/Virtualization-Documentation)
16. [Windows Terminal](https://github.com/Microsoft/Terminal/)
17. https://github.com/sirredbeard/Awesome-WSL
18. [C++20: Structure Modules](https://www.modernescpp.com/index.php/c-20-divide-modules)
19. [C++20: Module Interface & Implementation Unit](https://www.modernescpp.com/index.php/c-20-module-interface-unit-and-module-implementation-unit)

