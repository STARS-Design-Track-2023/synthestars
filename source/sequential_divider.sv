module sequential_divider (
    input logic clk, nRst,
    input logic [15:0] divider,
    output logic [7:0] quotient
);
    logic [2:0] count, next_count;
    logic [23:0] R, next_R;
    logic [7:0] Q, next_Q;

    typedef enum logic [2:0] {start, divide, done} state_t;
    logic [2:0] state, next_state;

    always_ff @(posedge clk, negedge nRst) begin
        if(nRst == 0) begin
            state <= start;
            R <= 0;
            Q <= 0;
            count <= 0;
        end else begin
            state <= next_state;
            R <= next_R;
            Q <= next_Q;
            count <= next_count;
        end
    end
    
    always_comb begin
        case (state)
             start: begin
                next_state = divide;
             end
             divide: begin
                next_count = count + 1;
                next_state = done;
             end
             done: begin
                if(count == 3'b111)
                    next_state = done;
                else
                    next_state = divide;
             end
            default: begin
                next_count = 0;
                next_R = R;
                next_Q = Q;
                quotient = 0;
            end 
        endcase
    end
endmodule
