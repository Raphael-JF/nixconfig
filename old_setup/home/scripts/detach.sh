#!/usr/bin/env bash

exec setsid "$@" >/dev/null 2>&1 < /dev/null &