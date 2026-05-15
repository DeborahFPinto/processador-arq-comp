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
		0 => "0000" & "000000000000000", 
		1 => "0000" & "000000000000000",
		2 => "1111" & "000000000000011", -- (2+1)+3 = 6
		3 => "0000" & "000000000000000", -- é para pular
		4 => "0000" & "000000000000000", -- é para pular
		5 => "0000" & "000000000000000", -- é para pular na ida, e passar na volta
		6 => "0000" & "000000000000000",
		7 => "1111" & "111111111111101", -- volta
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