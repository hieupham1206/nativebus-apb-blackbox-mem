module blackbox1(
    input clk,
    input resetn,
    input [7:0]pwdata,
    input pwrite,
    input psel,
    input penable,
    input [7:0]paddr,
    input [7:0]data_out,
    input ready,

    output reg [7:0]prdata,
    output reg pready,
    output reg cs,
    output reg we,
    output reg re,
    output [7:0]addr,
    output reg [7:0]data_in,
    output reg [1:0]stage
);
//reg [1:0]stage;
localparam IDLE 		= 2'b00;
localparam WRITE 		= 2'b01;
localparam READ 		= 2'b10;
localparam FINISH 		= 2'b11;
assign addr = paddr;
always @(posedge clk) begin
    if(!resetn) begin
			stage	<= IDLE;
			pready	<= 1'b0;
			prdata	<= {8{1'b0}};
            cs <= 0;
            we <=0;
            re <=0;
            //addr <= 0;
		end
    else begin
        case(stage)
        IDLE: begin
            pready	<= 1'b0;
			//prdata	<= {8{1'b0}};
            cs <= 0;
            we <=0;
            re <=0;
            //addr <= 0;
            if(psel && penable && pwrite) begin
                stage <= WRITE;
            end
            else if(psel && penable && !pwrite) begin
                stage <= READ;
            end
        end
        WRITE: begin
            pready <= 1'b0;
            cs <= 1'b1;
            we <= 1'b1;
            //addr <= paddr;
            data_in <= pwdata;
            if(ready) begin
                cs <= 0;
                we <= 0;
                pready <= 1'b1;
                stage <= FINISH;
            end
            else begin
                stage <= WRITE;
            end
        end
        READ: begin
            pready <= 1'b0; 
            cs <= 1'b1;
            re <= 1'b1;
            //addr <= paddr;
            prdata <= data_out;
            if(ready) begin
                cs <=0;
                re <=0;
                pready <= 1'b1;
                stage <= FINISH;
            end
            else begin
                stage <= READ;
            end
        end
        FINISH: begin
            pready <= 1'b0;
            stage <= IDLE;
        end        
    endcase
    end
end
endmodule