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
		-- Teste LD e MOV
        0  => B"0001_000_000000101010", -- LD 42
        1  => B"0011_011_000000000000", -- MOV R3
        2  => B"0001_000_000001100011", -- LD 99
        3  => B"0011_100_000000000000", -- MOV R4
        4  => B"0001_000_000000000101", -- LD 5
        5  => B"0011_001_000000000000", -- MOV R1
        6  => B"0001_000_000000010110", -- LD 22
        7  => B"0011_010_000000000000", -- MOV R2
        8  => B"0000_000_000000000000", -- NOP       

        -- Teste ADD e SW
        9  => B"0001_000_000000000000", -- LD 0
        10 => B"0100_011_000000000000", -- ADD R3
        11 => B"1011_001_000000000000", -- SW R1 - RAM[5] = 42
        12 => B"0001_000_000000000000", -- LD 0
        13 => B"0100_100_000000000000", -- ADD R4  
        14 => B"1011_010_000000000000", -- SW R2 - RAM[22] = 99

        -- Teste ADDI e SUB
        15 => B"0001_000_000000001010", -- LD 10
        16 => B"0110_000_000000000101", -- ADDI 5
        17 => B"0101_011_000000000000", -- SUB R3

        -- Teste BMI
        18 => B"0001_000_000000000101", -- LD 5
        19 => B"0101_100_000000000000", -- SUB R4
        20 => B"1001_000_000000010111", -- BMI 23 - pula p/23 se n = 1
        21 => B"0000_000_000000000000", -- NOP
        22 => B"0000_000_000000000000", -- NOP

        -- Teste JMP
        23 => B"0111_000_000000000010", -- JMP 2 - relativo
        24 => B"0000_000_000000000000", -- NOP
        25 => B"0000_000_000000000000", -- NOP

        -- Teste LW
        26 => B"1010_001_000000000000", -- LW R1
        27 => B"0011_000_000000000000", -- MOV R0
        28 => B"1010_010_000000000000", -- LW R2 
        29 => B"0011_100_000000000000", -- MOV R4

        -- Teste BLS
        30 => B"0001_000_000000000101", -- LD 5
        31 => B"0101_001_000000000000", -- SUB R1  
        32 => B"1000_000_000000100011", -- BLS 35
        33 => B"0000_000_000000000000", -- NOP
        34 => B"0000_000_000000000000", -- NOP

        35 => B"0111_000_000000000000",
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