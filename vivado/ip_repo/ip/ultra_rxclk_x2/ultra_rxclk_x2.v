`timescale 1ps/1ps

module ultra_rxclk_x2 # (
      parameter real    CLKIN_PERIOD = 6.600,      // Clock period (ns) of input clock on clk
      parameter         USE_PLL      = "FALSE"    // Selects either PLL or MMCM for clocking
   )
   (
      input             clk,                    // Clock input
      input             reset,                  // Asynchronous interface reset
      //
      (* DONT_TOUCH = "yes", s="true",keep="true" *)(* mark_debug="true" *)output            rx_clk_x2,           // RX clock div2 output
      (* DONT_TOUCH = "yes", s="true",keep="true" *)(* mark_debug="true" *)output            cmt_locked           // PLL/MMCM locked output
   );

//
// Set VCO multiplier for PLL/MMCM 
//  2  - if clock_period is greater than 750 MHz/7 
//  1  - if clock period is <= 750 MHz/7  
//
// Minimum MMCM VCO frequency	800	MHz
// Maximum MMCM VCO frequency	1600	MHz
// input clock frequency 10MHz~800MHz
// input clock period 100ns ~ 1.25ns
//
// Minimum PLL VCO frequency	750	MHz
// Maximum PLL VCO frequency	1500	MHz
// input clock frequency 70MHz~800MHz 
// input clock period 14.285714286ns ~ 1.25ns
//
// VCO = CLKIN1 (/D) (*M)
// CLKOUT0 = CLKIN1 (/D) (*M) (/D0)
//
//for mmcm, assume D=1,
//elsif(400<f<800) // 1.25ns<period<2.5
//then VCO_MULTIPLIER=2
//elsif(200<f<400) // 2.5<period<5
//then VCO_MULTIPLIER=4
//elsif(100<f<200) // 5<period<10
//then VCO_MULTIPLIER=8
//elsif(50<f<100) // 10<period<20
//then VCO_MULTIPLIER=16
//
//for pll, assume D=1,
//elsif(375<f<750) // 1.333ns<period<2.666
//then VCO_MULTIPLIER=2
//elsif(187.5<f<375) // 2.666<period<5.333
//then VCO_MULTIPLIER=4
//elsif(93.75<f<187.5) // 5.333<period<10.666
//then VCO_MULTIPLIER=8
//elsif(70<f<93.75) // 10.666<period<14.286
//then VCO_MULTIPLIER=16

localparam VCO_MULTIPLIER = (USE_PLL == "FALSE") ? ((CLKIN_PERIOD > 10) ? 16 : (CLKIN_PERIOD > 5) ? 8 : (CLKIN_PERIOD > 2.5) ? 4 : (CLKIN_PERIOD > 1.25) ? 2 : 1) : ((CLKIN_PERIOD >10.666) ? 16 : (CLKIN_PERIOD > 5.333) ? 8 : (CLKIN_PERIOD > 2.666) ? 4 : (CLKIN_PERIOD > 1.333)? 2 : 1);


wire       clk_i;
wire       fb_i_pllmmcm;
wire       fb_o_pllmmcm;
wire       rx_pllmmcm_x2;

assign clk_i = clk;


//
// Instantitate a PLL or a MMCM
//
generate
if (USE_PLL == "FALSE") begin    // use an MMCM
   MMCME3_BASE # (
         .CLKIN1_PERIOD      (CLKIN_PERIOD),
         .BANDWIDTH          ("OPTIMIZED"),
         .CLKFBOUT_MULT_F    (VCO_MULTIPLIER),
         .CLKFBOUT_PHASE     (0.0),
         .CLKOUT0_DIVIDE_F   (0.5*VCO_MULTIPLIER),
         .CLKOUT0_DUTY_CYCLE (0.5),
         .CLKOUT0_PHASE      (0.0),
         .DIVCLK_DIVIDE      (1),
         .REF_JITTER1        (0.100)
      )
      rx_mmcm_adv_inst (
         .CLKFBOUT       (fb_o_pllmmcm),
         .CLKFBOUTB      (),
         .CLKOUT0        (rx_pllmmcm_x2),
         .CLKOUT0B       (),
         .CLKOUT1        (),
         .CLKOUT1B       (),
         .CLKOUT2        (),
         .CLKOUT2B       (),
         .CLKOUT3        (),
         .CLKOUT3B       (),
         .CLKOUT4        (),
         .CLKOUT5        (),
         .CLKOUT6        (),
         .LOCKED         (cmt_locked),
         .CLKFBIN        (fb_i_pllmmcm),
         .CLKIN1         (clk_i),
         .PWRDWN         (1'b0),
         .RST            (reset)
     );
   end
   else begin           // Use a PLL
   PLLE3_BASE # (
         .CLKIN_PERIOD       ((CLKIN_PERIOD>12.5)?12.5:CLKIN_PERIOD),
         .CLKFBOUT_MULT      (VCO_MULTIPLIER),
         .CLKFBOUT_PHASE     (0.0),
         .CLKOUT0_DIVIDE     (0.5*VCO_MULTIPLIER),
         .CLKOUT0_DUTY_CYCLE (0.5),
         .REF_JITTER         (0.100),
         .DIVCLK_DIVIDE      (1)
      )
      rx_plle2_adv_inst (
          .CLKFBOUT       (fb_o_pllmmcm),
          .CLKOUT0        (rx_pllmmcm_x2),
          .CLKOUT0B       (),
          .CLKOUT1        (),
          .CLKOUT1B       (),
          .CLKOUTPHY      (),
          .LOCKED         (cmt_locked),
          .CLKFBIN        (fb_i_pllmmcm),
          .CLKIN          (clk_i),
          .CLKOUTPHYEN    (1'b0),
          .PWRDWN         (1'b0),
          .RST            (reset)
      );
   end
endgenerate

//
// Global Clock Buffers
//
// ug572 CLKFBIN must be connected either directly to the CLKFBOUT for internal feedback, 
// or to the. CLKFBOUT via a BUFG for clock buffer feedback ...
BUFG  bg_px     (.I(fb_o_pllmmcm),  .O(fb_i_pllmmcm)) ;
BUFG  bg_rx_x2  (.I(rx_pllmmcm_x2), .O(rx_clk_x2)) ;

endmodule

