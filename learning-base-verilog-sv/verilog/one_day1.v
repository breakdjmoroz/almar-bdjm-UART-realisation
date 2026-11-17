module one_day1 (
//comment
clock,
reset,
req_0,
req_1,
read_enable,
address,
gnt_0,
gnt_1
);
//Input Ports
input clock;
input reset;
input req_0;
input req_1;
inout read_enable; //bi-directional port
//Vector Signals Example
inout [7:0] address; //port "address" is bidirectional
//[7:0] - little endian, start with 0
//Output Ports
output gnt_0;
output gnt_1;
//Data Type
wire and_gate_output; //wire that only outputs
reg d_flip_flop_output; //stores and outputs a value
reg [7:0] address_bus; // a little-endian 8-bit register
endmodule
