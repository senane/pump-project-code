function da = powercomp(filename, cut, periods, chan)

% computes and plots difference in normalized powers 

% modified to take a 5 minute window on each side of cut time for
% comparison, with a 5 minute buffer (i.e. [-10,-5] vs [5,10] min) where 0
% is cut time

% cut represents minute of injection on EEG recording
% window is [start1, stop1, start2, stop2] in minutes

    da = bin2mat(filename);
    
    injmin = cut;
    
    if cut + min(periods) < 0
        error('Cut time is too low for window provided')
    end
    
    
    [filepath, name, ext] = fileparts(filename);
    animal = name(1:5);
    
    rate = 1000;
    window = 10; % size of a window for features, in seconds

    params.chans = [chan];
    params.features = [4];
    params.outputNames = 0 ;

    data = da.stream';
    alldata = data(:,2:5);

    % data = randn(1000,5)
    % rms = sqrt(sum(data.*data,1)/(size(data,1)))

    k = 1;
    allfeats = [];
    while k < length(alldata)-window*rate
        data = alldata(k:(k+window*rate),:);
        [feats, ~] = getEEGfeatures(data, rate, params);
        k = k + window*rate;
        allfeats = [allfeats; feats];
    end

    params.outputNames = 1 ;
    [~, featnames] = getEEGfeatures(data, rate, params);


    
    start1 = (injmin + periods(1))*60/window;
    stop1 = (injmin + periods(2))*60/window;
    start2 = (injmin + periods(3))*60/window;
    stop2 = (injmin + periods(4))*60/window;
    
    predata = allfeats(start1:stop1,:);
    postdata = allfeats(start2:stop2,:);
    
    [h, p] = ttest2(predata,postdata);

    figure
    errorbar(mean(predata), std(predata/sqrt(length(predata))),'bx')
    hold on
    errorbar(mean(postdata), std(postdata/sqrt(length(postdata))),'rx')
    legend('pre-injection', 'post-injection')
    ylabel('normalized power')
    xlabel('bands')
    xticklabels({'0.5-4 Hz', '4-8 Hz', '8-12 Hz', '12-16 Hz', '16-25 Hz', '25-50 Hz', '50-100 Hz'})
    title (strcat(animal,' normalized power in ch', num2str(chan),' with diazepam injection'))
    shg

    da.normpowers = allfeats;
    
end