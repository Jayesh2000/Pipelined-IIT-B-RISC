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
 
entity IDRR is 
	port (clk,rst, IDRR_en, IFID_flag, IDRR_rst_flag: in std_logic;
	      IFID_opcode: in std_logic_vector(3 downto 0);
	      inp11_9, inp8_6, inp5_3: in std_logic_vector(2 downto 0);
	      inp7_0: in std_logic_vector(7 downto 0);
		  se10_ir5_0, se7_ir8_0, ls7_ir8_0, inp_pc: in std_logic_vector(15 downto 0);
		  IDRR_flag: out std_logic;
		  IDRR_opcode: out std_logic_vector(3 downto 0);
		  IDRR11_9, IDRR8_6, IDRR5_3: out std_logic_vector(2 downto 0);
		  IDRR7_0: out std_logic_vector(7 downto 0);
		  IDRRse10_ir5_0, IDRRse7_ir8_0, IDRRls7_ir8_0, IDRRPC_out: out std_logic_vector(15 downto 0)	);
end entity;

architecture Form of IDRR is 
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0');
begin
process (IDRR_en, clk, IDRR_rst_flag)
 begin
 if(rising_edge(clk)) then
 if(IDRR_rst_flag = '1' or rst = '1') then
 IDRR_flag<='0';
 IDRR_opcode<="1111";
 IDRR11_9<="000";
 IDRR8_6<="000";
 IDRR5_3<="000";
 IDRR7_0<="00000000";
 IDRRse10_ir5_0<=Z16;
 IDRRse7_ir8_0<=Z16;
 IDRRls7_ir8_0<=Z16;
 IDRRPC_out<=Z16;
 else
 if(IDRR_en = '1') then
 IDRR_flag<=IFID_flag;
 IDRR_opcode<=IFID_opcode;
 IDRR11_9<=inp11_9;
 IDRR8_6<=inp8_6;
 IDRR5_3<=inp5_3;
 IDRR7_0<=inp7_0;
 IDRRse10_ir5_0<=se10_ir5_0; 
 IDRRse7_ir8_0<=se7_ir8_0;
 IDRRls7_ir8_0<=ls7_ir8_0;
 IDRRPC_out<=inp_pc; 
 end if;
 end if;
 end if;
 end process;
end Form;
