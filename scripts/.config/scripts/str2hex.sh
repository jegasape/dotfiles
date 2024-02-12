#!/bin/bash
echo -n $1 | od -A n -t x1 | sed 's/ *//g'

