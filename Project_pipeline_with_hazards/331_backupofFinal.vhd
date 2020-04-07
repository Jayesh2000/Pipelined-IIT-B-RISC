library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;  
use ieee.std_logic_unsigned.all;
entity final is
port (
 clk, rst: in std_logic;
 output_vector: out std_logic_vector(15 downto 0)
);
end entity final;


architecture behave of final is
component register_file_VHDL is
port (
 clk,rst: in std_logic;
 reg_write_en: in std_logic;
 reg_write_dest: in std_logic_vector(2 downto 0);
 reg_write_data: in std_logic_vector(15 downto 0);
 reg_read_addr_1: in std_logic_vector(2 downto 0);
 reg_read_data_1: out std_logic_vector(15 downto 0);
 reg_read_addr_2: in std_logic_vector(2 downto 0);
 reg_read_data_2: out std_logic_vector(15 downto 0)
);
end component register_file_VHDL;
component alu is
port(
 zero_prev, carry_prev : in std_logic_vector(0 downto 0);
 a,b : in std_logic_vector(15 downto 0); -- src1, src2
 alu_control : in std_logic_vector(1 downto 0); -- function select
 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
 zero_control, carry_control : in std_logic_vector(0 downto 0);
 zero, carry: out std_logic -- Zero Flag
 );
 end component;

component Memory_syncread_syncwrite is 
	port (address,Mem_datain: in std_logic_vector(15 downto 0); 
	      clk,Mem_wr,Mem_rd: in std_logic;
			Mem_dataout: out std_logic_vector(15 downto 0));
end component Memory_syncread_syncwrite;

   --fsm   
 type FsmState is (s0, s1, s2, s4, s5, s7, s8, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20,s21, s22, s25, s26, s27, s28, s29, s30, s32);
 signal fsm_state: FsmState;
 signal mem_write, mem_read: std_logic;
 signal IP, IR, T1, T2, T3, T4: std_logic_vector(15 downto 0);
 constant Z16:std_logic_vector(15 downto 0):=(others=>'0');
 constant plusone: std_logic_vector(15 downto 0):= "0000000000000001";
 signal addr, m_din, mem_out: std_logic_vector(15 downto 0);
 signal  zero_prev_dummy, carry_prev_dummy : std_logic_vector(0 downto 0);
 signal a_dummy,b_dummy :  std_logic_vector(15 downto 0); -- src1, src2
 signal alu_control_dummy : std_logic_vector(1 downto 0); -- function select
 signal alu_result_dummy: std_logic_vector(15 downto 0); -- ALU Output Result
 signal zero_control_dummy, carry_control_dummy,z_flag, c_flag :  std_logic_vector(0 downto 0);
 signal zero_dummy, carry_dummy: std_logic;
 signal reg_write_en_dummy: std_logic;
 signal reg_write_dest_dummy: std_logic_vector(2 downto 0);
 signal reg_write_data_dummy: std_logic_vector(15 downto 0);
 signal reg_read_addr_1_dummy: std_logic_vector(2 downto 0);
 signal reg_read_data_1_dummy: std_logic_vector(15 downto 0);
 signal reg_read_addr_2_dummy: std_logic_vector(2 downto 0);
 signal reg_read_data_2_dummy: std_logic_vector(15 downto 0);
 
begin
 mem1: Memory_syncread_syncwrite port map (addr,m_din, clk, mem_write, mem_read, mem_out);
 alu1: alu port map (zero_prev_dummy, carry_prev_dummy,a_dummy,b_dummy ,alu_control_dummy ,alu_result_dummy,zero_control_dummy, carry_control_dummy,zero_dummy, carry_dummy);
 reg1: register_file_VHDL port map (clk, rst,reg_write_en_dummy,reg_write_dest_dummy, reg_write_data_dummy,reg_read_addr_1_dummy,reg_read_data_1_dummy, reg_read_addr_2_dummy, reg_read_data_2_dummy );
 process(clk,rst)
    variable next_fsm_state:FsmState;
    variable zero_var, carry_var: std_logic_vector(0 downto 0);
    variable IP_var,IR_var, T1_var, T2_var, T3_var, T4_var, oup: std_logic_vector(15 downto 0);
 begin
    next_fsm_state:=fsm_state;
    zero_var:=z_flag;
    carry_var:=c_flag;
    IP_var:=IP;
	 IR_var:=IR;
	 T1_var:=T1;
	 T2_var:=T2;
	T3_var:=T3;
	T4_var:=T4;
    --done_var:='0';
  case next_fsm_state is
    when s0=>
        --oup:=Z16;
        addr<=IP_var;
        mem_write<='0';
        mem_read<='1';
		  IR_var:= mem_out;
        if (IR_var(15 downto 14)= "00" and IR_var(12) = '0') then
         if (IR_var(1 downto 0) = "00") then   
           next_fsm_state:=s1;
        elsif (IR_var(1 downto 0)= "10" and carry_var(0) = '1') then
           next_fsm_state:=s1;
        elsif (IR_var(1 downto 0)= "01" and zero_var(0) = '1') then
            next_fsm_state:=s1;
        else
            next_fsm_state:=s5;
         end if;
        elsif  (IR_var(15 downto 13) = "010") then
            next_fsm_state:=s1;
        elsif  (IR_var(15 downto 13) = "011") then
            next_fsm_state:=s16;
        elsif (IR_var(15 downto 12) = "0011") then
             next_fsm_state:=s25;
        elsif (IR_var(15 downto 12) = "1100") then
             next_fsm_state:=s1;
        elsif (IR_var(15 downto 12) = "1000") then
             next_fsm_state:=s29;
        elsif (IR_var(15 downto 12) = "1001") then
             next_fsm_state:=s1;
        elsif (IR_var(15 downto 12) = "0001") then
             next_fsm_state:=s7;          
        end if;
    when s1=>
        reg_write_en_dummy<='0';
        reg_read_addr_1_dummy<=IR_var(11 downto 9);
        T1_var:=reg_read_data_1_dummy;
        reg_read_addr_2_dummy<=IR_var(8 downto 6);
        T2_var:=reg_read_data_2_dummy;
        if (IR_var(15 downto 13) = "010") then
          next_fsm_state:=s11;
        elsif (IR_var(15 downto 12) = "1100") then
          next_fsm_state:=s27;
        elsif (IR_var(15 downto 12) = "1001") then
          next_fsm_state:=s29;
        else
          next_fsm_state:=s2;
        end if ;
        
    when s2=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=T1_var;
        b_dummy<=T2_var;
        if (IR_var(15 downto 13) = "000") then
        alu_control_dummy<="00";
		  zero_control_dummy(0)<='1';
        carry_control_dummy(0)<='1';
        elsif (IR_var(15 downto 12) = "0010") then
        alu_control_dummy<="10";
		  zero_control_dummy(0)<='1';
        carry_control_dummy(0)<='0';
        end if;
        T3_var:=alu_result_dummy;
		  oup:= T3_var;
        --if (IR_var(15 downto 13) = "000") then
        
        --elsif (IR_var(15 downto 12) = "0010")  then
        
        --end if;          
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        if (IR_var(15 downto 12) = "0001") then
        next_fsm_state:=s8;
        else
        next_fsm_state:=s4;
        end if;
    when s4=>
        reg_write_en_dummy<='1';
        reg_write_dest_dummy<=IR_var(5 downto 3);
        reg_write_data_dummy<=T3_var;
        next_fsm_state:=s5;
        oup:=T3_var;
    when s5=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=IP_var;
        b_dummy<=plusone;
        alu_control_dummy<="00";
		  zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0';
        IP_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        next_fsm_state:=s0;
    when s7=>
        reg_write_en_dummy<='0';
        reg_read_addr_1_dummy<=IR_var(11 downto 9);
        T1_var:=reg_read_data_1_dummy;
        T2_var:= IR_var(5) & IR_var(5) & IR_var(5) & 
		           IR_var(5) & IR_var(5) & IR_var(5) & 
					  IR_var(5) & IR_var(5) & IR_var(5) & 
					  IR_var(5) & IR_var(5 downto 0);
        next_fsm_state:=s2;
    when s8=>
        reg_write_en_dummy<='1';
        reg_write_dest_dummy<=IR_var(8 downto 6);
        reg_write_data_dummy<=T3_var;
        next_fsm_state:=s5;
        oup:= reg_write_data_dummy;
    when s11=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=T2_var;
        b_dummy<=IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5 downto 0);
        alu_control_dummy<="00";
        
        zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0';
			T3_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
		  if IR_var(12) = '0' then  --only for LW, Sw
        next_fsm_state:=s12;
        else
        next_fsm_state:=s15;
        end if;          
    when s12=>
        addr<=T3_var;
        
        mem_write<='0';
        mem_read<='1';
		  T1_var:=mem_out;
        next_fsm_state:=s13;
    when s13=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=T1_var;
        b_dummy<=Z16;
        alu_control_dummy<="00";
        
        zero_control_dummy(0)<='1';
        carry_control_dummy(0)<='0';
			T1_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        next_fsm_state:=s14;
    when s14=>
        reg_write_en_dummy<='1';
        reg_write_dest_dummy<=IR_var(11 downto 9);
        reg_write_data_dummy<=T1_var;
        next_fsm_state:=s5;
    when s15=>
        addr<=T3_var;
        
        mem_write<='1';
        mem_read<='0';
		  T1_var:=mem_out;
        next_fsm_state:=s5;
    when s16=>
        reg_write_en_dummy<='0';
        reg_read_addr_1_dummy<=IR_var(11 downto 9);
        T1_var:=reg_read_data_1_dummy;
        T3_var:=Z16;
        if(IR_var(12) = '0') then
        next_fsm_state:=s17;
        else
          next_fsm_state:=s21;
        end if;
    when s17=>
        addr<=T1_var;
        
        mem_write<='0';
        mem_read<='1';
		  T2_var:=mem_out;
        next_fsm_state:=s18;
    when s18=>
        reg_write_en_dummy<='1';
        reg_write_dest_dummy<=T3_var(2 downto 0);
        reg_write_data_dummy<=T2_var;
        next_fsm_state:=s5;
    when s19=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=T3_var;
        b_dummy<=plusone;
        alu_control_dummy<="00";
        
        zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0';
			T3_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        next_fsm_state:=s20;
    when s20=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=T1_var;
        b_dummy<=plusone;
        alu_control_dummy<="00";
       
        zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0'; 
			 T1_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        if (conv_integer(T3) < 8)then
         if(IR_var(12) = '0') then
         next_fsm_state:=s17;
         else
          next_fsm_state:=s21;
        end if;
        else
        next_fsm_state:=s5;
        end if;
    when s21=>
        reg_write_en_dummy<='0';
        reg_read_addr_1_dummy<=T3_var(2 downto 0);
        T2_var:=reg_read_data_1_dummy;
        next_fsm_state:=s22;
    when s22=>
        addr<=T1_var;
        
        mem_write<='1';
        mem_read<='0';
		  T2_var:=mem_out;
        next_fsm_state:=s19;
    when s25=>
        T1_var(15 downto 7):= IR_var(8 downto 0);
        T1_var(6 downto 0):= "0000000";
        next_fsm_state:=s26;
    when s26=>
        reg_write_en_dummy<='1';
        reg_write_dest_dummy<=IR_var(11 downto 9);
        reg_write_data_dummy<=T1_var;
        next_fsm_state:=s5;
    when s27=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=T1_var;
        b_dummy<=T2_var;
        alu_control_dummy<="01";
        
        zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0'; 
			T3_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        if (T3_var = Z16) then
        next_fsm_state:=s28;
        else
        next_fsm_state:=s5;
        end if;
    when s28=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=IP_var;
        b_dummy<=IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5) & IR_var(5 downto 0);
        alu_control_dummy<="00";
        
        zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0'; 
			IP_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        next_fsm_state:=s0;
    when s29=>
        reg_write_en_dummy<='1';
        reg_write_dest_dummy<=IR_var(11 downto 9);
        reg_write_data_dummy<=IP_var;
        if(IR_var(12) = '0') then
        next_fsm_state:=s30;
        else
        next_fsm_state:=s32;
        end if;
    when s30=>
        zero_prev_dummy<=zero_var;
        carry_prev_dummy<=carry_var;
        a_dummy<=IP_var;
        b_dummy<=IR_var(8) & IR_var(8) & IR_var(8) & IR_var(8) & IR_var(8) & IR_var(8) & IR_var(8) & IR_var(8 downto 0);
        alu_control_dummy<="00";
        
        zero_control_dummy(0)<='0';
        carry_control_dummy(0)<='0';
			IP_var:=alu_result_dummy;
        zero_var(0):=zero_dummy;
        carry_var(0):=carry_dummy;
        next_fsm_state:=s0;
    when s32=>
        IP_var:=T2_var;
        next_fsm_state:=s0;
    end case;
     output_vector<=oup;
    if(clk'event and clk='1') then
        if(rst = '1') then
           fsm_state <= s0;
           IP <= x"0000";
           z_flag(0)<='0';
           c_flag(0)<='0';
			  IP <= Z16;
			  IR <= Z16;
			  T1 <= Z16;
			  T2 <= Z16;
			  T3 <= Z16;
			  T4 <= Z16;
        else
           fsm_state <= next_fsm_state; 
           z_flag <= zero_var;
           c_flag <= carry_var;     
           IP <= IP_var;
			  IR <= IR_var;
	        T1<= T1_var;
           T2<= T2_var;
           T3<= T3_var;
           T4<= T4_var;			  
        end if;
    end if;
  end process;       
   

end behave; -- archt
