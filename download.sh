#!/bin/bash

wget -r --no-parent https://icpc.iisf.or.jp/past-icpc/domestic2015/qualify2015_data/
mkdir data
find icpc.iisf.or.jp/past-icpc/domestic2015/qualify2015_data/ | grep -E '[A-Z]\d(\.ans)?' | xargs -I{} mv {} data
rm -rf icpc.iisf.or.jp
