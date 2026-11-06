cmake_minimum_required(VERSION 3.21)

project(myatzy VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick)
find_package(Qt6 6.5 QUIET OPTIONAL_COMPONENTS LinguistTools)
qt_standard_project_setup(REQUIRES 6.5)

# Lets qmllint and other tooling find the module in the build directory
set(QT_QML_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/qml)

# The game logic and the UI as the QML module "Myatzy". The static backing
# library is shared by the app and the tests.
qt_add_library(myatzy_core STATIC)

set(QML_FILES
    qml/Main.qml
    qml/GameView.qml
    qml/GameMenu.qml
    qml/GameOverDialog.qml
    qml/HighScoreList.qml
    qml/PaperDialog.qml
    qml/MenuButton.qml
    qml/MenuIconButton.qml
    qml/RollButton.qml
    qml/ScoreCard.qml
    qml/ScoreButton.qml
    qml/DiceRect.qml
    qml/Celebration.qml
    qml/Dice.qml
    qml/Dot.qml
    qml/Style.qml
)
set_source_files_properties(qml/Style.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
# Serve the files from the module root so they see the module's own types
foreach(file IN LISTS QML_FILES)
    get_filename_component(name ${file} NAME)
    set_source_files_properties(${file} PROPERTIES QT_RESOURCE_ALIAS ${name})
endforeach()

qt_add_qml_module(myatzy_core
    URI Myatzy
    VERSION 1.0
    QML_FILES ${QML_FILES}
    SOURCES
        engine.cpp
        engine.h
        scoremodel.cpp
        scoremodel.h
        scoring.cpp
        scoring.h
)
# Translations, compiled into the library under :/i18n.
# Refresh the .ts files from the sources with the update_translations target.
if(Qt6LinguistTools_FOUND)
    qt_add_translations(myatzy_core
        TS_FILES i18n/myatzy_fi.ts
        LUPDATE_OPTIONS -locations relative
    )
else()
    message(WARNING "Qt6 LinguistTools not found, building without translations")
endif()

target_include_directories(myatzy_core PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(myatzy_core PUBLIC Qt6::Core Qt6::Qml Qt6::Quick)

qt_add_executable(myatzy main.cpp)
target_link_libraries(myatzy PRIVATE
    myatzy_coreplugin
    Qt6::Gui
    Qt6::Quick
)

set_target_properties(myatzy PROPERTIES
    WIN32_EXECUTABLE ON
    MACOSX_BUNDLE ON
)

# Linking the static Myatzy plugin makes Qt scan the app's QML imports for
# static plugins to link too. With a shared Qt those are loaded at run time.
get_target_property(qt_core_type Qt6::Core TYPE)
if(qt_core_type STREQUAL "SHARED_LIBRARY")
    set_target_properties(myatzy PROPERTIES QT_QML_MODULE_NO_IMPORT_SCAN TRUE)
endif()

include(GNUInstallDirs)
install(TARGETS myatzy
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

include(CTest)
if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
