module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
    reg [31:0] iaddr;
    reg [31:0] daddr;
    reg [31:0] dwdata;
    reg [3:0]  dwe;
    wire store;
    reg [31:0] write_data;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    reg [31:0] data2;
    wire [31:0] ALUresult;
    wire [31:0] Load_output;
    //wire [31:0] Store_output;
    wire branch ;
    //wire MemRead ;
    wire MemtoReg ;
    wire [1:0] ALUOp ;
    wire [3:0] MemWrite ;
    wire ALUSrc ;
    wire RegWrite;
    wire auipc;
    //wire we;
    wire imm;
    wire [31:0] offset;
    wire zer0;
    wire lui;
    regfile r1(.reset(reset),.rs1(idata[19:15]),.rs2(idata[24:20]),.rd(idata[11:7]),.we(RegWrite),.clk(clk),.wdata(write_data),.rv1(read_data1),.rv2(read_data2));
    control c1(.auipc(auipc),.lui(lui),.waddr(ALUresult[1:0]),.MemtoReg(MemtoReg),.store(store),.opcode(idata[6:0]),.ins(idata[14:12]),.branch(branch),.ALUOp(ALUOp),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.imm(imm));
    ALUControl a1(.zero(zero),.ALUOp(ALUOp),.instr(idata),.data1(read_data1),.data2(data2),.imm(imm),.ALUresult(ALUresult));
    load_control l1(.read_data(drdata),.Load_output(Load_output),.inst(idata[14:12]),.ALUresult(ALUresult));
    assign offset={{20{idata[31]}},idata[7],idata[30:25],idata[11:8],{1{1'b0}}};
    //MUX 1
    //assign we= RegWrite&!reset;
    always @(*) begin
       
    if(ALUSrc==0) begin
         data2=read_data2;
    end
    else begin
         if(store==0) begin
             if(idata[6:0]==7'b1100111) begin
             data2={{20{idata[31]}},idata[30:25],idata[24:21],idata[20]};
             end
             else begin 
                 data2={{20{idata[31]}},idata[31:20]};
             end
         end
         else begin
             data2={{20{idata[31]}},idata[31:25],idata[11:7]};
         end
         
    end
    //MUX 2
    if(MemtoReg==0) begin
         write_data=ALUresult;
    end 
    else begin
        if(lui==0) begin
            if(auipc==0) begin
                if((idata[6:0]==7'b1101111)||(idata[6:0]==7'b1100111)) begin
                    write_data=iaddr+4;
                end
                
                else begin
         write_data=Load_output;// from the load control
                end
            end
            else begin
                write_data=iaddr+{idata[31:12],{12{1'b0}}};
            end
        end
        else begin
            write_data={idata[31:12],{12{1'b0}}};
        end
    end
    dwe=MemWrite;
    daddr=ALUresult;
    dwdata=read_data2;
    end
     
    //assign drdata=read_data2;
     
    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
            daddr <= 0;
            dwdata <= 0;
            dwe <= 0;
        end else begin
            if(branch&zero) begin
             
            iaddr <= iaddr + offset;
            end
            else begin
                if(idata[6:0]==7'b1101111)
             iaddr<=iaddr+{{12{idata[31]}},idata[19:12],idata[20],idata[30:25],idata[24:21],{1{1'b0}}};
             else if(idata[6:0]==7'b1100111)
             iaddr<=ALUresult;
             else
            iaddr<=iaddr+4;    
            end
            
        end
    end

endmodule