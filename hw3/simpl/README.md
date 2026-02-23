This folder contains a dune project for Simpl language described in class, with a partial implementation of the small-step interpreter.

+ File `grammar.txt` contains the grammar. 
+ The folder `input` contains sample input files that you can try to interpret and use for testing. Feel free to build more such examples and use the interpreter to play around.
+ lib
   |- ast.ml : Describes the AST of the input program.
   |- eval_smallstep.ml : Implements the small-step interpreter of Simpl language
   |- lexer.mll : Implements lexer
   |- parser.mly: Implements parser
+ bin
   |- main.ml : Launches the Simpl interpreter by reading input file.

In the file `lib/eval_smallstep.ml`, some functions are not fully implemented. You are to implement these functions, test them, and then upload the updated `eval_smallstep.ml` file as your submission.


Steps to build and run
----------------------
1. Install menhir using `opam install menhir`
2. dune build (Ignore the warnings)
3. Invoke executable as  `dune exec simpl <filename>`


Steps to build and run in utop
------------------------------
1. dune build
2. dune utop lib


Steps to Complete and Submit
============================

1. Finish implementing all functions in `lib/eval_smallstep.ml`
2. Upload ONLY the file `lib/eval_smallstep.ml` to the assignment "HW3 Code" in gradescope
3. Don't forget to complete the theory portion as well.
3. Due Date: Monday, Feb 23, 2026
4. Late submission with penalty:
   (a) You can use 3 additional days with penalty to submit your homework.
   (b) Each late day will incur a penalty of 3 points from your final score.
   (c) After 3 days, you can no longer submit. The submission window closes.
