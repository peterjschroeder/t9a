#! /bin/bash

ROOT=$PWD

for dir in $(git diff --dirstat=files,0 HEAD~1 | sed 's/^[ 0-9.]\+% //g' | cut -d/ -f 1 | sort | uniq);
do
    echo $dir
    cd $ROOT/$dir
    if [ -e *.tex ];
    then
        time for i in 1 2 3; do lualatex *.tex; done
        if [ -e *.pdf ];
        then
            mv *.pdf $($ROOT/pipeline_scripts/get_version.sh *.tex).pdf
        fi
    fi
done