function da = powercomp(filename, cut, chan)

    da = bin2mat(filename);
    injmin = cut; % minute of injection
    
    [filepath, name, ext] = fileparts(filename);
    animal = name(1:5);
    
    rate = 1000;
    window = 60;

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
    [~, featnames] = getEEGfeatures(data, rate, params)


    [h, p] = ttest2(allfeats(1:injmin,:),allfeats(injmin+1:end,:))

    figure
    errorbar(mean(allfeats(1:injmin,:)), std(allfeats(1:injmin,:)/sqrt(length(allfeats(1:injmin,:)))),'bx')
    hold on
    errorbar(mean(allfeats(injmin+1:end,:)), std(allfeats(injmin+1:end,:)/sqrt(length(allfeats(injmin+1:end,:)))),'rx')
    legend('pre-injection', 'post-injection')
    ylabel('normalized power')
    xlabel('bands')
    xticklabels({'0.5-4 Hz', '4-8 Hz', '8-12 Hz', '12-16 Hz', '16-25 Hz', '25-50 Hz', '50-100 Hz'})
    title (strcat(animal,' normalized power in ch', num2str(chan),' with diazepam injection'))
    shg

    da.normpowers = allfeats;
    
end