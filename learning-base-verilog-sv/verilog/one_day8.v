initial begin
    clk = 0;
    reset = 0;
    req_0 = 0;
    req_1 = 0;

//executed only once when simulation starts
//This is useful in writing test benches
//If we have multiple initial blocks, then all
//of them are executed at the beginning of simulation