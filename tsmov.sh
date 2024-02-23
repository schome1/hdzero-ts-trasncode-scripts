#!/bin/zsh
for f in ./1-raw/*.(ts|TS)(.);
do 
    echo "////////////////////////////////////////////////////////////////////////////////";
    echo "////////////////////////////////////////////////////////////////////////////////";
    echo "FILE: $f";
    echo "";
    echo "CODEC INFO";
    
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
    echo "";

    # get the current date
    #currentDate=$(/bin/date +%F)
    currentDate=$(date '+%Y%m%d')
    echo "Current Date:  $currentDate";
    echo "";

    ((h=${duration}/3600));
    ((m=(${duration}%3600)/60));
    ((s=${duration}%60));

    printf -v runtime "%02dh%02dm%02ds" $h $m $s;
    newFileName="${f:r}-${currentDate}-${fps}fps-${width}x${height}-${vcodec}-${acodec}-${runtime}.mp4";
    if [[ $fps = 90 ]]; then
        echo "$fps fps - $vcoded/$acoded (lossy transcode) reducing frame rate from 90 fps to 60 fps to work with video editors...";
        echo "";

        if [[ $vcodec = "hevc" ]]; then
            # ./ffmpeg -y -i $f -vf fps=30 -c:a copy $newFileName; 
            ./ffmpeg -y -i $f -c:a copy -r 60 -tag:v hvc1 $newFileName;
            # upscale to 2k
            # ./ffmpeg -y -i $f -vf "scale=2560:1440:flags=bicubic" -c:a copy -r 60 $newFileName
        else
            ./ffmpeg -y -i $f -c:a copy -r 60 $newFileName;
        fi
    else
        echo "$fps pfs - $vcodec/$acodec lossless transcode...";
        if [[ $vcodec = "hevc" ]]; then
            # Need to specify the video codec because HEVC defaults to hvc3 (or something like that) and only hvc1 works on Mac.
            # Using -tag:v sets the type of hevc tag to use - this is a lossless conversion
            ./ffmpeg -y -i $f -c:v copy -c:a copy -tag:v hvc1 $newFileName;
        else
            # Lossless conversion to a new container (mp4/mov/etc)
            ./ffmpeg -y -i $f -c:v copy -c:a copy $newFileName;
        fi
    fi

    echo "";
    echo "////////////////////////////////////////////////////////////////////////////////";
    echo "";

done


# create the date folder
mkdir ./2-transcoded/$currentDate;

# copy mp4 files to the editing folder for the current date
mv ./1-raw/*.mp4 ./2-transcoded/$currentDate/;

mkdir ./2-transcoded/$currentDate/ts-files;
mv ./1-raw/*.(ts|TS)(.) ./2-transcoded/$currentDate/ts-files/;