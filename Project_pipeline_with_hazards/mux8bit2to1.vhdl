library ieee;
use ieee.std_logic_1164.all;
entity mux8bit2to1 is
   port(A,B: in std_logic_vector(7 downto 0); 
   	    S: in std_logic; 
   	    Cout: out std_logic_vector(7 downto 0));
end entity mux8bit2to1;

architecture Equations of mux8bit2to1 is
begin 
   Cout(7) <= (A(7) and S) or (B(7) and (not(S))); 
   Cout(6) <= (A(6) and S) or (B(6) and (not(S))); 
   Cout(5) <= (A(5) and S) or (B(5) and (not(S))); 
   Cout(4) <= (A(4) and S) or (B(4) and (not(S))); 
   Cout(3) <= (A(3) and S) or (B(3) and (not(S))); 
   Cout(2) <= (A(2) and S) or (B(2) and (not(S))); 
   Cout(1) <= (A(1) and S) or (B(1) and (not(S))); 
   Cout(0) <= (A(0) and S) or (B(0) and (not(S))); 	
end Equations;