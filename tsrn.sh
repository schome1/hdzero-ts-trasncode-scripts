#!/bin/zsh

for f in ./1-raw/*.ts;
do 
    echo "-----"
    echo "File: $f"
    echo "-----"
    
    eval $(./ffprobe -v quiet -show_format -of flat=s=_ -show_entries stream=codec_name,width,height,r_frame_rate,duration $f);
    vcodec=${streams_stream_0_codec_name};
    width=${streams_stream_0_width};
    height=${streams_stream_0_height};
    fps=$((${streams_stream_0_r_frame_rate}));
    duration=${streams_stream_0_duration};
    acodec=${streams_stream_1_codec_name};
    echo "Video Codec:   $vcodec";
    echo "Width:         $width";
    echo "Height:        $height";
    echo "Frames/Second: $fps";
    echo "Duration:      $duration";
    echo "Audio Codec:   $acodec";

    # get the current date
    #currentDate=$(/bin/date +%F)
    currentDate=$(date '+%Y%m%d')
    echo "Current Date:  $currentDate";

    ((h=${duration}/3600))
    ((m=(${duration}%3600)/60))
    ((s=${duration}%60))

    printf -v runtime "%02dh%02dm%02ds" $h $m $s
    newFileName="${f:r}-${currentDate}-${fps}fps-${width}x${height}-${vcodec}-${acodec}-${runtime}.ts";

    # copy mp4 files to the editing folder for the current date
    mv $f $newFileName
done

