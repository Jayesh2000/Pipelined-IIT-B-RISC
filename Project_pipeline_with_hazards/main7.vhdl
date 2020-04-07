library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;

entity main7 is
port (
 clk, rst, clk_fpga: in std_logic --;output:out std_logic
);
end entity main7;


architecture behave of main7 is

component register_file_VHDL is
port (
 clk,rst: in std_logic;
 reg_write_en, r7_write_en: in std_logic;
 r7_write_data: in std_logic_vector(15 downto 0);
 r7_read_data: out std_logic_vector(15 downto 0);
 reg_write_dest: in std_logic_vector(2 downto 0);
 reg_write_data: in std_logic_vector(15 downto 0);
 reg_read_addr_1: in std_logic_vector(2 downto 0);
 reg_read_data_1: out std_logic_vector(15 downto 0);
 reg_read_addr_2: in std_logic_vector(2 downto 0);
 reg_read_data_2: out std_logic_vector(15 downto 0)
);
end component;


component lmsmblock is
port(
  clk: in std_logic;
  a: in std_logic_vector(7 downto 0); -- input
  pe_out: out std_logic_vector(2 downto 0);
  lmsmout: out std_logic_vector(7 downto 0) -- LM SM output
 );
end component lmsmblock;


component alu1 is
port(
 a : in std_logic_vector(15 downto 0); -- src1
 alu1_en: in std_logic;
 alu_result: out std_logic_vector(15 downto 0) -- ALU Output Result
 );
end component alu1;


component alu2 is
port(
 zero_prev, carry_prev : in std_logic_vector(0 downto 0);
 a,b : in std_logic_vector(15 downto 0); -- src1, src2
 alu_control : in std_logic_vector(1 downto 0); -- function select
 beq, lm_zero: in std_logic;
 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
 zero_control, carry_control : in std_logic_vector(0 downto 0);
 zero, carry: out std_logic; -- Zero Flag
 beqZ_flag: out std_logic
 );
 end component alu2;
 
 
component alu3 is
port(
 a,b : in std_logic_vector(15 downto 0); -- src1
 alu_result: out std_logic_vector(15 downto 0) -- ALU Output Result
 );
end component alu3;


component alu4 is
port(
 a : in std_logic_vector(15 downto 0); -- src1
 alu_result: out std_logic_vector(15 downto 0) -- ALU Output Result
 );
end component alu4;


component imemory is 
	port (address: in std_logic_vector(15 downto 0); 
			clk, Mem_read_en: in std_logic;
			Mem_dataout: out std_logic_vector(15 downto 0));
end component imemory;


component dmemory is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); 
			clk,d_mem_wr_en: in std_logic;
			Mem_dataout: out std_logic_vector(15 downto 0));
end component dmemory;


component mux3bit2to1 is
   port(A,B: in std_logic_vector(2 downto 0); 
			S: in std_logic;
			Cout: out std_logic_vector(2 downto 0));
end component mux3bit2to1;


component mux3bit4to1 is
   port(A,B,C,D: in std_logic_vector(2 downto 0); 
			S0, S1: in std_logic; 
			Cout: out std_logic_vector(2 downto 0));
end component mux3bit4to1;


component mux16bit2to1 is
   port(A,B: in std_logic_vector(15 downto 0); 
			S: in std_logic; 
			Cout: out std_logic_vector(15 downto 0));
end component mux16bit2to1;


component mux16bit4to1 is
   port(A,B,C,D: in std_logic_vector(15 downto 0); 
			S0, S1: in std_logic; 
			Cout: out std_logic_vector(15 downto 0));
end component mux16bit4to1;


component opcodecontrol is
 port(a,b,c,d:in std_logic; 
		Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7,Cout8,Cout9,Cout10,Cout11: out std_logic);
end component;


component mux8bit2to1 is
   port(A,B: in std_logic_vector(7 downto 0); 
			S: in std_logic; 
			Cout: out std_logic_vector(7 downto 0));
end component mux8bit2to1;

component T2_reg is 
 port (T2_in: in std_logic_vector(7 downto 0); 
 	   clk, rst: in std_logic;
		 T2_out : out std_logic_vector(7 downto 0));
end component T2_reg;

component IFID is
 port (PC, Mem_d: in std_logic_vector(15 downto 0); 
		clk,rst, IFID_en, flag, IFID_rst_flag: in std_logic;
		PC_out, Mem_d_out: out std_logic_vector(15 downto 0); 
		IFID_flag: out std_logic);
end component IFID;

 
component IDRR is
 port (clk,rst,IDRR_en, IFID_flag, IDRR_rst_flag: in std_logic;
	      IFID_opcode: in std_logic_vector(3 downto 0);
	      inp11_9, inp8_6, inp5_3: in std_logic_vector(2 downto 0);
	      inp7_0: in std_logic_vector(7 downto 0);
			se10_ir5_0, se7_ir8_0, ls7_ir8_0, inp_pc: in std_logic_vector(15 downto 0);
			IDRR_flag: out std_logic;
			IDRR_opcode: out std_logic_vector(3 downto 0);
			IDRR11_9, IDRR8_6, IDRR5_3: out std_logic_vector(2 downto 0);
		   IDRR7_0: out std_logic_vector(7 downto 0);
		   IDRRse10_ir5_0, IDRRse7_ir8_0, IDRRls7_ir8_0, IDRRPC_out: out std_logic_vector(15 downto 0)	);
end component IDRR; 


component RREX is 
	port (clk, rst, RREX_en, IDRR_flag, RREX_rst_flag : in std_logic;
	      dest_reg: in std_logic_vector(2 downto 0);
	      r7_read_data, rf_d1, rf_d2: in std_logic_vector(15 downto 0);
			IDRR_opcode: in std_logic_vector(3 downto 0);
			IDRR11_9, IDRR8_6, IDRR5_3: in std_logic_vector(2 downto 0);
		   IDRR7_0: in std_logic_vector(7 downto 0);
			IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRR_PC_out: in std_logic_vector(15 downto 0);
			RREX_flag: out std_logic;
			RREX_dest_reg: out std_logic_vector(2 downto 0);
			RREX_r7_out, RREX_rf_d1, RREX_rf_d2: out std_logic_vector(15 downto 0);
			RREX_opcode: out std_logic_vector(3 downto 0);
			RREX11_9, RREX8_6, RREX5_3: out std_logic_vector(2 downto 0);
			RREX7_0: out std_logic_vector(7 downto 0);
			RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out: out std_logic_vector(15 downto 0)
			);
end component;


component EXMA is 
	port (clk, rst, EXMA_en, EXMA_rst_flag: in std_logic;
	      zero_prev, carry_prev: in std_logic_vector(0 downto 0);
	      RREX_opcode: in std_logic_vector(3 downto 0);
			RREX_dest_reg: in std_logic_vector(2 downto 0);
			RREX_r7_out, RREX_rf_d1, RREX_rf_d2: in std_logic_vector(15 downto 0);
			RREX11_9, RREX8_6, RREX5_3: in std_logic_vector(2 downto 0);
			RREX7_0: in std_logic_vector(7 downto 0);
			RREX_ls7_ir8_0, RREX_PC_out: in std_logic_vector(15 downto 0);
			--prev RREX output, RREX_dest, 
         alu_result_dummy, alu3_out: in std_logic_vector(15 downto 0);
			EXMA_zero_prev, EXMA_carry_prev: out std_logic_vector(0 downto 0);
			EXMA_opcode: out std_logic_vector(3 downto 0);
			EXMA_dest_reg: out std_logic_vector(2 downto 0);
			EXMA_r7_out, EXMA_rf_d1, EXMA_rf_d2: out std_logic_vector(15 downto 0);
			EXMA11_9, EXMA8_6, EXMA5_3: out std_logic_vector(2 downto 0);
			EXMA7_0: out std_logic_vector(7 downto 0);
			EXMA_ls7_ir8_0, EXMA_PC_out: out std_logic_vector(15 downto 0);
			--prev RREX output, RREX_dest, 
      	    EXMA_alu2_out, EXMA_alu3_out: out std_logic_vector(15 downto 0)
		   ); 
end component;


component MAWB is 
	port (clk, rst, MAWB_en, MAWB_rst_flag: in std_logic;
	EXMA_zero_prev, EXMA_carry_prev: in std_logic_vector(0 downto 0);
	      EXMA_dest_reg: in std_logic_vector(2 downto 0);
		  EXMA_opcode: in std_logic_vector(3 downto 0);	--mawb output:
 			EXMA11_9, EXMA8_6, EXMA5_3: in std_logic_vector(2 downto 0);
          EXMA7_0: in std_logic_vector(7 downto 0);
			 data_mem_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out:in std_logic_vector(15 downto 0);
		  MAWB_zero_prev, MAWB_carry_prev: out std_logic_vector(0 downto 0);
		  MAWB_dest_reg: out std_logic_vector(2 downto 0);
		  MAWB_opcode: out std_logic_vector(3 downto 0);	--mawb output:
		  	MAWB11_9, MAWB8_6, MAWB5_3: out std_logic_vector(2 downto 0);
			MAWB7_0: out std_logic_vector(7 downto 0);
		  MAWB_data_mem_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out: out std_logic_vector(15 downto 0)); 
end component;
 --fsm   
-- type FsmState is (inst_fetch, inst_decode, reg_read, execute, mem_access, write_back);--dummy1,dummy2,dummy3,dummy4,dummy5,dummy6,dummy7,dummy8,dummy9,dummy10,dummy11,dummy12,dummy13,dummy14,dummy15,dummy16,dummy17,dummy18,dummy19,dummy20,dummy21,dummy22,dummy23,dummy24,dummy25,dummy26);
 type FsmState is (s0, s1, s2, s3, s4, s5, s6, s7);
 signal fsm_state: FsmState;
 
 signal IFID_PC_out, IFID_Mem_d_out: std_logic_vector(15 downto 0);
 signal IDRR11_9, IDRR8_6, IDRR5_3:  std_logic_vector(2 downto 0);
 signal IDRR7_0: std_logic_vector(7 downto 0);
 signal IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out: std_logic_vector(15 downto 0);
 signal RREX_r7_out, RREX_rf_d1, RREX_rf_d2,RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out: std_logic_vector(15 downto 0);
 signal RREX7_0: std_logic_vector(7 downto 0);
 signal EXMA_PC_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out: std_logic_vector(15 downto 0);
 signal MAWB_data_mem_out, MAWB_PC_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out: std_logic_vector(15 downto 0);
 signal MAWB11_9, MAWB8_6, MAWB5_3: std_logic_vector(2 downto 0);
 signal MAWB7_0: std_logic_vector(7 downto 0);
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0');
 signal next_IP, T1: std_logic_vector(15 downto 0);
 signal  zero_prev_dummy, carry_prev_dummy : std_logic_vector(0 downto 0);
 signal a_dummy,b_dummy :  std_logic_vector(15 downto 0); -- src1, src2
 signal alu_control_dummy : std_logic_vector(1 downto 0); -- function select
 signal alu_result_dummy: std_logic_vector(15 downto 0); -- ALU Output Result
 signal zero_control_dummy, carry_control_dummy :  std_logic_vector(0 downto 0);
 signal zero_dummy,zero_dummy_dummy, carry_dummy: std_logic;
 signal alu3_a, alu3_b, alu3_out: std_logic_vector(15 downto 0);
 signal i_memd_out: std_logic_vector(15 downto 0);
 signal i_mem_read_en: std_logic;
 signal ALU1_en: std_logic;
 signal reg_write_en_dummy, r7_write_en: std_logic;
 signal reg_write_dest_dummy: std_logic_vector(2 downto 0);
 signal reg_write_data_dummy, r7_write_data, r7_read_data, r7_write1: std_logic_vector(15 downto 0);
 signal reg_read_addr_1_dummy: std_logic_vector(2 downto 0);
 signal reg_read_data_1_dummy: std_logic_vector(15 downto 0);
 signal reg_read_addr_2_dummy: std_logic_vector(2 downto 0);
 signal reg_read_data_2_dummy: std_logic_vector(15 downto 0);
 signal data_addr, data_mem_in, data_mem_out: std_logic_vector(15 downto 0);
 signal d_mem_wr_en: std_logic;
 signal opcode: std_logic_vector(3 downto 0);
 signal se10_ir5_0, se7_ir8_0, ls7_ir8_0: std_logic_vector(15 downto 0);
 signal IFID_en, IDRR_en, RREX_en, EXMA_en, MAWB_en: std_logic;
 signal s_rf_a1, s_rf_a2, s0_rf_a3, s1_rf_a3: std_logic;
 signal rf_a1_a, rf_a1_b, rf_a1: std_logic_vector(2 downto 0);
 signal rf_a2_a, rf_a2_b, rf_a2: std_logic_vector(2 downto 0);
 signal rf_a3_a, rf_a3_b, rf_a3_c, rf_a3_d, rf_a3: std_logic_vector(2 downto 0);
 signal beqZ_flag: std_logic;
 signal T2_in, T2_out: std_logic_vector(7 downto 0);
 signal T2_rst: std_logic;
 signal T2, lmsm_out: std_logic_vector(7 downto 0);
 signal pe_out: std_logic_vector(2 downto 0);
 signal opcodeaddCout, opcodeadiCout, opcodenduCout, opcodelwCout,opcodeswCout, opcodelhiCout, opcodelmCout, opcodesmCout, opcodebeqCout, opcodejalCout, opcodejlrCout : std_logic;
 signal s_t1, s_t2, s_alu2a, s0_alu2b, s1_alu2b, s_alu3b: std_logic;
 signal s_ma: std_logic;
 signal s_din, s0_r7in, s1_r7in, s0_rfd3, s1_rfd3: std_logic;
 signal r7_write_data_mux: std_logic_vector(15 downto 0);
 --type lmsmstate is (s0, s1);
 --signal lmsm_state: lmsmstate;
 signal flag, IFID_rst_flag, IFID_flag: std_logic;
 signal IDRR_rst_flag, IDRR_flag: std_logic;
 signal IDRR_opcode: std_logic_vector(3 downto 0);
 signal RREX_rst_flag, RREX_flag: std_logic;
 signal dest_reg, RREX_dest_reg: std_logic_vector(2 downto 0);
 signal RREX_opcode: std_logic_vector(3 downto 0);
 signal RREX11_9, RREX8_6, RREX5_3: std_logic_vector(2 downto 0);
 signal EXMA_rst_flag, EXMA_flag, MAWB_rst_flag: std_logic;
 signal EXMA_zero_prev, EXMA_carry_prev, MAWB_zero_prev, MAWB_carry_prev: std_logic_vector(0 downto 0);
 signal EXMA_opcode: std_logic_vector(3 downto 0);
 signal EXMA_dest_reg: std_logic_vector(2 downto 0); 
 signal EXMA11_9, EXMA8_6, EXMA5_3: std_logic_vector(2 downto 0);
 signal EXMA7_0: std_logic_vector(7 downto 0);
 signal MAWB_dest_reg: std_logic_vector(2 downto 0);
 signal MAWB_opcode: std_logic_vector(3 downto 0);
 signal IDRR_opcodeaddCout, IDRR_opcodeadiCout, IDRR_opcodenduCout, IDRR_opcodelhiCout, IDRR_opcodelwCout, IDRR_opcodeswCout, IDRR_opcodelmCout, IDRR_opcodesmCout, IDRR_opcodebeqCout, IDRR_opcodejalCout, IDRR_opcodejlrCout: std_logic;
 signal RREX_opcodeaddCout, RREX_opcodeadiCout, RREX_opcodenduCout, RREX_opcodelhiCout, RREX_opcodelwCout, RREX_opcodeswCout, RREX_opcodelmCout, RREX_opcodesmCout, RREX_opcodebeqCout, RREX_opcodejalCout, RREX_opcodejlrCout: std_logic;
 signal EXMA_opcodeaddCout, EXMA_opcodeadiCout, EXMA_opcodenduCout, EXMA_opcodelhiCout, EXMA_opcodelwCout, EXMA_opcodeswCout, EXMA_opcodelmCout, EXMA_opcodesmCout, EXMA_opcodebeqCout, EXMA_opcodejalCout, EXMA_opcodejlrCout: std_logic;
 signal MAWB_opcodeaddCout, MAWB_opcodeadiCout, MAWB_opcodenduCout, MAWB_opcodelhiCout, MAWB_opcodelwCout, MAWB_opcodeswCout, MAWB_opcodelmCout, MAWB_opcodesmCout, MAWB_opcodebeqCout, MAWB_opcodejalCout, MAWB_opcodejlrCout: std_logic;
 signal rfd3_mux_out: std_logic_vector(15 downto 0);
 signal  s_rfd3_lmsm_mux: std_logic;
 signal alu4_in, alu4_out: std_logic_vector(15 downto 0);
 signal WB_forw_out, forw1_d1, forw2_d2: std_logic_vector(15 downto 0);
 signal s0_forw1, s1_forw1, s0_forw2, s1_forw2, s0_wb_forw, s1_wb_forw: std_logic;
 signal s_r7minimux: std_logic;
 signal beq, lm_zero: std_logic;
 begin
 alu1_block: alu1 port map(r7_read_data,ALU1_en,next_IP);
 inst_mem: imemory port map(r7_read_data, clk, i_mem_read_en, i_memd_out);
 IFIDreg: IFID port map(r7_read_data, i_memd_out,clk, rst, IFID_en, flag, IFID_rst_flag, IFID_PC_out, IFID_Mem_d_out, IFID_flag);
 IDRRreg: IDRR port map(clk, rst, IDRR_en, IFID_flag, IDRR_rst_flag, opcode, IFID_Mem_d_out(11 downto 9), IFID_Mem_d_out(8 downto 6), IFID_Mem_d_out(5 downto 3), IFID_Mem_d_out(7 downto 0),se10_ir5_0, se7_ir8_0, ls7_ir8_0, IFID_PC_out,IDRR_flag, IDRR_opcode, IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out);
 rfa1mux: mux3bit2to1 port map(IDRR11_9, IDRR8_6, s_rf_a1, reg_read_addr_1_dummy);
 rfa2mux: mux3bit2to1 port map(IDRR8_6, pe_out, s_rf_a2, reg_read_addr_2_dummy);
 rfa3mux: mux3bit4to1 port map(MAWB11_9, MAWB8_6, MAWB5_3, pe_out, s0_rf_a3, s1_rf_a3, reg_write_dest_dummy); 
 r7inmux: mux16bit4to1 port map(r7_write_data_mux, r7_write1, reg_read_data_2_dummy, data_mem_out , s0_r7in, s1_r7in, r7_write_data); --alu1_out
 r7minimux: mux16bit2to1 port map(alu3_out,alu_result_dummy, s_r7minimux, r7_write1); 
 reg1: register_file_VHDL port map (clk, rst,reg_write_en_dummy, r7_write_en, r7_write_data, r7_read_data,reg_write_dest_dummy, reg_write_data_dummy,reg_read_addr_1_dummy,reg_read_data_1_dummy, reg_read_addr_2_dummy, reg_read_data_2_dummy);
 forwardingmux1: mux16bit4to1 port map(alu_result_dummy, data_mem_out,WB_forw_out,reg_read_data_1_dummy, s0_forw1, s1_forw1, forw1_d1); 
 forwardingmux2: mux16bit4to1 port map(alu_result_dummy, data_mem_out,WB_forw_out,reg_read_data_2_dummy, s0_forw2, s1_forw2, forw2_d2); 
 RREXreg: RREX port map(clk, rst, RREX_en, IDRR_flag, RREX_rst_flag,dest_reg, r7_read_data, forw1_d1, forw2_d2,IDRR_opcode, IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out,RREX_flag, RREX_dest_reg, RREX_r7_out, RREX_rf_d1, RREX_rf_d2, RREX_opcode,RREX11_9, RREX8_6, RREX5_3, RREX7_0, RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out); 
 alu2amux: mux16bit2to1 port map(RREX_rf_d1, RREX_rf_d2, s_alu2a, a_dummy);
 alu2bmux: mux16bit2to1 port map(RREX_rf_d2, RREX_se10_ir5_0, s0_alu2b, b_dummy);
 alu2_block: alu2 port map (zero_prev_dummy, carry_prev_dummy,a_dummy,b_dummy ,alu_control_dummy , RREX_opcodebeqCout, lm_zero, alu_result_dummy,zero_control_dummy, carry_control_dummy,zero_dummy, carry_dummy, beqZ_flag);
 alu3bmux: mux16bit2to1 port map(RREX_se10_ir5_0, RREX_se7_ir8_0, s_alu3b, alu3_b);
 alu3_block: alu3 port map(RREX_PC_out, alu3_b, alu3_out);
 EXMAreg: EXMA port map(clk, rst, EXMA_en, EXMA_rst_flag, zero_prev_dummy, carry_prev_dummy, RREX_opcode, RREX_dest_reg, RREX_r7_out, RREX_rf_d1, RREX_rf_d2, RREX11_9, RREX8_6, RREX5_3, RREX7_0, RREX_ls7_ir8_0, RREX_PC_out, alu_result_dummy, alu3_out, EXMA_zero_prev, EXMA_carry_prev, EXMA_opcode, EXMA_dest_reg, EXMA_r7_out, EXMA_rf_d1, EXMA_rf_d2, EXMA11_9, EXMA8_6, EXMA5_3, EXMA7_0, EXMA_ls7_ir8_0, EXMA_PC_out, EXMA_alu2_out, EXMA_alu3_out);
 maaddrmux: mux16bit2to1 port map(T1, EXMA_alu2_out, s_ma, data_addr);
 data_mem: dmemory port map(data_addr, data_mem_in, clk, d_mem_wr_en, data_mem_out);
 MAWBreg: MAWB port map(clk, rst, MAWB_en, MAWB_rst_flag, EXMA_zero_prev, EXMA_carry_prev, EXMA_dest_reg, EXMA_opcode,EXMA11_9, EXMA8_6, EXMA5_3, EXMA7_0, data_mem_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out,MAWB_zero_prev, MAWB_carry_prev, MAWB_dest_reg, MAWB_opcode,MAWB11_9, MAWB8_6, MAWB5_3,MAWB7_0, MAWB_data_mem_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out); 
 madinmux: mux16bit2to1 port map(MAWB_rf_d2, MAWB_rf_d1, s_din, data_mem_in); 
 rfd3mux: mux16bit4to1 port map(MAWB_alu2_out, MAWB_r7_out, MAWB_data_mem_out, MAWB_ls7_ir8_0, s0_rfd3, s1_rfd3, rfd3_mux_out);
 rfd3_lmsm_mux: mux16bit2to1 port map(rfd3_mux_out, data_mem_out, s_rfd3_lmsm_mux,reg_write_data_dummy); 
 wb_forwarding_mux: mux16bit4to1 port map(MAWB_data_mem_out, MAWB_alu2_out, MAWB_alu3_out, Z16, s0_wb_forw, s1_wb_forw, WB_forw_out);
 lmsm_unit: lmsmblock port map(clk, T2, pe_out, lmsm_out); 
 t2mux: mux8bit2to1 port map(IFID_Mem_d_out(7 downto 0), lmsm_out,s_t2, T2);
 t1mux: mux16bit2to1 port map(RREX_rf_d1, alu4_out, s_t1, T1);
 --T2_register: T2_reg port map(T2_in, clk, T2_rst, T2_out);
 alu4_block: alu4 port map(alu4_in, alu4_out);
 ID_opcode_logic: opcodecontrol port map(opcode(3), opcode(2), opcode(1), opcode(0), opcodeaddCout, opcodeadiCout, opcodenduCout, opcodelhiCout, opcodelwCout, opcodeswCout, opcodelmCout, opcodesmCout, opcodebeqCout, opcodejalCout, opcodejlrCout); --even for adc, adz
 RR_opcode_logic: opcodecontrol port map(IDRR_opcode(3), IDRR_opcode(2), IDRR_opcode(1), IDRR_opcode(0), IDRR_opcodeaddCout, IDRR_opcodeadiCout, IDRR_opcodenduCout, IDRR_opcodelhiCout, IDRR_opcodelwCout, IDRR_opcodeswCout, IDRR_opcodelmCout, IDRR_opcodesmCout, IDRR_opcodebeqCout, IDRR_opcodejalCout, IDRR_opcodejlrCout);
 EX_opcode_logic: opcodecontrol port map(RREX_opcode(3), RREX_opcode(2), RREX_opcode(1), RREX_opcode(0), RREX_opcodeaddCout, RREX_opcodeadiCout, RREX_opcodenduCout, RREX_opcodelhiCout, RREX_opcodelwCout, RREX_opcodeswCout, RREX_opcodelmCout, RREX_opcodesmCout, RREX_opcodebeqCout, RREX_opcodejalCout, RREX_opcodejlrCout);
 MA_opcode_logic: opcodecontrol port map(EXMA_opcode(3), EXMA_opcode(2), EXMA_opcode(1), EXMA_opcode(0), EXMA_opcodeaddCout, EXMA_opcodeadiCout, EXMA_opcodenduCout, EXMA_opcodelhiCout, EXMA_opcodelwCout, EXMA_opcodeswCout, EXMA_opcodelmCout, EXMA_opcodesmCout, EXMA_opcodebeqCout, EXMA_opcodejalCout, EXMA_opcodejlrCout);
 WB_opcode_logic: opcodecontrol port map(MAWB_opcode(3), MAWB_opcode(2), MAWB_opcode(1), MAWB_opcode(0), MAWB_opcodeaddCout, MAWB_opcodeadiCout, MAWB_opcodenduCout, MAWB_opcodelhiCout, MAWB_opcodelwCout, MAWB_opcodeswCout, MAWB_opcodelmCout, MAWB_opcodesmCout, MAWB_opcodebeqCout, MAWB_opcodejalCout, MAWB_opcodejlrCout);
 --zero_prev_dummy(0 downto 0)<="0";
 --carry_prev_dummy(0 downto 0)<="0";
-- output<=alu_result_dummy(0);
 process(clk, rst)
 variable next_IP_var: std_logic_vector(15 downto 0);
 variable next_fsm_state:FsmState;
 variable T1var: std_logic_vector(15 downto 0);
 variable z_prev_dummy_var, c_prev_dummy_var: std_logic_vector(0 downto 0);
 variable z_flag: std_logic;
 variable s_t1_var, s_t2_var: std_logic;
 variable alu4_in_var: std_logic_vector(15 downto 0);
 variable s_alu2a_var, s0_alu2b_var, s_alu3b_var, carry_control_var, zero_control_var, RREX_rst_flag_var,
 EXMA_rst_flag_var, s_ma_var, s_din_var, s0_rfd3_var, s1_rfd3_var, d_mem_wr_en_var, s0_rf_a3_var, s1_rf_a3_var,
 reg_write_en_var: std_logic;
 variable alu_control_var: std_logic_vector(1 downto 0);
 variable s_rf_a1_var, s_rf_a2_var, ALU1_en_var, IDRR_en_var, RREX_en_var, IFID_en_var: std_logic;
 --variable rrex_rst_var, exma_rst_var: std_logic;
 --variable var_s_rf_a2: std_logic;
 --variable 
 begin
 next_fsm_state := fsm_state;
 s_t1_var := '1';
 s_t2_var := '1';
 s_alu2a_var:= '1';
 s0_alu2b_var:='1';
 --rrex_rst_var := '1';
 --exma_rst_var := '1';
 --z_prev_dummy_var(0) := '0';
 --c_prev_dummy_var(0) := '0';
 --z_flag := '0';
 case next_fsm_state is
    when s0=>
	  next_IP_var := next_IP;
	  
	  if((IDRR_opcodelmCout = '1' or IDRR_opcodesmCout = '1')) then
	  IDRR_rst_flag<='1';
	 IDRR_en<='0';
	  ALU1_en<='0';
	  --RREX_en<='0';
	  IFID_en<='0';
	       s_alu2a<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodebeqCout;
 s0_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodebeqCout; --or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodeswCout or RREX_opcodebeqCout;
 --s1_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodelwCout or RREX_opcodebeqCout or not(RREX_opcodelmCout) or not(RREX_opcodesmCout);
 s_alu3b<= RREX_opcodebeqCout;
 if(RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1' or RREX_opcodelwCout='1' or RREX_opcodeswCout = '1') then
 alu_control_dummy<="00";
 if (RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1') then
 carry_control_dummy(0)<='1';
 zero_control_dummy(0)<='1';
 elsif(RREX_opcodelwCout='1') then
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';
 else
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='0';
 end if; 
 elsif (RREX_opcodenduCout = '1') then
 alu_control_dummy<="01";
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';
 elsif (RREX_opcodebeqCout = '1') then
 alu_control_dummy<="10";
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';  --changed later
 end if;
    
	  next_fsm_state := s1;
	  s_rfd3_lmsm_mux<='1';
	  else
	  next_fsm_state := s0;
	  i_mem_read_en<='1';
	  --RREX_rst_flag<='0';
	  --EXMA_rst_flag<='0';
	  ALU1_en<='1';
	  IDRR_en<='1';
	  RREX_en<='1';
	  IFID_en<='1';
	  s_rf_a1<= IDRR_opcodeaddCout or IDRR_opcodeadiCout or IDRR_opcodenduCout or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodelmCout or IDRR_opcodesmCout; -- same mux for lm_sm
     s_rf_a2<= IDRR_opcodeaddCout or IDRR_opcodenduCout or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodejlrCout ;
	  s_rfd3_lmsm_mux<='1';
	  s0_rf_a3<= MAWB_opcodeadiCout or MAWB_opcodelwCout or (MAWB_opcodejalCout and (not(MAWB_dest_reg(2)) or not(MAWB_dest_reg(1)) or not(MAWB_dest_reg(0))) ) or (MAWB_opcodejlrCout and (not(MAWB_dest_reg(2)) or not(MAWB_dest_reg(1)) or not(MAWB_dest_reg(0)))) or MAWB_opcodelhiCout ; --probably shift in wb stage
     s1_rf_a3<= MAWB_opcodeaddCout or  MAWB_opcodenduCout or  MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout;
     reg_write_en_dummy<=(MAWB_opcodeaddCout and ((not(MAWB7_0(0)) and not(MAWB7_0(1))) or ((MAWB7_0(1)) and not(MAWB7_0(0)) and MAWB_carry_prev(0)) or (not(MAWB7_0(1)) and (MAWB7_0(0)) and MAWB_zero_prev(0)) )) or  (MAWB_opcodenduCout and ((not(MAWB7_0(0)) and not(MAWB7_0(1))) or ((MAWB7_0(1)) and not(MAWB7_0(0)) and MAWB_carry_prev(0)) or (not(MAWB7_0(1)) and (MAWB7_0(0)) and MAWB_zero_prev(0)) )) or MAWB_opcodeadiCout or MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout or MAWB_opcodelmCout;
     r7_write_en<='1';
	  
	  if (EXMA_dest_reg = "111" and EXMA_opcodelwCout = '1') then
	   s0_r7in<='0';
		s1_r7in<='0';
	  elsif  (IDRR_opcodejlrCout = '1') then
	   s0_r7in<='0'; 
		s1_r7in<='1';
		elsif((((RREX_opcodeaddCout = '1' and ((RREX7_0(1 downto 0) = "00") or (RREX7_0(1 downto 0) = "10" and carry_prev_dummy(0) = '1') or (RREX7_0(1 downto 0) = "01" and zero_prev_dummy(0) = '1') ) ) or 
	  (RREX_opcodenduCout = '1' and ((RREX7_0(1 downto 0) = "00") or (RREX7_0(1 downto 0) = "10" and carry_prev_dummy(0) = '1') or (RREX7_0(1 downto 0) = "01" and zero_prev_dummy(0) = '1') ) ) or
	   RREX_opcodelhiCout = '1') and RREX_dest_reg = "111") or (RREX_opcodebeqCout = '1' and beqZ_flag = '1') or (RREX_opcodejalCout = '1')) then
		 s0_r7in<='1'; 
		s1_r7in<='0';
		 if ( (RREX_opcodebeqCout = '1' and beqZ_flag = '1') or (RREX_opcodejalCout = '1')) then
		  s_r7minimux<='1'; --alu3out
		 else
		  s_r7minimux<='0'; --alu2out
		 end if;
	  else
	   s0_r7in<='1';
		s1_r7in<='1';
	    
	  end if;
	  
	  
	  --Destination Register Logic
	  if (opcodeaddCout = '1' or opcodenduCout = '1') then
	   dest_reg<= IDRR5_3;
	  elsif (opcodeadiCout = '1' or opcodelhiCout = '1') then
	   dest_reg<= IDRR8_6;
	  elsif (opcodelhiCout = '1' or opcodejalCout = '1' or opcodejlrCout='1') then
	   dest_reg<= IDRR11_9;
	  end if;
	  
	  --FORWARDING LOGIC
 
     if  ( ( (   (RREX_dest_reg(0) xor reg_read_addr_1_dummy(0))    or    (RREX_dest_reg(1) xor reg_read_addr_1_dummy(1))   or    (RREX_dest_reg(2) xor reg_read_addr_1_dummy(2))   )
     and (    (EXMA_dest_reg(0) xor reg_read_addr_1_dummy(0))    or    (EXMA_dest_reg(1) xor reg_read_addr_1_dummy(1))   or    (EXMA_dest_reg(2) xor reg_read_addr_1_dummy(2))   )
     and (    (MAWB_dest_reg(0) xor reg_read_addr_1_dummy(0))    or    (MAWB_dest_reg(1) xor reg_read_addr_1_dummy(1))   or    (MAWB_dest_reg(2) xor reg_read_addr_1_dummy(2))   )
         )  = '1'  )  then
			
		s0_forw1<='0';
		s1_forw1<='0';	
		
   elsif   (  (RREX_dest_reg(0) = reg_read_addr_1_dummy(0))   and   (RREX_dest_reg(1) = reg_read_addr_1_dummy(1))   and   (RREX_dest_reg(2) = reg_read_addr_1_dummy(2)) ) then 
	   if (RREX_opcode = "1111") then
		 s0_forw1<='0';
		 s1_forw1<='0';
		else
		if (( (RREX_opcodeaddCout ='1' and  ( (RREX7_0(1 downto 0) = "10" and carry_prev_dummy(0) = '1')   or   (RREX7_0(1 downto 0) = "01" and zero_prev_dummy(0) = '1')  ) ) or
                  (RREX_opcodenduCout ='1' and  ( (RREX7_0(1 downto 0) = "10" and carry_prev_dummy(0) = '1')   or   (RREX7_0(1 downto 0) = "01" and zero_prev_dummy(0) = '1')  ) ) ) 
			  )   then
      			  
	   s0_forw1<='0';
		s1_forw1<='0';		
		end if;
		end if;
		elsif(((EXMA_dest_reg(0) xnor reg_read_addr_1_dummy(0))  and  (EXMA_dest_reg(1) xnor reg_read_addr_1_dummy(1))  and  (EXMA_dest_reg(2) xnor reg_read_addr_1_dummy(2))) = '1'  ) then
      if (EXMA_opcode = "1111") then
		s0_forw1<='0';
		s1_forw1<='0';
		else
      s0_forw1<='1';
      s1_forw1<='0';
	   end if;
		
		elsif(((MAWB_dest_reg(0) xnor reg_read_addr_1_dummy(0))  and  (MAWB_dest_reg(1) xnor reg_read_addr_1_dummy(1))  and  (MAWB_dest_reg(2) xnor reg_read_addr_1_dummy(2))) = '1'  ) then
	   if (MAWB_opcode = "1111") then
		s0_forw1<='0';
		s1_forw1<='0';
		else
	   s0_forw1<='0';
      s1_forw1<='1';
      end if;
       else
      	s0_forw1<='0';
         s1_forw1<='0';

	  end if;

 if  ( ( (   (RREX_dest_reg(0) xor reg_read_addr_2_dummy(0))    or    (RREX_dest_reg(1) xor reg_read_addr_2_dummy(1))   or    (RREX_dest_reg(2) xor reg_read_addr_2_dummy(2))   )
     and (    (EXMA_dest_reg(0) xor reg_read_addr_2_dummy(0))    or    (EXMA_dest_reg(1) xor reg_read_addr_2_dummy(1))   or    (EXMA_dest_reg(2) xor reg_read_addr_2_dummy(2))   )
     and (    (MAWB_dest_reg(0) xor reg_read_addr_2_dummy(0))    or    (MAWB_dest_reg(1) xor reg_read_addr_2_dummy(1))   or    (MAWB_dest_reg(2) xor reg_read_addr_2_dummy(2))   )
         )  = '1'  )  then
			
		s0_forw2<='0';
		s1_forw2<='0';	
		
     elsif(  (RREX_dest_reg(0) = reg_read_addr_2_dummy(0))   and   (RREX_dest_reg(1) = reg_read_addr_2_dummy(1))   and   (RREX_dest_reg(2) = reg_read_addr_2_dummy(2)) ) then 
	   if (RREX_opcode = "1111") then
		 s0_forw2<='0';
		 s1_forw2<='0';
		else
		if (( (RREX_opcodeaddCout ='1' and  ( (RREX7_0(1 downto 0) = "10" and carry_prev_dummy(0) = '1')   or   (RREX7_0(1 downto 0) = "01" and zero_prev_dummy(0) = '1')  ) ) or
                  (RREX_opcodenduCout ='1' and  ( (RREX7_0(1 downto 0) = "10" and carry_prev_dummy(0) = '1')   or   (RREX7_0(1 downto 0) = "01" and zero_prev_dummy(0) = '1')  ) ) ) 
			  )   then
	   s0_forw2<='0';
		s1_forw2<='0';		
		end if;
		end if;
		elsif(((EXMA_dest_reg(0) xnor reg_read_addr_2_dummy(0))  and  (EXMA_dest_reg(1) xnor reg_read_addr_2_dummy(1))  and  (EXMA_dest_reg(2) xnor reg_read_addr_2_dummy(2))) = '1'  ) then
      if (MAWB_opcode = "1111") then
		s0_forw2<='0';
		s1_forw2<='0';
		else 
      s0_forw2<='1';
      s1_forw2<='0';
	   end if;
		
		elsif(((MAWB_dest_reg(0) xnor reg_read_addr_2_dummy(0))  and  (MAWB_dest_reg(1) xnor reg_read_addr_2_dummy(1))  and  (MAWB_dest_reg(2) xnor reg_read_addr_2_dummy(2))) = '1'  ) then
	   if (MAWB_opcode = "1111") then
		s0_forw2<='0';
		s1_forw2<='0';
		else
		s0_forw2<='0';
      s1_forw2<='1';
      end if;
      else
      s0_forw2<='0';
      s1_forw2<='0';

	  end if;	 
	 --END OF FORWARDING LOGIC
	 
 --s0_r7in<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or opcodeswCout or (MAWB_opcodebeqCout and not(beqZflag)) or (not(MAWB_opcodebeqCout and beqZflag)) or (not MAWB_opcodejalCout) or MAWB_opcodejlrCout or opcodelhiCout or opcodelmCout or opcodesmCout or opcodejalCout or opcodejlrCout or opcodebeqCout;
 --s1_r7in<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or opcodeswCout or (MAWB_opcodebeqCout and not(beqZflag)) or (MAWB_opcodebeqCout and beqZflag) or MAWB_opcodejalCout or not(MAWB_opcodejlrCout) or opcodelhiCout or opcodelmCout or opcodesmCout or opcodejalCout or opcodejlrCout or opcodebeqCout;
 --IFID_en<='1';
 
 se10_ir5_0 <= IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5 downto 0);
 se7_ir8_0 <= IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8 downto 0);
 ls7_ir8_0(15 downto 7) <= IFID_Mem_d_out(8 downto 0);
 ls7_ir8_0(6 downto 0) <= "0000000";
 opcode <= IFID_Mem_d_out(15 downto 12);
 --IDRR_en<='1';
 
 
 --RREX_en<='1';
 
 --s_t1<='1';
 --s_t2<='1' ;1
 s_alu2a<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodebeqCout;
 s0_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodebeqCout; --or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodeswCout or RREX_opcodebeqCout;
 --s1_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodelwCout or RREX_opcodebeqCout or not(RREX_opcodelmCout) or not(RREX_opcodesmCout);
 s_alu3b<= RREX_opcodebeqCout;
 if(RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1' or RREX_opcodelwCout='1' or RREX_opcodeswCout = '1') then
 alu_control_dummy<="00";
 if (RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1') then
 carry_control_dummy(0)<='1';
 zero_control_dummy(0)<='1';
 elsif(RREX_opcodelwCout='1') then
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';
 else
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='0';
 end if; 
 elsif (RREX_opcodenduCout = '1') then
 alu_control_dummy<="01";
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';
 elsif (RREX_opcodebeqCout = '1') then
 alu_control_dummy<="10";
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';  --changed later
 end if;
 --z_prev_dummy_var(0) := zero_dummy;
 --c_prev_dummy_var(0) := carry_dummy;
 --z_flag := zero_dummy;
-- if(RREX_opcodebeqCout = '1') then
-- beqZflag<=zero_dummy_dummy;
-- zero_dummy <= zero_prev_dummy(0);
-- else
-- beqZflag<='0';
-- zero_dummy <= zero_dummy_dummy;
-- end if;
 EXMA_en<='1';
 
 s_ma<=EXMA_opcodelmCout;
 MAWB_en<='1';
 
 s_din<=MAWB_opcodesmCout;
 s0_rfd3<=MAWB_opcodeaddCout or MAWB_opcodeadiCout or MAWB_opcodenduCout or MAWB_opcodejalCOut or MAWB_opcodejlrCout;
 s1_rfd3<=MAWB_opcodeaddCout or MAWB_opcodeadiCout or MAWB_opcodenduCout or MAWB_opcodelwCout or MAWB_opcodelmCout;
 d_mem_wr_en<=MAWB_opcodeswCout or MAWB_opcodesmCout;
-- if (MAWB_opcodelwCout = '1' and MAWB_data_mem_out = Z16) then
--  lm_zero<= '1';
-- end if;
 
 
 end if;
	  --end if;
	 when s1=>
--	 s_rf_a1<= IDRR_opcodeaddCout or IDRR_opcodeadiCout or IDRR_opcodenduCout or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodelmCout or IDRR_opcodesmCout; -- same mux for lm_sm
--     s_rf_a2<= IDRR_opcodeaddCout or IDRR_opcodenduCout or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodejlrCout ;
--	  s_rfd3_lmsm_mux<='1';
--     s_alu2a<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodebeqCout;
-- s0_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodebeqCout; --or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodeswCout or RREX_opcodebeqCout;
-- --s1_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodelwCout or RREX_opcodebeqCout or not(RREX_opcodelmCout) or not(RREX_opcodesmCout);
-- s_alu3b<= RREX_opcodebeqCout;
-- if(RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1' or RREX_opcodelwCout='1' or RREX_opcodeswCout = '1') then
-- alu_control_dummy<="00";
-- if (RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1') then
-- carry_control_dummy(0)<='1';
-- zero_control_dummy(0)<='1';
-- elsif(RREX_opcodelwCout='1') then
-- carry_control_dummy(0)<='0';
-- zero_control_dummy(0)<='1';
-- else
-- carry_control_dummy(0)<='0';
-- zero_control_dummy(0)<='0';
-- end if; 
-- elsif (RREX_opcodenduCout = '1') then
-- alu_control_dummy<="01";
-- carry_control_dummy(0)<='0';
-- zero_control_dummy(0)<='1';
-- elsif (RREX_opcodebeqCout = '1') then
-- alu_control_dummy<="10";
-- carry_control_dummy(0)<='0';
-- zero_control_dummy(0)<='1';  --changed later
-- end if;
--    
    s_ma<=EXMA_opcodelmCout;
     RREX_rst_flag<='1';
	  next_fsm_state := s2;
	 when s2=>
	  EXMA_rst_flag<='1';
	   s_din<=MAWB_opcodesmCout;
	  s0_rfd3<=MAWB_opcodeaddCout or MAWB_opcodeadiCout or MAWB_opcodenduCout or MAWB_opcodejalCOut or MAWB_opcodejlrCout;
	  s1_rfd3<=MAWB_opcodeaddCout or MAWB_opcodeadiCout or MAWB_opcodenduCout or MAWB_opcodelwCout or MAWB_opcodelmCout;
	  d_mem_wr_en<=MAWB_opcodeswCout or MAWB_opcodesmCout;
	  s0_rf_a3<= MAWB_opcodeadiCout or MAWB_opcodelwCout or (MAWB_opcodejalCout and (not(MAWB_dest_reg(2)) or not(MAWB_dest_reg(1)) or not(MAWB_dest_reg(0))) ) or (MAWB_opcodejlrCout and (not(MAWB_dest_reg(2)) or not(MAWB_dest_reg(1)) or not(MAWB_dest_reg(0)))) or MAWB_opcodelhiCout ; --probably shift in wb stage
     s1_rf_a3<= MAWB_opcodeaddCout or  MAWB_opcodenduCout or  MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout;
     reg_write_en_dummy<=(MAWB_opcodeaddCout and ((not(MAWB7_0(0)) and not(MAWB7_0(1))) or ((MAWB7_0(1)) and not(MAWB7_0(0)) and MAWB_carry_prev(0)) or (not(MAWB7_0(1)) and (MAWB7_0(0)) and MAWB_zero_prev(0)) )) or  (MAWB_opcodenduCout and ((not(MAWB7_0(0)) and not(MAWB7_0(1))) or ((MAWB7_0(1)) and not(MAWB7_0(0)) and MAWB_carry_prev(0)) or (not(MAWB7_0(1)) and (MAWB7_0(0)) and MAWB_zero_prev(0)) )) or MAWB_opcodeadiCout or MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout or MAWB_opcodelmCout;
     
	 
	   
	  next_fsm_state := s3;
	 when s3=>
	 
	  next_fsm_state :=s4;
	 when s4=>
	  s_t1_var:='1';
	  s_t2_var:='1';
	 if(opcode(0) = '0') then
	  next_fsm_state :=s5;
	 else
	  next_fsm_state :=s6;
	  end if;
	  when s5=>
     alu4_in_var:=T1;
	  s_t1_var:='0';
	  s_t2_var:='0';
	  s0_rf_a3<='0';
	  s1_rf_a3<='0';
	  s_rfd3_lmsm_mux<='0';
	 if(T2 = "00000000") then
	   next_fsm_state:=s7;
		else
		next_fsm_state:= s5;
		end if;
	  
		when s6=>
	   alu4_in_var:=T1;
		s_rf_a2<='0';
		s_din<='1';
	   s_t1_var:='0';
		s_t2_var:='0';
	  if(T2 = "00000000") then
	   next_fsm_state:= s7;
		else
		next_fsm_state:= s6;	
		end if; 
	when s7=>
	  IDRR_en<='1';
	  IFID_en<='1';
	  ALU1_en<='1';
	  RREX_en<='1';
	  IDRR_rst_flag<='0';
	  RREX_rst_flag<='0';
	  EXMA_rst_flag<='0';
	  next_fsm_state:= s0;
	  opcode <= IFID_Mem_d_out(15 downto 12);
	  if(opcode(3) = '0' and opcode(2) = '1' and opcode(1) = '1') then
	  IDRR_en<='0';
	  ALU1_en<='0';
	  --RREX_en<='0';
	  IFID_en<='0';
	  next_fsm_state := s1;
	  s_rfd3_lmsm_mux<='1';
	  end if;
	--when s8=>
	  --RREX_en<='1';
	  --next_fsm_state:= s0;
 end case;
	  
 --var_s_rf_a2:= (IDRR_opcodeaddCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or (IDRR_opcodenduCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodejlrCout ;
 
 --r7_write_data<=next_IP;
 if (rising_edge(clk)) then
 if(rst = '1') then
 r7_write_data_mux<=Z16;
 fsm_state<=s0;
 T2_rst<='1';
 --alu4_in<=Z16;
 else
-- s_rf_a1<=s_rf_a1_var;
-- s_rf_a2<=s_rf_a2_var;
-- s_alu2a<=s_alu2a_var;
-- s0_alu2b<=s0_alu2b_var;
-- s_alu3b<=s_alu3b_var;
-- carry_control_dummy(0)<=carry_control_var;
-- zero_control_dummy(0)<=zero_control_var;
-- RREX_rst_flag<=RREX_rst_flag_var;
-- EXMA_rst_flag<=EXMA_rst_flag_var;
-- s_ma<=s_ma_var;
-- s_din<=s_din_var;
-- s0_rfd3<=s0_rfd3_var;
-- s1_rfd3<=s1_rfd3_var;
-- d_mem_wr_en<=d_mem_wr_en_var;
-- s0_rf_a3<=s0_rf_a3_var;
-- s1_rf_a3<=s1_rf_a3_var;
-- reg_write_en_dummy<=reg_write_en_var;
-- alu_control_dummy<=alu_control_var;

 T2_rst<='0';
 alu4_in<=alu4_in_var;
s_t1<= s_t1_var;
s_t2<= s_t2_var;
 zero_prev_dummy(0)<=zero_dummy;
 carry_prev_dummy(0)<=carry_dummy;
 zero_dummy<=z_flag;
 r7_write_data_mux<=next_IP_var;
 fsm_state<=next_fsm_state;
 end if;
 end if;
 --if(IDRR_opcodelmCout = '0' and IDRR_opcodesmCout = '0') then

 --end if;
 --end process;
 --process(IFID_Mem_d_out, IFID_PC_out, clk)
 --begin
 
 --end process;
 --process(IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out, clk)
 --begin
 --rf_a1_a<= IDRR11_9;
 --rf_a1_b<= IDRR8_6;
 --rf_a2_a<= IDRR8_6;
 --rf_a2_b<= pe_out;
 --rf_a3_a<= IDRR11_9; -- 11
 --rf_a3_b<= IDRR8_6; -- 01
 --rf_a3_c<= IDRR5_3; -- 10
 --rf_a3_d<= pe_out;  --00
 --s0_rf_a3<= opcodeaddCout or opcodenduCout or (not opcodeadiCout) or opcodelwCout or opcodejalCout or opcodejlrCout or opcodelhiCout or opcodelmCout; --probably shift in wb stage
 --s1_rf_a3<= (not opcodeaddCout) or (not opcodenduCout) or opcodeadiCout or opcodelwCout or opcodejalCout or opcodejlrCout or opcodelhiCout or opcodelmCout;
 --s0_rf_a3<= '1';
 --s1_rf_a3<= '0';
 --reg_write_dest_dummy<=rf_a3;
 --reg_read_addr_1_dummy<=rf_a1;
 --reg_read_addr_2_dummy<=rf_a2;

 --end process;
 --process(RREX_rf_d1, RREX_rf_d2, RREX7_0, RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out, clk)
 --begin
 
 --end process;
 --process(EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_T1, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, clk)
 --variable next_lmsm_state: lmsmstate;
 --begin

 --next_lmsm_state:= lmsm_state;
 --case next_lmsm_state:
 -- when s0=>

 --end process;
 --process(MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out, clk)
 --begin
 
 
 
 end process;
 end behave;