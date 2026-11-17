//assign statement for modeling ONLY comb logic
//executed continuously
//so the assign statement is called 'continuous
//assignment statement' as there is no sensitive list
assign out = (enable) & data:1'bz;
//the above example is a tri-state buffer. When enable
//is 1, data is driven to out, else out is pulled to
// high-impedance. We can have nested conditional operators
//to construct mux, decoders and encoders