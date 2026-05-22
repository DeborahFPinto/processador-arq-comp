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
		0 => B"0001_000_000000000101", -- A. LD 5 no acumulador
		1 => B"0011_011_000000000000", --    MOV do acumulador para R3
		2 => B"0001_000_000000001000", -- B. LD 8 no acumulador
		3 => B"0011_100_000000000000", --    MOV do acumulador para R4
		4 => B"0001_000_000000000000", -- C. LD 0 no acumulador
        5 => B"0100_100_000000000000", --    ADD Acumulador e R4
        6 => B"0100_011_000000000000", --    ADD acumulador com R3
		7 => B"0011_101_000000000000", --     MOV do acumulador para R5
		8 => B"0001_000_000000000001", -- D. LD 1 no acumulador
		9 => B"0101_101_000000000000", --  SUB Acumulador e R5
        10 => B"0011_101_000000000000", --     MOV do acumulador para R5
        11 => B"0111_000_000000010100", -- E. JUMP para o endereço 20
        12 => B"0001_000_000000000000", -- F. LD 0 no acumulador
        13 => B"0011_101_000000000000", --     MOV para o R5, zerando

        20 => B"0001_000_000000000000", -- G. LD 0 no acumulador
        21 => B"0100_101_000000000000", --    ADD Acumulador e R5
        22 => B"0011_011_000000000000", --    MOV do acumulador para R3
        23 => B"0111_000_000000000100", -- H. JUMP para o endereço 4 -- inicio de C
        24 => B"0001_000_000000000000", -- I. LD 0 no acumulador
        25 => B"0011_101_000000000000", --    MOV para o R5, zerando
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