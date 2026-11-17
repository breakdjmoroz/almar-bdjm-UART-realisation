//always blocks
//NOTE: it can not drive wire data type
//but can drive reg and integer data types
always @ (a OR b OR sel)
begin
    y = 0;
    if (sel == 0) begin
        y = a; // = for comb logiс
// = is a blocking assignment
// operators execute one by one.
//value's variable updated instantly

    end else begin
        y = b;
    end
end
