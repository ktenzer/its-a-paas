#!/bin/bash

for i in {0..40}; do
  TOKEN=`kubectl -n student$i describe secret $(kubectl -n student$i get secret  | grep student$i | awk '{print $1}') |grep "token:"`
  echo $TOKEN > credentials/$i/token.txt
done
