---------------------------------------------------------------------------------------------------
-- Module     : uvvm_tb.vhd
-- Author     : Sid Ray
-- Date       : 10/16/2024
-- Definition : Example of my UVVM simple test-bench using a GPIO. Idea
--              is to build on this with more complex modules including
--              AXI, UART and SPI. These need to be done for Kearfott
--              testing.
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library uvvm_util;
    context uvvm_util.uvvm_util_context;
package local_pkg is
    function slv_to_string(
      constant value : in std_logic_vector
    ) return string;
end package local_pkg;
package body local_pkg is
    function slv_to_string(
      constant value : in std_logic_vector
    ) return string is
    begin
      return to_string(value, HEX, KEEP_LEADING_0, INCL_RADIX);
    end function;
end package body local_pkg;
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library uvvm_util;
    context uvvm_util.uvvm_util_context;
library bitvis_vip_scoreboard;
library work;
    use work.local_pkg.all;
package slv1024_sb_pkg is new bitvis_vip_scoreboard.generic_sb_pkg
    generic map(t_element         => std_logic_vector(1023 downto 0),
                element_match     => std_match,
                to_string_element => slv_to_string);
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library uvvm_util;
    context uvvm_util.uvvm_util_context;
library bitvis_vip_scoreboard;
library work;
    use work.local_pkg.all;
package slv1_sb_pkg is new bitvis_vip_scoreboard.generic_sb_pkg
    generic map(t_element         => std_logic_vector(0 downto 0),
                element_match     => std_match,
                to_string_element => slv_to_string);
---------------------------------------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;
library uvvm_util;
    context uvvm_util.uvvm_util_context;
library uvvm_vvc_framework;
    use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;
library bitvis_vip_sbi;
    context bitvis_vip_sbi.vvc_context;
library bitvis_vip_clock_generator;
    context bitvis_vip_clock_generator.vvc_context;
library bitvis_vip_gpio;
    context bitvis_vip_gpio.vvc_context; 
library bitvis_vip_scoreboard;
    use bitvis_vip_scoreboard.slv8_sb_pkg.all;
    use bitvis_vip_scoreboard.slv_sb_pkg.all;
    use bitvis_vip_scoreboard.generic_sb_support_pkg.all;
library work;
    use work.slv1024_sb_pkg.all;
    use work.slv1_sb_pkg.all;
entity uvvm_tb is
end entity uvvm_tb;
architecture func of uvvm_tb is
    constant C_SCOPE    : string  := "TB";
    signal t_rst        : std_logic := '0';
    signal t_clk        : std_logic;
    signal t_dut_input  : std_logic_vector(0 downto 0) := (others => '0');
    signal t_dut_output : std_logic_vector(0 downto 0) := (others => '0');
    signal t_out        : std_logic_vector(0 downto 0) := (others => '0');
    shared variable v_gpio_sb : work.slv1_sb_pkg.t_generic_sb;
begin

    clk_gen : entity bitvis_vip_clock_generator.clock_generator_vvc(behave)
        generic map
        (
            GC_INSTANCE_IDX                           => 1,     -- : natural       := 1;
            GC_CLOCK_NAME                             => "clk"  -- : string        := "clk";
        -- Turbohack : Use defaults
        --     GC_CLOCK_PERIOD                          : time          := 10 ns;
        --     GC_CLOCK_HIGH_TIME                       : time          := 5 ns;
        --     GC_CMD_QUEUE_COUNT_MAX                   : natural       := C_CMD_QUEUE_COUNT_MAX;
        --     GC_CMD_QUEUE_COUNT_THRESHOLD             : natural       := C_CMD_QUEUE_COUNT_THRESHOLD;
        --     GC_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY    : t_alert_level := C_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY;
        --     GC_RESULT_QUEUE_COUNT_MAX                : natural       := C_RESULT_QUEUE_COUNT_MAX;
        --     GC_RESULT_QUEUE_COUNT_THRESHOLD          : natural       := C_RESULT_QUEUE_COUNT_THRESHOLD;
        --     GC_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY : t_alert_level := C_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY
        )
        port map
        (
            clk => t_clk  -- : out std_logic
        );

    gpio_input : entity bitvis_vip_gpio.gpio_vvc(behave)
        generic map
        (
            GC_DATA_WIDTH                            =>  1,   -- : natural range 1 to C_VVC_CMD_DATA_MAX_LENGTH;
            GC_INSTANCE_IDX                          =>  1,   -- : natural;
            GC_DEFAULT_LINE_VALUE                    => "0"   -- : std_logic_vector(GC_DATA_WIDTH - 1 downto 0);
            -- Turbohack : Use defaults for all these because I don't know what they do
            -- GC_GPIO_BFM_CONFIG                       : t_gpio_bfm_config := C_GPIO_BFM_CONFIG_DEFAULT;
            -- GC_CMD_QUEUE_COUNT_MAX                   : natural           := C_CMD_QUEUE_COUNT_MAX;
            -- GC_CMD_QUEUE_COUNT_THRESHOLD             : natural           := C_CMD_QUEUE_COUNT_THRESHOLD;
            -- GC_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY    : t_alert_level     := C_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY;
            -- GC_RESULT_QUEUE_COUNT_MAX                : natural           := C_RESULT_QUEUE_COUNT_MAX;
            -- GC_RESULT_QUEUE_COUNT_THRESHOLD          : natural           := C_RESULT_QUEUE_COUNT_THRESHOLD;
            -- GC_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY : t_alert_level     := C_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY
        )
        port map
        (
            gpio_vvc_if => t_dut_input(0 downto 0)  -- : inout std_logic_vector(GC_DATA_WIDTH - 1 downto 0) := GC_DEFAULT_LINE_VALUE
        );

    gpio_output : entity bitvis_vip_gpio.gpio_vvc(behave)
        generic map
        (
            GC_DATA_WIDTH                            =>  1,   -- : natural range 1 to C_VVC_CMD_DATA_MAX_LENGTH;
            GC_INSTANCE_IDX                          =>  2,   -- : natural;

            -- Turbohack : Set to "Z" to set it as an input.
            GC_DEFAULT_LINE_VALUE                    => "Z"   -- : std_logic_vector(GC_DATA_WIDTH - 1 downto 0);

            -- Turbohack : Use defaults for all these because I don't know what they do.
            -- GC_GPIO_BFM_CONFIG                       : t_gpio_bfm_config := C_GPIO_BFM_CONFIG_DEFAULT;
            -- GC_CMD_QUEUE_COUNT_MAX                   : natural           := C_CMD_QUEUE_COUNT_MAX;
            -- GC_CMD_QUEUE_COUNT_THRESHOLD             : natural           := C_CMD_QUEUE_COUNT_THRESHOLD;
            -- GC_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY    : t_alert_level     := C_CMD_QUEUE_COUNT_THRESHOLD_SEVERITY;
            -- GC_RESULT_QUEUE_COUNT_MAX                : natural           := C_RESULT_QUEUE_COUNT_MAX;
            -- GC_RESULT_QUEUE_COUNT_THRESHOLD          : natural           := C_RESULT_QUEUE_COUNT_THRESHOLD;
            -- GC_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY : t_alert_level     := C_RESULT_QUEUE_COUNT_THRESHOLD_SEVERITY
        )
        port map
        (
            gpio_vvc_if => t_dut_output(0 downto 0)  -- : inout std_logic_vector(GC_DATA_WIDTH - 1 downto 0) := GC_DEFAULT_LINE_VALUE
        );

    dut : entity work.my_dut(rtl)
        port map
        (
            i_clk => t_clk,           -- : in    std_logic;
            i_rst => t_rst,           -- : in    std_logic;
            i_val => t_dut_input(0),  -- : in    std_logic;
            o_val => t_dut_output(0)  -- :   out std_logic
        );

    --------------------------------------------------------------
    -- Have to initialize the UVVM.
    --------------------------------------------------------------
    uvvm_engine : entity uvvm_vvc_framework.ti_uvvm_engine(func);

    p_main : process
        variable v_cmd_idx : integer; -- natural;
        --variable v_data    : std_logic_vector(1023 downto 0);
        variable v_data    : std_logic_vector(0 downto 0);
    begin
        -----------------------------------------------------------------
        -- Wait for UVVM initialization complete(If this is not called 
        --  then we will receive the failed to obtain semaphore error).
        -----------------------------------------------------------------
        await_uvvm_initialization(VOID);

        log(ID_LOG_HDR_LARGE, "Starting simulations.", C_SCOPE);

        v_gpio_sb.set_scope("SB GPIO");
        log(ID_LOG_HDR, "Set configuration", C_SCOPE);
        v_gpio_sb.config(C_SB_CONFIG_DEFAULT, "Set config for SB UART");

        log(ID_LOG_HDR, "Enable SBs", C_SCOPE);
        v_gpio_sb.enable(VOID);

        -- Enable log msg for data
        v_gpio_sb.enable_log_msg(ID_DATA);

        start_clock(CLOCK_GENERATOR_VVCT, 1, "Start Clock Generator");

        wait_num_rising_edge(clk => t_clk, num_rising_edge => 10);

        v_data := (0 => '1');

        -------------------------------------------------------------------------------------------
        -- GPIO VCC : Set input value
        -------------------------------------------------------------------------------------------
        gpio_set(GPIO_VVCT, 1, v_data, "SET the GPIO input to a 1", C_SCOPE); -- VCC set
        await_completion(GPIO_VVCT, 1, NA, 1 us, "Wait for the GPIO VVC to set input value to 1");

        wait_num_rising_edge(clk => t_clk, num_rising_edge => 10);

        -------------------------------------------------------------------------------------------
        -- SB : Add expected value from the output
        -------------------------------------------------------------------------------------------
        v_gpio_sb.add_expected(v_data); -- Set Expected Value

        -------------------------------------------------------------------------------------------
        -- GPIO BFM : Set input value (may use BFM because it is easier to understand)
        -------------------------------------------------------------------------------------------
        gpio_get(data_value => v_data, 
                 data_port  => t_dut_output,
                 msg        => "Get the GPIO I/O BFM data"); -- BFM get, just need the v_data value and scoreboard it.

        -------------------------------------------------------------------------------------------
        -- SB : Verify actual vs expected
        -------------------------------------------------------------------------------------------
        v_gpio_sb.check_received(v_data); -- Verify Expected to Actual Value

        -------------------------------------------------------------------------------------------
        -- SB : Make sure the scoreboard is empty (Not sure what this means yet)
        -------------------------------------------------------------------------------------------
        check_value(v_gpio_sb.is_empty(VOID), ERROR, "Check that scoreboard is empty");

        -------------------------------------------------------------------------------------------
        -- SB : Display the scoreboard
        -------------------------------------------------------------------------------------------
        v_gpio_sb.report_counters(VOID);

        std.env.stop;

        wait;
    
    end process p_main;

end func;

