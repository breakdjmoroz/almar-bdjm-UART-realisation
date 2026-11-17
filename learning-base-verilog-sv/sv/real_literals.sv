`timescale 1ns/100ps
module real_literals ();

real a;
shortreal b;

initial begin
    $monitor ("@ %gns a =%e b =%e", $time, a, b);
    a = '0;
    b = 1.0e2;
    #1 a = 2e5; //b value didnt change so in output we see the same number as before
    //Type Casting
    #1 b = shortreal'(a); //type'(value) = safer way to cast our type
    #1 a = 2.1E-2;
    //Type Casting
    #1 b = shortreal'(a);
    #1 $finish;
end

endmodule