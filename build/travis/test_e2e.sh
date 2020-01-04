#!/bin/bash
set -ue

gem install krates && krates -v

pushd test && \
  bundle install && \
  krates -v && \
  rake compose:setup

# Skip running all the tests when we're in tracing mode
if [ "$TRACE" = "1" ];
then
  /bin/bash
else
  # End-2-end integration testing is desired
  rake
  popd
fi