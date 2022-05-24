%directionTuningAnalysis.m

close all
clear
clc

dataDir         = uigetdir();
load(fullfile(dataDir , 'exampleDirectionData') , 'allDir' , 'background')

ang1            = 1;
ang2            = 2;
pcClass         = 3;
chan            = 4;
unit            = 5;
rates           = 6;

chanUnit        = unique(allDir(: , [chan , unit]) , 'rows');
allAng          = unique(allDir(: , ang1));
sampRes         = allAng(2) - allAng(1);
allPc           = unique(allDir(: , pcClass));

pattAng         = circshift(flip(unique(allDir(allDir(: , 1) ~= allDir(: , 2) , [ang1 , ang2]) , 'rows')) , -3);
iga             = 135;
pattDir         = pattAng(: , 1) + mean(pattAng(1 , :)) - 270;
pattDir(pattDir < 0) = pattDir(pattDir < 0) + 360;

ave             = 1;
se              = 2;
grating         = 1;
plaid           = 2;

fig1            = figure('color' , 'w');
pInd            = 1;

allTuning       = NaN(numel(allAng) , 2 , numel(allPc) , size(chanUnit , 1));
for cu = 1 : size(chanUnit , 1)
    
    cuData = allDir(allDir(: , chan) == chanUnit(cu , 1) & allDir(: , unit) == chanUnit(cu , 2) , :);
    
    for ip = 1 : numel(allPc)
        
        for ja = 1 : numel(allAng)
        
            allTuning(ja , ave , ip , cu) = mean(cuData(cuData(: , ang1) == allAng(ja) & cuData(: , pcClass) == allPc(ip) , rates));
            allTuning(ja , se , ip , cu) = std(cuData(cuData(: , ang1) == allAng(ja) & cuData(: , pcClass) == allPc(ip) , rates)) ...
                ./ sqrt(numel(cuData(cuData(: , ang1) == allAng(ja) & cuData(: , pcClass) == allPc(ip) , rates)));
            
        end
        
    end
    
    gTuning = sortrows(horzcat(allAng , squeeze(allTuning(: , ave , grating , cu))) , 1);
    pTuning = sortrows(horzcat(pattDir , squeeze(allTuning(: , ave , plaid , cu))) , 1);
    
    [~ , ~ , ~ , ~ , ~ , compPred] = calc_pattCompCorr(gTuning(: , 2) , pTuning(: , 2) , background(cu));
    
    figure(fig1)
    subplot(size(chanUnit , 1) , 3 , 1 + (3 * (cu - 1)))
    g = polarplot(deg2rad(vertcat(gTuning(: , 1) , gTuning(1 , 1))) , vertcat(gTuning(: , 2) , gTuning(1 , 2)) , '-k');
    set(g , 'linewidth' , 1.5)
    set(gca , 'thetatick' , 0 : 90 : 360 - 90 , 'rgrid' , 'off' , 'thetagrid' , 'off' , 'rtick' , [0 , max(rlim) - 1]);
    if cu == 1
        title('Grating Response' , 'fontweight' , 'bold' , 'fontsize' , 8)
    end
    
    subplot(size(chanUnit , 1) , 3 , 2 + (3 * (cu - 1)))
    polarplot(deg2rad(vertcat(gTuning(: , 1) , gTuning(1 , 1))) , vertcat(gTuning(: , 2) , gTuning(1 , 2)) , '-k');
    hold on
    polarplot(deg2rad(vertcat(gTuning(: , 1) , gTuning(1 , 1))) , vertcat(compPred , compPred(1)) , ':r');
    cp = findobj(gca , 'type' , 'line');
    set(cp , 'linewidth' , 1.5)
    set(gca , 'thetatick' , 0 : 90 : 360 - 90 , 'rgrid' , 'off' , 'thetagrid' , 'off' , 'rtick' , [0 , max(rlim) - 1]);
    if cu == 1
        title('PattComp Predictions' , 'fontweight' , 'bold' , 'fontsize' , 8)
    end
    
    subplot(size(chanUnit , 1) , 3 , 3 + (3 * (cu - 1)))
    p = polarplot(deg2rad(vertcat(pTuning(: , 1) , pTuning(1 , 1))) , vertcat(pTuning(: , 2) , pTuning(1 , 2)) , '-b');
    set(p , 'linewidth' , 1.5)
    set(gca , 'thetatick' , 0 : 90 : 360 - 90 , 'rgrid' , 'off' , 'thetagrid' , 'off' , 'rtick' , [0 , max(rlim) - 1]);
    if cu == 1
        title('Plaid Response' , 'fontweight' , 'bold' , 'fontsize' , 8)
    end
    
end