# The following will define
#
# - FOUND_GIT_REPO          Find git repo
# - ${XMAKE}_RECENT_TAG     The most recent tag
# - ${XMAKE}_BRANCH_NAME    The current branch name
# - ${XMAKE}_COMMIT_HASH    The current commit short SHA1
# - ${XMAKE}_MODIFY_STAMP   The current commit timestamp

# Check if git repo exist
set(FOUND_GIT_REPO false)
file(TO_CMAKE_PATH ${CMAKE_SOURCE_DIR}/.git GIT_REPO_DIR)

if(NOT EXISTS "${GIT_REPO_DIR}" OR NOT IS_DIRECTORY "${GIT_REPO_DIR}")
    return() # repo NOT exist just ignore
endif()

# Get git repo info
set(FOUND_GIT_REPO true)
include(CheckGitRepoInfo)
GegGitRecentTag(${XMAKE}_RECENT_TAG)
GetGitCommitTime(${XMAKE}_MODIFY_STAMP)
GetGitBranchInfo(${XMAKE}_BRANCH_NAME ${XMAKE}_COMMIT_SHA1)

if(${XMAKE}_BRANCH_NAME AND ${XMAKE}_COMMIT_SHA1 AND ${XMAKE}_MODIFY_STAMP)
    set(REPO_INFO_FILE ${CMAKE_BINARY_DIR}/RepoInfo)
    file(WRITE ${REPO_INFO_FILE}
        "${${XMAKE}_BRANCH_NAME} ${${XMAKE}_COMMIT_SHA1} ${${XMAKE}_MODIFY_STAMP}")

    string(REPLACE "\"" "" ${XMAKE}_MODIFY_STAMP "${${XMAKE}_MODIFY_STAMP}")
    string(REPLACE "\\" "" ${XMAKE}_MODIFY_STAMP "${${XMAKE}_MODIFY_STAMP}")
    string(SUBSTRING "${${XMAKE}_MODIFY_STAMP}" 00 10 ${XMAKE}_COMMIT_DATE)
    string(SUBSTRING "${${XMAKE}_MODIFY_STAMP}" 11 08 ${XMAKE}_COMMIT_TIME)
    string(SUBSTRING "${${XMAKE}_MODIFY_STAMP}" 20 05 ${XMAKE}_COMMIT_ZONE)
    string(REPLACE "-" "" MODIFY_DATE_NUMS ${${XMAKE}_COMMIT_DATE})
    string(REPLACE ":" "" MODIFY_TIME_NUMS ${${XMAKE}_COMMIT_TIME})
    string(REPLACE ":" "" MODIFY_ZONE_NUMS ${${XMAKE}_COMMIT_ZONE})

    string(SUBSTRING "${${XMAKE}_COMMIT_SHA1}"  0 7 ${XMAKE}_COMMIT_HASH)

    string(APPEND ${XMAKE}_RELEASE_VERSION "~${MODIFY_DATE_NUMS}")
    string(APPEND ${XMAKE}_RELEASE_VERSION "@${${XMAKE}_COMMIT_HASH}")
endif()

if(false)
    message(STATUS "${PROJECT_NAME} Repo Hash: ${${XMAKE}_COMMIT_HASH}")
    message(STATUS "${PROJECT_NAME} Repo Branch: ${${XMAKE}_BRANCH_NAME}")
    message(STATUS "${PROJECT_NAME} Repo Describe: ${${XMAKE}_RECENT_TAG}")
    message(STATUS "${PROJECT_NAME} Repo Commit Time: ${${XMAKE}_MODIFY_STAMP}")
endif()

if(XMAKE_VERBOSE_MESSAGE)
    message(STATUS "${PROJECT_NAME} Build Type: ${CMAKE_BUILD_TYPE}")
    message(STATUS "${PROJECT_NAME} Release Version: ${${XMAKE}_RELEASE_VERSION}")
    message(STATUS "${PROJECT_NAME} Install Perfix: ${CMAKE_INSTALL_PREFIX}")
endif()

mark_as_advanced(FORCE FOUND_GIT_REPO GIT_REPO_DIR)
