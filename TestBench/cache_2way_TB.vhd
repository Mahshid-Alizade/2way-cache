library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity cache_2way_test is
	-- Generic declarations of the tested unit
		generic(
		Offset : INTEGER := 2;
		Index : INTEGER := 7;
		AddrWidth : INTEGER := 12;
		DataWidth : INTEGER := 32;
		Tag : INTEGER := 3;
		CacheWidth : INTEGER := 36;
		Word : INTEGER := 4;
		Byte : INTEGER := 8 );
end cache_2way_test;

architecture TB_ARCHITECTURE of cache_2way_test is
	-- Component declaration of the tested unit
	component cache_2way
		generic(
		Offset : INTEGER := 2;
		Index : INTEGER := 7;
		AddrWidth : INTEGER := 12;
		DataWidth : INTEGER := 32;
		Tag : INTEGER := 3;
		CacheWidth : INTEGER := 36;
		Word : INTEGER := 4;
		Byte : INTEGER := 8 );
	port(
		clk : in STD_LOGIC;
		memory_addr : in STD_LOGIC_VECTOR(AddrWidth-1 downto 0);
		cache_row_one : out STD_LOGIC_VECTOR(CacheWidth-1 downto 0);
		cache_row_two : out STD_LOGIC_VECTOR(CacheWidth-1 downto 0);
		cache_output : out STD_LOGIC_VECTOR(Byte-1 downto 0);
		hit : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal memory_addr : STD_LOGIC_VECTOR(AddrWidth-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal cache_row_one : STD_LOGIC_VECTOR(CacheWidth-1 downto 0);
	signal cache_row_two : STD_LOGIC_VECTOR(CacheWidth-1 downto 0);
	signal cache_output : STD_LOGIC_VECTOR(Byte-1 downto 0);
	signal hit : STD_LOGIC;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : cache_2way
		generic map (
			Offset => Offset,
			Index => Index,
			AddrWidth => AddrWidth,
			DataWidth => DataWidth,
			Tag => Tag,
			CacheWidth => CacheWidth,
			Word => Word,
			Byte => Byte
		)

		port map (
			clk => clk,
			memory_addr => memory_addr,
			cache_row_one => cache_row_one,
			cache_row_two => cache_row_two,
			cache_output => cache_output,
			hit => hit
		);

	process
	begin
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <='1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';   
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <='1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT FOR 5 NS;
		clk <= '0';
		WAIT FOR 5 NS;
		clk <= '1';
		WAIT;
	end process;
	
	addr: memory_addr <= "010001010101" after 10ns,	--Ex1
				   		 "010000000010" after 30ns, --EX2
				   		 "111000100111" after 50ns, --Ex3 
				   		 "111000111111" after 70ns; --Ex4

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_cache_2way of cache_2way_test is
	for TB_ARCHITECTURE
		for UUT : cache_2way
			use entity work.cache_2way(cache_2way);
		end for;
	end for;
end TESTBENCH_FOR_cache_2way;

