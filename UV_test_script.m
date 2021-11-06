clc; clear; close all;

mu = 1.327124e20 * (1e-3)^3; % km^3/s^2 (sun)

date1 = mjuliandate('30-Jul-2020','dd-mm-yyyy');
date2 = mjuliandate('18-Feb-2021','dd-mm-yyyy');
planet1 = 'Earth';
planet2 = 'Mars';
dates_day = linspace(date1,date2,10000);
dates_sec = dates_day * 86400;

[p1,v1] = OrbitPropogator(dates_sec,planet1);
[p3,v3] = OrbitPropogator(dates_sec,planet2);
% [p2,v2] = planetEphemeris(dates','Sun',planet1);

X = [p1(:,1) p3(:,1)];
Y = [p1(:,2) p3(:,2)];
Z = [p1(:,3) p3(:,3)];

figure(1)
plot3(X,Y,Z,'.')
hold on
plot3(0,0,0,'x')
plot3(X(1,:),Y(1,:),Z(1,:),'+')
xlim(1e8*[-4 4])
ylim(1e8*[-4 4])
zlim(1e8*[-4 4])
xlabel('x')
ylabel('y')
zlabel('z')
grid

%%
clc; clear; close all

jd = juliandate('2-Jan-2021','dd-mm-yyyy');
[p,v] = OrbitPropogator(jd,'Earth');