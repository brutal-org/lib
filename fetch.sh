#!/bin/sh

mkdir .temp

git clone --recursive https://github.com/brutal-org/brutal.git .temp
# prerequisites:
rm -rf libs
mkdir libs
rm -rf headers
mkdir headers

# copy lib
cp -r .temp/sources/libs/ .

# gen headers
cd .temp


if [[ -z "${GITHUB_ACTIONS}" ]]; then
    echo "! GITHUB_ACTIONS is not set, we expect you to have installed every brutal dependencies !"
else
    bash sources/build/scripts/setup-ubuntu.sh
fi

bash brutal.sh -a -f
cp -r ./bin/generated/headers/ ..
cd ..


rm -rf .temp

# remove unused arch utils
cd libs/embed/


# // obligated because ./*.h is the same as ./**.h
# v = (path != ./*/*.h)  &&  (path == ./*.h)
# delete(v) if (path != x86_64/**)  &&  (path != sdl/**)  &&  (path != posix/**)

find . -type f \( \( -not -path './*/*.h' \) -and \( -path './*.h' \) -prune \) -o  -type f \( -not -path './x86_64/**' \) -and \( -not -path './sdl/**' \) -and \( -not -path './posix/**' \) -exec rm {} +
cd ../..
