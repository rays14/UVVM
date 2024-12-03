-- Basic UVVM testbench taken from below:
--      https://uvvm.github.io/uvvm_getting_started.html

library uvvm_util;
    context uvvm_util.uvvm_util_context;
library uvvm_vvc_framework;
    use uvvm_vvc_framework.ti_vvc_framework_support_pkg.all;
library bitvis_vip_sbi;
    context bitvis_vip_sbi.vvc_context;

entity uvvm_tb is
end entity uvvm_tb;

architecture func of uvvm_tb is
begin
    p_main : process
    begin
        log("Starting simulation ... ");

        std.env.stop;
        wait;
    end process p_main;
end func;

