library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
entity main3 is
port (
 clk, rst: in std_logic
);
end entity main3;


architecture behave of main3 is
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
  a: in std_logic_vector(7 downto 0); -- input
  pout: out std_logic_vector(2 downto 0);
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
 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
 zero_control, carry_control : in std_logic_vector(0 downto 0);
 zero, carry: out std_logic -- Zero Flag
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
	port (address: in std_logic_vector(15 downto 0); clk, Mem_read_en: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end component imemory;
component dmemory is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); clk,Mem_wrbar: in std_logic;
				Mem_dataout: out std_logic_vector(15 downto 0));
end component dmemory;
component mux3bit2to1 is
   port(A,B: in std_logic_vector(2 downto 0); S: in std_logic; Cout: out std_logic_vector(2 downto 0));
end component mux3bit2to1;
component mux3bit4to1 is
   port(A,B,C,D: in std_logic_vector(2 downto 0); S0, S1: in std_logic; Cout: out std_logic_vector(2 downto 0));
end component mux3bit4to1;
component mux16bit2to1 is
   port(A,B: in std_logic_vector(15 downto 0); S: in std_logic; Cout: out std_logic_vector(15 downto 0));
end component mux16bit2to1;
component mux16bit4to1 is
   port(A,B,C,D: in std_logic_vector(15 downto 0); S0, S1: in std_logic; Cout: out std_logic_vector(15 downto 0));
end component mux16bit4to1;
component opcodecontrol is
 port(a,b,c,d:in std_logic; Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7,Cout8,Cout9,Cout10,Cout11: out std_logic);
end component;
component mux8bit2to1 is
   port(A,B: in std_logic_vector(7 downto 0); S: in std_logic; Cout: out std_logic_vector(7 downto 0));
end component mux8bit2to1;
component IFID is
 port (PC, Mem_d: in std_logic_vector(15 downto 0); clk, IFID_en, flag, IFID_rst_flag: in std_logic;
				PC_out, Mem_d_out: out std_logic_vector(15 downto 0); IFID_flag: out std_logic);
end component IFID; 
component IDRR is
 port (clk, IDRR_en, IFID_flag, IDRR_rst_flag: in std_logic;
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
	port (clk, RREX_en, IDRR_flag, RREX_rst_flag : in std_logic;
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
	port (clk, EXMA_en, EXMA_rst_flag: in std_logic;
	      RREX_opcode: in std_logic_vector(3 downto 0);
			RREX_dest_reg: in std_logic_vector(2 downto 0);
			RREX_r7_out, RREX_rf_d1, RREX_rf_d2: in std_logic_vector(15 downto 0);
			RREX11_9, RREX8_6, RREX5_3: in std_logic_vector(2 downto 0);
			RREX7_0: in std_logic_vector(7 downto 0);
			RREX_ls7_ir8_0, RREX_PC_out: in std_logic_vector(15 downto 0);
			--prev RREX output, RREX_dest, 
      	T1, alu_result_dummy, alu3_out: in std_logic_vector(15 downto 0);
			
			EXMA_opcode: out std_logic_vector(3 downto 0);
			EXMA_dest_reg: out std_logic_vector(2 downto 0);
			EXMA_r7_out, EXMA_rf_d1, EXMA_rf_d2: out std_logic_vector(15 downto 0);
			EXMA11_9, EXMA8_6, EXMA5_3: out std_logic_vector(2 downto 0);
			EXMA7_0: out std_logic_vector(7 downto 0);
			EXMA_ls7_ir8_0, EXMA_PC_out: out std_logic_vector(15 downto 0);
			--prev RREX output, RREX_dest, 
      	EXMA_T1, EXMA_alu2_out, EXMA_alu3_out: out std_logic_vector(15 downto 0)
		   ); 
end component;
component MAWB is 
	port (clk, MAWB_en, MAWB_rst_flag: in std_logic;
	      EXMA_dest_reg: in std_logic_vector(2 downto 0);
		   EXMA_opcode: in std_logic_vector(3 downto 0);	--mawb output:
         data_mem_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out:in std_logic_vector(15 downto 0);
			MAWB_dest_reg: out std_logic_vector(2 downto 0);
		   MAWB_opcode: out std_logic_vector(3 downto 0);	--mawb output:
			MAWB_data_mem_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out: out std_logic_vector(15 downto 0)); 
end  component;
 --fsm   
-- type FsmState is (inst_fetch, inst_decode, reg_read, execute, mem_access, write_back);--dummy1,dummy2,dummy3,dummy4,dummy5,dummy6,dummy7,dummy8,dummy9,dummy10,dummy11,dummy12,dummy13,dummy14,dummy15,dummy16,dummy17,dummy18,dummy19,dummy20,dummy21,dummy22,dummy23,dummy24,dummy25,dummy26);
 type FsmState is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
 signal fsm_state: FsmState;
 signal IFID_PC_out, IFID_Mem_d_out: std_logic_vector(15 downto 0);
 signal IDRR11_9, IDRR8_6, IDRR5_3:  std_logic_vector(2 downto 0);
 signal IDRR7_0: std_logic_vector(7 downto 0);
 signal IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out: std_logic_vector(15 downto 0);
 signal RREX_r7_out, RREX_rf_d1, RREX_rf_d2,RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out: std_logic_vector(15 downto 0);
 signal RREX7_0: std_logic_vector(7 downto 0);
 signal EXMA_PC_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_T1, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out: std_logic_vector(15 downto 0);
 signal MAWB_data_mem_out, MAWB_PC_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out: std_logic_vector(15 downto 0);
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0');
 signal next_IP, T1: std_logic_vector(15 downto 0);
 signal  zero_prev_dummy, carry_prev_dummy : std_logic_vector(0 downto 0);
 signal a_dummy,b_dummy :  std_logic_vector(15 downto 0); -- src1, src2
 signal alu_control_dummy : std_logic_vector(1 downto 0); -- function select
 signal alu_result_dummy: std_logic_vector(15 downto 0); -- ALU Output Result
 signal zero_control_dummy, carry_control_dummy,z_flag, c_flag :  std_logic_vector(0 downto 0);
 signal zero_dummy, carry_dummy: std_logic;
 signal alu3_a, alu3_b, alu3_out: std_logic_vector(15 downto 0);
 signal i_memd_out: std_logic_vector(15 downto 0);
 signal i_mem_read_en: std_logic;
 signal ALU1_en: std_logic;
 --signal pc_write_en: std_logic;
 --signal pc_in: std_logic_vector(15 downto 0);
 signal reg_write_en_dummy, r7_write_en: std_logic;
 signal reg_write_dest_dummy: std_logic_vector(2 downto 0);
 signal reg_write_data_dummy, r7_write_data, r7_read_data: std_logic_vector(15 downto 0);
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
 signal beqZflag: std_logic;
 signal T2, lmsm_out: std_logic_vector(7 downto 0);
 signal pe_out: std_logic_vector(2 downto 0);
 signal opcodeaddCout, opcodeadiCout, opcodenduCout, opcodelwCout,opcodeswCout, opcodelhiCout, opcodelmCout, opcodesmCout, opcodebeqCout, opcodejalCout, opcodejlrCout : std_logic;
 signal s_t1, s_t2, s0_alu2a, s1_alu2a, s0_alu2b, s1_alu2b, s_alu3a, s_alu3b: std_logic;
 signal s_ma: std_logic;
 signal s_din, s0_r7in, s1_r7in, s0_rfd3, s1_rfd3: std_logic;
 signal r7_write_data_mux: std_logic_vector(15 downto 0);
 type lmsmstate is (s0, s1);
 signal lmsm_state: lmsmstate;
 signal flag, IFID_rst_flag, IFID_flag: std_logic;
 signal IDRR_rst_flag, IDRR_flag: std_logic;
 signal IDRR_opcode: std_logic_vector(3 downto 0);
 signal RREX_rst_flag, RREX_flag: std_logic;
 signal dest_reg, RREX_dest_reg: std_logic_vector(2 downto 0);
 signal RREX_opcode: std_logic_vector(3 downto 0);
 signal RREX11_9, RREX8_6, RREX5_3: std_logic_vector(2 downto 0);
 signal EXMA_rst_flag, EXMA_flag, MAWB_rst_flag: std_logic;
 signal EXMA_opcode: std_logic_vector(3 downto 0);
 signal EXMA_dest_reg: std_logic_vector(2 downto 0); 
 signal EXMA11_9, EXMA8_6, EXMA5_3: std_logic_vector(2 downto 0);
 signal EXMA7_0: std_logic_vector(7 downto 0);
 signal MAWB_dest_reg: std_logic_vector(2 downto 0);
 signal MAWB_opcode: std_logic_vector(3 downto 0);
 --signal IFID_opcodeaddCout, IFID_opcodeadiCout, IFID_opcodenduCout, IFID_opcodelhiCout, IFID_opcodelwCout, IFID_opcodeswCout, IFID_opcodelmCout, IFID_opcodesmCout, IFID_opcodebeqCout, IFID_opcodejalCout, IFID_opcodejlrCout: std_logic;
 signal IDRR_opcodeaddCout, IDRR_opcodeadiCout, IDRR_opcodenduCout, IDRR_opcodelhiCout, IDRR_opcodelwCout, IDRR_opcodeswCout, IDRR_opcodelmCout, IDRR_opcodesmCout, IDRR_opcodebeqCout, IDRR_opcodejalCout, IDRR_opcodejlrCout: std_logic;
 signal RREX_opcodeaddCout, RREX_opcodeadiCout, RREX_opcodenduCout, RREX_opcodelhiCout, RREX_opcodelwCout, RREX_opcodeswCout, RREX_opcodelmCout, RREX_opcodesmCout, RREX_opcodebeqCout, RREX_opcodejalCout, RREX_opcodejlrCout: std_logic;
 signal EXMA_opcodeaddCout, EXMA_opcodeadiCout, EXMA_opcodenduCout, EXMA_opcodelhiCout, EXMA_opcodelwCout, EXMA_opcodeswCout, EXMA_opcodelmCout, EXMA_opcodesmCout, EXMA_opcodebeqCout, EXMA_opcodejalCout, EXMA_opcodejlrCout: std_logic;
 signal MAWB_opcodeaddCout, MAWB_opcodeadiCout, MAWB_opcodenduCout, MAWB_opcodelhiCout, MAWB_opcodelwCout, MAWB_opcodeswCout, MAWB_opcodelmCout, MAWB_opcodesmCout, MAWB_opcodebeqCout, MAWB_opcodejalCout, MAWB_opcodejlrCout: std_logic;
 signal rfd3_mux_out: std_logic_vector(15 downto 0);
 signal  s_rfd3_lmsm_mux: std_logic;
 signal alu4_in, alu4_out: std_logic_vector(15 downto 0);
 --signal: RA: std_logic_vector(2 downto 0);
 begin
 alu1_block: alu1 port map(r7_read_data,ALU1_en,next_IP);
 alu2_block: alu2 port map (zero_prev_dummy, carry_prev_dummy,a_dummy,b_dummy ,alu_control_dummy ,alu_result_dummy,zero_control_dummy, carry_control_dummy,zero_dummy, carry_dummy);
 alu3_block: alu3 port map(alu3_a, alu3_b, alu3_out);
 alu4_block: alu4 port map(alu4_in, alu4_out);
 inst_mem: imemory port map(r7_read_data, clk, i_mem_read_en, i_memd_out);
 reg1: register_file_VHDL port map (clk, rst,reg_write_en_dummy, r7_write_en, r7_write_data, r7_read_data,reg_write_dest_dummy, reg_write_data_dummy,reg_read_addr_1_dummy,reg_read_data_1_dummy, reg_read_addr_2_dummy, reg_read_data_2_dummy );
 data_mem: dmemory port map(data_addr, data_mem_in, clk, d_mem_wr_en, data_mem_out);
 IFIDreg: IFID port map(r7_read_data, i_memd_out,clk, IFID_en, flag, IFID_rst_flag, IFID_PC_out, IFID_Mem_d_out, IFID_flag);
 IDRRreg: IDRR port map(clk, IDRR_en, IFID_flag, IDRR_rst_flag, opcode, IFID_Mem_d_out(11 downto 9), IFID_Mem_d_out(8 downto 6), IFID_Mem_d_out(5 downto 3), IFID_Mem_d_out(7 downto 0),se10_ir5_0, se7_ir8_0, ls7_ir8_0, IFID_PC_out,IDRR_flag, IDRR_opcode, IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out);
 RREXreg: RREX port map(clk, RREX_en, IDRR_flag, RREX_rst_flag,dest_reg, r7_read_data, reg_read_data_1_dummy, reg_read_data_2_dummy,IDRR_opcode, IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out,RREX_flag, RREX_dest_reg, RREX_r7_out, RREX_rf_d1, RREX_rf_d2, RREX_opcode,RREX11_9, RREX8_6, RREX5_3, RREX7_0, RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out); 
 EXMAreg: EXMA port map(clk, EXMA_en, EXMA_rst_flag, RREX_opcode, RREX_dest_reg, RREX_r7_out, RREX_rf_d1, RREX_rf_d2, RREX11_9, RREX8_6, RREX5_3, RREX7_0, RREX_ls7_ir8_0, RREX_PC_out, T1, alu_result_dummy, alu3_out, EXMA_opcode, EXMA_dest_reg, EXMA_r7_out, EXMA_rf_d1, EXMA_rf_d2, EXMA11_9, EXMA8_6, EXMA5_3, EXMA7_0, EXMA_ls7_ir8_0, EXMA_PC_out, EXMA_T1, EXMA_alu2_out, EXMA_alu3_out);
 MAWBreg: MAWB port map(clk, MAWB_en, MAWB_rst_flag, EXMA_dest_reg, EXMA_opcode, data_mem_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out, MAWB_dest_reg, MAWB_opcode, MAWB_data_mem_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out); 
 rfa1mux: mux3bit2to1 port map(IDRR11_9, IDRR8_6, s_rf_a1, reg_read_addr_1_dummy);
 rfa2mux: mux3bit2to1 port map(IDRR8_6, pe_out, s_rf_a2, reg_read_addr_2_dummy);
 rfa3mux: mux3bit4to1 port map(IDRR11_9, IDRR8_6, IDRR5_3, pe_out, s0_rf_a3, s1_rf_a3, reg_write_dest_dummy); 
 ID_opcode_logic: opcodecontrol port map(opcode(3), opcode(2), opcode(1), opcode(0), opcodeaddCout, opcodeadiCout, opcodenduCout, opcodelhiCout, opcodelwCout, opcodeswCout, opcodelmCout, opcodesmCout, opcodebeqCout, opcodejalCout, opcodejlrCout); --even for adc, adz
 --_opcode_logic: opcodecontrol port map(IFID_opcode(3), IFID_opcode(2), IFID_opcode(1), IFID_opcode(0), IFID_opcodeaddCout, IFID_opcodeadiCout, IFID_opcodenduCout, IFID_opcodelhiCout, IFID_opcodelwCout, IFID_opcodeswCout, IFID_opcodelmCout, IFID_opcodesmCout, IFID_opcodebeqCout, IFID_opcodejalCout, IFID_opcodejlrCout);
 RR_opcode_logic: opcodecontrol port map(IDRR_opcode(3), IDRR_opcode(2), IDRR_opcode(1), IDRR_opcode(0), IDRR_opcodeaddCout, IDRR_opcodeadiCout, IDRR_opcodenduCout, IDRR_opcodelhiCout, IDRR_opcodelwCout, IDRR_opcodeswCout, IDRR_opcodelmCout, IDRR_opcodesmCout, IDRR_opcodebeqCout, IDRR_opcodejalCout, IDRR_opcodejlrCout);
 EX_opcode_logic: opcodecontrol port map(RREX_opcode(3), RREX_opcode(2), RREX_opcode(1), RREX_opcode(0), RREX_opcodeaddCout, RREX_opcodeadiCout, RREX_opcodenduCout, RREX_opcodelhiCout, RREX_opcodelwCout, RREX_opcodeswCout, RREX_opcodelmCout, RREX_opcodesmCout, RREX_opcodebeqCout, RREX_opcodejalCout, RREX_opcodejlrCout);
 MA_opcode_logic: opcodecontrol port map(EXMA_opcode(3), EXMA_opcode(2), EXMA_opcode(1), EXMA_opcode(0), EXMA_opcodeaddCout, EXMA_opcodeadiCout, EXMA_opcodenduCout, EXMA_opcodelhiCout, EXMA_opcodelwCout, EXMA_opcodeswCout, EXMA_opcodelmCout, EXMA_opcodesmCout, EXMA_opcodebeqCout, EXMA_opcodejalCout, EXMA_opcodejlrCout);
 WB_opcode_logic: opcodecontrol port map(MAWB_opcode(3), MAWB_opcode(2), MAWB_opcode(1), MAWB_opcode(0), MAWB_opcodeaddCout, MAWB_opcodeadiCout, MAWB_opcodenduCout, MAWB_opcodelhiCout, MAWB_opcodelwCout, MAWB_opcodeswCout, MAWB_opcodelmCout, MAWB_opcodesmCout, MAWB_opcodebeqCout, MAWB_opcodejalCout, MAWB_opcodejlrCout);
 t1mux: mux16bit2to1 port map(RREX_rf_d1, alu4_out, s_t1, T1);
 t2mux: mux8bit2to1 port map(IFID_Mem_d_out(7 downto 0), lmsm_out,s_t2, T2);
 alu2amux: mux16bit4to1 port map(T1, RREX_rf_d1, RREX_rf_d2, Z16, s0_alu2a, s1_alu2a, a_dummy);
 alu2bmux: mux16bit4to1 port map(RREX_rf_d2, RREX_se10_ir5_0, "0000000000000001", Z16, s0_alu2b, s1_alu2b, b_dummy);
 alu3amux: mux16bit2to1 port map(alu_result_dummy, RREX_PC_out, s_alu3a, alu3_a);
 alu3bmux: mux16bit2to1 port map(RREX_se10_ir5_0, RREX_se7_ir8_0, s_alu3b, alu3_b);
 lmsm_unit: lmsmblock port map(T2, pe_out, lmsm_out); 
 maaddrmux: mux16bit2to1 port map(EXMA_T1, EXMA_alu2_out, s_ma, data_addr);
 madinmux: mux16bit2to1 port map(MAWB_rf_d2, MAWB_rf_d1, s_din, data_mem_in); 
 r7inmux: mux16bit4to1 port map(r7_write_data_mux, MAWB_alu3_out, MAWB_rf_d2,MAWB_PC_out , s0_r7in, s1_r7in, r7_write_data); --alu1_out
 rfd3mux: mux16bit4to1 port map(MAWB_alu2_out, MAWB_r7_out, MAWB_data_mem_out, MAWB_ls7_ir8_0, s0_rfd3, s1_rfd3, rfd3_mux_out);
 rfd3_lmsm_mux: mux16bit2to1 port map(rfd3_mux_out, data_mem_out, s_rfd3_lmsm_mux,reg_write_data_dummy); 
 zero_prev_dummy(0 downto 0)<="0";
 carry_prev_dummy(0 downto 0)<="0";
 process(clk, rst)
 variable next_IP_var: std_logic_vector(15 downto 0);
 variable next_fsm_state:FsmState;
 variable T1var: std_logic_vector(15 downto 0);
 --variable var_s_rf_a2: std_logic;
 --variable 
 begin
 next_fsm_state := fsm_state;
 case next_fsm_state is
    when s0=>
	  next_IP_var := next_IP;
	  if(IDRR_opcodelmCout = '1' or IDRR_opcodesmCout = '1') then
	  IDRR_en<='0';
	  ALU1_en<='0';
	  RREX_en<='0';
	  IFID_en<='0';
	  next_fsm_state := s1;
	  s_rfd3_lmsm_mux<='1';
	  else
	  next_fsm_state := s0;
	  IDRR_en<='1';
	  ALU1_en<='1';
	  RREX_en<='1';
	  IFID_en<='1';
	  s0_rf_a3<=  MAWB_opcodeaddCout or MAWB_opcodenduCout or (not MAWB_opcodeadiCout) or MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout  ; --probably shift in wb stage
     s1_rf_a3<= (not MAWB_opcodeaddCout) or (not MAWB_opcodenduCout) or MAWB_opcodeadiCout or MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout;
     s_rf_a2<= (IDRR_opcodeaddCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or (IDRR_opcodenduCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodejlrCout ;

	  end if;
	 when s1=>
     RREX_rst_flag<='1';
	  next_fsm_state := s2;
	 when s2=>
	  EXMA_rst_flag<='1';
	  next_fsm_state := s3;
	 when s3=>
	  
	  next_fsm_state :=s4;
	 when s4=>
	  s_t1<='1';
	  s_t2<='1';
	 if(IDRR_opcodelmCout = '1') then
	  next_fsm_state :=s5;
	 else
	  next_fsm_state :=s6;
	  end if;
	  when s5=>
     alu4_in<=T1;
	  s0_rf_a3<='0';
	  s1_rf_a3<='0';
	  s_rfd3_lmsm_mux<='0';
	   
	  if(T2 = "00000000") then
	   next_fsm_state:=s7;
		else
		next_fsm_state:= s5;
		end if;
		when s6=>
	   alu4_in<=T1;
		s_rf_a2<='0';
		s_din<='1';
	   s_t1<='0';
		s_t2<='0';
	  if(T2 = "00000000") then
	   next_fsm_state:= s7;
		else
		next_fsm_state:= s6;
		end if;
	when s7=>
	  IDRR_en<='1';
	  IFID_en<='1';
	  ALU1_en<='1';
	  RREX_rst_flag<='0';
	  EXMA_rst_flag<='0';
	  next_fsm_state:= s8;
	when s8=>
	  RREX_en<='1';
	  next_fsm_state:= s0;
 end case;
	  
 --var_s_rf_a2:= (IDRR_opcodeaddCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or (IDRR_opcodenduCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodejlrCout ;

 --r7_write_data<=next_IP;
 if (clk'event and clk='1') then
 if(rst = '1') then
 r7_write_data_mux<=Z16;
 fsm_state<=s0;
 else
 r7_write_data_mux<=next_IP_var;
 fsm_state<=next_fsm_state;
 end if;
 if(IDRR_opcodelmCout = '0' and IDRR_opcodesmCout = '0') then
 r7_write_en<='1';
 i_mem_read_en<='1';
 s0_r7in<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or opcodeswCout or (MAWB_opcodebeqCout and not(beqZflag)) or (not(MAWB_opcodebeqCout and beqZflag)) or (not MAWB_opcodejalCout) or MAWB_opcodejlrCout or opcodelhiCout or opcodelmCout or opcodesmCout or opcodejalCout or opcodejlrCout or opcodebeqCout;
 s1_r7in<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or opcodeswCout or (MAWB_opcodebeqCout and not(beqZflag)) or (MAWB_opcodebeqCout and beqZflag) or MAWB_opcodejalCout or not(MAWB_opcodejlrCout) or opcodelhiCout or opcodelmCout or opcodesmCout or opcodejalCout or opcodejlrCout or opcodebeqCout;
 --IFID_en<='1';
 
 se10_ir5_0<=IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5 downto 0);
 se7_ir8_0<=IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8 downto 0);
 ls7_ir8_0(15 downto 7)<=IFID_Mem_d_out(8 downto 0);
 ls7_ir8_0(6 downto 0)<= "0000000";
 opcode<=IFID_Mem_d_out(15 downto 12);
 --IDRR_en<='1';
 
 s_rf_a1<= (IDRR_opcodeaddCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or  IDRR_opcodeadiCout or (IDRR_opcodenduCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or IDRR_opcodeswCout or IDRR_opcodebeqCout or IDRR_opcodelmCout or IDRR_opcodesmCout;

 --RREX_en<='1';
 
 --s_t1<='1';
 --s_t2<='1' ;
 s0_alu2a<= not(RREX_opcodeaddCout) or not(RREX_opcodenduCout) or not(RREX_opcodeadiCout) or RREX_opcodelwCout or RREX_opcodeswCout or not(RREX_opcodebeqCout) or RREX_opcodelmCout or RREX_opcodesmCout;
 s1_alu2a<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodeadiCout or not(RREX_opcodelwCout) or not(RREX_opcodelwCout) or RREX_opcodebeqCout or RREX_opcodelmCout or RREX_opcodesmCout;
 s0_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or not(RREX_opcodeadiCout) or not(RREX_opcodelwCout) or not(RREX_opcodelwCout) or RREX_opcodebeqCout or RREX_opcodelmCout or RREX_opcodesmCout;
 s1_alu2b<= RREX_opcodeaddCout or RREX_opcodenduCout or RREX_opcodeadiCout or RREX_opcodelwCout or RREX_opcodelwCout or RREX_opcodebeqCout or not(RREX_opcodelmCout) or not(RREX_opcodesmCout);
 s_alu3a<= RREX_opcodebeqCout or RREX_opcodejalCout;
 s_alu3b<= RREX_opcodebeqCout or not(RREX_opcodejalCout);
 if(RREX_opcodeaddCout = '1' or RREX_opcodeadiCout = '1' or RREX_opcodelwCout='1' or RREX_opcodeswCout = '1' or RREX_opcodelmCout = '1' or RREX_opcodesmCout = '1') then
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
 if(RREX_opcodebeqCout = '1') then
 beqZflag<=Z_flag(0);
 Z_flag<=zero_prev_dummy;
 end if; 
 EXMA_en<='1';
 
  s_ma<=not(EXMA_opcodelwCout) or not(EXMA_opcodeswCout) ;
  MAWB_en<='1';
 
 --s_din<= MAWB_opcodesmCout;
 
 s0_rfd3<=MAWB_opcodeaddCout or MAWB_opcodeadiCout or MAWB_opcodenduCout or MAWB_opcodelwCout or (not MAWB_opcodejalCout) or (not MAWB_opcodejlrCout) or (not MAWB_opcodelhiCout) or (not MAWB_opcodelmCout);
 s1_rfd3<=MAWB_opcodeaddCout or MAWB_opcodeadiCout or MAWB_opcodenduCout or (not MAWB_opcodelwCout) or MAWB_opcodejalCout or MAWB_opcodejalCout or (not MAWB_opcodelhiCout) or (not MAWB_opcodelmCout);
 reg_write_en_dummy<=MAWB_opcodeaddCout or MAWB_opcodenduCout or MAWB_opcodeadiCout or MAWB_opcodelwCout or MAWB_opcodejalCout or MAWB_opcodejlrCout or MAWB_opcodelhiCout or MAWB_opcodelmCout;
 d_mem_wr_en<=MAWB_opcodeswCout;
 end if;
 end if;
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