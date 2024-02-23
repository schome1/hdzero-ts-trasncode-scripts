# hdzero-ts-trasncode-scripts

## tsmov.sh
tsmove.sh will iterate through all .ts files in a folder and evaluate how to transcode it.

- If you have a 90 fps .ts video, it will transcode it to 60 fps (this is lossy, but allows it to work with many video editors).
- For other frame rates, the audio and video streams are copied as they exist in the .ts file and moved to a .mp4 container file.

- Since this was written for Mac users, if a .ts video file usees the hevc (h265) codec, a tag of "tag:v hvc1" needs to be used so the video can be viewed on the Mac.

Use the following command to make the script executable.

chmod +x myscript.sh

## tsrn.sh
tsrn.sh will iterate through all .ts files in a folder and rename them with more data as follows.

hdz_000.ts will be renamed to hdz_000-20240222-60fps-1280x720-hevc-aac-00h02m50s.ts, which includes the current date, video frame rate, video horizontal and vertical size, video format, audio format, and video duration.  Note that this rename is also done in the tsmov.sh script, so only use this script if you want to rename the .ts file.

## vidinf.sh
vidinf.sh allows you to send a filename as a parameter.  The script will evaluate the file and show information about the video file.

# Default Folder Structure
The scripts are setup to parse files in the following folder structure.

hdzero
- 1-raw (this is where the .ts files should be copied to)
- 2-transcoded
  - <yyyymmdd> (this is where the transcoded video files will be copied to)
    - ts-files (this is where the original .ts files will be backed up to after being transcoded)

ffmpeg and ffprobe will also need to be installed on the Mac, or dropped directly into the hdzero folder or the scripts will not work.

feel free to modify the scripts as needed to make them work for your needs.
