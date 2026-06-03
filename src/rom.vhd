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
		0  => B"0001_001_000000001111", -- LD R1, 15
        1  => B"0011_001_000000000000", -- MOV A -> R1
        2  => B"0001_000_000010101010", -- LD R0, 170
        3  => B"1011_001_000000000000", -- SW R1
        4  => B"0001_010_000001010000", -- LD R2, 80
        5  => B"0011_010_000000000000", -- MOV A -> R2
        6  => B"0001_000_010101010101", -- LD R0, 21845
        7  => B"1011_010_000000000000", -- SW R2    
        8  => B"0001_000_000000000000", -- LD R0, 0
        9  => B"0110_000_000011111111", -- ADDI R0, 255    
        10 => B"1010_010_000000000000", -- LW R2
        11 => B"1010_001_000000000000", -- LW R1
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