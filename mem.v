module mem
#(
	parameter DATA_WIDTH=8,
	parameter ADDR_WIDTH=8
)
(
input resetn,
input clk,
input cs,
input we,
input re,
//input mresetn
input [DATA_WIDTH-1:0]data_in,
input [ADDR_WIDTH-1:0]addr,
output reg [DATA_WIDTH-1:0]data_out,
output reg ready

,output reg [2:0] stage
);

reg [7:0]mem [0:2**ADDR_WIDTH-1];
//wire [7:0]mem_connect [0:2^^(ADDR_WIDTH-1)];
//assign mem_connect=mem;
// reg [2:0]stage;
localparam IDLE	 = 2'b00;
localparam WRITE = 2'b01;
localparam READ  = 2'b10;
localparam FINISH  = 2'b11;

always @(posedge clk) begin	
if(!resetn) begin
	stage <= IDLE;
end
else begin
case(stage)
	IDLE: begin
		//ready <= 1'b0;
		if(cs&we) begin
		
		stage <= WRITE;
		end
		else if(cs&re) begin
		
		stage <= READ;
		end
		else begin stage <= IDLE; end
	end
	WRITE: begin
	    //ready <= 1'b0;
		mem[addr] <= data_in;
		ready <= 1'b1;
		stage <= FINISH;
	end
	READ: begin
	    //ready <= 1'b0;
		data_out <= mem[addr];
		ready <= 1'b1;
		stage <= FINISH;
	end
	FINISH: begin
		ready <= 1'b0;
		stage <= IDLE;
	end
endcase
end
end

endmodule