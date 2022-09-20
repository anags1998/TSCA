function constelacion = constelacion_8pfm()
theta = [0 -3 0 -1 0 1 0 3];
theta2 = [1 0 3 0 -3 0 -1 0];
constelacion1 = [theta2*sin(pi/2)'];
constelacion2 = theta*sin(pi/2)';
plot(constelacion1,constelacion2,"LineStyle","none","Marker","*")
constelacion = [constelacion1' constelacion2'];