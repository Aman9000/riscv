module ALUControl(
    input [1:0] ALUOp,
    input [31:0] instr,
    //output[5:0] opcode,
    input [31:0] data1,
    input [31:0] data2,
    input imm,
    output zero,
    output [31:0] ALUresult
);
//reg opcode;
reg ALUresult;reg zero;
always @(*) begin
    case(ALUOp)
    2'b00: ALUresult=(data1)+(data2);
    2'b01: begin
        case(instr[14:12])
        3'b000:begin
            
            zero=($signed(data1)==$signed(data2));
        end
        3'b001: begin
            
            zero=!(($signed(data1)==$signed(data2)));
        end
        3'b100: begin
            zero=(data1<data2);
        end
        3'b110:zero=($unsigned(data1)<$unsigned(data2));
        3'b101:zero=($signed(data1)>=$signed(data2));
        3'b111:zero=($unsigned(data1)>=$unsigned(data2));
    endcase
    end 
        //ALUresult=data1-data2;
        //zero=ALUresult;
    2'b10:begin
       
        case(instr[14:12])
            3'b000:begin
                if(imm==1) begin
                    ALUresult=data1+data2;
            end
            else begin
                if(instr[30]==0) begin
                    ALUresult=data1+data2;
                end
                else begin
                    ALUresult=data1-data2;
                end

            end
            end
            3'b010:ALUresult=($signed(data1)<$signed(data2));
            3'b011:ALUresult=(data1<data2);
            3'b100:ALUresult=data1^data2;
            3'b110:ALUresult=data1|data2;
            3'b111:ALUresult=data1&data2;
            3'b001:ALUresult=data1<<data2[4:0];
            3'b101:begin
                if(instr[31:25]==0) begin
                    ALUresult=data1>>data2[4:0];
                end
                else begin
                    ALUresult=data1>>>data2[4:0];
                end
            end
            
            endcase
        
    
    
    end
    endcase
end

endmodule 