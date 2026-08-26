function(enable_sanitizers target)
  
  if(NOT USE_SANITIZER)
    return()
  endif()

  message(
    STATUS
    "ASan + UBSan enable"
  )

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

endfunction()

