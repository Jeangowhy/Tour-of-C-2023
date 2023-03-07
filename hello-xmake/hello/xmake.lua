-- add_rules("mode.debug", "mode.release")

target("sub-hello")
    set_kind("static")
    add_files("src/*.c")
    set_targetdir("$(buildir)")
