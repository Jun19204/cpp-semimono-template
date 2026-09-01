function(enable_sanitizers target)
    if(NOT USE_SANITIZER)
        return()
    endif()

    if(MSVC)
        message(STATUS "Enable MSVC AddressSanitizer (ASan)")
        
        # MSVC는 /fsanitize=address 플래그 사용 (UBSan 미지원)
        # Interface 대신 PRIVATE 또는 PUBLIC 권장
        target_compile_options(${target} INTERFACE /fsanitize=address)
        
        # MSVC ASan 사용 시 증기 연산 라이브러리 지원 플래그
        target_compile_options(${target} INTERFACE /EHsc)
        
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        message(STATUS "Enable GCC/Clang ASan + UBSan")
        
        target_compile_options(
            ${target}
            INTERFACE
            -fsanitize=address,undefined
            -fno-omit-frame-pointer
        )
        target_link_options(
            ${target}
            INTERFACE
            -fsanitize=address,undefined
        )
    endif()
endfunction()

