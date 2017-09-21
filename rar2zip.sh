#!/bin/bash

FILERAR=$1
BASEDIR=`pwd`
FILEPATH=`dirname "$FILERAR"`
FILENAMEFULL=`basename "$FILERAR"`
FILENAME="${FILENAMEFULL%.*}"
FILEEXT="${FILENAMEFULL##*.}"
TMPDIR=$FILENAME

if [ $FILEEXT == 'cbr' ]
then
    FILEZIPEXT='cbz'
else
    FILEZIPEXT='zip'
fi

FILEZIP="${BASEDIR}/${FILENAME}.$FILEZIPEXT"

dbusRef=`kdialog --title rar2zip --progressbar "Converting \"$FILERAR\" to ZIP\n\nplease wait" 10`
qdbus $dbusRef showCancelButton false

mkdir "$TMPDIR"

qdbus $dbusRef Set "" value 1

rar e "$FILERAR" "$TMPDIR"

qdbus $dbusRef Set "" value 4

cd "$TMPDIR"

zip -9 "$FILEZIP" *

qdbus $dbusRef Set "" value 9

cd "$BASEDIR"

rm -rf "$TMPDIR"

qdbus $dbusRef Set "" value 10

qdbus $dbusRef close

kdialog --title rar2zip --msgbox "Converting \"$FILERAR\" to ZIP\n\nDone\n\nCreated $FILEZIP"
