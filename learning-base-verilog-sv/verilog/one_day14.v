//Task and function
function parity;
input [31:0] data;
integer i;
begin
    parity = 0;
    for (i = 0; i < 32; i = i + 1) begin
        parity = parity ^ data[i];
    end
end
endfunction
//tasks can have delays, whereas functions can not have
//any delay.
//This means that function can be used for modeling
//comb logic

//and functions can return a value, whereas tasks can not