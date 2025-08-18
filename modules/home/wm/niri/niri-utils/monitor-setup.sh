#!/usr/bin/env bash

sleep 1

if niri msg outputs | grep -q "DP-1"; then
    niri msg action focus-monitor-left
fi