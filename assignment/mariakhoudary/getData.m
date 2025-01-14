function dataDownload = getData(URL)

% Downloads a CSV from the internet & returns the name of the local
% file. Takes one input: the URL of the file to be downloaded (must be a
% string).

% Presently, the script take as input arrays, matrices, and tables. 
% It outputs a CSV into the present working directory.

% Future versions may allow the user to specify the output filetype as well
% as download directory.

data = webread(URL);

if string(class(data)) == 'table'
    writetable(data, 'downloaded_data.csv');
else
    writematrix(data, 'downloaded_data.csv');
end

disp(['Download successful! The file can be found at: ', pwd filesep 'downloaded_data.csv']);