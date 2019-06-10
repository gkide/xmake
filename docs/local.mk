##############
# Xmake Init #
##############
# If set to any value but 'CmakeGitClone', then must set 'XmakeVersion', thus
# will init the xmake through wget/curl to download the required xmake tarball
# XmakeInitBy=X
#
# This can be used to required a xmake tarball to download, the version
# value of it must be xmake git repo's tag name, it can be found from
# https://github.com/gkide/xmake/tags
# XmakeVersion=v1.1.0
#
# This is should be the download xmake tarball SHA256, it is optional
# XmakeTarballSHA256=cedefafd2b328d6613effc715ca4ce2ed98ed626bbba055c85fa605596327735
#
# NOTE: The default is to use cmake do git clone the xmake repo

######################
# Project Build Type #
######################
# BUILD_TYPE := Dev
# BUILD_TYPE := Debug
# BUILD_TYPE := Coverage
# BUILD_TYPE := Release
# BUILD_TYPE := MinSizeRel
# BUILD_TYPE := RelWithDebInfo
#
# NOTE: The default value is Debug

##########################
# The Project Build Tool #
##########################
# BUILD_CMD := ninja
# GENERATOR := 'Ninja'
#
# BUILD_CMD := $(MAKE)
# GENERATOR := 'Unix Makefiles'
#
# NOTE: The default is MAKE & Unix Makefiles

#########################################
# The Project Build & Install Directory #
#########################################
# BUILD_DIR := $(SOURCE_DIR)/build
# INSTALL_PREFIX := $(BUILD_DIR)/usr
#
# NOTE: The default build directory is 'build' of project root, and
# the install directory if not set, it will depends on the build type

################################################################
# The Project Extrnal Dependents Download/Build/Install Config #
################################################################
# This is the extral project default build type, it can be used in the
# cmake files, the default value for it is Release
# DEPS_BUILD_TYPE := Release
#
# This is the extral project working root directory, for download,
# build, install, the default value is .deps of project root directory
# DEPS_ROOT_DIR := $(SOURCE_DIR)/.deps

###########################################
# More Configurable Variable for xmake.mk #
###########################################
# MAKE_PROG
# GIT_PROG, GIT_ARGS
# CMAKE_PROG, CMAKE_ARGS
# STRIP_PROG, STRIP_ARGS
# EUSTRIP_PROG, EUSTRIP_ARGS
# DOXYGEN_PROG, DOXYGEN_ARGS
# CPPCHECK_PROG, CPPCHECK_ARGS
# => CPPCHECK17_PROG, CPPCHECK18_PROG
# VALGRIND_PROG, VALGRIND_ARGS
# ASTYLE_PROG, ASTYLE_ARGS, ASTYLE_FILES, ASTYLE_VERSION
# WGET_PROG, CURL_PROG, DOWNLOAD_AS

####################################
# The Project Common Configuration #
####################################
# EXTRA_CMAKE_ARGS += -D<ProjectName>_ENABLE_CI=ON
# EXTRA_CMAKE_ARGS += -D<ProjectName>_ENABLE_GCOV=OFF
# EXTRA_CMAKE_ARGS += -D<ProjectName>_DISABLE_CCACHE=ON
# EXTRA_CMAKE_ARGS += -D<ProjectName>_ENABLE_ASSERTION=OFF

#################################
# The Qt5 Project Configuration #
#################################
# EXTRA_CMAKE_ARGS += -D<ProjectName>_QT5_AUTOMATIC=ON
# EXTRA_CMAKE_ARGS += -D<ProjectName>_QT5_STATIC_PREFIX=/opt/qt-5.9.1
# EXTRA_CMAKE_ARGS += -D<ProjectName>_QT5_SHARED_PREFIX=/opt/Qt5.5.1/5.5/gcc_64
# EXTRA_CMAKE_ARGS += -D<ProjectName>_QT5_SHARED_PREFIX=/usr/lib/gcc/x86_64-linux-gnu

# Add More Project Releated Configuration for Cmake
# EXTRA_CMAKE_ARGS += ...
