#!/bin/bash

find . -name "*.proto" -exec sed -i 's/\r//g' {} \;
find . -name "*.proto" -exec sed -i 's/^\xEF\xBB\xBF//' {} \;