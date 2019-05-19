# AppImage Configuration

# The App Entry Point
set(PKG_APP_EXEC xtest)

# If set, then just copy it to the root of AppDir
# if not, create it from a template shell script
#set(PKG_APPIMAGE_APPRUN  "")

# If set, then just copy it to the root of AppDir
# if not, create it from a template desktop file
#set(PKG_APPIMAGE_DESKTOP  "")

# Must set at less one of them
set(PKG_APPIMAGE_ICON16  "${CMAKE_SOURCE_DIR}/docs/res/xmake-16x16.png")
set(PKG_APPIMAGE_ICON32  "${CMAKE_SOURCE_DIR}/docs/res/xmake-32x32.png")
set(PKG_APPIMAGE_ICON64  "${CMAKE_SOURCE_DIR}/docs/res/xmake-64x64.png")
set(PKG_APPIMAGE_ICON128 "${CMAKE_SOURCE_DIR}/docs/res/xmake-128x128.png")
set(PKG_APPIMAGE_ICON256 "${CMAKE_SOURCE_DIR}/docs/res/xmake-256x256.png")
