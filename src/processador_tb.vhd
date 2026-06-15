library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    component processador is 
        port(
            clk, rst : in std_logic;
            constante_externa : in unsigned(15 downto 0);
            saida : out unsigned(15 downto 0);
            flag_z, flag_n, flag_c : out std_logic 
        );
    end component;

    -- sinais
    signal clk, rst : std_logic := '0';
    signal constante_externa : unsigned(15 downto 0) := (others => '0');
    signal monitor : unsigned(15 downto 0);
    signal fz, fn, fc : std_logic;
    signal finished : std_logic := '0';

begin

    uut: processador port map (
        clk => clk, 
        rst => rst, 
        constante_externa => constante_externa,
        saida => monitor,
        flag_z => fz, 
        flag_n => fn, 
        flag_c => fc
    );

    -- clk; T = 100ns
    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0'; wait for 50 ns;
            clk <= '1'; wait for 50 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for 200 ns;
        rst <= '0';
        
        wait for 200000 ns; 

        finished <= '1';
        wait;
    end process;
end architecture;