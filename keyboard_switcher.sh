#!/usr/bin/env bash

localectl status | grep -q "fr" && localectl set-keymap us || localectl set-keymap fr
localectl status
