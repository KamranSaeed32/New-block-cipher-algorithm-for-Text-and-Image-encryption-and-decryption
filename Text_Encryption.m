function Text_Encryption(Text,Key)


Data = double(char(Text));
Data = de2bi(Data, 8);
Data = Data';
Data = Data(:)';

input = bi2de(reshape(Data, 4, 32)')';

fprintf('%d ', Key);
fprintf('\n');
RoundKeys = Round_Key(Key);
% Encryption
LB = input(1:16);
RB = input(17:32);

for i = 1:16
    x = RB;
    RB = bitxor(f_function(RB, RoundKeys(i, :)), LB);
    LB = x;
end

Encrypted4 = [LB, RB];

X = de2bi(Encrypted4, 4)';
X = X(:);
X = bi2de(reshape(X, 8, 16)')';

Encrypted = char(X);
disp("Encrypted Message: " + Encrypted);

% Decryption
input = Encrypted4;

% Generate round keys in reverse order
RoundKeys = flipud(RoundKeys);

LB = input(1:16);
RB = input(17:32);

for i = 1:16
    x = LB;
    LB = bitxor(f_function(LB, RoundKeys(i, :)), RB);
    RB = x;
end

Decrypted4 = [LB, RB];

X = de2bi(Decrypted4, 4)';
X = X(:);
X = bi2de(reshape(X, 8, 16)')';

Decrypted = char(X);
disp("Decrypted Message: " + Decrypted);

function Output = Round_Key(input)
i = 1;
while i < 17
    input = Key_Scadulae(input);
    Round_Key(i,:) = bitxor(input(1:16), input(17:32));
    i = i + 1;
end
Output = Round_Key;
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
% Add the implementation of the sub_bytes function here if available
function bytes_out = sub_bytes (bytes_in, s_box)
bytes_out = s_box (bytes_in + 1);
end
end