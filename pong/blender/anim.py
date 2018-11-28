import bpy
from scipy.io import loadmat

#https://blender.stackexchange.com/questions/16084/how-to-animate-object-with-data-file?lq=1

M_2_P_SCALE = 4;


ball_c = loadmat("ball.mat")
p1_c = loadmat("p1.mat")
p2_c = loadmat("p2.mat")

ball_x = (ball_c['BALL_COR'][0] / M_2_P_SCALE) - 15.
ball_y = (ball_c['BALL_COR'][1] / M_2_P_SCALE) - 10.

p1_x = p1_c['P1_COR'][0] / M_2_P_SCALE - 15.
p1_y = p1_c['P1_COR'][1] / M_2_P_SCALE - 10.

p2_x = p2_c['P2_COR'][0] / M_2_P_SCALE - 15.
p2_y = p2_c['P2_COR'][1] / M_2_P_SCALE - 10.

for t in range(500):

    print(bpy.data.scenes["Scene"].render.fps)


    # f = bpy.data.scenes["Scene"].render.fps * t + 1 # stub
    f = t


    obj = bpy.data.objects["ball"] # stub
    obj.location = [ball_x[t],-10,ball_y[t]]
    obj.keyframe_insert(data_path="location", frame=f)


    obj = bpy.data.objects["p1"] # stub
    obj.location = [p1_x[t],-10,p1_y[t]]
    obj.keyframe_insert(data_path="location", frame=f)

    obj = bpy.data.objects["p2"] # stub
    obj.location = [p2_x[t],-10,p2_y[t]]
    obj.keyframe_insert(data_path="location", frame=f)

for fc in obj.animation_data.action.fcurves: # stub
    for kp in fc.keyframe_points:
        kp.handle_left_type = 'VECTOR'
        kp.handle_right_type = 'VECTOR'
    fc.update()
