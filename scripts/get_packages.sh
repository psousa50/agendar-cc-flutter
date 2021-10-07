#!/bin/bash

SOURCE_DIR=$(
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit
  pwd -P
)
ROOT_DIR=$(
  cd "${SOURCE_DIR}/../" || exit
  pwd
)

rm -rf "${ROOT_DIR}"/packages

mkdir "${ROOT_DIR}"/packages
mkdir "${ROOT_DIR}"/packages/time_range_selector

cp -r "${MY_PACKAGES}"/time-range-selector/lib "${ROOT_DIR}"/packages/time_range_selector
cp -r "${MY_PACKAGES}"/time-range-selector/pubspec.* "${ROOT_DIR}"/packages/time_range_selector
