# ignore parts of files in betwen
# // gitignore:start
#  this text
#            here
#       will     be
#   ignored
# // gitignore:end
git config --global filter.ignore-section.clean 'sed "/\/\/ gitignore:start/,/\/\/ gitignore:end/ { /\/\/ gitignore:start/b; /\/\/ gitignore:end/b; d; }"'
git config --global filter.ignore-section.smudge cat
