#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BUILD_DIR="${DIR}/build/"

MODE_DEBUG="debug"
MODE_RELEASE="release"

MODE=${MODE_DEBUG}
if [ $# -eq 1 ] && [ $1 == ${MODE_RELEASE} ]; then
    echo "Release mode"
    MODE=${MODE_RELEASE}
fi

rm -r ${BUILD_DIR}
mkdir ${BUILD_DIR} && cd ${BUILD_DIR}

cmake .. -DCMAKE_BUILD_TYPE=release

echo "Building SPLINTER"
make -j$(nproc)

make install

cd splinter-python/
python3 setup.py sdist bdist_wheel

if [ ${MODE} == ${MODE_RELEASE} ]; then
    python3 -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*
elif [ ${MODE} == ${MODE_DEBUG} ]; then
    python3 -m twine upload --repository-url https://www.pypi.org/legacy/ dist/*
else
    echo "Invalid mode: ${MODE}"
fi
