
module tb1();

    reg clk;

    wire [31:0] result;
    wire [7:0] pc;
    wire [5:0] opcode;
    wire [4:0]a,b,c;
    wire [5:0]d;
    wire [31:0]aumen16;
    wire over;
    datapath core_1(clk,opcode,pc,result,a,b,c,d,aumen16,over);

    integer i;

    initial
        begin
            clk = 0;
            for (i = 0; i < 128; i = i + 1)
                begin
                    #5 clk =~ clk;
                end
        end

    integer j = 0;

    always @(*) begin
        if (clk == 0&&opcode==6'd0) begin
            case (d)
                6'b100000: 
                    begin
                    $monitor("fun r-add ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b Regisen2: %b Regisguar:%b función: %b overflow: %b",clk,result,pc,opcode,a,b,c,d,over);
                    j = j + 1;
                    end
                6'b100010:
                    begin
                    $monitor("fun r-sub ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b Regisen2: %b Regisguar:%b función: %b overflow: %b",clk,result,pc,opcode,a,b,c,d,over);
                    j = j + 1;
                    end
                6'b100100:
                    begin
                    $monitor("fun r-and ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b Regisen2: %b Regisguar:%b función: %b overflow: 0",clk,result,pc,opcode,a,b,c,d);
                    j = j + 1;
                    end
                6'b100111:
                    begin
                    $monitor("fun r-nor ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b Regisen2: %b Regisguar:%b función: %b overflow: 0",clk,result,pc,opcode,a,b,c,d);
                    j = j + 1;
                    end
                6'b100101:
                    begin
                    $monitor("fun r-or ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b Regisen2: %b Regisguar:%b función: %b overflow: 0",clk,result,pc,opcode,a,b,c,d);
                    j = j + 1;
                    end
                6'b101010:
                    begin
                    $monitor("fun r-slt ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b Regisen2: %b Regisguar:%b función: %b overflow: 0",clk,result,pc,opcode,a,b,c,d);
                    j = j + 1;
                    end
            endcase
        end
        else
        begin
            if(clk == 0&&(opcode==6'b001000||opcode==6'b001001||opcode==6'b001100||opcode==6'b001101||opcode==6'b001010)) begin
                case (opcode)
            6'b001000:
                    begin 
                    $monitor("fun i-addi ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b aumentado: %d Regisguar:%b overflow: %b",clk,result,pc,opcode,a,aumen16,b,over);
                    j = j + 1;  
                    end
                  
            6'b001001:
                    begin 
                    $monitor("fun i-subbi ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b aumentado: %d Regisguar:%b overflow: %b",clk,result,pc,opcode,a,aumen16,b,over);
                    j = j + 1;  
                    end
                    
            6'b001101:
                    begin 
                    $monitor("fun i-ori ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b aumentado: %d Regisguar:%b overflow: 0",clk,result,pc,opcode,a,aumen16,b);
                    j = j + 1;  
                    end

            6'b001010:
                    begin 
                    $monitor("fun i-slti ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b aumentado: %d Regisguar:%b overflow: 0",clk,result,pc,opcode,a,aumen16,b);
                    j = j + 1;  
                    end

            6'b001100:
                    begin 
                    $monitor("fun i-andi ..Clock: %b Result: %d PC: %d Opcode: %b Regisen1: %b aumentado: %d Regisguar:%b overflow: 0",clk,result,pc,opcode,a,aumen16,b);
                    j = j + 1;  
                    end
                endcase
                
            end
            else
                begin
                    if (clk == 0&&(opcode==6'b000100||opcode==6'b000101||opcode==6'b000001||opcode==6'b000011||opcode==6'b000111||opcode==6'b000010)) begin
                    case (opcode)
                        6'b000100: 
                        begin
                            $monitor("fun beq ..Clock: %b PC: %d Opcode: %b cargado %d",clk,pc,opcode,aumen16);
                            j = j + 1;   
                        end
                        6'b000101: 
                        begin
                            $monitor("fun bne ..Clock: %b PC: %d Opcode: %b cargado %d",clk,pc,opcode,aumen16);
                            j = j + 1;   
                        end
                        6'b000001: 
                        begin
                            $monitor("fun bgez ..Clock: %b PC: %d Opcode: %b cargado %d",clk,pc,opcode,aumen16);
                            j = j + 1;   
                        end
                        6'b000010: 
                        begin
                            $monitor("fun j ..Clock: %b PC: %d Opcode: %b cargado %d",clk,pc,opcode,aumen16);
                            j = j + 1;   
                        end
                        6'b000011: 
                        begin
                            $monitor("fun jal ..Clock: %b PC: %d Opcode: %b cargado %d",clk,pc,opcode,aumen16);
                            j = j + 1;   
                        end
                        6'b000111: 
                        begin
                            $monitor("fun jr ..Clock: %b PC: %d Opcode: %b cargado %d",clk,pc,opcode,aumen16);
                            j = j + 1;   
                        end
                    endcase
                    end
                    else
                    begin
                        if(clk == 0&&(opcode==6'b100000||opcode==6'b100001||opcode==6'b100011||opcode==6'b101000||opcode==6'b000111||opcode==6'b000010||opcode==6'b101011))begin
                            case (opcode)
                                6'b100000: 
                                begin
                                $monitor("fun lb ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                                6'b100001:
                                begin 
                                $monitor("fun lh ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                                6'b100011: 
                                begin
                                $monitor("fun lw ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                                6'b101000: 
                                begin
                                $monitor("fun sb ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                                6'b000010: 
                                begin
                                $monitor("fun sh ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                                6'b101011: 
                                begin
                                $monitor("fun sw ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                                6'b001111: 
                                begin
                                $monitor("fun lui ..Clock: %b PC: %d Opcode: %b Regisen: %b Valor cargado: %d",clk,pc,opcode,c,result);
                                j = j + 1; 
                                end
                            endcase
                        end
                        else
                        $monitor("");
                    end
                end
            end
        end

endmodule