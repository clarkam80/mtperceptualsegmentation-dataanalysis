%psychometricAnalysis.m

close all
clear
clc

options     = optimoptions('lsqcurvefit' , 'display' , 'off' , 'maxfunevals', 10e9 , 'maxiter' , 10e9');
xinit       = [0.5 , 1];

dataDir     = uigetdir();
load(fullfile(dataDir , 'examplePsychometricData') , 'hPsy1' , 'hPsy2')

allPsy      = vertcat(hPsy1 , hPsy2);

pattDir     = 1;
ang1        = 2;
ang2        = 3;
cueSign     = 4;
cueCon      = 5;
cohChoice   = 6;
monkId      = 7;
sessionNo   = 8;

allDir      = unique(allPsy(: , pattDir));
allAng      = unique(allPsy(: , [ang1 , ang2]) , 'rows');
allCueCon   = unique(allPsy(: , [cueSign , cueCon]) , 'rows');
monks       = unique(allPsy(: , monkId));
plotCon     = vertcat(-allCueCon(allCueCon(: , 1) == 0 , 2) , allCueCon(allCueCon(: , 1) == 1 , 2));

coh         = 1;
tra         = 0;

monkLabel   = {'Monkey S' , 'Monkey N'};

cueConRange = linspace(min(plotCon) , max(plotCon) , 100);

fracCoh     = 1;
se          = 2;

fig1        = figure('color' , 'w');

psychs      = NaN(size(allCueCon , 1) , 2 , numel(allDir) , numel(monks));
for m = 1 : numel(monks)
    for ia = 1 : numel(allDir)
        for jc = 1 : size(allCueCon , 1)
            
            numCue = size(allPsy(allPsy(: , monkId) == monks(m) & allPsy(: , pattDir) == allDir(ia) & allPsy(: , cueSign) == allCueCon(jc , 1) & allPsy(: , cueCon) == allCueCon(jc , 2)) , 1);
            cueCoh = size(allPsy(allPsy(: , monkId) == monks(m) & allPsy(: , pattDir) == allDir(ia) & allPsy(: , cueSign) == allCueCon(jc , 1) & allPsy(: , cueCon) == allCueCon(jc , 2) & allPsy(: , cohChoice) == coh) , 1);
            
            psychs(jc , fracCoh , ia , m) = cueCoh / numCue;
            psychs(jc , se , ia , m)      = ((cueCoh / numCue) * (1 - (cueCoh / numCue))) / sqrt(numCue);
            
        end
        
        errFit  = lsqcurvefit('erf_p_fit_fun' , xinit , plotCon , squeeze(psychs(: , fracCoh , ia , m)) , [] , [] , options);
        
        figure(fig1)
        subplot(2 , 2 , ia + (2 * (m - 1)))
        hold on
        h       = errorbar(plotCon , squeeze(psychs(: , fracCoh , ia , m)) , squeeze(psychs(: , se , ia , m)) , 'ob');
        set(h , 'capsize' , 0 , 'markersize' , 4 , 'markerfacecolor' , 'b' , 'markeredgecolor' , 'w');
        f       = plot(cueConRange , errorFunction(errFit , cueConRange) , '-r');
        set(f , 'linewidth' , 1);
        if ia == numel(allDir)
            yyaxis right
            ylabel(monkLabel{m} , 'fontweight' , 'bold' , 'color' , 'k')
            set(gca , 'yticklabel' , {});
            g = gca;
            g.YAxis(2).Color = 'k';
            yyaxis left
            set(gca , 'ytick' , 0 : 0.1 : 1)
        end
        
        grid on
        set(gca , 'xtick' , sort(plotCon) , 'ytick' , 0 : 0.1 : 1)
        xstring = string(sort(plotCon));
        xstring(2 : end - 1) = '';
        set(gca , 'xticklabel' , xstring)
        if m < numel(monks)
            title(['Pattern Direction: ' , num2str(allDir(ia)) , '^\circ'] , 'fontweight' , 'bold')
        end
        if ia == 1 && m == numel(monks)
            xlabel('Signed Cue Contrast' , 'fontweight' , 'bold')
            ylabel('Frac. Coh Choices' , 'fontweight' , 'bold')
        end
        
    end
end