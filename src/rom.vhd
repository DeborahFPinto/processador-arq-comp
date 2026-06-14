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
		0 => B"0001_000_000000001111", -- LD 15
        1 => B"0011_001_000000000000", -- MOV R1
        2 => B"0001_000_000010101010", -- LD 170
        3 => B"0011_000_000000000000", -- MOV R0
        4 => B"1011_001_000000000000", -- SW R1 (O que está no acumulador vai para o endereço do R1)
        5 => B"0001_000_000001010000", -- LD 80
        6 => B"0011_010_000000000000", -- MOV R2
        7 => B"0001_000_010101010101", -- LD 1365
        8 => B"0011_011_000000000000", -- MOV R3
        9 => B"1011_010_000000000000", -- SW R2 (O que está no acumulador vai para o endereço do R2)
        10 => B"0001_000_000000000000", -- LD 0
        11 => B"0110_000_000011111111", -- ADDI 255
        12 => B"1010_010_000000000000", -- LW R2 (O que está no endereço do R2 vai para o acumulador)
        13 => B"1010_001_000000000000", -- LW R1 (O que está no endereço do R1 vai para o acumulador)
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