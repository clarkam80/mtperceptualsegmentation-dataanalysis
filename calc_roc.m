function [auc , pFA, pH] = calc_roc(noise , signal)

responses   = vertcat(noise , signal);

criteria    = linspace(min(responses) - 0.1 , max(responses) + 0.1 , 100);

gtC_noise   = NaN(numel(criteria) , 1);
gtC_signal  = NaN(numel(criteria) , 1);
for i = 1 : numel(criteria)
    gtC_noise(i)    = sum(ge(noise , criteria(i)));
    gtC_signal(i)   = sum(ge(signal , criteria(i)));
end

pFA         = gtC_noise / sum(isfinite(noise));
pH          = gtC_signal / sum(isfinite(signal));

auc         = trapz(flip(pFA) , flip(pH));