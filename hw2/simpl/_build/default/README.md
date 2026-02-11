This folder contains a dune project for Simpl language described in class, with the eval function for commands left undefined.

+ File `grammar.txt` contains the grammar. 
+ The folder `input` contains sample input files that you can try to interpret and use for testing. Feel free to build more such examples and use the interpreter to play around.
+ lib
   |- ast.ml : Describes the AST of the input program.
   |- eval.ml : Implements the interpreter of Simpl language
   |- lexer.mll : Implements lexer
   |- parser.mly: Implements parser
+ bin
   |- main.ml : Launches the Calc interpreter by reading input file.

In the file `lib/eval.ml`, the function `eval_c` is not yet implemented. You are to implement this function, test it, and then upload the updated `eval.ml` file as your submission


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

1. Implement the function `eval_c` in `lib/eval.ml`
2. Upload ONLY the file `lib/eval.ml` to the assignment "HW2" in gradescope
3. Due Date: Wednesday, Feb 11, 2026
4. Late submission with penalty:
   (a) You can use 3 additional days with penalty to submit your homework.
   (b) Each late day will incur a penalty of 3 points from your final score.
   (c) After 3 days, you can no longer submit. The submission window closes.
