--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:38:23 09/17/2018
-- Design Name:   
-- Module Name:   D:/Repository/XILINX/keygen/ttb.vhd
-- Project Name:  keygen
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: key_generator
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ttb IS
END ttb;
 
ARCHITECTURE behavior OF ttb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT key_generator
		port(
			CLK, rst_n 		: in std_logic;
		--	key 				: in std_logic_vector (255 downto 0);
			key_len 			: in std_logic_vector (1 downto 0); 
			ROUND 			: in std_logic_vector (3 downto 0);
			enc 				: in std_logic;
			valid_out 		: out std_logic;
			data_out			: out std_logic_vector (127 downto 0)
		);
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal key_len : std_logic_vector(1 downto 0) := (others => '0');
   signal ROUND : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal valid_out : std_logic;
   signal data_out : std_logic_vector(127 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: key_generator PORT MAP (
          CLK => CLK,
          rst_n => rst_n,
          key_len => key_len,
          ROUND => ROUND,
          valid_out => valid_out,
          data_out => data_out,
			 enc=>'1'
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
     wait for 100 ns;	

      wait for CLK_period*10;
		rst_n <= '1';
		ROUND <= "0000";
		
		wait for 200 ns;	
		ROUND <= "0001";
		wait for 60 ns;	
		ROUND <= "0010";
		
		wait for 60 ns;	
		ROUND <= "0011";
		wait for 60 ns;	
		ROUND <= "0100";
		wait for 60 ns;	
		ROUND <= "0101";
		wait for 60 ns;	
		ROUND <= "0110";
		wait for 60 ns;	
		ROUND <= "0111";
		wait for 60 ns;	
		ROUND <= "1000";
		wait for 60 ns;	
		ROUND <= "1001";
		wait for 60 ns;	
		ROUND <= "1010";
      -- insert stimulus here 
      wait;
   end process;

END;
