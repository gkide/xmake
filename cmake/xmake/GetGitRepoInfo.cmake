# The following will define
#
# - FOUND_GIT_REPO          Find git repo
# - ${XMAKE}_RECENT_TAG     The most recent tag
# - ${XMAKE}_BRANCH_NAME    The current repo working branch
# - ${XMAKE}_COMMIT_HASH    The working repo commit short SHA1
# - ${XMAKE}_COMMIT_MDTZ    The working repo commit timestamp

# Check if git repo exist
set(FOUND_GIT_REPO false)
file(TO_CMAKE_PATH ${CMAKE_SOURCE_DIR}/.git GIT_REPO_DIR)
mark_as_advanced(GIT_REPO_DIR FOUND_GIT_REPO)

if(NOT EXISTS "${GIT_REPO_DIR}" OR NOT IS_DIRECTORY "${GIT_REPO_DIR}")
    if(tweak_hash) # append repo HASH if any
        string(APPEND ${XMAKE}_RELEASE_VERSION "+${tweak_hash}")
    endif()
    return() # repo NOT exist just return
endif()

# Get git repo info
set(FOUND_GIT_REPO true)
include(CheckGitRepoInfo)
GegGitRecentTag(${XMAKE}_RECENT_TAG)
GetGitCommitTime(${XMAKE}_COMMIT_MDTZ)
GetGitBranchInfo(${XMAKE}_BRANCH_NAME ${XMAKE}_COMMIT_SHA1)

if(${XMAKE}_BRANCH_NAME AND ${XMAKE}_COMMIT_SHA1 AND ${XMAKE}_COMMIT_MDTZ)
    set(REPO_INFO_FILE ${CMAKE_SOURCE_DIR}/DistRepoInfo)
    mark_as_advanced(REPO_INFO_FILE)

    file(WRITE ${REPO_INFO_FILE}
        "${${XMAKE}_BRANCH_NAME} ${${XMAKE}_COMMIT_SHA1} ${${XMAKE}_COMMIT_MDTZ}")

    string(REPLACE "\"" "" ${XMAKE}_COMMIT_MDTZ "${${XMAKE}_COMMIT_MDTZ}")
    string(REPLACE "\\" "" ${XMAKE}_COMMIT_MDTZ "${${XMAKE}_COMMIT_MDTZ}")
    string(SUBSTRING "${${XMAKE}_COMMIT_MDTZ}" 00 10 ${XMAKE}_COMMIT_DATE)
    string(SUBSTRING "${${XMAKE}_COMMIT_MDTZ}" 11 08 ${XMAKE}_COMMIT_TIME)
    string(SUBSTRING "${${XMAKE}_COMMIT_MDTZ}" 20 05 ${XMAKE}_COMMIT_ZONE)
    #string(REPLACE "-" "" MODIFY_DATE_NUMS ${${XMAKE}_COMMIT_DATE})
    #string(REPLACE ":" "" MODIFY_TIME_NUMS ${${XMAKE}_COMMIT_TIME})
    #string(REPLACE ":" "" MODIFY_ZONE_NUMS ${${XMAKE}_COMMIT_ZONE})

    string(SUBSTRING "${${XMAKE}_COMMIT_SHA1}"  0 10 ${XMAKE}_COMMIT_HASH)

    string(APPEND ${XMAKE}_RELEASE_VERSION "+${${XMAKE}_COMMIT_HASH}")

    if(pkg_version_tweak)
        set(pkg_version_tweak "${pkg_version_tweak}+${${XMAKE}_COMMIT_HASH}")
    else()
        set(pkg_version_tweak "${${XMAKE}_COMMIT_HASH}")
    endif()

    mark_as_advanced(pkg_version_tweak)
    set(${XMAKE}_VERSION_TWEAK ${pkg_version_tweak})
endif()

if(false)
    message(STATUS "${PROJECT_NAME} Repo Hash: ${${XMAKE}_COMMIT_HASH}")
    message(STATUS "${PROJECT_NAME} Repo Branch: ${${XMAKE}_BRANCH_NAME}")
    message(STATUS "${PROJECT_NAME} Repo Describe: ${${XMAKE}_RECENT_TAG}")
    message(STATUS "${PROJECT_NAME} Repo Commit Time: ${${XMAKE}_COMMIT_MDTZ}")
endif()

message(STATUS "${PROJECT_NAME} Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "${PROJECT_NAME} Release Version: ${${XMAKE}_RELEASE_VERSION}")
message(STATUS "${PROJECT_NAME} Install Perfix: ${CMAKE_INSTALL_PREFIX}")
