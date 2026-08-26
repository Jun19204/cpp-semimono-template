# C++ Semi-Monorepo Template

C++23과 Modern CMake를 기반으로 여러 C++ 학습 프로젝트, 실험 코드, 재사용 가능한 라이브러리 및 테스트를 하나의 Repository에서 관리하기 위한 템플릿입니다.

각 구성 요소는 독립적인 CMake Target으로 관리하며, 공통 Compiler Warning, Sanitizer 및 Test 환경을 공유할 수 있습니다.

---

## Features

* C++23
* Modern CMake
* CMake Presets
* Library / Executable / Test 분리
* 공통 Compiler Warning 설정
* AddressSanitizer + UndefinedBehaviorSanitizer 지원
* Valgrind 검사 환경 지원
* GoogleTest 기반 Unit Test
* `compile_commands.json` 생성 지원
* 확장 가능한 Semi-Monorepo 구조

---

## Why Semi-Monorepo?

이 템플릿은 하나의 거대한 프로그램만을 위한 단일 프로젝트 구조와, 완전히 분리된 여러 Repository 사이의 중간 구조를 목표로 합니다.

하나의 Repository 안에서 다음과 같은 요소들을 함께 관리할 수 있습니다.

* 재사용 가능한 Library
* 독립적인 학습 및 실험 코드
* Example Executable
* Unit Test
* 공통 Build 환경
* 공통 Compiler Warning
* Memory / Undefined Behavior 검사 환경

각 구성 요소는 CMake Target 단위로 관리되므로, 새로운 코드나 프로젝트를 추가하더라도 기존 구조를 크게 변경하지 않고 확장할 수 있습니다.

---

## Project Structure

```text
.
├── cmake/
│   ├── CompilerWarnings.cmake
│   └── Sanitizers.cmake
│
├── examples/
│   ├── CMakeLists.txt
│   └── ...
│
├── include/
│   └── ...
│
├── resource/
│   └── ...
│
├── src/
│   ├── CMakeLists.txt
│   └── ...
│
├── tests/
│   ├── CMakeLists.txt
│   └── ...
│
├── .gitignore
├── CMakeLists.txt
├── CMakePresets.json
└── README.md
```

### `cmake/`

프로젝트 전체에서 사용하는 공통 CMake 모듈을 관리합니다.

현재 다음과 같은 기능을 분리합니다.

* Compiler Warning 설정
* Sanitizer 설정

필요에 따라 새로운 Custom CMake Module을 추가할 수 있습니다.

### `include/`

재사용 가능한 Library의 Public Header를 관리합니다.

일반적으로 다음과 같은 구조를 사용할 수 있습니다.

```text
include/
└── project_name/
    ├── foo.hpp
    └── bar.hpp
```

Library를 외부 Target에서 사용할 수 있도록 Public API를 정의하는 위치입니다.

### `src/`

재사용 가능한 Library 구현을 관리합니다.

각 Library는 독립적인 CMake Target으로 추가할 수 있습니다.

### `examples/`

학습, 실험 및 사용 예제를 위한 Executable을 관리합니다.

특정 언어 기능, 템플릿, Concepts, 자료구조, 시스템 프로그래밍 등의 독립적인 실험 코드를 추가하는 용도로 사용할 수 있습니다.

### `tests/`

GoogleTest 기반 Unit Test를 관리합니다.

Library 또는 특정 기능에 대한 테스트를 별도의 Target으로 구성할 수 있습니다.

### `resource/`

프로그램 실행에 필요한 리소스를 관리합니다.

예를 들면 다음과 같습니다.

* 설정 파일
* 테스트 데이터
* 입력 데이터
* 기타 런타임 리소스

---

## Requirements

다음 환경을 권장합니다.

* CMake 3.23 이상
* C++23을 지원하는 Compiler

  * GCC
  * Clang
  * MSVC
* 지원되는 CMake Generator

  * Ninja
  * Unix Makefiles
  * Visual Studio Generator
* Valgrind — 선택 사항

Linux 환경에서는 GCC 또는 Clang + Ninja 조합을 권장합니다.

---

# Build

이 프로젝트는 CMake Presets를 사용하여 Build 환경을 관리합니다.

사용 가능한 Preset은 `CMakePresets.json`에서 확인할 수 있습니다.

## ASan + UBSan

AddressSanitizer와 UndefinedBehaviorSanitizer를 활성화하여 Memory Error와 Undefined Behavior를 검사할 수 있습니다.

### Configure

```bash
cmake --preset asan
```

### Build

```bash
cmake --build --preset asan
```

### Run Tests

```bash
ctest --preset asan
```

Sanitizer를 활성화한 상태에서는 다음과 같은 문제를 발견하는 데 도움이 됩니다.

* Use After Free
* Heap Buffer Overflow
* Stack Buffer Overflow
* Double Free
* 일부 Undefined Behavior

---

## Valgrind Environment

`valgrind` preset은 Sanitizer를 비활성화한 Build 환경을 제공합니다.

### Configure

```bash
cmake --preset valgrind
```

### Build

```bash
cmake --build --preset valgrind
```

이 Preset 자체가 Valgrind를 실행하는 것은 아닙니다.

빌드 후 생성된 Executable을 직접 Valgrind로 검사할 수 있습니다.

예를 들어:

```bash
valgrind \
    --leak-check=full \
    --show-leak-kinds=all \
    ./your_executable
```

---

# Testing

테스트는 GoogleTest를 사용합니다.

CTest를 통해 등록된 테스트를 실행할 수 있습니다.

```bash
ctest --preset asan
```

또는 Build Directory에서 직접 실행할 수도 있습니다.

```bash
ctest --output-on-failure
```

실패한 테스트의 출력을 확인하려면:

```bash
ctest --output-on-failure
```

---

# Common Target Configuration

프로젝트 전체에서 사용하는 공통 Compiler Warning과 Sanitizer 설정은 INTERFACE Target을 통해 공유합니다.

## `project_warnings`

공통 Compiler Warning을 적용합니다.

새로운 Target에 다음과 같이 연결할 수 있습니다.

```cmake
target_link_libraries(
    my_target
    PRIVATE
        project_warnings
)
```

이렇게 하면 프로젝트에서 정의한 공통 Warning 정책을 여러 Target에 일관되게 적용할 수 있습니다.

---

## `project_sanitizers`

Sanitizer 설정을 공유합니다.

```cmake
target_link_libraries(
    my_target
    PRIVATE
        project_sanitizers
)
```

`USE_SANITIZER` 옵션이 활성화된 경우 Sanitizer가 적용됩니다.

일반적으로 새로운 Executable 또는 Library는 다음과 같이 구성할 수 있습니다.

```cmake
target_link_libraries(
    my_target
    PRIVATE
        project_warnings
        project_sanitizers
)
```

---

# Adding a Library

새로운 재사용 가능한 Library를 `src/`에 추가합니다.

예를 들어:

```cmake
add_library(
    my_library
    STATIC
    my_library.cpp
)
```

Public Header를 사용할 경우:

```cmake
target_include_directories(
    my_library
    PUBLIC
        "${PROJECT_SOURCE_DIR}/include"
)
```

공통 Warning과 Sanitizer 설정을 적용합니다.

```cmake
target_link_libraries(
    my_library
    PRIVATE
        project_warnings
        project_sanitizers
)
```

예시 전체:

```cmake
add_library(
    my_library
    STATIC
    my_library.cpp
)

target_include_directories(
    my_library
    PUBLIC
        "${PROJECT_SOURCE_DIR}/include"
)

target_link_libraries(
    my_library
    PRIVATE
        project_warnings
        project_sanitizers
)
```

---

# Adding an Example

새로운 학습 또는 실험용 Executable을 `examples/`에 추가합니다.

```cmake
add_executable(
    example_app
    example_main.cpp
)
```

필요한 Library와 공통 설정을 연결합니다.

```cmake
target_link_libraries(
    example_app
    PRIVATE
        my_library
        project_warnings
        project_sanitizers
)
```

예를 들어 독립적인 언어 기능 실험이라면:

```text
examples/
├── templates/
│   ├── concepts_example.cpp
│   └── forwarding_example.cpp
│
├── memory/
│   ├── lifetime_example.cpp
│   └── allocator_example.cpp
│
└── system/
    └── process_example.cpp
```

와 같이 관심 분야별로 확장할 수 있습니다.

---

# Adding Tests

새로운 테스트를 `tests/`에 추가합니다.

예를 들어 `my_library`에 대한 테스트:

```cmake
add_executable(
    my_library_test
    my_library_test.cpp
)
```

GoogleTest와 테스트 대상 Library를 연결합니다.

```cmake
target_link_libraries(
    my_library_test
    PRIVATE
        my_library
        GTest::gtest_main
        project_warnings
        project_sanitizers
)
```

CTest에서 자동으로 테스트를 발견하도록 등록합니다.

```cmake
gtest_discover_tests(my_library_test)
```

전체 예시:

```cmake
add_executable(
    my_library_test
    my_library_test.cpp
)

target_link_libraries(
    my_library_test
    PRIVATE
        my_library
        GTest::gtest_main
        project_warnings
        project_sanitizers
)

gtest_discover_tests(my_library_test)
```

---

# Typical Workflow

새로운 기능 또는 학습 주제를 추가할 때 다음과 같은 흐름을 사용할 수 있습니다.

```text
1. include/
        Public API 정의

2. src/
        Library 구현

3. examples/
        사용 예제 또는 실험 코드 작성

4. tests/
        Unit Test 작성

5. CMake Target 추가

6. ASan + UBSan Build

7. Test 실행

8. 필요하면 Valgrind 검사
```

예를 들어 새로운 자료구조를 구현한다면:

```text
include/
└── my_project/
    └── vector.hpp

src/
└── vector.cpp

examples/
└── vector_example.cpp

tests/
└── vector_test.cpp
```

와 같이 구성할 수 있습니다.

---

# Recommended Development Workflow

개발 중에는 다음과 같은 순서를 권장합니다.

## 1. 새로운 Target 추가

필요한 Library 또는 Executable을 추가합니다.

## 2. Compiler Warning 확인

`project_warnings`를 통해 Warning을 확인하고 가능한 한 수정합니다.

## 3. Unit Test 작성

`tests/`에 동작을 검증하는 테스트를 추가합니다.

## 4. ASan + UBSan 검사

```bash
cmake --preset asan
cmake --build --preset asan
ctest --preset asan
```

## 5. 필요하면 Valgrind 검사

```bash
cmake --preset valgrind
cmake --build --preset valgrind
```

빌드된 Executable을 Valgrind로 실행합니다.

```bash
valgrind \
    --leak-check=full \
    --show-leak-kinds=all \
    ./your_executable
```

---

# Before Starting a New Project

이 Template Repository를 기반으로 새로운 프로젝트를 시작하기 전에 다음 항목을 확인하세요.

* [ ] 최상위 `project()` 이름 변경
* [ ] 프로젝트 `VERSION` 수정
* [ ] 필요한 C++ Standard 확인
* [ ] `README.md` 수정
* [ ] 불필요한 Example 제거 또는 교체
* [ ] 필요한 Library Target 추가
* [ ] 필요한 Executable Target 추가
* [ ] 필요한 Test Target 추가
* [ ] Public Header 구조 구성
* [ ] 필요한 Resource 추가
* [ ] CMake Preset 확인

---

# Notes

이 템플릿은 하나의 특정 프로그램을 위한 완성된 프로젝트 구조라기보다, 여러 C++ 코드와 프로젝트를 지속적으로 추가하고 관리하기 위한 기반 구조를 목표로 합니다.

필요에 따라 다음과 같은 주제를 하나의 Repository 안에서 독립적인 Target으로 관리할 수 있습니다.

* Modern C++
* Templates
* Concepts
* Generic Programming
* Memory Management
* RAII
* Smart Pointers
* Data Structures
* Algorithms
* Concurrency
* System Programming
* Graphics Programming
* Template Libraries
* 기타 독립적인 C++ 프로젝트

프로젝트가 커지더라도 Library, Example, Test를 Target 단위로 분리하여 관리하는 것을 권장합니다.

