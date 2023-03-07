function(add_module name)
    message("add_module [${CMAKE_CXX_COMPILER_ID}]: " ${name} "  - " ${ARGN})
    if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        file(MAKE_DIRECTORY ${PREBUILT_MODULE_PATH})
        add_custom_target(
            ${name}
            COMMAND
                ${CMAKE_CXX_COMPILER}
                -std=c++20
                -xc++-module
                -c ${CMAKE_CURRENT_SOURCE_DIR}/${ARGN}
                --precompile
                -o ${PREBUILT_MODULE_PATH}/${name}
            )
        add_custom_target(
            ${name}.o
            COMMAND
                ${CMAKE_CXX_COMPILER}
                -std=c++20
                -c ${PREBUILT_MODULE_PATH}/${name}
                -o ${PREBUILT_MODULE_PATH}/${name}.o
            )
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        add_custom_target(
            ${name}
            COMMAND
                ${CMAKE_CXX_COMPILER}
                -std=c++20
                -fmodules-ts
                -xc++
                -c ${CMAKE_CURRENT_SOURCE_DIR}/${ARGN}
                -o ${CMAKE_CURRENT_BINARY_DIR}/${name}
            )
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        add_custom_target(${name}
            COMMAND
                ${CMAKE_CXX_COMPILER} 
                /experimental:module
                /c
                ${CMAKE_CURRENT_SOURCE_DIR}/${ARGN}
            )
    endif()
endfunction()
