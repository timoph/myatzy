cmake_minimum_required(VERSION 3.16)

project(myatzy VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

# Prefer Qt 6, fall back to Qt 5.15
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
if(QT_VERSION_MAJOR EQUAL 6)
    find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick QuickControls2)
else()
    find_package(Qt5 5.15 REQUIRED COMPONENTS Core Gui Quick)
endif()

# Game logic without any UI dependencies, shared by the app and the tests
add_library(myatzy_core STATIC
    engine.cpp
    engine.h
    scoremodel.cpp
    scoremodel.h
    scoring.cpp
    scoring.h
)
target_include_directories(myatzy_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(myatzy_core PUBLIC Qt${QT_VERSION_MAJOR}::Core)

add_executable(myatzy
    main.cpp
    resources.qrc
)
target_link_libraries(myatzy PRIVATE
    myatzy_core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Quick
)
if(QT_VERSION_MAJOR EQUAL 6)
    target_link_libraries(myatzy PRIVATE Qt6::QuickControls2)
endif()

set_target_properties(myatzy PROPERTIES
    WIN32_EXECUTABLE ON
    MACOSX_BUNDLE ON
)

include(GNUInstallDirs)
install(TARGETS myatzy
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
