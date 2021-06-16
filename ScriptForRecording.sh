#!/bin/basho
#	Written by BearShire on 2021-06-15
#	Argument in format "HH:MM:SS"

LocalUsr=$(whoami)
Fpath="/home/$LocalUsr/Desktop/recorderScr"
L="$Fpath/LogFile"
echo ----------------------------------------------- >>$L
echo "Script Init" >>$L
export XDG_RUNTIME_DIR="/run/user/1000"
d=$(date "+%Y-%m-%d %H:%M:%S")
fname="recording $d.avi"

TimeToRec=$1

if [ -z "$1" ]
  then
    echo "No argument supplied. Setting default time" >>$L
    TimeToRec="00:04:00"
fi

InputADev="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"
DefNam="recording.avi"
echo "Recording started on $d by $LocalUsr"  >>$L
echo "Recording time set to $TimeToRec (HH:MM:SS)" >>$L
ffmpeg -use_wallclock_as_timestamps 1 -thread_queue_size 512 -loglevel error -f pulse -ac 2 -ar 48000 -i $InputADev -f x11grab -y  -r 30 -s 1366x768 -i :0.0+0,0 -vcodec libx264 -preset veryfast -crf 18 -acodec libmp3lame -q:a 1 -pix_fmt yuv420p  -t $TimeToRec $Fpath/$DefNam
echo Recording ended >>$L
mv "$Fpath/recording.avi" "$Fpath/$fname" >>$L
echo "Renamed file from $DefNam to $fname" >>$L
echo ----------------------------------------------- >>$L
echo >> $L

