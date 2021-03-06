function [G, TP, ARD] = convert_to_ts(gid, acc, ard)

%% groupid processing
first_gid = find(gid == 1,1);
last_gid = find(gid == 1); last_gid = last_gid(end);
gid(1:first_gid-1) = 0;

gid = find(diff([gid,0]));
G = gid(1:2:end);

%% accelerometer data processing
% tapping is assumed to have occurred every 4 seconds
freq_of_tapping = 0.25; % Hz
sample_rate = 250; % Hz
% we will check windows of w_size width and find there a maximum peak -
% at each channel; the peak occurs at the moments when there was tapping;
w_size = sample_rate/freq_of_tapping; % time-points
w_num = 1;

num_t_samples = size(acc,2);
tapping_channel = zeros(1,num_t_samples);

for t_idx = 1:w_size:num_t_samples-w_size
    s_cur = acc(1, t_idx:t_idx+w_size-1);
    [~, max_idx] = max(s_cur);
    abs_max_idx = max_idx + w_size*(w_num-1);
    tapping_channel(abs_max_idx) = -1;
    w_num = w_num + 1;
end

tapping_channel(1, 1:first_gid - w_size) = 0;
tapping_channel(1, last_gid+1:end) = 0;
TP = find(tapping_channel);

%% arduino data

first_ard = find(ard == 1,1);
last_ard = find(ard == 1); last_ard = last_ard(end);
ard(1:first_ard-1) = 0;

ard = find(diff([ard,0]));
ARD = ard(1:2:end);
