# 루트 CMakeList.txt

cmake_minimum_required(VERSION 3.23)

project(
  CPP-LAB
  VERSION 1.0.0
  LANGUAGES CXX
)

# 지원되는 경우 MSVC 컴파일러에 대해 Hot Reload 사용하도록 설정
if(MSVC)
  if(POLICY CMP0141)
    cmake_policy(SET CMP0141 NEW)
    # CXX_COMPILER_ID 단독 검사로 수정
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT 
      "$<IF:$<CXX_COMPILER_ID:MSVC>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>"
    )
  endif()
endif()


# C++ Standard
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)


# Options
option(
  USE_SANITIZER
  "Enable AddressSanitizer and UndefinedBehaviorSanitizer"
  OFF
)
option(
  BUILD_EXAMPLES
  "Build example executables"
  ON
)


# Testing
include(CTest)


# CMake Modules
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(CompilerWarnings)
include(Sanitizers)


# Common Warnings
add_library(project_warnings INTERFACE)
target_compile_options(
  project_warnings
  INTERFACE
    # C++ 컴파일 시에만 플래그 리스트가 바인딩되도록 안전하게 전달
    $<$<COMPILE_LANGUAGE:CXX>:${PROJECT_WARNING_FLAGS}>
)


# Sanitizers
add_library(project_sanitizers INTERFACE)
enable_sanitizers(project_sanitizers)


# GoogleTest
if(BUILD_TESTING)
  include(FetchContent)

  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.17.0.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  )

  set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)

  FetchContent_MakeAvailable(googletest)
endif()


# Core Libraries
add_subdirectory(src)


# Examples
if(BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()


# Tests
if(BUILD_TESTING)
  add_subdirectory(tests)
endif()

