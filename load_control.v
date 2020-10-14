module load_control(
    input [31:0] read_data,
    output [31:0] Load_output,
    input [2:0] inst,
    input [31:0] ALUresult
);
reg Load_output;
always @(*) begin
    case(inst)
    3'b010:Load_output=read_data;
    3'b001:begin
        if(ALUresult[1]) begin
            Load_output={{16{read_data[31]}},read_data[31:16]};
        end
        else begin
            Load_output={{16{read_data[15]}},read_data[15:0]};
        end
    end
    3'b101:begin
        if(ALUresult[1]) begin
            Load_output={{16{1'b0}},read_data[31:16]};
        end
        else begin
            Load_output={{16{1'b0}},read_data[15:0]};
        end
    end
    3'b000: begin
        case(ALUresult[1:0])
        2'b00:Load_output={{24{read_data[7]}},read_data[7:0]};
        2'b01:Load_output={{24{read_data[15]}},read_data[15:8]};
        2'b10:Load_output={{24{read_data[23]}},read_data[23:16]};
        2'b11:Load_output={{24{read_data[31]}},read_data[31:24]};
        endcase
    end
    3'b100:begin
        case(ALUresult[1:0])
        2'b00:Load_output={{24{1'b0}},read_data[7:0]};
        2'b01:Load_output={{24{1'b0}},read_data[15:8]};
        2'b10:Load_output={{24{1'b0}},read_data[23:16]};
        2'b11:Load_output={{24{1'b0}},read_data[31:24]};
        endcase
    end
    endcase
end
endmodule