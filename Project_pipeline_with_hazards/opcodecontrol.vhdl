library ieee;
use ieee.std_logic_1164.all;
entity opcodecontrol is
 port(a,b,c,d:in std_logic; Cout1,Cout2,Cout3,Cout4,Cout5,Cout6,Cout7,Cout8,Cout9,Cout10,Cout11: out std_logic); 
end entity;

architecture Equations of opcodecontrol is
signal Cout: std_logic_vector(10 downto 0);
begin
process(a,b,c,d)
begin
Cout <= "00000000000"; 
 if(a = '0' and b = '0' and c = '0' and d = '0' ) then
  Cout(0) <= '1';
 else
  Cout(0) <= '0';
 end if;
 if(a = '0' and b = '0' and c = '0' and d = '1' ) then
  Cout(1) <= '1';
 else
  Cout(1) <= '0';
 end if;
 if(a = '0' and b = '0' and c = '1' and d = '0' ) then
  Cout(2) <= '1';
 else
  Cout(2) <= '0';
 end if;
 if(a = '0' and b = '0' and c = '1' and d = '1' ) then
  Cout(3) <= '1';
 else
  Cout(3) <= '0';
 end if;
 if(a = '0' and b = '1' and c = '0' and d = '0' ) then
  Cout(4) <= '1';
 else
  Cout(4) <= '0';
 end if;
 if(a = '0' and b = '1' and c = '0' and d = '1' ) then
  Cout(5) <= '1';
 else
  Cout(5) <= '0';
 end if;
 if(a = '0' and b = '1' and c = '1' and d = '0' ) then
  Cout(6) <= '1';
 else
  Cout(6) <= '0';
 end if;
 if(a = '0' and b = '1' and c = '1' and d = '1' ) then
  Cout(7) <= '1';
 else
  Cout(7) <= '0';
 end if;
 if(a = '1' and b = '1' and c = '0' and d = '0' ) then
  Cout(8) <= '1';
 else
  Cout(8) <= '0';
 end if;
 if(a = '1' and b = '0' and c = '0' and d = '0' ) then
  Cout(9) <= '1';
 else
  Cout(9) <= '0';
 end if;
 if(a = '1' and b = '0' and c = '0' and d = '1' ) then
  Cout(10) <= '1';
 else
  Cout(10) <= '0';
 end if;
end process;
Cout1<= Cout(0);
Cout2<= Cout(1);
Cout3<= Cout(2);
Cout4<= Cout(3);
Cout5<= Cout(4);
Cout6<= Cout(5);
Cout7<= Cout(6);
Cout8<= Cout(7);
Cout9<= Cout(8);
Cout10<= Cout(9);
Cout11<= Cout(10);
end Equations;