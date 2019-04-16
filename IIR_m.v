module IIR_m(
rst,
clk,
din,
dout,
din_valid,
dout_valid,
dout_prevalid
);
input rst;
input clk;
input signed[11:0] din;
input din_valid;
output reg signed[17:0] dout;
output reg dout_valid;
output dout_prevalid;

wire signed[17:0] din1;
wire signed[17:0] dout1;
wire signed[17:0] dout2;
wire signed[17:0] dout3;
wire signed[17:0] dout4;
wire signed[17:0] dout5;
wire signed[17:0] dout6;
wire signed[17:0] dout_reg;

wire din_valid1;
wire dout_valid1;
wire din_valid2;
wire dout_valid2;
wire din_valid3;
wire dout_valid3;
wire din_valid4;
wire dout_valid4;
wire din_valid5;
wire dout_valid5;
wire din_valid6;
wire dout_valid6;
wire din_valid7;
wire dout_valid7;

assign din1 = {din, 6'b000000};
assign din_valid1=din_valid;
assign din_valid2=dout_valid1;
assign din_valid3=dout_valid2;
assign din_valid4=dout_valid3;
assign din_valid5=dout_valid4;
assign din_valid6=dout_valid5;
assign din_valid7=dout_valid6;

assign dout_prevalid=dout_valid1;

IIR_m_1st U1(
.rst(rst),
.clk(clk),
.din(din1),
.dout(dout1),
.din_valid(din_valid1),
.dout_valid(dout_valid1)
);

IIR_m_2nd U2(
.rst(rst),
.clk(clk),
.din(dout1),
.dout(dout2),
.din_valid(din_valid2),
.dout_valid(dout_valid2)
);

IIR_m_3rd U3(
.rst(rst),
.clk(clk),
.din(dout2),
.dout(dout3),
.din_valid(din_valid3),
.dout_valid(dout_valid3)
);

IIR_m_4th U4(
.rst(rst),
.clk(clk),
.din(dout3),
.dout(dout4),
.din_valid(din_valid4),
.dout_valid(dout_valid4)
);

IIR_m_5th U5(
.rst(rst),
.clk(clk),
.din(dout4),
.dout(dout5),
.din_valid(din_valid5),
.dout_valid(dout_valid5)
);

IIR_m_6th U6(
.rst(rst),
.clk(clk),
.din(dout5),
.dout(dout6),
.din_valid(din_valid6),
.dout_valid(dout_valid6)
);

IIR_m_7th U7(
.rst(rst),
.clk(clk),
.din(dout6),
.dout(dout_reg),
.din_valid(din_valid7),
.dout_valid(dout_valid7)
);

always @(negedge rst,posedge clk) begin
	if(!rst) begin
		dout<=18'd0;
		dout_valid=1'b0;
	end
	else if(dout_valid7) begin
		dout_valid=1'b1;
		dout<=dout_reg;	
	end
	else begin
		dout<=dout;
		dout_valid=1'b0;
	end
end

endmodule
