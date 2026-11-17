//always block without sensitive list
//in this case we need to have a delay as shown in
//the code below
always begin
    #5 clk = ~clk;
end

//#5 in front of the statement delays its
//execution by 5 time units