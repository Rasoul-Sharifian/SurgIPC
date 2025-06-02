clc
clear
close all

load('num_matches.mat')
load('num_matches_IPC.mat')

% Calculate the ratio
ratio = numMatches_IPC ./ numMatches;

% Create the figure
figure
yyaxis left
plot(numMatches, 'Color', [0 0.4 1 1], 'LineWidth', 1.2, 'MarkerSize', 6)
ylabel('# Correspondences')
hold on 
plot(numMatches_IPC, 'Color', [1, 0.4, 0, 1], 'LineWidth', 1.2, 'MarkerSize', 6, 'LineStyle', '-')


hold off
ylim([0 700])
% Set left y-axis colors to blue
set(gca, 'YColor', [0, 0, 0]); % Set y-axis color to deep blue

yyaxis right
plot(ratio, 'LineWidth', 1.2, 'MarkerSize', 6, 'LineStyle', '--', 'Color', [1, 0, 0, 0.75])
hold on
plot([0 97],[1 1],'LineWidth', 1.2, 'MarkerSize', 6, 'LineStyle', '-', 'Color', [0, 0, 0, 1])
hold on
plot([8 8],[0 9.5],'LineWidth', 1.2, 'MarkerSize', 6, 'LineStyle', '-', 'Color', [0, 0, 0, 1])

xlim([1 96])
ylabel('Ratio')
xlabel('Frame Number')
legend('SIFT + UBCMatcher', 'SurgIPC + SIFT + UBCMatcher', 'Ratio', 'Location', 'northeast')
grid on
grid minor
ylim([0 9.5])
set(gca, 'YColor', [0, 0, 0]); % Set y-axis color to crimson red



