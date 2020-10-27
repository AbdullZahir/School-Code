//-----------------------------------------------------------------------------
//
// Title       : CTRL_ex_time
// Design      : FSM_ex_control
// Author      : user
// Company     : NTNU
//
//-----------------------------------------------------------------------------
//
// File        : c:\digital_camera\FSM_ex_control\src\CTRL_ex_time.v
// Generated   : Tue Nov 13 09:54:11 2018
// From        : interface description file
// By          : Itf2Vhdl ver. 1.22
//
//-----------------------------------------------------------------------------
//
// Description : 
//
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps

//{{ Section below this comment is automatically maintained
//   and may be overwritten
//{module {CTRL_ex_time}}
module CTRL_ex_time (input logic clk, reset, init, Exp_inc, Exp_dec, output logic EX_time);
// -- Enter your statements here -- //
/*typedef enum logic{1:0}	statetype;
statetyp state, nextstate;

// State Register
 always_ff @(posedge clk)
 if (reset) state <= ;
 else state <= nextstate;*/	 
	 
	int counter=0;
	 while(~reset && init){
		 if((Exp_inc && ~Exp_dec) || (Exp_inc && Exp_dec))
			 clk=clk+1ns;
			 counter++;
		if(~Exp_inc && ~Exp_dec)
			clk=clk+1ns;  
			counter++; 
		else //(~Exp_inc && Exp_dec)
			clk=clk-1ns;
			counter--;
	 } 
	 Ex_time = clk;
	 
endmodule
