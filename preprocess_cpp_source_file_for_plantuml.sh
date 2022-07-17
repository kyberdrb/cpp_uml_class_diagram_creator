#!/bin/sh

#set -x

INPUT_FILE="$1"

if [ -z "${INPUT_FILE}" ]
then
  printf "%s\n" "No input file specified"
  printf "%s\n" "Please provide a C++ header or source file"
  printf "%s\n" "Usage: $(basename "${0}") <input_cpp_file>"
  exit 1
fi

PREPROCESSED_FILE="/tmp/$(basename "${INPUT_FILE}").puml.preprocessed"

cp "${INPUT_FILE}" "${PREPROCESSED_FILE}"

sed --in-place '/^\s*\/\/.*/d' "${PREPROCESSED_FILE}"
sed --in-place '/^\s*#include </d' "${PREPROCESSED_FILE}"
sed --in-place '/^\s*#pragma/d' "${PREPROCESSED_FILE}"

sed --in-place 's/const\s*//g' "${PREPROCESSED_FILE}"
sed --in-place 's/volatile\s*//g' "${PREPROCESSED_FILE}"
sed --in-place 's/explicit\s*//g' "${PREPROCESSED_FILE}"
sed --in-place 's/friend\s*//g' "${PREPROCESSED_FILE}"
sed --in-place 's/override\s*//g' "${PREPROCESSED_FILE}"
sed --in-place 's/;\s*//g' "${PREPROCESSED_FILE}"

sed --in-place 's/virtual/\{abstract\}/g' "${PREPROCESSED_FILE}"
sed --in-place 's/\s*=\s*0.*$//g' "${PREPROCESSED_FILE}"

sed --in-place "s/(\s*/(/g" "${PREPROCESSED_FILE}"
sed --in-place "s/\s*)/)/g" "${PREPROCESSED_FILE}"

sed --in-place "s/\s*{.*/{/g" "${PREPROCESSED_FILE}"
sed --in-place 's/{/\n/g' "${PREPROCESSED_FILE}"

sed --in-place "/^class/s/$/ {/g" "${PREPROCESSED_FILE}"

sed --in-place 's/\*//g' "${PREPROCESSED_FILE}"
sed --in-place 's/&//g' "${PREPROCESSED_FILE}"
sed --in-place 's/std::unique_ptr<//g' "${PREPROCESSED_FILE}"
sed --in-place 's/std::shared_ptr<//g' "${PREPROCESSED_FILE}"
sed --in-place 's/std::reference_wrapper<//g' "${PREPROCESSED_FILE}"
sed --in-place 's/std::ref<//g' "${PREPROCESSED_FILE}"

sed --in-place 's/>\s*/>/g' "${PREPROCESSED_FILE}"

sed --in-place 's/std:://g' "${PREPROCESSED_FILE}"

sed --in-place '/^\s*$/d' "${PREPROCESSED_FILE}"

sed --in-place "s/}.*$/}/g" "${PREPROCESSED_FILE}"
sed --in-place 's/}//g' "${PREPROCESSED_FILE}"

cat --squeeze-blank "${PREPROCESSED_FILE}" | tee "${PREPROCESSED_FILE}"

cat "${PREPROCESSED_FILE}" | xclip -selection clipboard

printf "%s\n" "Output file had been written to"
printf "\n"
printf "%s\n" "${PREPROCESSED_FILE}"
printf "\n"
printf "%s\n" "and its contents had been copied to clipboard."

