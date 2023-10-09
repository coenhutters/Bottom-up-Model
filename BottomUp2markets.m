% Matlab code for simulation of 2 competitive markets with price coupling
% author: Coen Hutters
clear all; close all; clc;

% figure;  hold on;           % Create a new figure

% create time vector
tspan = 0:0.01:100000;
tspan = tspan(1:end-1);

% agent parameters
Ed1 = [0.65 0.40;0.4 0.5];% demander 1
Ed2 = [0.2 .10;.10 0.2];  % demander 2
Es1 = [0.5 0.0;0.0 0.3];  % supplier 1
Es2 = [0.3 0.0;0.0 0.2];  % supplier 2
R = 0.001;                % friction a and b 
Cc = 0.00001;             % Storage a and b
% For varying substitution goods
          % independent    % normal      % perf subs    % complements
Ed1_values={[.5 0;0 .5], [.5 .3;.3 .5], [.5 .5;.5 .5], [.5 -.5;-.5 .5]};
Ed2_values={[.3 0;0 .3], [.3 .2;.2 .3], [.3 .3;.3 .3], [.3 -.3;-.3 .3]};
% For varying storage preference
C_values = {0 0.0001 0.001}; % Different values for C
% For varying market friction
R_values = {0, 0.001, .01}; % Diffirent values for R

% for each type of demander
for k = 1:length(Ed1_values)
% Cc = C_values(k); % in case of varying storage preference
% R = R_values{k};  % in case of varying market friction
Ed1 = Ed1_values{k}; % k=1: independent, k=2:normal,....
Ed2 = Ed2_values{k};
% state-space matrices 
A = [0 0 -(Es1(1,1)+Es2(1,1)+Ed1(1,1)+Ed1(1,1)) -(Ed1(1,2)+Ed2(1,2));
     0 0 -(Ed1(2,1)+Ed2(2,1)) -(Es1(2,2)+Es2(2,2)+Ed1(2,2)+Ed1(2,2));
  Cc 0 -R*(Es1(1,1)+Es2(1,1)+Ed1(1,1)+Ed1(1,1)) -R*(Ed1(1,2)+Ed2(1,2));
  0 Cc -R*(Ed1(2,1)+Ed2(2,1)) -R*(Es1(2,2)+Es2(2,2)+Ed1(2,2)+Ed1(2,2))];
B = [1 1 0 0;
     0 0 1 1;
     R R 0 0;
     0 0 R R];
C = eye(4);        % state-output matrix
D = 0;             % direct throughput
sys = ss(A,B,C,D); % create state-space model

% create input sequence (first part is to initialize market variables)    
u = [10*ones(4,length(tspan)/10*2) [20*ones(1,length(tspan)/10*8);
                                    10*ones(3,length(tspan)/10*8)]] ;
% simulate system behavrior following step input
[output,time] =lsim(sys,u,tspan); 

% Define the line styles, colors, and labels for each output
labels = {'To: $q_a$', 'To: $q_b$', 'To: $\lambda_a$', 'To: $\lambda_b$'};
titels = {'From: $u_a$'}; 
% Create subplots for each input-output pair
numOutputs = size(sys, 1);
            %plot graphs
    for i = 1:numOutputs
            subplot(numOutputs, 1, (i-1) + 1);
            hold on
            plot(time(length(tspan)/10*2+1:length(tspan)/10*3),...
            output(length(tspan)/10*2+1:length(tspan)/10*3, i),...
            'LineWidth', 2);
            grid on; % Enable gridlines
            if i==max(numOutputs)
            xlabel('Time', 'Interpreter', 'latex');
            end
            ylabel(labels{i}, 'Interpreter', 'latex','FontSize', 12);
            if i==1
            title(titels(1), 'Interpreter', 'latex','FontSize', 12);
            end
            set(gca, 'XTickLabel', {});
    end
end
Add legend under the subplots
subplot(numOutputs, 1, numOutputs);
legend('independent', 'normal','perf. subs.', 'complements', ...
       'Interpreter', 'latex', 'Location', 'southoutside', ...
       'Orientation', 'horizontal');
