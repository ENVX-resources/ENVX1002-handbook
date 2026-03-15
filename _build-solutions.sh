#!/bin/bash
# Post-render hook: build solution labs and copy into exercise site.
# Only runs under the exercise profile (default), so no recursion.
#
# Skip during single-file or preview renders to keep development fast.
# Quarto sets QUARTO_PROJECT_RENDER_ALL=1 only during full project renders.
if [ "$QUARTO_PROJECT_RENDER_ALL" != "1" ]; then
  exit 0
fi
quarto render --profile solution
mkdir -p _site/solutions/labs
cp _solution/labs/Lab*.html _site/solutions/labs/
cp _solution/labs/Lab*.pdf _site/solutions/labs/
cp -r _solution/labs/data _site/solutions/labs/ 2>/dev/null || true
cp -r _solution/labs/images _site/solutions/labs/ 2>/dev/null || true
