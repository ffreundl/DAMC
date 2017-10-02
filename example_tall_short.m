%% load data
clear % remove all existing variables
close all % close all figure windows
load('./TutorialData.mat'); % load the tutorial data, be aware of the path
%% 1
dimensions = size(Data)
%% 2
values = unique(Labels)
%% 3
% calculate for tall
isTall = find(Labels == 1);
minimum = min(Data(isTall, 1))
maximum = max(Data(isTall, 1))
average = mean(Data(isTall, 1))

% plot for tall
figure % create a new figure
plot(values(1), average, 'or');
hold on % not to erase current figure for future plotting
plot(values(1), minimum, 'xb');
plot(values(1), maximum, 'xb');

% calculate for short
isShort = find(Labels == -1);
minimum = min(Data(isShort, 1))
maximum = max(Data(isShort, 1))
average = mean(Data(isShort, 1))

% plot for short
plot(values(2), average, 'og');
plot(values(2), minimum, 'xb');
plot(values(2), maximum, 'xb');

% set the figure in a clear way
grid on;
xlim([-1.75, 1.75]);
ylim([150 200]);
ylabel('Height (cm)');
set(gca,'xtick', values, 'xticklabel', {'Tall', 'Short'}); % {} is cell (learn by youself if you are interested)
set(gca, 'fontweight', 'bold');
%% 4
% calculate for tall
isTall = find(Labels == 1);
minimum = min(Data(isTall, 3))
maximum = max(Data(isTall, 3))
average = mean(Data(isTall, 3))

% plot for tall
figure % create a new figure
plot(values(1), average, 'or');
hold on % not to erase current figure for future plotting
plot(values(1), minimum, 'xb');
plot(values(1), maximum, 'xb');

% calculate for short
isShort = find(Labels == -1);
minimum = min(Data(isShort, 3))
maximum = max(Data(isShort, 3))
average = mean(Data(isShort, 3))

% plot for short
plot(values(2), average, 'og');
plot(values(2), minimum, 'xb');
plot(values(2), maximum, 'xb');

% set the figure in a clear way
grid on;
xlim([-1.75, 1.75]);
ylim([10 50]);
ylabel('Age (years)');
set(gca,'xtick', values, 'xticklabel', {'Tall', 'Short'}) % {} is cell (learn by youself if you are interested)
set(gca, 'fontweight', 'bold');