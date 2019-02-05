import numpy as np
import cv2
from PIL import Image, ImageDraw
from matplotlib import pyplot as plt
from skimage.io import imread
import time
import math
import sys
import ipdb
import pickle
from glob import glob


joints = ['nose','head','neck','RShoulder','RHand','Lshoulder','Lhand','hip','RKnee','RFoot','LKnee','Lfoot','tail']
data = pickle.load(open('background/results/experiment_1_4/sequence_1/hive_annotations.pkl','rb'))

colors = [ 
        (255, 255, 0),   # aqua
        (255, 0, 255),   # fuchsia
        (0, 0, 255),     # red
        (0, 255, 0),     # lime
        (226, 43, 138),  # blueviolet
        (0, 255, 255)    # yellow
        ]
joint_pairs = [ 
        ('nose','head'), 
        ('head','neck'),
        ('neck','RShoulder'),
        ('RShoulder','RHand'),
        ('neck','Lshoulder'),
        ('Lshoulder','Lhand'),
        ('neck','hip'),
        ('hip','RKnee'),
        ('RKnee','RFoot'),
        ('hip','LKnee'),
        ('LKnee','Lfoot'),
        ('hip','tail')
        ]

# frames = data.keys()
# frame = 22
# cam = 2
# cam_data = data[frame][cam]
# image = imread(glob('background/results/experiment_1_4/sequence_1/frame{}_*_cam{}_*jpg'.format(frame, cam))[0])
# image = cv2.cvtColor(image.astype(np.uint8), cv2.COLOR_RGB2BGR)
# 
# plt.figure()
# pt1 = cam_data['head']['coords'][::-1]  # (y,x) to (x,y)
# cv2.circle(image, pt1, 5, colors[0])
# 
# pt1 = cam_data['hip']['coords'][::-1]  # (y,x) to (x,y)
# cv2.circle(image, pt1, 5, colors[1])
# 
# pt1 = cam_data['tail']['coords'][::-1]  # (y,x) to (x,y)
# cv2.circle(image, pt1, 5, colors[2])
# 
# plt.imshow(image / 255.)
# plt.show()
# 
# sys.exit()
# 
# for j,(jt1,jt2) in enumerate(joint_pairs):
#     pt1 = cam_data[jt1]['coords'][::-1]  # (y,x) to (x,y)
#     pt2 = cam_data[jt2]['coords'][::-1]
#     # plt.figure()
#     # plt.imshow(image / 255.)
#     # plt.figure()
#     # plt.imshow(gt_heatmaps[:,:,joint_indexes[jt1]], cmap='hot', interpolation='nearest')
#     # plt.imshow(gt_heatmaps[:,:,joint_indexes[jt2]], cmap='hot', interpolation='nearest')
#     # plt.figure()
#     # plt.imshow(heatmap[:,:,joint_indexes[jt1]], cmap='hot', interpolation='nearest')
#     # plt.imshow(heatmap[:,:,joint_indexes[jt2]], cmap='hot', interpolation='nearest')
#     # plt.show()
#     cv2.line(image, pt1, pt2, colors[j % 6], 3)
#     # cv2.circle(image, pt1, 5, colors[j % 6])
#     # plt.imshow(image / 255.)
#     # plt.show()

# cv2.imwrite("background/results/experiment_1_4/sequence_1/hive_viz/image_{:07d}_{}.jpg".format(frame, cam), image)

frames = data.keys()
for frame in frames:
    for (cam, cam_data) in data[frame].items():
        # image = imread('background/cam{}/vid1/monkey_{:07d}.jpg'.format(cam, frame))
        image = imread('background/results/experiment_1_4/sequence_1/%s' % cam_data['fname'])
        image = cv2.cvtColor(image.astype(np.uint8), cv2.COLOR_RGB2BGR)
        for j,(jt1,jt2) in enumerate(joint_pairs):
            pt1 = cam_data[jt1]['coords'][::-1]  # (y,x) to (x,y)
            pt2 = cam_data[jt2]['coords'][::-1]
            # plt.figure()
            # plt.imshow(image / 255.)
            # plt.figure()
            # plt.imshow(gt_heatmaps[:,:,joint_indexes[jt1]], cmap='hot', interpolation='nearest')
            # plt.imshow(gt_heatmaps[:,:,joint_indexes[jt2]], cmap='hot', interpolation='nearest')
            # plt.figure()
            # plt.imshow(heatmap[:,:,joint_indexes[jt1]], cmap='hot', interpolation='nearest')
            # plt.imshow(heatmap[:,:,joint_indexes[jt2]], cmap='hot', interpolation='nearest')
            # plt.show()
            cv2.line(image, pt1, pt2, colors[j % 6], 3)
            # cv2.circle(image, pt1, 5, colors[j % 6])
            # plt.imshow(image / 255.)
            # plt.show()

        cv2.imwrite("background/results/experiment_1_4/sequence_1/hive_viz/%s" % cam_data['fname'], image)
