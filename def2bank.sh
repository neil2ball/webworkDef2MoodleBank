#!/bin/bash

if (( $# != 6 ))
then
  printf "USAGE: $0 inputFileName.def moodleCourseName homeworkSetName moodleEngineName serverUrl webworkCourseName > outputFileName.xml\n"
  exit
fi

moodleCourseName=$2
homeworkSetName=$3
moodleEngineName=$4
serverUrl=$5
webworkCourseName=$6
counter=0

printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<quiz>
  <question type=\"category\">
    <category>
      <text>$moodleCourseName/set$homeworkSetName</text>
    </category>
  </question>"

while IFS= read -r line; do

  if [[ "$line" == *"source_file = "* ]]; then
  ((counter++))
  name=$(echo $line | awk '{ print substr($0, 15) }')

  input1=$(echo $name | sed -r 's/./\L&/')

  input2=$(echo $input1 | sed -e 's/\//__/g')

  probPath=$(echo $input2 | sed -e 's/-/___/g')

    if [[ "$counter" -lt 10 ]]; then
      printf "\n  <!-- question: 0$counter  -->
      <question type=\"opaque\">
        <name>
          <text>$name</text>
        </name>
        <questiontext format=\"moodle_auto_format\">
          <text></text>
        </questiontext>
        <generalfeedback format=\"moodle_auto_format\">
          <text></text>
        </generalfeedback>
        <defaultgrade>1.0000000</defaultgrade>
        <penalty>0.0000000</penalty>
        <hidden>0</hidden>
        <remoteid>$probPath</remoteid>
        <remoteversion>1.0</remoteversion>
        <engine>
          <name>
            <text>$moodleEngineName</text>
          </name>
          <passkey>
            <text></text>
          </passkey>
          <timeout>10</timeout>
          <qe>
            <text>$serverUrl/opaqueserver_wsdl</text>
          </qe>
          <qb>
            <text>$serverUrl/webwork2/$webworkCourseName</text>
          </qb>
        </engine>
        <tags>
          <tag>
            <text>ODE</text>
          </tag>
          <tag>
            <text>IC</text>
          </tag>
        </tags>
      </question>"

    else
      printf "\n  <!-- question: $counter  -->
      <question type=\"opaque\">
        <name>
          <text>$name</text>
        </name>
        <questiontext format=\"moodle_auto_format\">
          <text></text>
        </questiontext>
        <generalfeedback format=\"moodle_auto_format\">
          <text></text>
        </generalfeedback>
        <defaultgrade>1.0000000</defaultgrade>
        <penalty>0.0000000</penalty>
        <hidden>0</hidden>
        <remoteid>$probPath</remoteid>
        <remoteversion>1.0</remoteversion>
        <engine>
          <name>
            <text>$moodleEngineName</text>
          </name>
          <passkey>
            <text></text>
          </passkey>
          <timeout>10</timeout>
          <qe>
            <text>$serverUrl/opaqueserver_wsdl</text>
          </qe>
          <qb>
            <text>$serverUrl/webwork2/$webworkCourseName</text>
          </qb>
        </engine>
        <tags>
          <tag>
            <text>ODE</text>
          </tag>
          <tag>
            <text>IC</text>
          </tag>
        </tags>
      </question>"
    fi
  fi
done < $1

printf "</quiz>"
