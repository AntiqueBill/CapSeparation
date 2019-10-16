function output = channel(input,number)
[A, B]=size(input);
output = zeros(A/number, B, number);
if number==2
    for i =1:A/2
    output(i,:,1) = input(2*i-1,:);
    output(i,:,2) = input(2*i,:);
    end
elseif number==3
    for i =1:A/3
    output(i,:,1) = input(3*i-2,:);
    output(i,:,2) = input(3*i-1,:);
    output(i,:,3) = input(3*i,:);
    end
end
    
