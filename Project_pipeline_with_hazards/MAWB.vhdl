library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

-- since The Memory is asynchronous read, there is no read signal, but you can use it based on your preference.
-- this memory gives 16 Bit data in one clock cycle, so edit the file to your requirement.
--p IFID_Mem_d_out(7 downto 0),se10_ir5_0, se7_ir8_0, ls7_ir8_0, IFID_PC_out);
 
entity MAWB is 
	port (clk,rst, MAWB_en, MAWB_rst_flag: in std_logic;
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
end entity;

architecture Form of MAWB is 
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0'); 
begin
process (MAWB_en, clk, MAWB_rst_flag)
 begin
 if(rising_edge(clk)) then
 if(MAWB_rst_flag = '1' or rst='1') then
 MAWB_zero_prev<="0";
 MAWB_carry_prev<="0";
 MAWB_dest_reg<="000";
 MAWB_opcode<="1111";
 MAWB_r7_out<=Z16;
 MAWB_ls7_ir8_0<=Z16;
 MAWB_rf_d1<=Z16;
 MAWB_rf_d2<=Z16;
 MAWB_alu2_out<=Z16;
 MAWB_alu3_out<=Z16;
 MAWB_data_mem_out<=Z16;
 MAWB_PC_out<=Z16;
 MAWB7_0<="00000000";
 MAWB11_9<="000";
 MAWB8_6<="000";
 MAWB5_3<="000";
 else
 if(MAWB_en = '1') then
 MAWB_zero_prev<=EXMA_zero_prev;
 MAWB_carry_prev<=EXMA_carry_prev;
 MAWB_dest_reg<=EXMA_dest_reg;
 MAWB_opcode<=EXMA_opcode;
 MAWB_r7_out<=EXMA_r7_out;
 MAWB_ls7_ir8_0<=EXMA_ls7_ir8_0;
 MAWB_rf_d1<=EXMA_rf_d1;
 MAWB_rf_d2<=EXMA_rf_d2;
 MAWB_alu2_out<=EXMA_alu2_out;
 MAWB_alu3_out<=EXMA_alu3_out;
 MAWB_data_mem_out<=data_mem_out;
 MAWB_PC_out<=EXMA_PC_out;
 MAWB7_0<=EXMA7_0;
 MAWB11_9<=EXMA11_9;
 MAWB8_6<=EXMA8_6;
 MAWB5_3<=EXMA5_3;
 end if;
 end if;
 end if;
 end process;
end Form;
