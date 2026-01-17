module controller (
    input wire start,clk,rst,Col_done,Row_done,
    output reg [1:0] Col_ctrl, Row_ctrl,enable_wr, data_ctrl,gray_ctrl,
    output reg [2:0] State
);
    localparam  Idle = 3'd0,
                Exe = 3'd2,
                Wb  = 3'd3,
                Inc_col = 3'd4,
                Inc_row = 3'd5 ,
                Load = 3'd1;

    reg [2:0] cur_state, n_state;

    always @(posedge clk or posedge rst) begin
        if(rst)
            cur_state <= Idle;
        else begin
            cur_state <= n_state;
        end
    end

    always @(*) begin
        case(cur_state)
            Idle : n_state = (start) ? Load : Idle;
            Exe : n_state = Wb;
            Wb : begin
                if(Col_done && Row_done)
                    n_state = Idle;
                else if(Col_done)
                    n_state = Inc_row;
                else 
                    n_state = Inc_col;
            end
            Load : n_state = Exe;
            Inc_col : n_state = Load;
            Inc_row : n_state = Load;
            default : n_state = Idle;
        endcase
    end

    always @(*)  begin
        State = cur_state ;
        enable_wr = 2'd0;
        data_ctrl = 2'd0;
        Col_ctrl = 2'd0;
        Row_ctrl = 2'd0;
        gray_ctrl = 2'd0;
        case (cur_state)
            Idle : begin
                Col_ctrl = 2'd1 ;// Load 0
                Row_ctrl = 2'd1 ;
            end
            Load : begin
                data_ctrl = 2'd1; // Load Data to Reg
            end
            Exe : begin
                gray_ctrl = 2'd1 ; // Load for gray
            end
            Wb : begin
                enable_wr = 2'd1 ; 
            end
            Inc_col : begin
                Col_ctrl = 2'd2 ; // increase 1
                //data_ctrl = 2'd1;
            end
            Inc_row : begin
                Row_ctrl = 2'd2 ; // increase 1
                Col_ctrl = 2'd1; // reload 0
                //data_ctrl = 2'd1;
            end 
        endcase
    end
    
endmodule