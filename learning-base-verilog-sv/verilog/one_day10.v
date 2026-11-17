//same as one_day9.v but
//the output y is now a flip-flop output
always @ (posedge clk)
if (reset == 0) begin
    y <= 0; //<= for sequential block
//<= - non-blocking assignment.
//all right parts are calculated simultaneously (at the same time)
//in the begining og the tact
//the assignment happens in the end of the tact
//it correctly models the work of flip-flops
//and prevent race conditions
end else if (sel == 0) begin
    y <= a;
end else begin
    y <= b;
end
