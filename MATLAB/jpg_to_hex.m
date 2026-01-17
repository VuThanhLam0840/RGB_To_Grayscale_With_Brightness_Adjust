% Chuyển JPG sang BGR hex (không header)
clear; clc;

INPUT_JPG = 'baitap2_anhgoc.jpg';
OUTPUT_HEX = 'in.txt';

fprintf('==================================\n');
fprintf('JPG TO HEX CONVERTER\n');
fprintf('==================================\n');
fprintf('Input:  %s\n', INPUT_JPG);
fprintf('Output: %s\n', OUTPUT_HEX);

% Đọc ảnh
fprintf('\nĐọc ảnh...\n');
img = imread(INPUT_JPG);
[height, width, channels] = size(img);

fprintf('Kích thước: %d x %d x %d\n', height, width, channels);

if channels ~= 3
    error('Ảnh phải là RGB (3 channels)!');
end

% Tách RGB
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

% Tạo BGR data (từ TRÊN xuống DƯỚI, TRÁI sang PHẢI)
fprintf('\nChuyển RGB → BGR...\n');
num_pixels = height * width;
bgr_data = zeros(num_pixels * 3, 1, 'uint8');

idx = 1;
for row = 1:height
    for col = 1:width
        bgr_data(idx)   = B(row, col);  % Blue
        bgr_data(idx+1) = G(row, col);  % Green
        bgr_data(idx+2) = R(row, col);  % Red
        idx = idx + 3;
    end
    
    % Progress
    if mod(row, 100) == 0
        fprintf('  %.1f%%\n', row/height*100);
    end
end

fprintf('Tổng bytes: %d\n', length(bgr_data));

% Ghi file hex
fprintf('\nGhi file hex...\n');
fid = fopen(OUTPUT_HEX, 'w');

for i = 1:length(bgr_data)
    fprintf(fid, '%02X\n', bgr_data(i));
    
    % Progress
    if mod(i, 100000) == 0
        fprintf('  %.1f%%\n', i/length(bgr_data)*100);
    end
end

fclose(fid);

fprintf('\n==================================\n');
fprintf('✓ Hoàn thành!\n');
fprintf('==================================\n');
fprintf('File:   %s\n', OUTPUT_HEX);
fprintf('Bytes:  %d\n', length(bgr_data));
fprintf('Pixels: %d\n', num_pixels);

% Verify - hiển thị 9 bytes đầu
fprintf('\n9 bytes đầu (3 pixels BGR):\n');
for i = 1:3
    fprintf('Pixel %d: %02X %02X %02X (B=%d, G=%d, R=%d)\n', ...
            i-1, ...
            bgr_data(i*3-2), bgr_data(i*3-1), bgr_data(i*3), ...
            bgr_data(i*3-2), bgr_data(i*3-1), bgr_data(i*3));
end