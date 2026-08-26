cmake_minimum_required(VERSION 3.23)

project(
  ProjectName
  VERSION 0.1.0
  LANGUAGES CXX
)

# ============================================================
# C++ Standard
# ============================================================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# ============================================================
# Options
# ============================================================
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

# ============================================================
# Testing
# ============================================================
include(CTest)

# ============================================================
# CMake Modules
# ============================================================
list(APPEND CMAKE_MODULE_PATH
  "${PROJECT_SOURCE_DIR}/cmake"
)
include(CompilerWarnings)
include(Sanitizers)

# ============================================================
# Common Warnings
# ============================================================
add_library(
  project_warnings
  INTERFACE
)
target_compile_options(
  project_warnings
  INTERFACE
  ${PROJECT_WARNING_FLAGS}
)

# ============================================================
# Sanitizers
# ============================================================
add_library(
  project_sanitizers
  INTERFACE
)
enable_sanitizers(
  project_sanitizers
)

# ============================================================
# GoogleTest
# ============================================================
if(BUILD_TESTING)
  include(FetchContent)

  FetchContent_Declare(
    googletest
    URL
      https://github.com/google/googletest/archive/refs/tags/v1.17.0.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  )

  set(
    INSTALL_GTEST
    OFF
    CACHE BOOL ""
    FORCE
  )

  FetchContent_MakeAvailable(
    googletest
  )
endif()

# ============================================================
# Core Libraries
# ============================================================
add_subdirectory(src)

# ============================================================
# Examples
# ============================================================
if(BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

# ============================================================
# Tests
# ============================================================
if(BUILD_TESTING)
  add_subdirectory(tests)
endif()

