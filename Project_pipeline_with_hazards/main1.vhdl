library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
entity main1 is
port (
 clk, rst: in std_logic
);
end entity main1;


architecture behave of main1 is
component register_file_VHDL is
port (
 clk,rst: in std_logic;
 reg_write_en, r7_write_en, pc_write_en: in std_logic;
 pc_in: in std_logic_vector(15 downto 0);
 r7_write_data: in std_logic_vector(15 downto 0);
 r7_read_data: out std_logic_vector(15 downto 0);
 reg_write_dest: in std_logic_vector(2 downto 0);
 reg_write_data: in std_logic_vector(15 downto 0);
 reg_read_addr_1: in std_logic_vector(2 downto 0);
 reg_read_data_1: out std_logic_vector(15 downto 0);
 reg_read_addr_2: in std_logic_vector(2 downto 0);
 reg_read_data_2: out std_logic_vector(15 downto 0)
);
 component;
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
 port (PC, Mem_d: in std_logic_vector(15 downto 0); clk, IFID_en: in std_logic;
				PC_out, Mem_d_out: out std_logic_vector(15 downto 0));
end component IFID; 
component IDRR is
 port (clk, IDRR_en: in std_logic;
	      inp11_9, inp8_6, inp5_3: in std_logic_vector(2 downto 0);
	      inp7_0: in std_logic_vector(7 downto 0);
			se10_ir5_0, se7_ir8_0, ls7_ir8_0, inp_pc: in std_logic_vector(15 downto 0);
			IDRR11_9, IDRR8_6, IDRR5_3: out std_logic_vector(2 downto 0);
		   IDRR7_0: out std_logic_vector(7 downto 0);
		   IDRRse10_ir5_0, IDRRse7_ir8_0, IDRRls7_ir8_0, IDRRPC_out: out std_logic_vector(15 downto 0)	);
end component IDRR; 
component RREX is 
	port (clk, RREX_en: in std_logic;
	      r7_read_data, rf_d1, rf_d2: in std_logic_vector(15 downto 0);
		  	IDRR7_0: in std_logic_vector(7 downto 0);
		  	IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRR_PC_out: in std_logic_vector(15 downto 0);
			RREX_r7_out, RREX_rf_d1, RREX_rf_d2,  RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out: out std_logic_vector(15 downto 0);
			RREX7_0: out std_logic_vector(7 downto 0));
end component;
component EXMA is 
	port (clk, EXMA_en: in std_logic;
      	RREX_r7_out, RREX_ls7_ir8_0, T1, RREX_rf_d1, RREX_rf_d2, alu_result_dummy, alu3_out, RREX_PC_out: in std_logic_vector(15 downto 0);
			EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_T1, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out: out std_logic_vector(15 downto 0)); 
end component;
component MAWB is 
	port (clk, MAWB_en: in std_logic;
         data_mem_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out:in std_logic_vector(15 downto 0);
			MAWB_data_mem_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out: out std_logic_vector(15 downto 0)); 
end component;
 --fsm   
-- type FsmState is (inst_fetch, inst_decode, reg_read, execute, mem_access, write_back);--dummy1,dummy2,dummy3,dummy4,dummy5,dummy6,dummy7,dummy8,dummy9,dummy10,dummy11,dummy12,dummy13,dummy14,dummy15,dummy16,dummy17,dummy18,dummy19,dummy20,dummy21,dummy22,dummy23,dummy24,dummy25,dummy26);
-- signal fsm_state: FsmState;
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
 signal pc_write_en: std_logic;
 signal pc_in: std_logic_vector(15 downto 0);
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
 --signal: RA: std_logic_vector(2 downto 0);
 begin
 alu1_block: alu1 port map(r7_read_data, next_IP);
 alu2_block: alu2 port map (zero_prev_dummy, carry_prev_dummy,a_dummy,b_dummy ,alu_control_dummy ,alu_result_dummy,zero_control_dummy, carry_control_dummy,zero_dummy, carry_dummy);
 alu3_block: alu3 port map(alu3_a, alu3_b, alu3_out);
 inst_mem: imemory port map(r7_read_data, clk, i_mem_read_en, i_memd_out);
 reg1: register_file_VHDL port map (clk, rst,reg_write_en_dummy, r7_write_en, r7_write_data, r7_read_data,reg_write_dest_dummy, reg_write_data_dummy,reg_read_addr_1_dummy,reg_read_data_1_dummy, reg_read_addr_2_dummy, reg_read_data_2_dummy );
 data_mem: dmemory port map(data_addr, data_mem_in, clk, d_mem_wr_en, data_mem_out);
 IFIDreg: IFID port map(next_IP, i_memd_out,clk, IFID_en, IFID_PC_out, IFID_Mem_d_out);
 IDRRreg: IDRR port map(clk, IDRR_en, IFID_Mem_d_out(11 downto 9), IFID_Mem_d_out(8 downto 6), IFID_Mem_d_out(5 downto 3), IFID_Mem_d_out(7 downto 0),se10_ir5_0, se7_ir8_0, ls7_ir8_0, IFID_PC_out, IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out);
 RREXreg: RREX port map(clk, RREX_en, r7_read_data, reg_read_data_1_dummy, reg_read_data_2_dummy, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out,RREX_r7_out, RREX_rf_d1, RREX_rf_d2, RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out, RREX7_0); 
 EXMAreg: EXMA port map(clk, EXMA_en, RREX_r7_out, RREX_ls7_ir8_0, T1, RREX_rf_d1, RREX_rf_d2, alu_result_dummy, alu3_out, RREX_PC_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_T1, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, EXMA_PC_out); 
 MAWBreg: MAWB port map(clk, MAWB_en, data_mem_out, EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out,EXMA_PC_out, MAWB_data_mem_out, MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out); 
 rfa1mux: mux3bit2to1 port map(IDRR11_9, IDRR8_6, s_rf_a1, reg_read_addr_1_dummy);
 rfa2mux: mux3bit2to1 port map(IDRR8_6, pe_out, s_rf_a2, reg_read_addr_2_dummy);
 rfa3mux: mux3bit4to1 port map(IDRR11_9, IDRR8_6, IDRR5_3, pe_out, s0_rf_a3, s1_rf_a3, reg_write_dest_dummy); 
 opcode_logic: opcodecontrol port map(opcode(3), opcode(2), opcode(1), opcode(0), opcodeaddCout, opcodeadiCout, opcodenduCout, opcodelhiCout, opcodelwCout, opcodeswCout, opcodelmCout, opcodesmCout, opcodebeqCout, opcodejalCout, opcodejlrCout); --even for adc, adz
 t1mux: mux16bit2to1 port map(RREX_rf_d1, alu_result_dummy, s_t1, T1);
 t2mux: mux8bit2to1 port map(IFID_Mem_d_out(7 downto 0), lmsm_out,s_t2, T2);
 alu2amux: mux16bit4to1 port map(T1, RREX_rf_d1, RREX_rf_d2, Z16, s0_alu2a, s1_alu2a, a_dummy);
 alu2bmux: mux16bit4to1 port map(RREX_rf_d2, RREX_se10_ir5_0, "0000000000000001", Z16, s0_alu2b, s1_alu2b, b_dummy);
 alu3amux: mux16bit2to1 port map(alu_result_dummy, RREX_PC_out, s_alu3a, alu3_a);
 alu3bmux: mux16bit2to1 port map(RREX_se10_ir5_0, RREX_se7_ir8_0, s_alu3b, alu3_b);
 lmsm_unit: lmsmblock port map(T2, pe_out, lmsm_out); 
 maaddrmux: mux16bit2to1 port map(EXMA_T1, EXMA_alu2_out, s_ma, data_addr);
 madinmux: mux16bit2to1 port map(MAWB_rf_d2, MAWB_rf_d1, s_din, data_mem_in); 
 r7inmux: mux16bit4to1 port map(MAWB_PC_out, MAWB_alu3_out, MAWB_rf_d2,r7_write_data_mux , s0_r7in, s1_r7in, r7_write_data); --alu1_out
 rfd3mux: mux16bit4to1 port map(MAWB_alu2_out, MAWB_r7_out, MAWB_data_mem_out, MAWB_ls7_ir8_0, s0_rfd3, s1_rfd3, reg_write_data_dummy);
 zero_prev_dummy(0 downto 0)<="0";
 carry_prev_dummy(0 downto 0)<="0";
 process(r7_read_data, clk)
 variable next_IP_var: std_logic_vector(15 downto 0);
 variable 
 begin
 next_IP_var := next_IP;
 r7_write_en<='1';
 i_mem_read_en<='1';
 IFID_en<='1';
 --r7_write_data<=next_IP;
 if (clk'event and clk='1') then
  r7_write_data_mux<=next_IP_var;
 end if;
 end process;
 process(IFID_Mem_d_out, IFID_PC_out, clk)
 begin
 opcode<=IFID_Mem_d_out(15 downto 12);
 se10_ir5_0<=IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5) & IFID_Mem_d_out(5 downto 0);
 se7_ir8_0<=IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8) & IFID_Mem_d_out(8 downto 0);
 ls7_ir8_0(15 downto 7)<=IFID_Mem_d_out(8 downto 0);
 ls7_ir8_0(6 downto 0)<= "0000000";
 IDRR_en<='1';
 end process;
 process(IDRR11_9, IDRR8_6, IDRR5_3, IDRR7_0, IDRRse10_ir5_0, IDRR_se7_ir8_0, IDRR_ls7_ir8_0, IDRRPC_out, clk)
 begin
 --rf_a1_a<= IDRR11_9;
 --rf_a1_b<= IDRR8_6;
 --rf_a2_a<= IDRR8_6;
 --rf_a2_b<= pe_out;
 --rf_a3_a<= IDRR11_9; -- 11
 --rf_a3_b<= IDRR8_6; -- 01
 --rf_a3_c<= IDRR5_3; -- 10
 --rf_a3_d<= pe_out;  --00
  s_rf_a1<= (opcodeaddCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or  opcodeadiCout or (opcodenduCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or opcodeswCout or opcodebeqCout or opcodelmCout or opcodesmCout;
 s_rf_a2<= (opcodeaddCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or (opcodenduCout and ((not(IDRR7_0(0)) and not(IDRR7_0(1))) or (IDRR7_0(0) and not(IDRR7_0(1)) and c_flag(0)) or (not(IDRR7_0(0)) and IDRR7_0(1) and z_flag(0)))) or opcodeswCout or opcodebeqCout or opcodejlrCout ;
 --s0_rf_a3<= opcodeaddCout or opcodenduCout or (not opcodeadiCout) or opcodelwCout or opcodejalCout or opcodejlrCout or opcodelhiCout or opcodelmCout; --probably shift in wb stage
 --s1_rf_a3<= (not opcodeaddCout) or (not opcodenduCout) or opcodeadiCout or opcodelwCout or opcodejalCout or opcodejlrCout or opcodelhiCout or opcodelmCout;
 s0_rf_a3<= '1';
 s1_rf_a3<= '0';
 --reg_write_dest_dummy<=rf_a3;
 --reg_read_addr_1_dummy<=rf_a1;
 --reg_read_addr_2_dummy<=rf_a2;
 RREX_en<='1';
 end process;
 process(RREX_rf_d1, RREX_rf_d2, RREX7_0, RREX_se10_ir5_0, RREX_se7_ir8_0, RREX_ls7_ir8_0, RREX_PC_out, clk)
 begin
 s_t1<='1';
 s_t2<='1' ;
 s0_alu2a<= not(opcodeaddCout) or not(opcodenduCout) or not(opcodeadiCout) or opcodelwCout or opcodeswCout or not(opcodebeqCout) or opcodelmCout or opcodesmCout;
 s1_alu2a<= opcodeaddCout or opcodenduCout or opcodeadiCout or not(opcodelwCout) or not(opcodelwCout) or opcodebeqCout or opcodelmCout or opcodesmCout;
 s0_alu2b<= opcodeaddCout or opcodenduCout or not(opcodeadiCout) or not(opcodelwCout) or not(opcodelwCout) or opcodebeqCout or opcodelmCout or opcodesmCout;
 s1_alu2b<= opcodeaddCout or opcodenduCout or opcodeadiCout or opcodelwCout or opcodelwCout or opcodebeqCout or not(opcodelmCout) or not(opcodesmCout);
 s_alu3a<= opcodebeqCout or opcodejalCout;
 s_alu3b<= opcodebeqCout or not(opcodejalCout);
 if(opcodeaddCout = '1' or opcodeadiCout = '1' or opcodelwCout='1' or opcodeswCout = '1' or opcodelmCout = '1' or opcodesmCout = '1') then
 alu_control_dummy<="00";
 if (opcodeaddCout = '1' or opcodeadiCout = '1') then
 carry_control_dummy(0)<='1';
 zero_control_dummy(0)<='1';
 elsif(opcodelwCout='1') then
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';
 else
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='0';
 end if; 
 elsif (opcodenduCout = '1') then
 alu_control_dummy<="01";
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';
 elsif (opcodebeqCout = '1') then
 alu_control_dummy<="10";
 carry_control_dummy(0)<='0';
 zero_control_dummy(0)<='1';  --changed later
 end if;
 if(opcodebeqCout = '1') then
 beqZflag<=Z_flag(0);
 Z_flag<=zero_prev_dummy;
 end if; 
 EXMA_en<='1';
 end process;
 process(EXMA_r7_out, EXMA_ls7_ir8_0, EXMA_T1, EXMA_rf_d1, EXMA_rf_d2, EXMA_alu2_out, EXMA_alu3_out, clk)
 --variable next_lmsm_state: lmsmstate;
 begin
 s_ma<=not(opcodelwCout) or not(opcodeswCout) ;
 --next_lmsm_state:= lmsm_state;
 --case next_lmsm_state:
 -- when s0=>
 MAWB_en<='1';
 end process;
 process(MAWB_r7_out, MAWB_ls7_ir8_0, MAWB_rf_d1, MAWB_rf_d2, MAWB_alu2_out, MAWB_alu3_out, MAWB_PC_out, clk)
 begin
 s_din<= opcodesmCout;
 --s0_r7in<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or opcodeswCout or (opcodebeqCout and not(beqZflag)) or (not(opcodebeqCout and beqZflag)) or (not opcodejalCout) or opcodejlrCout or opcodelhiCout or opcodelmCout or opcodesmCout;
 --s1_r7in<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or opcodeswCout or (opcodebeqCout and not(beqZflag)) or (opcodebeqCout and beqZflag) or opcodejalCout or not(opcodejlrCout) or opcodelhiCout or opcodelmCout or opcodesmCout;
 s0_rfd3<=opcodeaddCout or opcodeadiCout or opcodenduCout or opcodelwCout or (not opcodejalCout) or (not opcodejlrCout) or (not opcodelhiCout) or (not opcodelmCout);
 s1_rfd3<=opcodeaddCout or opcodeadiCout or opcodenduCout or (not opcodelwCout) or opcodejalCout or opcodejalCout or (not opcodelhiCout) or (not opcodelmCout);
 reg_write_en_dummy<=opcodeaddCout or opcodenduCout or opcodeadiCout or opcodelwCout or opcodejalCout or opcodejlrCout or opcodelhiCout or opcodelmCout;
 d_mem_wr_en<=opcodeswCout;
 
 
 end process;
 end behave;