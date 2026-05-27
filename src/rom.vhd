library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
        clk : in  std_logic;
        endereco : in  unsigned(6 downto 0);
        dado : out unsigned(18 downto 0)
    );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(18 downto 0);

    constant conteudo_rom : mem := (
		0  => B"0001_000_000000000000", -- A. LD 0
        1  => B"0011_011_000000000000", --    MOV R3
        2  => B"0001_000_000000000000", -- B. LD 0
        3  => B"0011_100_000000000000", --    MOV R4
        4  => B"0001_000_000000000000", -- C. LD 0  <- BLS
        5  => B"0100_011_000000000000", --    ADD R3
        6  => B"0100_100_000000000000", --    ADD R4
        7  => B"0011_100_000000000000", --    MOV R4
        8  => B"0001_000_000000000001", -- D. LD 1
        9  => B"0100_011_000000000000", --    ADD R3
        10 => B"0011_011_000000000000", --    MOV R3
        11 => B"0001_000_000000011101", -- E. LD 29
        12 => B"0101_011_000000000000", --    SUB R3 (Flags)
        13 => B"1000_000_000000000100", --    BLS 4 (absoluto)
        14 => B"0001_000_000000000000", -- F. LD 0
        15 => B"0100_100_000000000000", --    ADD R4
        16 => B"0011_101_000000000000", --    MOV R5

    others => (others => '0')          
);

begin
	
	-- síncrona
    process(clk)
    begin
        if rising_edge(clk) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;

end architecture;