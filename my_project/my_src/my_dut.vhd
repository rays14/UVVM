---------------------------------------------------------------------------------------------------
-- Module     : my_dut.vhd
-- Author     : Sid Ray
-- Date       : 10/16/2024
-- Definition : Example of my UVVM DUT. It is a simple GPIO. Will also add a AXI slave endpoint
--              soon to drive this via Vivado. Needs an AXI VVC tester.
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
entity my_dut is
    port
    (
        i_clk : in    std_logic;
        i_rst : in    std_logic;
        i_val : in    std_logic;
        o_val :   out std_logic
    );
end my_dut;
architecture rtl of my_dut is
    signal q_val : std_logic := '0';
begin
    o_val <= q_val;

    p_my_dut : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                q_val <= '0';
            else
                q_val <= i_val;
            end if;
        end if;
    end process p_my_dut;
end rtl;