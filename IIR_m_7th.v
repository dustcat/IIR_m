module IIR_m_7th(
rst,
clk,
din,
dout,
din_valid,
dout_valid
);

parameter b0=78401;
parameter b1=0;
parameter b2=-78401;
parameter a1=-31496;
parameter a2=9456;


input rst;
input clk;
input signed[17:0] din;
input din_valid;

output signed[17:0] dout;
output dout_valid;

reg[4:0] cState,nState;
reg signed[17:0] x_reg0;
reg signed[17:0] x_reg1;

reg signed[35:0] x_mul1;
reg signed[35:0] x_mul2;
reg signed[35:0] x_mul3;

wire signed[35:0] x_int_mul1;
wire signed[35:0] x_int_mul2;
wire signed[35:0] x_int_mul3;

reg signed[35:0] x_sum;
//wire signed[17:0] x_temp;

reg signed[17:0] y_reg0;
reg signed[17:0] y_reg1;

reg signed[35:0] y_mul1;
reg signed[35:0] y_mul2;

wire signed[35:0] y_int_mul1;
wire signed[35:0] y_int_mul2;

reg signed[35:0] y_sum;
//wire signed[17:0] y_temp;

reg signed[35:0] dout_sum;
wire signed[17:0] dout_temp;

always @(negedge rst,posedge clk) begin
        if(!rst) begin
                cState<=0;
        end
        else begin
                cState<=nState;                
        end
end

always @(*) begin
        case(cState)
                0:if(din_valid) begin
                        nState<=1;
                  end
                  else begin
                        nState<=0;
                  end
                1:nState<=2;
                2:nState<=3;
                3:nState<=4;
                4:nState<=5;
                5:nState<=6;
                6:nState<=0;
                default:nState<=nState;
        endcase
end

always @(*) begin
        if(rst) begin
                case(cState)
                        1:x_mul1=b0*din;
                        2:begin
                                x_mul2=b1*x_reg0;
                                y_mul1=a1*y_reg0;
                        end
                        3:begin
                                x_mul3=b2*x_reg1;
                                y_mul2=a2*y_reg1;
                        end
                        4:begin
                                x_sum=x_int_mul1+x_int_mul2+x_int_mul3;
                                y_sum=y_int_mul1+y_int_mul2;
                        end
                        5:dout_sum=x_sum-y_sum;
                        default:;
                endcase
        end
end

always @(cState) begin
        if(rst) begin
                if(cState==4) begin
                        x_reg0<=din;
                        x_reg1<=x_reg0;
                end
                else begin
                        x_reg0<=x_reg0;
                        x_reg1<=x_reg1;
                end
        end
        else begin
                x_reg0<=18'd0;
                x_reg1<=18'd0;
        end
end

always @(cState) begin
        if(rst) begin
                if(cState==6) begin
                        y_reg0<=dout;
                        y_reg1<=y_reg0;
                end 
                else begin
                        y_reg0<=y_reg0;
                        y_reg1<=y_reg1;
                end
        end
        else begin
                y_reg0<=18'd0;
                y_reg1<=18'd0;
        end
end

assign x_int_mul1=x_mul1;
assign x_int_mul2=x_mul2;
assign x_int_mul3=x_mul3;
//assign x_temp=(x_sum[19:17]==3'b000||x_sum[19:17]==3'b111)?x_sum[17:0]:(x_sum[19])?18'h20000:18'h1ffff;
//
assign y_int_mul1=y_mul1;
assign y_int_mul2=y_mul2;
//assign y_temp=(y_sum[18:17]==2'b00||y_sum[18:17]==2'b11)?y_sum[17:0]:(y_sum[18])?18'h20000:18'h1ffff;
//
//assign dout_temp=(dout_sum[18:17]==2'b00||dout_sum[18:17]==2'b11)?dout_sum[17:0]:(dout_sum[18])?18'h800:18'h7ff;
//assign dout=(!rst)?18'd0:dout_temp;
//
//assign dout_valid=(cState==6 && nState==0)?1'b1:1'b0;



assign dout_temp=dout_sum[33:16];
assign dout=(!rst)?18'd0:dout_temp;

assign dout_valid=(cState==6 && nState==0)?1'b1:1'b0;

endmodule

