#!/usr/bin/env bash

REPO_VCS="GIT";
REPO_DIR="$(git rev-parse --show-toplevel)";
VS_VFILE="${REPO_DIR}/CMakeLists.txt";

VS_MAJOR="set(XMAKE_VERSION_MAJOR";
VS_MINOR="set(XMAKE_VERSION_MINOR";
VS_PATCH="set(XMAKE_VERSION_PATCH";
VS_TWEAK="set(XMAKE_VERSION_TWEAK";
