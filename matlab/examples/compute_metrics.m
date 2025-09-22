
function S = compute_metrics(t, y, r)
%COMPUTE_METRICS  Rise time, overshoot, settling time (2% band).
rt = NaN; os = NaN; st = NaN;
yr = r(end);
y10 = yr + 0.1*(y(1)-yr);
y90 = yr + 0.9*(y(1)-yr);
idx10 = find((y-yr).*(y10-yr) <= 0, 1, 'last');
idx90 = find((y-yr).*(y90-yr) <= 0, 1, 'last');
if ~isempty(idx10) && ~isempty(idx90), rt = t(max(idx90,idx10)) - t(min(idx90,idx10)); end
os = (max(y)-yr)/max(abs(yr),1e-9)*100;
band = 0.02*max(abs(yr),1e-9);
idx = find(abs(y-yr) > band, 1, 'last');
if isempty(idx), st = 0; else, st = t(end) - t(idx); end
S = struct('rise_time',rt,'overshoot_pct',os,'settling_time',st);
end
