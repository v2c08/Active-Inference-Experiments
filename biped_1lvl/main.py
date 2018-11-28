# TODO
# 1. Incorporate leg contact in bottom level dynamics
# 2. Mix top level (hull vars) with a * x *
# 3. Seperate params per level  - fps, scale in top, hip/knee speeds in bottom

import matlab.engine
import scipy.io
import numpy as np
import gym
import matlab.engine
import time
import random

ml = matlab.engine.start_matlab()

env = gym.make('BipedalWalker-v2')
observation = env.reset()

observations = []
nT = 100
r_trials = 20
g_trials  = 20
walk_trials = 128
done = False
observations = []



x_ind  = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
x1_ind = [4,5,6,7,9,10,11,12]
x2_ind = [0, 1, 2, 3]
v_ind  = [5,7,10,12]
x_s    = []
x1_s   = []
x2_s   = []
v_s    = []
a_s    = []

print "Initialising..."
# Initialise DEM
noise = [item for sublist in abs(0.08*np.random.rand(4,1)) for item in sublist]
for n in range(nT):
    env.render()
    a = random.randint(0,3)
    action = [0] * 4
    action[a] = random.random()
    observation, reward, done, info = env.step(action)
    x  = [observation[i] for i in x_ind]
    v  = [observation[i] for i in v_ind]
    x1 = [observation[i] for i in x1_ind]
    x2 = [observation[i] for i in x2_ind]
    x_s.append(x)
    x1_s.append(x1)
    x2_s.append(x2)
    v_s.append(v)
    a_s.append(action)

x_s   = [item for sublist in x_s  for item in sublist]
x1_s  = [item for sublist in x1_s for item in sublist]
x2_s  = [item for sublist in x2_s for item in sublist]
v_s   = [item for sublist in v_s  for item in sublist]
a_s   = [item for sublist in a_s  for item in sublist]

ml.init_bipedal_dem(matlab.double([x_s]),          matlab.double([v_s]),
                    matlab.double([a_s]),          matlab.double([len(x_ind)]),
                    matlab.double([len(v_ind)]),   matlab.double([4]),
                    matlab.double([nT]),           matlab.double([noise]), matlab.double([x1_s]),
                    matlab.double([x2_s]),         nargout=0)
print "DEM Initialised"

# #scipy.io.savemat('real_data.mat', mdict={'x':causes, 'v':inputs, 'a':actions})
#
# # inner loop - single step - no lookahead -=- nT = 1
# #  outer look n + t lookahead             -=- nT = nT
# print "Optimising R Model"
#
# x_s   = []
# v_s   = []
# a_s   = []
# # Optomise Recognition Model (no real power for randomization here without a)
# for a in range(4):
#     for trial in range(r_trials):
#         print " Iteration {} of {}".format(trial+1, r_trials)
#         causes  = []
#         inputs  = []
#         actions = []
#         x_s     = []
#         v_s   = []
#         a_s   = []
#         observation = env.reset()
#         for n in range(nT):
#             #env.render()
#             action = [0] * 4
#             action[a] = random.random()
#             observation, reward, done, info = env.step([q + p for q, p in zip(action, noise)])
#             x = [observation[i] for i in x_ind]
#             v  = [observation[i] for i in v_ind]
#             x_s.append(x)
#             v_s.append(v)
#             a_s.append(action)
#
#         x_s   = [item for sublist in x_s for item in sublist]
#         v_s   = [item for sublist in v_s for item in sublist]
#         a_s   = [item for sublist in a_s for item in sublist]
#
#         ml.update_bipedal_dem_R(matlab.double([x_s]),          matlab.double([v_s]),
#                                 matlab.double([a_s]),          matlab.double([len(x_ind)]),
#                                 matlab.double([len(v_ind)]),   matlab.double([4]),
#                                 matlab.double([nT]),           matlab.double([noise]), nargout=0)
#
# print "R Model Optimised"


print "Optimising G Model"
# Jesus take the wheel
x_s   = []
v_s   = []
a_s   = []
observation = env.reset()
action = env.action_space.sample().tolist()
loop = 0
while True:
    loop += 1
    observation = env.reset()
    for vvvv in range(100/ 5):
        print " Iteration{}-{} of inf".format(loop, vvvv)
        x_s     = []
        x1_s    = []
        x2_s    = []
        v_s     = []
        a_s     = []
        for n in range(nT):
            env.render()
            observation, reward, done, info = env.step(action)
            x = [observation[i] for i in x_ind]
            v  = [observation[i] for i in v_ind]
            x1 = [observation[i] for i in x1_ind]
            x2 = [observation[i] for i in x2_ind]
            x_s.append(x)
            x1_s.append(x1)
            x2_s.append(x2)
            v_s.append(v)
            a_s.append(action)

        action = ml.bipedal_action(matlab.double([x_s]),          matlab.double([v_s]),
                               matlab.double([a_s]),          matlab.double([len(x_ind)]),
                               matlab.double([len(v_ind)]),   matlab.double([4]),
                               matlab.double([nT]),           matlab.double([noise]),
                               matlab.double([x1_s]),         matlab.double([x2_s]), nargout=1)
        action  =  [item for sublist in action for item in sublist]
print "Done. Don't re-run before backing up bipedal_dem.mat"

#scipy.io.savemat('{}_n.mat'.format(nT), mdict={'obs':observations})
