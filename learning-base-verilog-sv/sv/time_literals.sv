`timescale 100ps/10ps //100ps - delay, 10ps - step
module time_literals ();

time a;
// @ 0 a =      x0 - x(unknown)
initial begin
    $monitor ("@ %g a = %t", $time, a);
    #1 a = 1ns; //1ns = 1000ps -> 1000ps/step = 100
    #1 a = 0.2ns;
    #1 a = 300ps;
    #1 $finish;
end

endmodule