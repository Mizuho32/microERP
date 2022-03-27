#!/bin/bash

cd $(dirname $0)
bundle exec ruby ws.rb config.yaml
