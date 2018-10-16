cuttimes.names = {'pkh01_1ul', 'pkh02_1ul', 'pkh01_2ul', 'pkh02_2ul', 'pkh01_4ul', 'pkh02_4ul'};
cuttimes.filenames = {'C:\Users\Senan\Desktop\pump prelim\pKH01-20180803-193539.bin',
                      'C:\Users\Senan\Desktop\pump prelim\pKH02-20180803-160721.bin',
                      'C:\Users\Senan\Desktop\pump prelim\pKH01-20180918-092911.bin',
                      'C:\Users\Senan\Desktop\pump prelim\pKH02-20180918-092913.bin',
                      'C:\Users\Senan\Desktop\pump prelim\pKH01-20181003-130634.bin',
                      'C:\Users\Senan\Desktop\pump prelim\pKH02-20181003-130638.bin'
                      }
                      
cuttimes.times = [134, 52, 83, 78, 123,108];


for i = 1:length(cuttimes.times)
    for j = 1:2 %channels of interest
        data = powercomp(cuttimes.filenames{i}, cuttimes.times(i), [-10,-5, 5,10], j);
        %save(strcat(cuttimes.names(i), '_ch', j, '.mat'), 'data');
        %saveas(gcf, strcat(cuttimes.names(i), '_ch', j, '_powers.fig'));
        %saveas(gcf, strcat(cuttimes.names(i), '_ch', j, '_powers.png'));
        
    end
end
