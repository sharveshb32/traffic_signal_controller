# Traffic Signal Controller (4-Way Junction)

A Verilog RTL design of a traffic signal controller for a 4-way junction. The controller uses a finite state machine (FSM). It gives priority to ambulances. It also adapts the green light time to car presence at each road.

## Overview

The design controls traffic lights at 4 roads. Each road has one input for a car sensor and one input for an ambulance sensor. Each road has one 2-bit output for its signal light.

The controller does 3 things:

1. It cycles the green light through the 4 roads, one at a time.
2. It gives immediate priority to a road with an ambulance.
3. It skips a road's green light if no car waits there, and moves to the next road that has a car.

## Files

| File | Purpose |
|---|---|
| `traffic_4_way.v` | Main RTL module for the controller |
| `traffic_4_way_tb.v` | Testbench for simulation |

## Module Ports

**Module name:** `traffic_4_way`

| Port | Direction | Width | Description |
|---|---|---|---|
| `clk` | input | 1 bit | Clock signal |
| `rst` | input | 1 bit | Reset signal |
| `car_1`, `car_2`, `car_3`, `car_4` | input | 1 bit each | Car sensor for road 1–4 |
| `amb_1`, `amb_2`, `amb_3`, `amb_4` | input | 1 bit each | Ambulance sensor for road 1–4 |
| `sig_1`, `sig_2`, `sig_3`, `sig_4` | output reg | 2 bits each | Signal light for road 1–4 |

### Signal Codes

| Code | Light |
|---|---|
| `2'b00` | Red |
| `2'b01` | Yellow |
| `2'b11` | Green |

## FSM States

The FSM has 9 states: 1 green state and 1 yellow state for each road, plus 1 all-red state.

| State | Value | Meaning |
|---|---|---|
| `g1` | `4'b0000` | Green for road 1 |
| `g2` | `4'b0001` | Green for road 2 |
| `g3` | `4'b0010` | Green for road 3 |
| `g4` | `4'b0011` | Green for road 4 |
| `y1` | `4'b0100` | Yellow for road 1 |
| `y2` | `4'b0101` | Yellow for road 2 |
| `y3` | `4'b0110` | Yellow for road 3 |
| `y4` | `4'b0111` | Yellow for road 4 |
| `r1` | `4'b1111` | Default all-red state |

At reset, the FSM starts at state `g1`.

## Timing Parameters

| Parameter | Value | Meaning |
|---|---|---|
| `gtime` | 20 clock cycles | Duration of each green state |
| `ytime` | 3 clock cycles | Duration of each yellow state |

An internal 5-bit `timer` counts clock cycles inside the current state. The controller resets the timer to 0 at each state change.

## Control Logic

The next-state logic follows this order:

1. **Check ambulance sensors first.** If any `amb_x` input is high, the FSM moves directly to the green state for that road, regardless of the current state or timer value.
2. **If no ambulance is present, run the normal cycle.** Each green state holds until `timer >= gtime`, then moves to the matching yellow state. Each yellow state holds until `timer >= ytime`, then checks the car sensors of the other 3 roads in a fixed order and moves to the first road with a car present. If no other road has a car, the FSM returns to the same road's green state.

This design means:
- An ambulance sensor overrides the normal cycle at any time.
- A road with no car waiting is skipped, so the cycle does not waste green time on an empty road.

## Simulation

The testbench `traffic_4_way_tb.v` instantiates `traffic_4_way` and drives the `clk`, `rst`, `car_x`, and `amb_x` inputs to exercise the FSM.

To simulate with Xilinx Vivado:

1. Create a new project in Vivado.
2. Add `traffic_4_way.v` as a design source.
3. Add `traffic_4_way_tb.v` as a simulation source.
4. Run behavioral simulation.
5. Check the `sig_1`–`sig_4` outputs on the waveform viewer.

