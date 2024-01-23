module SignedMultiplier #(parameter N=4) (
  input signed [N-1:0] A,
  input signed [N-1:0] B,
  input sel,
  output reg busy,
  output reg valid,
  output reg error,
  
  
  output reg [N-1:0] m, 
 output reg [N-1:0] r
  
);
assign busy = 1'b1;//********************************
assign valid = 1'b0;
assign error = 1'b0;
 reg signed [2*N-1:0] result;
reg [N-1:0] A_pos; 
reg [N-1:0] B_pos;
reg [N-1:0] count ;
assign count = {N{1'b0}};
reg [1:0] sign_term;
wire [1:0] sign_term_wire;

assign sign_term_wire = {A[N-1], B[N-1]};

// Generate block for sign term
generate 
  if (1'b1) begin: gen_block
    always @* begin
      sign_term = sign_term_wire;
    end
  end
endgenerate

// Convert inputs to positive
always @* begin


  case(sign_term)
    2'b01: begin // B negative
      A_pos = A; 
      B_pos = ~B+1;
    end
    
    2'b10: begin // A negative  
      A_pos = ~A+1;
      B_pos = B; 
    end
    
    2'b11: begin // Both negative
      A_pos = ~A + 1;
      B_pos = ~B + 1;
    end
    
    default: begin // Both positive
      A_pos = A;
      B_pos = B; 
    end
  endcase
end

// Multiplication loop
reg [2*N-1:0] accum;
integer i;
assign m = {N{1'b0}};
assign	r = {N{1'b0}};


always @* begin :check1
if (sel)begin
  accum = 0;

  for ( i=0; i<N; i=i+1) begin
  
    if (B_pos[i])
      accum = accum + A_pos;

    A_pos = A_pos << 1; 
    
  end
  case(sign_term)
    2'b01: begin // A negative
    result =~accum +1;
    end
    
    2'b10: begin // B negative  
    result = ~accum +1;
    end
    
    default: begin // Both positive
    result = accum ; 
      
    end
  endcase
end

end
assign {m,r}=result;
assign valid=1'b0;

//******************************************************


reg [N-1:0] msb;

always @* begin
      msb = {A[N-1], B[N-1]};
    end

always @* begin :a7eeh

  case(msb)
    2'b01: begin // b negative
      A_pos = A; 
      B_pos = ~B+1;
    end
    
    2'b10: begin // a negative  
      A_pos = ~A+1;
      B_pos = B; 
    end
    
    2'b11: begin // Both negative
      A_pos = ~A + 1;
      B_pos = ~B + 1;
    end
    
    default: begin // Both positive
      A_pos = A;
      B_pos = B; 
    end
  endcase
end


reg [N-1:0]counter ;
assign counter =  {N{1'b0}};
reg [N-1:0] A_div;
always @* begin :hel
	if(sel==0)begin
    if(busy==0)begin
	m = {N-1{1'b0}};
	r = {N-1{1'b0}};
	if (B_pos == 0)
		error = 1'b0;
	else if (A_pos == 0)begin
		m = {N-1{1'b0}};
		r = {N-1{1'b0}};
	end
	else begin
		A_div[N-1:0] = A_pos[N-1:0];
		while(A_div >= B_pos)begin
			A_div = A_div - B_pos;
			counter = counter + 1;
		end

		case(msb)
    		  2'b01: begin // A negative
    		  
    		  m = ~counter + 1;
    		  r = A_div;
    		  end
    
    		  2'b10: begin // B negative  
    		  
    		  m = ~counter + 1;
    		  r = A_div;
    		  end
    
    		  default: begin // Both positive
    		  
    		  m = counter;
    		  r = A_div; 
      valid=1'b0;
    		  end
  		endcase
	end
    end
   end
end
endmodule
module testbench;

  reg [3:0] A, B;
  reg sel;

  reg [3:0] expected_m, expected_r;
  
  // DUT
  SignedMultiplier #(.N(4)) DUT (
    .A(A),
    .B(B), 
    .sel(sel),
    .m(m),
    .r(r)
  );

  // Test cases  
  initial begin
  
    test_case(4'd5, 4'd2, 1'b1, 4'd10, 4'd0); 
    #10;
    
    test_case(4'd7, 4'd3, 1'b1, 4'd21, 4'd1);
    #10;
    
    // Check outputs
    check_outputs();
    
    test_case(4'd6, 4'd2, 1'b0, 4'd3, 4'd0);
    #10;
    
    // And so on for remaining test cases

  end

  // Test case task  
  task test_case;
    input [3:0] a, b;
    input sel;
    input [3:0] expected_m, expected_r;
    
    begin
      A = a;
      B = b;
      sel = sel;
      expected_m = expected_m;
      expected_r = expected_r;
    end
  endtask

  // Output check task
  task check_outputs;
    begin
      if (m != expected_m) begin
        $display("Output m mismatch!"); 
      end
      
      if (r != expected_r) begin
         $display("Output r mismatch!");
      end
    end 
  endtask

endmodule

module testbench;

  reg [3:0] A, B; 
  reg sel;

  // DUT
  SignedMultiplier #(.N(4)) dut (.A(A), .B(B), .sel(sel), .m(m), .r(r));

  initial begin
  
    // Statement coverage
    
    // Test all input combinations
    test_inputs(4'd1, 4'd2, 1'b1); 
    test_inputs(4'd5, 4'd0, 1'b1);
    test_inputs(4'd0, 4'd3, 1'b0);
    test_inputs(4'd15, 4'd15, 1'b0);
    
    // Branch coverage
    
    // Test true and false branches
    test_branch(4'd2, 4'd4, 1'b1);
    test_branch(4'd10, 4'd11, 1'b0);
  
    // Block coverage
    
    // Test each always block
    test_mult_block(4'd5, 4'd2, 1'b1);
    test_sign_block(4'd12, 4'd10, 1'b0);
    test_div_block(4'd15, 4'd3, 1'b0);

  end

  task test_inputs;
    input [3:0] a, b;
    input sel;
    
    begin
      A = a;
      B = b;
      this.sel = sel;
    end 
  endtask

  task test_branch;
    input [3:0] a, b;
    input sel;
    
    begin
      // Test true case
      A = a;
      B = b;
      this.sel = sel;
      
      // Test false case 
      A = b;  
      B = a;
      this.sel = !sel;
    end
  endtask

  // Tasks to test blocks

  // Check coverage at end

endmodule