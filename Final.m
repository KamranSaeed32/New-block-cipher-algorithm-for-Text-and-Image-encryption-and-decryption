close all; 
clear all; 
clc
repeat = true;

while repeat
    choice = input('What do you want to encrypt? Enter "text" or "image": ', 's');

    if strcmpi(choice, 'text')
        % Get input from the user
        Text = input ("Enter the message to encrypt (less than 17 alphabets): ", 's');
        
        % Check if the input exceeds the limit
        while numel(Text) > 16
            disp("Input exceeds the limit. Please enter a message with less than 17 alphabets.");
            Text = input("Enter the message to encrypt (less than 17 alphabets): ", 's');
        end
        
        % Add spaces if the input length is less than 16
        if numel(Text) < 16
            Text = [Text, repmat(' ', 1, 16 - numel(Text))];
        end
        
        disp("Original Message: " + Text);
        disp('E.g: Key = [7,12,8,10,14,0,4,0,3,11,11,14,9,1,14,12,4,8,15,11,13,6,7,8,4,11,8,10,4,2,7,5]')
        kk = input('Enter the encryption key (Length 32 and every value should be less then 16):', 's');
        Key = str2num(kk);
        
        % Check if the length is less than 32
        if length(Key) < 32
            % Generate random numbers to fill the remaining length
            remainingLength = 32 - length(Key);
            randomNumbers = randi([0, 15], 1, remainingLength);
            
            % Concatenate the random numbers to the input array
            Key = [Key, randomNumbers];
        end
        disp("Incorrect format automatically generated a Key. Key:");
        % Define the modulo value
        moduloValue = 16;
        
        % Check each index of the array
        for i = 1:length(Key)
            if Key(i) > 15
                Key(i) = mod(Key(i), moduloValue);
            end
        end
        Text_Encryption(Text,Key);

    elseif strcmpi(choice, 'image')
        % disp('E.g: Key = [7,12,8,10,14,0,4,0,3,11,11,14,9,1,14,12,4,8,15,11,13,6,7,8,4,11,8,10,4,2,7,5]')
        % kk = input('Enter the encryption key (Length 32 and every value should be less then 16):', 's');
        % Key = str2num(kk);
        % 
        % % Check if the length is less than 32
        % if length(Key) < 32
        %     % Generate random numbers to fill the remaining length
        %     remainingLength = 32 - length(Key);
        %     randomNumbers = randi([0, 15], 1, remainingLength);
        % 
        %     % Concatenate the random numbers to the input array
        %     Key = [Key, randomNumbers];
        % end
        % disp("Incorrect format automatically generated a Key. Key:");
        % % Define the modulo value
        % moduloValue = 16;
        % 
        % % Check each index of the array
        % for i = 1:length(Key)
        %     if Key(i) > 15
        %         Key(i) = mod(Key(i), moduloValue);
        %     end
        % end
        % fprintf('%d ', Key);
        % fprintf('\n');
        % % Prompt the user to input the image
        % disp('Please select an image file:');
        % [fileName, filePath] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Select Image File');
        % imageFilePath = fullfile(filePath, fileName);
        % resized_image = imread(imageFilePath);
        % original_image = imresize(resized_image, [256, 256]);
        % Image_Encryption(Key,original_image);
        clc
        clear
        % Prompt the user to input the image
        disp('Please select an image file:');
        [fileName, filePath] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Select Image File');
        imageFilePath = fullfile(filePath, fileName);
        resized_image = imread(imageFilePath);
        original_image = imresize(resized_image, [256, 256]);
        %original_image = imread(imageFilePath);
        Image = rgb2gray(original_image);
        Image = Image';
        Image = Image(:);
        l = length(Image);
        
        Data = double(reshape(Image, 16, l/16)');
        
        disp('E.g: Key = [7,12,8,10,14,0,4,0,3,11,11,14,9,1,14,12,4,8,15,11,13,6,7,8,4,11,8,10,4,2,7,5]')
        kk = input('Enter the encryption key (Length 32 and every value should be less then 16):', 's');
        Key = str2num(kk);
        
        % Check if the length is less than 32
        if length(Key) < 32
            % Generate random numbers to fill the remaining length
            remainingLength = 32 - length(Key);
            randomNumbers = randi([0, 15], 1, remainingLength);
            
            % Concatenate the random numbers to the input array
            Key = [Key, randomNumbers];
        end
        disp("Incorrect format. Automatically generated a Key. Key:");
        % Define the modulo value
        moduloValue = 16;
        
        % Check each index of the array
        for i = 1:length(Key)
            if Key(i) > 15
                Key(i) = mod(Key(i), moduloValue);
            end
        end
        
        fprintf('%d ', Key);
        fprintf('\n');
        RoundKeys = Round_Key(Key);
        
        i = 1;
        while i < (l/16)+1
            Encryt(i,:) = Encryption(Data(i,:),Key);
            i = i + 1;
        end
        
        Encrypt = Encryt';
        Encrypt = Encrypt(:);
        Encrypted_image = uint8(reshape(Encrypt ,256,256));
        
        % Decryption
        Decrypted = [];
        j = 1;
        while j < (l/16)+1
            Decryt(j,:) = Decryption(Encryt(j,:),Key);
            j = j + 1;
        end
        
        Decrypt = Decryt';
        Decrypt = Decrypt(:);
        Decrypted_image = uint8(reshape(Decrypt, 256, 256));
        
        % Display images
        subplot(1, 3, 1);
        imshow(original_image);
        title('Original Image');
        
        subplot(1, 3, 2);
        imshow(Encrypted_image);
        title('Encrypted Image');
        
        subplot(1, 3, 3);
        originalImage = Decrypted_image;
        
        % Get the dimensions of the image
        [rows, columns, ~] = size(originalImage);
        
        % Create a new matrix for the rotated image
        rotatedImage = zeros(columns, rows, 3, class(originalImage));
        
        % Perform the right 90-degree rotation
        for row = 1:rows
            for col = 1:columns
                rotatedImage(col, rows - row + 1, :) = originalImage(row, col, :);
            end
        end
        
        % Display the rotated image
        imshow(rotatedImage);
        title('Decrypted Image');
        
        

    else
        disp('Invalid choice.');
    end
    
    % Ask if the user wants to repeat
    repeat_choice = input('Do you want to encrypt again? Enter "yes" or "no": ', 's');
    if strcmpi(repeat_choice, 'no')
        repeat = false;
    end
end
function Output = Round_Key(input)
    i = 1;
    while i < 17
        input = Key_Scadulae(input);
        Round_Key(i,:) = bitxor(input(1:16),input(17:32));
        i = i + 1;
    end
    Output = Round_Key;
end

function Output = Key_Scadulae(input)
    binaryInput = de2bi(input, 4, 'left-msb')';
    binaryInput = binaryInput(:)';
    Permutation = [8,54,11,66,73,38,112,95,85,124,114,119,92,33,45,115,93,34,17,98,104,103,55,100,27,49,32,36,67,80,41,39,60,106,58,123,9,25,72,122,79,105,69,2,37,84,94,97,3,86,75,102,10,64,23,12,28,71,121,126,52,13,6,51,77,89,44,116,68,96,1,61,18,24,113,81,48,109,15,120,40,83,118,42,4,16,19,108,21,63,128,50,70,107,22,30,110,111,127,31,101,14,46,91,90,99,43,117,87,74,35,82,88,59,78,47,125,5,7,26,65,76,62,57,56,29,20,53];
    permuted_data = binaryInput(Permutation);
    foubits = bi2de(reshape(permuted_data,4,32)','left-msb')';
    sBox = [9 4 10 11;
            13 1 8 5;
            6 2 0 3;
            12 14 15 7];
    Output = sub_bytes(foubits ,sBox);
end

function Output = f_function(Data, RoundK)
    Key_add = bitxor(Data, RoundK);
    sBox = [9 4 10 11;
            13 1 8 5;
            6 2 0 3;
            12 14 15 7];
    Substitute = reshape(sub_bytes(Key_add, sBox), 4, 4);
    Mat = [9   10    4    9;
            2    4    6    4;
            15    7   13    8;
            2    5   15    8];
    Mat = gf(Mat, 4);
    Output = Mat * Substitute;
    Output = Output.x;
    Output = double(Output(:)');
end

function Encrypted = Encryption(Data, Key)
    Data = de2bi(Data, 8);
    Data = Data';
    Data = Data(:)';
    input = bi2de(reshape(Data, 4, 32)')';
    RoundKeys = Round_Key(Key);
    LB = input(1:16);
    RB = input(17:32);
    disp('Please wait it will take few moments.......')
    for i = 1:16
        disp('Please wait it will take few moments')
        x = RB;
        RB = bitxor(f_function(RB, RoundKeys(i, :)), LB);
        LB = x;
    end
    Encrypt4 = [LB, RB];
    X = de2bi(Encrypt4, 4)';
    X = X(:);
    X = bi2de(reshape(X, 8, 16)')';
    Encrypted = X;
end

function Decrypted = Decryption(Data, Key)
    Data = de2bi(Data, 8);
    Data = Data';
    Data = Data(:)';
    input = bi2de(reshape(Data, 4, 32)')';
    RoundKeys = Round_Key(Key);
    LB = input(1:16);
    RB = input(17:32);
    for i = 16:-1:1
        x = LB;
        LB = bitxor(f_function(LB, RoundKeys(i, :)), RB);
        RB = x;
    end
    Decrypt4 = [LB, RB];
    X = de2bi(Decrypt4, 4)';
    X = X(:);
    X = bi2de(reshape(X, 8, 16)')';
    Decrypted = X;
end
function bytes_out = sub_bytes (bytes_in, s_box)
bytes_out = s_box (bytes_in + 1);
end