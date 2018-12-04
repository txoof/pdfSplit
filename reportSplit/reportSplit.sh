#!/bin/bash

version="0.21 180520.1420"

# Split large reportcard PDF containing multiple students using
# pdfgrep (installed via homebrew) and sejda-console (included)

# PDFs are split on:
# Student: FirstName SecondName NName LastName StudentID:000000
# see below for the posix regular expression

# Stop execution if any called commands exits with non-zero
#set -e
# location for PDF Grep
pdfGrep=/usr/local/bin/pdfgrep

# location for pdf-sam engine (sejda-console)
#sejdaCon="./sejda-console-3.2.29/bin/sejda-console"
sejdaCon="./sejda-console-3.2.50/bin/sejda-console"

# input pdf
inputPath="$1"
inputFileName=$(basename "${inputPath}")
inputDir=$(dirname "${inputPath}")

# output path
outFileName="${inputFileName%.*}"
# remove any spaces in output filename
outDir="${inputDir}"/split_"${outFileName// /_}"/

# regular expressions for searching for student records in pdf file

# match pages that contain StudentID: 123456
# matches any of the following:
# StudentID:123456
# StudentID: 123456
# Student ID:123456
# Student ID: 123456
studentRE="Student[[:space:]]{0,}ID:[[:digit:]]+"


# Posix regular expression for searching individual files for student name
# and student number
# matches:
# Student: William van Orange StudentID:000001
# Student:Martin Luther King Jr Student ID:000002
# Student:        Nelson Mandella      StudentID:       00000000005

studentDetailsRE="Student:[[:space:]]*([[:alpha:]]+.*[[:alpha:]]+)[[:space:]]*Student[[:space:]]*ID:[[:space:]]*([[:digit:]]+)"
###### File Checks
filesToCheck=($pdfGrep $sejdaCon)

echo "Version: $version"

# check for needed executables
for i in "${filesToCheck[@]}"
do
  if [ -x ${i} ]
  then
    :
    #echo "$i found and is executable"
  else
    echo "$i does not appear to be installed or is not executable"
    echo "please contact IT Support and provide this URL:"
    echo "https://github.com/txoof/pdfSplit/blob/master/README.md"
    echo "exiting."
  exit 1
  
  fi
done

# check for input file
if [ ! "${inputPath}" ] 
then
  echo "Please drag and drop a Report Card or Progress Report PDF into this window"
  echo ""
  echo "command line usage: $0 Report_to_split.pdf"
  exit 0
else
  if [ ! -r "${inputPath}" ] 
  then
    echo "$inputPath is not readable or does not exist."
    echo "exiting."
    exit 0
  fi
fi

echo "Searching ${inputPath} for student records"

#$pdfGrep -i -n $studentRE "${inputPath}" | sed -E 's/(^[0-9]+)(:.*)/\1/'
# search for pages containing the string "StudentID: 123456" and push only
# page number into array
pageArray=(`$pdfGrep -i -n $studentRE "${inputPath}" | sed -E 's/(^[0-9]+)(:.*)/\1/'`)

echo "Found ${#pageArray[@]} student records"

# build a list for sejda extract by - sejda needs the n-1 page number for 
# extraction
pageList=''


for i in "${pageArray[@]}"
do
  pageList="$pageList $(($i-1))"
done


if [  -d "${outDir}" ] 
then
  :
else
  if ! mkdir "${outDir}"
  then
    echo "failed to create $outDir for split files"
    echo "exiting"
    exit 1
  fi
fi

echo "Extracting records into ${outDir}"

# split the files based on the pageList
$sejdaCon splitbypages -f "${inputPath}" --overwrite --lenient -o "${outDir}" -n $pageList 

# check the exit status of sejda and bail out if it fails
if [ ! $? ] 
then
  echo "sejda-console failed to complete."
  echo "exiting."
  exit 1
fi

echo "Done extracting"

#studentDetailsRE="Student:[[:space:]]*([[:alpha:]]+)"

echo "Renaming extracted files"

for f in "${outDir}"/*.pdf
do
  result=`$pdfGrep -i ${studentDetailsRE} "${f}"`
  if [[ $result =~ $studentDetailsRE ]]
  then
    newName="${outDir}"${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-$(basename "${f}")
    echo "renaming: $f ---> $newName"
    if ! `mv "${f}"  "${newName}"`; 
    then
      echo "failed to rename $f"
    fi
  else
    echo "re not found"
  fi
done

echo "Finished"
