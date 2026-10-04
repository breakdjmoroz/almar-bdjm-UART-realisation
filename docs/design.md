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

# The project's UART Specification

The main principles of the UART interface say:

- There are two information lines \(Receive port - RX and Transmitt port - TX\) and one electrical ground \(GND\) line
- The default value on the information line is HIGH \(logical 1\)
- To declare the transmitting use the start bit that always LOW \(logical 0\)
- After the start of the transmitting there is the series of informational bits \(from 5 to 9 bits\)
- At the end of the series there is always the stop bit that should equals HIGH
- If the stop bit doesn't equals HIGH, a transmitting error registers
- The information exchange process is the time-based one, so it uses timer for receiving/transmitting data
- The speed of the receiving/transmitting is measured in bits per second or bauds and may be
 300; 600; 1200; 2400; 4800; 9600; 19 200; 38 400; 57 600; 115 200; 230 400; 460 800; 921 600 bauds.

There are some advanced features of the UART interface, but to the _v1.0.0_ above ones are enough.

To keep the simplicity of the project we will use the fixed configuration:

- Only 1 start bit
- 8 info bits
- Only 1 stop bit
- Speed is 9600 bauds

So the information frame looks like this:

```
┌───┬────┬────┬────┬────┬────┬────┬────┬────┬───┐
│ 0 │ x0 │ x1 │ x2 │ x3 │ x4 │ x5 │ x6 │ x7 │ 1 │
└───┴────┴────┴────┴────┴────┴────┴────┴────┴───┘
 --- --------------------------------------- ---
 ^                     ^                     ^
 start                info                  stop
 bit                  bits                   bit
```

A byte to send/obtain starts from the last significant bit \(x0\) in the sequence.
 For example byte 0x2A is 0b**0**010**1**010 And the frame will be _0 0101 0100 1_.

And the tick period is _1 / speed = 1 / 9600 ≈_ **104,167 μsec**

An information byte a frame will be formed from on transmitting is stored in the TX\_REG register.
 An information byte, that is formed from a received frame is stored in the RX\_REG register.

There is the STATUS_REG register, that contains some info about the receiving/transmitting process:

```
_8_                                 _0_
┌───┬───┬───┬───┬────┬────┬────┬────┐
│ 0 │ 0 │ 0 │ 0 │ DL │ TS │ RF │ FE │
└───┴───┴───┴───┴────┴────┴────┴────┘
```

_Where:_

0. FRAME\_ERROR bit - _claims 1, when the stop bit of a frame isn't HIGH; claims 0 if there are no any errors_
1. RECEIVE\_FULL bit - _claims 1, when the RX gets a frame and writes it to RX\_REG; claims 0, when the RX\_REG is red_
2. TRANSMITT\_START bit - _claims 1, when there is a write to TX\_REG and the transmitting is started;
 when transmitting is finished, returns to 0_
3. DATA\_LOST bit - _claims 1, when either the RF bit is 1 and the next frame comes or the TS bit is 1 and there is a write to TX\_REG.
 It doesn't block the process, when set to 1. Becomes 0 after a read._
4. RESERVED, always 0
5. RESERVED, always 0
6. RESERVED, always 0
7. RESERVED, always 0

The TX_REG is **write-only**. The RX_REG and STATUS_REG are **read-only**.

The register map of the UART model:


| TX_REG | UART_BASE_ADDR + 0x00 |
| RX_REG | UART_BASE_ADDR + 0x01 |
| STATUS_REG | UART_BASE_ADDR + 0x02 |

_Where UART\_BASE\_ADDR is specified by developers of a full computer system._

There is the vision of the UART block on the diagram below:

```
┌─────────────────────────────────────┐
│            UART                     │
│   ┌─────────────────────────┐       │
│   │      REG_WINDOW         │       │
│   │  ┌───────────────┐      │       │
│   │  │   TX_REG     ─┼──────┼▶ TX ──┼──▶
│   │  ├───────────────┤      │       │
│   │  │   RX_REG     ◀┼──────┼─ RX ◀─┼───
│   │  ├───────────────┤      │       │
│   │  │   STATUS_REG  │      │  GND ─┼───
│   │  │ ┌──┬──┬──┬──┐ │      │       │
│   │  │ │FE│RF│TS│DL│ │      │       │
│   │  │ └──┴──┴──┴──┘ │      │       │
│   │  └───────────────┘      │       │
│   └─────────────────────────┘       │
└─────────────────────────────────────┘
```

The default state of all the registers is all bits are zeros.
