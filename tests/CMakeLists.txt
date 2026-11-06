find_package(Qt6 REQUIRED COMPONENTS Gui Test)

add_executable(tst_scoring tst_scoring.cpp)
target_link_libraries(tst_scoring PRIVATE
    myatzy_core
    # QAbstractItemModelTester inspects GUI types such as QPixmap
    Qt6::Gui
    Qt6::Test
)

add_test(NAME tst_scoring COMMAND tst_scoring)
