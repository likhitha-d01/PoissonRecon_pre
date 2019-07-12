load('cap4.txt');
ptCloud = pointCloud(cap4);
normals = pcnormals(ptCloud);
ptCloud = pointCloud(cap4,'Normal',normals);
pcwrite(ptCloud,'cap4_mat.ply','Encoding','binary');
pcshow(ptCloud)
figure
pcshow(ptCloud)
title('Estimated Normals of Point Cloud')
hold on

x = ptCloud.Location(:,1);
y = ptCloud.Location(:,2);
z = ptCloud.Location(:,3);

u = normals(:,1);
v = normals(:,2);
w = normals(:,3);

quiver3(x,y,z,u,v,w);
hold off
pause;

sensorCenter = mean(ptCloud.Location); 
for k = 1 : numel(x)
   p1 = sensorCenter - [x(k),y(k),z(k)];
   p2 = [u(k),v(k),w(k)];
   % Flip the normal vector if it is not pointing towards the sensor.
   angle = atan2(norm(cross(p1,p2)),p1*p2');
   if angle > pi/2 || angle < -pi/2
       u(k) = -u(k);
       v(k) = -v(k);
       w(k) = -w(k);
   end
end

figure
pcshow(ptCloud)
title('Adjusted Normals of Point Cloud')
hold on
quiver3(x, y, z, u, v, w);
hold off

normals = [u,v,w];
ptCloud = pointCloud(cap4,'Normal',normals);
pcwrite(ptCloud,'cap4_mat.ply','Encoding','binary');
