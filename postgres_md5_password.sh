#!/bin/bash
# $1 user
# $2 password
# echo -n "md5"; echo -n "password123admin" | md5sum | awk '{print $1}'
#   md53f84a3c26198d9b94054ca7a3839366d
echo -n '{"md5":"'
echo -n "md5"; echo -n "$2$1" | md5sum | awk '{print $1}'|tr -d '\n' | tr -d ' '
echo '"}'