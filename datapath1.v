module datapath(clk,opcode,pcin,impress1,regisinposi1,regisinposi2,regisouposi1,intention,aumentado,overflow);
    input clk;
    output reg [31:0]impress1;
    reg [31:0]outins_mem;//salida del intruccion memmory
    output reg [4:0]regisinposi1,regisinposi2,regisouposi1;
    output reg overflow;
    reg [32:0]temp_over;
    reg [15:0]inmediate;
    output reg [5:0]opcode; 
    output reg [31:0]aumentado;
    reg bit;
    output reg [7:0]pcin = 8'b00000000;
    reg [25:0]jassign; 
    reg [7:0]jr;
    reg [31:0]jumps;
    output reg [5:0]intention; //funcion específica
    reg [23:0]load ; //funciones l
    reg [31:0]templ; //extraccón del regfile
    reg [31:0]reg_file_tempsave;//temporal de carga para data memmory
    reg [1:0] aumenj = 2'b00;
    reg [25:0] jinicial,jtemp;
    reg [7:0] data_mem [0:255];
    reg [31:0] reg_file [0:31];
    reg [7:0] ins_mem [0:255];

    initial begin
        $readmemb("datamem.txt", data_mem);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        $readmemh("contenregis.txt", reg_file);                                                                                                                                                                                                                                                                                                                                                     
        $readmemb("instruction.txt", ins_mem);                                                
    end        
           
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always@(posedge clk)
         begin
            outins_mem={ins_mem[pcin],ins_mem[pcin+1],ins_mem[pcin+2],ins_mem[pcin+3]};
            opcode = {outins_mem[31:26]};
            bit = outins_mem[15];
            inmediate={outins_mem[15:0]};
            pcin=pcin+4;
            case (opcode)
            //funciones tipo r positivo
            6'b000000:
                begin 
                    regisinposi1={outins_mem[25:21]};
                    regisinposi2={outins_mem[20:16]};
                    regisouposi1={outins_mem[15:11]};
                    intention = {outins_mem[5:0]};
                    
                end
            //funciones tipo i positivo
            6'b001000:
                begin
                    regisinposi1=outins_mem[25:21];
                    regisouposi1=outins_mem[20:16];        //addi
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                  
                end
            6'b001001:
                    begin
                        regisinposi1=outins_mem[25:21];
                        regisouposi1=outins_mem[20:16];        //subi
                        aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]}; 
                                                      
                    end
            6'b001100:
                    begin
                        regisinposi1=outins_mem[25:21];
                        regisouposi1=outins_mem[20:16];        //andi
                        aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                      
                    end
            6'b001101:
                    begin
                        regisinposi1=outins_mem[25:21];
                        regisouposi1=outins_mem[20:16];        //ori
                        aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                                                                
                    end
            6'b001010:
                    begin
                        regisinposi1=outins_mem[25:21];
                        regisouposi1=outins_mem[20:16];        //slti
                        aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                    end
            //funciones tipo j
            6'b000100:
            
                    begin       //beq
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                    regisinposi1=outins_mem[25:21];
                    regisinposi2=outins_mem[20:16];
                    end
            6'b000101:
                    begin       //bne
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                    regisinposi1=outins_mem[25:21];
                    regisinposi2=outins_mem[20:16];

                    end
            6'b000001:       //bgez
                    begin
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};
                    regisinposi1=outins_mem[25:21];
                    end
                
            6'b000010:         //j
                    begin
                    jassign =  outins_mem[25:0]<<2; 
                    pcin = jassign[7:0];  
                    end
            6'b000011:  //jal
                    begin                
                    jumps = {24'd0,pcin};
                    jassign =  outins_mem[25:0]<<2;
                    pcin = jassign[7:0];  
                    end
            6'b000111:  //jr
                    begin
                    regisinposi1=outins_mem[25:21];
                    jumps = reg_file[regisinposi1];
                    pcin = {jumps[7:0]};                                        
                    end      
            //funciones tipo lw
            6'b100000: //LB
                    begin                
                    regisinposi1=outins_mem[25:21];
                    regisouposi1=outins_mem[20:16];   
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};  
                    load = aumentado+reg_file[regisinposi1];                                      
                    end
            6'b100001: //lh
                    begin
               
                regisinposi1=outins_mem[25:21];
                regisouposi1=outins_mem[20:16];   
                aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};  
                load = aumentado+reg_file[regisinposi1];                   
                    end

            6'b100011://lw
                    begin
                
                    regisinposi1={outins_mem[25:21]};
                    regisouposi1={outins_mem[20:16]}; 
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};  
                    load = aumentado+reg_file[regisinposi1];   
                    end

            6'b101000://sb
                    begin
                    regisinposi1=outins_mem[25:21];
                    regisouposi1=outins_mem[20:16];   
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};  
                    load = aumentado+reg_file[regisinposi1];   

                    end                    

            6'b000010://sh

                begin
                  
                    regisinposi1=outins_mem[25:21];
                    regisouposi1=outins_mem[20:16]; 
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};  
                    load = aumentado+reg_file[regisinposi1];                                  
                end
            6'b101011:

                begin
                                 //sw
                    regisinposi1=outins_mem[25:21];
                    regisouposi1=outins_mem[20:16];   
                    aumentado ={bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,inmediate[15:0]};  
                    load = aumentado+reg_file[regisinposi1];
                end
            6'b001111:

                begin
                    
                    regisouposi1=outins_mem[20:16];  //lui     

                end      

            endcase

        end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always@(negedge clk)
    begin
        //alu - tipo r pulso negativo
        case(opcode)
        6'b000000:
            begin
            case (intention)
                6'b100000: 
                    begin
                    reg_file[regisouposi1]  = reg_file[regisinposi1]+reg_file[regisinposi2];//add
                    impress1= reg_file[regisouposi1];
                    temp_over= reg_file[regisinposi1]+reg_file[regisinposi2];
                    overflow = temp_over[32];
                    end
                6'b100010:
                   begin
                   reg_file[regisouposi1] = reg_file[regisinposi1]-reg_file[regisinposi2];//sub
                    impress1= reg_file[regisouposi1];
                    temp_over= reg_file[regisinposi1]-reg_file[regisinposi2];
                    overflow = temp_over[32];
                    end
                6'b100100:
                    begin
                   reg_file[regisouposi1] = reg_file[regisinposi1]&reg_file[regisinposi2];//and
                    impress1= reg_file[regisouposi1];
                    end
                6'b100111: 
                    begin
                   reg_file[regisouposi1] = ~{reg_file[regisinposi1]|reg_file[regisinposi2]};//nor
                   impress1= reg_file[regisouposi1];
                    end
                6'b100101: 
                    begin
                    reg_file[regisouposi1] = reg_file[regisinposi1]||reg_file[regisinposi2]; //or
                    impress1= reg_file[regisouposi1];
                    end

                6'b101010:begin
                    if (reg_file[regisinposi1]<reg_file[regisinposi2]) begin
                        reg_file[regisouposi1] = 1;
                    end 
                else begin                              //slt
                    reg_file[regisouposi1] = 0;
                    end   
                    impress1 = reg_file[regisouposi1];
                end 
            endcase    //r function final
            end                                                
        //formato j pulso negativo

            //tipo I
        6'b000100:
                begin       //beq
                    if (reg_file[regisinposi1]==reg_file[regisinposi2]) begin
                            //condición
                            pcin = pcin+aumentado<<2;
                        end 
                    else begin              
                            //condición
                            pcin = pcin;  
                        end                                                     
                end
        6'b000101:
                begin       //bne
                    if (reg_file[regisinposi1]!=reg_file[regisinposi2]) begin
                            //condición
                            pcin = pcin+aumentado<<2;
                        end 
                    else begin              
                            //condición
                            pcin = pcin;  
                        end     
                end
        6'b000001:       //bgez
                begin
                    if (reg_file[regisinposi1]>=0) begin
                            //condición
                            pcin = pcin+aumentado<<2;
                        end 
                    else begin              
                            //condición
                            pcin = pcin;  
                        end     
                end
                        
        6'b000011:  //jal
                begin
                    reg_file[31] <= jumps;
                end
          
    
    // tipo i pulso negativo
        6'b001000: //addi
                begin
                    reg_file[regisouposi1] = reg_file[regisinposi1]+aumentado;
                    impress1= reg_file[regisouposi1];
                    temp_over= reg_file[regisinposi1]+aumentado;
                    overflow = temp_over[32];
                end
        6'b001010: //slti
                begin
                    if (reg_file[regisinposi1]<aumentado) begin
                    reg_file[regisouposi1] <= 32'd0+1;
                    end 
                    else begin                              
                        reg_file[regisouposi1] <= 32'd0;
                        end 
                    impress1= reg_file[regisouposi1];    
                end
                
        6'b001100: //andi
                    begin
                        reg_file[regisouposi1] <= reg_file[regisinposi1]&&aumentado;
                        impress1= reg_file[regisouposi1];
                    end

        6'b001101: //ori
                    begin   
                        reg_file[regisouposi1] <= reg_file[regisinposi1]||aumentado;
                        impress1<= reg_file[regisouposi1];
                    end

        6'b001001:   //subi oooooooooooooooooooooooooooooooooooooooooooooooooooooooojoooooooooooooooooooooooooooooo
                    begin
                        reg_file[regisouposi1] = reg_file[regisinposi1]-aumentado;
                        impress1= reg_file[regisouposi1];
                        temp_over= reg_file[regisinposi1]-aumentado;
                        overflow = temp_over[32];
                    end
//tipos de carga pulso de bajada
        6'b100011:
                    begin        //lw
                        reg_file[regisouposi1] = {data_mem[load+3],data_mem[load+2],data_mem[load+1],data_mem[load]};
                        impress1=reg_file[regisouposi1];//37
                    end
        6'b101011:          
                    begin        //sw
                         reg_file_tempsave=reg_file[regisouposi1];
                         data_mem[load]=reg_file_tempsave[31:24];
                         data_mem[load+1]=reg_file_tempsave[23:16];
                         data_mem[load+2]=reg_file_tempsave[15:8];
                         data_mem[load+3]=reg_file_tempsave[7:0];
                    end

        6'b100000:
                    begin       //lb
                        templ = data_mem[load];
                        reg_file[regisouposi1] = templ[7:0];
                    end

        6'b101000://sb
                    begin
                        templ = reg_file[regisouposi1];
                        data_mem[load] = templ[7:0];  
                    end

        6'b001111:
                    begin        //lui */
                        reg_file[regisouposi1] = inmediate<<16;
                    end

        6'b100001:
                    begin       //lh
                        templ = {data_mem[load],data_mem[load+1]};
                        reg_file[regisouposi1] = {16'd0,templ[15:0]};
                    end

        6'b101001:   
                    begin        //sh
                        templ = reg_file[regisouposi1] ;
                        data_mem[load+1]= templ[15:8];
                        data_mem[load]= templ[7:0];                        
                    end
        endcase
    end
endmodule