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
-  Bjarne Cxx HOPL4 paper - C++20：方向之争](https://github.com/Cpp-Club/Cxx_HOPL4_zh/blob/main/09.md)
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

C++ 作为向后兼容 C 语言的一种系统底层高级编程语言，它的编译流程也基本和 C 语言的编译流程一致。
C 语言在贝尔实验室刚诞生时，由于当时的计算机资源相当有限，其内存无法完全表示大型源文件的语法树。
所以，为了能够编译大型项目，Dennis Ritchie 采用了分开编译源文件，最后链接形成可执行文件的
编译单元化思想，让大文件的编译成为可能。

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



以下使用 Homebrew 安装的 clang version 15.0.7，以及 GCC 12.2.0。

Clang 模块的一些定义规则：

- 模块文件使用 .cppm 扩展名，不像 GCC 可以使用支持的多个扩展名；
- 模块代码中以 `module;` 打头，但是 `export module` 语句要在 include 指令后面；
- 使用 --precompile 指令预编译模块时，输出名称要和源文件名一致；

模块定义以及测试参考如下，使用 Clang 编译时，一定要保存为 .cppm 文件。如果使用 GCC 编译，
则宽松很多，保存为 .cc 或 .cxx .cpp 都是可以的，并且也不要求导出模块名称与文件名一致。不过，
为了一致，还是保持一致的模块名与文件名为好。

```C++
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
    import HelloWorld;
    #include <iostream>

    using namespace std;

    int main() {
        cout << "Hello? c++" << NS::f() << endl;
    }
```

Clang 编译命令参考，编译标头单元文件需要 Clang 15：

```sh
clang++ -std=c++20 --precompile ../hello.cppm -o hello.pcm
clang++ -std=c++20 -fprebuilt-module-path=. hello.pcm ../hello.cpp -o Hello; ./Hello

clang++ -std=c++20 -stdlib=libc++ -fprebuilt-module-path=. hello.pcm ../hello.cpp -o Hello; ./Hello
clang++ -std=c++20 -stdlib=libc++ -fexperimental-library -ohello hello.cpp; ./hello

clang++ -std=c++20 -xc++-user-header --precompile some.cppm -o iostream.pcm
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


GCC 在文件扩展名上的设计选择是，不支持新的拓展名，只支持原有的 .cc, .cxx, .cpp 等等拓展名。
目前 GCC 12.2 还没有提供 <format> 标准库，使用 {fmt} 库替代。

GCC 编译命令参考，使用 PowerShell：

```sh
    # GCC 12.2.0
    $cclv = "C:\mingw-w64\llvm-mingw-20220906-msvcrt-x86_64\bin\aarch64-w64-mingw32-g++.exe"
    $cclu = "C:\mingw-w64\llvm-mingw-20220906-ucrt-x86_64\bin\aarch64-w64-mingw32-g++.exe"
    $ccv = "C:\mingw-w64\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\bin\g++.exe"
    $ccu = "C:\mingw-w64\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\bin\g++.exe"
    $env:Path += ";C:\mingw-w64\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\bin;"

    &$ccu -std=c++20 -fmodules-ts -xc++-system-header iostream  -xc++-system-header vector
    &$ccu -std=c++20 -fmodules-ts ../hello.cc ../hello.cpp -o hello ; ./hello
    
    # GCC 11 surport to generates a gcm from header
    # then you can use: import "header.h";
    g++-12 -c -std=c++20 -fmodule-header header.h 

    g++-12 -std=c++20 -fmodules-ts ../hello.cc ../hello.cpp -o hello ; ./hello
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
src 目录包含的 fmt.cc 是一个全局模块，它引用了 C++ 标准库，也引用 {fmt} 库：

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

```C++
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

```C++
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

以下是 Windows 系统，Visual Studio 2019 社区版，MinGW-w64 GCC 12.2 以及 LLVM Clang 14，
等三大编译器的 Sublime 构建配置参考，MSVC 部分放在下一节内容：

```json
{
    "env": {
        "PATH": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\\bin;%PATH%",
        "VS2019": "\"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\Tools\\VsDevCmd.bat\" -arch=x64 -host_arch=x64",
        "ccv": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-msvcrt-rt_v10-rev2\\bin\\g++.exe",
        "ccu": "C:\\mingw-w64\\x86_64-12.2.0-release-win32-seh-ucrt-rt_v10-rev2\\bin\\g++.exe",
    },
    "shell_cmd": "\"%ccv%\" --help || \"%ccu\" --help",
    "file_regex": "^\\.?\\.?/?(.*?):([0-9]*):([0-9]*): (.+)",
    "working_dir": "${file_path}",
    "selector": "source.c++, source.c",
    "encoding":"GBK",
    "quiet": true,
    "variants":[
        {
            "name":"G++ (-std=c++20) Active File",
            "shell_cmd":"mkdir build || cd build && %ccu% -g -std=c++20 -fmodules-ts \"$file\" -o $file_base_name && ${file_base_name} && Echo done "
        },
        {
            "name":"G++ (-std=c++20) Active Modules",
            "shell_cmd":"mkdir build || cd build && %ccu% -g -std=c++20 -fmodules-ts ../*.cpp ../*.cc ../*.cxx -o $file_base_name && ${file_base_name} && Echo done "
        },
        {
            "name":"Clang++ (-std=c++20) Active File",
            "shell_cmd":"cmd /c \"%VS2019% && mkdir build || cd build && clang++ -g -std=c++20 \"$file\" -o $file_base_name.exe && ${file_base_name} && Echo done \" "
        },
        {
            "name":"Clang++ (-std=c++20) Active Modules",
            "shell_cmd":"cmd /c \"%VS2019% && mkdir build || cd build && powershell /c \"clang++ -std=c++20 --precompile (dir ../*.cppm); clang++ -g -std=c++20 -fprebuilt-module-path=\"$file_path/build\" (dir *.pcm) (dir ../*.cpp) -o $file_base_name.exe \" && ${file_base_name} && Echo done \" "
        },
    ]
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

如果使用模块实现分区，也称为内部分区 Module Internal Partition，可以设置 /internalPartition。

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


通过 Sublime 构建工具调用 MSVC 编译 C++20 程序，配置参考如下：

```json
{
    "env": {
        "msvc19":"C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\Common7\\Tools\\VsDevCmd.bat",
        "msvc22":"C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\Tools\\VsDevCmd.bat",
        "VCToolsInstallDir": "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\VC\\Tools\\MSVC\\14.35.32215\\",
        "cc20":"cl /std:c++20 /EHsc /MTd",
        "ccla":"cl /std:c++latest /W4 /EHsc /MTd",
    },
    "shell_cmd": "cmd /c \"\"%msvc19%\" && \"%msvc22%\"\"",
    "file_regex": "^(...*?)\\(([0-9]*)\\):([0-9]*)",
    "working_dir": "${file_path}",
    "selector": "source.c++, source.c, source.ixx",
    "encoding":"GBK",
    "quiet": true,
    "variants":[
        { "name":"Visual Studio 2019", "shell_cmd": "cmd /c \"\"%msvc19%\" && cl /help\"" },
        { "name":"Visual Studio 2022", "shell_cmd": "cmd /c \"\"%msvc22%\" && cl /help\"" },
        {
            "name":"MSVC v16.x (/std:c++20) ACTIVE FILE",
            "shell_cmd": "cmd /c \"\"%msvc19%\" && mkdir build || cd build && %cc20% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} "
        },
        {
            "name":"MSVC v16.x (/std:c++latest) ACTIVE FILE",
            "shell_cmd": "cmd /c \"\"%msvc19%\" && mkdir build || cd build && %ccla% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} "
        },
        {
            "name":"MSVC v16.x (/std:c++20)",
            "shell_cmd": "cmd /c \"\"%msvc19%\" && mkdir build || cd build && %cc20% ..\\*.cpp ..\\*.ixx /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} "
        },
        {
            "name":"MSVC v17.x (/std:c++20) ACTIVE FILE",
            "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build || cd build && %cc20% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} "
        },
        {
            "name":"MSVC v17.x (/std:c++latest) ACTIVE FILE",
            "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build || cd build && %ccla% ${file} /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} "
        },
        {
            "name":"MSVC v17.x (/std:c++latest)",
            "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build || cd build && %ccla% ..\\*.cpp ..\\*.ixx /link /OUT:${file_base_name}.exe\" && cd build && ${file_base_name} "
        },
        {
            "name":"MSVC v17.x (build named module: std & std.compat)",
            "shell_cmd": "cmd /c \"\"%msvc22%\" && mkdir build || cd build && %ccla% /c \"%VCToolsInstallDir%\\modules\\std.ixx\" \"%VCToolsInstallDir%\\modules\\std.compat.ixx\"\" && echo Done"
        },
    ]
}
```

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


