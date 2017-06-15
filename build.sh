#!/bin/sh
# Version of dotnet to create image for
# Remember you will need to change the version in Dockerfile.extractor as well as here 
#  for different version
version=1.1.2

# Build image to extract dotnet from. Files are placed in /dotnet on the container
docker build -t travelrepublic/dotnet-extractor:$version . -f Dockerfile.extractor

# Create a container from the extractor image
docker create --name dotnet-extract-$version travelrepublic/dotnet-extractor:$version

# Copy the dotnet files out from the container to a local folder
docker cp dotnet-extract-$version:/dotnet .
# Make a tmp directory needed by dotnet in the scratch based image
mkdir -p dotnet/tmp

docker rm -f dotnet-extract-$version

# Build the scratch based image copying across the files from the dotnet folder
docker build -t travelrepublic/dotnet:$version-runtime .
