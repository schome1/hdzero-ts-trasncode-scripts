#!/bin/zsh

# Check if a filename is provided as an argument
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Get the filename from the command-line argument
filename="$1"

# Check if the file exists
if [[ ! -f "$filename" ]]; then
    echo "File not found: $filename"
    exit 1
fi

echo "";
echo "////////////////////////////////////////////////////////////////////////////////";
echo "////////////////////////////////////////////////////////////////////////////////";
echo "File: $filename";
echo "";
echo "CODEC INFO";

eval $(./ffprobe -v quiet -show_format -of flat=s=_ -show_entries stream=codec_name,width,height,r_frame_rate,duration $filename);
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
echo "////////////////////////////////////////////////////////////////////////////////";
echo "";
