module sequential_divider (
    input logic clk, nRst, en,
    input logic [15:0] divider,
    input logic [15:0] dividend,

    output logic [7:0] quotient
);
    logic [2:0] count, next_count;
    logic [23:0] R, next_R;
    logic [15:0] D, next_D;
    logic [7:0] Q, next_Q;
    logic [7:0] next_quotient;

    logic [23:0] top_R_shift;
    logic [15:0] top_R;

    assign top_R_shift = (R << 1);
    assign top_R = top_R_shift[23:8];

    typedef enum logic [2:0] {start, load, divide, done} state_t;
    logic [2:0] state, next_state;

    always_ff @(posedge clk, negedge nRst) begin
        if(!nRst) begin
            state <= start;
            R <= 0;
            D <= 0;
            Q <= 0;
            quotient <= 0;
            count <= 0;
        end else begin
            state <= next_state;
            R <= next_R;
            D <= next_D;
            Q <= next_Q;
            quotient <= next_quotient;
            count <= next_count;
        end
    end
    
    always_comb begin
        next_state = state;
        next_count = count;
        next_R = R;
        next_D = D;
        next_Q = Q;
        next_quotient = quotient;

        case (state)
             start: begin
                if(en) begin
                    next_state = load;
                end
             end
             load: begin
                next_Q = 8'b00000000;
                next_D = divider;
                next_R = {dividend, 8'd0};
                next_state = divide;
             end
             divide: begin
                if(top_R >= D) begin
                    next_R = (R << 1) - {D, 8'b0};
                    next_Q = (Q << 1) + 8'b00000001;
                end else begin
                    next_R = (R << 1);
                    next_Q = (Q << 1);
                end
                
                next_count = count + 1;
                if(count == 3'b111)
                    next_state = done;
                else
                    next_state = divide;
             end
             done: begin
                next_quotient = Q;
                if(en)
                    next_state = load;
             end
             default begin
                next_state = state;
                next_count = count;
                next_R = R;
                next_D = D;
                next_Q = Q;
                next_quotient = quotient;
             end
        endcase
    end
endmodule
