# The following will define
#
# - FOUND_GIT_REPO          Find git repo
# - ${XBUILD}_RECENT_TAG     The most recent tag
# - ${XBUILD}_BRANCH_NAME    The current branch name
# - ${XBUILD}_COMMIT_HASH    The current commit short SHA1
# - ${XBUILD}_MODIFY_STAMP   The current commit timestamp

# Check if git repo exist
set(FOUND_GIT_REPO false)
file(TO_CMAKE_PATH ${CMAKE_SOURCE_DIR}/.git GIT_REPO_DIR)

if(NOT EXISTS "${GIT_REPO_DIR}" OR NOT IS_DIRECTORY "${GIT_REPO_DIR}")
    return() # repo NOT exist just ignore
endif()

# Get git repo info
set(FOUND_GIT_REPO true)
include(CheckGitRepoInfo)
GegGitRecentTag(${XBUILD}_RECENT_TAG)
GetGitCommitTime(${XBUILD}_MODIFY_STAMP)
GetGitBranchInfo(${XBUILD}_BRANCH_NAME ${XBUILD}_COMMIT_SHA1)

if(${XBUILD}_BRANCH_NAME AND ${XBUILD}_COMMIT_SHA1 AND ${XBUILD}_MODIFY_STAMP)
    set(REPO_INFO_FILE ${CMAKE_BINARY_DIR}/RepoInfo)
    file(WRITE ${REPO_INFO_FILE}
        "${${XBUILD}_BRANCH_NAME} ${${XBUILD}_COMMIT_SHA1} ${${XBUILD}_MODIFY_STAMP}")

    string(REPLACE "\"" "" ${XBUILD}_MODIFY_STAMP "${${XBUILD}_MODIFY_STAMP}")
    string(REPLACE "\\" "" ${XBUILD}_MODIFY_STAMP "${${XBUILD}_MODIFY_STAMP}")
    string(SUBSTRING "${${XBUILD}_MODIFY_STAMP}" 00 10 ${XBUILD}_COMMIT_DATE)
    string(SUBSTRING "${${XBUILD}_MODIFY_STAMP}" 11 08 ${XBUILD}_COMMIT_TIME)
    string(SUBSTRING "${${XBUILD}_MODIFY_STAMP}" 20 05 ${XBUILD}_COMMIT_ZONE)
    string(REPLACE "-" "" MODIFY_DATE_NUMS ${${XBUILD}_COMMIT_DATE})
    string(REPLACE ":" "" MODIFY_TIME_NUMS ${${XBUILD}_COMMIT_TIME})
    string(REPLACE ":" "" MODIFY_ZONE_NUMS ${${XBUILD}_COMMIT_ZONE})

    string(SUBSTRING "${${XBUILD}_COMMIT_SHA1}"  0 7 ${XBUILD}_COMMIT_HASH)

    string(APPEND ${XBUILD}_RELEASE_VERSION "~${MODIFY_DATE_NUMS}")
    string(APPEND ${XBUILD}_RELEASE_VERSION "@${${XBUILD}_COMMIT_HASH}")
endif()

if(false)
    message(STATUS "${PROJECT_NAME} Repo Hash: ${${XBUILD}_COMMIT_HASH}")
    message(STATUS "${PROJECT_NAME} Repo Branch: ${${XBUILD}_BRANCH_NAME}")
    message(STATUS "${PROJECT_NAME} Repo Describe: ${${XBUILD}_RECENT_TAG}")
    message(STATUS "${PROJECT_NAME} Repo Commit Time: ${${XBUILD}_MODIFY_STAMP}")
endif()

if(XBUILD_VERBOSE_MESSAGE)
    message(STATUS "${PROJECT_NAME} Build Type: ${CMAKE_BUILD_TYPE}")
    message(STATUS "${PROJECT_NAME} Release Version: ${${XBUILD}_RELEASE_VERSION}")
    message(STATUS "${PROJECT_NAME} Install Perfix: ${CMAKE_INSTALL_PREFIX}")
endif()

mark_as_advanced(FORCE FOUND_GIT_REPO GIT_REPO_DIR)
