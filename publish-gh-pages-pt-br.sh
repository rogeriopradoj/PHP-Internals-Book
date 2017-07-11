#!/usr/bin/env sh
# make the script fail for any failed command
set -e
# make the script display the commands it runs to help debugging failures
set -x

# Go to the output directory
cd BookHTML/html

# Remove the existing repo if it exists
if [ -d ".git" ]; then
    rm -rf .git
fi

# Create a repo for the built website for the gh-pages branch
git init
git checkout --orphan gh-pages

# configure env (locally)
git config user.email 'rogeriopradoj@gmail.com'
git config user.name 'PHP-Internals-Book bot'

# commit build
touch .nojekyll
git add .
git commit -m "Build website"

# push to GitHub Pages
git push -f "https://github.com/rogeriopradoj/PHP-Internals-Book.git" gh-pages
