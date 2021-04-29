clear
close all

%%
%Cargamos el fichero . wav y creamos un fichero con el formato necesario.

[data, fs] = audioread('haha.wav');
file = fopen('sample_in.dat','w');
%data = [zeros(6000, 1); 1; zeros(5056, 1)];
fprintf(file, '%d\n', round(data.*127));

%%
%Utilizamos la funcion filter para saber la respuesta del filtro real.

%Filtro Paso Bajo

test_lp = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data);
sound(test_lp);

%Filtro Paso Alto

test_hp = filter([-0.0078, -0.2031, 0.6015, -0.2031, -0.0078],[1, 0, 0, 0, 0], data);
sound(test_hp);

%%
%Salida del testbench vhdl.

%Filtro Paso Bajo

vhdl_lp=load('sample_out_lp.dat')/127;
sound(vhdl_lp);

%Filtro Paso Alto

vhdl_hp=load('sample_out_hp.dat')/127;
sound(vhdl_hp);

%%
% Truncarcamos las señales filtradas por la aplicacion matlab.
% Muestras en sample_out_lp y sample_out_hp 11057

cambio_matlab_lp = test_lp(1:11056);
cambio_matlab_hp = test_hp(1:11056);

% Eliminamos la primera muestra de la señal de nuestro test.
% Muestras en sample_out_lp y sample_out_hp 11057

cambio_vhdl_lp = vhdl_lp(2:11057);
cambio_vhdl_hp = vhdl_hp(2:11057);

resta_lp = cambio_matlab_lp - cambio_vhdl_lp;
resta_hp = cambio_matlab_hp - cambio_vhdl_hp;

figure
plot(resta_lp,'r'); title('Error FPB');
figure
plot(resta_hp,'r'); title('Error FPA');

figure
plot(cambio_matlab_lp,'g'); title('FPB en matlab');
figure
plot(cambio_matlab_hp,'g'); title('FPA en matlab');

figure
plot(cambio_vhdl_lp,'b'); title('FPB en vhdl');
figure
plot(cambio_vhdl_hp,'b'); title('FPA en vhdl');
