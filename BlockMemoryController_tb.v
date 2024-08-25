`timescale 1ns / 1ps  // モジュール定義の外に配置

module BlockMemoryController_tb;

    // クロックとリセット
    reg clk;
    reg reset;

    // アドレスとデータ
    reg [11:0] rd_addr1, rd_addr2, rd_addr3, rd_addr4;
    reg [11:0] wr_addr1, wr_addr2, wr_addr3, wr_addr4;
    reg [31:0] wr_data1, wr_data2, wr_data3, wr_data4;
    reg wr_enable1, wr_enable2, wr_enable3, wr_enable4;

    // 出力データとステータス信号
    wire [31:0] rd_data1, rd_data2, rd_data3, rd_data4;
    wire rd_enable1, rd_enable2, rd_enable3, rd_enable4;
    wire wr_enable_out1, wr_enable_out2, wr_enable_out3, wr_enable_out4;

    // DUTのインスタンス化
    BlockMemoryController uut (
        .clk(clk),
        .reset(reset),
        .rd_addr1(rd_addr1), .rd_addr2(rd_addr2), .rd_addr3(rd_addr3), .rd_addr4(rd_addr4),
        .wr_addr1(wr_addr1), .wr_addr2(wr_addr2), .wr_addr3(wr_addr3), .wr_addr4(wr_addr4),
        .wr_data1(wr_data1), .wr_data2(wr_data2), .wr_data3(wr_data3), .wr_data4(wr_data4),
        .wr_enable1(wr_enable1), .wr_enable2(wr_enable2), .wr_enable3(wr_enable3), .wr_enable4(wr_enable4),
        .rd_data1(rd_data1), .rd_data2(rd_data2), .rd_data3(rd_data3), .rd_data4(rd_data4),
        .rd_enable1(rd_enable1), .rd_enable2(rd_enable2), .rd_enable3(rd_enable3), .rd_enable4(rd_enable4),
        .wr_enable_out1(wr_enable_out1), .wr_enable_out2(wr_enable_out2), .wr_enable_out3(wr_enable_out3), .wr_enable_out4(wr_enable_out4)
    );

    // クロック生成
    always begin
        #5 clk = ~clk; // 10nsのクロック周期
    end

    initial begin
        // 初期化
        clk = 0;
        reset = 1;
        rd_addr1 = 12'b0;
        rd_addr2 = 12'b0;
        rd_addr3 = 12'b0;
        rd_addr4 = 12'b0;
        wr_addr1 = 12'b0;
        wr_addr2 = 12'b0;
        wr_addr3 = 12'b0;
        wr_addr4 = 12'b0;
        wr_data1 = 32'b0;
        wr_data2 = 32'b0;
        wr_data3 = 32'b0;
        wr_data4 = 32'b0;
        wr_enable1 = 0;
        wr_enable2 = 0;
        wr_enable3 = 0;
        wr_enable4 = 0;

        // リセット解除
        #10 reset = 0;

        // 初期書き込み: 異なるアドレスにデータを書き込む
        #10 wr_addr1 = 12'd257; wr_data1 = 32'hAAAA_AAAA; wr_enable1 = 1;
            wr_addr2 = 12'd50; wr_data2 = 32'hBBBB_BBBB; wr_enable2 = 1;
            wr_addr3 = 12'd3099; wr_addr4 = 12'd3099;
        #10 wr_enable1 = 0; wr_enable2 = 0;
            wr_addr1 = 12'd2057;
        #10 wr_enable1 = 0; wr_enable2 = 1;
        #10 wr_enable1 = 0; wr_enable2 = 0;

        // 書き込んだデータの読み出し
        #10 rd_addr1 = 12'd257; rd_addr2 = 12'd1048; rd_addr3 = 12'd1048;

        // 書き込んだデータの読み出し
        #10 rd_addr1 = 12'd2099; rd_addr2 = 12'd50; rd_addr3 = 12'd1048;

        // 書き込んだデータの読み出し
        #10 rd_addr1 = 12'd2048; rd_addr2 = 12'd2048; rd_addr3 = 12'd257;
        #10

        // 書き込んだデータの読み出し
        #10 rd_addr1 = 12'd257; rd_addr2 = 12'd2048; rd_addr3 = 12'd1048;
        #10

        // 書き込んだデータの読み出し
        #10 rd_addr1 = 12'd257; rd_addr2 = 12'd2048; rd_addr3 = 12'd257;
        #10

        // 競合読み込みテスト（同じブロックにアクセス）
        #10 rd_addr1 = 12'd0; rd_addr3 = 12'd257; rd_addr4 = 12'd5;

        // 異なるブロックに対する書き込みテスト
        #10 wr_addr3 = 12'd256; wr_data3 = 32'hCCCC_CCCC; wr_enable3 = 1;
            wr_addr4 = 12'd512; wr_data4 = 32'hDDDD_DDDD; wr_enable4 = 1;
        #10 wr_enable3 = 0; wr_enable4 = 0;

        // 同一ブロックへの競合書き込みテスト
        #10 wr_addr1 = 12'd15; wr_data1 = 32'h1111_1111; wr_enable1 = 1;
            wr_addr2 = 12'd15; wr_data2 = 32'h2222_2222; wr_enable2 = 1;
        #10 wr_enable1 = 0; wr_enable2 = 0;

        // 書き込んだデータの読み出し
        #10 rd_addr1 = 12'd15; rd_addr2 = 12'd4015; rd_addr3 = 12'd4015;
        #10

        // 書き込んだデータの読み出し
        #10 rd_addr3 = 12'd256; rd_addr4 = 12'd512; 
            rd_addr1 = 12'd4015; rd_addr2 = 12'd4015;
        #10
            rd_addr1 = 12'd0; rd_addr2 = 12'd4015;
        #10
            rd_addr1 = 12'd4014; rd_addr3 = 12'd4015; rd_addr4 = 12'd257;
        #10

        // 終了
        #50 $finish;
    end
    
    initial begin
    	$dumpfile("wave.vcd");
    	$dumpvars(0, BlockMemoryController_tb);
    end

endmodule
