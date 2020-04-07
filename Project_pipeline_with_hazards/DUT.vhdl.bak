-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

library ieee;
use ieee.std_logic_1164.all;
entity DUT is
   port(input_vector: in std_logic_vector(1 downto 0);
       	output_vector: out std_logic_vector(15 downto 0));
end entity;

architecture DutWrap of DUT is
  component final is
port (
 clk, rst: in std_logic;
 output_vector: out std_logic_vector(15 downto 0)
);
 end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: final
			port map (
					-- order of inputs Cin B A
					clk=> input_vector(1),
          rst=>input_vector(0),
          output_vector=>output_vector             	
                                        -- order of outputs S Cout
					);

end DutWrap;

