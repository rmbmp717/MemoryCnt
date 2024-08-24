# MEMCNT
# written by Nishiharu. hhttps://note.com/dreamy_stilt3370/n/nc6bdd03db812

module BlockMemoryController (
    input wire clk,
    input wire reset,
    input wire [11:0] rd_addr1,    // Read Address for Port 1
    input wire [11:0] rd_addr2,    // Read Address for Port 2
    input wire [11:0] rd_addr3,    // Read Address for Port 3
    input wire [11:0] rd_addr4,    // Read Address for Port 4
    input wire [11:0] wr_addr1,    // Write Address for Port 1
    input wire [11:0] wr_addr2,    // Write Address for Port 2
    input wire [11:0] wr_addr3,    // Write Address for Port 3
    input wire [11:0] wr_addr4,    // Write Address for Port 4
    input wire [31:0] wr_data1,    // Write Data for Port 1
    input wire [31:0] wr_data2,    // Write Data for Port 2
    input wire [31:0] wr_data3,    // Write Data for Port 3
    input wire [31:0] wr_data4,    // Write Data for Port 4
    input wire wr_enable1,         // Write Enable for Port 1
    input wire wr_enable2,         // Write Enable for Port 2
    input wire wr_enable3,         // Write Enable for Port 3
    input wire wr_enable4,         // Write Enable for Port 4
    output reg [31:0] rd_data1,    // Read Data for Port 1
    output reg [31:0] rd_data2,    // Read Data for Port 2
    output reg [31:0] rd_data3,    // Read Data for Port 3
    output reg [31:0] rd_data4,    // Read Data for Port 4
    output reg rd_enable1,         // Port 1 read enable status
    output reg rd_enable2,         // Port 2 read enable status
    output reg rd_enable3,         // Port 3 read enable status
    output reg rd_enable4,         // Port 4 read enable status
    output reg wr_enable_out1,     // Port 1 write enable status
    output reg wr_enable_out2,     // Port 2 write enable status
    output reg wr_enable_out3,     // Port 3 write enable status
    output reg wr_enable_out4      // Port 4 write enable status
);

    // 4つの1KB SRAMブロック (1ブロックあたり1024エントリ)
    reg [31:0] sram[3:0][1023:0]; // 各ブロックに1024エントリを持つメモリ

    integer i, j;

    // アドレスからブロック番号を計算 (3ビットで8つのブロックを指定)
    function [1:0] get_block_index(input [11:0] addr);
        get_block_index = addr[11:10];  // 上位2ビットを使用してブロックを指定
    endfunction

    // アドレスからオフセットを計算 (ブロック内の位置を指定)
    function [9:0] get_block_offset(input [11:0] addr);
        get_block_offset = addr[9:0];  // 下位10ビットを使用してブロック内の位置を指定
    endfunction

    // ブロックを代入
    wire [1:0] read_block1, read_block2, read_block3, read_block4;
    wire [1:0] write_block1, write_block2, write_block3, write_block4;

    assign read_block1 = get_block_index(rd_addr1);
    assign read_block2 = get_block_index(rd_addr2);
    assign read_block3 = get_block_index(rd_addr3);
    assign read_block4 = get_block_index(rd_addr4);

    // 書き込みのためのブロックインデックスを計算
    assign write_block1 = get_block_index(wr_addr1);
    assign write_block2 = get_block_index(wr_addr2);
    assign write_block3 = get_block_index(wr_addr3);
    assign write_block4 = get_block_index(wr_addr4);


    // アドレスからRead enableを計算
    // Memory0
    wire rd_mem0_enable1, rd_mem0_enable2, rd_mem0_enable3, rd_mem0_enable4;
    assign rd_mem0_enable1 = (read_block1==2'd0)? 1'b1 : 1'b0;
    assign rd_mem0_enable2 = (read_block2==2'd0)? 1'b1 : 1'b0;
    assign rd_mem0_enable3 = (read_block3==2'd0)? 1'b1 : 1'b0;
    assign rd_mem0_enable4 = (read_block4==2'd0)? 1'b1 : 1'b0;

    // Memory1
    wire rd_mem1_enable1, rd_mem1_enable2, rd_mem1_enable3, rd_mem1_enable4;
    assign rd_mem1_enable1 = (read_block1==2'd1)? 1'b1 : 1'b0;
    assign rd_mem1_enable2 = (read_block2==2'd1)? 1'b1 : 1'b0;
    assign rd_mem1_enable3 = (read_block3==2'd1)? 1'b1 : 1'b0;
    assign rd_mem1_enable4 = (read_block4==2'd1)? 1'b1 : 1'b0;

    // Memory2
    wire rd_mem2_enable1, rd_mem2_enable2, rd_mem2_enable3, rd_mem2_enable4;
    assign rd_mem2_enable1 = (read_block1==2'd2)? 1'b1 : 1'b0;
    assign rd_mem2_enable2 = (read_block2==2'd2)? 1'b1 : 1'b0;
    assign rd_mem2_enable3 = (read_block3==2'd2)? 1'b1 : 1'b0;
    assign rd_mem2_enable4 = (read_block4==2'd2)? 1'b1 : 1'b0;

    // Memory3
    wire rd_mem3_enable1, rd_mem3_enable2, rd_mem3_enable3, rd_mem3_enable4;
    assign rd_mem3_enable1 = (read_block1==2'd3)? 1'b1 : 1'b0;
    assign rd_mem3_enable2 = (read_block2==2'd3)? 1'b1 : 1'b0;
    assign rd_mem3_enable3 = (read_block3==2'd3)? 1'b1 : 1'b0;
    assign rd_mem3_enable4 = (read_block4==2'd3)? 1'b1 : 1'b0;


    // アドレスからWrite enableを計算
    // Memory0
    wire wr_mem0_enable1, wr_mem0_enable2, wr_mem0_enable3, wr_mem0_enable4;
    assign wr_mem0_enable1 = (write_block1==2'd0)? 1'b1 : 1'b0;
    assign wr_mem0_enable2 = (write_block2==2'd0)? 1'b1 : 1'b0;
    assign wr_mem0_enable3 = (write_block3==2'd0)? 1'b1 : 1'b0;
    assign wr_mem0_enable4 = (write_block4==2'd0)? 1'b1 : 1'b0;

    // Memory1
    wire wr_mem1_enable1, wr_mem1_enable2, wr_mem1_enable3, wr_mem1_enable4;
    assign wr_mem1_enable1 = (write_block1==2'd1)? 1'b1 : 1'b0;
    assign wr_mem1_enable2 = (write_block2==2'd1)? 1'b1 : 1'b0;
    assign wr_mem1_enable3 = (write_block3==2'd1)? 1'b1 : 1'b0;
    assign wr_mem1_enable4 = (write_block4==2'd1)? 1'b1 : 1'b0;

    // Memory2
    wire wr_mem2_enable1, wr_mem2_enable2, wr_mem2_enable3, wr_mem2_enable4;
    assign wr_mem2_enable1 = (write_block1==2'd2)? 1'b1 : 1'b0;
    assign wr_mem2_enable2 = (write_block2==2'd2)? 1'b1 : 1'b0;
    assign wr_mem2_enable3 = (write_block3==2'd2)? 1'b1 : 1'b0;
    assign wr_mem2_enable4 = (write_block4==2'd2)? 1'b1 : 1'b0;

    // Memory3
    wire wr_mem3_enable1, wr_mem3_enable2, wr_mem3_enable3, wr_mem3_enable4;
    assign wr_mem3_enable1 = (write_block1==2'd3)? 1'b1 : 1'b0;
    assign wr_mem3_enable2 = (write_block2==2'd3)? 1'b1 : 1'b0;
    assign wr_mem3_enable3 = (write_block3==2'd3)? 1'b1 : 1'b0;
    assign wr_mem3_enable4 = (write_block4==2'd3)? 1'b1 : 1'b0;


    // Memory Cnt
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 初期化
            rd_data1 <= 32'b0;
            rd_data2 <= 32'b0;
            rd_data3 <= 32'b0;
            rd_data4 <= 32'b0;
            rd_enable1 <= 0;
            rd_enable2 <= 0;
            rd_enable3 <= 0;
            rd_enable4 <= 0;
            wr_enable_out1 <= 0;
            wr_enable_out2 <= 0;
            wr_enable_out3 <= 0;
            wr_enable_out4 <= 0;

        end else begin
            // ### リード処理 ###

            // rd_data1の優先度選択
            if (rd_mem0_enable1) begin
                rd_enable1 <= 1'b1;
                rd_data1 <= sram[read_block1][get_block_offset(rd_addr1)];
            end else if (rd_mem0_enable2) begin
                rd_enable2 <= 1'b1;
                rd_data2 <= sram[read_block2][get_block_offset(rd_addr2)];
            end else if (rd_mem0_enable3) begin
                rd_enable3 <= 1'b1;
                rd_data3 <= sram[read_block3][get_block_offset(rd_addr3)];
            end else if (rd_mem0_enable4) begin
                rd_enable4 <= 1'b1;
                rd_data4 <= sram[read_block4][get_block_offset(rd_addr4)];
            end else begin
                //rd_enable1 <= 1'bx;
                //rd_data1 <= 32'bz;  // 全ての rd_enable が無効の場合
            end
            // rd_data2の優先度選択
            if (rd_mem1_enable1) begin
                rd_enable1 <= 1'b1;
                rd_data1 <= sram[read_block1][get_block_offset(rd_addr1)];
            end else if (rd_mem1_enable2) begin
                rd_enable2 <= 1'b1;
                rd_data2 <= sram[read_block2][get_block_offset(rd_addr2)];
            end else if (rd_mem1_enable3) begin
                rd_enable3 <= 1'b1;
                rd_data3 <= sram[read_block3][get_block_offset(rd_addr3)];
            end else if (rd_mem1_enable4) begin
                rd_enable4 <= 1'b1;
                rd_data4 <= sram[read_block4][get_block_offset(rd_addr4)];
            end else begin
                //rd_enable1 <= 1'bx;
                //rd_data2 <= 32'bz;  // 全ての rd_enable が無効の場合
            end
            // rd_data3の優先度選択
            if (rd_mem2_enable1) begin
                rd_enable1 <= 1'b1;
                rd_data1 <= sram[read_block1][get_block_offset(rd_addr1)];
            end else if (rd_mem2_enable2) begin
                rd_enable2 <= 1'b1;
                rd_data2 <= sram[read_block2][get_block_offset(rd_addr2)];
            end else if (rd_mem2_enable3) begin
                rd_enable3 <= 1'b1;
                rd_data3 <= sram[read_block3][get_block_offset(rd_addr3)];
            end else if (rd_mem2_enable4) begin
                rd_enable4 <= 1'b1;
                rd_data4 <= sram[read_block4][get_block_offset(rd_addr4)];
            end else begin
                //rd_enable1 <= 1'bx;
                //rd_data3 <= 32'bz;  // 全ての rd_enable が無効の場合
            end
            // rd_data4の優先度選択
            if (rd_mem3_enable1) begin
                rd_enable1 <= 1'b1;
                rd_data1 <= sram[read_block1][get_block_offset(rd_addr1)];
            end else if (rd_mem3_enable2) begin
                rd_enable2 <= 1'b1;
                rd_data2 <= sram[read_block2][get_block_offset(rd_addr2)];
            end else if (rd_mem3_enable3) begin
                rd_enable3 <= 1'b1;
                rd_data3 <= sram[read_block3][get_block_offset(rd_addr3)];
            end else if (rd_mem3_enable4) begin
                rd_enable4 <= 1'b1;
                rd_data4 <= sram[read_block4][get_block_offset(rd_addr4)];
            end else begin
                //rd_enable1 <= 1'bx;
                //rd_data4 <= 32'bz;  // 全ての rd_enable が無効の場合
            end

            // ### ライト処理 ###

            // wr_data1の優先度選択
            if (wr_mem0_enable1) begin
                wr_enable_out1 <= 1'b1;
                sram[write_block1][get_block_offset(wr_addr1)] <= wr_data1;
            end else if (wr_mem0_enable2) begin
                wr_enable_out2 <= 1'b1;
                sram[write_block2][get_block_offset(wr_addr2)] <= wr_data2;
            end else if (wr_mem0_enable3) begin
                wr_enable_out3 <= 1'b1;
                sram[write_block3][get_block_offset(wr_addr3)] <= wr_data3;
            end else if (wr_mem0_enable4) begin
                wr_enable_out4 <= 1'b1;
                sram[write_block4][get_block_offset(wr_addr4)] <= wr_data4;
            end else begin
                wr_enable_out1 <= 1'b0;
                wr_enable_out2 <= 1'b0;
                wr_enable_out3 <= 1'b0;
                wr_enable_out4 <= 1'b0;
            end
            // wr_data2の優先度選択
            if (wr_mem1_enable1) begin
                wr_enable_out1 <= 1'b1;
                sram[write_block1][get_block_offset(wr_addr1)] <= wr_data1;
            end else if (wr_mem1_enable2) begin
                wr_enable_out2 <= 1'b1;
                sram[write_block2][get_block_offset(wr_addr2)] <= wr_data2;
            end else if (wr_mem1_enable3) begin
                wr_enable_out3 <= 1'b1;
                sram[write_block3][get_block_offset(wr_addr3)] <= wr_data3;
            end else if (wr_mem1_enable4) begin
                wr_enable_out4 <= 1'b1;
                sram[write_block4][get_block_offset(wr_addr4)] <= wr_data4;
            end else begin
                wr_enable_out1 <= 1'b0;
                wr_enable_out2 <= 1'b0;
                wr_enable_out3 <= 1'b0;
                wr_enable_out4 <= 1'b0;
            end
            // wr_data3の優先度選択
            if (wr_mem2_enable1) begin
                wr_enable_out1 <= 1'b1;
                sram[write_block1][get_block_offset(wr_addr1)] <= wr_data1;
            end else if (wr_mem2_enable2) begin
                wr_enable_out2 <= 1'b1;
                sram[write_block2][get_block_offset(wr_addr2)] <= wr_data2;
            end else if (wr_mem2_enable3) begin
                wr_enable_out3 <= 1'b1;
                sram[write_block3][get_block_offset(wr_addr3)] <= wr_data3;
            end else if (wr_mem2_enable4) begin
                wr_enable_out4 <= 1'b1;
                sram[write_block4][get_block_offset(wr_addr4)] <= wr_data4;
            end else begin
                wr_enable_out1 <= 1'b0;
                wr_enable_out2 <= 1'b0;
                wr_enable_out3 <= 1'b0;
                wr_enable_out4 <= 1'b0;
            end
            // wr_data4の優先度選択
            if (wr_mem3_enable1) begin
                wr_enable_out1 <= 1'b1;
                sram[write_block1][get_block_offset(wr_addr1)] <= wr_data1;
            end else if (wr_mem3_enable2) begin
                wr_enable_out2 <= 1'b1;
                sram[write_block2][get_block_offset(wr_addr2)] <= wr_data2;
            end else if (wr_mem3_enable3) begin
                wr_enable_out3 <= 1'b1;
                sram[write_block3][get_block_offset(wr_addr3)] <= wr_data3;
            end else if (wr_mem3_enable4) begin
                wr_enable_out4 <= 1'b1;
                sram[write_block4][get_block_offset(wr_addr4)] <= wr_data4;
            end else begin
                wr_enable_out1 <= 1'b0;
                wr_enable_out2 <= 1'b0;
                wr_enable_out3 <= 1'b0;
                wr_enable_out4 <= 1'b0;
            end
        end
    end
endmodule
