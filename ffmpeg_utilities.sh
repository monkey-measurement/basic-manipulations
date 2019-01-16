# splice video / get video segment at 7 minutes, 40 seconds for a minute
ffmpeg -ss 00:07:40 -i infile.mp4 -t 00:01:00 -vcodec copy outfile.mp4

# extract image frames from 1 minute onwards for 10 secs @ 30 fps, with outfile pattern being out00001.jpg and so on
ffmpeg -ss 00:01:00 -i infile.mp4 -t 10 -r 30 out%05d.jpg

# combine frames to make video
# 1. from number-based input pattern
ffmpeg -framerate 60 -i cam5_filtered_%03d.jpg -c:v libx264 -pix_fmt yuv420p filtered.mp4
# 2. from glob pattern
ffmpeg -framerate 60 -pattern_type glob -i 'cam5_filtered_*.jpg' -c:v libx264 -pix_fmt yuv420p filtered.mp4

# scaling parameter : -s WxH
