function fast_writememh_to_jpg(input_file, output_file, width, height)
    % Đọc file nhanh bằng textscan
    fid = fopen(input_file, 'r');
    
    % Đọc tất cả các giá trị hex
    data = textscan(fid, '%s', 'CommentStyle', '//');
    fclose(fid);
    
    % Chuyển hex sang decimal
    hex_values = data{1};
    pixels = cellfun(@hex2dec, hex_values);
    
    fprintf('Read %d pixels\n', length(pixels));
    
    % Reshape
    img = reshape(pixels(1:width*height), [width, height])';
    img = uint8(img);
    
    % Lưu và hiển thị
    imwrite(img, output_file, 'jpg', 'Quality', 95);
    figure; imshow(img);
    title(sprintf('%s (%dx%d)', output_file, height, width));
    
    fprintf('✓ Saved: %s\n', output_file);
end

% Sử dụng
fast_writememh_to_jpg('kiet_adjust.txt', 'kiet_adjust.jpg', 2048, 1365);