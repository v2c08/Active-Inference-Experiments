figure
subplot(3,1,1)
plot(DEM.pU.v{1}(1,:),'m')
title('Observed cause (Y) 1...DEM.pU.v{1} ')
subplot(3,1,2)
plot(DEM.pU.v{1}(2,:),'r')
title('Observed cause  Y2 ')
subplot(3,1,3)
plot(DEM.pU.v{1}(3,:),'b')
title('Observed cause Y3')


figure
subplot(3,1,1)
plot(DEM.pU.x{1}(1,:),'m')
title('Observed state x1 ')
subplot(3,1,2)
plot(DEM.pU.x{1}(2,:),'r')
title('Observed state  x2 ')
subplot(3,1,3)
plot(DEM.pU.x{1}(3,:),'b')
title('Observed state x3 (DEM.pU.x{1}(1,:)')
 


figure
subplot(4,1,1)
plot(DEM.qU.x{1}(1,:),'m')
title('Estimated cause (same as state) qU.v1 ')
subplot(4,1,2)
plot(DEM.qU.x{1}(2,:),'r')
title('Estimated cause qU.v2 ')
subplot(4,1,3)
plot(DEM.qU.x{1}(3,:),'b')
title('Estimated cause qU.v3  ')
subplot(4,1,4)
plot(DEM.qU.a{2} ,'g')
title('Applied Action ')
 