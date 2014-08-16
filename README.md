#Open Logic Analyzer
A synthesizable, internal, FPGA-tested, Verilog 16-bit logic analyzer that comes bundled with a Python2.7-based controller and a (swappable) serial interface

Written during the 2014 edition of the Ideas and Projects Workshop, Tirgu Mures, Romania.

###Usage

Add the module, assign the monitored bits to DATA_IN, then send a command

Size of memory 1KB (configurable)

###Commands (1 byte each)

Value | Effect
---------|-------
0x01| SET TRIG CONDITION (waits for another 4 bytes)
0x02 | CHECK TRIGGERED (returns 1 byte)
0x03 | FORCE TRIGGER
0x04 | READ DATA (dumps the RAM onto the communication interface)

###TRIG_DATA format
2-byte mask, 2-byte target value

e.g.

MASK  | TARGET_VALUE
--------------- | ----------------
00000001 00000001  | 00000000 00000001
bytes 1 and 2 | bytes 3 and 4

will trigger when DATA_IN[0] is 1 and DATA_IN[8] is 0, ignoring the other values

Uses the RS232_INTERFACE by akram.mashni available at http://opencores.org/project,rs232_interface

Copyright (C) 2014 Alexandru Ioan Pop

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
