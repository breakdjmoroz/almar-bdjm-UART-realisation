# The scope

Here we try to describe the boundaries of our project.
 We've decided to develop an MVP and if we'll reach a success, then we would go further.

All the information below refers to the first final version of the project, that will be tagged as the _v1.0.0_;
 The further versions aren't described here and requirements for them may become soon.

## What we will do

Aligned with the concept document we plan to construct the system, that contains three modules:

- The RTL model of the UART block written in SystemVerilog
- The golden model of the UART written in C and verified with the Frama-C tool
- The simulation tool, where we will test our RTL module via UVM testbenches

### The RTL model

To implement the UART module we have to have a specification.
 Despite to the fact, that UART is the world-wide known interface,
 there is no a unified specification, that describes it's behaviour.
 So we have decided to specify our UART module on our own base on the
 main principles of the UART interfaces. The specification below is
 our main document, that describes our plans.

Passing the details here the vision of the RTL module:

- RX and TX lines
- No FIFOs; memory-mapped registers only
- Immutable configuration
- No interrupts

### The golden model

It's also based on the specification below. To make this model really the gold one we have to:

- Implement RX and TX lines as corresponding functions, that take an input byte and return it's bitstream for TX
 and from a bitstream as input return a byte as an output for RX
- Verify the logic of the modification inside the functions we've spoken above via Frama-C framework
- Using Unity by ThrowTheSwitch, make sure that testbenches are able to call this functions via DPI-C interface and do it correctly

### The simulation tool

We are intended to learn UVM and test our RTL UART module. To do this we have to use an RTL simulation tool \(RTL simulator\).
 There are a lot of such tools so the main goal of the topic is the description of how we'll use a simulator.
 We are planned to go through the next steps:

- Write the UVM testbenches, where the Design Under Test \(the DUT\) is the RTL module
- Add the golden model above inside the testbenches via DPI-C interface and test it
- Run this testbenches inside an RTL simulator
- Get the scores and finish the tests

Aligned with the concept we plan to use Verilator as the RTL simulator.

## What we won't do

Up to the _v1.0.0_ we want to make the minimum that works. All the advanced features may become in the future versions.
 So in the scope of the _v1.0.0_ the features below aren't included in our plan:

### The RTL

- RX and TX FIFOs
- Control register
- Any of interrupts

### The golden model

- All the features we won't do in the RTL module
- Detailed simulation of the timings, latencies and other hardware-specific mechanisms
- ACSL contracts to the mechanisms above respectfully

### The RTL simulator

- Develop our own simulation tool
- Use other features except the running UVM's testbenches

