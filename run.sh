#!/bin/bash

dune build

for problem in "data/C"?; do
    time diff ${problem}.ans <(dune exec icpc_domestic2015_c <${problem})
done
