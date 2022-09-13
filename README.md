# homebus-gpsd

![rspec](https://github.com/HomeBusProjects/homebus-gpsd/actions/workflows/rspec.yml/badge.svg)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

Publishes information about a [gpsd](http://gpsd.io) instance.

## Usage

On its first run, `homebus-gpsd` needs to know how to find the Homebus provisioning server.

```
bin/homebus-gpsd -b homebus-server-IP-or-domain-name -P homebus-server-port username [password]
```

The port will usually be 443 (its default value). The server will default to `homebus.org`

Once it's provisioned it stores its provisioning information in `.homebus.json`. This file should be protected; the auth token in it will allow devices to join your network.

## Configuration

Create a `.env` file in the repo's home directory.

Put two lines in it:
```
GPSD_HOST=GPSD HOSTNAME OR IP ADDRESS
GPSD_PORT=GPSD PORT NUMBER
```

The port number is usually 2947.

You can ususally use `127.0.0.1` or `localhost` if `gpsd` is running on
the same computer as the publisher. If it's not, make sure that `gpsd`
is accessible from the computer you're running this program on. If you
have problems, use a program like [`netcat`](https://en.wikipedia.org/wiki/Netcat)
to try to connect to it.

# LICENSE

Licensed under the [MIT License](https://mit-license.org).

