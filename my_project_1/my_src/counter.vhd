library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity counter is
    port
    (
        i_clk : in    std_logic;
        i_rst : in    std_logic;

        i_en  : in    std_logic;
        i_max : in    std_logic_vector(31 downto 0);
        o_val :   out std_logic_vector(31 downto 0);
        o_int :   out std_logic 
    ); 
end counter;

architecture rtl of counter is
    signal q_counter : unsigned(i_max'range) := (others => '0');
begin
    o_int <= '1' when q_counter = to_unsigned(0, q_counter'length) else '0';

    p_counter : process (i_clk) is
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                q_counter <= (others => '0');
            else
                if i_en = '1' then
                    if q_counter > 0 then
                        q_counter <= q_counter - 1;
                    else
                        q_counter <= unsigned(i_max); 
                    end if;
                else
                    q_counter <= unsigned(i_max);
                end if;
            end if;
        end if;
    end process p_counter;
end rtl;
