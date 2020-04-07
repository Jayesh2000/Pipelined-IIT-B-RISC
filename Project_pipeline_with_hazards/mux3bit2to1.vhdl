library ieee;
use ieee.std_logic_1164.all;
entity mux3bit2to1 is
   port(A,B: in std_logic_vector(2 downto 0); 
   	    S: in std_logic; 
   	    Cout: out std_logic_vector(2 downto 0));
end entity mux3bit2to1;

architecture Equations of mux3bit2to1 is
begin
   Cout(2) <= (A(2) and S) or (B(2) and (not(S))); 
   Cout(1) <= (A(1) and S) or (B(1) and (not(S))); 
   Cout(0) <= (A(0) and S) or (B(0) and (not(S))); 	
end Equations;