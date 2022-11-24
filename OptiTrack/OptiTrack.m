%% MARCADOR 5
 CrazyFlie = robotat_connect('192.168.50.200');
 pause(1);
 Q= robotat_get_pose(CrazyFlie,4,'quat')
 robotat_disconnect(CrazyFlie);
 quat = Q(:,4:7);
 
 posiciones = Q(:,1:3);
 [yaw,pitch,roll] = quat2angle(quat);
 
 posiciones7 = [Q(:,1:3)];
 posiciones7 = posiciones7;
 angulosdeg7 = [rad2deg(yaw);rad2deg(pitch);rad2deg(roll)];
 fprintf('el valor del optitrack es\n x = %1.2f \n y = %1.2f\n z = %1.2f',posiciones7(1,1),posiciones7(1,2),posiciones7(1,3));
 
