// Y = 0.299 * R + 0.587*G + 0.114 * B
// Y = (299 * R + 587 * G + 114 * B) /1000
// xấp xỉ Y =  (299 * R + 587 * G + 114 * B) >> 10bit 
module BGR_to_Gray
(
    input wire [7:0] B,G,R,Value,
    input wire op, // 1 la cong, 0 la tru
    output reg [7:0] Gray
);
    wire [8:0] temp = (299 * R + G * 587 + 114 * B) >> 10 ;
    wire signed [9:0] tmp = (op ) ? (temp + Value ) : (temp -Value);
    always @(*) begin
        if(tmp > 255)
            Gray = 8'd255;
        else if( tmp < 0)
            Gray = 8'd0;
        else
            Gray = tmp[7:0];
    end


endmodule