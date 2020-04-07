-- A DUT entity is used to wrap your design.
--  This example shows how you can do this for the
--  Full-adder.

library ieee;
use ieee.std_logic_1164.all;
entity DUT is
   port(clk, rst, clk_fpga: in std_logic--; output: out std_logic);
       	);--output_vector: out std_logic_vector(15 downto 0));
end entity;

architecture DutWrap of DUT is
--signal rst_trigger: std_logic;
  component main7 is
port (
 clk, rst, clk_fpga: in std_logic--; output: out std_logic
);
 end component;
begin
  --rst_trigger<= not rst;

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: main7
			port map (
					-- order of inputs Cin B A
					clk=> clk,
          rst=> rst,
			  clk_fpga=>clk_fpga
			 -- output=>output
          --output_vector=>output_vector             	
                                        -- order of outputs S Cout
					);

end DutWrap;

