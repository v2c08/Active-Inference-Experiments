# Bipedal walker implementation - single level using ADEM

Here we demonstrate that the parameters (randomly selected height, mass, inertia, gravity) can be learned. I still haven't been able to produce goal-directed action i.e walking. This effictively means that the agent is able to correctly predict the trajectory of hidden states while falling down (it knows it's falling but it's fine with that so doesn't try to walk). Getting the agent to walk will require more thought and a more distinct seperation between the generative and recognition models. 

Running the script from aigym without any arguments provides an example agent that walks successfuly. Data was captured from this simulation and used as a prior over hidden states (C). 

You may want to look at the openai wiki & implementation for a description of the true state space.
https://github.com/openai/gym/wiki/BipedalWalker-v2
https://github.com/openai/gym/blob/master/gym/envs/box2d/bipedal_walker.py

Entry point is 'main.py'.


