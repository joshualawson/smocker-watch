# Smocker Watch

Uses `thiht/smocker` docker image and simply just adds file watching and loading mock .yml files by convention
into smocker.

## Usage

To make use to loading mocks automatically and listen to file changes on those mocks you must mount your folder that
contains your .yml mocks to the `/mocks` directory in the container.

```shell
docker run -v /my/mocks/location:/mocks --name=smocker-watch joshualawson/smocker-watch
```