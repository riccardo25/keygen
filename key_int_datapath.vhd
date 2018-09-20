
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity key_int_datapath is

	port(
		CLK, rst_n				: in std_logic;
		
		--INPUT
		key						: in std_logic_vector( 255 downto 0);
		key_len					: in std_logic_vector( 1 downto 0);	
		enc						: in std_logic;
		ROUND						: in std_logic_vector( 3 downto 0);	
		R0in, R1in, R2in, R3in, R4in, 
		R5in, R6in, R7in, R8in, R9in, 
		R10in, R11in, R12in, R13in, R14in	: in std_logic_vector(128 downto 0);
		
		--from controller
		load_key, load_len 	: in std_logic;
		sel_round				: in std_logic_vector( 1 downto 0);
		load_thisround			: in std_logic;
		sel_dataout				: in std_logic;
		load_dataout			: in std_logic;
		
		--OUTPUT
		THISROUND				: out std_logic_vector( 3 downto 0);
		DATAOUT					: out std_logic_vector( 128 downto 0);
		key_len_out				: out std_logic_vector( 1 downto 0);
		enc_out					: out std_logic;
		key_out					: out std_logic_vector( 255 downto 0)
	);
end key_int_datapath;

architecture arc of key_int_datapath is


	component reg is
		generic( N : integer);
		port (
			CLK, rst_n : in std_logic;
			load : in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
		);
	end component;

	component mux2input is
		generic (N:integer);
		port (
			sel : in std_logic;
			I0 : in std_logic_vector(N-1 downto 0);
			I1 : in std_logic_vector(N-1 downto 0);
			Y : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component mux3input is
		generic (N:integer);
		port (
			sel : in std_logic_vector(1 downto 0);
			I0 : in std_logic_vector(N-1 downto 0);
			I1 : in std_logic_vector(N-1 downto 0);
			I2 : in std_logic_vector(N-1 downto 0);
			Y : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component adder2input is
		generic (N: integer);
		port (
			I0 : in std_logic_vector(N-1 downto 0);
			I1 : in std_logic_vector(N-1 downto 0);
			Y : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component sub2input is
		generic (N: integer);
		port (
			I0 : in std_logic_vector(N-1 downto 0);
			I1 : in std_logic_vector(N-1 downto 0);
			Y : out std_logic_vector(N-1 downto 0)
		);
	end component;


	signal 	keybuff_out					: std_logic_vector( 255 downto 0);
	signal 	lenbuff_out 				: std_logic_vector( 1 downto 0);
	signal 	thisround_out, plus1, 
				minus1, roundsel_out		: std_logic_vector( 3 downto 0);	
	signal 	dataR, nextdata_out, 
				datasel						: std_logic_vector( 128 downto 0);	

begin

-- REGISTERS
	KEY1	: reg generic map(256) port map (CLK => CLK, rst_n => rst_n, load => load_key, D => key, Q => keybuff_out);
	LEN1	: reg generic map(2) port map (CLK => CLK, rst_n => rst_n, load => load_len, D => key_len, Q => lenbuff_out);
	
	-- and enc
	enc_out <= '0'	when rst_n='0' else enc when rising_edge(CLK) and load_key='1';
	key_out <= keybuff_out;
	key_len_out <= lenbuff_out;

	THISR	: reg generic map(4) port map (CLK => CLK, rst_n => rst_n, load => load_thisround, D => ROUND, Q => thisround_out);
	NEXTD	: reg generic map(129) port map (CLK => CLK, rst_n => rst_n, load => '1', D => dataR, Q => nextdata_out);
	DATAO	: reg generic map(129) port map (CLK => CLK, rst_n => rst_n, load => load_dataout, D => datasel, Q => DATAOUT);
	
--NEXTDATA

	ADD1 	: adder2input 	generic map(4) port map (I0 => thisround_out, I1 => "0001", Y => plus1);
	SUB1 	: sub2input 	generic map(4) port map (I0 => thisround_out, I1 => "0001", Y => minus1);
	
	MUX1	: mux3input		generic map(4) port map (sel => sel_round, I0=>ROUND, I1 => plus1, I2=> minus1, Y=>roundsel_out);
	
	dataR <= R0in  when roundsel_out = "0000" else
				R1in  when roundsel_out = "0001" else
				R2in  when roundsel_out = "0010" else
				R3in  when roundsel_out = "0011" else
				R4in  when roundsel_out = "0100" else
				R5in  when roundsel_out = "0101" else
				R6in  when roundsel_out = "0110" else
				R7in  when roundsel_out = "0111" else
				R8in  when roundsel_out = "1000" else
				R9in  when roundsel_out = "1001" else
				R10in when roundsel_out = "1010" else 
				R11in when roundsel_out = "1011" else 
				R12in when roundsel_out = "1100" else 
				R13in when roundsel_out = "1101" else 
				R14in when roundsel_out = "1110" else
				R0in;
--DATAOUT

	MUX2	: mux2input		generic map(129) port map (sel => sel_dataout, I0=>dataR, I1 => nextdata_out, Y=>datasel);
	
	THISROUND <= thisround_out;
	
end arc;

