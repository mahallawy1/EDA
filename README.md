# EDA

Task#1:
As a promising digital design engineer, you are required to implement an N-bit integer (signed multiplier
and divider. The multiplier/divider should have an input to choose whether it will multiply or divide. It
will also have 2 inputs (a,b) each has N-bits and two outputs (m,r) N-bits as well. In case of
multiplication, the result of multiplication will be of size 2N where the most significant N-bits will be in
‘m’ and the least significant bits will be in ‘r’. On the other hand, the division a/b = ‘m’ and the reminder
will be saved in ‘r’.
You are not allowed to use ‘*’ or ‘/’ operators in the design as they will not synthesis, you should
implement the hardware circuit yourself. Both multiplier and divider should be sequential using shifting
and adding/subtracting.
Additionally, the arithmetic unit should have three additional outputs, error bit, busy bit and valid bit.
Error bit indicates some error like division by zero, where busy bit indicates that the circuit is busy and
can’t accept any input currently, finally, valid bit indicates that the result is ready.
Use a clock and reset signals to initialize your design.
Task#2:
Repeat the design above but make the multiplier and division pure combinational circuits. Make sure not
to generate any unnecessary latches or flipflops. (the way you do it by pen and paper)
Task#3:
• Create a testing plan for the above designs.
• Mention the way you will use to generate stimulus.
• Also mention your coverage criteria you will use.
• Implement the self-checking testbench to test the above two implementations.
• Take care that each implementation has its own corner cases with respect to timing, use
different directives to choose between designs and corner cases.
• At the end you should report the total number of passed testcases as a ratio from the total
testcases i.e., 15/15.
• You can use * & / in your testbench.
• Take care of sign handling.
• Your testcases should be reproducible and your messages should be self-explanatory
