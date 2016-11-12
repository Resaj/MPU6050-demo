%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Este programa calcula la velocidad y la posición de un dispositivo a
% partir de sus aceleraciones en los ejes x e y, obtenidas en una matriz
% bidimensional de 2 columnas (x,y), con un periodo de muestreo de dt[seg].
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Rubén Espino San José <ruben@ieeeuah.org>
% Rama de Estudiante de IEEE de la Universidad de Alcalá
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = fopen('cuadrado.txt');
A = textscan(f,'%f,%f','headerlines',1);
A = cell2mat(A);
fclose(f);

dt = 0.005;
[m,n] = size(A);

t = dt:dt:m*dt;

%% Cálculo y representación de la aceleración

figure(1);
subplot(2,2,1);
plot(t,A(:,1),'b',t,A(:,2),'r');
title('Aceleración x e y sin filtrar');
xlabel('Tiempo [seg]');
ylabel('Aceleración [cm/s^2]');
legend('Eje X','Eje Y')

A_sm = zeros(size(A));
A_sm(:,1) = smooth(A(:,1));
A_sm(:,2) = smooth(A(:,2));

filtLow = 5;
filtHigh = 50;
Fs = 1000;
[b, a] = butter(1, [filtLow/(Fs/2), filtHigh/(Fs/2)]);
acel_xy = zeros(size(A));
acel_xy(:,1) = filtfilt(b, a, A_sm(:,1));
acel_xy(:,2) = filtfilt(b, a, A_sm(:,2));

%figure(2);
subplot(2,2,2);
plot(t,acel_xy(:,1),'b',t,acel_xy(:,2),'r');
title('Aceleración x e y');
xlabel('Tiempo [seg]');
ylabel('Aceleración [cm/s^2]');
legend('Eje X','Eje Y')

%% Cálculo y representación de la velocidad

vel_xy = zeros(m,n);
for k = 1:m-1
    vel_xy(k+1,1) = (vel_xy(k,1) + acel_xy(k+1,1));
    vel_xy(k+1,2) = (vel_xy(k,2) + acel_xy(k+1,2));
end
vel_xy = vel_xy*dt;

filtLow = 2;
filtHigh = 40;
Fs = 1000;
[b, a] = butter(1, [filtLow/(Fs/2), filtHigh/(Fs/2)]);
vel_xy(:,1) = filtfilt(b, a, vel_xy(:,1));
vel_xy(:,2) = filtfilt(b, a, vel_xy(:,2));

%figure(3);
subplot(2,2,3);
plot(t,vel_xy(:,1),'b',t,vel_xy(:,2),'r');
title('Velocidad x e y');
xlabel('Tiempo [seg]');
ylabel('Velocidad [cm/s]');
legend('Eje X','Eje Y')

%% Cálculo y representación de la posición

pos_xy = zeros(m,n);
for k = 1:m-1
    pos_xy(k+1,:) = (pos_xy(k,:)+vel_xy(k+1,:));
end
pos_xy = pos_xy*dt;

filtLow = 0.5;
filtHigh = 50;
Fs = 1000;
[b, a] = butter(1, [filtLow/(Fs/2), filtHigh/(Fs/2)]);
pos_xy(:,1) = filtfilt(b, a, pos_xy(:,1));
pos_xy(:,2) = filtfilt(b, a, pos_xy(:,2));

%figure(4);
subplot(2,2,4);
plot(t,pos_xy(:,1),'b',t,pos_xy(:,2),'r');
title('Posición x e y');
xlabel('Tiempo [seg]');
ylabel('Posición [cm]');
legend('Eje X','Eje Y')

%% Representación de la posición en el plano XY

figure(2);
plot(pos_xy(:,1),pos_xy(:,2));
title('Posición XY');
xlabel('Posición X [cm]');
ylabel('Posición Y [cm]');
