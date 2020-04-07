library std;
use std.standard.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.all;
use IEEE.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;
entity lmsmblock is
port(
  clk: in std_logic;
  a: in std_logic_vector(7 downto 0); -- input
  pe_out: out std_logic_vector(2 downto 0);
  lmsmout: out std_logic_vector(7 downto 0) -- LM SM output
 );
end lmsmblock;

architecture Behavioral of lmsmblock is

component priorityencoder is
 port(  
         din : in STD_LOGIC_VECTOR(7 downto 0);
         dout : out STD_LOGIC_VECTOR(2 downto 0)
         );	
end component;

--signal eightbitseq1: std_logic_vector(7 downto 0);
signal p_out: std_logic_vector(2 downto 0);
begin
pe: priorityencoder port map (din=>a, dout=>p_out);
pe_out<=p_out;
process(clk, p_out)
--variable peout: std_logic_vector(2 downto 0);
--variable eightbitseq: std_logic_vector(7 downto 0);
variable lmsmout_var: std_logic_vector(7 downto 0);
begin
case p_out is
 when "000" =>
  lmsmout_var(7):='0';
  lmsmout_var(6 downto 0):= a(6 downto 0);
 when "001" =>
   lmsmout_var(7 downto 6):="00";
   lmsmout_var(5 downto 0):= a(5 downto 0);
 when "010" =>
 lmsmout_var(7 downto 5):="000";
 lmsmout_var(4 downto 0):= a(4 downto 0);
 when "011" =>
 lmsmout_var(7 downto 4):="0000";
 lmsmout_var(3 downto 0):= a(3 downto 0);
 when "100" =>
 lmsmout_var(7 downto 3):="00000";
 lmsmout_var(2 downto 0):= a(2 downto 0);
 when "101" =>
 lmsmout_var(7 downto 2):="000000";
 lmsmout_var(1 downto 0):= a(1 downto 0);
 when "110" =>
 lmsmout_var(7 downto 1):="0000000";
 lmsmout_var(0 downto 0):= a(0 downto 0);
 when "111" =>
 lmsmout_var(7 downto 0):="00000000";
 when others => null;
 end case;
 
 if (clk'event and clk='1') then
 lmsmout <= lmsmout_var;
-- pe_out <= p_out;
 end if;
--peout:= p_out;
--if (peout(2) = '0' and peout(1) = '0' and peout(2) = '0') then
-- --eightbitseq := "01111111";
-- lmsmout_var(7)<='0';
-- lmsmout_var(6 downto 0)<= a(6 downto 0);
-- elsif (peout(2) = '0' and peout(1) = '0' and peout(2) = '1') then
-- --eightbitseq := "00111111";
-- lmsmout_var(7 downto 6)<="00";
-- lmsmout_var(5 downto 0)<= a(5 downto 0);
--elsif (peout(2) = '0' and peout(1) = '1' and peout(2) = '0') then
-- --eightbitseq := "00011111";
-- lmsmout_var(7 downto 5)<="000";
-- lmsmout_var(4 downto 0)<= a(4 downto 0);
--elsif (peout(2) = '0' and peout(1) = '1' and peout(2) = '1') then
-- --eightbitseq := "00001111";
-- lmsmout_var(7 downto 4)<="0000";
-- lmsmout_var(3 downto 0)<= a(3 downto 0);
--elsif (peout(2) = '1' and peout(1) = '0' and peout(2) = '0') then
-- --eightbitseq := "00000111";
-- lmsmout_var(7 downto 3)<="00000";
-- lmsmout_var(2 downto 0)<= a(2 downto 0);
--elsif (peout(2) = '1' and peout(1) = '0' and peout(2) = '1') then
-- --eightbitseq := "00000011";
-- lmsmout_var(7 downto 2)<="000000";
-- lmsmout_var(1 downto 0)<= a(1 downto 0);
--elsif (peout(2) = '1' and peout(1) = '1' and peout(2) = '0') then
-- --eightbitseq := "00000001";
-- lmsmout_var(7 downto 1)<="0000000";
-- lmsmout_var(0 downto 0)<= a(0 downto 0);
--elsif (peout(2) = '1' and peout(1) = '1' and peout(2) = '1') then
-- --eightbitseq := "00000000";
-- lmsmout_var(7 downto 0)<="00000000";
-- lmsmout_var(5 downto 0)<= a(5 downto 0);
--end if;
--if (clk'event and clk='1') then

--eightbitseq1 <= eightbitseq; 
--lmsmout(0) <= eightbitseq(0) and a(0);
--lmsmout(1) <= eightbitseq(1) and a(1);
--lmsmout(2) <= eightbitseq(2) and a(2);
--lmsmout(3) <= eightbitseq(3) and a(3);
--lmsmout(4) <= eightbitseq(4) and a(4);
--lmsmout(5) <= eightbitseq(5) and a(5);
--lmsmout(6) <= eightbitseq(6) and a(6);
--lmsmout(7) <= eightbitseq(7) and a(7);
--end if;
end process;

end Behavioral;
