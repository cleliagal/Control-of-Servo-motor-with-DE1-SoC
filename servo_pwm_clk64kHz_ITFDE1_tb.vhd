library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--Test Bench Application


ENTITY servo_pwm_clk64kHz_ITFDE1_tb IS
END servo_pwm_clk64kHz_ITFDE1_tb;


architecture Behavioral of servo_pwm_clk64kHz_ITFDE1_tb is

    COMPONENT servo_pwm_clk64kHz_ITFDE1
	 
			PORT(
				CLOCK_50  : IN  STD_LOGIC;
				KEY: IN  STD_LOGIC_VECTOR(3 downto 0);
				SW  : IN  STD_LOGIC_VECTOR(7 downto 0);
				LEDR  : OUT  STD_LOGIC_VECTOR(8 downto 0);
				GPIO_1: OUT STD_LOGIC_VECTOR(3 downto 0)
    );
	 END COMPONENT;
	 
	 
	signal sCLOCK_50  : std_logic := '0';
	signal sKEY : STD_LOGIC_VECTOR(3 downto 0) := "1111";
	signal sSW  : std_logic_vector(7 downto 0) := (others => '0');
    -- Outputs.
    signal sGPIO_1 : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	 signal sLEDR  : std_logic_vector(8 downto 0) := (others => '0');
    -- Clock definition.
    constant clk_period : time := 10 ns; --A tester : mettre une clock de 12 µs = (2.5-0.5)/180 max-min/angle -> pour aller plus loin
	 constant PWM_period : time := 20 ms;
	
BEGIN 

	     -- Instance of the unit under test.
    uut: servo_pwm_clk64kHz_ITFDE1 PORT MAP (
        ClOCK_50 => sClOCK_50,
        KEY => sKEY,
        SW => sSW,
        LEDR => sLEDR,
		  GPIO_1 => sGPIO_1
    );

   -- Definition of the clock process.
   clk_process :process begin
        sClOCK_50 <= '0';
        wait for clk_period/2;
        sClOCK_50 <= '1';
        wait for clk_period/2;
   end process;
 

		 
	stimuli: process begin
        sKEY(0) <= '0'; --Reset à 1 comme not KEY dans le code
        wait for PWM_period/2; --Attendre un temps plus long et plus cohérent avec notre PWM_period
        sKEY(0) <= '1'; --Reset à 0 idem
        wait for 3*PWM_period/2; --
		  
		  sSW <= "00000010";	-- ON change la position des pos mais le PWM ne devrait pas changer car on a pas apppuyé sur le bouton
		  wait for 3*PWM_period/2; -- ON observe que le PWM ne change pas
		  
		  sKEY(1) <= '0';	-- On appuie sur le bouton 
		  wait for PWM_period/2;
		  sKEY(1) <= '1'; -- On lache le bouton -> ipos after change 
		  wait for 3*PWM_period/2; -- On attend, à la prochaine PWM_period on voit le PWM changer

        sSW <= "00101000"; --40
		  wait for 3*PWM_period/2;
		  
		  sKEY(1) <= '0';	 
		  wait for PWM_period/2;
		  sKEY(1) <= '1';
		  wait for 3*PWM_period/2;
		  
        sSW <= "01010000"; --80
		  wait for 3*PWM_period/2;
		  
		  sKEY(1) <= '0';	 
		  wait for PWM_period/2;
		  sKEY(1) <= '1';
		  wait for 3*PWM_period/2;
		  
        sSW <= "01111000";	--120
		  wait for 3*PWM_period/2;
		  
		  sKEY(1) <= '0';	 
		  wait for PWM_period/2;
		  sKEY(1) <= '1';
		  wait for 3*PWM_period/2;
		  
        sSW <= "10110100";--180
		  wait for 3*PWM_period/2;
		  
		  sKEY(1) <= '0';	 
		  wait for PWM_period/2;
		  sKEY(1) <= '1';
		  wait for 3*PWM_period/2;
        wait;
    end process;


END;