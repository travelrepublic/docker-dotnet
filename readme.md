# Scratch Based .NET Core Images

## Why?

Scratch based images start with no filesystem. 

In this case we are extracting just the .NET Core framework and it's
dependencies.

There are no other tools in the image, no distribution etc.

This makes the image smaller, gives you less reason to change the image
because of the application dependencies and arguably makes the image
more secure.

You'll have a more intimate understanding of what is running in your 
container because you put it there.

## Any Gotchas?

Probably lots.

For instance if you want to make any https calls you'll want some
certificate authority certificates.

You'll have to think about it but that isn't always a bad thing.

## How Do I Use It?

Just like you normally would.

Make sure the dotnet version you use to build the application matches 
the version in the Dockerfile.

Here we are using 1.0.5

```sh
mkdir console
dotnet new console
dotnet restore
dotnet publish -c Release -o app
```

Create the following Dockerfile

```dockerfile
FROM travelrepublic/dotnet:1.0.5-runtime
ADD app /app
ENTRYPOINT ["/usr/share/dotnet/dotnet", "/app/console.dll"]
```

and then

```sh
docker image build -t travelrepublic/consoleapp .
docker container run --rm travelrepublic/consoleapp
```

## How Do I Debug It?

That is a bit more difficult.

Obviously there are no tools in the container itself.

You'll want to bring up another container in the same namespace/s as the 
dotnet container.

See [here](https://medium.com/@rothgar/how-to-debug-a-running-docker-container-from-a-separate-container-983f11740dc6) for a better explanation.

If you need to debug an initialisation issue you might have to consider 
copying something like strace to the application container. 

There are probably better ways to do it though.
