#!/usr/bin/env bash
set -e

mv web/main.dart web_main_env/main_dev.dart
mv web_main_env/main_production.dart web/main.dart
webdev build
mv web/main.dart web_main_env/main_production.dart
mv web_main_env/main_dev.dart web/main.dart
