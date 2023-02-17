cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "nim_core_windows")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "${PROJECT_NAME}_plugin")

if(MSVC)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP /Zc:threadSafeInit-")
  SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Gm- /Zi")
  SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
endif()
add_compile_options(/bigobj)
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
set(PCH_HEADER_FILE ${CMAKE_CURRENT_LIST_DIR}/src/common/stable.h)

# third_party_libs
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../third_party/alog/include")
link_directories("${CMAKE_CURRENT_SOURCE_DIR}/../third_party/alog/lib/x64/${CMAKE_BUILD_TYPE}")

# nim_sdk
set(NIM_SDK_URL "https://yx-web-nosdn.netease.im/package/nim-win32-x64-refs-tags-9.6.0.1676-build.312.tar.gz?download=nim-win32-x64-refs-tags-9.6.0.1676-build.312.tar.gz")
set(SPLIT "download=")
string(LENGTH ${SPLIT} SPLIT_LENGTH)
string(LENGTH ${NIM_SDK_URL} NIM_SDK_URL_LENGTH)
string(FIND ${NIM_SDK_URL} ${SPLIT} POS)
math(EXPR SPLIT_POS "${POS}+${SPLIT_LENGTH}")
string(SUBSTRING ${NIM_SDK_URL} ${SPLIT_POS} ${NIM_SDK_URL_LENGTH} NIM_SDK)
string(COMPARE EQUAL "${NIM_SDK}" "" RET)
if(RET)
  set(NIM_SDK "nim_sdk.zip")
endif()
set(NIM_SDK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk")
set(NIM_SDK "${NIM_SDK_DIR}/${NIM_SDK}")
if(EXISTS "${NIM_SDK}")
    file(SIZE "${NIM_SDK}" IM_SIZE)
    if(NOT ${IM_SIZE})
      file(REMOVE_RECURSE "${NIM_SDK}")
    endif()
endif()
if(NOT EXISTS "${NIM_SDK}")
  file(MAKE_DIRECTORY ${NIM_SDK_DIR})
  message("[downloadSDK]: start download sdk from ${NIM_SDK_URL}")
  file(DOWNLOAD ${NIM_SDK_URL} ${NIM_SDK})
  message("[downloadSDK]: download the end.")
  message("[downloadSDK]: start decompressing ${NIM_SDK}")
  file(ARCHIVE_EXTRACT INPUT ${NIM_SDK} DESTINATION ${NIM_SDK_DIR})
  message("[downloadSDK]: decompression end(successfull).")
else()
  message("[downloadSDK]: sdk existing.")
endif()
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/include")
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/wrapper")
link_directories("${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/lib")
set(INSTALL_CPP_WRAPPER OFF)
set(BUILD_SHARED_LIBS ON)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/wrapper" "${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/wrapper/output")
add_definitions(-DUNICODE -D_UNICODE -DNOMINMAX -DCPPWRAPPER_DLL)
install(TARGETS nim_wrapper_util nim_cpp_wrapper nim_chatroom_cpp_wrapper nim_tools_cpp_wrapper
            CONFIGURATIONS ${CMAKE_BUILD_TYPE}
            ARCHIVE DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/lib
            RUNTIME DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/bin
        )

FILE(GLOB SELF_TEMP_SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/*.cpp src/*.h)
source_group(src FILES ${SELF_TEMP_SRC_FILES})
list(APPEND NIM_CORE_SOURCES ${SELF_TEMP_SRC_FILES})

FILE(GLOB SELF_TEMP_SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/common/*.cpp src/common/*.h)
source_group(src/common FILES ${SELF_TEMP_SRC_FILES})
list(APPEND NIM_CORE_SOURCES ${SELF_TEMP_SRC_FILES})

FILE(GLOB SELF_TEMP_SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/common/services/*.cpp src/common/services/*.h)
source_group(src/common/services FILES ${SELF_TEMP_SRC_FILES})
list(APPEND NIM_CORE_SOURCES ${SELF_TEMP_SRC_FILES})

FILE(GLOB SELF_TEMP_SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/common/utils/*.cpp src/common/utils/*.h src/common/utils/*.hpp)
source_group(src/common/utils FILES ${SELF_TEMP_SRC_FILES})
list(APPEND NIM_CORE_SOURCES ${SELF_TEMP_SRC_FILES})

FILE(GLOB SELF_TEMP_SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/utils/*.cpp src/utils/*.h)
source_group(src/utils FILES ${SELF_TEMP_SRC_FILES})
list(APPEND NIM_CORE_SOURCES ${SELF_TEMP_SRC_FILES})

FILE(GLOB SELF_TEMP_SRC_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} src/utils/dump/*.cpp src/utils/dump/*.h)
source_group(src/utils/dump FILES ${SELF_TEMP_SRC_FILES})
list(APPEND NIM_CORE_SOURCES ${SELF_TEMP_SRC_FILES})

list(APPEND PLUGIN_SOURCES
  "nim_core_plugin.cpp"
  "nim_core_plugin.h"
)

add_library(${PLUGIN_NAME} SHARED
  "include/nim_core_windows/nim_core_windows.h"
  "nim_core_windows.cpp"
  ${PLUGIN_SOURCES}
  ${NIM_CORE_SOURCES}
)
target_precompile_headers(${PLUGIN_NAME} PRIVATE ${PCH_HEADER_FILE})

target_link_libraries(${PLUGIN_NAME} PRIVATE yx_alog nim_wrapper_util nim_cpp_wrapper nim_chatroom_cpp_wrapper nim_tools_cpp_wrapper)
apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
target_compile_options(${PLUGIN_NAME} PRIVATE /wd"4251" /wd"4091" /bigobj)
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)
if(${CMAKE_BUILD_TYPE} MATCHES Debug)
  set_target_properties(${PLUGIN_NAME} PROPERTIES LINK_FLAGS "/INCREMENTAL:YES")
endif()
# List of absolute paths to libraries that should be bundled with the plugin
set(nim_core_windows_bundled_libraries
    "${CMAKE_CURRENT_SOURCE_DIR}/../nim_sdk/bin/"
  PARENT_SCOPE
)

# === Tests ===

if(${include_${PROJECT_NAME}_tests})
set(TEST_RUNNER "${PROJECT_NAME}_test")
enable_testing()
# TODO(stuartmorgan): Consider using a single shared, pre-checked-in googletest
# instance rather than downloading for each plugin. This approach makes sense
# for a template, but not for a monorepo with many plugins.
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/release-1.11.0.zip
)
# Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# Disable install commands for gtest so it doesn't end up in the bundle.
set(INSTALL_GTEST OFF CACHE BOOL "Disable installation of googletest" FORCE)

FetchContent_MakeAvailable(googletest)

# The plugin's C API is not very useful for unit testing, so build the sources
# directly into the test binary rather than using the DLL.
add_executable(${TEST_RUNNER}
  test/nim_core_windows_test.cpp
  ${PLUGIN_SOURCES}
  ${NIM_CORE_SOURCES}
)
apply_standard_settings(${TEST_RUNNER})
target_include_directories(${TEST_RUNNER} PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_link_libraries(${TEST_RUNNER} PRIVATE flutter_wrapper_plugin)
target_link_libraries(${TEST_RUNNER} PRIVATE gtest_main gmock)
# flutter_wrapper_plugin has link dependencies on the Flutter DLL.
add_custom_command(TARGET ${TEST_RUNNER} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  "${FLUTTER_LIBRARY}" $<TARGET_FILE_DIR:${TEST_RUNNER}>
)

include(GoogleTest)
gtest_discover_tests(${TEST_RUNNER})
endif()
