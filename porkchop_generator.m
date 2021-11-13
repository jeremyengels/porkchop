clc; clear; close all;

% 2020 window
departure_1 = '1-Jan-2011';
departure_2 = '1-Jan-2030';
arrival_1 = '1-Mar-2011';
arrival_2 = '1-Mar-2030';

% departure_1 = '1-Jan-2020';
% departure_2 = '1-Jul-2020';
% arrival_1 = '1-Nov-2020';
% arrival_2 = '24-Jan-2022';
% 
% % 2018 window
% departure_1 = '12-Sep-2017';
% departure_2 = '17-Oct-2018';
% arrival_1 = '1-Mar-2018';
% arrival_2 = '10-Jan-2020';

%% M2020: depart 30-Jul-2020 arrive 18-Feb-2021
departure_m2020 = '25-Jul-2020';
arrival_m2020 = '15-Feb-2021';

departure_m2020 = '30-Jul-2020';
arrival_m2020 = '18-Feb-2021';

% departure_m2020 = '20-May-2018';
% arrival_m2020 = '6-Dec-2018';

jd_departure_1 = juliandate(departure_1,'dd-mm-yyyy');
jd_departure_2 = juliandate(departure_2,'dd-mm-yyyy');
jd_arrival_1 = juliandate(arrival_1,'dd-mm-yyyy');
jd_arrival_2 = juliandate(arrival_2,'dd-mm-yyyy');

jd_departure_m2020 = juliandate(departure_m2020,'dd-mm-yyyy');
jd_arrival_m2020 = juliandate(arrival_m2020,'dd-mm-yyyy');

%%
N_departure_dates = 500;
N_arrival_dates = 500;
departure_dates = linspace(jd_departure_1,jd_departure_2,N_departure_dates);
arrival_dates = linspace(jd_arrival_1,jd_arrival_2,N_arrival_dates);

% initialize arrays
DV_depart_short = zeros(N_arrival_dates,N_departure_dates);
DV_depart_long = zeros(N_arrival_dates,N_departure_dates);
DV_arrive_short = zeros(N_arrival_dates,N_departure_dates);
DV_arrive_long = zeros(N_arrival_dates,N_departure_dates);

% departure planet
planet1 = 'Earth';

% arrival planet
planet2 = 'Mars';

% initialize data matrices
DV_depart = zeros(N_arrival_dates,N_departure_dates,2);
DV_arrive = zeros(N_arrival_dates,N_departure_dates,2);
DT = zeros(N_arrival_dates,N_departure_dates);

for j = 1:N_departure_dates
    for i = 1:N_arrival_dates
        
        % calculate transfer at (i,j) transfer
        [DV_depart(i,j,1),DV_arrive(i,j,1)] = ...
            interplanetary_transfer(departure_dates(j),...
            arrival_dates(i),planet1,planet2,1);
        [DV_depart(i,j,2),DV_arrive(i,j,2)] = ...
            interplanetary_transfer(departure_dates(j),...
            arrival_dates(i),planet1,planet2,-1);
        
        % populate transfer time matrix
        DT(i,j) = arrival_dates(i) - departure_dates(j);
        
        % progress updates
        num_complete = N_arrival_dates*(j-1) + i;
        num_total = N_arrival_dates * N_departure_dates;
        clc;
        fprintf('Progress: %.1f%% \n',100*num_complete/num_total);
    end
end

disp('CALCULATION COMPLETE');


%% REMOVE NEGATIVE TIME TRANSFERS
for j = 1:N_departure_dates
    for i = 1:N_arrival_dates
        
        if departure_dates(j) > arrival_dates(i)
            DV_depart(i,j,:) = 10000 * ones(1,1,2);
            DV_arrive(i,j,:) = 10000 * ones(1,1,2);
        end
    end
end


%% PLOTTING
plotdefaults(16,14,2);

X = datenum(datetime(departure_dates,'convertfrom','juliandate'));
Y = datenum(datetime(arrival_dates,'convertfrom','juliandate'));
Z = min(DV_depart + DV_arrive,[],3);
V = linspace(0,15,100);

% plot total Delta-V porkchop plot
figure(1)
contour(X,Y,Z,V);
hold on
% plot(datenum(datetime(jd_departure_m2020,'convertfrom','juliandate')),...
%     datenum(datetime(jd_arrival_m2020,'convertfrom','juliandate')),'k+')
colormap(jet);
hold off

% colorbar
cb = colorbar;
cb.Title.String ='Total $\Delta V$ [km/s]';
cb.Title.Interpreter = 'latex';
set(cb,'ticklabelinterpreter','latex');

% date ticks
set(gca,'ytick',linspace(min(Y),max(Y),7))
set(gca,'xtick',linspace(min(X),max(X),5))
datetick('x',2,'keeplimits','keepticks')
datetick('y',2,'keeplimits','keepticks')

% labels
xlabel('Departure Date')
ylabel('Arrival Date')
% legend('Total $\Delta V$ Contour','NASA Mars 2020 Mission','location','northwest')
title('Earth to Mars 2020 Launch Window')

% save figure
% saveas(gca,'porkchop_plot.pdf')
% exportgraphics(gcf,'porkchop.jpg','resolution','500')

%% plot separate contour plots
Z1 = min(DV_depart,[],3);
Z2 = min(DV_arrive,[],3);
V1 = linspace(0,10,8);
V2 = linspace(0,10,8);
V3 = linspace(min(DT,[],'all'),max(DT,[],'all'),10);
plotdefaults(16,14,3);


figure(2)
[C1,h1] = contour(X,Y,Z1,V1,'r');
hold on
[C2,h2] = contour(X,Y,Z2,V2,'b');
% [C3,h3] = contour(X,Y,DT,V3,'k');
hold off

clabel(C1,h1,'interpreter','latex','fontsize',8)
clabel(C2,h2,'interpreter','latex','fontsize',8)
% clabel(C3,h3,'interpreter','latex','fontsize',14)


% date ticks
set(gca,'ytick',linspace(min(Y),max(Y),7))
set(gca,'xtick',linspace(min(X),max(X),5))
datetick('x',2,'keeplimits','keepticks')
datetick('y',2,'keeplimits','keepticks')

% labels
xlabel('Departure Date')
ylabel('Arrival Date')
legend('Departure $\Delta V$ [km/s]','Arrival $\Delta V$ [km/s]','location','northwest')
title('Earth to Mars 2020 Launch Window')

% exportgraphics(gca,'porkchop_separate.jpg','resolution','500')