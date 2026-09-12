# =============================================
# Core Libraries:
# =============================================

# add_library(MyLibrary1 STATIC my_library1.cc)
# add_library(MyLibrary2 STATIC my_library2.cc)

# =============================================
# Header-only Libraries:
# =============================================

# add_library(MyTemplate_lib INTERFACE)
# target_include_directories(
#   MyTemplate_lib
#   INTERFACE
#     "${PROJECT_SOURCE_DIR}/include"
# )
# target_compile_features(
#   MyTemplate_lib
#   INTERFACE
#     cxx_std_23
# )

# =============================================
# Common Static Library Settings
# =============================================

# set(
#   ALL_LIBS
#     MyLibrary1
#     MyLibrary2
# )
#
# foreach(lib IN LISTS ALL_LIBS)
#   target_include_directories(
#     ${lib}
#     PUBLIC
#       "${PROJECT_SOURCE_DIR}/include"
#   )
#   target_compile_features(
#     ${lib}
#     PUBLIC
#       cxx_std_23
#   )
#   target_link_libraries(
#     ${lib}
#     PRIVATE
#       project_warnings
#       project_sanitizers
#   )
# endforeach()

