-- add_rules("mode.debug", "mode.release")

target("sub-world")
    set_kind("shared")
    -- set_kind("binary")
    -- add_cxflags("-xc++")
    -- add_files("src/*.c")
    add_files("src/*.cpp")
    set_targetdir("$(buildir)")

    -- xmake\core\src\demo\xmake.lua:51
    -- copy target to the build directory
    -- after_build(function (target, opt)
    --     if not os.isfile(target:targetfile()) then
    --         print("=== Not a file ", target:targetfile())
    --         return
    --     end
    --     local extension = is_plat("windows", "llvm","mingw") and ".exe" or ""
    --     print("==> after build", target._NAME, target:targetfile(), extension)
    --     os.cp(target:targetfile(), "$(buildir)/"..target:targetfile().. extension)
    -- end)

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
            return
        end
        print("==> before_build", target._NAME, "$(platform)")
        os.run("clang++ -o build\\sub-world.dll $(scriptdir)\\src\\main.cpp -shared -m64 -g ")
        -- os.run("touch here")
    end)
