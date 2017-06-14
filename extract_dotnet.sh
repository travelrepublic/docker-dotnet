#!/bin/bash
# Copy the dotnet core framework and all its dependencies to
#  the specified directory
extract_to_dir=$1

mkdir -p $extract_to_dir

# Find dependencies of dotnet executable
#  We aren't interested in file in /usr/share/dotnet as we will
#  copy the whole directory
exe_deps=$(ldd /usr/bin/dotnet \
    | grep -v '/usr/share/dotnet' \
    | awk 'BEGIN{ORS=" "}$1 ~/^\//{print $1}$3 ~/^\//{print $3}' \
    | sed 's/,$/\n/')

# Find dependencies of dotnet libraries
#  We aren't interested in file in /usr/share/dotnet as we will
#  copy the whole directory
lib_deps=$(find /usr/share/dotnet -name '*.so' \
    | xargs ldd \
    | grep -v '/usr/share/dotnet' \
    | awk 'BEGIN{ORS=" "}$1 ~/^\//{print $1}$3 ~/^\//{print $3}' \
    | sed 's/,$/\n/')

deps="$exe_deps $lib_deps"
deps=$(echo "$deps" | sort | uniq)

for file in $deps; do
	cp --parents $file $extract_to_dir
done

cp -R --parents /usr/share/dotnet $extract_to_dir
