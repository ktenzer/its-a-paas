#!/bin/bash

for i in {0..40}; do
  cp credentials/$i/token.txt /home/student$i
done
