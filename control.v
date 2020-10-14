module control(
    
    input [2:0] ins,
    output branch ,
    input [1:0] waddr,
    output imm,
    output store,
    //output MemRead ,
    output MemtoReg ,
    output [1:0] ALUOp ,
    output [3:0] MemWrite ,
    output ALUSrc ,
    output RegWrite,
    output lui,
    output auipc,
    input [6:0] opcode
);
    reg branch ;reg store;
    //reg MemRead ;
    reg MemtoReg ;
    reg ALUOp ;
    reg MemWrite ;
    reg ALUSrc ;
    reg RegWrite;
    reg imm;
    reg lui;
    reg auipc;
    always @(*) begin
    case(opcode)
    7'b0110011: begin
        branch=0;
        MemWrite=4'b0000;
        ALUOp=2'b10;
        store=0;
        lui=0;
        auipc=0;
        //MemRead=0;
        RegWrite=1;
        MemtoReg=0;
        ALUSrc=0;
        imm=0;
    end
    7'b0010011:begin
        branch=0;
        store=0;
        MemWrite=4'b0000;
        ALUOp=2'b10;
        //MemRead=0;
        RegWrite=1;
        MemtoReg=0;
        auipc=0;
        lui=0;
        ALUSrc=1;
        imm=1;
    end
    //Load Instructions
    7'b0000011:begin
         branch=0;
        MemWrite=4'b0000;
        ALUOp=2'b00;
        store=0;
        //MemRead=1;
        RegWrite=1;
        MemtoReg=1;
        auipc=0;
        ALUSrc=1;
        lui=0;
        imm=0;
    end
    //Store Instructions
    7'b0100011: begin
         branch=0;
         case(ins)
         3'b010:MemWrite=4'b1111;
         3'b001:begin
             case(waddr[1])
             0:MemWrite=4'b0011;
             1:MemWrite=4'b1100;
             endcase
         end
         3'b000:begin
             case(waddr)
             2'b00:MemWrite=4'b0001;
             2'b01:MemWrite=4'b0010;
             2'b10:MemWrite=4'b0100;
             2'b11:MemWrite=4'b1000;
             endcase
         end
    endcase
        ALUOp=2'b00;
        //MemRead=0;
        RegWrite=0;
        store=1;
        lui=0;
        auipc=0;
        ALUSrc=1;
        imm=0;
    end
    //Branch instructions
    7'b1100011: begin
         branch=1;
         store=1;
        MemWrite=4'b0000;
        ALUOp=2'b01;
        //MemRead=0;
        RegWrite=0;
        lui=0;
        auipc=0;
        ALUSrc=0;
        imm=0;
    end
    7'b0110111:begin
        RegWrite=1;
        lui=1;
        MemtoReg=1;
        auipc=0;
    end
    7'b0010111: begin
        RegWrite=1;
        lui=0;
        MemtoReg=1;
        auipc=1;
    end
    7'b1101111:begin
        branch=0;
        RegWrite=1;lui=0;auipc=0;
        
        
    end
    7'b1100111:begin
        branch=0;RegWrite=1;
        lui=0;
        auipc=0;
        ALUOp=2'b00;
        store=0;
        ALUSrc=1;
        MemtoReg=1;
    end
    7'b0000000:begin
        branch=0;
    end
    endcase
end
endmodule
