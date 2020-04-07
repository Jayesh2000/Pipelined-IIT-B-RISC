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
 
entity EXMA is 
	port (clk,rst, EXMA_en, EXMA_rst_flag: in std_logic;
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
end entity;

architecture Form of EXMA is 
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0'); 
begin
process (EXMA_en, clk, EXMA_rst_flag)
 begin
 if(rising_edge(clk)) then
 if(EXMA_rst_flag = '1' or rst = '1') then
 EXMA_zero_prev<="0";
 EXMA_carry_prev<="0";
 EXMA_opcode<="1111";
 EXMA_dest_reg<="000";
 EXMA_r7_out<=Z16;
 EXMA_rf_d1<=Z16;
 EXMA_rf_d2<=Z16;
 EXMA11_9<="000";
 EXMA8_6<="000";
 EXMA5_3<="000";
 EXMA7_0<="00000000";
 EXMA_ls7_ir8_0<=Z16;
 EXMA_PC_out<=Z16;
 EXMA_alu2_out<=Z16;
 EXMA_alu3_out<=Z16;
 else
 if(EXMA_en = '1') then
 EXMA_zero_prev<=zero_prev;
 EXMA_carry_prev<=carry_prev;
 EXMA_opcode<=RREX_opcode;
 EXMA_dest_reg<=RREX_dest_reg;
 EXMA_r7_out<=RREX_r7_out;
 EXMA_rf_d1<=RREX_rf_d1;
 EXMA_rf_d2<=RREX_rf_d2;
 EXMA11_9<=RREX11_9;
 EXMA8_6<=RREX8_6;
 EXMA5_3<=RREX5_3;
 EXMA7_0<=RREX7_0;
 EXMA_ls7_ir8_0<=RREX_ls7_ir8_0;
 EXMA_PC_out<=RREX_PC_out;
 EXMA_alu2_out<=alu_result_dummy;
 EXMA_alu3_out<=alu3_out; 
 end if;
 end if;
 end if;
 end process;
end Form;
