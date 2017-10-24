#!/bin/bash
# stop execution if any called command exits with non zero
set -e

scriptName="reportSplit"
tempDataFile="$TMPDIR""${scriptName}.temp"

# input file path
inputFile="$1"

if [ ! "${inputFile}" ]
  then
    printf "Split a PDF with multiple bookmarks into individual student files\n"
    printf "usage: $0 /path/to/input/file.pdf\n"
    exit 0
fi

inDirPath=$(dirname "${inputFile}")
inFileName=$(basename "${inputFile}")

outFileName="${inFileName%.*}"
outDirPath="${inDirPath}"/split_"${outFileName}"/

# search for the page numbers with student id on them
#pageArray=(`./pdfgrep -i -n -P "Student:\W{0,}\w+.*StudentID:\D{0,}\d+" "${inputFile}" |sed -E 's/([0-9]+)(:.*)/\1/'`)

if [ ! -r "$inputFile" ]
  then
    printf "[${inputFile}] does not exist or is unreadable\nexiting\n"
    exit 2
fi


# get a list of page numbers and student information for each record
# searches for pages that contain the string: 
# "Studnet: FirstName LastName StudentID:123456"
pageArray=(`./pdfgrep -i -n -P "Student:\W{0,}\w+.*StudentID:\D{0,}\d+" "${inputFile}" | sed -E 's/^([0-9]+)(: {0,}Student: {0,})([A-Za-z-]+ .*[A-Za-z-]+)( {0,}StudentID: {0,})([0-9]+)/\1:\3_\5/' | sed 's/ /_/g'`) 

if [ ${#pageArray[@]} -lt 1 ]
  then
    printf "no student records found in input file\nexiting\n"
    exit 0
  else
    if [ ! -d "${outDirPath}" ]
      then
        mkdir "${outDirPath}"
    fi
fi

for i in "${!pageArray[@]}"
  do
    echo "${pageArray[i]}"
    IFS=: 
    read -ra startPage <<< "${pageArray[$i]}"
    read -ra endPage <<< "${pageArray[$i+1]}"
    let endPage=endPage-1

    if [ "${endPage[0]}" -lt 0 ]
      then
        let endPage=${startPage[0]}*100
    fi
    
    pages="${startPage}"-"${endPage}"

    splitFile="${outDirPath}""${outFileName}"_"${startPage[1]}".pdf
    echo $splitFile

    ./sejda-console-3.2.22/bin/sejda-console extractpages -f "${inputFile}" -s $pages -o "${splitFile}"

    #pageList="${pageList}""${startPage}"-"${endPage}",
    
done

