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
 
entity RREX is 
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
end entity;

architecture Form of RREX is
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0'); 
begin
process (RREX_en, clk, RREX_rst_flag)
 begin
 if(rising_edge(clk)) then
 if(RREX_rst_flag = '1' or rst = '1') then
 RREX_flag<='0';
 RREX_dest_reg<="000";
 RREX_r7_out<=Z16;
 RREX_rf_d1<=Z16;
 RREX_rf_d2<=Z16;
 RREX_opcode<="1111";
 RREX7_0<="00000000";
 RREX_se10_ir5_0<=Z16;
 RREX_se7_ir8_0<=Z16;
 RREX_ls7_ir8_0<=Z16;
 RREX_PC_out<=Z16;
 RREX11_9<="000";
 RREX8_6<="000";
 RREX5_3<="000";
 else
 if(RREX_en = '1') then
 RREX_flag<=IDRR_flag;
 RREX_dest_reg<=dest_reg;
 RREX_r7_out<=r7_read_data;
 RREX_rf_d1<=rf_d1;
 RREX_rf_d2<=rf_d2;
 RREX_opcode<=IDRR_opcode;
 RREX7_0<=IDRR7_0;
 RREX_se10_ir5_0<=IDRRse10_ir5_0; 
 RREX_se7_ir8_0<=IDRR_se7_ir8_0;
 RREX_ls7_ir8_0<=IDRR_ls7_ir8_0;
 RREX_PC_out<=IDRR_PC_out; 
 RREX11_9<=IDRR11_9;
 RREX8_6<=IDRR8_6;
 RREX5_3<=IDRR5_3;
 end if;
 end if;
 end if;
 end process;
end Form;
