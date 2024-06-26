#! /bin/bash

FILE=$1

#T9A-FB_2ed_DH_2023_Beta1_EN.tex
#\newcommand{\editionversion}{\nth{2} Edition}
#\newcommand{\booktitle}{Dwarven Holds}
#\newcommand{\balanceversion}{2023}
#%\newcommand{\documentversion}{}% undefined if first version (= version 1), 2 for second version, etc.
#\newcommand{\betaversion}{2}% 1 if first beta, 2 if second beta, etc.
#%\newcommand{\hotfixversion}{1}% undefined if no hotfix (= version 0), 1 for first hotfix, etc. this version number is language specific, each translation can be in his own hotfix number
#\newcommand\releasedate{February 28, 2023}% Comment if you want to use today's date in your default language
#%\newcommand{\specialversion}{INTERNAL Pre-release 2}% anything related to the version

edition=$(cat $FILE | perl -ne 'print $1 if m!^\\newcommand\{\\editionversion\}\{\\nth\{([^\}]*)\}\s*Edition\}!i')
balance=$(cat $FILE | perl -ne 'print $1 if m!^\\newcommand\{\\balanceversion\}\{([^\}]*)\}!i')
beta=$(cat $FILE |    perl -ne 'print $1 if m!^\\newcommand\{\\betaversion\}\{([^\}]*)\}!i')
hotfix=$(cat $FILE |  perl -ne 'print $1 if m!^\\newcommand\{\\hotfixversion\}\{([^\}]*)\}!i')

army=$(echo $FILE | cut -d_ -f 3)
lang=$(echo $FILE | cut -d. -f 1 | rev | cut -d_ -f 1 | rev)

BOOK=T9A-FB_${edition}ed_${army}

if [[ $balance -ne "" ]]
then
	BOOK=${BOOK}_${balance}
fi

if [[ $beta -ne "" ]]
then
	BOOK=${BOOK}_beta${beta}
fi

if [[ $hotfix -ne "" ]]
then
	BOOK=${BOOK}_hotfix${hotfix}
fi

echo ${BOOK}_${lang}
