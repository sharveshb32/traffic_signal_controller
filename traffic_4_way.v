`timescale 1ns / 1ps
module traffic_4_way(input rst,input clk,input amb_1,amb_2,amb_3,amb_4,car_1,car_2,car_3,car_4,
output reg[1:0]sig_1,sig_2,sig_3,sig_4);
parameter red=2'b00,yellow=2'b01,green=2'b11;
reg [3:0]curr_state,next_state;
parameter gtime=5'd20,ytime=2'd3;
reg[4:0] timer;
parameter g1=4'b0000,g2=4'b0001,g3=4'b0010,g4=4'b0011,y1=4'b100,y2=4'b0101,y3=4'b0110,y4=4'b0111,r1=4'b1111;
always @(posedge clk or rst)
begin
    if(rst)
    begin 
        timer<=0;
        curr_state<=g1;
    end
    else
    if(curr_state!=next_state)
    begin
        timer<=0;
        curr_state=next_state;
    end
    else
        timer<=timer+1;    
end

always @(*)
begin
    next_state=curr_state;
    if(amb_1) next_state=g1;
    else if(amb_2) next_state=g2;
    else if(amb_3) next_state=g3;
    else if(amb_4) next_state=g4;
    else
    begin
    case (curr_state)
    
    g1:if(timer>=gtime)next_state=y1;
    y1:if(timer>=ytime)
        begin
        if(car_2) next_state=g2;
        else if(car_3) next_state=g3;
        else if(car_4) next_state=g4;
        else next_state=g1;
        end
    g2:if(timer>=gtime)next_state=y2;
    y2:if(timer>=ytime)
        begin
        if(car_3) next_state=g3;
        else if(car_4) next_state=g4;
        else if(car_1) next_state=g1;
        else next_state=g2;
        end
    g3:if(timer>=gtime)next_state=y3;
    y3:if(timer>=ytime)
        begin
        if(car_4) next_state=g4;
        else if(car_1) next_state=g1;
        else if(car_2) next_state=g2;
        else next_state=g3;
        end
    g4:if(timer>=gtime)next_state=y4;
    y4:if(timer>=ytime)
        begin
        if(car_1) next_state=g1;
        else if(car_2) next_state=g2;
        else if(car_3) next_state=g3;
        else next_state=g4;
        end
    default:next_state=r1;
    endcase
    end
end
always @(*)
begin
    sig_1=red;
    sig_2=red;
    sig_3=red;
    sig_4=red;
    case(curr_state)
    g1: 
        begin 
        sig_1=green;
        sig_2=red;
        sig_3=red;
        sig_4=red;
        end
    y1: 
        begin 
        sig_1=yellow;
        sig_2=red;
        sig_3=red;
        sig_4=red;
        end
    g2: 
        begin 
        sig_1=red;
        sig_2=green;
        sig_3=red;
        sig_4=red;
        end
    y2: 
        begin 
        sig_1=red;
        sig_2=yellow;
        sig_3=red;
        sig_4=red;
        end
    g3: 
        begin 
        sig_1=red;
        sig_2=red;
        sig_3=green;
        sig_4=red;
        end
    y3: 
        begin 
        sig_1=red;
        sig_2=red;
        sig_3=yellow;
        sig_4=red;
        end
    g4: 
        begin 
        sig_1=red;
        sig_2=red;
        sig_3=red;
        sig_4=green;
        end
    y4: 
        begin 
        sig_1=red;
        sig_2=red;
        sig_3=red;
        sig_4=yellow;
        end
    r1: 
        begin 
        sig_1=red;
        sig_2=red;
        sig_3=red;
        sig_4=red;
        end
        
    endcase
        
end

endmodule
