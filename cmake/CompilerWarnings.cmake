set(
  PROJECT_WARNING_FLAGS

  # 기본 경고
  -Wall 
  -Wextra
  -Wpedantic

  # 쉐도잉 경고
  -Wshadow

  # 암시적 형변환 경고
  -Wconversion
  -Wsign-conversion

  -Wcast-qual # const 한정자를 제거하는 위험 캐스트 경고
  -Wcast-align # 잠재적 미정렬 경고

  -Wformat=2 # C 스타일 format string 관련 검사 강화
  -Wnull-dereference # nullptr 역참조 대입 여부 정적 분석

  -Wdouble-promotion # double 승격 경고
)

