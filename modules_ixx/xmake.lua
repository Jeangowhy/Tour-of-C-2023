add_rules("mode.debug", "mode.release")
set_languages("c++20")

target("modules-ixx")
    set_kind("binary")
    -- add_files("*.cpp", "*.ixx")
    add_files("*.cpp")
    add_linkdirs("$(buildir)/modules-ixx")
    set_targetdir("$(buildir)/modules-ixx")

    if (is_plat("mingw")) then
        add_cxxflags("-fmodules-ts")
        add_ldflags("$(buildir)/modules-ixx/hello.o", {force = true})
        add_ldflags("$(buildir)/modules-ixx/world.o", {force = true})
        -- add_cxxflags("-fmodules-ts", { tools = "gcc" })
        -- add_cxxflags("-o modules-ixx", { tools = "gcc" })
    else
        -- ("Unworking in MinGW GCC")
        set_policy("build.c++.modules", true)
        add_cxxflags("-fprebuilt-module-path=$(buildir)", {force = true})
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
        local args = {"-c", "-xc++", "-std=c++20", "-fmodules-ts", "modules_ixx/*.ixx"}
        local a, b, c = os.execv("g++", args)
        local dest = "build/modules-ixx/"
        os.mkdir(dest)
        os.mv("*.o", dest)
        print("==> before build:", target:name())
    end)

    after_build(function (target, opt)
        print("==>", "xmake run "..target._NAME)
        -- xmake\xmake\core\base\os.lua
        -- os.runv("xmake run ".. target._NAME)
        os.exec("xmake run ".. target:name())
    end)
    -- add_rules("cppfront")

rule("cppfront")
    set_extensions(".cpp") -- associate to .cpp file
    on_load(function (target)
        local rule = target:rule("c++.build"):clone()
        rule:add("deps", "cppfront", {order = true})
        target:rule_add(rule)
        print("==>=== set target [%s] rule of cppfront file.", target._NAME)
    end)
    on_build_file(function (target, sourcefile, opt)
        print("==>=== build cppfront file", target._NAME, sourcefile, opt.progress)
    end)
