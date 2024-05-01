#!/bin/sh
bin/main_package eval "mix ecto.migrate"
bin/main_package start
