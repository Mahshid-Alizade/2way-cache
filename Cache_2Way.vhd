-------------------------------------------------------------------------------
--
-- Title       : Cache_2Way
-- Design      : Cache_2_Way
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : Cache_2Way.vhd
-- Generated   : Mon Jan 31 00:14:22 2022
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {Cache_2Way} architecture {Cache_2Way}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity Cache_2Way is  
	
	generic (
	Offset   	: integer := 2;    
	Index    	: integer := 7;
	AddrWidth	: integer := 12;  
	DataWidth	: integer := 32;
	Tag      	: integer := 3;   
	CacheWidth	: integer := 36;
	Word  		: integer := 4;
	Byte		: integer := 8
	); 	  
	
	port (
	clk: 				in std_logic; 
	memory_addr: 		in std_logic_vector(AddrWidth-1 downto 0);	
	cache_row_one:   	out std_logic_vector(CacheWidth-1 downto 0);
	cache_row_two:   	out std_logic_vector(CacheWidth-1 downto 0);
	cache_output : 		out std_logic_vector(Byte-1 downto 0);
	hit : 				out std_logic 
	);
	
end Cache_2Way;

architecture Cache_2Way of Cache_2Way is

-- define a 2D array of cache
type MyCache is array (2**Index-1 downto 0) of std_logic_vector(CacheWidth-1 downto 0);	 

-- Cache initialization
signal Cache_one: MyCache := (others=>(others=>'0')); 
signal Cache_two: MyCache := (others=>(others=>'0'));

-- Address paarts
signal c_tag: std_logic_vector (Tag-1 downto 0); 
signal c_index: std_logic_vector (Index-1 downto 0);
signal c_offset: integer range 1 to 4 := 2;	 

-- Data
signal cache_data_one_row: std_logic_vector (CacheWidth-1 downto 0);  
signal cache_data_two_row: std_logic_vector (CacheWidth-1 downto 0); 
																		   											  
-- Tag
signal tag_part_one: std_logic_vector (Tag-1 downto 0);  
signal tag_part_two: std_logic_vector (Tag-1 downto 0); 

-- Compare result
signal compare_out_one: std_logic; 
signal compare_out_two: std_logic; 

-- Select
signal select_cache_1: std_logic ;
signal select_cache_2: std_logic ;	

-- Output
signal cache_block_one: std_logic_vector (Byte-1 downto 0);
signal cache_block_two: std_logic_vector (Byte-1 downto 0);


begin		  
	
	-- 3 part of physical address
	c_tag <= memory_addr (AddrWidth-1 downto AddrWidth-Tag); 			-- 11 to 9 
	c_index <= memory_addr (AddrWidth-Tag-1 downto Offset);				-- 8 to 2
	c_offset <= (to_integer(unsigned(memory_addr(1 downto 0)))+1);		-- 1 to 0
	
	-- Selecting the row with "Index" part of address
	cache_data_one_row <= Cache_one(to_integer(unsigned(c_index)));	 	
	cache_data_two_row <= Cache_two(to_integer(unsigned(c_index)));
	
	cache_row_one <= cache_data_one_row; 
	cache_row_two <= cache_data_two_row;	
	
	-- Select the byte with "Offset" part of address(8 bit)
	cache_block_one <= cache_data_one_row(c_offset*8-1 downto c_offset*8-8); 
	cache_block_two <= cache_data_two_row(c_offset*8-1 downto c_offset*8-8);  
	
	-- the bits(3 bits) of tag in the cache	
	tag_part_one <= cache_data_one_row (Tag+DataWidth-1 downto DataWidth);
	tag_part_two <= cache_data_two_row (Tag+DataWidth-1 downto DataWidth);
	
	-- compare 'physical-addr Tag' vs 'cache Tag' 
	Comparator1: entity Comparator(Comparator)
		port map (data_one => c_tag, data_two => tag_part_one, F => compare_out_one);	
		
	Comparator2: entity Comparator(Comparator)
		port map (data_one => c_tag, data_two => tag_part_two, F => compare_out_two);
	 
	-- which cache has a valid data
	select_cache_1 <= compare_out_one and cache_data_one_row(CacheWidth-1); 
	select_cache_2 <= compare_out_two and cache_data_two_row(CacheWidth-1);	
	
	-- if one of the caches has the valid data 
	-- then hit is 1
	process (clk)
	begin	
		if(rising_edge(clk)) then
			hit <= 	select_cache_1 or select_cache_2;
		end if;
	end process;
	
	-- Determining the value of cache output 
	process (clk)
	begin	
		if(rising_edge(clk)) then
			if (select_cache_1 = '1' and select_cache_2 = '0') then 
				cache_output <= cache_block_one;
			
			elsif (select_cache_1 = '0' and select_cache_2 = '1') then
				cache_output <= cache_block_two;
				
			elsif (select_cache_1 = '1' and select_cache_2 = '1') then
				cache_output <= cache_block_one;
				
			else
				cache_output <= (others => 'Z');
				
			end if;
		end if;
	end process;
	
	-- Initializing some cache rows
   	-- cache 1
	Cache_one(0) 		<= "000101010011100001011100101001011010"; --EX2 (unvalid with different Tag)
	Cache_one(1) 		<= "001000100101101010101001001010001010";
	Cache_one(2)	 	<= "010100111011010110110001110000001110";
	Cache_one(3)	 	<= "011100101111100001010101010111110001"; 
	Cache_one(4)	 	<= "010100011101011010101010110101011110"; 
	Cache_one(5)	 	<= "011001010000001100000111111100011010"; 	
	Cache_one(6) 		<= "101001000100110011010101010110101000";	
	Cache_one(7) 		<= "110010110100111111111010110010101101"; 
	Cache_one(8)	 	<= "001010010101111101110101011001010011";
	Cache_one(9)	 	<= "011111110000011111101110000110110101"; --Ex3 (unvalid with the same Tag)
	Cache_one(10)	 	<= "111111111001110111010101000101101011"; 
	Cache_one(11)	 	<= "111100111101101110000111010101101111"; 
	Cache_one(12)	 	<= "101010001011011010110101101101010011"; 
	Cache_one(13)	 	<= "011101100000110001101101010101111100"; 
	Cache_one(14)	 	<= "111001010110101100111010001101010101"; 
	Cache_one(15)	 	<= "111110010101010100111010101000110001"; --Ex4 (valid with the same Tag)
	Cache_one(16)	 	<= "111111001110111000010101100010101001"; 
	Cache_one(17)	 	<= "100111011100001111101000010110010111"; 
	Cache_one(18)	 	<= "101011110010100110011010100011100111"; 
	Cache_one(19)	 	<= "110011101110000111100010101010001011"; 
	Cache_one(20)	 	<= "110011101110111111000101010001010100"; 
	Cache_one(21)	 	<= "101011101110111111111000101101100001"; --EX1 (valid with the same Tag)
																		  
	-- cache 2																	
	Cache_two(0) 		<= "000101010011100001011100101001011010"; --EX2 (unvalid with a different Tag)
	Cache_two(1) 		<= "001000100101101010101001001010001010";
	Cache_two(2)	 	<= "010100111011010110110001110000001110";
	Cache_two(3)	 	<= "011100101111100001010101010111110001"; 
	Cache_two(4)	 	<= "010100011101011010101010110101011110"; 
	Cache_two(5)	 	<= "011001010000001100000111111100011010"; 	
	Cache_two(6) 		<= "101001000100110011010101010110101000";	
	Cache_two(7) 		<= "110010110100111111111010110010101101"; 
	Cache_two(8)	 	<= "001010010101111101110101011001010011";
	Cache_two(9)	 	<= "111111110000011111101110000110110101"; --Ex3 (valid with the same Tag)	
	Cache_two(10)	 	<= "111111111001110111010101000101101011"; 
	Cache_two(11)	 	<= "111100111101101110000111010101101111"; 
	Cache_two(12)	 	<= "101010001011011010110101101101010011"; 
	Cache_two(13)	 	<= "011101100000110001101101010101111100"; 
	Cache_two(14)	 	<= "111001010110101100111010001101010101"; 
	Cache_two(15)	 	<= "111110010101010100111010101000110001"; --Ex4 (valid with the same Tag)
	Cache_two(16)	 	<= "111111001110111000010101100010101001"; 
	Cache_two(17)	 	<= "100111011100001111101000010110010111"; 
	Cache_two(18)	 	<= "101011110010100110011010100011100111"; 
	Cache_two(19)	 	<= "110011101110000111100010101010001011"; 
	Cache_two(20)	 	<= "110011101110111111000101010001010100"; 
	Cache_two(21)	 	<= "111011101110111111111000101101100001"; --EX1 (valid but with a different Tag)	  
	
end Cache_2Way;
