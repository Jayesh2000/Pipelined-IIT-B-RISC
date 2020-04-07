library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lookup_tab is 
  port(
    ip, alu3_o, RR_ex_ip, RF_d3, ID_rr_ip:    in std_logic_vector(15 downto 0);
	 ID_rr_11_9 : in std_logic_vector(2 downto 0);
	 RR_ex_opcode, ID_rr_opcode: in std_logic_vector(3 downto 0);
	 ID_rr_in_flag,RR_ex_in_flag, clk,rst: in std_logic;
    out1:  out std_logic_vector(15 downto 0);
	 matchBit: out std_logic
);
end entity lookup_tab;

architecture design of lookup_tab is
type reg_type is array (0 to 15 ) of std_logic_vector (15 downto 0);
   signal IP_symbol, BTA: reg_type;
	signal index: std_logic_vector(3 downto 0);
begin
	process(clk)
	variable index_var: std_logic_vector(3 downto 0);
	begin
	    if(RR_ex_in_flag = '0' and (RR_ex_opcode = "1100" or RR_ex_opcode = "1000")) then
		 IP_symbol(to_integer(unsigned(index))) <= RR_ex_ip;
		 BTA(to_integer(unsigned(index))) <= alu3_o;
		 index_var := index + 1;
		 elsif(ID_rr_in_flag = '0' and ID_rr_opcode = "0011" and ID_rr_11_9 = "111") then
		 IP_symbol(to_integer(unsigned(index))) <= ID_rr_ip;
		 BTA(to_integer(unsigned(index))) <= RF_d3;
		 index_var := index + 1;
		 end if;
		 
		 if (clk'event and clk='1') then
		 if(rst = '1') then
		 index <= "0000";
		 end if;
		 index <= index_var;
		 end if;
	end process;
	
	process(clk)
	begin
	   loop1: for k in 0 to 15 loop --to_integer(unsigned(index)) loop //  dynamic not working
		    if(IP_symbol(k) = ip) then
			 out1 <= bta(k);
			 matchBit <= '1';
			 end if;
			 end loop loop1;
	end process;
end design;