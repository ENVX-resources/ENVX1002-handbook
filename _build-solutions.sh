#!/bin/bash
# Post-render hook: build solution labs and copy into exercise site.
# Only runs under the exercise profile (default), so no recursion.
quarto render --profile solution
mkdir -p _site/solutions/labs
cp _solution/labs/Lab*.html _site/solutions/labs/
cp -r _solution/labs/data _site/solutions/labs/ 2>/dev/null || true
cp -r _solution/labs/images _site/solutions/labs/ 2>/dev/null || true
