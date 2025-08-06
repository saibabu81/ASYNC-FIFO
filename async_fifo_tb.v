`include "async_fifo.v"

module tb;
        
        reg wr_clk;                         // Write clock
        reg rd_clk;                         // Read clock
        reg wr_rst_n;                       // Write domain reset (active low)
        reg rd_rst_n;                       // Read domain reset (active low)
        reg wr_en;                          // Write enable
        reg rd_en;                          // Read enable
        reg [7:0] wr_data;                  // Write data
        wire [7:0] rd_data;                 // Read data
        wire fifo_full;                     // FIFO full flag
        wire fifo_empty;                    // FIFO empty flag
       

       //instance of dut
        async_fifo   #(.ADDR_WIDTH(5))rtl
                        (
                            .wr_clk(wr_clk),
                            .rd_clk(rd_clk),
                            .wr_rst_n(wr_rst_n),
                            .rd_rst_n(rd_rst_n),
                            .wr_en(wr_en),
                            .rd_en(rd_en),
                            .wr_data(wr_data),
                            .rd_data(rd_data),
                            .fifo_full(fifo_full),
                            .fifo_empty(fifo_empty)
                        );
        
        //source input frequncy 156.25 MHz 
        //1 clock cycle  6.4 ns
        always #3.2 wr_clk   = ~wr_clk;

        //receiver output frequncy 100 MHz 
        //1 clock cycle  10 ns
        always #5 rd_clk   = ~rd_clk;

        initial begin
            wr_clk  =   0;
            rd_clk  =   0;
            wr_rst_n =  0;
            rd_rst_n =  0;
            #5
            wr_rst_n =  1;
            rd_rst_n =  1;
            
            fork
                write();
                read();
            join
            #100;
            $stop;
        end

        task write();
           begin 
            repeat(10) begin
                @(posedge wr_clk);
                wr_en   =   1;
                wr_data =   $urandom_range(100,200);
            end
                @(posedge wr_clk);
                wr_en   =   0;
            end
        endtask

        task read();
            begin
            repeat(10) begin
                @(posedge rd_clk);
                rd_en   =   1;
            end
                @(posedge rd_clk);
                wr_en   =   0;

            end
        endtask

    
    initial begin
            $monitor("wr_data  [%0d]\t rd_data  [%0d]",wr_data,rd_data);
    end 
endmodule
