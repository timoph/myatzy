find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Test)

add_executable(tst_scoring tst_scoring.cpp)
target_link_libraries(tst_scoring PRIVATE
    myatzy_core
    Qt${QT_VERSION_MAJOR}::Test
)

add_test(NAME tst_scoring COMMAND tst_scoring)
