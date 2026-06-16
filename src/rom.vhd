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
		-- == INICIALIZAÇÃO GERAL ==
        0  => B"0001_000_000000100000", -- LD R0, 32  -> Carrega o limite 32 no Acc
        1  => B"0011_010_000000000000", -- MOV R2     -> Salva o limite em R2 (R2 = 32)
        2  => B"0001_000_000000000001", -- LD R0, 1   -> Carrega o valor inicial 1 no Acc
        3  => B"0011_001_000000000000", -- MOV R1     -> Inicializa o ponteiro i em R1 (R1 = 1)

        -- == LOOP 1: Escrita RAM[i] = i (posições 1 a 32) ==
        4  => B"0001_000_000000000000", -- LD R0, 0   -> Limpa o Acc (Início do Loop 1)
        5  => B"0100_001_000000000000", -- ADD R1     -> Acc = 0 + R1 (Traz o ponteiro 'i' para o Acc)
        6  => B"1011_001_000000000000", -- ST_RAM R1  -> RAM[R1] = Acc (Escreve o valor de 'i' no endereço 'i')
        7  => B"0110_000_000000000001", -- ADDI R0, 1 -> Acc = Acc + 1 (Incrementa o valor)
        8  => B"0011_001_000000000000", -- MOV R1     -> Atualiza o ponteiro R1 (R1 = i + 1)
        9  => B"0101_010_000000000000", -- SUB R2     -> Acc = R2 - Acc (Compara 32 com o novo i)
        10 => B"1000_000_000000000100", -- BLS 4      -> Salto se i <= 32 (Volta para endereço 4)

        -- == PREPARAÇÃO PARA O LOOP 2 (PARES) ==
        11 => B"0001_000_000000000010", -- LD R0, 2   -> Carrega o primeiro endereço par (2) no Acc
        12 => B"0011_001_000000000000", -- MOV R1     -> Inicializa o ponteiro de pares em R1 (R1 = 2)

        -- == LOOP 2: Substitui conteúdo dos endereços pares por 0 ==
        13 => B"0001_000_000000000000", -- LD R0, 0   -> Coloca o valor 0 no Acc (Início do Loop 2)
        14 => B"1011_001_000000000000", -- ST_RAM R1  -> RAM[R1] = Acc (Escreve 0 na posição par atual)
        15 => B"0001_000_000000000000", -- LD R0, 0   -> Limpa o Acc para recuperar o ponteiro
        16 => B"0100_001_000000000000", -- ADD R1     -> Acc = 0 + R1 (Traz o ponteiro de volta ao Acc)
        17 => B"0110_000_000000000010", -- ADDI R0, 2 -> Acc = Acc + 2 (Incrementa de 2 em 2 para o próximo par!)
        18 => B"0011_001_000000000000", -- MOV R1     -> Atualiza o ponteiro em R1 (R1 = R1 + 2)
        19 => B"0101_010_000000000000", -- SUB R2     -> Acc = R2 - Acc (Compara 32 com o novo ponteiro)
        20 => B"1000_000_000000001101", -- BLS 13     -> Salto se i <= 32 (Volta para endereço 13)

        -- == PREPARAÇÃO PARA O LOOP 3 (EXIBIÇÃO) ==
        21 => B"0001_000_000000000001", -- LD R0, 1   -> Carrega 1 no Acc
        22 => B"0011_001_000000000000", -- MOV R1     -> Reinicializa o ponteiro em R1 para ler tudo (R1 = 1)

        -- == LOOP 3: Leitura completa da RAM (1 a 32) e exibição em R4 ==
        23 => B"1010_001_000000000000", -- LD_RAM R1  -> Acc = RAM[R1] (Lê o dado da RAM, Início do Loop 3)
        24 => B"0011_100_000000000000", -- MOV R4     -> R4 = Acc (Salva o dado lido em R4 para podermos ver!)
        25 => B"0001_000_000000000000", -- LD R0, 0   -> Limpa o Acc para recuperar o ponteiro
        26 => B"0100_001_000000000000", -- ADD R1     -> Acc = 0 + R1 (Traz o ponteiro de volta ao Acc)
        27 => B"0110_000_000000000001", -- ADDI R0, 1 -> Acc = Acc + 1 (Incrementa de 1 em 1)
        28 => B"0011_001_000000000000", -- MOV R1     -> Atualiza o ponteiro em R1
        29 => B"0101_010_000000000000", -- SUB R2     -> Acc = R2 - Acc (Compara 32 com o novo ponteiro)
        30 => B"1000_000_000000010111", -- BLS 23     -> Salto se i <= 32 (Volta para endereço 23)

        -- == FIM DO PROGRAMA ==
        31 => B"0111_000_000000000000", -- JMP 0      -> Salto Incondicional Relativo com offset 0 (Trava aqui)
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