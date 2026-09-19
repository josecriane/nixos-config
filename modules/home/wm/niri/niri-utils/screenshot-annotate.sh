#!/usr/bin/env bash

region=$(@slurp@) || exit 0

@grim@ -g "$region" - | @swappy@ -f -
