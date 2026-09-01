# CompilerWarnings.cmake

if(MSVC)
  set(
    PROJECT_WARNING_FLAGS
    /W4          # 기본 높은 수준 경고 (-Wall, -Wextra 대응)
    /permissive- # C++ 표준 준수 모드 강제

    # 외부 헤더 경고 억제 (SYSTEM 키워드 지정 디렉터리 대상)
    /external:W0
    /external:templates-

    # 쉐도잉 (-Wshadow 대응)
    /w14456 # 로컬 변수 쉐도잉
    /w14457 # 함수 매개변수 쉐도잉
    /w14458 # 클래스 멤버 쉐도잉
    /w14459 # 전역 변수 쉐도잉

    # 암시적 형변환 (-Wconversion 대응)
    /w14242 # 데이터 손실 가능 변환
    /w14244 # 정수/부동소수점 데이터 손실 변환

    # 캐스팅
    /w14305 # Truncation (double -> float 등 축소 변환)
    /w14311 # Pointer truncation
    /w14312 # Conversion to pointer of greater size
  )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang|AppleClang")
  set(
    PROJECT_WARNING_FLAGS
    # 공통 기본 경고 및 표준 준수
    -Wall
    -Wextra
    -Wpedantic

    # 쉐도잉 및 형변환
    -Wshadow
    -Wconversion
    -Wsign-conversion

    # 캐스팅 및 정렬
    -Wcast-qual        # const 한정자 제거 경고
    -Wcast-align       # 잠재적 미정렬 경고

    # 정적 분석 및 설계
    -Wformat=2         # C 스타일 format string 검사
    -Wnull-dereference # nullptr 역참조 검사
    -Wdouble-promotion # float -> double 암시적 승격 경고
    -Wnon-virtual-dtor # 가상 파괴자 누락 경고
  )

  # GCC 전용 경고 플래그
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    list(APPEND PROJECT_WARNING_FLAGS
      -Wlogical-op      # 논리 연산자 오용 경고
      -Wduplicated-cond # 중복 조건문 경고
    )
  # Clang / AppleClang 전용 경고 플래그
  elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang|AppleClang")
    list(APPEND PROJECT_WARNING_FLAGS
      -Wold-style-cast       # C 스타일 캐스트 금지 (C++ 캐스트 강제)
      -Woverloaded-virtual   # 오버라이딩 시 시그니처 불일치 감지
      -Wshadow-field         # 멤버 변수 쉐도잉 명확히 감지
      -Wabstract-final-class # final 클래스 관련 가상 함수 오용 감지
    )
  endif()
endif()

