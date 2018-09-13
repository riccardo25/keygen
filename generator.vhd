library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity generator is
port(
	CLK, rst_n : in std_logic;
	
	-- INPUT
	--key : in std_logic_vector (255 downto 0);
	key_len : in std_logic_vector (1 downto 0); 
	ROUND : in std_logic_vector (3 downto 0);
	
	valid : out std_logic;
	w0_new: out std_logic_vector (31 downto 0);
	-- OUTPUT
	curr_round : out std_logic_vector (3 downto 0);
	dataround: out std_logic_vector (127 downto 0)
);

end generator;

architecture arc of generator is

--COMPONENTS
	component gen_datapath is
	port(
		CLK, rst_n : in std_logic;
		key : in std_logic_vector (255 downto 0);
		key_len : in std_logic_vector (1 downto 0); 
		ROUND : in std_logic_vector (3 downto 0);
		sel_curr, sel_s, sel_t5, sel_t7, sel_w6, sel_w7 : in std_logic;
		sel_rotWord,sel_dataround, sel_t4, sel_t6, sel_w0, sel_w1, sel_w2, sel_w3, sel_w4, sel_w5 : in std_logic_vector (1 downto 0);
		load_curr : in std_logic;
		load_w0, load_w1, load_w2, load_w3, load_w4, load_w5, load_w6, load_w7 : in std_logic;
		w0, w1, w2, w3, w4, w5, w6, w7 	: out std_logic_vector (31 downto 0);
		curr_round : out std_logic_vector (3 downto 0);
		dataround: out std_logic_vector (127 downto 0)
	);
	end component;
	
	component gen_control is
		port(
			CLK, rst_n : in std_logic;
			key 										: in std_logic_vector (255 downto 0);
			key_len 									: in std_logic_vector (1 downto 0); 
			ROUND 									: in std_logic_vector (3 downto 0);
			w0, w1, w2, w3, w4, w5, w6, w7 	: in std_logic_vector (31 downto 0);
			curr_round 								: in std_logic_vector (3 downto 0);
			valid 									: out std_logic;
			load_curr,
			sel_curr, sel_s, sel_t5, 
			sel_t7, sel_w6, sel_w7 				: out std_logic;
			sel_rotWord, sel_dataround, 
			sel_t4, sel_t6, sel_w0, sel_w1, 
			sel_w2, sel_w3, sel_w4, sel_w5 	: out std_logic_vector (1 downto 0);
			load_w0, load_w1, load_w2, 
			load_w3, load_w4, load_w5, 
			load_w6, load_w7 						: out std_logic
		);
	end component;


--SIGNALS

	signal key 	: std_logic_vector (255 downto 0) := X"00000000000000000000000000000000" & X"09cf4f3c" & X"abf71588" & X"28aed2a6"& X"2b7e1516";

	signal 	sel_curr, sel_s, sel_t5, sel_t7, sel_w6, sel_w7 		: std_logic;
	signal 	sel_rotWord,sel_dataround, sel_t4, sel_t6, sel_w0, 
				sel_w1, sel_w2, sel_w3, sel_w4, sel_w5 					: std_logic_vector (1 downto 0);
	signal 	load_curr, load_w0, load_w1, load_w2, load_w3, 
				load_w4, load_w5, load_w6, load_w7 							: std_logic;
	signal 	w0, w1, w2, w3, w4, w5, w6, w7 								: std_logic_vector (31 downto 0);
	signal 	curr_round_signal 												: std_logic_vector (3 downto 0);
	
begin

	DATPATH1	: gen_datapath port map(CLK => CLK, rst_n => rst_n,
		key => key , key_len => key_len, ROUND => ROUND,
		w0 => w0, w1 => w1, w2 => w2, w3 => w3, w4 => w4, w5 => w5, w6 => w6, w7 => w7,
		curr_round => curr_round_signal, sel_curr => sel_curr, sel_s => sel_s,
		sel_t4 => sel_t4, sel_t5 => sel_t5, sel_t6 => sel_t6, sel_t7 => sel_t7, 
		sel_rotWord => sel_rotWord, sel_dataround =>sel_dataround, 
		sel_w0 => sel_w0, sel_w1 => sel_w1, sel_w2 => sel_w2, sel_w3 => sel_w3, 
		sel_w4 => sel_w4, sel_w5 => sel_w5, sel_w6 => sel_w6, sel_w7 => sel_w7,
		load_curr => load_curr,
		load_w0 => load_w0, load_w1 => load_w1, load_w2 => load_w2, load_w3 => load_w3, 
		load_w4 => load_w4, load_w5 => load_w5, load_w6 => load_w6, load_w7 => load_w7,
		dataround => dataround);
	
	CTRLUNIT1 : gen_control port map(CLK => CLK, rst_n => rst_n,
		key => key , key_len => key_len, ROUND => ROUND,
		w0 => w0, w1 => w1, w2 => w2, w3 => w3, w4 => w4, w5 => w5, w6 => w6, w7 => w7,
		curr_round => curr_round_signal, sel_curr => sel_curr, sel_s => sel_s,
		sel_t4 => sel_t4, sel_t5 => sel_t5, sel_t6 => sel_t6, sel_t7 => sel_t7, 
		sel_rotWord => sel_rotWord, sel_dataround =>sel_dataround, 
		sel_w0 => sel_w0, sel_w1 => sel_w1, sel_w2 => sel_w2, sel_w3 => sel_w3, 
		sel_w4 => sel_w4, sel_w5 => sel_w5, sel_w6 => sel_w6, sel_w7 => sel_w7,
		load_curr => load_curr,
		load_w0 => load_w0, load_w1 => load_w1, load_w2 => load_w2, load_w3 => load_w3, 
		load_w4 => load_w4, load_w5 => load_w5, load_w6 => load_w6, load_w7 => load_w7, valid => valid);


	curr_round <= curr_round_signal;
	w0_new <= w0;
	
end arc;

