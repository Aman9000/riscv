module regfile(
    input [4:0] rs1,     // address of first operand to read - 5 bits READ_REGISTER1
    input [4:0] rs2,     // address of second operand  READ_REGISTER2
    input [4:0] rd,      // address of value to write  WRITE_REGISTER
    input reset,
    input we,            // should write update occur  REG_WRITE
    input [31:0] wdata,  // value to be written        WRITE_DATA
    output [31:0] rv1,   // First read value           READ_DATA1
    output [31:0] rv2,   // Second read value          READ_DATA2
    input clk           // Clock signal - all changes at clock posedge
);
  
    wire [31:0] r0;wire [31:0] r31;wire [31:0] r1;wire [31:0] r2;wire [31:0] r4;wire [31:0] r5;wire [31:0] r6;wire [31:0] r7;wire [31:0] r3;
    assign r0=registers[0];assign r31=registers[31];assign r1=registers[1];assign r2=registers[2];assign r3=registers[3];
    assign r4=registers[4];assign r5=registers[5];assign r6=registers[6];assign r7=registers[7];
    // Desired function
    // rv1, rv2 are combinational outputs - they will update whenever rs1, rs2 change
    // on clock edge, if we=1, regfile entry for rd will be updated
    
    integer i;
    reg[31:0] registers[31:0];
    initial
    begin
        //$dumpfile("regfile.vcd");
	//$dumpvars(0, regfile);
        for(i=0;i<32;i=i+1) begin
            registers[i]=0;
        end
    end
   
    assign rv1=registers[rs1];
    assign rv2=registers[rs2];
    always @(posedge clk) begin
        if((we==1)) begin
            if(rd!=0) registers[rd]<=wdata;
            else registers[rd]<=0;  
        end
          
      
        
    end
    //assign rv1 = 'h12345678;
    //assign rv2 = 'h87654321;


endmodule