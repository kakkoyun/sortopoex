# Sortopoex

[![semver](https://img.shields.io/badge/semver-1.0.0-blue.svg?cacheSeconds=2592000)](https://github.com/kakkoyun/sortopoex/releases) [![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)](https://github.com/kakkoyun/sortopoex/commits/master) [![](https://images.microbadger.com/badges/image/kakkoyun/sortopoex.svg)](https://microbadger.com/images/kakkoyun/sortopoex) [![](https://images.microbadger.com/badges/version/kakkoyun/sortopoex.svg)](https://microbadger.com/images/kakkoyun/sortopoex)

An JSON API service that sorts given tasks

## Examples

```console
$ cat mytasks.json
{
    "tasks": [
        {
            "name": "task-1",
            "command": "touch /tmp/file1"
        },
        {
            "name": "task-2",
            "command": "cat /tmp/file1",
            "requires": [
                "task-3"
            ]
        },
        {
            "name": "task-3",
            "command": "echo 'Hello World' > /tmp/file1",
            "requires": [
                "task-1"
            ]
        },
        {
            "name": "task-4",
            "command": "rm /tmp/file1",
            "requires": [
                "task-2",
                "task-3"
            ]
        }
    ]
}

$ curl -H "Content-type: application/json" -H "Accept: application/json" -d @mytasks.json localhost:4000/api/tasks/
sort
[
  {
    "command": "touch /tmp/file1",
    "name": "task-1"
  },
  {
    "command": "echo 'Hello World' > /tmp/file1",
    "name": "task-3"
  },
  {
    "command": "cat /tmp/file1",
    "name": "task-2"
  },
  {
    "command": "rm /tmp/file1",
    "name": "task-4"
  }
]
```

## Development

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Tests

```console
$ mix test
```

### Build Docker

Build the docker image with the following commands:

```console
$ make docker-build
```

### Learn more about Framework

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/kakkoyun/sortopoex/tags).


## License and Copyright

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details
