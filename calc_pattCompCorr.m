function [Rc , Rp , Zc , Zp , PCI , compPred] = calc_pattCompCorr(gratingResponse , plaidResponse , background)

shiftInd    = 3; %135deg IGA, 22.5deg sampling

pattPred    = gratingResponse;
compPred    = sum(horzcat(circshift(gratingResponse - background , shiftInd) ...
    , circshift(gratingResponse - background , -shiftInd)) , 2) + background;

rp          = corrcoef([plaidResponse pattPred]);
rc          = corrcoef([plaidResponse compPred]);
rpc         = corrcoef([pattPred compPred]);

Rp          = (rp(1,2) - (rc(1,2) * rpc(1,2))) / sqrt((1 - rc(1,2)^2) * (1 - rpc(1,2)^2));
 
Rc          = (rc(1,2) - (rp(1,2) * rpc(1,2))) / sqrt((1 - rp(1,2)^2) * (1 - rpc(1,2)^2));

Zp          = 0.5 * (log(1+Rp) - log(1-Rp)) / (sqrt(1/13));

Zc          = 0.5 * (log(1+Rc) - log(1-Rc)) / (sqrt(1/13));

PCI         = Zp - Zc;