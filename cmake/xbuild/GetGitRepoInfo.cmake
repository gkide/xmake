# The following will define
#
# - FOUND_GIT_REPO          Find git repo
# - ${PNUC}_RECENT_TAG     The most recent tag
# - ${PNUC}_BRANCH_NAME    The current branch name
# - ${PNUC}_COMMIT_HASH    The current commit short SHA1
# - ${PNUC}_MODIFY_STAMP   The current commit timestamp

# Check if git repo exist
set(FOUND_GIT_REPO false)
file(TO_CMAKE_PATH ${CMAKE_SOURCE_DIR}/.git GIT_REPO_DIR)

if(NOT EXISTS "${GIT_REPO_DIR}" OR NOT IS_DIRECTORY "${GIT_REPO_DIR}")
    return() # repo NOT exist just ignore
endif()

# Get git repo info
set(FOUND_GIT_REPO true)
include(CheckGitRepoInfo)
GegGitRecentTag(${PNUC}_RECENT_TAG)
GetGitCommitTime(${PNUC}_MODIFY_STAMP)
GetGitBranchInfo(${PNUC}_BRANCH_NAME ${PNUC}_COMMIT_SHA1)

if(${PNUC}_BRANCH_NAME AND ${PNUC}_COMMIT_SHA1 AND ${PNUC}_MODIFY_STAMP)
    set(REPO_INFO_FILE ${CMAKE_BINARY_DIR}/RepoInfo)
    file(WRITE ${REPO_INFO_FILE}
        "${${PNUC}_BRANCH_NAME} ${${PNUC}_COMMIT_SHA1} ${${PNUC}_MODIFY_STAMP}")

    string(REPLACE "\"" "" ${PNUC}_MODIFY_STAMP "${${PNUC}_MODIFY_STAMP}")
    string(REPLACE "\\" "" ${PNUC}_MODIFY_STAMP "${${PNUC}_MODIFY_STAMP}")
    string(SUBSTRING "${${PNUC}_MODIFY_STAMP}" 00 10 ${PNUC}_COMMIT_DATE)
    string(SUBSTRING "${${PNUC}_MODIFY_STAMP}" 11 08 ${PNUC}_COMMIT_TIME)
    string(SUBSTRING "${${PNUC}_MODIFY_STAMP}" 20 05 ${PNUC}_COMMIT_ZONE)
    string(REPLACE "-" "" MODIFY_DATE_NUMS ${${PNUC}_COMMIT_DATE})
    string(REPLACE ":" "" MODIFY_TIME_NUMS ${${PNUC}_COMMIT_TIME})
    string(REPLACE ":" "" MODIFY_ZONE_NUMS ${${PNUC}_COMMIT_ZONE})

    string(SUBSTRING "${${PNUC}_COMMIT_SHA1}"  0 7 ${PNUC}_COMMIT_HASH)

    string(APPEND ${PNUC}_RELEASE_VERSION "~${MODIFY_DATE_NUMS}")
    string(APPEND ${PNUC}_RELEASE_VERSION "@${${PNUC}_COMMIT_HASH}")
endif()

if(false)
    message(STATUS "${PROJECT_NAME} Repo Hash: ${${PNUC}_COMMIT_HASH}")
    message(STATUS "${PROJECT_NAME} Repo Branch: ${${PNUC}_BRANCH_NAME}")
    message(STATUS "${PROJECT_NAME} Repo Describe: ${${PNUC}_RECENT_TAG}")
    message(STATUS "${PROJECT_NAME} Repo Commit Time: ${${PNUC}_MODIFY_STAMP}")
endif()

message(STATUS "${PROJECT_NAME} Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "${PROJECT_NAME} Release version: ${${PNUC}_RELEASE_VERSION}")
