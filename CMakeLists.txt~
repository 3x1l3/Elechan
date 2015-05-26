# project name
project (codewall)
# the oldest stable cmake version we support
cmake_minimum_required (VERSION 2.6)
# tell cmake where its modules can be found in our project directory
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
# where we install data directory (if we have any)
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
# what to call that directory where we install data too
set (PKGDATADIR "${DATADIR}/codewall")
set (EXEC_NAME "codewall")
set (RELEASE_NAME "CodeWall lightweight IDE")
set (VERSION "0.0.1")
set (VERSION_INFO "Initial Development")
# we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
find_package(PkgConfig)
# now let's actually check for the required dependencies
pkg_check_modules(DEPS REQUIRED gtk+-3.0 granite gtksourceview-3.0)
add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})
# make sure we have vala
find_package(Vala REQUIRED)
# make sure we use vala
include(ValaVersion)
# make sure it's the desired version of vala
ensure_vala_version("0.16" MINIMUM)
# files we want to compile
include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
src/MainWindow.vala
src/Utilities.vala
src/Page.vala
src/PageDecorator.vala
src/Toolbar.vala
src/Settings.vala
src/InfoBar.vala
# tell what libraries to use when compiling
PACKAGES
gtk+-3.0
granite
gtksourceview-3.0
)
# tell cmake what to call the executable we just made
add_executable(${EXEC_NAME} ${VALA_C})
# install the binaries we just made
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
#install our .desktop file so the Applications menu will see it
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/codewall.desktop DESTINATION ${DATADIR}/applications/)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/uncrustify.cfg DESTINATION ${PKGDATADIR})
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/ui.xml DESTINATION ${PKGDATADIR})

FILE (GLOB styles "${CMAKE_CURRENT_SOURCE_DIR}/data/StyleSchemes/*")
install (FILES ${styles} DESTINATION ${PKGDATADIR}/StyleSchemes/)