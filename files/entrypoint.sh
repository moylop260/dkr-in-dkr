#!/bin/bash
/usr/bin/docker -d --tlsverify --tlscacert=/docker_keys/ca.pem --tlscert=/docker_keys/server-cert.pem --tlskey=/docker_keys/server-key.pem -H=0.0.0.0:${PORT}

