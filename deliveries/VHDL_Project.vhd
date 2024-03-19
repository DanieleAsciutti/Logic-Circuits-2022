library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity project_reti_logiche is
port (
i_clk : in std_logic;
i_rst : in std_logic;
i_start : in std_logic;
i_data : in std_logic_vector(7 downto 0);
o_address : out std_logic_vector(15 downto 0);
o_done : out std_logic;
o_en : out std_logic;
o_we : out std_logic;
o_data : out std_logic_vector (7 downto 0)
);
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

signal r1_load : STD_LOGIC;
signal r2_sel : STD_LOGIC;
signal r2_load : STD_LOGIC;
signal r3_sel : STD_LOGIC;
signal r3_load : STD_LOGIC;
signal r4_load : STD_LOGIC;
signal r5_sel : STD_LOGIC;
signal r5_load : STD_LOGIC;
signal r6_load : STD_LOGIC;
signal reg1 : STD_LOGIC_VECTOR (7 downto 0);
signal reg2 : STD_LOGIC_VECTOR (7 downto 0);
signal reg3 : STD_LOGIC_VECTOR (15 downto 0);
signal reg4 : STD_LOGIC_VECTOR (7 downto 0);
signal reg5 : STD_LOGIC_VECTOR (3 downto 0);
signal reg6 : STD_LOGIC_VECTOR (15 downto 0);
signal o_cend : STD_LOGIC;
signal o_fend : STD_LOGIC;
signal o_inmem : STD_LOGIC_VECTOR (15 downto 0);
signal o_outmem : STD_LOGIC_VECTOR (15 downto 0);
signal c_sel : STD_LOGIC;
signal c_rst : STD_LOGIC;
signal c_end : STD_LOGIC;
signal in_cs : STD_LOGIC;
signal out_cs1 : STD_LOGIC;
signal out_cs2 : STD_LOGIC;
signal sum2 : STD_LOGIC_VECTOR (7 downto 0);

type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18);
type C is (CS0,CS1,CS2,CS3);
signal curr_state, next_state : S;
signal curr_state_c, next_state_c : C;

begin
  process(i_clk, i_rst, c_rst, c_sel)
    begin 
        if(i_rst = '1') then
            curr_state <= S0;
            curr_state_c <= CS0;
        elsif i_clk' event and i_clk = '1' then 
            curr_state <= next_state;
            if c_sel = '1' then
                curr_state_c <= next_state_c;
            end if;
        end if;
        if c_rst = '1' then
            curr_state_c <= CS0;
        end if;
    end process;
    
    process(curr_state,next_state,i_start,o_cend,o_fend,c_end)
        begin
            next_state <= curr_state;
            case curr_state is
                when S0 =>
                    if i_start = '1' then
                        next_state <= S1;
                    end if;
                when S1 =>
                    next_state <= S2;
                when S2 =>
                    next_state <= S3;
                when S3 =>
                    if o_cend = '1' then
                        next_state <= S4;
                    else
                        next_state <= S6;
                    end if;
                when S4 =>
                    if i_start = '0' then
                        next_state <= S5;
                    end if;
                when S5 =>
                    next_state <= S0;
                when S6 =>
                    if o_fend = '0' then
                        next_state <= S7;
                    else
                        next_state <= S18;
                    end if;
                when S7 =>
                    next_state <= S8;
                when S8 =>
                    next_state <= S9;
                when S9 =>
                    next_state <= S10;
                when S10 =>
                    next_state <= S11;
                when S11 =>
                    if c_end = '0' then
                        next_state <= S9;
                    else
                        next_state <= S12;
                    end if;
                when S12 =>
                    next_state <= S13;
                when S13 =>
                    next_state <= S14;
                when S14 =>
                    next_state <= S15;
                when S15 =>
                    next_state <= S16;
                when S16 =>
                    next_state <= S17;
                when S17 =>
                    next_state <= S6;
                when S18 =>
                    next_state <= S4;
            end case;
    end process;
       
   process(curr_state_c,in_cs)         
        begin   
            next_state_c <= curr_state_c;   
                case curr_state_c is
                    when CS0 =>
                        if in_cs = '0' then
                            out_cs1 <= '0';
                            out_cs2 <= '0';
                        else
                            next_state_c <= CS2;
                            out_cs1 <= '1';
                            out_cs2 <= '1';
                        end if;
                    when CS1 =>
                        if in_cs = '0' then
                            next_state_c <= CS0;
                            out_cs1 <= '1';
                            out_cs2 <= '1';
                        else
                            next_state_c <= CS2;
                            out_cs1 <= '0';
                            out_cs2 <= '0';
                        end if;
                    when CS2 =>
                        if in_cs = '0' then
                            next_state_c <= CS1;
                            out_cs1 <= '0';
                            out_cs2 <= '1';
                        else
                            next_state_c <= CS3;
                            out_cs1 <= '1';
                            out_cs2 <= '0';
                        end if;    
                    when CS3 =>
                        if in_cs = '0' then
                            next_state_c <= CS1;
                            out_cs1 <= '1';
                            out_cs2 <= '0';
                        else
                            out_cs1 <= '0';
                            out_cs2 <= '1';
                        end if;
                   end case;
      end process;
      
      
      process (curr_state,reg6,o_inmem,o_outmem) 
      begin
            o_address <= "0000000000000000";
            o_en <= '0';
            o_we <= '0';
            o_done <= '0';
            c_rst <= '0';
            c_sel <= '0';
            r1_load <= '0';
            r2_sel <= '0';
            r2_load <= '0';
            r3_sel <= '0';
            r3_load <= '0';
            r4_load <= '0';
            r5_sel <= '0';
            r5_load <= '0';
            r6_load <= '0';
            o_data <= "00000000";
            case curr_state is
                when S0 =>
                when S1 =>
                    o_en <= '1';
                    r2_load <= '1';
                    r3_load <= '1';
                when S2 =>
                    r1_load <= '1';
                when S3 =>
                when S4 =>
                    o_done <= '1';
                when S5 =>
                when S6 =>
                when S7 =>
                    o_address <= o_inmem;
                    o_en <= '1';
                    r5_load <= '1';
                when S8 =>
                    r4_load <= '1';
                when S9 =>
                    c_sel <= '1';
                    r6_load <= '1';
                when S10 =>
                    r5_sel <= '1';
                    r5_load <= '1';
                when S11 =>
                when S12 =>
                    c_sel <= '1';
                    r6_load <= '1';
                when S13 =>
                    o_address <= o_outmem;
                    o_en <= '1';
                    o_we <= '1';
                    o_data <=reg6(15 downto 8);
                when S14 =>
                    r3_sel <= '1';
                    r3_load <= '1';
                when S15 =>
                when S16 =>
                    o_address <= o_outmem;
                    o_en <= '1';
                    o_we <= '1';                               
                    o_data <= reg6(7 downto 0);
                when S17 =>
                r2_sel <= '1';
                r2_load <= '1';
                r3_sel <= '1';
                r3_load <= '1';
                when S18 =>
                    c_rst <= '1';
            end case;
       end process;
    
    process (i_clk)
        begin
            if i_clk' event and i_clk = '1' then
                if r1_load = '1' then
                    reg1 <= i_data;
                 end if;
                 if r2_load = '1' then
                    if r2_sel = '0' then
                        reg2 <= "00000001";
                    else
                        reg2 <= sum2;
                    end if;
                 end if;
                 if r3_load = '1' then
                    if r3_sel = '0' then
                        reg3 <= "0000000000000000";
                    else
                        reg3 <= reg3 + "1";
                    end if;
                end if;
                if r4_load = '1' then
                    reg4 <= i_data;
                end if;
                if r5_load = '1' then
                    if r5_sel = '0' then
                        reg5 <= "0111";
                    else
                        reg5 <= reg5 - "1";
                    end if;
                end if;    
                if r6_load = '1' then
                    reg6(conv_integer(reg5+reg5+"1")) <= out_cs1;
                    reg6(conv_integer(reg5+reg5)) <= out_cs2;
                end if; 
         end if;
         o_inmem <= reg2 + "0000000000000000";
    end process;
    
    o_cend <= '1' when (reg1 = "00000000") else '0';
    o_fend <= '1' when (reg2 = reg1 + "1") else '0';
    o_outmem <= reg3 + "1111101000";
    c_end <= '1' when (reg5 = "0000") else '0';
    in_cs <= reg4(conv_integer(reg5));
    sum2 <= reg2 + "00000001";



end Behavioral; 