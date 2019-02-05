import os, sys, shutil, pickle
from glob import glob
import numpy as np


def prepare_frame_extraction(data_dir, start_time, end_time, start_number, use_bmp=False, scale=False, frame_rate=1):
    data = get_sync_data(data_dir)
    offsets = data['offsets']

    # Offset for naming
    # start_number = max(int(fname.split('/')[-1][7:-4]) for fname in glob('background/cam2/vid1/monkey_*jpg')) + 1
    f = open('extract_{}.sh'.format(start_number),'w')

    # cams = offsets.keys()
    cams = [2,4,6,10,12,14,15,18,20,22,23,25,27,29,30,33]
    for i in cams:
        # infile = glob("{}/{}/image/GOPR*".format(data_dir,i))[0]
        infile = "{}/{}/image/combined.MP4".format(data_dir,i)
        outdir = "background/cam{}/vid1".format(i)
        if not os.path.exists(outdir):
            os.makedirs(outdir)
        fmt = 'bmp' if use_bmp else 'jpg'
        scale_flag = "-s 1280x720" if scale else ""
        extract_cmd = "ffmpeg -ss {} -i {} {} -t {} -start_number {} -r {} {}/monkey_%07d.{}".format(start_time + offsets[i], infile, scale_flag, end_time-start_time, start_number, frame_rate, outdir, fmt)
        print(extract_cmd, file=f)
    f.close()


def get_sync_data(data_dir):
    data = pickle.load(open('{}/sync.pkl'.format(data_dir),'rb'))
    return data


if __name__ == '__main__':
    # if len(sys.argv) < 4:
    #     print('Please specify data directory & start/end time for base camera (offset 0).')
    #     sys.exit()
    data_dir = sys.argv[1]
    # start_time = int(sys.argv[2])
    # end_time = int(sys.argv[3])
    # if len(sys.argv) == 5:
    #     prepare_frame_extraction(data_dir, start_time, end_time, frame_rate=int(sys.argv[4]))
    # else:
    #     prepare_frame_extraction(data_dir, start_time, end_time)

    pairs = [
              (910,925,1),
              (925,932,3),
              (932,975,1),
              (975,989,3),
              (989,1003,1),
              (1003,1025,3),
              (1025,1049,1),
              (1049,1063,3),
              (1063,1110,1),
              (1110,1120,3),
              (1120,1150,1),
              (1150,1164,3),
              (1164,1192,1),
              (1192,1200,3),
              (1200,1231,1),
              (1231,1240,3),
              (1240,1270,1)
            ]
    start_number = 301
    for (st,et,rt) in pairs:
        prepare_frame_extraction(data_dir, st, et, start_number, frame_rate=rt)
        start_number += (et-st) * rt
