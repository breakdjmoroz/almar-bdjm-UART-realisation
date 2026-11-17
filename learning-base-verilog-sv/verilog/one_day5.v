module one_day5 (clk, rst, enable, count);
input clk, rst, enable;
output [3:0] count;
reg [3:0] count;

always @ (posedge clk or posedge rst)
//all blocks marked always will run simultaneously
//when one or more of the conditions listed within it
//is fulfilled
if (rst) begin
    count <= 0;
end else begin: COUNT
    while (enable) begin
        count <= count + 1;
        disable COUNT; //disabled a block of code
    end
end
endmodule
