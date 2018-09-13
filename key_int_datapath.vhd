
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_int_datapath is

port(
	CLK, rst_n		: in std_logic;
	
	--INPUT
	key				: in std_logic_vector( 255 downto 0);
	key_len			: in std_logic_vector( 1 downto 0);	
	
	--from controller
	sel_key, sel_len, load_key, load_len : in std_logic;
	
	--OUTPUT
	key_len_out		: out std_logic_vector( 1 downto 0);
	key_out			: out std_logic_vector( 255 downto 0)
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


signal keybuff_out, keysel_out	: std_logic_vector( 255 downto 0);
signal lenbuff_out, keylen_out 	: std_logic_vector( 1 downto 0);


begin

-- REGISTERS
	KEY1	: reg generic map(256) port map (CLK => CLK, rst_n => rst_n, load => load_key, D => key, Q => keybuff_out);
	LEN1	: reg generic map(2) port map (CLK => CLK, rst_n => rst_n, load => load_len, D => key_len, Q => lenbuff_out);


-- KEY and LEN
	MUX1	: mux2input generic map (256) port map(sel=> sel_key, I0 => keybuff_out, I1 => key, Y=>keysel_out);
	MUX2	: mux2input generic map (2) port map(sel=> sel_len, I0 => lenbuff_out, I1 => key_len, Y=>keylen_out);
	
	

	key_out <= keybuff_out;
	key_len_out <= lenbuff_out;


end arc;

