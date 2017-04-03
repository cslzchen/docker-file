#!/usr/bin/env python
"""Rackspace Cloud Monitoring Plugin for Check Barman Status."""

import json
import sys

from docker import APIClient
from docker.errors import APIError

from optparse import OptionParser


class DockerService(object):
    """Create an object for a Docker service. Assume it is stopped."""

    def __init__(self, url, container, database):

        self.url = url
        self.container = container
        self.command = 'barman check ' + database

    def barman_check(self):
        """Connect to the Barman Docker object and check configuration. Error out on failure."""

        docker_client = APIClient(base_url=self.url)

        try:
            # TODO: verify that the barman container is running
            docker_client.inspect_container(self.container)
        except Exception:
            print('stats err failed when inspecting the container.')
            sys.exit(1)

        try:
            exec_id = docker_client.exec_create(self.container, self.command)
            response = docker_client.exec_start(exec_id)

            success = 0
            for line in response.splitlines():
                if 'FAILED' in line:
                    failure = ((line.split('FAILED'))[0]).strip(': \t\n\r')
                    success = 1
                    print('status err ' + failure + ' failed in barman check.')
            sys.exit(success)
        except Exception:
            print('stats err failed to execute barman check command in the container.')
            sys.exit(1)


def main():
    """Instantiate a DockerService and Check Barman Configuration"""

    parser = OptionParser()

    parser.add_option(
        '-u',
        '--url',
        default='unix://var/run/docker.sock',
        help='URL for Docker service (Unix or TCP socket).'
    )

    parser.add_option(
        '-c',
        '--container',
        default='barman',
        help='Name or Id of container that you want to monitor'
    )

    parser.add_option(
        '-d',
        '--database',
        default='pg_osf',
        help='Name of the database server for barman backup'
    )

    (opts, args) = parser.parse_args()

    docker_service = DockerService(opts.url, opts.container, opts.database)
    docker_service.barman_check()


if __name__ == '__main__':
    main()
