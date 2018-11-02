#!/bin/bash

for i in {1..40}; do
  TOKEN=`kubectl -n student$i describe secret $(kubectl -n student$i get secret  | grep student$i | awk '{print $1}') |grep "token:"`
  echo $TOKEN >> credentials/student$i/password.txt
done
