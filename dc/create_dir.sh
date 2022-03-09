#!/bin/bash

if [ ! -d $1 ]; then
  echo "Creating $1"
  mkdir -p $1;
fi
