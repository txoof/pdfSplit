#!/bin/bash
# stop execution if any called commands with a non zero result
set -e

scriptName="bookmarkSplit"
tempDataFile="$TMPDIR""${scriptName}.temp"
echo $tempDataFile

# first commandline argument
droppedFile="$1"

if [ ! "$droppedFile" ]
  then
    printf "Split a PDF with multiple bookmarks into individual student files"
    printf "usage: $0 /path/to/input/file.pdf"
    exit 0
fi
# get the path and filename
inDirPath=$(dirname "${droppedFile}")
inFileName=$(basename "${droppedFile}")

# set the output path
outDirPath="${inDirPath}/split_${inFileName%.*}"
outFileName="${inFileName%.*}_"

printf "Splitting file: $inFileName\n"

# check that hte dropped file is readable
if [ ! -r "$droppedFile" ]
  then
    printf "$droppedFile does not exist or is unreadable!\n"
    printf "exiting\n"
    exit 2
fi

printf "Split files wil be stored at: $outDirPath\n"
if [ ! -w "${inDirPath}" ]
  then
    printf "folder: ${inDirPath} does not appear to be writeable\nexiting\n"
    exit 2
fi
if [ -d "${outDirPath}" ]
  then
      # remove any stale PDFs
      rm -r "${outDirPath}"
      mkdir "${outDirPath}"
  else
    mkdir "${outDirPath}"
fi

# split input file based on bookmarks (one per student)
./sejda-console-3.2.22/bin/sejda-console splitbybookmarks -l 1 -f "${droppedFile}" -o "${outDirPath}" --overwrite

#fileArray=(`./pdfgrep -P "Student: .*StudentID:\d+" "${outDirPath}"/*.pdf  | sed -E 's/(.*\/)(.*\.pdf)(: {0,}Student: {0,})([A-Za-z']+.*[A-Za-z']+)( {1,}StudentID:)([0-9]+)/\1\2:\4-\6;/'`)

if [ ! -w "${TMPDIR}" ] 
  then
    printf "$TMPDIR is not writable.\nexiting\n"
    exit 2
fi

if [ -w "${tempDataFile}" ]
  then
    rm "${tempDataFile}"
fi

./pdfgrep -P "Student: .*StudentID:\d+" "${outDirPath}"/*.pdf  | sed -E 's/(.*\/)(.*\.pdf)(: {0,}Student: {0,})([A-Za-z']+.*[A-Za-z']+)( {1,}StudentID:)([0-9]+)/\1\2:\4-\6/' >> "${tempDataFile}"

# init an array to hold the lines from the data file
fileArray=()

# read in temp data file
input="${tempDataFile}"
while IFS= read -r var
  do
    fileArray+=("$var")
done < "$input"

# set the internal delimeter 
IFS=:
for i in "${fileArray[@]}"
  do
    echo "$i"
    IFS=: read -ra eachFile <<< "$i"
    #echo old: "${eachFile[0]}"
    #echo new: "${outDirPath}"/"${outFileName}""${eachFile[1]}".pdf
    oldFileName="${eachFile[0]}" 
    newFileName="${outDirPath}"/"${outFileName}""${eachFile[1]}".pdf
    
    echo mv "${oldFileName}" "${newFileName}"
    #mv "${eachFile[0]}" "${outDirPath}"/"${outFileName}""${eachFile[1]}".pdf
done

rm "${tempDataFile}"
