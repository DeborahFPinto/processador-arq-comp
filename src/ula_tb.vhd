library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
    component ula
        port (
            entrada_a : in  unsigned(15 downto 0);
            entrada_b : in  unsigned(15 downto 0);
            selec_op  : in  unsigned(1 downto 0);
            saida     : out unsigned(15 downto 0);
            flag_c    : out std_logic;
            flag_z    : out std_logic;
            flag_n    : out std_logic
        );
    end component;

    signal a, b, res : unsigned(15 downto 0);
    signal sel       : unsigned(1 downto 0);
    signal c, z, n   : std_logic;

begin
    uut: ula port map(entrada_a => a, entrada_b => b, selec_op => sel, saida => res, flag_c => c, flag_z => z, flag_n => n);

    process
    begin
        -- 10 + 5 = 15
        a <= x"000A"; b <= x"0005"; sel <= "00"; wait for 50 ns;

        -- FFFF + 1 = 0000 -> C=1, Z=1
        a <= x"FFFF"; b <= x"0001"; sel <= "00"; wait for 50 ns;

        -- 20 - 10 = 10
        a <= x"0014"; b <= x"000A"; sel <= "01"; wait for 50 ns;

        -- 15 - 15 = 0 -> Z=1
        a <= x"000F"; b <= x"000F"; sel <= "01"; wait for 50 ns;

        -- 5 - 10 = -5 -> N=1 (BMI)
        a <= x"0005"; b <= x"000A"; sel <= "01"; wait for 50 ns;

        -- 2 - 5 -> C=1 (borrow)
        a <= x"0002"; b <= x"0005"; sel <= "01"; wait for 50 ns;

        --F0F0 AND AAAA = A0A0
        a <= x"F0F0"; b <= x"AAAA"; sel <= "10"; wait for 50 ns;

        -- F0F0 AND 0F0F = 0000 -> Z=1
        a <= x"F0F0"; b <= x"0F0F"; sel <= "10"; wait for 50 ns;

        -- F0F0 OR 0F0F = FFFF -> N=1 (MSB é 1)
        a <= x"F0F0"; b <= x"0F0F"; sel <= "11"; wait for 50 ns;

        -- -1 + -1 = -2
        a <= x"FFFF"; b <= x"FFFF"; sel <= "00"; wait for 50 ns;

        wait;
    end process;
end architecture;