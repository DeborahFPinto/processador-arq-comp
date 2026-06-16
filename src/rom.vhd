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
		-- Inicializar
        0  => B"0001_000_000000100000", -- LD 32  - Carregar o limite
        1  => B"0011_010_000000000000", -- MOV R2 - Salvar o limite em R2 
        2  => B"0001_000_000000000001", -- LD 1   - Carrega o valor inicial 1 no Acc
        3  => B"0011_001_000000000000", -- MOV R1 - Inicializa o ponteiro i em R1 (R1 = 1)

        -- Escrever RAM[i] = i
        4  => B"0001_000_000000000000", -- LD 0
        5  => B"0100_001_000000000000", -- ADD R1 - colocar valor de R1 no Acc
        6  => B"1011_001_000000000000", -- SW R1  - salva valor do ACUMULADOR na RAM[R1]
        7  => B"0110_000_000000000001", -- ADDI 1 - Acc++
        8  => B"0011_001_000000000000", -- MOV R1
        9  => B"0101_010_000000000000", -- SUB R2 - Acc = Acc - R2 (pro salto)
        10 => B"1000_000_000000000100", -- BLS 4  - se menor que 32, vai pra 4 (salto condicional absoluto)

        -- Preparação Loop 2
        11 => B"0001_000_000000000010", -- LD 2   - primeiro endereço par (2) no Acc
        12 => B"0011_001_000000000000", -- MOV R1

        -- Loop 2 RAM[i] = 0 para i par
        13 => B"0001_000_000000000000", -- LD 0
        14 => B"1011_001_000000000000", -- SW R1  - RAM[R1] = 0, R1 par
        15 => B"0001_000_000000000000", -- LD 0
        16 => B"0100_001_000000000000", -- ADD R1 - colocar valor de R1 no Acc
        17 => B"0110_000_000000000010", -- ADDI 2 - Acc = Acc + 2 
        18 => B"0011_001_000000000000", -- MOV R1
        19 => B"0101_010_000000000000", -- SUB R2 - Acc = Acc - R2 (pro salto)
        20 => B"1000_000_000000001101", -- BLS 13 - se menor que 32, vai pra 13

        -- Preparação Loop 3
        21 => B"0001_000_000000000110", -- LD 3  - primeiro endereço múltiplo de 3 (6) no Acc
        22 => B"0011_001_000000000000", -- MOV R1

        -- Loop 3 RAM[i] = 0 para i múltiplo de 3
        23 => B"0001_000_000000000000", -- LD 0
        24 => B"1011_001_000000000000", -- SW R1  - RAM[R1] = 0, R1 múltiplo de 3
        25 => B"0001_000_000000000000", -- LD 0
        26 => B"0100_001_000000000000", -- ADD R1 - colocar valor de R1 no Acc
        27 => B"0110_000_000000000011", -- ADDI 3 - Acc = Acc + 3 
        28 => B"0011_001_000000000000", -- MOV R1
        29 => B"0101_010_000000000000", -- SUB R2 - Acc = R2 - Acc (pro salto)
        30 => B"1000_000_000000010111", -- BLS 23 - se menor que 32, vai pra 23

        -- Preparação Loop 5
        31 => B"0001_000_000000001010", -- LD 5  - primeiro endereço múltiplo de 5 (10) no Acc
        32 => B"0011_001_000000000000", -- MOV R1

        -- Loop 5 RAM[i] = 0 para i múltiplo de 5
        33 => B"0001_000_000000000000", -- LD 0
        34 => B"1011_001_000000000000", -- SW R1  - RAM[R1] = 0, R1 múltiplo de 5
        35 => B"0001_000_000000000000", -- LD 0
        36 => B"0100_001_000000000000", -- ADD R1 - colocar valor de R1 no Acc
        37 => B"0110_000_000000000101", -- ADDI 5 - Acc = Acc + 5 
        38 => B"0011_001_000000000000", -- MOV R1
        39 => B"0101_010_000000000000", -- SUB R2 - Acc = R2 - Acc (pro salto)
        40 => B"1000_000_000000100001", -- BLS 33 - se menor que 32, vai pra 33

        -- Preparação Exibição
        41 => B"0001_000_000000000001", -- LD 1
        42 => B"0011_001_000000000000", -- MOV R1

        -- Exibição
        43 => B"1010_001_000000000000", -- LW R1
        44 => B"0011_100_000000000000", -- MOV R4 - coloca da memória no R4 p/ visualizar
        45 => B"0001_000_000000000000", -- LD 0
        46 => B"0100_001_000000000000", -- ADD R1 
        47 => B"0110_000_000000000001", -- ADDI 1 - Acc++
        48 => B"0011_001_000000000000", -- MOV R1     
        49 => B"0101_010_000000000000", -- SUB R2     
        50 => B"1000_000_000000101011", -- BLS 43 - se menor que 32, vai pra 43

        -- fim
        51 => B"0111_000_000000000000", -- JMP 0      -> Salto Incondicional Relativo com offset 0 (Trava aqui)
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