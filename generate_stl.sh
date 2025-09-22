#!/bin/bash

# Script that generates 3d-printable .stl files from parametric .SCAD
# models
#
# Copyright (c) 2023 - 2024 Kauzerei <mailto:github@kauzerei.de>
# Copyright (c) 2023 - 2024 Thomas Buck <thomas@xythobuz.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

shopt -s expand_aliases

command -v openscad >/dev/null 2>&1 || { alias openscad='openscad-nightly'; }
command -v openscad >/dev/null 2>&1 || { echo >&2 "Openscad not installed. Abotring "; exit 1; }
command -v pgrep >/dev/null 2>&1 || { echo >&2 "procps not installed. Aborting "; exit 1; }

N=$(nproc --all)

mkdir -p stl

if [ -z "$( ls -A $(git rev-parse --show-toplevel)/import/BOSL2 )" ]; then 
echo "BOSL2 not found" && git submodule update --init
fi

for MODULE in $@
do
  MODULENAME=$(basename "$MODULE" ".${MODULE##*.}")
  PARTS=$(grep -o "part.*//.*\[.*]" ${MODULE} | sed 's/,/ /g' | sed 's/.*\[\([^]]*\)\].*/\1/g')
  echo "generating from ${MODULE}:"
  if [ -z "$PARTS" ]; then 
    openscad --q --enable roof --backend Manifold "$(cd "$(dirname "${MODULE}")" && pwd)/$(basename "${MODULE}")" --D part=\"${PART}\" --o $(pwd)/stl/${MODULENAME}.stl &
    while [ $(pgrep -c openscad) -ge $N ]; do sleep 1; done
  fi
  for PART in ${PARTS}
  do
    if [[ "${PART}" != "NOSTL"* ]]; then
      echo ${PART}
      FILENAME=$(echo stl/${MODULENAME}_${PART}.stl | tr '[:upper:]' '[:lower:]')
      openscad --q --enable roof --backend Manifold "$(cd "$(dirname "${MODULE}")" && pwd)/$(basename "${MODULE}")" --D part=\"${PART}\" --o $(pwd)/${FILENAME} &
      while [ $(pgrep -c openscad) -ge $N ]; do sleep 1; done
    fi
  done
done
wait

