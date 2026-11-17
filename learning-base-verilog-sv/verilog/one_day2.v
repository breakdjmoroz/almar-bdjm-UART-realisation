//begin and end act like curly braces in C and C++
if (enable == 1'b1)
begin
    data = 10; //decimal
    address = 16'hDEAD; //haxadecimal
    wr_enable = 1'b1; //binary
end else
begin
    data = 32'b0;
    wr_enable = 1'b0;
    address = address + 1;
end