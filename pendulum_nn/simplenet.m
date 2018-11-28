
function net = simplenet()

hiddenLayerSize = 3;

net = network(3,hiddenLayerSize);

net.inputConnect=[1 1 1;0 0 0;0 0 0];
net.inputs{1}.size=1;
net.inputs{2}.size=1;
net.inputs{3}.size=1;
net.layerConnect=[0 0 0;1 0 0;0 1 0];
net.layers{1}.size=3;
net.layers{2}.size=4;
net.layers{3}.size=1;
net.outputConnect=[0 0 1];

wb = getwb(net);
for x = 1:length(wb)
   init(x) = 0.01 * randn();
end

net = setwb(net, init);

% % View the Network
% view(net)
% display(net)
% wb = getwb(net);


end

