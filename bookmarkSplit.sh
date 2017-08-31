#!/bin/bash
# stop execution if any called command exits with non zero
set -e

#./sejda-console-3.2.22/bin/sejda-console splitbybookmarks -l 1 -f RCG1_Q4_2016-2017.pdf -o ./split/


#./sejda-console-3.2.22/bin/sejda-console splitbybookmarks -l 1 -f $1 -o ./split/
# grab the first commandline argument (dropped via platypus)
droppedFile=$1

if [ ! "$droppedFile" ]
  then
    printf "usage: $0 /path/to/input/file.pdf"
    exit 0
fi

echo Splitting and renaming file: $droppedFile
filePath=`echo $droppedFile | sed -E 's/(^\/.*\/|^\..*\/)(.*)/\1/'`
fileName=`echo $droppedFile | sed -E 's/(^\/.*\/|^\..*\/)(.*)/\2/'`
# set the path for outputting files
splitPath=split_files-`date +"%Y-%m-%d_%H%M"`

# check that the dropped file is readable
if [  ! -r "$droppedFile" ]
  then
    printf "$droppedFile does not exist or is unreadable!\n"
    printf "exiting\n"
    exit 2
fi

printf "Split files will be stored at: $filePath/$splitPath\n"

# check that the output base path is writable
if [ ! -w "$filePath" ]
  then
    printf "folder: $filePath does not appear to be writeable\nexiting"
    exit 2
elif [ ! -d $filePath/$splitPath ]
  then
    # create the output path for the split files
    mkdir $filePath/$splitPath
fi

# split the pdf based on the bookmarks 
./sejda-console-3.2.22/bin/sejda-console splitbybookmarks -l 1 -f "$droppedFile" -o "$filePath/$splitPath"

# pdf grep each file and extract the filename, student name, studenet number
# pdfgrep can use shortcut tokens
# bsd sed can't deal with shortcut tokens
# store each entry in an array in the format: /path/single.pdf:newfilename.pdf
myArray=(`./pdfgrep -P "Student: .*StudentID:(\d)+" $filePath$splitPath/*.pdf  | sed -E 's/(.*\/)(.*\.pdf)(: {0,}Student: {0,})([A-Za-z']+.*[A-Za-z']+)( {1,}StudentID:)([0-9]+)/\1\2:\4-\6/' |sed 's/ /_/g'`)

# recurse array
for i in ${myArray[@]}
  do
    :
    # extract the existing filename and the new filname
    oldFilename=`echo $i | cut -d':' -f1`
    newFilename=`echo $i | cut -d':' -f2`.pdf
    # rename (move) the file
    if [ -r $oldFilename ] 
      then
        echo mv $oldFilename $filePath$splitPath/$fileName_$newFilename
    else
      printf "could not rename $oldFilename\n"

    fi
done

printf "Done!"
