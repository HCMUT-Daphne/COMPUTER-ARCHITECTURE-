`include "../00_src/vending_machine.sv"
`include "../01_tb/vending_machine_tb.sv"

module sim (
	input clock_tb
);
	vending_machine dut(
		.clock_tb(clock_tb)
	);

endmodule
