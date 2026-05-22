library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_tb is
end entity;

architecture a_uc_tb of uc_tb is

    component uc is
        port(
            clk        : in  std_logic;
            rst        : in  std_logic;
            pc_out     : out unsigned(6 downto 0);
            instr_out  : out unsigned(18 downto 0);
            estado_out : out unsigned(1 downto 0)
        );
    end component;

    -- Sinais de interface
    signal sinal_clk : std_logic := '0';
    signal sinal_rst : std_logic := '1';
    signal sinal_pc  : unsigned(6 downto 0);
    signal sinal_instr : unsigned(18 downto 0);
    signal sinal_estado : unsigned(1 downto 0);

    constant tempo : time := 20 ns;

begin

    uut: uc port map(
        clk        => sinal_clk,
        rst        => sinal_rst,
        pc_out     => sinal_pc,
        instr_out  => sinal_instr,
        estado_out => sinal_estado
    );

    sinal_clk <= not sinal_clk after tempo/2;

    process
    begin
        sinal_rst <= '1';
        wait for 2 * tempo;
        
        sinal_rst <= '0';
        
        wait for 50 * tempo;
        

        wait;
    end process;

end architecture;