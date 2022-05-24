%rocAnalysis.m

close all
clear
clc

dataDir         = uigetdir();
load(fullfile(dataDir , 'exampleTexturedPlaidData') , 'allTplaid')

options         = optimoptions('lsqcurvefit' , 'display' , 'off' , 'maxfunevals',10e9,'maxiter',10e9');

outcomes        = 1;
ang1            = 2;
ang2            = 3;
cueSign         = 4;
cueCon          = 5;
chan            = 6;
unit            = 7;
rates           = 8;

allAng          = unique(allTplaid(: , [ang1 , ang2]) , 'rows');
allCue          = unique(allTplaid(: , cueSign));
allCon          = unique(allTplaid(allTplaid(: , cueCon) ~= 0 , cueCon));

chanUnit        = unique(allTplaid(: , [chan , unit]) , 'rows');

fig1            = figure('color' , 'w');

allAuc          = NaN(numel(allCon) , size(allAng , 1) , size(chanUnit , 1));
for ic = 1 : size(chanUnit , 1)
    
    cuData      = allTplaid(allTplaid(: , chan) == chanUnit(ic , 1) & allTplaid(: , unit) == chanUnit(ic , 2) , :);
    
    for ja = 1 : size(allAng , 1)
        
        angTrials   = ismember(cuData(: , [ang1 , ang2]) , allAng(ja , :) , 'rows');
        
        cueEff      = fitlm(cuData(angTrials , cueSign) .* cuData(angTrials , cueCon) , cuData(angTrials , rates));
        plaidPref   = sign(cueEff.Coefficients.Estimate(end));
        
        figure(fig1)
        subplot(size(chanUnit , 1) , 4 , 1 + (2 * (ja - 1)) + (4 * (ic - 1)))
        ce = plot(cueEff);
        set(ce(1) , 'marker' , '.' , 'color' , 'k' , 'markersize' , 3)
        set(ce(2 : 4) , 'color' , 'r' , 'linewidth' , 1)
        legend off
        box off
        axis([-100 , 100 , 0 , 50])
        if ja == 1
            title(['Chan: ' num2str(chanUnit(ic , 1)) , '/Unit: ' , num2str(chanUnit(ic , 2))] , 'fontweight' , 'bold' , 'fontsize' , 8)
        else
            title('')
        end
        if ic == size(chanUnit , 1) && ja == 1
            xlabel('Cue Contrast (%)' , 'fontweight' , 'bold' , 'fontsize' , 8)
            ylabel('Rate (Spks/sec)' , 'fontweight' , 'bold' , 'fontsize' , 8)
        else
            xlabel('')
            ylabel('')
        end
        
        for kc = 1 : numel(allCon)
            
            cTrials = ismember(cuData(: , [ang1 , ang2 , cueSign , cueCon]) , [allAng(ja , :) , 1 , allCon(kc)] , 'rows');
            tTrials = ismember(cuData(: , [ang1 , ang2 , cueSign , cueCon]) , [allAng(ja , :) , -1 , allCon(kc)] , 'rows');
            
            if sum(cTrials) == 0 || sum(tTrials) == 0
                
                continue
                
            elseif plaidPref == 1
                
                allAuc(kc , ja , ic)    = calc_roc(cuData(tTrials , rates) , cuData(cTrials , rates));
                
            else
                
                allAuc(kc , ja , ic) = calc_roc(cuData(cTrials , rates) , cuData(tTrials , rates));
                
            end 
        end
    
        nMetric = sortrows(horzcat(vertcat(-allCon , allCon) , vertcat(1 - squeeze(allAuc(: , ja , ic)) , squeeze(allAuc(: , ja , ic)))) , 1);
        nMetric = nMetric(~isnan(nMetric(: , 2)) , :);
        
        x0loose = erf_gridSearch(nMetric(: , 1) , nMetric(: , 2));
        x0tight = erf_gridSearch(nMetric(: , 1) , nMetric(: , 2) , x0loose);
        errFit  = lsqcurvefit('erf_p_fit_fun' , x0tight , nMetric(: , 1) , nMetric(: , 2) , [] , [] , options);
        cRange  = linspace(nMetric(1 , 1) , nMetric(end , 1) , 100);
        
        figure(fig1)
        subplot(size(chanUnit , 1) , 4 , 2 + (2 * (ja - 1)) + (4 * (ic - 1)))
        hold on
        
        d = plot(nMetric(: , 1) , nMetric(: , 2) , 'ob');
        set(d , 'markerfacecolor' , 'b' , 'markeredgecolor' , 'w' , 'markersize' , 4)
        
        plot(cRange , errorFunction(errFit , cRange) , '-r');
        axis([-100 , 100 , 0 , 1])
        if ja == 1
            title('Patt. Dir.: 90^\circ' , 'fontweight' , 'bold' , 'fontsize' , 8);
        else
            title('Patt. Dir.: 270^\circ' , 'fontweight' , 'bold' , 'fontsize' , 8);
        end
        if ic == size(chanUnit , 1) && ja == 1
            xlabel('Cue Contrast (%)' , 'fontweight' , 'bold' , 'fontsize' , 8)
            ylabel('Frac. Pref.' , 'fontweight' , 'bold' , 'fontsize' , 8)
        end
        
    end
end 