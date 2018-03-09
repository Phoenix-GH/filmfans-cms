#!/usr/bin/env bash

export REDIS_PROVIDER="redis://localhost:6379"

bundle exec sidekiq
