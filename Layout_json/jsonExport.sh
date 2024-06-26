#!/bin/bash

rm -rf ./extract
mkdir extract
cd ..

dirs=($(ls | grep "AB"))
for dir in "${dirs[@]}"; do
  cd "$dir"
  echo $PWD

  locales=($(ls ./language_specific/))
  echo $locales

  initials=''
  army_name=''

  line=($(cat T9A-FB_*_EN.tex | grep "bookprefix{"))
  pat='bookprefix\{([a-zA-Z]+)\}'
  [[ $line =~ $pat ]] # $pat must be unquoted
  if [ "${BASH_REMATCH[1]}" != "" ]; then
    initials="${BASH_REMATCH[1]}"
  fi

  for locale in "${locales[@]}"; do
    echo $locale
    file_locale="T9A-JSON-${initials}_${locale}.tex"
    echo $file_locale

    echo $(ls T9A-FB_*_$locale.tex)

    army_name=$(find . -name "T9A-*_$locale.tex" ! -name '*-JSON-*' -exec cat {} \; | sed  -En 's/booktitle\}\{(.+)\}/\1/p')
    army_name="${army_name//\\newcommand{\\/}"
    echo "Army -> $army_name ($initials)"

      case $locale in
        "FR")
          language='\def\languageisfrench{}'
          ;;
        "IT")
          language='\def\languageisitalian{}'
          ;;
        "RU")
          language='\def\languageisrussian{}'
          ;;
        "DE")
          language='\def\languageisgerman{}'
          ;;
        "ES")
          language='\def\languageisspanish{}'
          ;;
        *)
          language='\def\languageisenglish{}'
          ;;
      esac
      echo $language

      # Find all army's files
      army_files=""
      to_replace="./language_specific/$locale/"
      replace_string=""
      while read line
      do
        sub_file=$(echo "${line//$to_replace/$replace_string}")
        army_files="$army_files\subimport{language_specific/\languagetag/}{$sub_file}\n"
      done < <(find "./language_specific/$locale" -type f ! -name 'changelog.tex' ! -name 'changelog.log' ! -name 'AAAcleantexfile.tex' ! -name 'AAAcleantexfile.py')
      army_files=$(echo -e $army_files)
      
      # Find all rules
      rules="\\quote{rules}: [\n  "
      equipments="\\quote{equipments}: [\n  "

      pat='AMRsortedlistentry\{\\([a-z]+)\{*\}*\}'
      pat_category='AMRsortedlistentry\[\\([a-z]+)\{*\}*\]\{\\([a-z]+)\{*\}*\}'
      input="./common/modelrules.tex"
      add_rule=0
      add_equipment=0
      while IFS= read -r line
      do
        if grep -q "universalrules" <<< "$line"; then
         let add_rule=1
         let add_equipment=0
         continue
        fi
        if grep -q "armoury" <<< "$line"; then
         let add_rule=0
         let add_equipment=1
         continue
        fi

        if grep -q "AMRsortedlistentry" <<< "$line"; then
          
          if [ "$add_rule" = 1 ]; then
            [[ $line =~ $pat ]] # $pat must be unquoted
            if [ "${BASH_REMATCH[1]}" != "" ]; then
              rules="${rules}
                      \\\\ruleentry{ key=${BASH_REMATCH[1]}, army=true, name=\\\\${BASH_REMATCH[1]}{}, description=\\\\${BASH_REMATCH[1]}def{} },\n"
              continue
            fi
            [[ $line =~ $pat_category ]] # $pat must be unquoted
            if [ "${BASH_REMATCH[2]}" != "" ]; then
              rules="${rules}
                      \\\\ruleentry{ key=${BASH_REMATCH[2]}, army=true, name=\\\\${BASH_REMATCH[2]}{}, description=\\\\${BASH_REMATCH[2]}def{} },\n"
              continue
            fi
          fi
          if [ "$add_equipment" = 1 ]; then
            [[ $line =~ $pat ]] # $pat must be unquoted
            if [ "${BASH_REMATCH[1]}" != "" ]; then
              equipments="${equipments}
                      \\\\equipmententry{ key=${BASH_REMATCH[1]}, army=true, name=\\\\${BASH_REMATCH[1]}{}, description=\\\\${BASH_REMATCH[1]}def{} },\n"
              continue
            fi
            [[ $line =~ $pat_category ]] # $pat must be unquoted
            if [ "${BASH_REMATCH[2]}" != "" ]; then
              equipments="${equipments}
                      \\\\equipmententry{ key=${BASH_REMATCH[2]}, army=true, name=\\\\${BASH_REMATCH[2]}{}, description=\\\\${BASH_REMATCH[2]}def{} },\n"
              continue
            fi
          fi
        fi

      done < "$input"

      pat='\\newcommand\{\\(.*)def\}\{'
      input="./language_specific/$locale/dictionnary_armylist.tex"
      while IFS= read -r line
      do
        if grep -q "def}{" <<< "$line"; then
          [[ $line =~ $pat ]] # $pat must be unquoted
          if [ "${BASH_REMATCH[1]}" != "" ]; then
            rules="${rules}
                      \\\\ruleentry{ key=${BASH_REMATCH[1]}, army=true, name=\\\\${BASH_REMATCH[1]}{}, description=\\\\${BASH_REMATCH[1]}def{} },\n"
            equipments="${equipments}
                      \\\\equipmententry{ key=${BASH_REMATCH[1]}, army=true, name=\\\\${BASH_REMATCH[1]}{}, description=\\\\${BASH_REMATCH[1]}def{} },\n"
          fi
        fi

      done < "$input"

      rules=$"${rules::${#rules}-3} ],"
      rules=$(echo -e $rules)
      rules="${rules//\\\\/\\}"
      equipments=$"${equipments::${#equipments}-3}  ],"
      equipments=$(echo -e $equipments)
      equipments="${equipments//\\\\/\\}"

      # Find all banners
      banners=$"\\quote{banners}: [\n"
      to_replace="./common/specialitemsfolder/"
      replace_string=""
      while read line
      do
        sub_file=$(echo "${line//$to_replace/$replace_string}")
        banners="$banners		\subimport{common/specialitemsfolder/}{$sub_file}\n"
      done < <(find ./common/specialitemsfolder -type f -exec grep -l "banner" {} \;)
      banners="$banners  ],"
      banners=$(echo -e $banners)
      
      # Find all special items
      specialItems=$"\\quote{specialItems}: [\n"
      while read line
      do
        sub_file=$(echo "${line//$to_replace/$replace_string}")
        specialItems="$specialItems		\subimport{common/specialitemsfolder/}{$sub_file}\n"
      done < <(find ./common/specialitemsfolder -type f -exec grep -L "banner" {} \;)
      specialItems="$specialItems  ],"
      specialItems=$(echo -e $specialItems)
      
      # Find all singularities
      singularities=$"\\quote{singularities}: [\n"
      dir_replace="./"
      while read directory
      do
        singularities="$singularities  \{\\quote{key}: \\quote{$(basename $directory)},\\quote{items}: [\n"

        to_replace="$directory/"

        while read line
        do
          sub_dir=$(echo "${directory:2:${#directory}}")
          sub_file=$(echo "${line//$to_replace/$replace_string}")
          singularities="$singularities		\subimport{$sub_dir/}{$sub_file}\n"
        done < <(find $directory -type f)

        singularities="$singularities ]\},\n"
      done < <(find ./common/* -maxdepth 1 -type d -not \( -path './common/armylistfolder' -o -path './common/specialitemsfolder' \))
      
      singularities="$singularities  ],"
      singularities=$(echo -e $singularities)
      
      # Find all mounts
      mounts=$"\\quote{mounts}: [\n"
      to_replace="./common/armylistfolder/"
      replace_string=""
      while read line
      do
        sub_file=$(echo "${line//$to_replace/$replace_string}")
        mounts="$mounts		\subimport{common/armylistfolder/}{$sub_file}\n"
      done < <(find ./common/armylistfolder -type f -name "*MOUNT.tex")
      mounts="$mounts  ],"
      mounts=$(echo -e $mounts)
      
      # Find all units
      units=$"\\quote{units}: [\n"
      to_replace="./common/armylistfolder/"
      replace_string=""
      while read line
      do
        sub_file=$(echo "${line//$to_replace/$replace_string}")
          units="$units		\subimport{common/armylistfolder/}{$sub_file}\n"
      done < <(find ./common/armylistfolder -type f -not -name "*MOUNT.tex")
      units="$units  ]"
      units=$(echo -e $units)
      
      echo $language > $file_locale
      echo "" >> $file_locale
      echo "" >> $file_locale
      echo "% Preamble" >> $file_locale
      echo "\documentclass[a4paper,10pt]{article}" >> $file_locale
      echo "\usepackage{import}" >> $file_locale
      echo "\subimport{../Layout/}{Layout.tex}" >> $file_locale
      echo "\graphicspath{{pics/}{../Layout/pics/}{../Arcane_Compendium/pics/}}" >> $file_locale
      echo "\subimport{common/}{layout.tex}" >> $file_locale
      echo "" >> $file_locale
      echo "$army_files" >> $file_locale
      echo "" >> $file_locale
      echo "\subimport{common/}{toc.tex}" >> $file_locale
      echo "\subimport{common/}{footer.tex}" >> $file_locale
      echo "\subimport{../Layout_json/}{rpg-json}" >> $file_locale
      echo "" >> $file_locale
      echo "" >> $file_locale
      echo "\begin{document}" >> $file_locale
      echo "	\pagestyle{empty}" >> $file_locale
      echo "\{" >> $file_locale
      echo "	\quote{id}:\quote{}," >> $file_locale
      echo "	\quote{initials}:\quote{${initials}}," >> $file_locale
      echo "	\quote{name}:\quote{${army_name}}," >> $file_locale
      echo "	\quote{locale}: \quote{\languagetag{}}, " >> $file_locale
      echo "$rules" >> $file_locale
      echo "$equipments" >> $file_locale
      echo "$specialItems" >> $file_locale
      echo "$banners" >> $file_locale
      echo "$singularities" >> $file_locale
      echo "$mounts" >> $file_locale
      echo "$units" >> $file_locale
      echo "\}" >> $file_locale
      echo "\end{document}" >> $file_locale
      
      lualatex -interaction=nonstopmode $file_locale # >> /dev/null
      lualatex -interaction=nonstopmode $file_locale # >> /dev/null
      python3 ../Layout_json/jsonTxtExtractor.py ${file_locale/.tex/.pdf}
      mv ${file_locale/.tex/.json} ../Layout_json/extract/

      rm ${file_locale/.tex/.*}
  done

  cd ..
done