`timescale 1ns/1ps

module IIR_m_tb;

reg rst;
reg clk;
reg signed[11:0] din;
wire signed[17:0] dout;
reg din_valid;
wire dout_valid;
wire dout_prevalid;

reg[15:0] cnt1,cnt2;
integer fp1,fp2;

IIR_m U(
.rst(rst),
.clk(clk),
.din(din),
.dout(dout),
.din_valid(din_valid),
.dout_valid(dout_valid),
.dout_prevalid(dout_prevalid)
);

initial begin
	rst=1;
	#40
	rst=0;
	#2
	rst=1;
end

initial begin
	clk=0;
	fp1=$fopen("data_m.txt","r");
end
always #5 clk=~clk;

always @(negedge rst,posedge clk) begin
	if(!rst) begin
		din<=12'h0;
		cnt1<=16'd1;
		din_valid<=1'b1;
	end
	else begin
		if(dout_prevalid) begin
			cnt1<=cnt1+16'd1;	
			din_valid<=1'b1;
		end
		else begin
			din_valid<=1'b0;
			cnt1<=cnt1;
		end
	end
end

always @(*) begin
	if(din_valid) begin
		$fscanf(fp1,"%d",din);
	end
end

always @(*) begin
	if(cnt1==16'd40000) begin
		din_valid<=1'b0;
		$fclose(fp1);
	end
end

initial begin
	cnt2<=16'd0;
	fp2=$fopen("data_out.txt","w");
end

always @(posedge clk) begin
	if(dout_valid) begin
		cnt2<=cnt2+16'd1;
		$fwrite(fp2,"%d\n",dout);
	end
	else begin
		cnt2<=cnt2;
	end
end

always @(*) begin
	if(cnt2==16'd40000) begin
		$fclose(fp2);
		$stop;
	end
end

endmodule
